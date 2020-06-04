+++
draft = true
+++

## Repository

A class that encapsulates the data **persistence for an aggregate root**.

## Domain Events

A class that captures the occurance of an event in a domain object.

The name of an event should be **part of the ubiquitous language**. In fact, the **stackeholder should understand what the event is about, when reading the** name. Events should be very business releated, not techical events.

Such an event describes the past, something that is completed.

Events can cross layers, for instance an event issued in the core layer can also be catched by the UI layer (e.g. to show a notification).

When events need to cross domain boundaries, translate the event into a special cross-domain event type and raise that to external domains. (Internal) domain events should not be propagates to other domains since the information transported by the event does only make sense within the domain. Cross-domain event encapsulate possibly more or different information to make sense to other domains.

## Hollywood Principle

> Don't call use, we'll call you.

Use domain events to decouple features from the bare business code. E.g. when creating an appointment, sending an email confirmation is not part of the core logic. The core logic could emit a `AppointmentCreated` event that is received by an `AppointmentNotificationService` which might send the email.

## Anti-Corruption Layer

A layer that insulates a bounded context and handles interaction with foreign systems or contexts.

It mainly has to adopt, translate and validate.
