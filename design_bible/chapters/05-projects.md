# Chapter 5 — Projects

> **Chapter:** Projects
> **Chapter ID:** PERCH-05
> **Version:** 1.0
> **Status:** Concept — there is no first-class project system; only project-*adjacent* homestead chore/goal data exists
> **Confidence:** 80% — the role of projects is clear; the model is entirely unbuilt and its shape is open
> **Owner:** Jeff
> **Implementation:** Not Started as projects — the nearest code is `homestead.maintenance` (chores) and `homestead.goals` (a single build item)
> **Depends On:** Goals *(Prototype)*, Calendar & Obligations *(Prototype)*, Brain/Captures *(Implemented)*, Money *(Implemented math)*, Priority Engine *(Prototype, in-engine)*, Recommendation Engine *(Concept)*
> **Last Updated:** July 4, 2026

*Projects are execution systems. Goals define direction; projects organize the movement toward that direction. Perch should help a user move a project forward without becoming a heavyweight project-management app. This chapter is the most honest in the Bible so far about absence: **there is no project system in the repository.** What exists is chore tracking that is project-shaped, and this chapter says exactly that.*

---

## 1. Purpose

This chapter governs how Perch will eventually help a user **organize and advance multi-step efforts** — a greenhouse build, a rental turnover, a family trip's logistics — that are bigger than a single task and more concrete than a goal.

**Primary question this chapter answers:** *What am I in the middle of building or doing, and what's the next move?*

---

## 2. Vision

Between a goal ("expand the homestead") and a task ("buy PVC") sits the project ("build the greenhouse") — the unit where intention becomes a sequence of moves. Most tools force one of two failures: either projects live nowhere (scattered across sticky notes and reminders) or they live in heavyweight PM software that becomes its own chore. Perch's vision is the middle: a project is held lightly, its next move is obvious, and the user is never managing the manager.

Crucially, the vision is bounded by honesty about *today*: **none of this exists yet.** Perch currently has no concept of a project. This chapter is the destination, clearly marked Concept, so it is never mistaken for reality.

---

## 3. Design Philosophy

- **Lightweight, never heavyweight.** Perch will not become Jira. A project is a name, a next move, and a sense of progress — not a Gantt chart.
- **Projects organize; they don't nag.** Like goals, a stalled project is held quietly, not flagged red.
- **The next move is the point.** A project's value on Today is one thing: what's the next concrete step. Not a task backlog.
- **Projects borrow, they don't duplicate.** A project's tasks are captures (Brain), its costs are Money, its dates are Calendar. Projects are the connective tissue, not a parallel store. (This is a design principle for the planned system, not current behavior.)

---

## 4. Current Implementation (repo-verified)

Brutally honest, traced to code.

### 4a. There is no project system
- **No `projects` collection.** Verified: nothing in storage is named projects.
- **No project object or type.** Capture types are `reminder`, `waiting_on`, `recurring`, `opportunity`, `event`, `goal` — **"project" is not among them.** A capture cannot become a project.
- **No task/subtask/checklist model.** Nothing computes multi-step progress. (The only "checklist" code is the file-error UI in `index.html` and the onboarding setup checklist — unrelated.)
- **The word "project"** appears only in Voice Engine questions ("Any projects pulling at you lately?") and the What-Perch-Knows page label "Interests & projects." Neither is a data model.

**Status: Concept.** Projects do not exist as a system.

### 4b. What is project-*adjacent* (the nearest real code)
Two homestead structures are the closest thing:
- **`homestead.maintenance[]`** — chores with `urgency` (high/this_week/soon/upcoming), some with `cost_estimate`, `overdue_months`, or `days_since`. These are *recurring/one-off chores*, not projects. They surface on Today's attention section and drive the `no_urgent_maintenance` OK-rule.
- **`homestead.goals[]`** — a single item, "Greenhouse build" (`cost_estimate: 400`, `season: 'spring'`). This is the most project-like object in the entire repo — a named, multi-step, seasonal, budgeted endeavor — but it has **no tasks, no progress, no status beyond existing.** It's a goal-shaped stub, orphaned from the goal UI (Chapter 4 §4a).

**Status: Prototype** for homestead chore tracking; **Concept** for anything resembling project management.

### 4c. How the adjacent data surfaces
- **Today:** `homestead.maintenance` appears in the Needs-Attention section by `urgency`; urgent maintenance can block "clear" via the OK-rule.
- **Priority:** the scorer treats maintenance as generic `urgency` (+25 high / −20 low). **No project-specific scoring exists.**
- **Life:** homestead goals are not rendered as goals (they're in a separate collection the Life page doesn't read).

---

## 5. Planned Architecture

The destination:
- A **first-class project object** — name, type, status, next-move, linked tasks (captures), linked costs (Money), linked dates (Calendar), optional parent goal.
- **Task linkage** — projects reference existing Brain captures rather than duplicating them.
- **Lightweight progress** — derived from task completion or explicit milestones, never a mandatory schedule.
- A **project surface** (likely within Life or Home, not a heavyweight standalone).
All Concept.

---

## 6. Project Philosophy

A project is **a chosen effort with a sequence.** Perch's role is to (a) remember the project exists, (b) always know the next move, and (c) reflect real progress. Perch never imposes a project, never generates a task list the user didn't ask for, and never turns a project into an obligation with shame attached. Projects serve goals: a project exists *because* of a direction the user chose.

---

## 7. Project Model

**Current (repo):** none. The nearest fields are `homestead.goals` (`name`, `cost_estimate`, `season`) and `homestead.maintenance` (`name`, `urgency`, `cost_estimate`, `overdue_months`, `days_since`).

**Planned (Concept):** `{ id, name, type, status, next_move, parent_goal_id, task_ids[] (→ captures), cost_estimate, target_date, milestones[], created_date, updated_date, completed_date, history[] }`.

---

## 8. Project Types

Every type below is **Concept** — none is modeled. Listed to define the eventual taxonomy.

| Type | Status | Nearest current data |
|---|---|---|
| **Home projects** | Concept | `homestead.goals` (greenhouse), `homestead.maintenance` — the closest real data |
| **Money projects** | Concept | Funded goals (Chapter 4) are adjacent but are goals, not projects |
| **Life projects** | Concept | `future_horizon` dated events are adjacent, not projects |
| **Business projects** | Concept | `spicewood` rental data exists (cash flow, equity) but no project layer |
| **Family projects** | Concept | People modeled; no project layer |
| **Health projects** | Concept | Not modeled |
| **Learning projects** | Concept | Learning Engine captures interests; interests ≠ projects |

Home projects have the only real adjacent data; everything else is purely Concept.

---

## 9. Project Hierarchy

*Status: Concept.* No hierarchy exists. The planned model nests within the goal hierarchy from Chapter 4:

- **Goal** — the direction ("expand the homestead"). *Prototype (funded goals only).*
- **Project** — the effort ("build the greenhouse"). *Concept.*
- **Milestone** — a progress marker within the project. *Concept for projects* (milestones exist only for funded goals).
- **Task** — a concrete step ("pour the footing"). *Exists as captures, but unlinked to any project.*
- **Subtask** — a step within a step. *Concept — no subtask model.*

Only Tasks (as unlinked captures) and funded-goal Milestones exist. Project, project-Milestone, and Subtask are Concept.

---

## 10. Project Status Model

*Concept.* No project status exists. (Maintenance has `urgency`; homestead goals have no status.) Planned: `active / paused / blocked / done`, held without shame.

## 11. Completion Model

*Concept.* No project completion exists. Planned: a project completes when its tasks/milestones are done or the user marks it done; a completed project could become a permanent Living-World element (Chapter's §Living World).

## 12. Dependency Model

*Concept.* No project can depend on another; no task ordering. Not modeled. (Same absence as goal dependencies, Chapter 4 §14.)

## 13. Deadline Model

*Concept for projects.* Dates exist for calendar items and goals; projects have no deadline model. `homestead.maintenance` has soft urgency bands, not deadlines. When built, project deadlines inherit Calendar's truth rules (Chapter 3) — a deadline is a Fact only if sourced.

## 14. Progress Model

*Concept.* No project progress is computed anywhere. Planned: progress derived from completed linked tasks or explicit milestones — a **Derived Fact** when it exists, never invented.

## 15. Project Scheduling

*Concept.* Perch schedules nothing (Chapter 3 §12). A project's dates would be surfaced from Calendar, never auto-planned.

## 16. Project Funding

*Concept, but adjacent.* `homestead.goals` and `maintenance` carry `cost_estimate`, and funded goals (Chapter 4) prove the funding loop. A project's budget would reuse Money's math and strict rules — a cost is a Fact only if entered; a "you can afford this project" claim is an evidence-gated Interpretation (Chapter 2).

---

## 17. Read Mode

*Concept — no project surface exists.* Planned: a project reads as its name + its **one next move** + a quiet sense of progress. Prose-first, like Today. Never a task board as the default.

## 18. Explore Mode

*Concept.* Planned: the full project — linked tasks, costs, dates, milestones, history. Calm and readable, never a heavyweight PM view.

---

## 19. Engine & Chapter Relationships

- **Goals (Prototype):** a project serves a goal; `parent_goal_id` is the planned link. Today, goals and the greenhouse stub live in unconnected collections.
- **Money (Implemented math):** project budgets reuse Money's figures and rules. Cost estimates exist on homestead items; no project-level budget rollup exists.
- **Calendar & Obligations (Prototype):** project dates/deadlines surface through `PerchEvents`. Maintenance urgency is the only current time signal, and it's not a true deadline.
- **Brain/Captures (Implemented):** the planned source of project tasks — projects would *reference* captures, not duplicate them. Today captures are unlinked to any project.
- **Priority Engine (Prototype):** treats maintenance as generic urgency; no project-aware scoring. A future Priority Engine would rank "next moves" across projects.
- **Recommendation Engine (Concept):** would suggest the next move or the best day for a project step ("you're off Thursday and it's dry — good greenhouse day"). This is the canonical cross-domain recommendation and needs weather/calendar/home data Perch lacks (Chapter 1 §7).
- **Living World (Concept):** a completed project is the most natural permanent world element — a finished greenhouse *appearing* in the scene (Rule of Surprise, `perch_world.md`). No world responds to projects today.

---

## 20. Truth Rules (chapter-specific)

- **A project's existence and next move are Facts** only when stored. Perch invents neither.
- **Progress is a Derived Fact** from completed tasks/milestones — never estimated to look better.
- **"Next move" is never guessed.** If the user hasn't defined the next step, Perch asks or stays silent; it does not fabricate a plausible step.
- **Perch never generates a project or its task list unprompted** (§What Does NOT Belong).
- **A blocked/stalled project is stated plainly, without shame.**

## 21. Voice Rules (chapter-specific)

- Next-move framed as an observation, not a command (Chapter 1 subtraction): "The greenhouse is waiting on the footing," not "Pour the footing."
- No nagging on stalled projects; held quietly.
- Cost/date claims inherit Money and Calendar voice rules.
- No manufactured urgency around a self-chosen project.

## 22. Known Unknowns

- **Whether a project exists at all** — Perch only knows what's entered; most real projects are invisible.
- **The real next move** — unless the user defined it, Perch doesn't know it.
- **Whether a stalled project is abandoned or paused** — an interior state Perch must not guess (`perch_truth.md`).
- **True cost and timeline** — estimates are user-entered guesses, not tracked actuals.
- **Task-to-project belonging** — captures aren't linked to projects, so Perch can't know which task advances which effort.

## 23. Source Lineage examples

```
"Greenhouse build — spring, ~$400"   (adjacent data, not a project)
    ↓  Life/homestead read
    ↓  homestead.goals[].cost_estimate, .season
    ↓  Manual Seed / User Entry
```
```
"Rental HVAC filter is overdue"      (maintenance, not a project)
    ↓  Today attention section
    ↓  homestead.maintenance[].urgency + overdue_months
    ↓  Manual Seed / User Entry
```
Planned project lineage (Concept):
```
"Greenhouse — next: pour the footing"
    ↓  Project object.next_move
    ↓  linked capture (Brain)
    ↓  Manual User Entry
```

## 24. Statement Classification examples

| Statement | Classification |
|---|---|
| Greenhouse build, est. $400 | **Fact** (entered) |
| Rental HVAC filter overdue 4 months | **Derived Fact** (overdue_months) |
| Greenhouse is 60% done | **Derived Fact** *(Concept — requires task/progress model)* |
| Next move: pour the footing | **Fact** *(Concept — requires next_move field)* |
| Good day to work the greenhouse Thursday | **Recommendation** (cross-domain; Concept) |
| You'll finish by summer | **Prediction** (Concept; would need progress + rate) |

---

## 25. What Does NOT Belong

- **No heavyweight PM.** No Gantt charts, no burndown, no mandatory schedules. Perch is not Jira.
- **No AI-generated projects or task lists.** Perch never invents a project or fills in steps the user didn't choose. *(Verified: no such code exists, and none should.)*
- **No task board as the default surface.** Next-move-first, not backlog-first.
- **No shame on stalled projects.**
- **No duplicated tasks.** Projects reference captures; they don't create a parallel task store.
- **No invented progress, cost, or next move.**

## 26. Dependencies

- Brain/Captures *(Implemented)* — the task substrate.
- Goals *(Prototype)* — the parent direction.
- Money *(Implemented math)* — budgets.
- Calendar & Obligations *(Prototype)* — dates/deadlines.
- Priority Engine *(Prototype)* — next-move ranking.
- Truth Engine *(doctrine)*.

## 27. Missing Dependencies

- **First-class project object** *(Concept)* — nothing exists.
- **Task-to-project linkage** *(Concept)* — captures are unlinked.
- **Project progress model** *(Concept)*.
- **Unified goal object** *(Concept, Chapter 4)* — projects need it to hang off.
- **Recommendation Engine** *(Concept)* — for next-move suggestions.

## 28. Future Build Order

1. **Define the project object** and let a capture be promoted to (or linked under) a project. *(Smallest real step from today's data.)*
2. **Link tasks** — projects reference captures instead of duplicating them.
3. **Migrate homestead goals/maintenance** into the project/task model where they fit (the greenhouse is the natural first project).
4. **Next-move surfacing** — one line on Today/Home: the project's next concrete step.
5. **Lightweight progress** — from completed linked tasks.
6. **Project budgets** — roll up costs via Money.
7. **Completion → Living World** — a finished project becomes a permanent world element.

Each step independently testable (data → link → compute → surface → gate).

## 29. Acceptance Tests

**Current (verified):**
- [x] No `projects` collection or project type exists.
- [x] Homestead maintenance surfaces by urgency on Today.
- [x] Homestead goals carry cost/season but no tasks or progress.
- [x] Priority treats maintenance as generic urgency, not project-aware.

**Planned (Concept — not built):**
- [ ] A project is a first-class object with a next move.
- [ ] Tasks are linked captures, never duplicates.
- [ ] Progress is derived from real task completion.
- [ ] No project or task list is ever auto-generated.
- [ ] Next move is never fabricated; absent → Perch asks or stays silent.

## 30. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Projects collection | — (does not exist) | Concept |
| Project type on captures | — (not in TYPES) | Concept |
| Project-adjacent: chores | `homestead.maintenance[]` | Prototype |
| Project-adjacent: build item | `homestead.goals[]` (greenhouse) | Prototype (stub) |
| Tasks | `captures[]` (unlinked) | Implemented (as captures, not project tasks) |
| Maintenance surfacing | Today attention + `no_urgent_maintenance` rule | Implemented |
| Project progress/history/completion | — | Concept |
| Project recommendations | — | Concept |
| AI-generated projects | — | Concept (deliberately excluded) |

## 31. Notes

The honest headline: **Perch has no project system.** Not a weak one — none. The word "project" is UI copy in two places; there is no project object, type, task-linkage, progress, status, completion, history, or recommendation. The only project-*shaped* data is homestead chore tracking (`maintenance`) and a single budgeted build stub (`homestead.goals` greenhouse), both Prototype-level and neither functioning as a project.

This is the correct and useful thing for the Bible to record: a whole Atlas capability at **Concept**, with its nearest real data identified (the greenhouse is the obvious first project when the model is built) and its dependencies named (it needs the unified goal object from Chapter 4 and the task substrate from Brain). Projects are the connective tissue between Goals (direction) and Brain (tasks) and Money (cost) and Calendar (dates) — which is exactly why they can't be built until those neighbors are firmer. The status labels say so plainly, and nothing here implies project management exists because it would be useful.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Concept. Verified no `projects` collection, no project type, no task/subtask/progress model. Identified `homestead.maintenance` and `homestead.goals` (greenhouse) as the only project-adjacent data (Prototype). All project types, hierarchy, status, completion, dependencies, and recommendations labeled Concept. |
