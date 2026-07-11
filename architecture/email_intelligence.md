# Perch Email Intelligence

## Purpose

Perch Email Intelligence converts selected email messages into small, useful, source-linked facts that can support Today, Projects, Money, Travel, Family, Work, and Brain.

It is not intended to become another inbox. Perch should surface only what is useful now or likely to become useful later.

## Core principle

Email is evidence, not truth.

Perch may extract a candidate fact from an email, but it must preserve the source, confidence, timestamp, and review status. Important actions should remain confirmable by the user.

## Permission model

Email access must be explicit and revocable.

Recommended permission levels:

1. Off
2. Manual scan only
3. Selected labels or senders
4. Relevant-mail scan
5. Continuous background relevance scan

Perch should default to the narrowest permission that still satisfies the user's request.

## Processing pipeline

1. Retrieve message metadata and body from the approved mailbox scope.
2. Classify the message category.
3. Extract candidate facts and dates.
4. Score current relevance.
5. Match facts to known projects, people, places, accounts, trips, and responsibilities.
6. Generate a proposed Perch action.
7. Preserve a source link to the original email.
8. Require confirmation when confidence or consequence warrants it.
9. Re-score later as time and context change.

## Candidate categories

- Bill, payment, refund, renewal, subscription, or account notice
- Appointment, reservation, event, deadline, or schedule change
- Travel booking, campground, ticket, lodging, route, or cancellation
- School, family, medical, childcare, or activity notice
- Work schedule, credential, training, payroll, or benefits notice
- Delivery, order, return, warranty, or service appointment
- Project update, approval, decision, blocker, or requested follow-up
- Security, fraud, identity, password, or account-access warning
- Newsletter or informational reference worth saving
- Noise, promotion, duplicate, or irrelevant message

## Relevance is dynamic

A message may be irrelevant today and highly relevant later.

Examples:

- A campground reservation becomes highly relevant near the trip.
- A warranty email becomes relevant when an appliance fails.
- A school calendar becomes relevant when planning the next week.
- A bill becomes more urgent as its due date approaches.

Relevance should be recomputed from:

- Time until or since the event
- Consequence of missing it
- Match to an active project
- Match to current location or travel
- Sender trust and prior usefulness
- Whether the user has acted
- Whether newer email supersedes it
- Whether the fact is already known elsewhere
- Current user mode, energy, and available time

## Relevance dimensions

Each signal should retain separate scores instead of one unexplained number:

- Urgency
- Importance
- Confidence
- Actionability
- Project match
- Personal context match
- Freshness
- Consequence
- User-interest history

Perch may calculate a display priority, but the dimensions must remain inspectable.

## Suggested actions

Email-derived facts may propose:

- Add to Today
- Attach to a project
- Create or update a milestone
- Add a calendar event
- Add a due date or reminder
- Add a booking or travel record
- Add a bill or renewal
- Save as reference
- Ask the user a clarifying question
- Ignore or archive the signal

Perch should not silently send email, pay bills, cancel reservations, or modify external systems.

## Project Assessor integration

Email signals should influence project assessment when they provide evidence of:

- A new deadline
- A completed milestone
- A blocker
- An approval
- A required decision
- A cost or payment
- A waiting dependency
- A cancellation or schedule change

Example:

A Visual Studio installation receipt should not create a new project. It can update the existing "Perch home development setup" project with evidence that software acquisition is complete.

## Deduplication and supersession

Perch should detect:

- Multiple messages in the same thread
- Repeated reminders for one event
- Updated reservations or changed appointment times
- Receipts that confirm earlier order messages
- Cancellation messages that invalidate previous facts

The latest authoritative fact should be active while earlier facts remain traceable.

## Storage policy

Prefer storing:

- Extracted fact
- Short supporting excerpt
- Sender
- Subject
- Received time
- Source message identifier or deep link
- Confidence and relevance scores
- Project or entity matches
- User decision and audit history

Avoid storing full message bodies by default.

Sensitive content should have stricter retention controls.

## Privacy and safety

- No email processing without user authorization
- Clear mailbox and label scope
- Revocable connection
- Visible audit trail
- Source-linked facts
- Confirmation for consequential actions
- No model training use implied by Perch
- Minimize stored message content
- Allow deletion of imported signals and derived facts

## First implementation slice

The first useful version should:

1. Read a manually requested Gmail search result.
2. Extract dates, money amounts, bookings, tasks, and deadlines.
3. Show candidate signals in a review list.
4. Let the user attach a signal to an existing project or Today.
5. Save the source link and confidence.
6. Re-score signals as due dates approach.

Continuous background scanning should come only after the manual review flow is trusted.

## Future desk representation

The desk should not show an inbox badge for every message.

Potential representations:

- A sealed envelope when meaningful new signals exist
- A small stack of correspondence when several need review
- No object change when email contains nothing relevant
- Opening the envelope reveals only distilled candidate facts, not the full inbox

This keeps Perch calm while still making email useful.
