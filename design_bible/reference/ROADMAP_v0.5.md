# ROADMAP_v0.5.md

# Perch v0.5 Implementation Roadmap

## Purpose

This roadmap turns the current Design Bible into a practical implementation path for Perch v0.5.

v0.5 is not the full Atlas.

v0.5 is the first trustworthy, coherent, daily-usable version of Perch.

The goal is to prove that Perch can create calm clarity without becoming bloated, noisy, invasive, or falsely intelligent.

---

## v0.5 Product Goal

Perch v0.5 should reliably answer:

1. What deserves my attention today?
2. Where do I stand financially within the data Perch actually has?
3. What is coming soon?
4. What did I tell Perch?
5. What does Perch know, not know, or only partly know?
6. Why is Perch showing me this?
7. What action is worth considering next?

If v0.5 does this clearly, honestly, and beautifully, it succeeds.

---

## Canonical Atlas Direction

The current Design Bible supports this Atlas direction:

- Today
- Money
- Calendar & Obligations
- Goals
- Projects
- Brain
- Knowledge & Search
- Home & Property
- People & Relationships *(planned)*
- Health *(planned)*
- Notifications *(planned)*
- Settings *(planned)*

Today is the home screen, but it is not the whole product.

Each page answers one primary question.

The engines provide shared intelligence across pages.

---

## v0.5 Non-Goals

The following are not primary v0.5 goals:

- full AI autonomy
- complex prediction
- deep financial automation
- external integrations
- banking/Plaid/Tiller sync
- Gmail/email ingestion
- Google/Apple Calendar sync
- weather integration
- mobile app release
- iPhone widget
- semantic/vector search
- knowledge graph
- multi-user households
- marketplace/business features
- complex agent orchestration

These may come later.

For v0.5, they are distractions unless they directly support trustworthy clarity.

---

## v0.5 Build Phases

## Phase 1 — Documentation Sync

### Goal

Ensure the repository, Design Bible, AI workspace, and reference documents all describe the same product.

### Work

- replace stale Master Index
- replace stale Architectural Debt register
- replace stale Roadmap
- update ADR-005 for current Atlas model
- add `docs/README.md` to mark old docs as supporting/historical
- confirm `PROJECT_STATE.md` matches chapter reality

### Exit Criteria

- no active reference file describes old chapter names as current
- Atlas navigation has one canonical model
- Design Bible remains the architectural contract
- AI workspace does not become a second architecture bible

---

## Phase 2 — Atlas Shell

### Goal

Create a clean shell that can support the current Atlas without pretending every page is fully built.

### Work

- define the canonical navigation surface
- show only pages that are real enough to expose
- mark planned pages clearly if surfaced
- ensure Today remains the entry point
- ensure every page answers one primary question
- avoid tab sprawl by grouping or progressive disclosure if needed

### Exit Criteria

- user can understand the app structure quickly
- Today is clearly home
- Money, Calendar, Goals, Brain, Knowledge/Search, and Home/Property have obvious conceptual homes
- planned pages are not mistaken for built pages

---

## Phase 3 — Core Data Model Baseline

### Goal

Define the minimum durable model for what Perch knows.

### Core Objects

- facts
- derived facts
- interpretations
- recommendations
- captures
- obligations
- bills
- work shifts
- people
- goals
- projects
- properties
- homestead items
- knowledge records
- freshness/status markers
- source lineage

### Required Properties

Every meaningful item should support:

- source
- status
- created date
- updated date
- freshness
- confidence when relevant
- visibility reason when shown to the user
- privacy sensitivity when relevant
- demo vs real distinction

### Exit Criteria

- Perch can distinguish real data from demo data
- Perch can distinguish active, done, archived, stale, and uncertain items
- Perch can explain why an item appears
- Perch can show where important claims came from

---

## Phase 4 — Truth / Priority / Recommendation Baseline

### Goal

Make Perch's reasoning chain understandable before making it more powerful.

### Work

- document what Truth currently gates and does not gate
- identify existing priority scorers
- choose the canonical priority path for v0.5
- keep recommendations evidence-backed
- require explanations for meaningful recommendations
- avoid cross-domain prediction unless evidence is clear

### Exit Criteria

- Perch does not imply a unified engine exists where it does not
- top items are ranked by a known path
- recommendations expose evidence and confidence
- pages present truth instead of inventing logic locally

---

## Phase 5 — Today v0.5

### Goal

Make Today the clearest and most trustworthy entry point.

### Required Behavior

Today should show:

- one opening orientation statement
- what needs attention
- what is safe to ignore
- money risk within known data limits
- coming obligations
- relevant Brain items
- one useful next action when evidence supports it
- why Perch thinks the user is clear or not clear

### Rules

Today should not be a feed.

Today should not show everything.

Today should show the smallest useful set of what matters now.

### Exit Criteria

- user can open Today and immediately understand what matters
- each important item has a reason
- stale or uncertain information is labeled
- demo data is never confused with real data

---

## Phase 6 — Brain and Capture v0.5

### Goal

Make Tell Perch and Brain reliable as the user's memory intake and review system.

### Work

- captures can be created quickly
- captures can be classified simply
- captures can become reminders, questions, waiting items, obligations, goals, projects, or basics when appropriate
- completed captures can be marked done
- old captures can be archived
- user-created captures can be deleted
- Brain has useful search/filtering within current limits

### Exit Criteria

- Tell Perch feels fast
- Brain feels organized
- user does not need to understand the database
- Perch can surface relevant Brain items on Today
- search limitations are honest

---

## Phase 7 — Money v0.5

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
- fix biweekly payday imprecision before relying on Money as a standalone page

### Rules

Money must be conservative.

If data is incomplete, Perch must say so.

Perch must never imply certainty it does not have.

Every money figure needs source lineage.

### Exit Criteria

- user understands money risk before payday
- Perch avoids false precision
- manual updates are easy
- privacy is respected
- no standalone Money page ships with known date/math trust bugs

---

## Phase 8 — Calendar / Obligations v0.5

### Goal

Make time and obligations visible without becoming a full calendar app.

### Work

- today / next few days horizon
- overdue items
- upcoming bills
- work shifts
- waiting items
- no fake external calendar sync
- recurrence limitations stated honestly

### Exit Criteria

- user understands what is coming soon
- Perch does not invent dates
- recurring logic is either reliable or clearly limited

---

## Phase 9 — Goals / Projects / Home Boundary

### Goal

Prevent goals, projects, and home maintenance from becoming three competing task systems.

### Work

- define minimum shared task/project structure
- decide how homestead maintenance relates to Projects
- decide how goals connect to projects
- prevent duplicate stores for the same user intent

### Exit Criteria

- a maintenance chore, project task, and goal milestone have clear boundaries
- Home & Property does not invent a separate project system
- Goals can drive priority without becoming noisy

---

## Phase 10 — Knowledge & Search Baseline

### Goal

Make current knowledge searchable enough for v0.5 while honestly deferring semantic search.

### Work

- define what stores are searched
- unify search entry points where practical
- label search limitations
- avoid claims of semantic memory or knowledge graph

### Exit Criteria

- user can find captures/questions/basic known information
- search does not pretend to reach stores it does not reach
- future semantic search has a clear path

---

## Phase 11 — Explanation Layer

### Goal

Every important Perch answer should be explainable.

### Work

- “Why am I clear?”
- “Why is this shown?”
- stale data warnings
- missing data prompts
- confidence labels
- demo data labels
- source lineage where meaningful

### Exit Criteria

- user can trust what Perch shows
- uncertainty is visible
- Perch feels honest, not magical

---

## Phase 12 — v0.5 Stabilization

### Goal

Prepare Perch for serious daily use.

### Work

- clean sample data flow
- real-life onboarding checklist
- empty states
- delete/archive safety
- bug pass
- documentation pass
- update `PROJECT_STATE.md`
- update `AI_BOOT.md` only if AI workflow changed
- update `ARCHITECTURAL_DEBT.md`

### Exit Criteria

- user can start from empty state
- user can understand sample state
- user can switch to real-life state
- no known critical architectural debt blocks v0.5
- repository matches documented reality

---

## Recommended Build Order

1. Documentation sync
2. Atlas shell / navigation authority
3. Core data model baseline
4. Truth / Priority / Recommendation baseline
5. Today v0.5
6. Brain / Capture v0.5
7. Money v0.5
8. Calendar / Obligations v0.5
9. Goals / Projects / Home boundary
10. Knowledge & Search baseline
11. Explanation layer
12. Demo-to-real onboarding
13. Stabilization
14. v0.5 release candidate

---

## Deferred Until After v0.5

- mobile app
- iPhone widgets
- external integrations
- banking/Plaid/Tiller sync
- email intelligence
- weather-powered recommendations
- semantic search
- vector database
- knowledge graph
- complex financial forecasting
- multi-user households
- fully automated scheduling
- advanced notification system
- business/marketplace/passive-income modules

---

## v0.5 Success Standard

Perch v0.5 is successful when a user can say:

> I opened Perch and quickly understood what needs my attention, what is coming soon, where I stand within the data Perch actually has, what I already told it, and why Perch thinks I am okay or not okay.

That is enough.

Do not expand the goal until that works beautifully.

---

## Closing Direction

v0.5 should feel small, sharp, calm, and useful.

Do not build the impressive version first.

Build the version that earns trust.
