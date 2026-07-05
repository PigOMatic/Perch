# Chapter 10 — Living World

> **Chapter:** Living World
> **Chapter ID:** PERCH-10
> **Version:** 1.0
> **Status:** Concept — the entire Living World in code is a single static, decorative SVG on Today. No world state, no data-driven rendering, no unlocks, no shared state exist.
> **Confidence:** 80% — the philosophy is rich and settled (`perch_world.md`); the implementation is essentially unbuilt, and much of the design may evolve once it meets real data
> **Owner:** Jeff
> **Implementation:** Not Started as a system — one static horizon preview (mountains, tree, cabin, sun) beneath Today's note is the whole of it
> **Depends On:** Truth Engine *(Prototype)*, Belief Engine *(Prototype, gated)*, Goals *(Prototype)*, Priority Engine *(Prototype)*, a world-state store *(Concept)*
> **Last Updated:** July 4, 2026

*The Living World is the setting Perch's clarity is presented within — a place the notebook sits, that reflects a life over time. Its philosophy is the most developed of any chapter (`perch_world.md`, 266 lines). Its implementation is the least developed of any shipped surface: one static picture. This chapter holds that gap honestly — a large, careful vision sitting almost entirely at Concept.*

---

## 1. Purpose

The Living World governs **where and how Perch's clarity is presented** — the visual, evolving setting that makes opening Perch feel like returning to a place that knows you, rather than loading a dashboard.

**Primary question this chapter answers:** *What does my life look like, presented as a place?*

---

## 2. Vision

From `perch_world.md`: a visual autobiography. A sky that shifts with the time and the tone of the moment; a tree that matures as the account ages, carrying hidden rings for chapters of life; an eagle whose proximity reflects trust; a cabin that evolves — porch, chimney, workshop — as Perch comes to know the user; districts that reflect the five priorities (a family grove, trails, gardens). Places unlock over time (creek, camper, dock, forge). Nothing announces itself — the Rule of Surprise. Absence is never punished — the world quiets but never decays; "Welcome back," never "You lost your streak." Eventually, a world worth printing and hanging on a wall.

The vision is that the *same clarity* — the note, the numbers, the obligations — can be presented in this living place without ever sacrificing readability. **The notebook stays consistent; the location changes.**

The vision is bounded by a stark implementation truth (§4): almost none of this is built.

---

## 3. Design Philosophy

From `perch_world.md`, the rules that never bend:
- **The world reflects a life, not rewards.** It is autobiography, not a game board. No XP, no streaks, no badges.
- **It never punishes absence.** Quiet, never decay. Return is always "welcome back."
- **The Rule of Surprise.** Nothing announces itself; discovery happens on the user's timeline.
- **History never vanishes.** Permanent elements (a reached goal, a child) stay permanent.
- **Readability first, always.** The world supports the clarity; the clarity is never subordinate to the world (established for Today in Chapter 1).
- **Truth-bound scenery.** A world element may only represent something real and Truth-permitted — the world never renders an invented fact (Chapter 7).

---

## 4. Current Implementation (repo-verified)

Brutally honest, traced to code. **The audit was exhaustive and the finding is unambiguous.**

### 4a. The entire Living World is one static SVG
On Today (`perch_today_live.html`), beneath the note, sits a `world-preview` div containing a single static SVG horizon:
- A low sun, three layered mountain ranges, a near hill, one lone tree ("the perch"), one cabin with a warm window.
- Marked **`aria-hidden="true"`** — it is explicitly decorative.
- Captioned "Your morning."
- The CSS comment names its intent: *"Follows perch_world.md systems: Sky, Mountains, Tree, Cabin — at rest. Static placeholder art."*

That is the complete Living World in the repository. **Status: Concept** (a static preview is a placeholder, not a system).

### 4b. What does NOT exist (verified absent)
- **No world state.** No `perch_world_v1` or any world-state storage key. The scene has no persisted state.
- **No data-driven rendering.** The SVG never changes based on goals, beliefs, time of day, tone, or account age. It is hardcoded art.
- **No unlocks or progression.** No places (creek, camper, workshop, dock, forge), no unlock logic, no progression model.
- **No cabin/tree evolution.** The tree doesn't mature; the cabin doesn't gain a porch. They are fixed shapes.
- **No sky/tone system.** The sky is a fixed gradient; it does not shift with time or engine tone.
- **No eagle, no districts, no priority-reflecting geography.**
- **No shared or multiplayer world-state.** Nothing uses `window.storage` or any shared-state API; there is no household/shared world.
- **No code loads `perch_world.md`.** The 266-line philosophy is pure doctrine, referenced only in a CSS comment.

### 4c. Summary
The Living World is **philosophy-complete and implementation-absent.** One static, decorative, Truth-safe (it claims nothing) picture stands in for an elaborate planned system. This is the largest Vision-to-Implementation gap in the entire Design Bible — and, correctly, the world was *not* built early, per the discipline in `future.md` (the world must reflect stored truth, so it waits for the belief store to stabilize).

---

## 5. Planned Architecture

- A **world-state store** deriving scenery from real data (beliefs, goals, account age, time, tone).
- A **scene renderer** that composes Sky, Terrain, Tree, Cabin, Eagle, and Districts from state.
- An **unlock/progression system** for places, driven by life events, never by grinding.
- **Evolution systems** — tree maturity, cabin additions, district growth.
- A **tone/time sky system** tied to the engine's mood output.
All Concept.

---

## 6. World Model (planned)

*Concept.* A world would be `{ sky_state, terrain, tree_stage, cabin_features[], eagle_proximity, districts{}, unlocked_places[], permanent_elements[] }`, each field derived from a real, Truth-permitted source. Nothing of this exists; today the "model" is a fixed SVG.

## 7. Scene Systems (from `perch_world.md`)

| System | Reflects | Status |
|---|---|---|
| **Sky** | Time of day, engine tone | Concept (fixed gradient today) |
| **Mountains / Terrain** | Permanent backdrop | Concept (static art) |
| **Tree ("the perch")** | Account age, life chapters (rings) | Concept (static shape) |
| **Cabin** | How well Perch knows the user | Concept (static shape) |
| **Eagle** | Trust / relationship confidence | Concept (absent) |
| **Districts** | The five life priorities | Concept (absent) |
| **Places** (creek, camper, workshop, dock, forge) | Unlocked life dimensions | Concept (absent) |

Every system is Concept. The static preview gestures at Sky, Mountains, Tree, and Cabin "at rest" but none is data-driven.

## 8. Unlock & Progression Model

*Concept.* Places unlock through real life events (a logged trip reveals a trail; a funded workshop goal reveals the workshop). Never through points or streaks (anti-gamification, §3). No unlock code exists.

## 9. Evolution Model

*Concept.* Tree matures with account age; cabin gains features as relationship confidence grows; districts grow with priority activity. No evolution code exists.

## 10. Absence Model

*Concept (doctrine-firm).* The world quiets during absence and greets return warmly — never decays, never guilts. This rule is fully specified and will govern the system when built; it is not yet code.

## 11. Personalization Model

*Concept.* From the catch-up vision: notebook, desk objects, bookmarks, pens, paper, stickers, holiday decorations, unlocked locations — "everything owned, not cluttered." Entirely unbuilt.

---

## 12. Read Mode / Explore Mode

**Read Mode (Concept):** the world as the ambient setting behind the note — today, a static horizon; planned, a living scene that never impairs readability.
**Explore Mode (Concept):** entering the world — panning the districts, visiting unlocked places, seeing the tree's rings. None exists.

The one shipped behavior: the static preview appears in Today's Read Mode, beneath and subordinate to the note (Chapter 1).

---

## 13. Relationships

- **Truth Engine (Prototype):** the world may render **only** Truth-permitted, sourced facts/beliefs — a cabin feature must correspond to something real, never invented scenery. This is the constitutional constraint on the world. *(Not yet enforced because nothing is rendered from data.)*
- **Belief Engine (Prototype, gated):** the natural data source for the world (relationship confidence → eagle; patterns → scene). Beliefs are gated off (`mayEmitToUI()` → false), so the world has nothing to render yet — correctly.
- **Goals (Prototype):** a reached goal becomes a permanent world element (the Yellowstone sign in `perch_world.md`). No link exists today.
- **Priority Engine (Prototype):** could emphasize the district matching what most deserves attention. No link.
- **Brain (Prototype):** captures/interests could shape scenes (a woodworking interest → workshop). No link.
- **Money / Calendar / Projects:** each could surface in the world (a funded project appearing built). All Concept.
- **Voice (Implemented):** the world and Voice share the engine's tone output; a somber tone would dim the sky. No link today.
- **Today (Implemented consumer):** hosts the only world element — the static preview, readability-first.

---

## 14. World Rules

- **Reflects a life, never rewards it** — no gamification.
- **Never punishes absence** — quiet, not decay.
- **Rule of Surprise** — nothing announces itself.
- **Readability first** — the world never obscures the clarity.
- **Truth-bound** — the world renders only real, permitted truth; never invented scenery.
- **History is permanent** — earned elements stay.

## 15. Known Unknowns

- **Whether the elaborate vision survives contact with real data.** Much of `perch_world.md` is aspirational art direction that may simplify once it must be driven by an actual belief store.
- **How to derive scenery truthfully** without overclaiming (an eagle's proximity implying a trust level Perch can't really measure).
- **Performance and craft** of a living scene are unexplored.
- **Everything** — with almost no implementation, most of this chapter is design intent, not validated behavior.

## 16. What Does NOT Belong

- **No gamification** — no XP, streaks, badges, or grind-unlocks.
- **No absence punishment.**
- **No world element without a real, Truth-permitted source** — no invented scenery.
- **No world that obscures the note** — readability is inviolable.
- **No announcing / notifications** from the world (Rule of Surprise).
- **No building the world before the belief store is stable** (`future.md` gate).

## 17. Dependencies

- Truth Engine *(Prototype)* — gates what may be rendered.
- Belief Engine *(Prototype, gated)* — the primary data source.
- Goals *(Prototype)* — permanent-element source.
- A world-state store *(Concept)* — does not exist.

## 18. Missing Dependencies

- **World-state store** *(Concept)* — the foundational missing piece.
- **Data-driven scene renderer** *(Concept)*.
- **Belief emission** *(Concept)* — the world needs the gate opened to have anything to show.
- **Unlock/evolution systems** *(Concept)*.
- **Tone/time sky system** *(Concept)*.

## 19. Future Build Order

*(Gated: do not begin until the Belief store is stable and emission is ready — `future.md`.)*
1. **World-state store** — derive a minimal state (time of day, account age) from real data.
2. **Sky/time system** — the first data-driven element; sky shifts with time and tone.
3. **Tree maturity** — account age → tree stage. The first "autobiography" element.
4. **Permanent goal elements** — a reached goal appears, forever (needs Goals link).
5. **Cabin evolution + relationship signals** — needs belief emission (eagle, cabin features).
6. **Places / unlocks** — life-event-driven, never grind.
7. **Personalization** — owned objects, last.

Each step must be Truth-gated: render only what's real. Step 1 is the keystone, and it waits on belief-store stability.

## 20. Acceptance Tests

**Current (verified):**
- [x] A single static, decorative SVG world preview renders on Today, `aria-hidden`.
- [x] The scene never changes based on data (hardcoded).
- [x] No world-state storage key exists.
- [x] No unlocks, progression, evolution, or shared state exist.
- [x] The world claims nothing (Truth-safe by being purely decorative).
- [x] The preview is subordinate to the note (readability-first).

**Planned (Concept — not built):**
- [ ] A world-state store derives scenery from real data.
- [ ] The sky shifts with time and engine tone.
- [ ] The tree matures with account age.
- [ ] A reached goal renders as a permanent element.
- [ ] Every world element traces to a Truth-permitted source.
- [ ] Absence quiets the world without decay or guilt.

## 21. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Static world preview | `world-preview` SVG in `perch_today_live.html` | Concept (placeholder art) |
| World philosophy | `perch_world.md` (doctrine, not loaded by code) | Implemented (as doctrine) |
| World-state store | — | Concept |
| Scene renderer | — | Concept |
| Sky/tone/time system | — | Concept |
| Tree/cabin evolution | — | Concept |
| Unlocks / places / districts | — | Concept |
| Eagle / trust signal | — | Concept |
| Shared / multiplayer state | — | Concept |
| Personalization | — | Concept |

## 22. Notes

The honest headline: **the Living World is fully imagined and almost entirely unbuilt.** `perch_world.md` is the richest design document in the project — a genuine, moving vision of a life rendered as a place. The repository's answer to it is one static SVG of a mountain, a tree, and a cabin, marked decorative and claiming nothing.

This gap is not a failure; it is discipline. The world was deliberately *not* built early, because a living world must reflect **stored truth** — and the belief store that would feed it is itself a gated prototype (Chapters 6, 7). Building the world before its data existed would have meant a world that lies (scenery driven by a timer, not a life), which every rule in `perch_world.md` and `perch_truth.md` forbids. So the world correctly waits.

The status is **Concept**, and the keystone is not a world feature at all — it is finishing the belief store and opening the Truth-gated emission path (Chapters 7, 8, 9's build orders). Only when Perch reliably *knows* things it may say can the world begin to *show* them. Until then, the honest Living World is a quiet, static horizon beneath the morning note — which is exactly the right placeholder: beautiful, subordinate to the clarity, and claiming nothing it cannot prove.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Concept. Exhaustive audit found the entire Living World is one static, decorative, `aria-hidden` SVG on Today — no world state, no data-driven rendering, no unlocks, no evolution, no shared state, and `perch_world.md` is doctrine not loaded by code. Documented the large Vision-to-Implementation gap as deliberate discipline (world must reflect stored truth; waits on belief-store stability). Keystone = finish belief store + Truth-gated emission before any world build. |
