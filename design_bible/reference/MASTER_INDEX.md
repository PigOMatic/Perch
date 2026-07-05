# MASTER_INDEX.md

# Perch Design Bible Master Index

## Purpose

This index is the map of the Perch Design Bible.

The Design Bible is the architectural contract for what Perch must become.

The repository is the implementation source of truth for what Perch currently is.

This document must stay aligned with the actual files in `design_bible/`.

---

## Design Bible Structure

```text
design_bible/
├── governance/     # Permanent principles
├── reference/      # Living architecture references
├── decisions/      # Architecture Decision Records
└── chapters/       # Product and engine specifications
```

---

## Governance Documents

| Document | Location | Purpose | Status |
|---|---|---|---|
| Constitution | `design_bible/governance/CONSTITUTION.md` | Permanent governing rules for Perch. | Active |
| Perch Philosophy | `design_bible/governance/PERCH_PHILOSOPHY.md` | Product soul, emotional target, and design values. | Active |

Governance documents should change rarely.

---

## Reference Documents

| Document | Location | Purpose | Status |
|---|---|---|---|
| Master Index | `design_bible/reference/MASTER_INDEX.md` | Maps the Design Bible. | Active |
| Architectural Debt | `design_bible/reference/ARCHITECTURAL_DEBT.md` | Tracks known structural weaknesses. | Active |
| v0.5 Roadmap | `design_bible/reference/ROADMAP_v0.5.md` | Defines the practical path to v0.5. | Active |

Reference documents are living documents and should be updated as architecture changes.

---

## Decision Records

| Document | Location | Purpose | Status |
|---|---|---|---|
| ADR Template | `design_bible/decisions/ADR_TEMPLATE.md` | Template for future architecture decisions. | Active |
| ADR-001 | `design_bible/decisions/ADR-001-Design-Bible-Authority.md` | Design Bible authority. | Accepted |
| ADR-002 | `design_bible/decisions/ADR-002-Privacy-by-Default.md` | Privacy by default. | Accepted |
| ADR-003 | `design_bible/decisions/ADR-003-Clarity-Over-Feature-Count.md` | Clarity over feature count. | Accepted |
| ADR-004 | `design_bible/decisions/ADR-004-Explainability-Before-Intelligence.md` | Explainability before intelligence. | Accepted |
| ADR-005 | `design_bible/decisions/ADR-005-Today-Is-the-Home-Screen.md` | Today as the home screen. | Accepted |

---

## Product / Atlas Chapters

| # | Chapter | File | Primary Question | Current Status |
|---|---|---|---|---|
| 01 | Today | `design_bible/chapters/01-today.md` | What deserves my attention today? | Prototype |
| 02 | Money | `design_bible/chapters/02-money.md` | Where do I stand financially, and what changed? | Concept / Partial implementation elsewhere |
| 03 | Calendar & Obligations | `design_bible/chapters/03-calendar-obligations.md` | What's coming, and what do I owe or am owed? | Prototype |
| 04 | Goals | `design_bible/chapters/04-goals.md` | Am I building the life I want? | Prototype |
| 05 | Projects | `design_bible/chapters/05-projects.md` | What am I in the middle of building? | Concept |
| 06 | Brain | `design_bible/chapters/06-brain.md` | What am I carrying? | Prototype |
| 12 | Knowledge & Search | `design_bible/chapters/12-knowledge-search.md` | What am I learning, and what do I want to know? | Prototype |
| 14 | Home & Property | `design_bible/chapters/14-home-property.md` | What do I own, and what needs care? | Prototype |

---

## Engine / System Chapters

| # | Chapter | File | Purpose | Current Status |
|---|---|---|---|---|
| 07 | Truth Engine | `design_bible/chapters/07-truth-engine.md` | Defines what Perch is allowed to say. | Prototype |
| 08 | Priority Engine | `design_bible/chapters/08-priority-engine.md` | Determines what deserves attention. | Prototype |
| 09 | Recommendation Engine | `design_bible/chapters/09-recommendation-engine.md` | Determines what action is worth suggesting. | Prototype |
| 10 | Living World | `design_bible/chapters/10-living-world.md` | Defines the ambient world where clarity is presented. | Concept |
| 11 | Voice Engine | `design_bible/chapters/11-voice-engine.md` | Defines how Perch speaks. | Prototype |
| 13 | Integrations | `design_bible/chapters/13-integrations.md` | Defines future external data ingestion. | Concept |

---

## Planned Future Chapters

These are listed in `PROJECT_STATE.md` as upcoming or expected future chapters:

| Planned Chapter | Expected Purpose | Status |
|---|---|---|
| People & Relationships | Who matters right now? | Planned |
| Health | What should I know about health-related life context? | Planned |
| Learning | What is Perch learning from the user over time? | Planned |
| Notifications | What should interrupt the user, and when? | Planned |
| Settings | What can the user control? | Planned |
| Security & Privacy | How is sensitive data protected? | Planned |

---

## Operational AI Documents

These are not Design Bible documents, but they must remain aligned with it.

| Document | Location | Purpose | Status |
|---|---|---|---|
| AI Boot | `perch_ai_workspace/AI_BOOT.md` | Stable starting context for AI agents. | Active |
| Project State | `perch_ai_workspace/PROJECT_STATE.md` | Current working state of Perch. | Active |
| Global Laws | `perch_ai_workspace/GLOBAL_LAWS.md` | Compact AI-facing rules. | Active |
| Glossary | `perch_ai_workspace/GLOSSARY.md` | Shared terminology. | Active |
| Status Definitions | `perch_ai_workspace/STATUS_DEFINITIONS.md` | Shared status label definitions. | Active |

AI workspace files should point to the Design Bible, not replace it.

---

## Authority Rules

1. Governance documents define permanent principles.
2. Chapters define intended product and engine architecture.
3. ADRs record why major decisions were made.
4. Reference documents summarize and coordinate the architecture.
5. `PROJECT_STATE.md` defines current working status.
6. Application code defines implemented reality.

When documents conflict, do not guess.

Update the correct source of truth.

---

## Status Labels

Use these labels consistently:

- Concept
- Planning
- Prototype
- Implemented
- Deprecated
- Deferred
- Blocked

No document should imply something is implemented unless it exists in the repository and is trustworthy within stated limits.

---

## Privacy Requirement

All future documentation must follow the mandatory privacy rule:

- private by default
- minimum necessary data
- no unnecessary exposure of user content
- analytics based on behavior patterns, not private content, unless explicitly allowed
- clear distinction between real, inferred, stale, uncertain, and demo data

---

## Maintenance Rule

Update this index whenever:

- a chapter is added
- a chapter is renamed
- a foundational document is added
- a document is deprecated
- v0.5 roadmap status changes
- architectural debt meaningfully changes
- Atlas navigation changes

---

## Closing Note

This index exists to prevent Perch from becoming scattered.

If a future contributor or AI agent does not know where something belongs, this index should make the answer obvious.
