# Project State

This file is the current working status of Perch.

Update this file after major milestones.

## Repository Version

0.1.0-alpha

## Current Phase

Design Bible completion.

## Current Goal

Finish the Design Bible, then freeze Design Bible v1.0 and begin Perch v0.5 implementation.

## Completed Design Bible Chapters

- 01 — Today
- 02 — Money
- 03 — Calendar & Obligations
- 04 — Goals
- 05 — Projects
- 06 — Brain
- 07 — Truth Engine
- 08 — Priority Engine
- 09 — Recommendation Engine
- 10 — Living World

## Current Next Chapter

11 — Voice Engine

## Upcoming Chapters

- 12 — Knowledge & Search
- 13 — Integrations
- 14 — Home & Property
- 15 — People & Relationships
- 16 — Health
- 17 — Learning
- 18 — Notifications
- 19 — Settings
- 20 — Security & Privacy

## Current Build Status

Application status: Prototype.

Current build plan: Perch v0.5.

## Known Architectural Debt

- Truth Engine exists as doctrine and belief-scoped runtime logic, not a universal runtime gate.
- Priority exists as multiple independent scorers, not one unified engine.
- Recommendations exist, but are currently top priority-scored candidates rather than a standalone engine.
- Living World is concept-level; current implementation is only a static decorative world preview.
- Goals are fragmented across multiple collections.
- Money logic is manual and scattered across Today and Life.
- Biweekly payday logic has known imprecision and should be fixed before relying on Money Flow.

## Current Claude Workflow

For the next Design Bible chapter, provide Claude:

1. `perch_ai_workspace/AI_BOOT.md`
2. `perch_ai_workspace/PROJECT_STATE.md`
3. the previous chapter only
4. the short task prompt

Do not upload the entire repository unless the task truly requires it.
