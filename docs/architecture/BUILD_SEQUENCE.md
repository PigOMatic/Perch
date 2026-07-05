# Perch Build Sequence

**Status:** Engineering foundation  
**Created:** July 5, 2026  
**Source:** Design Bible v1.0, Source Manifest, UX Rebuild Plan, UI State Model, Engine Interfaces

---

## 1. Purpose

This document defines the safe order for rebuilding Perch from the restored source candidate.

The goal is to preserve useful behavior while replacing the current UI and separating engine responsibilities.

---

## 2. Core rule

> Do not redesign visuals and refactor logic in the same step unless the behavior is already covered by tests or fixtures.

Perch should move in small, auditable increments.

---

## 3. Phase 0 — Freeze and understand source

### Goal

Protect the restored source candidate as reference behavior.

### Tasks

- Keep restored source files in GitHub root.
- Complete `SOURCE_MANIFEST.md`.
- Identify localStorage keys and data shapes.
- Identify page routes.
- Identify key functions in `perch_core.js` and `perch_engine.js`.

### Exit criteria

- [ ] Every restored file has a classification.
- [ ] Data keys are documented.
- [ ] No source file is deleted before replacement exists.

---

## 4. Phase 1 — Engineering contracts

### Goal

Define the contracts before rewriting UI.

### Required docs

```text
UI_STATE_MODEL.md
ENGINE_INTERFACES.md
DATA_MODEL.md
SYSTEM_ARCHITECTURE.md
```

### Exit criteria

- [ ] UI state model exists.
- [ ] Engine interfaces exist.
- [ ] Data model exists.
- [ ] System architecture exists.

---

## 5. Phase 2 — App shell rebuild

### Goal

Create a cleaner shell without changing core behavior.

### Tasks

- Define navigation.
- Define route/page ownership.
- Define shared layout.
- Keep old pages accessible as reference until replacements are validated.

### Exit criteria

- [ ] New shell loads.
- [ ] Old pages remain reachable or archived.
- [ ] No data loss occurs.

---

## 6. Phase 3 — Today rebuild

### Goal

Rebuild Today first because it is the home screen and proof-of-system.

### Tasks

- Build Today from `PageState`.
- Surface one clear headline.
- Surface one primary attention item.
- Preserve money/calendar/brain signals.
- Add why/clear explanation path.

### Exit criteria

- [ ] Today answers the primary question.
- [ ] Facts/recommendations are visually distinct.
- [ ] Existing local data still appears.
- [ ] Current Today HTML can become reference-only.

---

## 7. Phase 4 — Capture and Brain rebuild

### Goal

Protect the input path.

### Tasks

- Rebuild capture UI.
- Preserve capture parser behavior.
- Preserve lifecycle: active, done, archived, deleted.
- Keep source trace from raw capture to parsed record.

### Exit criteria

- [ ] User can capture a reminder/waiting item/question.
- [ ] Capture appears where expected.
- [ ] Capture can be completed/archived/deleted.

---

## 8. Phase 5 — Calendar and obligations rebuild

### Goal

Rebuild time surfaces.

### Tasks

- Rebuild Week.
- Rebuild Month.
- Preserve date helpers and recurrence rules.
- Clarify obligations vs calendar events.

### Exit criteria

- [ ] Week shows current obligations.
- [ ] Month shows bills/events where appropriate.
- [ ] Work shifts and due dates do not become ambiguous.

---

## 9. Phase 6 — Engine separation

### Goal

Wrap existing engine behavior behind clean interfaces.

### Tasks

- Wrap priority scoring.
- Separate recommendations from top-priority candidate logic.
- Route statements through Truth where practical.
- Route final copy through Voice.

### Exit criteria

- [ ] Priority and Recommendation can be tested separately.
- [ ] Voice cannot change certainty.
- [ ] Truth can label or block unsupported statements.

---

## 10. Phase 7 — Money, Goals, Settings, Knowledge

### Goal

Rebuild deeper surfaces after foundations are stable.

### Tasks

- Rebuild Money read mode.
- Rebuild Goals/Life.
- Rebuild Settings/Basics.
- Rebuild Memory Explorer into Knowledge.

### Exit criteria

- [ ] Money numbers show source/lineage.
- [ ] Goal suggestions remain suggestions.
- [ ] Settings can edit basics safely.
- [ ] Knowledge can inspect stored facts/captures.

---

## 11. Phase 8 — Future domains

Do later:

- People page
- Home page
- Search page
- Atlas page
- Living World
- Integrations

These should wait until core state, data, and engine boundaries are stable.

---

## 12. Stop conditions

Stop and reassess if:

- Existing data would be lost.
- A refactor changes behavior without a test or fixture.
- A UI change changes architecture.
- A page begins making unsupported claims.
- Feature scope expands beyond the Design Bible.

---

## 13. Immediate next step

Create `DATA_MODEL.md` and `SYSTEM_ARCHITECTURE.md`, then start Phase 0 source inventory and Phase 2 app shell planning.
