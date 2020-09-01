+++
title = "Domain Driven Design"
tags = [
    "domain",
    "ddd",
]
draft = true
+++

## Aggregate
An aggregate is a logical group of entities. It must have a single [aggregate root](#aggregate-root) entity that is the main entity of the aggregate.

An entity can only belong to a single aggregate. This is in contrast to value objects, they can be long to multiple aggregates.

The application layer should deal with aggregates rather than individual entities. 

## Aggregate Root
The *main/entry* entity of an aggregate. The aggregate is represented by its aggregate root. It is referenced by other entities outside of the aggregate. Indeed, references from the outside of the aggregate should only reference the aggregate route, not other entities (inside) of the aggregate.

The aggregate root is responsible to enforce the [invariants](#invariant) of the aggregate.

## Entity
Interrelated values of interest in a specific domain of knowledge.

> Example: An address consists of at least a street, house number, zip code, and city. The house number alone does not make any sense. Combined, all these values describe a precise address and can be treated as an *address* entity.

## Invariant
(Data) validation performed on an [aggregate](#aggregate) and its [entities](#entity). It is the responsibility of the [aggregate root](#aggregate-root) to enforce these rules.

## Repository
A class that encapsulates the data **persistence for an [aggregate root](#aggregate-root)**.

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
