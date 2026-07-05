# Chapter 9 — Recommendation Engine

> **Chapter:** Recommendation Engine
> **Chapter ID:** PERCH-09
> **Version:** 1.0
> **Status:** Prototype — real, evidence-gated suggestions with a feedback loop exist, but there is **no standalone Recommendation Engine**; recommendations are the top priority-scored candidate, and cross-domain reasoning does not exist
> **Confidence:** 88% — the role and rules are settled; the engine's independence from Priority, and all cross-domain capability, are unbuilt
> **Owner:** Jeff
> **Implementation:** Partial — Life-page suggestions and engine opportunities work and adapt to feedback; they reuse the priority scorer rather than a separate recommendation model
> **Depends On:** Truth Engine *(Prototype — should gate every recommendation)*, Priority Engine *(Prototype — currently conflated with this one)*, Money *(Implemented math)*, Goals *(Prototype)*, Calendar *(Implemented)*, Behavior learning *(Prototype)*
> **Last Updated:** July 4, 2026

*The constitutional triad, restated: **Truth answers "what is true?" Priority answers "what deserves attention?" Recommendation answers "what should the user do?"** These are three separate engines. This chapter is Recommendation — and its honest headline is that Perch does not yet have one as a distinct engine. It has suggestions produced by the priority scorer, which means the Priority/Recommendation boundary the architecture requires is currently blurred.*

---

## 1. Purpose

The Recommendation Engine proposes **actions the user could take** — move money toward a goal, cut a subscription, pick up a shift, handle a bill before payday. It never acts; it suggests, always with visible reasoning and always evidence-gated.

**Primary question this chapter answers (internal):** *Given what's true and what matters, what could the user do about it?*

---

## 2. Vision

The highest form of Perch is a companion that, having understood the user's life, occasionally offers a genuinely useful, well-reasoned move — the right one, at the right time, for the right reason, that the user hadn't quite assembled themselves. The canonical example: *"Tuesday is cool, you're off, rain starts Wednesday — a good day to mow, then enjoy the pool with the family."* One sentence synthesizing weather, calendar, home, and family into a single obvious-in-hindsight suggestion.

That vision is bounded hard by the current truth: **no such synthesis exists.** Today's recommendations are single-domain, evidence-gated suggestions produced by the priority scorer. Cross-domain reasoning — the thing that would make Perch feel like it *thinks* — is entirely Concept, precisely because it needs data (weather, external calendar) Perch cannot ingest.

---

## 3. Design Philosophy

- **Recommend, never act.** Perch proposes; the user disposes. No autonomous action, ever.
- **Every recommendation exposes its reasoning.** A suggestion without a visible "why" does not ship (global law, Chapter 7).
- **Evidence-gated.** A recommendation appears only when its triggering conditions are real (a cushion exists, a goal has room). No suggestion from absent data.
- **Earned, not constant.** Perch is not a nag. It suggests rarely and only when the move is genuinely worth surfacing.
- **Adapts to the user.** A repeatedly-declined kind of suggestion goes quiet. Perch learns what the user doesn't want.
- **Recommendation ≠ Priority.** Priority ranks what rises; Recommendation decides what to *do* about it. They must be separable (they currently aren't — §4).

---

## 4. Current Implementation (repo-verified)

Brutally honest, traced to code.

### 4a. There is no standalone Recommendation Engine
In `perch_engine.js`, `buildMorningBrief` assembles `recCandidates`, scores each with **`whyNowScore`** (the priority scorer, Chapter 8), and sets `recommendation = recCandidates[0]`. **The "recommendation" is literally the top priority-scored candidate.** There is no separate recommendation model, no distinct recommendation ranking, no independent recommendation logic. Priority and Recommendation are the same code path. **Status: Prototype — and a boundary violation the architecture wants corrected.**

### 4b. Real suggestions do exist (and are decent)
Two surfaces produce genuine, evidence-gated suggestions:

**Life page (`perch_life.html`) — the most recommendation-like code:**
- **Payday transfer** — "Move $X toward [goal]" — gated on `target>0 && remaining>0` and a real cushion (`fin.balance>1000`, `safe = min(balance*0.15, remaining/4)`).
- **Subscription cut** — gated on coaching level and subscription count.
- **Extra shift** — opportunity-based.
Each carries an **impact amount** (e.g. "+$65") and a reason. This is the closest thing to a Recommendation Engine in the repo.

**Today (`perch_today_live.html`) — "suggests" + opportunities:**
- The `suggests-card` and engine opportunities surface goal-approach, subscription, holiday-with-family, and free-weekday suggestions, each with a `_whyNow` string ("Subscription savings could close gap toward [goal]," "Free around [holiday] with kids").

**Status: Prototype** — real, useful, single-domain, evidence-gated.

### 4c. Reasoning is partially exposed
Every suggestion carries a `_whyNow`/`whyNow` reason string and (on Life) an impact amount. So recommendations **do** expose reasoning — partially. What's missing is a full, structured "here is the evidence chain" — the reasons are human-written labels, not a derived explanation. **Status: Prototype.**

### 4d. A feedback loop exists
`_lpbSignal(type)` reads behavior preferences: a suggestion type repeatedly declined returns `'avoid'`, and the suggestion is then **skipped entirely** (`transferSignal!=='avoid'`, `subSignal!=='avoid'`). Done/suppressed suggestions are tracked (`sugPrefs.done`, `.suppressed`) and not re-shown. **Perch genuinely adapts** — it stops suggesting what the user keeps rejecting. **Status: Prototype (real, if simple).**

### 4e. Recommendations never auto-execute
Verified: there is **no autonomous action.** `auto_transfer` is a *label for a user's chosen answer* ("Save a little automatically each payday"), not an action Perch performs. Perch writes reminders and updates values the user commits; it never moves money or acts on its own. **Status: Implemented (as a prohibition — the most important safety property).**

### 4f. No cross-domain recommendations
The canonical "mow Tuesday" example does not exist. "Lawn mow" is a maintenance chore with an `urgency` band — never combined with weather (not ingested) or calendar-free-day logic into a synthesized suggestion. **Status: Concept.**

### 4g. No truth-gating
Recommendations are evidence-gated by **hand-written conditions** (`if target>0 && remaining>0…`), not by the Truth Engine. There is no runtime check that a recommendation's claim is Truth-permitted. **Status: Concept** (inherits Chapter 7's editorial-enforcement gap).

---

## 5. Planned Architecture

- A **standalone Recommendation Engine**, independent of Priority.
- **Cross-domain synthesis** — combine signals from multiple domains into one reasoned suggestion.
- **Structured reasoning** — every recommendation carries its full evidence chain, Truth-gated.
- **A recommendation ranking** distinct from the priority score.
- **Richer feedback** — learn not just "avoid this type" but timing, framing, and amount preferences.
All Concept except the single-domain, priority-scored, feedback-adapting seed above.

---

## 6. Recommendation Philosophy

A recommendation is an offer, not an instruction. Perch earns the right to make one by understanding the user's situation and finding a move that is real, timely, and reasoned. It makes them sparingly, explains them always, adapts when refused, and never acts. The measure of a good recommendation is not engagement — it's whether the user thinks *"that's a good idea I hadn't put together."*

---

## 7. Recommendation Types

| Type | Status | Evidence |
|---|---|---|
| **Payday transfer to goal** | Prototype | Life page; gated on cushion + goal room; carries impact |
| **Subscription cut** | Prototype | Life/Today; gated on subs + coaching level |
| **Extra shift / earn** | Prototype | Opportunity captures; feedback-adaptive |
| **Bill-before-payday** | Prototype | Engine rec candidate; `shortMoney` boost |
| **Holiday-with-family** | Prototype | Engine opportunity; goal + free-day |
| **Free-weekday use** | Prototype | Today suggests; off-day detection |
| **Cross-domain (weather+calendar+home)** | Concept | Requires un-ingested data |
| **Health / rest** | Concept | Not modeled |
| **Relationship / people** | Concept | People modeled; no recs |

Single-domain, evidence-gated types are Prototype. Anything requiring synthesis across un-ingested data is Concept.

---

## 8. Recommendation Inputs

- **Money state** — balance, cushion, `remaining` to goal. *(Prototype.)*
- **Goal state** — target, saved, milestone proximity. *(Prototype.)*
- **Time signals** — payday proximity, free days, holidays. *(Prototype.)*
- **Behavior signals** — `_lpbSignal` avoid/accept history. *(Prototype.)*
- **Coaching level** — the user's chosen aggressiveness. *(Prototype.)*
Planned, unused: weather, external calendar, confidence, momentum, cross-domain combinations.

## 9. Recommendation Outputs

- A suggestion with a label, a reason (`whyNow`), often an impact amount, and action buttons (done/snooze/dismiss).
- **No unified recommendation object** — Life suggestions, Today suggests, and engine opportunities each have their own shape.

## 10. Recommendation Lifecycle

*Prototype.* Generated fresh each render → gated by evidence + behavior signal → shown with reasoning → user acts (done/snooze/dismiss) → outcome recorded → future suggestions adapt (`sugPrefs`, `_lpbSignal`). No recommendation history or long-term learning beyond avoid/accept.

---

## 11. Reasoning Model

*Prototype (human-written).* Each recommendation's "why" is an authored string tied to its trigger condition. It is genuine reasoning-exposure but not a derived, structured explanation. Planned: a Truth-gated evidence chain generated from the actual inputs, so the reason is provably the real cause.

## 12. Confidence & Recommendation

*Concept.* Confidence does not affect whether a recommendation appears or how strongly it's phrased. (Belief confidence is gated off; data has no confidence field — Chapter 7.) Planned: low-confidence situations produce softer or withheld recommendations.

## 13. Feedback & Adaptation

*Prototype.* The strongest non-obvious feature: `_lpbSignal` makes Perch **stop suggesting what the user rejects**. A goal_transfer repeatedly avoided → transfer suggestions go silent. This is real, if coarse (type-level avoid/accept). Planned: finer adaptation (timing, amount, framing).

---

## 14. Read Mode / Explore Mode

Recommendations appear **inline on the surfaces they belong to** — the Life suggestions panel, Today's suggests-card and opportunity slots. There is no dedicated Recommendation surface, and there should not be one (recommendations live where their context is). A future **"why this suggestion?"** expansion (the full evidence chain) would be the closest thing to an Explore Mode — Concept.

---

## 15. Relationships

- **Truth Engine (Prototype):** every recommendation must be Truth-permitted and expose reasoning. **Today: evidence-gated by hand, not Truth-gated** — the reasoning is shown but not verified by a runtime gate (Chapter 7 gap).
- **Priority Engine (Prototype):** **currently the same code** — `recommendation = recCandidates[0]` from `whyNowScore`. The architecture requires them separate: Priority ranks attention, Recommendation proposes action. Separating them is a primary planned correction (Chapter 8 §14, §20).
- **Money (Implemented math):** the richest recommendation domain — transfers, cuts, cushion math. Recommendations inherit Money's strict rules (Chapter 2): a "you can afford this" is an evidence-gated Interpretation.
- **Goals (Prototype):** most recommendations serve a goal (fund it, protect it). `remaining`, milestone proximity drive them.
- **Calendar (Implemented):** time signals (payday, free days, holidays) gate timing.
- **Brain (Prototype):** could recommend processing/promoting captures; minimally used today.
- **Projects (Concept):** would recommend the next project move; no projects exist.
- **Behavior learning (Prototype):** the feedback loop — `_lpbSignal`, `sugPrefs`.
- **Living World (Concept):** no recommendation touches the world.
- **Voice (Implemented):** phrases the recommendation warmly and truthfully (e.g. "room to add toward it," not "you should transfer $75"). Voice never strengthens the claim.

---

## 16. Recommendation Rules

- **Never act autonomously** — suggest only. *(Enforced.)*
- **Always expose reasoning.** *(Partial — reasons shown, not structured.)*
- **Evidence-gated** — no recommendation from absent data. *(Enforced by hand.)*
- **Truth-permitted** — no recommendation that makes an unsupported claim. *(Planned — not runtime-gated.)*
- **Adapt to refusal** — go quiet on rejected types. *(Enforced via `_lpbSignal`.)*
- **Sparing, not nagging.** *(Enforced by gating + suppression.)*
- **Distinct from Priority.** *(Violated today — same code path.)*
- **No financial advice beyond the user's own data** — Perch surfaces the user's situation and options, it does not advise on regulated decisions (Chapter 2 §14).

## 17. Known Unknowns

- **Whether a recommendation is actually good** — Perch gates on evidence, not on outcome; it can't know if the move truly helps.
- **The Priority/Recommendation conflation** — because they share code, a change to priority silently changes recommendations.
- **No cross-domain awareness** — Perch can't combine weather+calendar+home; the flagship recommendation is impossible without ingestion.
- **No confidence weighting** — a shaky situation gets the same recommendation strength as a certain one.
- **Coarse feedback** — Perch learns type-level avoid, not nuance.

## 18. What Does NOT Belong

- **No autonomous action** — the inviolable rule.
- **No recommendation without visible reasoning.**
- **No recommendation from data Perch lacks** (no fake cross-domain synthesis).
- **No nagging** — sparing and suppressible.
- **No merging with Priority** (planned separation).
- **No regulated financial advice** — situation and options, not directives.
- **No confidence-blind over-strong phrasing.**

## 19. Dependencies

- Truth Engine *(Prototype)* — should gate every recommendation.
- Priority Engine *(Prototype)* — currently conflated; must be separated.
- Money, Goals, Calendar — the domains recommendations serve.
- Behavior learning *(Prototype)* — the feedback loop.

## 20. Missing Dependencies

- **A standalone Recommendation Engine** *(Concept)* — separate from Priority.
- **Cross-domain synthesis** *(Concept)* — needs weather + external calendar ingestion.
- **Truth-gating of recommendations** *(Concept)* — needs Chapter 7's universal gate.
- **Structured reasoning / evidence chains** *(Concept)*.
- **Confidence-aware recommendation** *(Concept)*.
- **Richer feedback learning** *(Concept)*.

## 21. Future Build Order

1. **Separate Recommendation from Priority.** Give recommendations their own ranking distinct from `whyNowScore`. *(Keystone — ends the boundary violation.)*
2. **Truth-gate recommendations.** Route each through the (generalized) Truth gate so its claim is verified, not just its trigger.
3. **Structured reasoning.** Generate the "why" from the actual inputs, not a hand-written string.
4. **Unify the recommendation object** across Life/Today/engine.
5. **Confidence-aware strength.** Soften or withhold on low-confidence situations.
6. **Cross-domain synthesis** — only after weather/calendar ingestion exists. The flagship, built last.
7. **Richer feedback** — timing/amount/framing adaptation.

Step 1 is the keystone: **separate the engine from Priority before adding anything.**

## 22. Acceptance Tests

**Current (verified):**
- [x] `recommendation = recCandidates[0]` — top priority-scored candidate (no separate engine).
- [x] Life suggestions (transfer/subscription/shift) are evidence-gated and carry impact + reason.
- [x] Every suggestion exposes a `whyNow` reason string.
- [x] `_lpbSignal` suppresses repeatedly-declined suggestion types.
- [x] Done/suppressed suggestions are not re-shown.
- [x] No recommendation ever auto-executes.
- [x] No cross-domain (weather+calendar) recommendation exists.
- [x] Recommendations are not Truth-gated (evidence-gated by hand only).

**Planned (Concept — not built):**
- [ ] Recommendation Engine independent of Priority.
- [ ] Every recommendation Truth-gated with a structured evidence chain.
- [ ] Confidence affects recommendation strength.
- [ ] Cross-domain synthesis (post-ingestion).
- [ ] Unified recommendation object.

**Always enforced:**
- [ ] Perch never acts autonomously.
- [ ] No recommendation without visible reasoning.
- [ ] No recommendation from absent data.

## 23. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| "Recommendation" = top rec candidate | `recommendation = recCandidates[0]` in `perch_engine.js` | Prototype |
| Rec scoring (shared w/ Priority) | `whyNowScore` | Prototype (conflated) |
| Life suggestions | `perch_life.html` (transfer/subscription/shift) | Prototype |
| Today suggests + opportunities | `renderSuggests`, `_whyNow` in `perch_today_live.html` | Prototype |
| Reasoning strings | `whyNow`/`_whyNow` | Prototype |
| Feedback loop | `_lpbSignal`, `sugPrefs` | Prototype |
| No auto-execution | (verified absent) | Implemented (prohibition) |
| Truth-gating | — | Concept |
| Cross-domain synthesis | — | Concept |
| Standalone engine | — | Concept |
| Confidence-aware recs | — | Concept |

## 24. Notes

The honest headline: **Perch recommends, but has no Recommendation Engine.** What exists is genuinely more than nothing — evidence-gated, single-domain suggestions (money transfers, subscription cuts, shift pickups) that carry impact amounts and reasons, and — notably — a real feedback loop that makes Perch stop suggesting what the user keeps declining. That adaptation is the most impressive part and is easy to miss.

But three structural truths keep it at **Prototype**: (1) recommendations *are* the top priority-scored candidate — Priority and Recommendation share one code path, violating the architecture's requirement that they be separate engines; (2) recommendations are evidence-gated by hand, not Truth-gated by the (nonexistent) universal gate; and (3) the flagship capability — cross-domain synthesis like the "mow Tuesday" example — is impossible without weather and calendar data Perch cannot ingest, so it is honestly Concept.

The one safety property that is fully solid: **Perch never acts.** Every recommendation is a suggestion the user accepts or declines; `auto_transfer` is a user's choice, not autonomous behavior. That prohibition is the most important thing this engine gets right today.

The keystone for the future is separation: give Recommendation its own ranking, distinct from Priority, then Truth-gate it. Only after that — and after ingestion — does the cross-domain vision become buildable. Truth answers what is true; Priority answers what deserves attention; Recommendation answers what to do. Today the third borrows the second's brain and skips the first's gate. Fixing that is the work.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Prototype. Verified no standalone engine — `recommendation = recCandidates[0]` from `whyNowScore` (conflated with Priority). Documented real evidence-gated Life/Today suggestions with impact + reasoning, and a genuine `_lpbSignal` feedback loop that suppresses declined types. Confirmed recommendations never auto-execute (key safety property), are not Truth-gated, and cross-domain synthesis is Concept (needs un-ingested data). Keystone fix: separate Recommendation from Priority, then Truth-gate. |
