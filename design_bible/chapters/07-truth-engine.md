# Chapter 7 — Truth Engine

> **Chapter:** Truth Engine
> **Chapter ID:** PERCH-07
> **Version:** 1.0
> **Status:** Prototype — a real classification/confidence/permission gate exists but only inside the Belief Engine; there is **no unified runtime Truth Engine**. Most truth enforcement is doctrine applied by hand.
> **Confidence:** 92% — the constitutional rules are settled and proven in doctrine; the runtime engine that enforces them universally is largely unbuilt
> **Owner:** Jeff
> **Implementation:** Partial — doctrine (`perch_truth.md`) is complete and applied editorially; runtime enforcement exists only for beliefs (`perch_beliefs.js`)
> **Depends On:** *(nothing — every other engine depends on this one)*
> **Last Updated:** July 4, 2026

*This chapter is not user-facing. It is the constitutional law of Perch: the rules that determine what Perch is allowed to say. Every other engine — Priority, Recommendation, Belief, Money, Calendar, Goals, Voice — is downstream of this chapter. The honest headline, stated up front: **the Truth Engine today is a complete body of law with only partial runtime enforcement.** The doctrine is authoritative and applied; the machine that would enforce it on every sentence does not yet exist as a single engine.*

---

## 1. Purpose

The Truth Engine governs **what Perch may claim, at what strength, with what evidence.** It is the gate every statement must pass before reaching the user. Its job is singular: ensure Perch never says something it cannot support.

**Primary question this chapter answers (internal):** *Is Perch allowed to say this, and how strongly?*

---

## 2. Vision

Perch's entire value rests on being believed. A single fabricated claim — a guessed emotion, an invented number, an overstated confidence — costs trust that does not return cheaply. The Truth Engine is the vision of that trust made mechanical: a runtime layer through which every candidate statement flows, emerging classified (Fact / Derived Fact / Interpretation / Recommendation / Prediction / Unknown), confidence-scored, source-attributed, and either permitted at its supported level, downgraded, or withheld.

The destination is that **no sentence reaches the user without passing the gate** — not by editorial discipline, but by code. Today that gate exists for beliefs only; the vision is to make it universal.

---

## 3. Design Philosophy

- **Truth outranks convenience.** When a truthful statement is less satisfying than a confident guess, truth wins. Always.
- **Perch never invents certainty.** Absent evidence, Perch stays silent, asks, or drops a level.
- **Every claim knows its evidence.** A statement that cannot name its source does not ship.
- **Classification before phrasing.** *What kind* of claim this is (Fact vs Prediction) is decided before *how* it's worded. The Voice Engine phrases; the Truth Engine authorizes.
- **Disagreement is surfaced, never silently resolved.** Two conflicting sources produce an explained conflict, not a hidden pick.
- **The gate is one-directional and final.** Nothing routes around it.

---

## 4. Current Implementation (repo-verified)

Brutally honest, traced to code.

### 4a. There is no unified Truth Engine
No module classifies every statement Perch makes. The Bible's global laws (Statement Classification, Source Lineage, Trust rules) live in `perch_truth.md` and the Bible README as **doctrine**, and are applied **editorially** — by hand, in copy, during the truth passes (Chapter 1). This is real and effective, but it is documentation-enforced, not runtime-enforced.

**Status: Prototype** — the law exists and is applied; the engine does not exist as one thing.

### 4b. Runtime truth logic exists — but only for beliefs
The only place truth classification runs as code is the **Belief Engine** (`perch_beliefs.js`):
- **`truth_level`** on every belief (Fact / Inference / Pattern / Identity / Reflection). Real field.
- **`LEVEL_THRESHOLD`** — per-level confidence bars (fact 1.0, inference 0.5, pattern 0.6, identity 0.75, reflection 0.8).
- **`evaluate()`** — the permission gate: returns `permitted-internal`, or `denied` (below threshold, or Identity/Reflection refused outright).
- **`mayEmitToUI()`** — returns **`false`, always.** Nothing a belief classifies ever reaches the user.

So a working classification-and-permission pipeline exists, scoped to internally-formed beliefs, and it emits nothing. **Status: Prototype (gated off).**

### 4c. Confidence is computed — only for beliefs
`_confidenceFromEvidence(count, consistency)` — a saturating curve capped at 0.95 (patterns never reach Fact-certainty). Decay over time (`_ageBeliefs`), erosion on contradiction (`_recordContradiction`). **Real confidence math — but only beliefs have it.** Bills, balances, dates, goals carry **no confidence field.** *Status: Prototype (belief-only).*

### 4d. Provenance is tracked — shallowly
- **Seed vs. user:** `seed: true` vs `user_created`/`user_owned`, distinguished by `_isSeedItem`. Real.
- **Source tag:** captures carry `source` (e.g. `perch_input`). Real.
- **Edit tracking:** `last_edited` timestamp on some records. Real.
- **What's missing:** a full **source-lineage chain** in code (the "Projected → Snapshot → Checking → Manual Entry" chains in the Bible are documentation, not a runtime provenance graph). *Status: Prototype.*

### 4e. Disagreement detection — only for beliefs
`_recordContradiction`/`contradicted_by[]` holds conflicts when observed behavior contradicts a belief — kept, never auto-resolved. **But there is no conflict detection between data sources** (e.g. two account balances, a manual vs. a future bank figure). The Bible's "if two sources disagree, explain it" law has **no runtime implementation** outside beliefs. *Status: Prototype (belief-only).*

### 4f. Unknown states — represented ad hoc, not unified
Unknowns appear as `null` (dates, `birth_year`), the `paydayStale` flag, and `intel()` returning `{daysUntil:null, isOverdue:false,...}` for missing dates. There is **no unified "Unknown" type** or explicit unknown-state model. Absence is handled case by case. *Status: Prototype.*

### 4g. Beliefs never become facts
`mayEmitToUI()` → false, and Identity/Reflection are refused by the gate even at 0.99. **No belief is ever promoted to a fact or surfaced.** This is correct per doctrine and is the one rule fully enforced in code. *Status: Implemented (as a prohibition).*

---

## 5. Planned Architecture

The destination:
- A **single Truth Engine module** every statement passes through, not just beliefs.
- **Universal classification** — Fact / Derived Fact / Interpretation / Recommendation / Prediction / Unknown assigned to every candidate output.
- **A runtime provenance graph** — real source lineage, queryable.
- **Cross-source disagreement detection** — conflicts detected and surfaced, not just within beliefs.
- **A unified Unknown type** — explicit representation of what Perch doesn't know.
- **The universal permission gate** — the Belief Engine's `evaluate()` generalized to all output.
All Concept or Planning except the belief-scoped pieces above.

---

## 6. Truth Philosophy

Perch may describe its own data; it may not describe the user's interior. It may state what it can source; it must stay silent on what it cannot. Certainty is a privilege the evidence buys — every level above Fact must be earned. When in doubt, Perch drops a level or says nothing. This philosophy is complete in `perch_truth.md`; this chapter is its architectural expression.

---

## 7. Statement Classification

The six kinds every statement is (global law, Bible README). Runtime status noted per kind.

- **Fact** — directly stored/observed ("balance: $2,183"). *Runtime: not classified as such except implicitly; no Fact-tagging engine.*
- **Derived Fact** — arithmetic over Facts ("bills before payday: $1,042"). *Runtime: computed (e.g. `projected`), but not labeled as a Derived Fact in code.*
- **Interpretation** — judgment from Facts ("you're covered"). *Runtime: produced in copy, not tagged.*
- **Recommendation** — suggested action ("room to add toward the goal"). *Runtime: the single payday nudge, evidence-gated by hand.*
- **Prediction** — future claim ("at this pace, ~June 2027"). *Runtime: `projectDate()` computes it; labeled as estimate only by copy convention.*
- **Unknown** — Perch doesn't know. *Runtime: ad-hoc nulls; no unified type.*

**Honest summary:** classification is **fully specified in doctrine, applied editorially, and computed-but-untagged in code.** Only beliefs carry an explicit truth-level field.

---

## 8. Confidence Model

*Belief-scoped (Prototype).* `_confidenceFromEvidence` — saturating, capped 0.95, consistency-weighted, decaying, contradiction-eroded. **No other data type has confidence.** A bill, a balance, a goal percentage are treated as certain (they're user-entered Facts) — which is correct, but means confidence is not a universal property. Planned: a confidence value on every classified statement.

## 9. Source Lineage

*Documentation-complete, runtime-partial.* The lineage chains (Chapters 2, 4, 6) are authoritative doctrine. In code, provenance is three shallow signals (`seed`/`user_created`, `source`, `last_edited`) — not a queryable lineage graph. Planned: runtime lineage every figure can produce on demand.

## 10. Provenance

*Prototype.* Seed-vs-user is the strongest runtime provenance (`_isSeedItem`), and it matters most for v0.5 (demo data must never read as real). Source tags and edit timestamps exist. A full provenance model (who/what/when/from-where for every value) is Concept.

---

## 11. Truth Lifecycle

How a truth moves over time. **Belief-scoped only:**
- **Truth Decay** — beliefs lose confidence when unreinforced (`_ageBeliefs`); permanent-weight never decays. *Implemented for beliefs.*
- **Truth Promotion** — a belief crossing a threshold *would* become eligible to surface — but `mayEmitToUI()` blocks it. No promotion occurs. *Gated.*
- **Beliefs → Facts** — never (§4g). *Enforced.*

For non-belief data (bills, balances), there is **no lifecycle** — a value is current until the user edits it. No decay, no staleness beyond `paydayStale`. *Concept.*

## 12. Truth Conflicts

- **Within beliefs:** `_recordContradiction` holds conflicts, never auto-resolves. *Implemented.*
- **Between data sources:** **not detected.** If a manual balance and a future bank feed disagreed, nothing would catch it today. The "explain the disagreement" law is doctrine awaiting a runtime home. *Concept.*

### Conflicting Sources
*Concept (except beliefs).* Planned: detect when two sources claim different values for the same fact; surface both with their provenance; never silently choose (Bible global law).

### Missing Data
*Prototype.* Represented as `null`/absence; handled case-by-case (silent goal beat, "nothing on Perch's calendar"). No unified missing-data policy in code — enforced by copy discipline.

### Incomplete Data
*Prototype.* E.g. checking-only projection (Chapter 2 B2) — incomplete but not labeled as such in code. The v0.5 plan flags fixing this. *Concept for systematic handling.*

---

## 13. Manual Overrides

*Prototype.* User-entered data is authoritative over seed data (`_isSeedItem` distinguishes; `startRealLife`/`clearSeedData` zeroes demo). Captures are editable before commit (correction flow, Chapter 6). `last_edited` records edits. There is **no imported data yet** (no integrations), so "manual overrides imported" is not yet a live scenario — when integrations arrive, the rule (manual wins, or conflict surfaced) is doctrine, unbuilt.

## 14. Seed Data

*Implemented.* Every seed record carries `seed: true`; `_isSeedItem` gates it; the seed banner warns while demo data is active; `startRealLife` clears it. This is the **most complete provenance distinction in the repo** and is essential to v0.5 trust (demo numbers must never masquerade as real).

## 15. External Data

*Concept.* No external data exists (no banking, calendar, email). When it arrives, it enters as a distinct provenance class, timestamped, never overwriting manual truth silently. Unbuilt.

## 16. Internal Data

*Prototype.* Internally-derived data (beliefs, derived facts like `projected`) is computed. Only beliefs are truth-classified; derived facts are computed but untagged.

---

## 17. Engine Interfaces

The Truth Engine is the root dependency. How it relates to each engine:

- **Priority Engine (Prototype):** ranks what rises, but priority must never elevate an unsupported claim. Today the scorer has no truth-awareness; a future Truth Engine would filter candidates before Priority ranks them.
- **Recommendation Engine (Concept):** every recommendation must expose reasoning and pass the gate. Today's single payday nudge is hand-gated.
- **Brain (Prototype):** captures preserve source truth (`original_text`); classification of a capture's *type* is an editable Interpretation. Belief collection runs here, emission gated.
- **Money (Implemented math):** the strictest domain — every figure a sourced Fact/Derived Fact, no confidence claimed, disagreement handling required (Chapter 2). Enforced editorially.
- **Calendar (Prototype):** dates are Facts only when sourced; "free" is an Interpretation bounded by Known Unknowns (Chapter 3).
- **Goals (Prototype):** progress is a Derived Fact; projection is a Prediction that must expose its assumption (Chapter 4).
- **Projects (Concept):** inherits all rules when built.
- **Living World (Concept):** may only render permitted, sourced truth — a world element must correspond to a real belief/fact, never invented scenery.
- **Voice (Implemented):** phrases what the Truth Engine authorizes. The division is constitutional: **Truth decides what may be said; Voice decides how.** Voice never upgrades a claim's certainty.

---

## 18. Read Mode / Explore Mode

The Truth Engine has **no user-facing surface** — it is infrastructure. It has no Read or Explore Mode of its own. (A future debug/"why did Perch say this?" provenance inspector would be its only surface — Concept.) Its output is visible only as the *restraint* in every other page: the silent goal beat, the "on Perch's calendar" hedge, the absent guess.

---

## 19. Truth Rules (the constitution)

The absolutes, from `perch_truth.md`, that every engine inherits:
- Perch may describe its own data, never the user's interior.
- No claim above its evidence level (no Inference-as-Fact, no Pattern-as-Identity).
- No guessed emotions, motivation, priorities, or intent.
- No fabricated memories, no "always"/"never," no overstated confidence.
- When evidence is absent: stay silent, ask, or drop a level.
- Never invent certainty. If sources disagree, explain — don't choose.
- Beliefs never silently become facts.

## 20. Known Unknowns

- **The gate is not universal.** Most statements are truth-checked by editorial discipline, not code — so a careless future edit *could* introduce an unsupported claim that no runtime gate catches. This is the single biggest structural risk in Perch's trust model.
- **No cross-source conflict detection** outside beliefs.
- **No universal confidence or provenance** — only beliefs and seed-flags.
- **Derived facts are untagged** — `projected` is computed but not marked as a Derived Fact in code.

## 21. What Does NOT Belong

- **No claim without evidence** — the prime directive.
- **No runtime path around the gate** (when the gate becomes universal).
- **No belief-to-fact promotion.**
- **No silent conflict resolution.**
- **No confidence inflation for warmer copy.**
- **No interior-state claims, ever.**

## 22. Dependencies

- **None upstream.** The Truth Engine is the root. Every other engine depends on it.
- Doctrine: `perch_truth.md` (complete), Bible README global laws (complete).

## 23. Missing Dependencies

- **A unified Truth Engine module** *(Concept)* — the central missing piece.
- **Universal statement classification** *(Concept)*.
- **Runtime provenance/lineage graph** *(Concept)*.
- **Cross-source disagreement detection** *(Concept)*.
- **Unified Unknown type** *(Concept)*.
- **Generalized permission gate** *(Concept — the belief `evaluate()` is the seed)*.

## 24. Future Build Order

1. **Generalize the permission gate.** Lift `evaluate()` out of the Belief Engine into a Truth Engine that any statement can call. *(The seed already exists.)*
2. **Tag derived facts.** Mark computed values (`projected`, goal `pct`) with their class and inputs — the first universal classification.
3. **Runtime provenance.** Give every figure a queryable source chain.
4. **Cross-source conflict detection.** Implement "explain the disagreement" for data, not just beliefs (activates when integrations arrive).
5. **Unified Unknown type.** Replace ad-hoc nulls with an explicit unknown state.
6. **Universal gate.** Route all output through the Truth Engine — the constitutional endpoint.

Each step independently testable; step 1 is the keystone.

## 25. Acceptance Tests

**Current (verified):**
- [x] Beliefs carry `truth_level` and `confidence`; thresholds enforced by `evaluate()`.
- [x] Confidence is saturating, capped <1.0, decays, erodes on contradiction.
- [x] `mayEmitToUI()` returns false; no belief surfaces; no belief becomes a fact.
- [x] Seed data is flagged and separable (`_isSeedItem`, `startRealLife`).
- [x] Belief contradictions are held, never auto-resolved.
- [x] Captures preserve `original_text` (source truth).

**Planned (Concept — not built):**
- [ ] Every statement (not just beliefs) is classified at runtime.
- [ ] Every figure can produce its source lineage.
- [ ] Cross-source disagreements are detected and surfaced.
- [ ] A unified Unknown type exists.
- [ ] All output routes through one permission gate.

**Always enforced:**
- [ ] No claim exceeds its evidence level.
- [ ] No interior-state claim ships.
- [ ] Certainty is never inflated for tone.

## 26. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Truth doctrine | `perch_truth.md`, Bible README laws | Implemented (as doctrine) |
| Belief truth-levels | `truth_level`, `TRUTH.*` in `perch_beliefs.js` | Prototype (belief-only) |
| Confidence math | `_confidenceFromEvidence` | Prototype (belief-only) |
| Permission gate | `evaluate()`, `mayEmitToUI()` | Prototype (gated off) |
| Truth decay | `_ageBeliefs` | Prototype (belief-only) |
| Contradiction handling | `_recordContradiction`/`contradicted_by` | Prototype (belief-only) |
| Provenance: seed vs user | `_isSeedItem`, `seed`/`user_created` | Implemented |
| Provenance: source tag | `source` on captures | Prototype |
| Provenance: edits | `last_edited` | Prototype |
| Derived-fact tagging | — | Concept |
| Universal classification | — | Concept |
| Runtime lineage graph | — | Concept |
| Cross-source conflict | — | Concept |
| Unified Unknown type | — | Concept |
| Unified Truth Engine | — | Concept |

## 27. Notes

The honest headline: **the law is complete; the court is not built.** `perch_truth.md` and the Bible's global laws are a full, authoritative constitution, and they are genuinely *applied* — the truth passes on Today removed real unsupported claims, and Money/Calendar/Goals copy visibly obeys the rules. But that enforcement is **editorial, by hand.** The only *runtime* truth machinery is inside the Belief Engine: a real classification-confidence-threshold-gate pipeline, correctly built, scoped to beliefs, and emitting nothing.

So the Truth Engine is **Prototype**: more than doctrine (there's working belief-scoped code), far less than a unified engine (nothing classifies or gates general output). The single most important finding for the whole project's trust model: **because enforcement is mostly editorial, a careless future edit could introduce an unsupported claim with no runtime gate to catch it.** That is the argument for building the universal gate — generalizing the Belief Engine's `evaluate()` — as the first real Truth Engine work.

Every other engine depends on this chapter. That dependency is real in doctrine and aspirational in code. Closing that gap — making the constitution executable — is the most important architectural investment Perch can make, and the build order names its keystone: lift the gate out of beliefs and make it universal.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Prototype. Verified runtime truth logic (truth_level, confidence, thresholds, permission gate, contradiction handling) exists ONLY in `perch_beliefs.js`, belief-scoped, emission gated off. Confirmed no unified Truth Engine; most enforcement is editorial doctrine (`perch_truth.md`). Seed provenance Implemented; derived-fact tagging, universal classification, runtime lineage, cross-source conflict, unified Unknown type all Concept. Flagged editorial-only enforcement as the key structural trust risk. |
