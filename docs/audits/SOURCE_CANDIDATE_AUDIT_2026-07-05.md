# Perch Source Candidate Audit — 2026-07-05

**Audit date:** July 5, 2026  
**Source:** Restored `perch deploy 2.zip` bundle  
**Repository:** `PigOMatic/Perch`  
**Audit status:** Initial classification complete  

---

## Executive conclusion

The restored app source is useful, but it should not become the final app surface.

It should be treated as:

```text
reference implementation + salvageable logic
```

not:

```text
final UI / final architecture
```

The highest-value files are `perch_core.js` and `perch_engine.js`. The HTML pages contain useful behavior and page-specific logic, but they are large monolithic documents and should be redesigned/rebuilt into a cleaner UI architecture.

---

## Restored files audited

| File | Approx. role | Audit classification |
|---|---|---|
| `index.html` | Entry shell / route launcher | Salvage shell, replace visual design |
| `perch_core.js` | Date helpers, memory layer, event system, defaults, domain logic | Keep / modularize |
| `perch_engine.js` | Morning brief, priority scoring, recommendations, tone/opening logic | Keep / refactor into engines |
| `perch_today_live.html` | Main Today page | Salvage behavior, replace UI |
| `perch_week_live.html` | Week view | Salvage behavior, replace UI |
| `perch_month_live.html` | Month view | Salvage behavior, replace UI |
| `perch_capture.html` | Capture page | Salvage capture/parser behavior, replace UI |
| `perch_life.html` | Goals / What Matters page | Salvage goal/funding logic, replace UI |
| `perch_settings.html` | Settings / basics / preferences | Salvage flows, replace UI |
| `perch_memory_explorer.html` | Memory explorer / edit surface | Salvage data-edit patterns, replace UI |

---

## Key technical observations

### 1. The app is mostly static HTML + global JavaScript

The restored version uses standalone HTML pages with inline CSS/JS plus shared scripts. That is acceptable as a prototype but will not scale cleanly.

### 2. `perch_core.js` is the main salvage asset

It contains the most reusable foundation:

- Date helpers
- Memory/data layer
- Event system
- Defaults / seed data
- Domain helpers
- Local persistence behavior

This file should be preserved first, then gradually modularized.

### 3. `perch_engine.js` is valuable but architecturally mixed

It contains logic that maps to multiple Design Bible engines:

- Priority Engine
- Recommendation Engine
- Voice Engine
- Today brief generation

Per the Design Bible, those responsibilities eventually need clearer separation.

### 4. HTML pages contain both UI and business logic

The pages are not just presentation. They include important behavior. That means we should not discard them blindly, but also should not build the final UI by editing them forever.

### 5. The current look is not binding

The user explicitly does not like the current app look. This confirms the correct strategy:

> salvage logic, rebuild UX.

---

## Design Bible alignment

| Design Bible area | Current source reality | Action |
|---|---|---|
| Today | Exists in `perch_today_live.html`, large monolith | Preserve behavior, redesign UI |
| Brain | Exists through capture and memory tools | Preserve parser/capture lifecycle, redesign UI |
| Calendar & Obligations | Exists through Week/Month/Event logic | Preserve date/event rules, normalize model |
| Money | Exists as manual/bill/payday logic | Preserve math, add lineage and UI later |
| Goals | Exists in Life page | Preserve funding/progress logic, clarify Projects boundary |
| Truth Engine | Doctrine exists in Bible; runtime source incomplete | Build runtime gate later |
| Priority Engine | Exists partly in `perch_engine.js` | Extract into formal engine interface |
| Recommendation Engine | Exists partly in `perch_engine.js` and Life | Separate from Priority later |
| Voice Engine | Appears embedded in engine/opening/tone code | Extract later |
| Living World | Not materially implemented | Do not build until truth/data model stabilizes |
| Integrations | Not implemented | Leave future |

---

## Keep / salvage / replace decision

### Keep first

```text
perch_core.js
perch_engine.js
```

### Salvage logic, replace interface

```text
perch_today_live.html
perch_week_live.html
perch_month_live.html
perch_capture.html
perch_life.html
perch_settings.html
perch_memory_explorer.html
index.html
```

### Missing or not restored

```text
perch_voice.js
perch_beliefs.js
perch_truth.md
perch_world.md
perch_core_merge.js
```

These should not be recreated blindly. First determine whether their behavior is embedded in restored files or belongs in the clean rebuild.

---

## UX conclusion

Do not polish the current HTML aesthetics.

Create a new UX rebuild plan that treats the current files as a source of behavior and data rules, while rebuilding the interface around the Design Bible's principles:

- calm
- clear
- note-first
- source-aware
- human-readable
- less dashboard-like
- more Life OS / Atlas-driven

---

## Recommended next step

Create `docs/architecture/UX_REBUILD_PLAN.md`, then proceed to `UI_STATE_MODEL.md` and `ENGINE_INTERFACES.md`.

Do not start major feature coding until the UI rebuild strategy and source salvage boundaries are documented.
