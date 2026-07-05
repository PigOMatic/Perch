# The Perch Design Bible

*The authoritative guide for what Perch must become.*

**Version:** v1.0 Architecture Baseline  
**Locked:** July 5, 2026  
**Authority:** Design Bible defines destination; repository code defines current implementation.

---

## What this is

An encyclopedia explains what is. A design bible explains what a product must become.

This document describes the finished Perch product architecture and its current maturity honestly. Systems that do not yet exist in code may appear here first, but they must be marked by status, confidence, dependencies, and implementation reality.

> The Bible is the destination. The repository is the journey.

---

## The three layers

### Layer 1 — Vision

The mission and philosophy. Changes rarely.

- *Clarity, presented beautifully.*
- Perch is a Life Operating System.
- The Atlas: every domain answers one primary question.
- The Living World: clarity is presented inside a place.

### Layer 2 — Product Specification

The Design Bible. It defines what every domain, page, and engine must become.

### Layer 3 — Repository

The current code. Nothing more. Implementation status is recorded honestly inside chapters.

---

## Status system

| Status | Meaning |
|---|---|
| **Concept** | Believed product direction; not specified or built deeply enough yet. |
| **Planning** | Being specified now; behavior is defined enough to guide work. |
| **Prototype** | Partially built or spiked; not production-complete. |
| **Implemented** | Shipped and working in the repository today. |

Every major claim should carry enough source, confidence, and implementation context to avoid false certainty.

---

## The Atlas — v1.0 chapter index

Every Atlas chapter answers one primary question. Status reflects the chapter's current maturity in the Design Bible and repository.

| # | Chapter | Primary question | Status | Bible file |
|---|---|---|---|---|
| 1 | Today | What deserves my attention today? | Prototype | `chapters/01-today.md` |
| 2 | Money | Where do I stand financially, and what changed? | Concept / Partial | `chapters/02-money.md` |
| 3 | Calendar & Obligations | What's coming, and what do I owe? | Prototype | `chapters/03-calendar-obligations.md` |
| 4 | Goals | Am I building the life I want? | Prototype | `chapters/04-goals.md` |
| 5 | Projects | What am I in the middle of building? | Concept | `chapters/05-projects.md` |
| 6 | Brain | What am I carrying? | Prototype | `chapters/06-brain.md` |
| 7 | Truth Engine | What is Perch allowed to say? | Prototype | `chapters/07-truth-engine.md` |
| 8 | Priority Engine | What deserves attention? | Prototype | `chapters/08-priority-engine.md` |
| 9 | Recommendation Engine | What should Perch suggest? | Prototype | `chapters/09-recommendation-engine.md` |
| 10 | Living World | What place does clarity live inside? | Concept | `chapters/10-living-world.md` |
| 11 | Voice Engine | How should Perch say it? | Prototype | `chapters/11-voice-engine.md` |
| 12 | Knowledge & Search | What does Perch know, and how can the user find it? | Prototype | `chapters/12-knowledge-search.md` |
| 13 | Integrations | How does Perch safely ingest outside data? | Concept | `chapters/13-integrations.md` |
| 14 | Home & Property | What do I own, and what needs care? | Prototype | `chapters/14-home-property.md` |
| 15 | People | Who matters, what matters about them, and what should I know right now? | Concept | `chapters/15-people.md` |
| 16 | Home | What is happening in my physical world? | Concept | `chapters/16-home.md` |
| 17 | Knowledge | What does Perch know that can help me? | Concept | `chapters/17-knowledge.md` |
| 18 | Search | How do I instantly find anything across Perch? | Concept | `chapters/18-search.md` |
| 19 | Atlas | How does every domain work together as one Life OS? | Concept | `chapters/19-atlas.md` |

---

## Engine index

| Engine | Purpose | Status | Bible file / repo reference |
|---|---|---|---|
| Truth Engine | Determines what Perch is allowed to say | Prototype | `chapters/07-truth-engine.md`, `perch_truth.md`, `perch_beliefs.js` |
| Belief Engine | Forms and ages beliefs from evidence | Prototype | `perch_beliefs.js` |
| Priority Engine | Decides what deserves attention | Prototype | `chapters/08-priority-engine.md`, `perch_engine.js` |
| Recommendation Engine | Suggests actions | Prototype | `chapters/09-recommendation-engine.md`, `perch_engine.js` |
| Voice Engine | Chooses wording | Prototype | `chapters/11-voice-engine.md`, `perch_voice.js` |
| Learning Engine | Captures personal context | Implemented / Prototype boundary | `perch_learn.js` |
| Living World | Presents clarity as a place | Concept | `chapters/10-living-world.md`, `perch_world.md` |
| Integrations | Imports outside data safely | Concept | `chapters/13-integrations.md` |

---

## Global law: statement classification

Every sentence Perch shows is one of five kinds.

| Class | What it is | Must expose |
|---|---|---|
| **Fact** | Directly stored or observed | Source |
| **Derived Fact** | Arithmetic over facts | Inputs |
| **Interpretation** | Judgment from facts | Reasoning |
| **Recommendation** | Suggested action | Reasoning + evidence |
| **Prediction** | Claim about the future | Assumptions + uncertainty |

A chapter that presents an Interpretation, Recommendation, or Prediction as a Fact has failed.

---

## Global law: source lineage

Every figure Perch shows must be able to answer:

> Where did this come from?

If a figure cannot produce lineage, it does not ship.

---

## Global law: trust rule

> **Perch never invents certainty.**

When sources disagree, Perch shows the disagreement, explains it, and does not silently choose one.

---

## Authoring rules

1. Every feature must have a home.
2. Every feature has a permanent ID.
3. Status comes before detail.
4. Data gaps are named, not hidden.
5. Chapters mature; they do not vanish.
6. The Design Bible wins over quick implementation unless the Bible is deliberately updated first.

---

## v1.0 lock status

The Design Bible is locked as a **v1.0 architecture baseline**, not as a claim that every chapter is equally implemented or equally deep.

See:

- `V1_LOCK.md`
- `CHANGELOG.md`
- `chapters/_TEMPLATE.md`

---

*Perch Design Bible · v1.0 Architecture Baseline · locked July 5, 2026.*
