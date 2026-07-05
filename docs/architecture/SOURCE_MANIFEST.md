# Perch Source Manifest

**Status:** Source candidate restored to GitHub; audit classification in progress  
**Created:** July 5, 2026  
**Updated:** July 5, 2026  
**Purpose:** Reconcile the Design Bible's implementation references with the actual source files present in GitHub.

---

## Current finding

The uploaded `perch deploy 2.zip` bundle has now been restored to GitHub root.

It should be treated as a **source candidate**, not the canonical final app.

This version is useful because it contains working logic, app routes, storage behavior, capture behavior, date helpers, event behavior, and engine behavior. It should **not** be treated as the final visual or UX direction.

---

## Source decision

Decision: **Restore existing source as reference implementation and salvage target.**

Do not rebuild blindly, because useful logic exists. Also do not preserve the current UI as final, because the user explicitly does not like the current app look.

---

## Restored source files

| File | Status | Classification | Owning chapters | Notes |
|---|---|---|---|---|
| `index.html` | Present in GitHub | Salvage shell / replace UI | Today, Atlas | Entry shell. Can be redesigned fully. |
| `perch_core.js` | Present in GitHub | **Keep / salvage heavily** | Calendar, Brain, Money, Goals, Home, Knowledge | Main data/date/memory/event layer. Highest salvage value. |
| `perch_engine.js` | Present in GitHub | **Keep / refactor** | Priority, Recommendation, Voice, Today | Contains priority/recommendation/brief logic. Needs separation per Design Bible. |
| `perch_today_live.html` | Present in GitHub | Salvage logic / replace UI | Today | Main Today implementation. Very large monolithic page. UI can be fully rebuilt. |
| `perch_week_live.html` | Present in GitHub | Salvage logic / replace UI | Calendar & Obligations | Week view. Keep behavior patterns, redesign surface. |
| `perch_month_live.html` | Present in GitHub | Salvage logic / replace UI | Calendar & Obligations, Money | Month/bill view. Keep date/bill logic where valid. |
| `perch_capture.html` | Present in GitHub | Salvage logic / replace UI | Brain | Capture parsing and lifecycle are valuable. Redesign interface. |
| `perch_life.html` | Present in GitHub | Salvage logic / replace UI | Goals, Projects, Recommendation | Goal/funding/suggestion logic is useful. UI can be replaced. |
| `perch_settings.html` | Present in GitHub | Salvage logic / replace UI | Settings, Brain, Truth, Preferences | Contains configuration and basics flows. Needs modularization. |
| `perch_memory_explorer.html` | Present in GitHub | Salvage logic / replace UI | Knowledge & Search, People, Brain | Useful as reference; likely not final UX. |

---

## Expected Design Bible files still not restored

| File | Referenced by | Status | Notes |
|---|---|---|---|
| `perch_voice.js` | Voice Engine | Missing | Voice logic may be embedded in `perch_engine.js` or older versions. |
| `perch_beliefs.js` | Truth Engine, Belief Engine | Missing | Belief logic may be embedded, absent, or from another version. |
| `perch_truth.md` | Truth Engine / doctrine | Missing | Doctrine exists in Design Bible; standalone file not restored. |
| `perch_world.md` | Living World doctrine | Missing | Doctrine exists in Design Bible; standalone file not restored. |
| `perch_core_merge.js` | Priority Engine debt | Missing | May have been old/orphan code and should not be restored unless found. |

---

## Salvage rules

1. Keep behavior before visuals.
2. Preserve data migration and localStorage compatibility until intentionally replaced.
3. Extract reusable logic out of HTML pages before redesigning.
4. Do not style-polish the current monolithic HTML as the final design.
5. Rebuild UI from the Design Bible, not from this deploy bundle's aesthetics.
6. Treat this bundle as one historical working version among many.

---

## Required next documents

```text
docs/audits/SOURCE_CANDIDATE_AUDIT_2026-07-05.md
docs/architecture/UX_REBUILD_PLAN.md
docs/architecture/UI_STATE_MODEL.md
docs/architecture/ENGINE_INTERFACES.md
```

---

## Next action

Audit the restored source candidate and define the UI rebuild strategy before feature coding.
