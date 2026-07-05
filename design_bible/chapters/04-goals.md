# Chapter 4 — Goals

> **Chapter:** Goals
> **Chapter ID:** PERCH-04
> **Version:** 1.0
> **Status:** Prototype — funded savings goals work end-to-end (create, track, project, celebrate); the broader goal model (hierarchy, non-financial types, history) does not
> **Confidence:** 85% — the funded-goal loop is proven; the wider goal taxonomy is open design
> **Owner:** Jeff
> **Implementation:** Partial — goals live inside `future_horizon`, not as a first-class object; Life page and Today both read and render them
> **Depends On:** Priority Engine *(Prototype, in-engine)*, Money *(Implemented math)*, Calendar *(Implemented engine)*, Recommendation Engine *(Concept)*, Truth Engine *(Implemented as doctrine)*
> **Last Updated:** July 4, 2026

*Goals influence decisions; they do not replace them. Perch never forces a goal on the user. Its job is to help the user keep moving toward goals they chose — quietly, without shame, at their own pace. This chapter is held to the same evidence standard as Money, because a goal's progress number is a financial figure and a wrong one breaks the same trust.*

---

## 1. Purpose

This chapter governs everything Perch knows about what the user is **building toward**: the goals themselves, how progress is tracked, how goals are funded, how they're prioritized, and how they surface across the app.

**Primary question this chapter answers:** *Am I building the life I want?*

---

## 2. Vision

A person carries a few things they're trying to build — a trip, a cushion, a home project, a skill. Most tools either ignore these or turn them into a nagging checklist. Perch's vision is different: hold the goal quietly, show real movement when it happens, and never scold when it doesn't. The Life page states it directly today: *"Your goals. Your pace. No shame — just progress."*

The destination is a goal system that spans more than money — projects, habits, learning, health, relationships — all held with the same calm, evidence-bound honesty. But the vision is bounded by the same rule as Money: **a progress figure is shown only when it traces to real stored numbers. Perch never inflates, never guesses, never implies movement that didn't happen.**

---

## 3. Design Philosophy

- **Goals are chosen, never imposed.** Perch does not generate goals for the user or pressure them toward goals they didn't set. (See §"What Does NOT Belong.")
- **Movement over maintenance.** Perch surfaces *change* — a contribution made, a milestone crossed — not a standing scold about distance remaining.
- **No shame in stillness.** A goal that hasn't moved is held quietly, not flagged red. (This principle was enforced directly in Today's truth pass: a stale goal beat goes silent rather than nagging.)
- **The number supports the dream, never leads it.** On Today, the goal is spoken about as a dream ("you're getting there") with the percentage sitting quiet beneath. (Chapter 1.)

---

## 4. Current Implementation (repo-verified)

Traced to code. Brutally honest: **goals are not a first-class object.** They are embedded across several collections, and only one path is fully wired.

### 4a. Where goals actually live
- **`future_horizon[]`** — the primary, working goal store. Items flagged `is_life_goal` and/or `user_created` are treated as goals. This is what the **Life page** and **Today** both read. Carries: `name`, `icon`, `target_amount`, `saved_amount`, `coaching_level`, `date_start`/`date_end`, `status`, `life_priority`, `priority_tags`, `created_date`, `updated_date`.
- **`goals[]`** — a *separate legacy* collection with a different shape (`target`/`current`, e.g. emergency_fund, CC utilization). The Life page does **not** read this. It is effectively orphaned for the goal UI. **This fragmentation is the single biggest structural debt in the goal system.**
- **`homestead.goals[]`** — a third shape (greenhouse build, `cost_estimate`/`season`). Not part of the goal UI.

**Status: Prototype** — one working path (`future_horizon`) plus two orphaned collections.

### 4b. Funded goals (Implemented)
The funded-savings loop is real and complete:
- **Progress:** `pct = round(saved_amount / target_amount * 100)`; `remaining = max(0, target − saved)`. Computed identically in Life (`renderGoals`) and Today (`renderPaydayCard`, brief).
- **Creation:** manual form on the Life page — savings target, already-saved, optional target date (month), notes, and a `coaching_level`.
- **Projection:** `projectDate()` estimates a completion month from `coaching_level` savings rate (Aggressive 12% / Active 8% / Balanced 5% of paycheck) × biweekly cadence. **This is a Prediction** (§Statement Classification), and it assumes the user saves at that rate every payday — an assumption Perch cannot verify.

**Status: Implemented** for financial goals with a target amount.

### 4c. Milestones & celebration (Implemented, one-time)
- Milestones at 25 / 50 / 75 / 90 / 100 (`MILESTONES` in Today).
- `crossedMilestone(old, new)` detects a crossing; a one-time celebration surfaces via the cross-page `perch_goal_updated` localStorage flag (written when a contribution moves the goal, read once on Today, then cleared).
- Copy is truth-scoped (Chapter 1's truth pass): "Halfway there," "A quarter of the way there," "fully funded. That took real work."

**Status: Implemented** as a one-time surfacing — **not** persisted history (§4f).

### 4d. Goal scoring & priority (Prototype)
Goals feed the existing priority scorer in `perch_engine.js`:
- `rec.goalConnected` adds **+20** to a rec's why-now score.
- `life_priority` rank orders goals (via `PRIORITY_RANK`).
- `topGoal` is selected and drives the Today goal beat and payday goal suggestion.

**Status: Prototype** (in-engine, not a standalone Priority Engine — Chapter 1 §5).

### 4e. Completion (Implemented, minimal)
Completion is `pct >= 100` (or `status === 'completed'`). Fully-funded goals trigger the terminal celebration. There is no post-completion lifecycle (archival, reflection, "what's next") beyond the status.

### 4f. History (Concept for goals specifically)
- Monthly **financial snapshots** exist (`finances.snapshots`, capped 24 / two years) — but these are *account-level*, not *per-goal* progress history.
- `updated_date` on a goal records the *last* movement only.
- **There is no per-goal progress history** — no record of how a goal's percentage changed over time. The milestone flag is transient.

**Status: Concept** — goal-level historical tracking does not exist.

---

## 5. Planned Architecture

The destination this Prototype converges toward:
- Goals as a **first-class object** in one store, replacing the fragmented `future_horizon` / `goals` / `homestead.goals` split.
- A **goal hierarchy** (Vision → Objectives → Milestones → Tasks).
- **Non-financial goal types** (project, habit, learning, health, relationship).
- **Per-goal progress history** for real trend and momentum truth.
- A dedicated **Goals page** (currently goals live on the Life page).
All of the above is Concept or Planning.

---

## 6. Goal Philosophy

Perch treats a goal as a **chosen direction**, not a debt. The user opts in; Perch holds it and reflects real movement. The system must make it easy to see progress and easy to ignore a goal for a while without penalty. Goals *inform* what Perch surfaces (a funded goal earns a gentle payday nudge) but never *coerce*. Perch continuously helps the user move toward goals they chose — it does not invent goals or pressure toward them.

---

## 7. Goal Model

**Current (repo):** a goal is a `future_horizon` entry with `name`, optional `target_amount`/`saved_amount`, optional `coaching_level`, optional target date, `life_priority`, `priority_tags`, `status`, `created_date`, `updated_date`. Financial goals are fully modeled; everything else is a name with a date.

**Planned:** a unified goal object with `type`, hierarchy links (parent/child), progress model appropriate to type (amount, count, streak, boolean, or subjective), history, and dependencies.

---

## 8. Goal Types

| Type | Status | Evidence |
|---|---|---|
| **Financial goals** | Implemented | `target_amount`/`saved_amount`, projection, milestones — fully working |
| **Life goals** (dated life events) | Prototype | `future_horizon` with `is_life_goal`; tracked and dated, but progress is date-based, not funded |
| **Project goals** | Concept | `homestead.goals` shape exists (cost/season) but no project system; no tasks/subgoals |
| **Habit goals** | Concept | No habit or streak system exists anywhere in the repo (deliberately — "Perch isn't Duolingo") |
| **Learning goals** | Concept | Learning Engine captures interests, but interests are not goals; no learning-goal type |
| **Health goals** | Concept | Not modeled |
| **Relationship goals** | Concept | People are modeled (Learning/Voice engines); relationship *goals* are not |

Only Financial goals are Implemented. Everything else is Prototype or Concept, and the chapter says so rather than implying a goal taxonomy exists.

---

## 9. Goal Hierarchy

*Status: Concept.* The repository has **no** hierarchy — goals are flat. The planned model:
- **Vision** — the life direction (e.g. "a secure, adventurous family life").
- **Objectives** — concrete aims under a vision (e.g. "Yellowstone trip").
- **Milestones** — progress markers (the 25/50/75/90/100 rungs — the *only* piece of hierarchy that exists today, and only for funded goals).
- **Tasks** — the atomic actions (currently these live separately as captures/reminders, unlinked to goals).

Only Milestones exist, and only for financial goals. Vision, Objectives, and Task-linkage are Concept.

---

## 10. Progress Model

*Current (Implemented for financial):* `pct = saved/target`. Linear, amount-based.
*Planned (Concept):* type-appropriate progress — count-based (learning), streak-based (habit), boolean (one-time), or subjective self-rating (relationship/health). None of these exist.

## 11. Completion Model

*Current:* `pct >= 100` or `status==='completed'` → terminal celebration. *Missing (Concept):* post-completion lifecycle — archival, "what's next," recurring goal reset. A completed goal simply stays completed.

## 12. Goal Funding

*Implemented.* The funded-goal loop: user sets target + saved; contributions update `saved_amount` and `updated_date`; Today and Life recompute `pct`; payday surfaces a gentle "room to add toward it" suggestion (an **Interpretation**, phrased as availability, gated on real cushion — Chapter 2). Funding is the most complete part of the goal system.

## 13. Goal Scheduling

*Prototype.* Goals may carry a target date (`date_start`/`date_end` or the month field). `projectDate()` predicts a completion month from the coaching rate. This projection is a **Prediction** and must be labeled as such — it assumes a save rate the user hasn't committed to.

## 14. Goal Dependencies

*Status: Concept.* No goal can depend on another. No "finish X before Y." Not modeled.

## 15. Goal Prioritization

*Prototype.* `life_priority` rank + `goalConnected` +20 in the scorer + `topGoal` selection. Goals compete for attention through the same in-engine priority prototype that ranks everything else. A standalone Priority Engine (Concept) would unify this.

---

## 16. Read Mode

**Current:** goals render on the **Life page** (not a dedicated Goals page) as progress cards — current/target, a bar, projected completion, coaching level. On **Today**, the single `topGoal` appears as the "one thing being built" beat, dream-first with a quiet percentage.

**Planned Read Mode (Concept):** a Goals page opening with the one goal most worth attention in plain language, the rest as a calm list — prose-first, same subtraction discipline as Today.

## 17. Explore Mode

*Concept.* Deep goal view: history/trend, milestone timeline, contribution log, projection modeling ("if I add $X per payday, here's the date"), and eventually sub-goals/tasks. Only a static projection exists today; there is no history to explore.

---

## 18. Engine & Chapter Relationships

- **Priority Engine (Prototype):** goals influence ranking via `goalConnected` and `life_priority`. §4d.
- **Recommendation Engine (Concept):** would suggest *which* goal to fund when, and cross-domain moves. Today only the single funded-goal payday nudge exists, and it's evidence-gated.
- **Money (Implemented math):** funded goals are financial objects — progress is a Derived Fact from `saved`/`target`, and the payday suggestion inherits Money's strict rules. A goal progress figure is a financial figure.
- **Calendar (Implemented engine):** dated goals appear in `PerchEvents` and on the timeline; target dates are obligations-adjacent. Projections are Predictions, not calendar Facts.
- **Projects (Concept):** no project system exists; project-goals are unbuilt. `homestead.goals` is a vestige.
- **Habits (Concept):** deliberately absent — no streaks or habit loops (consistent with the anti-gamification stance in `perch_world.md`).
- **Living World (Concept):** a reached goal could become a permanent world element (the Yellowstone sign in `perch_world.md`), and priorities shape districts — but no world rendering responds to goals today. The static Today preview is unrelated.

---

## 19. Truth Rules (chapter-specific)

- A goal's **percentage is a Derived Fact** (`saved/target`) — shown plainly, only when both numbers are real.
- **Projected completion is a Prediction** — it must expose its assumption (the coaching save-rate) and never be stated as a date-certain. "At this pace, around June 2027," never "You'll finish June 2027."
- **Momentum claims require evidence.** "You moved something toward it this week" is a Fact only if `updated_date` is within 7 days. Otherwise Perch stays silent (Chapter 1 truth pass).
- **Never imply movement that didn't happen.** No motivational sentence is invented for a still goal.
- **Never invent or impose a goal.** Perch surfaces only goals the user created.

## 20. Voice Rules (chapter-specific)

- Dream-first, number-quiet: speak about the trip, not the formula (Chapter 1 subtraction pass).
- No shame for stillness; a stale goal is silent, never scolded.
- Milestones are warm and truthful, never metric-boastful ("Halfway there," not "You've achieved 50% completion").
- No pressure, no urgency manufactured around a goal the user set for themselves.

---

## 21. Known Unknowns

- **Actual contributions vs. recorded.** Perch knows `saved_amount` as last entered; real transfers it wasn't told about are invisible (inherits Money's Known Unknowns).
- **Whether the user still wants the goal.** A stale goal may be paused, abandoned, or just quiet — Perch cannot tell and must not assume (this is exactly the kind of interior state `perch_truth.md` forbids guessing).
- **True save rate.** The projection assumes a coaching rate; the real rate is unknown.
- **Non-financial progress.** With no habit/learning/health models, progress on those goals is entirely unmodeled.
- **Goal relationships.** Dependencies and hierarchy are invisible because unmodeled.

---

## 22. Source Lineage examples

```
"Yellowstone — 65% there"
    ↓  Today goal beat / Life renderGoals
    ↓  pct = saved_amount / target_amount
    ↓  future_horizon[].saved_amount, .target_amount
    ↓  Manual User Entry (Life page form)
```
```
"At this pace, around June 2027"
    ↓  projectDate()
    ↓  coaching_level save-rate × biweekly cadence   (ASSUMPTION)
    ↓  future_horizon[].coaching_level + finances.paycheck
    ↓  Manual User Entry
```

## 23. Statement Classification examples

| Statement | Classification |
|---|---|
| Yellowstone target: $4,500 | **Fact** |
| Saved so far: $2,925 | **Fact** |
| 65% there | **Derived Fact** |
| You moved something toward it this week | **Derived Fact** (updated_date ≤ 7d) |
| At this pace, around June 2027 | **Prediction** (assumes save rate) |
| A good morning to add toward it | **Recommendation** (evidence-gated) |
| You're getting there | **Interpretation** (only shown with recent movement) |

---

## 24. What Does NOT Belong

- **No AI-generated or imposed goals.** Perch never invents goals for the user. *(Verified: no goal-generation code exists, and none should.)*
- **No shame mechanics.** No red overdue goals, no guilt copy, no streak-breaking.
- **No habit/streak gamification.** Deliberately excluded (`perch_world.md`).
- **No forcing pace.** Coaching level is the user's choice; Perch never pressures a faster rate.
- **No projection stated as certainty.** Always a Prediction with its assumption exposed.
- **No progress figure without both real numbers.** A goal with no target shows no percentage.

---

## 25. Dependencies

- Money *(Implemented math)* — funded-goal progress and payday suggestion.
- Priority Engine *(Prototype, in-engine)* — goal ranking.
- Calendar *(Implemented engine)* — dated goals on the timeline.
- Truth Engine *(doctrine)* — governs every progress/projection claim.

## 26. Missing Dependencies

- **Unified first-class goal object** *(Concept)* — to end the `future_horizon`/`goals`/`homestead.goals` fragmentation.
- **Per-goal history store** *(Concept)* — for real trend/momentum truth.
- **Goal hierarchy model** *(Concept)* — Vision/Objectives/Tasks.
- **Non-financial progress models** *(Concept)* — habit/learning/health/relationship.
- **Recommendation Engine** *(Concept)* — cross-goal funding guidance.
- **Standalone Priority Engine** *(Concept)*.

## 27. Future Build Order

1. **Unify the goal object** — migrate `future_horizon` goals + orphaned `goals`/`homestead.goals` into one store. *(Removes the biggest structural debt; unblocks everything below.)*
2. **Per-goal history** — record progress over time; enables honest momentum instead of a single `updated_date`.
3. **Dedicated Goals page** — Read Mode + Explore Mode, lifted off the Life page.
4. **Goal hierarchy** — link tasks/captures to goals; add Objectives.
5. **Non-financial goal types** — project first (has a vestigial shape), then learning (interests already captured).
6. **Projection as modeled scenario** — interactive "what if I add $X," clearly a Prediction.
7. Habit/health/relationship goals — last, and only if they can avoid gamification.

Each step independently testable (data → compute → surface → gate).

---

## 28. Acceptance Tests

**Funded goals (Implemented — verified):**
- [x] `pct = saved/target`, clamped, shown only when both are real.
- [x] Contributions update `saved_amount` and `updated_date`.
- [x] Milestones fire once at 25/50/75/90/100 via the cross-page flag.
- [x] Projection derives a month from coaching rate and is phrased as an estimate.
- [x] Stale goals surface no invented motivation.
- [x] `goalConnected` boosts priority; `topGoal` drives the Today beat.

**Goal system (Concept — not built):**
- [ ] One unified goal object; no fragmented collections.
- [ ] Per-goal progress history exists.
- [ ] Non-financial goal types have real progress models.
- [ ] Hierarchy links tasks to goals.

**Always enforced:**
- [ ] No progress figure without both real numbers.
- [ ] Projection always labeled as a Prediction with its assumption shown.
- [ ] No goal is ever invented or imposed.

---

## 29. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Primary goal store | `future_horizon[]` (is_life_goal / user_created) | Prototype |
| Legacy goal store (orphaned) | `goals[]` (target/current) | Prototype (unused by UI) |
| Homestead goals (vestige) | `homestead.goals[]` | Concept |
| Funded progress | `pct` in `perch_life.html`, `perch_today_live.html` | Implemented |
| Projection | `projectDate()` in `perch_life.html` | Implemented (Prediction) |
| Milestones | `MILESTONES`/`crossedMilestone` in Today | Implemented |
| Milestone persistence | `perch_goal_updated` localStorage flag | Prototype (transient) |
| Goal scoring | `goalConnected`, `life_priority` in `perch_engine.js` | Prototype |
| Goal creation | Life page modal form | Implemented (manual only) |
| Per-goal history | — | Concept |
| Goal hierarchy | — | Concept |
| Habit/learning/health/relationship goals | — | Concept |
| AI-generated goals | — | Concept (and deliberately excluded) |

---

## 30. Notes

The honest headline: **Perch has a strong funded-savings goal loop and no general goal system.** Creating a savings goal, tracking it, projecting it, and celebrating milestones all work and are truth-scoped. But "goals" as a first-class, multi-type, hierarchical system does not exist — goals are embedded in `future_horizon`, shadowed by two orphaned collections, with no history and no non-financial types.

This mirrors the pattern across the Bible: a genuinely good narrow implementation (funded goals) under a much larger planned architecture. The status labels carry the distinction — Implemented where the money-goal loop runs, Prototype where it's embedded-but-working, Concept where the ambition (hierarchy, types, history) has no code.

The single biggest structural debt is the **three-collection fragmentation** (`future_horizon` / `goals` / `homestead.goals`). Unifying it is step 1 of the build order because every richer goal feature depends on one coherent object.

The single biggest trust rule is that **projected completion is a Prediction, not a promise** — it assumes a save rate the user never committed to. Stating it as a date-certain would be the goal equivalent of Money's live-balance error.

---

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Prototype. Verified funded-savings loop Implemented (progress, projection, milestones, scoring) traced to `perch_life.html`/`perch_today_live.html`/`perch_engine.js`. Documented three-collection fragmentation (`future_horizon`/`goals`/`homestead.goals`). Labeled hierarchy, non-financial types, per-goal history, dependencies, and AI-generated goals as Concept. Flagged projection-as-Prediction and goal-unification as key items. |
