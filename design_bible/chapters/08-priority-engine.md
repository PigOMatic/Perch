# Chapter 8 — Priority Engine

> **Chapter:** Priority Engine
> **Chapter ID:** PERCH-08
> **Version:** 1.0
> **Status:** Prototype — real scoring exists, but as **four independent, uncoordinated scorers**, not one engine. There is no unified, centralized, or fully explainable Priority Engine.
> **Confidence:** 90% — the role of priority is clear and heuristics work; the unification is entirely unbuilt
> **Owner:** Jeff
> **Implementation:** Partial — `whyNowScore` is the closest to canonical, but at least three other scoring systems rank things independently
> **Depends On:** Truth Engine *(Prototype — should gate priority but does not yet)*, Calendar *(Implemented)*, Goals *(Prototype)*, Brain *(Prototype)*, Money *(Implemented math)*
> **Last Updated:** July 4, 2026

*One architectural distinction is constitutional and must never blur: **Truth answers "what is true?" Priority answers "what deserves attention?" Recommendation answers "what should the user do?"** These are three independent engines. This chapter is Priority — and its honest headline is that Perch does not have one Priority Engine. It has four scoring systems that each decide ordering in their own corner, with inconsistent tie-breaking and no shared brain.*

---

## 1. Purpose

The Priority Engine decides **what rises for the user's attention** — which single item becomes Today's "one thing," which recommendations appear, in what order everything is shown. Priority comes before presentation: every piece of information competes, and Priority arbitrates.

**Primary question this chapter answers (internal):** *What deserves attention right now?*

---

## 2. Vision

A person's life throws dozens of candidate demands at any moment — bills, shifts, goals, waiting items, chores. The vision is a single, coherent Priority Engine that weighs them all on one scale, explains *why* each rose, ranks deterministically, and hands the top of the list to Today and the pages. One brain deciding attention, so the same logic governs the "one thing" on Today, the order on Money, and the surfacing on Calendar.

The vision is bounded by a stark current truth: **there is no single engine.** Attention is decided by several scorers that don't know about each other. Unifying them is this chapter's whole future.

---

## 3. Design Philosophy

- **Priority before presentation.** What rises is decided before how it looks.
- **One thing, not a ranked wall.** Today surfaces a single "one thing," not a leaderboard (Chapter 1).
- **Why-now, not just importance.** A thing rises because it matters *now*, not merely because it's important in the abstract.
- **Explainable.** Every priority decision should be able to say why it rose. (Today: partially — `whyNow` strings exist; the full score is not surfaced.)
- **Deterministic.** Same inputs → same order, every refresh. (Today: mostly, but inconsistent tie-breaking threatens this.)
- **Priority ranks; it does not invent.** Priority orders truths; it never creates or inflates them (that's the Truth Engine's boundary).

---

## 4. Current Implementation (repo-verified)

Brutally honest. **There are at least four independent scoring systems.** Each is real; none is coordinated.

### Scorer 1 — `whyNowScore(rec, context)` — `perch_engine.js` (closest to canonical)
The most engine-like scorer. Starts at `baseScore || 50`, then:
- `timedToToday` **+40**, `timedToPayday` **+35**, `goalConnected` **+20**
- `urgency==='high'` **+25**, `urgency==='low'` **−20**
- `shiftToday && type==='shift_prep'` **+30**, `shortMoney && type==='bill'` **+30**
- no-why-now suppression **−25**
- clamped **0–100**.
Used in `buildMorningBrief`: `candidates.forEach(r => r.score = whyNowScore(r, context))`. This ranks the engine's recommendation candidates. **Status: Prototype (the canonical seed).**

### Scorer 2 — `priorityScore(tags)` — `perch_core.js`
A **different** scorer entirely. Weights an item by its `priority_tags` against the five ranked life priorities (financial_freedom rank 1 … career_growth rank 5), producing a `priority_score` (primary-weighted, secondary-added). Attached to events in `PerchEvents`. **Ranks by life-priority alignment, not why-now.** Status: Prototype.

### Scorer 3 — Today's own `_score` system — `perch_today_live.html`
Quick-answer and question candidates get their **own** `_score` and `_whyNow`, then `candidates.sort((a,b)=>(b._score||0)-(a._score||0))`. This is a **third**, page-local ordering that neither engine scorer touches. Status: Prototype.

### Scorer 4 — `PerchEvents` sort — `perch_core.js`
Events sort by **`daysUntil` ascending, then `priority_score`** (Scorer 2's output). A **fourth** ordering, time-first rather than score-first. Status: Implemented (for the timeline).

### The coordination problem
- **Not centralized.** Four scorers in three files.
- **Duplicated.** An orphan `perch_core_merge.js` re-implements `priorityScore` — a fifth copy, unused but present.
- **Page-specific.** Today's `_score`, the engine's `whyNowScore`, and the event sort each own a different surface.
- **Heuristic.** All are hand-tuned point values, not learned.
- **Inconsistent tie-breaking.** Some sorts break ties by `daysUntil`, some by `priority_score`, some by `_score`. No single tie-break rule.
- **Deterministic-ish.** Given identical data, order is stable per scorer — but *which scorer wins* depends on the surface, so "the one thing" logic and the timeline order can reflect different priorities.

**Overall status: Prototype.** Real, working heuristic scoring — but explicitly **not one engine.**

### What decides "the one thing" today
In `buildMorningBrief`/Today: the engine builds recommendation candidates, scores each with `whyNowScore`, and the highest survivor becomes the note's focus, with type-specific overrides (an urgent bill, a shift-prep, the oldest brain item). It is `whyNowScore` — Scorer 1 — that most directly picks the "one thing," moderated by hand-coded type precedence.

---

## 5. Planned Architecture

- **One Priority Engine** every surface calls, replacing all four scorers.
- **A single scoring model** combining why-now, importance, risk, opportunity, momentum, goal-alignment, and time-horizon on one scale.
- **A consistent tie-break rule.**
- **Explainability** — every ranked item carries its score breakdown.
- **Truth-gating** — Priority ranks only Truth-permitted candidates (Chapter 7).
All Concept except the heuristic seeds above.

---

## 6. Priority Philosophy

Priority exists so the user never has to triage their own life at 6am. It weighs everything competing for attention and surfaces the few that matter now — one on Today, a short ordered list elsewhere. It never fabricates urgency, never elevates an unsupported claim (Truth gates it), and never replaces the user's judgment — it *informs* attention, it doesn't dictate action (that's Recommendation).

---

## 7. Attention vs. Importance

A crucial distinction the current heuristics only partly capture:
- **Importance** — how much something matters in general (life-priority rank; Scorer 2).
- **Attention** — what deserves focus *right now* (why-now; Scorer 1).
A funded goal is *important* always, but only *attention-worthy* on payday. Today, these two live in different scorers that don't combine cleanly — the planned engine merges them: attention = importance × timeliness × risk.

---

## 8. Priority Inputs

What currently feeds priority (per scorer):
- **Time signals** — `timedToToday`, `timedToPayday`, `daysUntil`, overdue. *(Scorers 1, 4.)*
- **Goal connection** — `goalConnected`, `life_priority`. *(Scorers 1, 2.)*
- **Urgency** — `urgency: high/low`, maintenance urgency bands. *(Scorer 1.)*
- **Money context** — `shortMoney`, `shiftToday`. *(Scorer 1.)*
- **Life-priority tags** — the five ranked priorities. *(Scorer 2.)*
Planned inputs not yet used: confidence, momentum, risk, explicit user intent, attention budget.

## 9. Priority Outputs

- A `score` (0–100, Scorer 1) or `priority_score` (weighted, Scorer 2) or `_score` (page-local, Scorer 3).
- A sorted candidate list per surface.
- The single "one thing" for Today.
There is **no unified output object** — each scorer emits its own shape.

## 10. Priority Lifecycle

*Prototype.* Scores are computed fresh each render (`buildMorningBrief`, `refreshAllToday`), not persisted. No priority history, no decay, no learning across sessions. A priority exists only for the current render.

---

## 11. Scoring Model (by dimension)

How each dimension is handled today. Honest status per dimension.

- **Urgency** — Implemented (Scorer 1: high +25/low −20; maintenance bands).
- **Importance** — Prototype (Scorer 2: life-priority rank weighting).
- **Risk** — Concept (no explicit risk scoring; `shortMoney` is the nearest proxy).
- **Opportunity** — Prototype (opportunity captures scored; extra-shift value noted, not fully modeled).
- **Momentum** — Concept (goal `updated_date` exists but doesn't feed priority; Belief Engine has momentum patterns, gated off).
- **Dependencies** — Concept (no dependency-aware ordering).
- **Deadlines** — Prototype (time signals via Calendar; no distinct deadline weight).
- **User Intent** — Concept (no explicit intent capture; no pinning).
- **Goal Alignment** — Prototype (`goalConnected` +20; `life_priority`).
- **Confidence** — **Concept (does NOT affect priority).** Belief confidence is never an input; low-confidence items aren't down-weighted.
- **Time Horizon** — Implemented (daysUntil classification, Chapter 3).
- **Context** — Prototype (shiftToday, shortMoney; a few context flags).

## 12. Attention Budget

*Concept.* There is no model of how much attention the user has or how many items may surface. Today's "one thing" discipline is enforced by **layout convention** (Chapter 1), not by an attention-budget computation. Planned: an explicit budget that caps what rises.

---

## 13. Read Mode / Explore Mode

Priority has **no user-facing surface of its own** — it is infrastructure whose output *is* the ordering of every page. Its only visible trace is the "one thing" and the order of items. A future **"why did this rise?" explainer** (surfacing the score breakdown) would be its Explore Mode — Concept. The `whyNow` strings ("Shift is today," "Balance goes negative before payday") are the closest thing to explainability today, and they're descriptive labels, not the actual score.

---

## 14. Relationships

- **Truth Engine (Prototype):** *should* gate priority — Priority must only rank Truth-permitted candidates. **Today it does not**; the scorers rank whatever candidates the engine builds, with no truth filter. This is a constitutional gap (Chapter 7 §17).
- **Recommendation Engine (Concept):** distinct from Priority. Recommendation decides *what to do*; Priority decides *what rises*. Today the single payday nudge and the engine's rec candidates blur the two — recommendations reuse `whyNowScore` rather than a separate recommendation ranking. Keeping them independent is a planned correction.
- **Living World (Concept):** priority could influence what the world emphasizes; no such link exists.
- **Brain (Prototype):** the oldest open capture can become the "one thing"; brain-fullness is a why-now signal (`activeCaps.length > 3`).
- **Money (Implemented math):** `shortMoney` and bill timing are strong priority inputs (+30 each).
- **Calendar & Obligations (Implemented):** the primary source of time signals; `daysUntil`/overdue drive ranking.
- **Goals (Prototype):** `goalConnected`/`life_priority` feed priority; the top goal is selected for Today.
- **Projects (Concept):** no project priority (no projects).
- **Today (Implemented consumer):** the main consumer — `whyNowScore` most directly picks its "one thing."
- **Voice (Implemented):** Voice phrases the top item; Priority chooses it. Voice never re-ranks.

---

## 15. Priority Rules

- **Priority ranks only what Truth permits** *(planned; not enforced today).*
- **One thing on Today** — never a ranked wall.
- **Why-now over abstract importance** — timeliness is the dominant axis.
- **Deterministic ordering** — same data, same order.
- **No fabricated urgency** — a thing rises only on real signals.
- **Priority informs, never dictates** — it orders attention, not actions.

## 16. Known Unknowns

- **Which scorer "wins" a given surface** is implicit, not designed — a maintenance risk.
- **No confidence weighting** — a shaky item can outrank a certain one.
- **No user intent/pinning** — the user cannot force something to the top.
- **Inconsistent tie-breaks** can make two surfaces disagree about what matters most.
- **No cross-session priority memory** — nothing learns what the user actually attends to (the Belief Engine could feed this, gated off).

## 17. What Does NOT Belong

- **No ranked leaderboard on Today** — one thing.
- **No priority elevating an unsupported claim** — Truth gates first.
- **No fabricated or inflated urgency.**
- **No merging Priority with Recommendation** — three engines stay independent.
- **No opaque ordering** — priority should be explainable.
- **No confidence-blind ranking** (planned correction).

## 18. Dependencies

- Truth Engine *(Prototype)* — should gate candidates.
- Calendar *(Implemented)* — time signals.
- Goals, Brain, Money — candidate sources.

## 19. Missing Dependencies

- **A unified Priority Engine module** *(Concept)* — the central missing piece.
- **A single scoring model** *(Concept)*.
- **Consistent tie-breaking** *(Concept)*.
- **Truth-gating of candidates** *(Concept)*.
- **Confidence as an input** *(Concept)*.
- **Explainability surface** *(Concept)*.
- **Attention budget** *(Concept)*.

## 20. Future Build Order

1. **Consolidate to one scorer.** Make `whyNowScore` the single entry point; route Today's `_score` and event ordering through it. Remove the orphan `perch_core_merge.js` duplicate.
2. **One tie-break rule.** Define and apply consistently (e.g. why-now score, then daysUntil, then life-priority rank).
3. **Truth-gate candidates.** Priority ranks only Truth-permitted items (needs Chapter 7's universal gate).
4. **Add missing dimensions** — risk, momentum, confidence — to the unified model.
5. **Explainability** — attach a score breakdown to each ranked item; build the "why did this rise?" view.
6. **Attention budget** — cap what surfaces by an explicit budget.
7. **User intent/pinning** — let the user influence priority.

Step 1 is the keystone: **one scorer before anything else.**

## 21. Acceptance Tests

**Current (verified):**
- [x] `whyNowScore` ranks engine rec candidates (0–100, clamped).
- [x] `priorityScore` weights by life-priority rank.
- [x] Today's `_score` orders quick-answer candidates independently.
- [x] `PerchEvents` sorts by daysUntil then priority_score.
- [x] The highest `whyNowScore` survivor becomes Today's "one thing."
- [x] Confidence does NOT affect any scorer.
- [x] Truth does NOT gate any scorer.
- [x] No manual pinning/override exists.

**Planned (Concept — not built):**
- [ ] One Priority Engine serves every surface.
- [ ] One consistent tie-break rule.
- [ ] Priority ranks only Truth-permitted candidates.
- [ ] Confidence, risk, and momentum feed the score.
- [ ] Every ranked item is explainable.
- [ ] The user can pin/override.

## 22. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Why-now scorer (canonical seed) | `whyNowScore` in `perch_engine.js` | Prototype |
| Life-priority scorer | `priorityScore` in `perch_core.js` | Prototype |
| Today page-local scorer | `_score`/`_whyNow` in `perch_today_live.html` | Prototype |
| Event timeline sort | `PerchEvents` daysUntil→priority_score | Implemented |
| Orphan duplicate | `perch_core_merge.js` priorityScore | Prototype (dead code) |
| "One thing" selection | `buildMorningBrief` + type precedence | Prototype |
| Tie-breaking | inconsistent across sorts | Prototype |
| Confidence input | — | Concept |
| Truth-gating | — | Concept |
| Unified Priority Engine | — | Concept |
| Explainability surface | `whyNow` strings only | Prototype |
| User pinning/override | — | Concept |
| Attention budget | — | Concept |

## 23. Notes

The honest headline: **Perch has priority scoring, not a Priority Engine.** Four independent scorers — the engine's `whyNowScore`, core's `priorityScore`, Today's page-local `_score`, and the event sort — each decide ordering for their own surface, with a fifth dead copy in an orphan file. They are all reasonable heuristics; none knows about the others. The result mostly works because the surfaces rarely conflict, but "what matters most" is answered by different math depending on where you look.

Answering the audit's direct questions: **`whyNowScore` is the closest to canonical but is not the sole scorer** — there are multiple competing systems. **Confidence does not affect priority. Truth does not gate priority. Users cannot override it. Ranking is deterministic per-scorer but not globally coherent. Priorities are only partially explainable** (the `whyNow` strings). **Recommendations reuse `whyNowScore` rather than computing separate ordering** — which currently blurs the Priority/Recommendation boundary the architecture requires to stay separate. **"The one thing" is decided by `whyNowScore` plus hand-coded type precedence.**

So: **Prototype**, and the most important structural finding is the plurality itself. The keystone fix is consolidation — one scorer, one tie-break, one truth-gated entry point — before adding a single new dimension. Truth answers what is true; Priority answers what deserves attention; Recommendation answers what to do. Today Priority is real but fragmented, and it leaks into Recommendation. Making it one engine, gated by Truth and distinct from Recommendation, is the work.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Prototype. Identified FOUR independent scorers (`whyNowScore`, `priorityScore`, Today `_score`, PerchEvents sort) plus an orphan duplicate — not one engine. Documented that confidence doesn't affect priority, Truth doesn't gate it, no user override, inconsistent tie-breaking, and that Recommendations reuse the priority scorer (blurring the engine boundary). Keystone fix: consolidate to one truth-gated scorer. |
