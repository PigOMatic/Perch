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
- 11 — Voice Engine
- 12 — Knowledge & Search
- 13 — Integrations
- 14 — Home & Property

## Current Next Chapter

15 — People & Relationships

## Upcoming Chapters

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

### Truth Engine
- Runtime gate is not yet universal.
- Confidence and classification are primarily belief-scoped.

### Priority Engine
- Multiple independent scoring systems exist.
- Priority is not yet universally Truth-gated.

### Recommendation Engine
- Recommendations are currently derived from priority-scored candidates.
- Recommendation logic is not yet a standalone engine.

### Voice Engine
- Three independent voice systems exist:
  - PerchVoice (learning)
  - Engine brief/opening
  - message_styles
- The named Voice Engine does not yet phrase the main Today brief.

### Living World
- Concept-level architecture.
- Current implementation is only a static decorative world preview.
- No unified world-state store exists.

### Goals
- Goals are fragmented across multiple collections.

### Money
- Money logic is manual and split across Today and Life.
- Biweekly payday logic has known imprecision.

### Brain
- No semantic memory.
- No vector search.
- No capture aging.

### Knowledge & Search
- Knowledge is scattered across separate stores (personal_context, interests, people/known_details, captures) with no unified index.
- Search is substring-only (captures and questions); it does not reach the Learning or People stores.
- Recall returns first match, not best match.
- No semantic search, no vector search, no knowledge graph.

### Integrations
- Zero external integrations exist; Perch is fully manual, local, and offline.
- No API, import, sync, or OAuth anywhere; only network call is a local file-existence check.
- No imported-data provenance or confidence propagation exists (nothing to import yet).
- Tiller, banking/Plaid, Calendar, Email, Weather, GitHub, and Health are all Concept.

### Home & Property
- Two flat property records (primary and rental properties) with financials; no location hierarchy.
- No rooms, buildings, land, equipment, or storage as objects; pool/workshop/barn exist only in notes.
- Utilities are modeled as bills, not property-linked objects; no maintenance history (log empty).
- Home maintenance overlaps Projects (Ch.5) — two task stores that should be unified.

## Current Claude Workflow

For the next Design Bible chapter, provide Claude:

1. perch_ai_workspace/AI_BOOT.md
2. perch_ai_workspace/PROJECT_STATE.md
3. The previous chapter only
4. The short task prompt

Do not upload the entire repository unless the task truly requires it.
