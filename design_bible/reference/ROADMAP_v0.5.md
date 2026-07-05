# ROADMAP_v0.5.md

# Perch v0.5 Implementation Roadmap

## Purpose

This roadmap turns the Design Bible into a practical implementation path for Perch v0.5.

The goal of v0.5 is not to build every future idea.

The goal is to create a coherent, trustworthy, usable foundation.

v0.5 should prove that Perch can give a user calm clarity over their real life without becoming bloated, noisy, or invasive.

---

## v0.5 Product Goal

Perch v0.5 should reliably answer:

1. What needs my attention today?
2. What is coming soon?
3. What did I tell Perch?
4. What does Perch know about my life?
5. Why is Perch showing me this?
6. What should I do next?

If v0.5 does this well, it succeeds.

---

## v0.5 Non-Goals

The following should not be primary v0.5 goals:

- full AI autonomy
- complex prediction
- deep financial automation
- integrations with every external service
- mobile app release
- iPhone widget
- advanced dashboards
- social features
- marketplace features
- passive income expansion features
- complex agent orchestration

These may come later.

For now, they are distractions unless they directly support clarity.

---

## Build Phases

## Phase 1 — Foundation Cleanup

### Goal

Make the existing app state understandable, stable, and aligned with the Design Bible.

### Work

- confirm repository structure
- confirm Design Bible location
- confirm AI workspace files
- remove or isolate old/demo clutter
- verify current screens and routes
- identify what is implemented vs only designed
- ensure privacy rule is included in future documentation

### Exit Criteria

- project can be explained in under 2 minutes
- no major unknown folders or mystery files
- AI_BOOT.md and PROJECT_STATE.md accurately describe current state
- Design Bible remains the architectural contract

---

## Phase 2 — Core Data Model

### Goal

Define the durable model for what Perch knows.

### Core Objects

- Basics
- Bills
- Work shifts
- People
- Captures
- Reminders
- Waiting items
- Questions
- Daily brief items
- Money facts
- User decisions
- Status/freshness markers

### Required Properties

Every meaningful item should support:

- source
- status
- created date
- updated date
- freshness
- confidence when relevant
- visibility reason when shown to user
- privacy sensitivity when relevant

### Exit Criteria

- Perch can distinguish real data from demo data
- Perch can distinguish active, done, archived, stale, and uncertain items
- Perch can explain why an item appears

---

## Phase 3 — Today Surface

### Goal

Make Today the clearest and most useful screen.

### Required Sections

- Needs Attention
- Money
- From Your Brain
- This Week
- Daily Brief
- Suggestions
- Why Am I Clear?

### Rules

Today should not be a feed.

Today should not show everything.

Today should show the smallest useful set of what matters now.

### Exit Criteria

- user can open Today and immediately understand what matters
- each visible item has a reason
- stale or uncertain information is labeled
- demo data is never confused with real data

---

## Phase 4 — Brain and Capture System

### Goal

Make Tell Perch and Brain work as the user’s memory intake and review system.

### Work

- captures can be created quickly
- captures can be classified simply
- captures can become reminders, questions, waiting items, or basics
- completed captures can be marked done
- old captures can be archived
- user-created captures can be deleted
- Brain has search and filtering

### Exit Criteria

- Tell Perch feels fast
- Brain feels organized
- user does not need to understand the database
- Perch can surface relevant Brain items on Today

---

## Phase 5 — Money Flow v0.5

### Goal

Create useful, limited financial clarity without pretending to be a full finance platform.

### Work

- checking balance
- payday
- bills before payday
- manual/autopay status
- paid/pulled/skipped states
- basic cash pressure warnings
- explanation of why money appears safe or unsafe

### Rules

Money Flow must be conservative.

If data is incomplete, Perch must say so.

Perch must never imply certainty it does not have.

### Exit Criteria

- user understands money risk before payday
- Perch avoids false precision
- manual updates are easy
- privacy is respected

---

## Phase 6 — Explanation Layer

### Goal

Every important Perch answer should be explainable.

### Work

- “Why am I clear?”
- “Why is this shown?”
- stale data warnings
- missing data prompts
- confidence labels
- demo data labels

### Exit Criteria

- user can trust what Perch shows
- uncertainty is visible
- Perch feels honest, not magical

---

## Phase 7 — v0.5 Stabilization

### Goal

Prepare Perch for serious daily use.

### Work

- clean sample data flow
- real-life onboarding checklist
- empty states
- delete/archive safety
- bug pass
- documentation pass
- update PROJECT_STATE.md
- update AI_BOOT.md
- update ARCHITECTURAL_DEBT.md

### Exit Criteria

- user can start from empty state
- user can understand sample state
- user can switch to real-life state
- no known critical architectural debt blocks v0.5
- repository matches documented reality

---

## v0.5 Success Standard

Perch v0.5 is successful when a user can say:

> I opened Perch and quickly understood what needs my attention, what is coming soon, what I already told it, and why it thinks I am okay or not okay.

That is enough.

Do not expand the goal until that works beautifully.

---

## Recommended Build Order

1. Documentation sync
2. Data model cleanup
3. Today screen clarity
4. Brain/capture reliability
5. Money Flow v0.5
6. Explanation layer
7. Demo-to-real onboarding
8. Stabilization
9. v0.5 release candidate

---

## Deferred Until After v0.5

- mobile app
- iPhone widgets
- automatic external integrations
- advanced AI recommendations
- complex financial forecasting
- multi-user households
- passive income modules
- marketplace/business features
- fully automated scheduling
- advanced notification system

---

## Closing Direction

v0.5 should feel small, sharp, calm, and useful.

Do not build the impressive version first.

Build the version that earns trust.
