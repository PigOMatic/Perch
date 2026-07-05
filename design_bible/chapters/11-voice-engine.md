# Chapter 11 — Voice Engine

> **Chapter:** Voice Engine
> **Chapter ID:** PERCH-11
> **Version:** 1.0
> **Status:** Prototype — real voice logic exists, but split across **three independent systems** that don't share a code path; the named `PerchVoice` engine powers only the learning conversation, not Today.
> **Confidence:** 88% — voice principles are settled and proven in copy; the unified engine that would own all phrasing is unbuilt
> **Owner:** Jeff
> **Implementation:** Partial — `perch_voice.js` (relationship voice), the engine's `buildOpening`/tone system (Today's copy), and a wording-style selector are three separate voice paths
> **Depends On:** Truth Engine *(Prototype — Voice must never exceed what Truth permits)*, Priority Engine *(Prototype — Voice phrases the top item)*, Recommendation Engine *(Prototype)*, People/Learning *(Implemented)*
> **Last Updated:** July 5, 2026

*In the engine chain — Truth → Priority → Recommendation → Voice → Pages — Voice is the fourth link. It answers one question: **how should this be said?** Voice never decides what is true (Truth), what matters (Priority), or what to do (Recommendation). It only chooses the words. The honest headline: Perch has strong voice *principles* and three separate voice *implementations* that were built at different times and never unified. `PerchVoice`, the module that sounds like "the Voice Engine," actually phrases only the learning chat — not the morning brief most users read.*

---

## 1. Purpose

The Voice Engine governs **how Perch phrases what the other engines have already decided to say** — warm, truthful, relationship-aware, never exceeding the certainty the evidence supports.

**Primary question this chapter answers (internal):** *Given a permitted, prioritized thing to say, what exact words does Perch use?*

---

## 2. Vision

Perch should sound like a thoughtful person who knows your life and respects your time — never a chatbot, never a dashboard label, never a cheerleader. The same fact ("a bill is due") should be sayable in the register the moment calls for: plain when you're busy, warmer when there's room, quieter when the news is heavy. Voice is what turns correct information into something a person actually wants to read at 6am.

The vision is a single Voice Engine that every surface routes through, so Perch sounds like *one* consistent character everywhere — the brief, the recall, the recommendation, the world. The current reality (§4) is three voices that happen to share taste but not code.

---

## 3. Design Philosophy

From the established voice doctrine (Chapters 1, 3, 4, 6) and `perch_voice.js`:
- **Observations, not instructions.** "This lands tomorrow," not "Pay this." Buttons command; sentences notice.
- **The strongest note says less.** Subtraction over addition (Chapter 1's subtraction pass).
- **Names over titles; relationship phrasing only when natural.**
- **No flattery, no filler.** No "please provide," no "tell me more about."
- **No two consecutive identical phrasings** (`_lastSaid` no-repeat).
- **Voice never upgrades certainty.** It phrases a Prediction as a prediction, an Interpretation as an interpretation — it may not make a hedge sound like a fact (the constitutional Truth→Voice boundary).
- **Tone matches the moment, never manufactured.** Warmth is earned by context, not sprayed on.

---

## 4. Current Implementation (repo-verified)

Brutally honest. **There are three independent voice systems.**

### Voice System 1 — `PerchVoice` (`perch_voice.js`) — relationship voice, learning-only
A real, well-built relationship-aware voice module:
- **`say(intent, context)`** with 9 intents: `ask_about_person`, `ask_about_family`, `ask_about_interest`, `ask_about_role`, `confirm_memory_saved`, `recall_answer`, `confidence_summary`, `followup_interest`, `ask_missing_area`.
- **~150 banked variations** across the intents.
- **Reference helpers:** `personRef`, `relationshipRef`, `positionRef` (oldest/youngest/teenager from `birth_year`), `confidencePhrase`, `compareAreas`.
- **No-repeat:** `_lastSaid[intent]` prevents back-to-back duplicates.
- **The catch:** `PerchVoice` is called **only from `perch_learn.js`** (3 sites — memory-save confirm, recall answer, ask-about-person). **It does not phrase Today's brief, the hero, recommendations, or any main surface.** The module that *sounds* like the Voice Engine governs only the getting-to-know-you conversation. **Status: Implemented (but narrowly scoped).**

### Voice System 2 — engine tone/opening (`perch_engine.js`) — Today's actual voice
Today's morning copy — the hero, the opening, the top-priority line — is produced here, **not** by `PerchVoice`:
- **`determineTone(context)`** → a tone (Calm / Opportunity / others).
- **`buildOpening(context, tone, topGoal)`** → the hero/opening line, with tone-conditioned variations.
- **`buildTopPriority`, `buildMorningBrief`** → the note's body.
This is a **separate** voice system with its own phrasing and tone logic. It is what most users actually read. **Status: Implemented (and it's the primary voice), but disconnected from System 1.**

### Voice System 3 — wording-style selector (`perch_today_live.html`) — A/B phrasing
A third path chooses *which wording* to show for an item based on what earns action:
- Stored in `perch_behavior_prefs.message_styles` — **pure counts, no AI.**
- `_shownStyle` (e.g. `'direct'`) picks a phrasing per item (bill_due, etc.), preferring styles that get `done`, avoiding `snoozed`/`dismissed`.
- The chosen style is logged (`_logAction(recType, actionType, styleUsed)`) and feeds the Belief Engine's `style_response_pattern` (gated).
**Status: Prototype (behavioral phrasing selection).**

### The coordination problem
- **Three systems, three files.** Relationship voice (`perch_voice.js`), engine tone (`perch_engine.js`), wording styles (`perch_today_live.html`).
- **`PerchVoice` ≠ the main voice.** The named engine is the *least* used of the three on primary surfaces.
- **No shared vocabulary, tone model, or no-repeat across systems.** Each has its own.
- **Truth boundary held editorially, not by a Voice gate.** The truth passes (Chapter 1) enforced "no certainty upgrade" by hand, not through a runtime Voice-checks-Truth step.

**Overall status: Prototype.** Real, effective voice — but not one engine.

---

## 5. Planned Architecture

- **One Voice Engine** every surface routes through — brief, recall, recommendation, world.
- **A unified tone model** (the engine's `determineTone`) feeding all phrasing.
- **Relationship references** (`PerchVoice`'s `personRef` etc.) available everywhere, not just learning.
- **Wording-style adaptation** folded in as one input, not a separate path.
- **A runtime Truth→Voice check** — Voice provably never exceeds the permitted certainty.
All Concept except the three working-but-separate pieces above.

---

## 6. Voice Philosophy

Voice is the servant of the engines above it. It is given a permitted, prioritized, possibly-recommended thing to say, and its only freedom is *wording* — register, warmth, variation, reference. It may make Perch sound human; it may never make Perch sound *more certain than it is*. The best voice is often the shortest: it trusts the user, says the true thing plainly, and stops.

---

## 7. Advice vs Alert vs Insight vs Statement (register model)

*Partially implemented via tone.* The engine's tone system is the closest thing to a register model — Calm vs Opportunity shift the phrasing. A full model (a plain **statement**, a warmer **insight**, a time-sensitive **alert**, an offered **suggestion** — each with its own voice) is Concept. Today, register is tone-driven and single-system (engine only).

## 8. Voice Model

*Current:* three shapes — intent+bank (`PerchVoice`), tone+opening (engine), style-count (wording). *Planned:* one voice call — `voice(statement, {class, confidence, tone, person, register})` — returning the phrased line, Truth-checked. Unbuilt.

## 9. Voice Inputs

- **Statement class & confidence** (from Truth) — *should* shape hedging; today only editorial.
- **Tone** (engine `determineTone`) — Calm/Opportunity/etc. *Implemented.*
- **Person/relationship** (`PerchVoice` refs) — *Implemented, learning-only.*
- **Behavioral style** (`message_styles`) — *Prototype.*
- **No-repeat history** (`_lastSaid`) — *Implemented, per-system.*

## 10. Voice Outputs

A short, natural line. **No unified output** — each system emits its own string.

## 11. Voice Lifecycle

*Prototype.* Phrasing is chosen fresh per render. The wording-style path has memory (counts persist, feed beliefs); the other two are stateless beyond per-session no-repeat.

---

## 12. Tone Model

*Implemented (engine).* `determineTone` derives a tone from context (calm when nothing's urgent, opportunity when there's room/a goal/holiday). Tone conditions the opening line. This is Perch's most-developed voice component and correctly lives closest to the engine chain — but it drives only System 2.

## 13. Relationship-Aware Voice

*Implemented (learning-only).* `PerchVoice`'s `personRef`/`relationshipRef`/`positionRef` produce natural references ("your oldest," "Emma") scaled by how much Perch knows. Excellent, and stranded in the learning flow — not available to the brief or recommendations.

## 14. Behavioral Voice Adaptation

*Prototype.* The wording-style selector learns which phrasings earn action and prefers them — a real, if narrow, adaptation. Feeds `style_response_pattern` in the Belief Engine (gated).

## 15. No-Repeat / Variation

*Implemented, fragmented.* `_lastSaid` (PerchVoice) and style rotation (wording) each avoid repetition within their own system; there's no global anti-repetition across all voice output.

---

## 16. Read Mode / Explore Mode

Voice has **no surface of its own** — it is expressed *through* every page's words. Its quality is visible only as how Perch sounds. A future "why these words?" or tone-preference control would be its only surface — Concept. (A user-facing tone/style preference is a natural v0.6+ Settings item — Chapter 19 territory.)

---

## 17. Relationships

- **Truth Engine (Prototype):** the hard boundary — Voice may never phrase a claim above its permitted certainty. Enforced editorially today (the truth passes), not by a runtime Voice→Truth check. This is the most important unbuilt link.
- **Priority Engine (Prototype):** Priority picks the item; Voice phrases it. Voice never re-ranks.
- **Recommendation Engine (Prototype):** Voice phrases suggestions warmly ("room to add toward it," not "transfer $75") and must show the reasoning Recommendation provides.
- **Pages (Implemented consumers):** pages receive phrased lines and present them; they don't re-word (the Pages layer, last in the chain).
- **Brain (Prototype):** `PerchVoice` phrases recall/confirmation in the learning flow.
- **People/Learning (Implemented):** the source of relationship references.
- **Money / Calendar / Goals:** each has domain voice rules (Chapters 2–4) that Voice must honor — money plainness, "on Perch's calendar" hedging, goal dream-first phrasing.
- **Living World (Concept):** would share the engine's tone (a somber tone dims the sky) — no link today.

---

## 18. Voice Rules

- **Never exceed permitted certainty** (Truth boundary).
- **Observations, not commands.**
- **Shortest true phrasing wins.**
- **No flattery, no filler, no manufactured urgency.**
- **No back-to-back repetition.**
- **Names/relationship refs only when natural.**
- **Tone matches the moment.**
- **Voice phrases; it never decides what/whether to say** (that's Truth/Priority/Recommendation).

## 19. Known Unknowns

- **Which system speaks depends on the surface**, implicitly — a maintenance risk identical to Priority's plurality.
- **No runtime guarantee** that Voice never over-claims — it's editorial.
- **Relationship voice is stranded** in learning; the brief can't use it.
- **No global anti-repetition** across systems.
- **Tone is inferred, not chosen** — the user can't set a preferred register yet.

## 20. What Does NOT Belong

- **No certainty inflation** for a warmer sentence — the cardinal Voice sin.
- **No flattery, no engagement-bait, no false urgency.**
- **No deciding content** — Voice only phrases.
- **No robotic dashboard labels** ("Due: tomorrow") where an observation fits.
- **No inconsistent character** — the planned unification exists to prevent Perch sounding like different apps on different screens.

## 21. Dependencies

- Truth Engine *(Prototype)* — the certainty boundary.
- Priority / Recommendation *(Prototype)* — supply what to phrase.
- People/Learning *(Implemented)* — relationship references.

## 22. Missing Dependencies

- **A unified Voice Engine** *(Concept)* — one call all surfaces use.
- **Runtime Truth→Voice check** *(Concept)* — provable no-over-claim.
- **Shared tone + reference + style model** *(Concept)* — merge the three systems.
- **Global anti-repetition** *(Concept)*.
- **User tone/register preference** *(Concept — Settings, Ch.19)*.

## 23. Future Build Order

1. **Route the brief through `PerchVoice`.** Give System 2's output access to System 1's relationship refs — the first unification, already flagged in Chapter 1's build order.
2. **Merge tone into the shared voice.** One tone model feeding all phrasing.
3. **Fold in wording-style adaptation** as one input, not a separate path.
4. **Runtime Truth→Voice check** — Voice reads statement class/confidence and cannot exceed it (needs Chapter 7's gate).
5. **Global anti-repetition.**
6. **User tone preference** (Settings).

Step 1 is the keystone: **one voice for the brief and the recall**, ending the split between the named engine and the primary surface.

## 24. Acceptance Tests

**Current (verified):**
- [x] `PerchVoice.say` returns banked, no-repeat lines for 9 learning intents.
- [x] `personRef`/`relationshipRef`/`positionRef` produce relationship-scaled references.
- [x] `PerchVoice` is called only from `perch_learn.js` (not the brief).
- [x] Today's hero/brief copy comes from the engine's `buildOpening`/tone, not `PerchVoice`.
- [x] Wording-style selector prefers action-earning phrasings via `message_styles`.
- [x] No interior-state claims appear (editorial Truth enforcement).

**Planned (Concept — not built):**
- [ ] One Voice Engine phrases every surface.
- [ ] Relationship references available to the brief and recommendations.
- [ ] A runtime check prevents Voice exceeding permitted certainty.
- [ ] Global anti-repetition across all voice output.
- [ ] User-settable tone/register.

## 25. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Relationship voice | `PerchVoice.say` + banks in `perch_voice.js` | Implemented (learning-only) |
| Relationship references | `personRef`/`relationshipRef`/`positionRef` | Implemented (learning-only) |
| Today's actual voice | `buildOpening`/`determineTone` in `perch_engine.js` | Implemented (primary surface) |
| Tone model | `determineTone` | Implemented |
| Wording-style adaptation | `message_styles`/`_shownStyle` in `perch_today_live.html` | Prototype |
| No-repeat | `_lastSaid` (voice), style rotation (wording) | Implemented (per-system) |
| Unified Voice Engine | — | Concept |
| Runtime Truth→Voice check | — | Concept |
| Global anti-repetition | — | Concept |
| User tone preference | — | Concept |

## 26. Notes

The honest headline: **Perch has excellent voice taste and three voices.** The doctrine is consistent and proven — the subtraction and truth passes made Today sound genuinely human, and `perch_voice.js` is a well-crafted relationship-voice module. But there is no single Voice Engine. The named module (`PerchVoice`) speaks only in the learning conversation; the morning brief most users read is voiced by a *different* system inside the engine; and a *third* path picks wording by what earns action. They share taste, not code.

Answering the audit directly: **`PerchVoice` is real but narrowly scoped to learning; Today's voice is the engine's `buildOpening`/tone system; a third wording-style selector adapts phrasing behaviorally.** Voice correctly never decides content and never (by editorial discipline) exceeds permitted certainty — but that Truth boundary is not yet a runtime guarantee.

So the status is **Prototype**, and the pattern rhymes with Priority (Chapter 8) and Recommendation (Chapter 9): good, working parts that were built at different times and never unified into the single engine the architecture calls for. The keystone is the smallest unification with the biggest payoff — route the brief through `PerchVoice` so the relationship-aware voice finally reaches the surface people actually read. Truth decides what may be said; Priority what rises; Recommendation what to do; Voice how to say it. Today the fourth link is three links wearing one name.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 5 2026 | 1.0 | Chapter created at status Prototype. Identified THREE independent voice systems: `PerchVoice` (`perch_voice.js`, relationship voice, called only from `perch_learn.js`), the engine's `buildOpening`/`determineTone` (Today's actual copy), and the `message_styles` wording-style selector (behavioral phrasing). Documented that the named Voice Engine does not phrase the main brief, that the Truth→Voice certainty boundary is editorial not runtime, and that no global anti-repetition exists. Keystone = route the brief through `PerchVoice` to unify. |
