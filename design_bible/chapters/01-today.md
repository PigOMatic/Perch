# Chapter 1 — Today

> **Chapter:** Today
> **Chapter ID:** PERCH-01
> **Version:** 1.0
> **Status:** Prototype — the most-built page; core Read Mode ships, Explore Mode and cross-domain intelligence do not
> **Confidence:** 95% — the note-first shape is settled and proven; only the depth beneath it will grow
> **Owner:** Jeff
> **Implementation:** Partial — Read Mode surface built and refined across multiple passes; Explore Mode, Priority Engine, Recommendation Engine unbuilt
> **Depends On:** Voice Engine *(Implemented)*, Truth Engine *(Implemented as doctrine)*, Belief Engine *(Prototype)*, Priority Engine *(Prototype, in-engine)*, Recommendation Engine *(Concept)*, Living World *(Prototype — static preview)*
> **Last Updated:** July 4, 2026

*This is the proof-of-method chapter. Today is the most implemented page in Perch, so it is the one place the Design Bible can be checked line-by-line against running code. Every status label here is verified against the repository, not aspirational.*

---

## 1. Vision

Today answers the first question a person has when they wake up: **what deserves my attention today?** It is the front door of Perch and the page that must earn the daily open.

Today is not a dashboard. It is a **morning note** — a short, calm, handwritten-feeling brief that tells the user the one thing worth doing, the one thing they're building toward, and then gets out of the way. Beneath the note sits the first glimpse of the user's world. The note is the point; the world supports it.

Its entire design philosophy is **subtraction**: the strongest companion says less. Today has been through multiple editorial passes (a subtraction pass removing ~37% of words, and a "truth before personality" pass removing every claim Perch couldn't support). The result is a page that reads like something a thoughtful person who knows your life would leave on the counter.

**Primary question this page answers:** *What deserves my attention today?*

---

## 2. Questions Answered

- **Primary:** What is the one thing I should deal with today?
- **Primary:** Am I okay — financially, this week, right now?
- **Secondary:** What am I building toward, and did it move?
- **Secondary:** Is payday close, and will I be covered?
- **Occasional:** What did I ask Perch to remember? (Brain surface)
- **Occasional:** What's coming this week? (shift/schedule glance)

A page that answered all of these with equal weight would answer none of them well. Today's discipline is that the **note** answers the two primary questions in three sentences, and everything else recedes below it.

---

## 3. Read Mode

The default, at-a-glance experience. This is what ships today and what has been most carefully refined.

**Structure, top to bottom:**
1. **Hero** — one opening sentence. The single most important line in the product. A truth-scoped observation about the day ("Another ICU night," "Money's thin till payday," "Nothing on Perch's list today"). Never a calendar readout.
2. **The note (brief)** — three beats, bare text on cream, no card chrome:
   - *One thing* — the single item that most deserves attention today, phrased as an observation, not a command ("This one lands tomorrow"). Done / Later buttons carry the action so the sentence is free to observe.
   - *One thing being built* — the top goal, spoken about as a dream, not a formula. Only speaks when there's real movement evidence; otherwise shows only the goal name and a quiet percentage.
   - *Closing line* — a tone-earned exhale ("Everything else can wait," "One thing at a time").
3. **Payday ritual** — appears only when payday has landed. The emotional peak of the pay cycle.
4. **World preview** — a static horizon (mountains, a lone tree, a cabin) beneath the note. The first glimpse of the Living World.
5. **Capture input** — a quiet prompt to tell Perch something.

**Status: Implemented.** All five elements exist and have been refined. The copy is governed by the Voice and Truth rules in §11–12.

---

## 4. Explore Mode

The deeper experience when the user wants to dig past the note.

**Currently:** Today has a below-the-fold region with labeled sections (Needs attention, Money, From your brain, This week, etc.) that the user scrolls to. This is a *transitional* dashboard remnant, not the intended Explore Mode.

**Planned Explore Mode:** tapping any beat of the note expands it in place — the bill reveals its amount, history, and options; the goal opens its trajectory and contribution history; the day opens the full schedule. Explore Mode should feel like turning to a more detailed page of the same notebook, never like switching to a spreadsheet. It stays calm and readable.

**Status: Concept.** The expand-in-place interaction is not built. The current scrolled sections are Prototype and will be replaced or absorbed.

---

## 5. Information Hierarchy

What rises and what recedes. This is the Priority Engine's job, and Today is where it's most developed.

**What exists (Prototype):** the engine contains a real scoring function (`_scoreRec`) that ranks candidate items by a "why now" score — timed-to-today (+40), timed-to-payday (+35), goal-connected (+20), high urgency (+25), shift-day and short-money boosts, and low-urgency penalties, clamped 0–100. Life-priority rank breaks ties. This is a genuine, working priority prototype — the single highest-scoring rec becomes the note's "one thing."

**What's planned:** a standalone **Priority Engine** that ranks across *all* domains and pages, not just Today's rec list — so the same brain decides what rises on Money, People, and Home. The in-engine scorer is the seed of it.

**Rule:** exactly one thing is the "one thing." Today never shows a ranked list of five priorities — that would be a dashboard. The hierarchy's output is a single item plus the goal, and everything else is below the fold or absent.

---

## 6. Intelligence & AI Behaviors

Which engines act on Today, with honest status.

- **Voice Engine** *(Implemented)* — relationship-aware phrasing. **Nuance:** the Voice Engine module (`perch_voice.js`) is loaded by Today but Today's copy does not call it directly; the voice currently lives in the engine's `buildOpening` and brief construction. Wiring Today's rendered copy through `PerchVoice` is a small planned cleanup.
- **Truth Engine** *(Implemented as doctrine)* — every sentence on Today has been passed through `perch_truth.md`. Interior-state claims were removed; the hero gates shift-type naming on real evidence. This is enforced by editorial discipline today, not yet by a runtime gate.
- **Belief Engine** *(Prototype)* — `PerchBeliefs.collect()` runs silently on every Today load, forming beliefs from the action log. It surfaces **nothing** — `mayEmitToUI()` returns `false`, always. Today is where the brain quietly gathers evidence; it does not yet read any belief back into the note.
- **Priority Engine** *(Prototype, in-engine)* — see §5.
- **Recommendation Engine** *(Concept)* — see §7.

**What Perch may infer on Today:** only Fact and low-level Inference today (bill timing, money-thin projection, payday proximity). No Pattern, Identity, or Reflection claims are surfaced, because the Belief Engine's output is gated off.

---

## 7. Recommendation Rules

**What Today recommends now:** a single "one thing" chosen by the in-engine scorer — a bill to deal with, a Brain item to clear, a shift to prepare for, a goal contribution. These are single-domain and evidence-based (the item exists, the date is real).

**What's planned — the Recommendation Engine (Concept):** cross-domain, evidence-based suggestions that combine multiple sources. The canonical example:

> "Tuesday is cool, you're off, rain starts Wednesday. It would be a good day to mow, then enjoy the pool with your family."

This single sentence requires **weather** + **calendar** + **home/property** + **family** data, none of which Perch currently ingests. It is the clearest illustration of why the Recommendation Engine is `Concept`, not `Planning`: **it cannot be built truthfully until its data sources exist** (see §8). Under `perch_truth.md`, Perch may not synthesize a confident recommendation from data it doesn't have.

**Forbidden recommendations (permanent):** Today must never recommend from guessed data, never claim the user's priorities it hasn't been told, never suggest an action whose evidence it can't name. A recommendation without a traceable evidence chain does not ship.

---

## 8. Data Sources

Everything Today reads, verified against the repository, with honest ingestion status.

| Data | Source | Available today? | Notes / ingestion path |
|---|---|---|---|
| Checking balance | `finances.accounts` | ✅ Yes | Manually entered |
| Paycheck amount + date | `finances.paycheck` | ✅ Yes | Manually entered |
| Bills (amount, due date) | `bills` | ✅ Yes | Manually entered |
| Goals (target, saved, updated) | `future_horizon` | ✅ Yes | Manually entered |
| Work schedule | `work.schedule` | ✅ Yes | Manually entered |
| Brain captures | `captures` | ✅ Yes | User input |
| People | `people` | ✅ Yes | Learning Engine + manual |
| Priorities | `priorities` | ✅ Yes | Onboarding |
| Properties | `properties` | ✅ Yes | Manual |
| Action log (evidence) | `perch_action_log` | ✅ Yes | Auto-logged on every action |
| Beliefs | `perch_beliefs_v1` | ✅ Formed, ⛔ not surfaced | Belief Engine writes; nothing reads back yet |
| **Weather** | — | ❌ **No** | *Required for Recommendation Engine. No ingestion path. Concept.* |
| **External calendar** | — | ❌ **No** | *Only work schedule exists. Full calendar ingestion is Concept (Chapter 5).* |
| **Transactions / spending** | — | ❌ **No** | *Required for duplicate-charge / spending intelligence. Concept (Chapter 2 / Tiller).* |
| **Email (bills, receipts)** | — | ❌ **No** | *Required for Inbox Intelligence auto-entry. Concept.* |

The pattern is clear: everything Today does *today* runs on manually-entered data. Every ambitious cross-domain behavior waits on an ingestion path that doesn't exist yet — and the Bible says so plainly rather than pretending.

---

## 9. Wireframes & Reference Illustrations

**Current Read Mode (verified structure):**
```
┌─────────────────────────────┐
│ Perch                    ⚙  │  ← minimal top bar
│                             │
│ Thursday                    │  ← date, muted
│ Another ICU night.          │  ← hero (Playfair serif, the one line)
│                             │
│ Duke Energy                 │  ← one thing (name)
│ This one lands tomorrow.    │  ← observation, not command
│ [ Done ]  [ Later ]         │  ← buttons carry the action
│                             │
│ Yellowstone                 │  ← one thing being built
│ You moved something         │  ← only if real evidence; else silent
│ toward it this week.        │
│ 65% there                   │  ← quiet, muted, never leads
│                             │
│ One thing at a time.        │  ← closing exhale
│                             │
│ ┌─────────────────────────┐ │
│ │  🌄  mountains · tree ·  │ │  ← static world preview
│ │      cabin · low sun     │ │
│ │      "Your morning"      │ │
│ └─────────────────────────┘ │
│                             │
│ [ Tell Perch something… ]   │  ← quiet capture
└─────────────────────────────┘
```

**Planned Explore Mode (Concept):** tapping "Duke Energy" expands the beat inline to reveal amount, due date, payment history, and actions — without leaving the note. *Reference mockup to be created when Explore Mode moves to Planning.*

---

## 10. Acceptance Tests

How we know Today is correctly implemented. Checked items are verified in the current repository; unchecked are planned.

**Read Mode (Implemented):**
- [x] Hero shows exactly one observation, never a calendar readout.
- [x] Hero names shift type (ICU/night) only when the shift record supports it.
- [x] Hero says "another" only with ≥2 same-type shifts of evidence.
- [x] The note shows exactly one "one thing," not a ranked list.
- [x] Bill/brain lines are observations; Done/Later buttons carry the action.
- [x] Goal beat stays silent when there's no movement evidence (shows only name + quiet %).
- [x] No interior-state claims ("feels easier," "on your mind") appear.
- [x] Closing line is tone-appropriate.
- [x] World preview renders beneath the note, static, decorative (aria-hidden).
- [x] Belief collection runs on load and surfaces nothing.
- [x] No dashboard grid; single-column note.

**Explore Mode (Planned):**
- [ ] Tapping a beat expands it in place with detail and actions.
- [ ] Expansion never navigates away from the note.

**Recommendation Engine (Concept):**
- [ ] A cross-domain recommendation names every data source in its evidence chain.
- [ ] No recommendation appears when any required data source is unavailable.

---

## 11. Implementation Notes & Build Order

**What shipped, in order (history):** note-first layout → wording-style engine → payday ritual → goal momentum → subtraction pass → truth-before-personality pass → Tier 0 action logging → Belief Engine (silent) → static world preview.

**Next steps toward the Bible's Today, in order:**
1. **Wire Today's copy through the Voice Engine** — small cleanup so all rendered copy uses `PerchVoice` consistently. *(Voice Engine already Implemented.)*
2. **Turn on one belief** — let a single, gated Pattern belief source one existing sentence, behind `perch_truth.md` thresholds. Proves the Belief→surface pipeline on one line before expanding.
3. **Explore Mode** — expand-in-place interaction for each beat.
4. **Priority Engine extraction** — lift the in-engine scorer into a standalone engine serving all pages.
5. **Recommendation Engine** — only after Priority is standalone *and* at least one new data source (weather or calendar) is ingested.

Each step is independently testable, following the pattern established so far (data → engine → gate → surface).

---

## 12. Voice & Truth Rules (page-specific)

**Voice rules for Today** (from `perch_voice.js` doctrine):
- Observations, not instructions. The buttons command; the sentences notice.
- Names over titles; relationship phrasing only when natural.
- No flattery, ever. No "please provide," no "tell me more about."
- No two consecutive identical phrasings.
- The strongest note says less.

**Truth rules for Today** (from `perch_truth.md`):
- Perch may describe its own data; never the user's interior (feelings, motivations, priorities, intent).
- When evidence is absent: stay silent, ask, or drop a truth level. The empty goal beat is the model.
- No "always"/"never." No overstated confidence.
- Shift-type and repetition claims must be backed by the shift record and history count.

---

## 13. What Does Not Belong on Today

Explicitly out of scope — guardrails against regression:
- **No dashboard grid** of equal-weight cards. Today is a note, not a control panel.
- **No ranked priority list.** One thing rises; the rest stay quiet.
- **No metrics as headlines** — no "$65 → 66%," no percentages leading a sentence.
- **No streaks, XP, badges, or gamification.** (That's not what the world is; see `perch_world.md`.)
- **No interior-state claims** without evidence.
- **No cross-domain recommendation** until its data sources are real.
- **No Living World logic** on Today beyond the static preview — the full world is a separate, later build.
- **No notifications or "unlock" announcements** — the Rule of Surprise applies.

---

## 14. Living World Relationship

Today is where the Living World first appears, as a **static preview** beneath the note (Prototype). The relationship is deliberate and constrained:
- The world **supports** the note; the note is never subordinate to the world.
- Today renders only a static horizon — no world *engine*, no data-driven scenery, no interaction.
- When the Living World engine is eventually built (gated in `future.md`, philosophy in `perch_world.md`), Today's preview becomes a live window into it — but always beneath the note, always readable-first.
- The world on Today must never announce change, never demand attention, never punish absence.

**Status: Prototype (static art only).**

---

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Prototype. Verified against repository: Read Mode Implemented, Explore Mode Concept, Priority Engine Prototype (in-engine), Recommendation Engine Concept, Living World Prototype (static). Serves as the Design Bible's proof-of-method chapter. |
