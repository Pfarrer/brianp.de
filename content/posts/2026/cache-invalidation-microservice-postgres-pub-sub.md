+++
title = "In-Memory Cache Invalidation in Distributed Spring Services Using Postgres Pub/Sub"
date = "2026-05-12"
tags = [
    "cache",
    "microservice",
    "spring",
    "postgres",
]
+++

Microservices typically run multiple instances in parallel. When a cache is required to improve performance for certain use cases, a simple in-memory cache offers significant gains without the need for additional infrastructure, such as a Redis instance.

Cache invalidation is a major downside of having an individual in-memory cache for each microservice instance. When cached data changes, all instances must invalidate or update their caches. Otherwise, an instance may continue using outdated data.

<!--more-->

With a shared external cache, such as Redis, all microservice instances use the same source of truth. In contrast, each microservice needs a notification to synchronize its individual cache when data is updated. The challenge is how to notify all microservices without introducing another infrastructure service.

## Idea

Given that the microservices already use a Postgres database, its built-in [Listen/Notify](https://www.postgresql.org/docs/current/sql-notify.html) (aka Pub/Sub) feature can be used to synchronize all instances.

When the cached data is also stored in Postgres, this approach makes even more sense. With a trigger in place, Postgres automatically sends notifications to all listening services when data changes. Any microservice instance—or even an external Postgres connection—can change Postgres records, and all services will evict their affected in-memory caches without any additional steps.

## Example Code

Two components are required to get this to work. On one hand, Postgres must send notifications using `pg_notify`. Ideally, change notifications are sent automatically on any insert, update, or delete on particular tables.

On the other hand, each microservice instance must listen for notifications on the same channel.

### Listen for Notifications in Spring

The code omits some checks and logging for brevity.

```kotlin
const val NOTIFICATIONS_CHANNEL = "change_notifications"
const val NOTIFICATION_POLL_TIMEOUT = 1000

@Component
class PostgresNotificationListener(
    private val dataSource: DataSource,
    private val notificationParser: PostgresNotificationParser,
    private val eventPublisher: ApplicationEventPublisher,
) {

    @Async
    @EventListener(ApplicationReadyEvent::class)
    fun listenForNotifications() {
        dataSource.connection.use { connection ->
            val pgConnection = connection.unwrap(PGConnection::class.java)

            connection.createStatement().use {
                it.execute("LISTEN $NOTIFICATIONS_CHANNEL")
            }

            while (!Thread.currentThread().isInterrupted) {
                pgConnection.getNotifications(NOTIFICATION_POLL_TIMEOUT)
                    ?.mapNotNull(notificationParser::mapFromParameter)
                    ?.forEach(eventPublisher::publishEvent)
            }
        }
    }
}
```

`PostgresNotificationParser` is a class that takes the notification message payload, parses it, and maps it to an internal application event. That event is then published within the Spring `ApplicationContext`. In this example, such an event could be of type `SettingsChanged`.

Since the listener waits for notifications in a loop, it should run asynchronously. The example above uses `@Async`, which requires async execution to be enabled in the Spring application.

### Spring Cache Eviction

```kotlin
@Service
class SettingsService {
    [...]
    
    @CacheEvict(cacheNames = [SETTINGS_CACHE_NAME], allEntries = true)
    @EventListener
    internal fun onSettingsChanged(event: SettingsChanged) {
        logger.info("Received SettingsChanged. Performing cache eviction.")
    }
}
```

### Postgres Change Detection and Notifications

To publish change notifications automatically on inserts, updates, or deletes in a particular table, a function must be created that can be called from a trigger. The trigger associates the function with a single table and specifies which changes will cause it to execute.

```sql
CREATE OR REPLACE FUNCTION notify_on_change()
    RETURNS TRIGGER AS $$
BEGIN
    PERFORM pg_notify('change_notifications', TG_TABLE_SCHEMA || '/' || TG_TABLE_NAME);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER settings_notification_trigger
    AFTER INSERT OR UPDATE OR DELETE ON settings
    FOR EACH ROW
EXECUTE FUNCTION notify_on_change();
```

Notifications can also be sent programmatically, by running a simple query like this. This approach is not limited to events originating in Postgres. Each microservice instance could trigger such an event at any time.

```sql
SELECT pg_notify('change_notifications', '[message-payload]');
```

> This idea was inspired by [You Don't Need Redis, Postgres Already Has Pub/Sub](https://www.prisma.io/blog/you-dont-need-redis-postgres-already-has-pub-sub).

<hr/>

*Disclaimer: AI helped me phrase this post. The idea and content are entirely my own.*
