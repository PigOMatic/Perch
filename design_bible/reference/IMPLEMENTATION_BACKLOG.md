# Perch Implementation Backlog

**Source:** Design Bible v1.0 Architecture Baseline  
**Purpose:** Translate locked architecture into implementation work without inventing new product scope.

---

## Backlog rules

1. Every task must trace to a Design Bible chapter.
2. Architecture-changing tasks require an ADR.
3. Trust and source lineage work comes before convenience features.
4. Manual/local correctness comes before live integrations.
5. The Today page remains the first implementation proving ground.

---

## Phase 1 — Engineering foundation

| Priority | Task | Source chapter |
|---:|---|---|
| 1 | Define system architecture document | Atlas, Truth Engine |
| 2 | Define canonical data model | Brain, Money, Calendar, Home & Property |
| 3 | Define engine interfaces | Truth, Priority, Recommendation, Voice |
| 4 | Define event model | Calendar & Obligations, Brain, Projects |
| 5 | Define UI state model | Today, Atlas |
| 6 | Define build sequence | All chapters |

---

## Phase 2 — Trust foundation

| Priority | Task | Source chapter |
|---:|---|---|
| 1 | Generalize truth evaluation beyond beliefs | Truth Engine |
| 2 | Add source lineage structures for all high-trust claims | Money, Truth Engine |
| 3 | Separate fact, derived fact, interpretation, recommendation, and prediction in UI copy | Truth Engine, Voice Engine |
| 4 | Add stale/uncertain data labels | Truth Engine, Integrations |

---

## Phase 3 — Engine cleanup

| Priority | Task | Source chapter |
|---:|---|---|
| 1 | Consolidate priority scoring into one engine path | Priority Engine |
| 2 | Separate recommendation generation from priority sorting | Recommendation Engine |
| 3 | Route Today copy through a unified Voice path | Voice Engine, Today |
| 4 | Add explain-why surfaces for priority and recommendation output | Today, Priority, Recommendation |

---

## Phase 4 — Manual-first MVP

| Priority | Task | Source chapter |
|---:|---|---|
| 1 | Stabilize Today as the home screen | Today |
| 2 | Strengthen manual Money inputs and lineages | Money |
| 3 | Strengthen Calendar/Obligation recurrence model | Calendar & Obligations |
| 4 | Strengthen Brain capture lifecycle and search | Brain, Knowledge & Search |
| 5 | Add basic Home & Property location hierarchy | Home & Property, Home |

---

## Phase 5 — Future expansion

| Priority | Task | Source chapter |
|---:|---|---|
| 1 | Dedicated People page | People |
| 2 | Dedicated Home page | Home |
| 3 | Dedicated Knowledge page | Knowledge |
| 4 | Dedicated Search page | Search |
| 5 | Atlas navigation surface | Atlas |
| 6 | External integration proof-of-rules import | Integrations |
| 7 | Living World state model | Living World |

---

## Current recommendation

Start with Phase 1.

Do not jump into feature coding until system architecture, data model, and engine interfaces exist.
