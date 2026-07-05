# Architectural Debt

This document collects architectural issues discovered during Design Bible audits.

It is a build roadmap, not a blame document.

## Priority Key

- **Critical** — must be addressed before Perch can be trusted broadly.
- **High** — should be addressed before v0.5 or early daily use.
- **Medium** — important, but can follow core trust work.
- **Later** — useful after the core product stabilizes.

---

## Truth Engine

**Status:** Prototype  
**Priority:** Critical

### Debt

- Runtime Truth Gate is not universal.
- Confidence and classification are primarily belief-scoped.
- Source lineage is mostly doctrine, not runtime provenance.

### Target

Create a universal Truth Gate used by Priority, Recommendation, Voice, and pages.

---

## Priority Engine

**Status:** Prototype  
**Priority:** Critical

### Debt

- Multiple independent scoring systems exist.
- Tie-breaking is inconsistent.
- Priority is not universally Truth-gated.

### Target

Create one canonical Priority Engine with explainable scoring.

---

## Recommendation Engine

**Status:** Prototype  
**Priority:** High

### Debt

- Recommendations piggyback Priority output.
- No standalone recommendation object model.
- No structured confidence or conflict resolution.

### Target

Separate Recommendation from Priority.

---

## Voice Engine

**Status:** Prototype  
**Priority:** High

### Debt

- Voice is fragmented across PerchVoice, engine brief/opening copy, and message_styles.
- The named Voice Engine does not phrase the main Today brief.

### Target

Route major surfaces through one Voice Engine.

---

## Knowledge & Search

**Status:** Prototype  
**Priority:** Critical

### Debt

- Knowledge is scattered across captures, questions, people, interests, and learned context.
- Search is substring-only.
- No semantic search, vector search, or knowledge graph.

### Target

Build one search surface across everything Perch knows.

---

## Brain

**Status:** Prototype  
**Priority:** High

### Debt

- Captures are real, but capture does not equal memory.
- No semantic recall, capture aging, or confidence on captures.

### Target

Connect Brain to Knowledge & Search while preserving source truth.

---

## Money

**Status:** Prototype  
**Priority:** Critical

### Debt

- No standalone Money page.
- Money logic is scattered across Today and Life.
- Biweekly payday logic has known imprecision.
- Spending analysis and duplicate-charge detection are absent.

### Target

Fix payday logic and source-label every money figure.

---

## Goals

**Status:** Prototype  
**Priority:** High

### Debt

- Goals are fragmented across multiple collections.
- No goal hierarchy or per-goal history.

### Target

Unify goal storage before expanding goal types.

---

## Projects

**Status:** Concept  
**Priority:** Medium

### Debt

- No project object exists.
- No task/subtask/checklist system.
- Project-adjacent data exists in Home & Property.

### Target

Delay full Projects until Brain, Goals, Calendar, and Home task models are clearer.

---

## Living World

**Status:** Concept  
**Priority:** Medium

### Debt

- Static decorative preview only.
- No world-state store, entity model, or Truth-gated world emissions.

### Target

Do not animate/evolve the world until Truth-gated state can feed it.

---

## Integrations

**Status:** Concept  
**Priority:** Later

### Debt

- No external integrations, import/export, sync strategy, OAuth/API boundary, or imported-data provenance.

### Target

Start with safe local file import before live integrations.

---

## Home & Property

**Status:** Prototype  
**Priority:** Medium

### Debt

- Flat property records.
- No location hierarchy, equipment model, maintenance history, or property-linked utilities.

### Target

Unify home maintenance with the Projects/task model, then build a location hierarchy.

---

## Pending Chapters

- People & Relationships
- Health
- Learning
- Notifications
- Settings
- Security & Privacy

## v0.5 Suggested Debt Burn-Down

1. Fix biweekly payday logic.
2. Add source labels to money projections.
3. Build a universal Truth Gate skeleton.
4. Consolidate priority scoring.
5. Create one cross-knowledge search.
6. Route Today copy through Voice Engine.
7. Keep privacy sanitation in every future Design Bible prompt.
