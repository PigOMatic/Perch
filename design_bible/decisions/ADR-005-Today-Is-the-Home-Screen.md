# ADR-005: Today Is the Home Screen

**Status:** Accepted  
**Date:** 2026-07-05

## Decision

Today is Perch's home screen and primary entry point.

Today answers:

> What deserves my attention today?

Today is not the entire product.

Perch uses an Atlas model where each major page answers one primary question. Today provides daily orientation and pulls the highest-value signals from other domains when they matter now.

## Context

Perch has evolved through several navigation models, including earlier tab sets and broader page experiments. The current Design Bible defines a clearer Atlas approach:

- Today
- Money
- Calendar & Obligations
- Goals
- Projects
- Brain
- Knowledge & Search
- Home & Property
- future People, Health, Notifications, and Settings chapters

Without a clear home screen decision, Perch risks becoming either:

1. a scattered set of disconnected tabs, or
2. a bloated dashboard where Today tries to contain everything.

Both outcomes violate the core principle: clarity, beautifully designed.

## Alternatives Considered

### Option A — Today as the whole dashboard

Rejected.

This would make Today too heavy and would collapse the Atlas into one overloaded page.

### Option B — Equal-weight tab app

Rejected.

This would make the user decide where to look first, increasing mental load.

### Option C — Today as home, Atlas pages as focused domains

Accepted.

Today orients the user. Domain pages provide deeper context.

## Consequences

Positive:

- The user always has one obvious place to start.
- Today can stay calm and selective.
- Other pages can exist without competing to be the main experience.
- The Priority Engine has a clear destination for the most important cross-domain items.

Tradeoffs:

- Today must be carefully protected from feature creep.
- Domain pages must not duplicate Today's purpose.
- Navigation authority must remain documented as the Atlas evolves.

## Rules

- Today shows what matters now.
- Today does not show everything.
- Domain pages answer their own primary questions.
- A domain item appears on Today only when it deserves attention now.
- Today must expose why important items are shown.
- Today must never imply certainty beyond what Truth permits.

## Related Design Bible Chapters

- Chapter 1 — Today
- Chapter 2 — Money
- Chapter 3 — Calendar & Obligations
- Chapter 4 — Goals
- Chapter 5 — Projects
- Chapter 6 — Brain
- Chapter 8 — Priority Engine
- Chapter 9 — Recommendation Engine
- Chapter 12 — Knowledge & Search
- Chapter 14 — Home & Property

## Related ADRs

- ADR-001 — Design Bible Authority
- ADR-003 — Clarity Over Feature Count
- ADR-004 — Explainability Before Intelligence
