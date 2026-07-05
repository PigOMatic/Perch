# Perch System Architecture

**Status:** Engineering foundation  
**Created:** July 5, 2026  
**Source:** Design Bible v1.0, Source Manifest, Source Candidate Audit, UX Rebuild Plan, Data Model, UI State Model, Engine Interfaces

---

## 1. Purpose

This document defines the target system architecture for rebuilding Perch from the restored source candidate.

It bridges the Design Bible and the actual app code.

---

## 2. Architectural stance

Perch should move from a set of large static HTML pages with shared JavaScript toward a clearer layered architecture.

The rebuilt system does not need to jump immediately to a heavy framework. It does need clearer boundaries.

---

## 3. Current source reality

The restored source candidate includes:

```text
index.html
perch_core.js
perch_engine.js
perch_today_live.html
perch_week_live.html
perch_month_live.html
perch_capture.html
perch_life.html
perch_settings.html
perch_memory_explorer.html
```

Current pattern:

```text
HTML page = layout + style + page logic
perch_core.js = shared helpers/data/event/memory logic
perch_engine.js = brief/priority/recommendation/voice-like logic
```

This is acceptable for prototype recovery, but not the long-term architecture.

---

## 4. Target architecture layers

```text
┌─────────────────────────────────────────────┐
│ UI / Pages                                  │
│ Today, Week, Month, Capture, Settings, etc. │
├─────────────────────────────────────────────┤
│ Page State Builders                         │
│ Convert domain data + engine output to UI   │
├─────────────────────────────────────────────┤
│ Engines                                     │
│ Truth, Priority, Recommendation, Voice      │
├─────────────────────────────────────────────┤
│ Domain Services                             │
│ Money, Calendar, Brain, Goals, Home, People │
├─────────────────────────────────────────────┤
│ Data Access / Persistence                   │
│ LocalStorage adapters, migrations, sources  │
├─────────────────────────────────────────────┤
│ Foundation                                  │
│ Date helpers, IDs, utilities, event bus     │
└─────────────────────────────────────────────┘
```

---

## 5. Layer responsibilities

### 5.1 UI / Pages

Responsible for:

- Rendering
- User interaction
- Navigation
- Mode switching between Read and Explore

Not responsible for:

- Calculating truth
- Ranking priority
- Creating recommendations
- Owning persistent data shapes

### 5.2 Page State Builders

Responsible for:

- Producing `PageState`
- Organizing UI sections
- Connecting actions to records
- Preparing trust notices

### 5.3 Engines

Responsible for:

- Truth: allowed/limited/blocked claims
- Priority: ranking attention
- Recommendation: suggested actions
- Voice: final wording

### 5.4 Domain Services

Responsible for:

- Domain-specific operations
- Data validation
- Record creation/update rules
- Derived facts within a domain

### 5.5 Data Access / Persistence

Responsible for:

- LocalStorage reads/writes
- Source records
- Migrations
- Import/export later

### 5.6 Foundation

Responsible for:

- Dates
- IDs
- Formatting
- Common utilities
- Event bus

---

## 6. Recommended folder direction

Do not reorganize everything immediately. Use this as the target structure when rebuilding.

```text
/src
  /core
    date.js
    ids.js
    storage.js
    events.js
  /data
    adapters.js
    migrations.js
    sources.js
  /domains
    brain.js
    calendar.js
    money.js
    goals.js
    projects.js
    home.js
    people.js
    knowledge.js
  /engines
    truth.js
    priority.js
    recommendation.js
    voice.js
    brief.js
  /state
    todayState.js
    weekState.js
    captureState.js
    settingsState.js
  /ui
    shell.js
    components.js
    pages/
```

For now, restored root files may remain until replacements exist.

---

## 7. Routing model

Current pages can remain as routes while the rebuilt shell is designed.

Target route ownership:

| Route | Page | Chapter owner |
|---|---|---|
| `/` | App shell / Today landing | Today / Atlas |
| `/today` | Today | Chapter 1 |
| `/week` | Week | Chapter 3 |
| `/month` | Month | Chapter 3 / Money |
| `/capture` | Capture | Chapter 6 |
| `/life` | Goals / Projects planning | Chapters 4–5 |
| `/settings` | Settings / Basics | Settings / Trust controls |
| `/knowledge` | Knowledge / Memory Explorer | Chapters 12, 17 |

---

## 8. Data flow

Target flow:

```text
Stored records
   ↓
Domain services
   ↓
Truth Engine gates claims
   ↓
Priority Engine ranks attention
   ↓
Recommendation Engine suggests actions
   ↓
Voice Engine phrases output
   ↓
Page State Builder creates PageState
   ↓
UI renders Read Mode / Explore Mode
```

UI should not bypass this flow for high-trust statements.

---

## 9. Source candidate migration plan

### Step 1 — Inventory

Document current localStorage keys, functions, and page behavior.

### Step 2 — Wrap

Add thin wrappers around existing logic rather than rewriting immediately.

### Step 3 — Rebuild shell

Create a cleaner shell that can use old logic.

### Step 4 — Replace page-by-page

Rebuild pages in the order defined by `BUILD_SEQUENCE.md`.

### Step 5 — Retire old pages

Only retire old HTML after replacement behavior is verified.

---

## 10. Testing strategy

Testing should begin with behavior fixtures, not visual polish.

Initial fixtures:

- bills before payday
- next work shift
- capture parsing
- goal funding suggestion
- priority ordering
- recommendation suppression
- stale data label

Minimum test target:

```text
same inputs → same derived facts → same attention order
```

---

## 11. Trust and privacy stance

Perch is local/manual-first right now.

Until integrations exist:

- Do not imply live sync.
- Do not imply live banking.
- Do not imply cloud memory.
- Do not imply semantic search.
- Do not imply autonomous action.

Every future integration must be opt-in and source-labeled.

---

## 12. Non-goals

This architecture does not yet require:

- React/Vue/Svelte
- Backend server
- Authentication
- Cloud database
- Mobile app
- Push notifications
- Banking/calendar/email integrations

Those may become future ADRs.

---

## 13. Immediate implementation rule

Before changing UI files, create or confirm:

```text
DATA_MODEL.md
UI_STATE_MODEL.md
ENGINE_INTERFACES.md
BUILD_SEQUENCE.md
```

Those are now the controlling engineering docs for the rebuild.

---

## 14. Acceptance criteria

This architecture is ready to guide build work when:

- [ ] Restored source files are classified.
- [ ] Data model exists.
- [ ] Engine interfaces exist.
- [ ] UI state model exists.
- [ ] Build sequence exists.
- [ ] First rebuilt page can be implemented without changing domain rules.
- [ ] Old UI can remain as reference until replaced.
