+++
title = "Domain Driven Design"
tags = [
    "domain",
    "ddd",
]
draft = true
+++

## Aggregate
An aggregate is a logical group of entities. It represents a cohesive notion of the domain model.

It must have a single [aggregate root](#aggregate-root) entity that is the main entity of the aggregate. Single entity aggregates are also valid, this entity must be the aggregate root then. Most aggregates consist of 1 or 2 entities.

An entity can only belong to a single aggregate. This is in contrast to value objects, they can belong to multiple aggregates.

The application layer should deal with aggregates rather than individual entities, e.g. fetching and storing complete aggregates.

### Aggregate Root
The *main/entry* entity of an aggregate. The aggregate is represented by its aggregate root. Only the aggregate root is referenced by other entities outside of the aggregate.

If possible/feasible, the aggregate root should not expose internal entities of the same aggregate to the outside, but rather allow interaction with them through the aggregate root only.

The aggregate root is responsible to enforce the [invariants](#invariant) of the aggregate.

### Aggregate Boundaries
The process of defining which entities belong together and form an aggregate is crucial. The boundaries of an aggregate must be thought out. An entity can only belong to a single aggregate (value objects can belong to multiple).

An entity should belong to an aggregate if the entity does not make sense without the context of the aggregate.

When defining the boundaries, keep in mind that an aggregate is supposed to be fetched and persisted as a single unit. Thus, if there is a relationship within an aggregate with a large number of elements, all those elements must be fetched whenever the aggregate is fetched, and persisted whenever the aggregate is persisted. It might make sense to not include certain entities as part of an aggregate to reduce overhead and complexity.

> Example: Let's assume we model a Todo list that consists of the list entity itself, its entries, and users that can be assigned to entries. \
The list itself becomes the aggregate root and the entry entity is part of that aggregate. An entry entity without the list does not make sense. \
The user entity would form its own aggregate, thus, is not part of the todo list aggregate. A user entity makes sense also without the context of a todo list. In this example, the user entity would be the aggregate root of an aggregate that consists only of one entity.

### Invariant
(Data) validation performed on an [aggregate](#aggregate) and its [entities](#entity). It is the responsibility of the [aggregate root](#aggregate-root) to enforce these rules.

## Entity
Interrelated values of interest in a specific domain of knowledge.

> Example: An address consists of at least a street, house number, zip code, and city. The house number alone does not make any sense. Combined, all these values describe a precise address and can be treated as an *address* entity.

## Repository
A class that encapsulates the data **persistence for an [aggregate](#aggregate)**. It should not work on individual entities of an aggregate but rather on the aggregate as a whole.

In general, there should be one repository per aggregate.

## Domain Events
An instance of a special class that captures the occurrence of an event.

The name of an event should be **part of the ubiquitous language**. A **stakeholder should understand what the event is about when reading its name**. Events should be business related, not technical.

Such an event describes the past, something that is completed.

Events can cross layers, for instance, an event issued in the core layer can also be caught by the UI layer (e.g. to show a notification).

When events need to cross-domain boundaries, translate the event into a special cross-domain event type, and raise that to external domains. (Internal) domain events should not be propagated to other domains since the information transported by the event does only make sense within the domain. Cross-domain events encapsulate possibly more or different information to make sense to other domains.

## Hollywood Principle
"Don't call use, we'll call you." - Use domain events to decouple features from the business code. 

> Example: When creating an appointment, sending an email confirmation is not part of the core logic. The core logic could emit an `AppointmentCreated` event that is received by an `AppointmentNotificationService` which might send the email.

## Anti-Corruption Layer
A layer that insulates a bounded context and handles interaction with foreign systems or contexts.

It mainly has to adapt, translate, and validate.

## Ubiquitous Language
A common and shared (domain) language that is must be established between the domain experts and developers. Domain-specific terms must be understood by both the domain experts and developers, therefore, it is important to agree on a set of terms and their meaning within a context/domain.

Elements (e.g. events, classes) in this domain should be called by their meaning. The naming should not be implementation-specific.