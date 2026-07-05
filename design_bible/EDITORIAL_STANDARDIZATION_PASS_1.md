# Perch Design Bible — Editorial Standardization Pass 1

**Date:** July 5, 2026  
**Branch:** `docs/editorial-standardization-pass-1`  
**Scope:** Design Bible chapters and supporting reference documents  
**Goal:** Improve consistency without changing locked architecture.

---

## Operating rule

The Design Bible v1.0 Architecture Baseline is locked. This pass may clarify, organize, and standardize, but it must not redesign Perch.

If a change would alter ownership, domain boundaries, engine responsibility, or global law, it requires an ADR and is outside this editorial pass.

---

## Canonical chapter standard

Every chapter should either contain or clearly imply the following information:

1. Metadata block
2. Vision or purpose
3. Primary question
4. Position in the architecture
5. Read Mode
6. Explore Mode
7. Information hierarchy
8. Intelligence and AI behaviors
9. Recommendation rules
10. Data sources and source lineage
11. Privacy and trust rules
12. What does not belong here
13. Acceptance tests
14. Implementation notes and build order
15. Change log

Exact wording may vary if the chapter's structure is stronger than a mechanical template conversion.

---

## Editorial philosophy

The goal is not uniformity for its own sake.

A good chapter should be:

- Clear to a builder
- Honest about implementation status
- Traceable to source and evidence rules
- Safe against feature creep
- Useful for future coding decisions
- Written in the same architectural voice as the rest of the Bible

Strong chapters should not be weakened by forcing them into a rigid format.

---

## Pass 1 chapter audit

| Chapter | Current quality | Action |
|---|---:|---|
| 01 — Today | High | Preserve. Add missing template sections only if needed later. |
| 02 — Money | High | Preserve. Strong source-lineage model. |
| 03 — Calendar & Obligations | High | Preserve. Strong time/obligation framing. |
| 04 — Goals | High | Preserve. Implementation gaps are named. |
| 05 — Projects | High | Preserve. Honest absence statement is valuable. |
| 06 — Brain | High | Preserve. Capture-vs-memory distinction is strong. |
| 07 — Truth Engine | High | Preserve. Constitutional chapter should keep its specialized shape. |
| 08 — Priority Engine | High | Preserve. Engine-boundary debt is clearly named. |
| 09 — Recommendation Engine | High | Preserve. Conflation risk is clearly named. |
| 10 — Living World | High | Preserve. Gap between doctrine and code is clear. |
| 11 — Voice Engine | High | Preserve. Three-path voice debt is named. |
| 12 — Knowledge & Search | High | Preserve. Current/future distinction is clear. |
| 13 — Integrations | High | Preserve. Zero-integration audit is explicit. |
| 14 — Home & Property | High | Preserve. Strong current-state vs missing-hierarchy framing. |
| 15 — People | Medium | Already standardized in v1 lock; deepen later when implementation begins. |
| 16 — Home | Medium | Already standardized in v1 lock; depends on Chapter 14. |
| 17 — Knowledge | Medium | Already standardized in v1 lock; depends on Chapter 12. |
| 18 — Search | Medium | Already standardized in v1 lock; depends on Chapter 12. |
| 19 — Atlas | Medium | Already standardized in v1 lock; capstone is adequate for baseline. |

---

## Decision

Do **not** rewrite Chapters 1–14 wholesale.

They are already stronger than a generic template conversion would make them. The correct editorial action is to preserve their depth and use the template as a checklist, not as a destructive replacement.

Chapters 15–19 were the real inconsistency and have already been standardized to baseline quality.

---

## Remaining editorial work

The next safe editorial tasks are:

1. Add an Architecture Decision Record index.
2. Add a stable terminology reference.
3. Create an implementation backlog derived from the locked Bible.
4. Create engineering architecture documents under `docs/architecture/`.

---

## Final pass 1 statement

The Design Bible is editorially acceptable for implementation planning.

Further chapter polish should happen only when implementation exposes a real gap, stale claim, or ambiguous ownership.
