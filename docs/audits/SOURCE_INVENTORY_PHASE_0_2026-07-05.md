# Perch Source Inventory — Phase 0

**Date:** July 5, 2026  
**Repository:** `PigOMatic/Perch`  
**Source:** Restored `perch deploy 2.zip` bundle now present in GitHub root  
**Status:** Initial source inventory complete

---

## 1. Executive conclusion

The restored source candidate contains enough working logic to salvage. It should not be treated as disposable, but it should also not dictate the final UI or architecture.

Phase 0 confirms:

- `perch_core.js` is the main data/date/memory/event foundation.
- `perch_engine.js` is the main intelligence foundation but mixes several engine concerns.
- HTML pages contain valuable behavior, but they are monolithic and should be rebuilt page-by-page.
- LocalStorage compatibility must be preserved or intentionally migrated.

---

## 2. Restored source files

| File | Lines | Approx. size | Classification |
|---|---:|---:|---|
| `index.html` | 205 | 7.7 KB | App entry shell; redesign visually. |
| `perch_core.js` | 2,326 | 112 KB | Keep and modularize gradually. |
| `perch_engine.js` | 471 | 18 KB | Keep and refactor into engine interfaces. |
| `perch_today_live.html` | 4,671 | 230 KB | Salvage behavior; replace UI. |
| `perch_week_live.html` | 922 | 54 KB | Salvage behavior; replace UI. |
| `perch_month_live.html` | 466 | 27 KB | Salvage behavior; replace UI. |
| `perch_capture.html` | 796 | 40 KB | Salvage parser/capture behavior; replace UI. |
| `perch_life.html` | 732 | 35 KB | Salvage goal/funding behavior; replace UI. |
| `perch_settings.html` | 1,313 | 65 KB | Salvage settings/basics flows; replace UI. |
| `perch_memory_explorer.html` | 1,412 | 72 KB | Salvage memory-edit patterns; replace UI. |

---

## 3. LocalStorage keys discovered

| Key | Used by | Purpose / notes |
|---|---|---|
| `perch_memory_v1` | `perch_core.js`, Settings reset | Primary Perch data store. Highest compatibility priority. |
| `perch_payday_card` | Today | Payday card display/status data. |
| `perch_rec_prefs` | Today | Recommendation done/snoozed/suppressed preferences. |
| `perch_behavior_prefs` | Today, Life, Settings | Behavior/personalization signals. Shared across pages. |
| `perch_quick_answer_prefs` | Today, Settings | Quick answer ordering/visibility/counts. |
| `perch_goal_qs` | Today | Goal-related questions. |
| `perch_noticed_v1` | Today | Lightweight noticed-item storage. |
| `perch_changes_snap` | Today, Settings reset | Snapshot used to detect changes. |
| `perch_goal_updated` | Life, Engine, Today | Cross-page flag when goals change. |
| `perch_sug_prefs` | Life | Suggestions done/suppressed preferences. |

---

## 4. Primary source modules

### 4.1 `perch_core.js`

Detected exported/global modules:

| Module | Role | Target layer |
|---|---|---|
| `PerchDate` | Date helpers and formatting | Foundation/core |
| `PerchMemory` | Primary memory/data layer | Data access/domain data |
| `PerchParse` | Capture parsing | Brain domain service |
| `PerchEvents` | Event generation / refresh | Calendar domain service |
| `PerchComplete` | Completion handling | Domain action helpers |
| `PerchActions` | User actions | Domain/action layer |
| `PerchCorrect` | Corrections / quick fixes | Data correction layer |
| `PerchFeedback` | Feedback handling | Interaction history/preferences |
| `PerchAppearance` | Appearance/theme behavior | UI preferences |

### 4.2 `perch_engine.js`

Detected major functions:

| Function | Current role | Future owner |
|---|---|---|
| `fmtTime` | Formatting helper | Foundation/core or UI helper |
| `sortGoals` | Goal ordering | Goals domain service |
| `whyNowScore` | Priority scoring | Priority Engine |
| `determineTone` | Tone selection | Voice Engine |
| `buildOpening` | Opening copy | Voice Engine / Brief Builder |
| `buildRecCandidates` | Recommendation candidate generation | Recommendation Engine |
| `buildTopPriority` | Top priority selection | Priority Engine / Brief Builder |
| `buildFacts` | Fact assembly | Truth / Brief Builder boundary |
| `buildMorningBrief` | Daily brief orchestration | Brief Builder |
| `nextFreeDay` | Calendar helper | Calendar domain service |
| `holidayNear` | Calendar helper | Calendar domain service |

---

## 5. HTML page function clusters

### `perch_today_live.html`

Large monolithic Today implementation. Function clusters include:

- Advisor/brief rendering
- Payday card logic
- Recommendation preference logic
- Behavior preference signals
- Quick answer preferences
- Goal questions
- Noticed items
- Change snapshot logic
- Hero and attention card rendering

Decision: **do not polish as final UI**. Extract behaviors gradually.

### `perch_capture.html`

Key behavior:

- Date parsing for capture text
- Capture classification
- Recent capture rendering
- Edit/rerun/complete/arrived/reopen behavior

Decision: preserve capture parser and lifecycle behavior.

### `perch_week_live.html`

Key behavior:

- Week rendering
- Week brief
- Attention items
- Day strip/detail rendering
- Quick fix hooks

Decision: preserve week/event behavior; replace presentation.

### `perch_month_live.html`

Key behavior:

- Month day generation
- Bill date placement
- Short date formatting
- Money/date surface logic

Decision: preserve bill/month logic where consistent with Money and Calendar chapters.

### `perch_life.html`

Key behavior:

- Goal suggestions
- Goal card rendering
- Add/edit/delete goals
- Suggestion preference storage
- Behavior signal recording

Decision: salvage goal/funding logic, but clarify Goals vs Projects ownership.

### `perch_settings.html`

Key behavior:

- Theme/accent controls
- Memory information display
- Learned behavior preferences
- Seed/demo data controls
- OK rules
- Basics editor: name, balance, payday, bills, shifts, people

Decision: preserve settings flows, but rebuild UI and map basics to canonical data model.

### `perch_memory_explorer.html`

Key behavior:

- Priority editing
- People editing
- Bills editing
- Memory inspection
- Feedback capture
- Section navigation

Decision: salvage record-editing patterns; rebuild as Knowledge/Memory Explorer later.

---

## 6. Source-to-Design-Bible map

| Source file | Design Bible chapters |
|---|---|
| `index.html` | Today, Atlas |
| `perch_core.js` | Brain, Calendar & Obligations, Money, Goals, Home & Property, Knowledge & Search |
| `perch_engine.js` | Truth Engine, Priority Engine, Recommendation Engine, Voice Engine, Today |
| `perch_today_live.html` | Today, Money, Brain, Calendar, Priority, Recommendation, Voice |
| `perch_week_live.html` | Calendar & Obligations, Today |
| `perch_month_live.html` | Calendar & Obligations, Money |
| `perch_capture.html` | Brain, Knowledge & Search |
| `perch_life.html` | Goals, Projects, Recommendation Engine |
| `perch_settings.html` | Settings, Brain, Money, Calendar, People, Preferences |
| `perch_memory_explorer.html` | Knowledge & Search, People, Brain, Money |

---

## 7. First safe code-change recommendation

Do not start by redesigning all pages.

First safe code change should be a **non-visual source protection pass**:

1. Add a lightweight `docs/architecture/STORAGE_KEYS.md` or inline storage section.
2. Add a small test/fixture folder or documented manual fixture cases.
3. Add wrapper functions around localStorage access in `perch_core.js` or a new `src/core/storage.js` later.
4. Do not migrate data yet.

Recommended first implementation PR:

```text
engineering: add storage inventory and behavior fixtures
```

---

## 8. Stop conditions before code changes

Stop if a change would:

- Delete a restored page before replacement exists.
- Rename a localStorage key without migration.
- Mix visual redesign with logic refactor.
- Change priority/recommendation behavior without a fixture.
- Convert manual/local data into implied live integration.

---

## 9. Phase 0 decision

The restored source candidate is valid enough to salvage.

Proceed with **inventory → fixtures → wrappers → shell rebuild**, not clean rebuild and not direct HTML beautification.
