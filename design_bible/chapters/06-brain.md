# Chapter 6 — Brain

> **Chapter:** Brain
> **Chapter ID:** PERCH-06
> **Version:** 1.0
> **Status:** Prototype — a real typed capture system with an inbox, lifecycle, and Today integration exists; true semantic memory, AI interpretation, and vector search do not
> **Confidence:** 90% — the capture model is proven and central; the "externalized memory" ambition is largely unbuilt
> **Owner:** Jeff
> **Implementation:** Partial — capture, classify, store, process, and surface all work; search is substring-only, no semantic layer
> **Depends On:** Learning Engine *(Implemented)*, Belief Engine *(Prototype, gated)*, Priority Engine *(Prototype, in-engine)*, Calendar *(Implemented)*, Goals *(Prototype)*, Truth Engine *(doctrine)*
> **Last Updated:** July 4, 2026

*Brain is not a junk drawer. It is meant to become Perch's externalized working memory: the place loose life material lands, keeps its source truth, and gets converted from chaos into clarity. Today, Brain is a genuinely capable typed-capture system — more built than most chapters — but it is still mostly capture storage, not memory. This chapter says exactly where that line falls.*

---

## 1. Purpose

Brain governs how Perch **captures loose life material** — reminders, things you're waiting on, recurring commitments, opportunities, events, and goals — classifies it, holds it truthfully, and helps convert it into action or clarity.

**Primary question this chapter answers:** *What am I carrying?*

---

## 2. Vision

A person's head is full of open loops: call the county, waiting on the ring, Noah's baseball on Thursdays, maybe pick up that extra shift. Brain's vision is to be the trusted place all of that lands the instant it's spoken — captured in plain language, classified without friction, and surfaced back exactly when it matters, never lost. The larger destination is **externalized working memory**: not just a list, but a system that preserves the original source truth of what you said and helps you turn a pile of loose thoughts into a clear next move.

The vision is bounded by honesty: Brain today is a strong *capture* system. It is not yet *memory* in the semantic sense, and this chapter marks that gap precisely.

---

## 3. Design Philosophy

- **Capture at the speed of thought.** One text box, plain language, no forms. Perch classifies; the user doesn't have to.
- **Preserve source truth.** The original words are kept (`original_text`) alongside Perch's cleaned label — Perch never overwrites what you actually said.
- **Typed, not tangled.** Every capture has a type so it can be surfaced correctly (a reminder behaves differently from a waiting item).
- **Nothing is lost, nothing nags.** Done items archive rather than vanish; open items wait quietly.
- **Brain feeds everything.** Captures are the substrate for Today, Calendar, and eventually Projects — Brain is a source, not a silo.

---

## 4. Current Implementation (repo-verified)

Traced to code. Brain is one of the more complete systems in the repository.

### 4a. Captures are first-class objects (Implemented)
A capture is a rich stored object (`captures[]`), created via `PerchParse` in `perch_core.js`. Verified fields: `id`, `type`, `typeLabel`, `icon`, `label`, `clean_label`, `original_text`, `perch_action`, `source` (e.g. `'perch_input'`), `priority_tags`, date fields (`expected`, `day_of_week`), and `status`. **Source truth is preserved** — `original_text` holds the user's actual words; `clean_label` holds Perch's tidied version.

### 4b. Typed classification (Implemented, rule-based)
Input is classified by `PerchParse` — a **rule-based regex** classifier, not AI. Six types, each with pattern matchers:
- `reminder` (default fallback), `waiting_on`, `recurring`, `opportunity`, `event`, `goal`, plus internal `context`/`meaning` actions.
Classification is deterministic and transparent. **No AI, no ML, no embeddings** are involved.

### 4c. Brain Inbox (Implemented)
`renderBrainInbox()` surfaces captures on Today; `grp-inbox` shows/hides based on content. The oldest open capture can become Today's "one thing" beat (`renderDailyBrief`). Captures also feed Quick Answers.

### 4d. Processing / lifecycle (Implemented)
Statuses: open, `completed`, `dismissed`, `archived`. The Memory Explorer (`perch_memory_explorer.html`) filters by open / done / reminder / waiting_on / recurring / all / archived. Done items archive (not delete); archived items are recoverable. A confirm-interpretation flow lets the user edit Perch's classification and label before committing (`interp-*` UI in Today).

### 4e. Search = substring filter (Prototype)
The Memory Explorer has a search box (`_capSearch`) that does **case-insensitive substring matching** on labels via `.filter()/.includes()`. This is **filtering, not search** — no semantic matching, no ranking, no vector/embedding layer. Honest label: Prototype.

### 4f. Promotion (Prototype)
Captures can route to other systems: `event` → `future_horizon`, `goal` → Goals section, and a reminder-promote path exists (`perch_capture.html`). This is **partial** — promotion is type-specific and not a general "convert this into an obligation/goal/basic" capability.

### 4g. Source & confidence metadata (Partial)
- **Source: yes** — captures carry `source` (e.g. `perch_input`) and `seed` vs `user_created` provenance.
- **Confidence: no** — captures have **no confidence score.** (Confidence lives in the Belief and Learning engines, not on captures.)

### 4h. Belief emission (gated off)
The Belief Engine (`perch_beliefs.js`) forms beliefs silently from the action log — but `mayEmitToUI()` returns **false, always.** Brain does **not** emit beliefs into the UI or the Living World. Belief *collection* exists; belief *emission* is absent by design (Chapter 1, `perch_inference.md`).

### 4i. Aging (absent)
There is **no capture aging or staleness logic.** A capture does not decay, expire, or lose confidence over time. (Aging exists only in the Belief Engine, not for captures.)

**Overall status: Prototype→Implemented for capture; Concept for memory.** The capture system is solid and central; the "externalized semantic memory" is not built.

---

## 5. Planned Architecture

- **Semantic memory** — meaning-based recall, not substring filter.
- **AI-assisted interpretation** *(Concept, opt-in)* — better parsing of messy input; strictly bound by `perch_truth.md` (never fabricate).
- **General promotion** — any capture → obligation / goal / project / basic.
- **Capture aging** — stale, unreferenced captures quiet down.
- **Belief emission** — gated beliefs eventually surface one sentence at a time.
All Concept or Planning.

---

## 6. Brain Philosophy

Brain holds what the user hands it, exactly as handed, and gives it back when useful. It never judges the pile, never invents entries, never loses source truth. Its job is to reduce the cost of remembering to near zero and the cost of retrieval to near zero — so the user's head is free.

---

## 7. Capture Model

`{ id, type, typeLabel, icon, label, clean_label, original_text, perch_action, source, priority_tags[], expected|day_of_week, status, seed|user_created }`. **Implemented.** The dual `original_text` + `clean_label` is the model's core honesty feature — Perch's interpretation never destroys the user's words.

---

## 8. Capture Types

| Type | Status | Behavior (repo) |
|---|---|---|
| **Reminder** | Implemented | Default type; a thing to do. Surfaces in inbox/Today. |
| **Waiting On** | Implemented | Owed *to* the user; has `expected` date; can go overdue (Chapter 3). |
| **Recurring** | Implemented | Weekly via `day_of_week`; regenerated as events. |
| **Opportunity** | Implemented | A possible gain (extra shift); dated. |
| **Event** | Implemented | Dated; promotes to `future_horizon`. |
| **Goal** | Implemented (as capture) | Routes toward Goals (Chapter 4's fragmentation applies). |
| **Question** | Concept (as capture) | Questions are stored **separately** (Learning Engine / `questions`), *not* as captures. |
| **Note** | Concept | No freeform "note" type; closest is `context`/`meaning` internal actions. |
| **Thought** | Concept | No "thought" type; everything is classified into an actionable type. |

Honest note: Brain captures are **typed, not freeform.** There is no plain "note" or "thought" bucket — every input is classified into one of the actionable types, defaulting to reminder. Question, Note, and Thought as first-class Brain types are Concept.

---

## 9. Brain Inbox

*Implemented.* `renderBrainInbox()` on Today; oldest open capture can become the "one thing"; visibility auto-managed. The inbox is the working surface where captures await processing.

## 10. Processing Model

*Implemented.* Capture → (optional confirm-interpretation edit) → commit → surfaces in inbox/Today/Calendar → user marks done/dismissed → archives. Transparent and reversible.

## 11. Done / Archive / Delete

*Implemented.* Done and dismissed items archive (recoverable), not hard-delete. The Memory Explorer exposes archived items. True permanent deletion is minimal/secondary — the philosophy is "nothing is lost."

## 12. Promotion Model

*Prototype.* Type-specific routing (event→future_horizon, goal→Goals, reminder-promote). A general "promote any capture to any system" capability is Concept.

## 13. Search Model

*Prototype (substring filter).* No semantic search, no vector store, no ranking. `_capSearch` matches label substrings. Honest: this is filtering. Semantic search is Concept.

## 14. Memory Model

*Concept for semantic memory.* Brain today is **capture storage with source preservation**, not semantic memory. There is no meaning-based recall, no embedding index, no associative retrieval. The Learning Engine (`perch_learn.js`) stores personal context separately and *is* more memory-like (people, interests, traits), but that is a different store (Chapter's People/Knowledge territory), not Brain captures.

## 15. Belief Model

*Prototype, gated.* The Belief Engine forms Pattern-level beliefs from the action log and stores them (`perch_beliefs_v1`), but **emits nothing** (`mayEmitToUI()` → false). Brain neither surfaces beliefs nor feeds them to the world. Belief collection is real; belief emission is deliberately off (`perch_inference.md`).

---

## 16. Relationships

- **Today (Implemented):** Brain directly powers Today — inbox, the oldest-item "one thing," quick answers. This is Brain's most active integration.
- **Calendar & Obligations (Implemented):** dated captures (waiting_on, recurring, event) flow into `PerchEvents` and the timeline (Chapter 3).
- **Goals (Prototype):** goal-type captures route toward Goals; inherits Chapter 4's fragmentation.
- **Projects (Concept):** Brain captures are the *planned* task substrate for Projects — projects would reference captures, not duplicate them (Chapter 5). No linkage exists yet.
- **Money (Implemented math):** money-related captures (transfer/payday reminders) are detected by label regex and can seed payday actions; Brain doesn't compute money itself.
- **Priority Engine (Prototype):** captures are scored by the in-engine scorer (urgency, timing) to decide inbox/Today surfacing.
- **Recommendation Engine (Concept):** would suggest what to process next or convert a capture into a recommendation. Not built.
- **Living World (Concept):** Brain emits nothing to the world; belief emission is gated off. Any world response to Brain is Concept.

---

## 17. Read Mode

*Implemented (as the inbox).* Brain reads as a clean list of open captures, oldest/most-relevant surfaced first, each showing its cleaned label and type icon. Prose-adjacent, calm, processable.

## 18. Explore Mode

*Prototype (the Memory Explorer).* Full capture browser with filters (open/done/type/archived) and substring search. This is the deepest existing Brain surface. Semantic exploration is Concept.

---

## 19. Truth Rules (chapter-specific)

- **Source truth is inviolable.** `original_text` is never overwritten; Perch's `clean_label` is clearly a derived interpretation.
- **A capture's type is Perch's Interpretation**, editable by the user before commit — never presented as unquestionable.
- **Perch never invents captures.** Only user (or seed) input creates them.
- **No confidence is claimed on captures** — because none is computed. Perch doesn't imply certainty it lacks.
- **Belief-derived claims stay internal** until the gate opens (`perch_truth.md`).

## 20. Voice Rules (chapter-specific)

- Captures surfaced as observations, not commands (Chapter 1): "Call the county is still open," not "Do this."
- Waiting items phrased as awaited, not nagged (Chapter 3).
- No shame for a full or stale inbox.
- Perch's interpretation is offered humbly and is always editable.

## 21. Known Unknowns

- **Whether a capture still matters.** Perch doesn't know if an old open reminder is still relevant (no aging).
- **The true meaning of terse input.** Rule-based parsing can misclassify; the user's edit is the correction path.
- **Semantic relationships between captures.** With no semantic layer, Perch can't know two captures are about the same thing.
- **Whether a capture belongs to a project/goal.** No linkage exists.
- **Everything not captured.** Brain only knows what was entered.

## 22. Source Lineage examples

```
"Call the county about the permit"  (inbox item)
    ↓  renderBrainInbox / Today beat
    ↓  captures[].clean_label  (derived)
    ↓  captures[].original_text  (source truth, preserved)
    ↓  PerchParse classification (reminder)
    ↓  Manual User Entry
```
```
"Waiting on Maura's ring (expected ~14th)"
    ↓  PerchEvents (waiting_on)
    ↓  captures[].expected
    ↓  Manual User Entry
```

## 23. Statement Classification examples

| Statement | Classification |
|---|---|
| "Call the county" is in your Brain | **Fact** (stored capture) |
| This has been open a while | **Derived Fact** (created_date) |
| This looks like a reminder | **Interpretation** (PerchParse type, editable) |
| You usually clear these in the morning | **Prediction/Pattern** *(Belief Engine — gated, not surfaced)* |
| Want to turn this into a goal? | **Recommendation** *(promotion — partial)* |

---

## 24. What Does NOT Belong

- **No junk-drawer sprawl.** Everything is typed and processable; Brain is not an unstructured dump.
- **No overwriting source truth.** `original_text` is sacred.
- **No invented captures or fabricated interpretations.**
- **No fake semantic search** — filtering is labeled as filtering, never dressed as understanding.
- **No claimed confidence** on captures where none is computed.
- **No belief emission** until the gate opens.
- **No nagging** on stale or numerous captures.

## 25. Dependencies

- Learning Engine *(Implemented)* — personal-context capture (adjacent memory).
- Calendar *(Implemented)* — dated captures on the timeline.
- Priority Engine *(Prototype)* — inbox/Today surfacing.
- Truth Engine *(doctrine)*.

## 26. Missing Dependencies

- **Semantic memory / vector search** *(Concept)* — the biggest gap between capture and memory.
- **AI-assisted interpretation** *(Concept, opt-in)* — better parsing, truth-bound.
- **Capture aging** *(Concept)* — staleness handling.
- **General promotion** *(Concept)* — any capture → any system.
- **Belief emission** *(Concept)* — surface gated beliefs.
- **Project linkage** *(Concept)* — captures as project tasks.

## 27. Future Build Order

1. **Capture aging** — quiet stale, unreferenced captures without deleting them.
2. **General promotion** — one path to convert any capture into an obligation/goal/project/basic.
3. **Project linkage** — let a capture be a project's task (unblocks Chapter 5).
4. **Semantic search** — meaning-based recall over substring filter.
5. **Belief emission (one sentence)** — open the gate for a single Pattern belief behind `perch_truth.md`.
6. **AI-assisted interpretation** *(opt-in)* — last, and strictly truth-bound.

Each step independently testable (capture → classify → store → surface → gate).

## 28. Acceptance Tests

**Current (verified):**
- [x] Captures are first-class typed objects with preserved `original_text`.
- [x] Six types classified by rule-based `PerchParse` (no AI).
- [x] Brain Inbox surfaces captures on Today; oldest can be the "one thing."
- [x] Lifecycle: open → done/dismissed → archived (recoverable).
- [x] Memory Explorer filters by type/status and substring-searches labels.
- [x] Event/goal captures promote to future_horizon/Goals (partial).
- [x] No capture carries a confidence score.
- [x] Belief emission is gated off (`mayEmitToUI` → false).
- [x] No capture aging exists.

**Planned (Concept — not built):**
- [ ] Semantic/meaning-based search.
- [ ] AI-assisted interpretation (opt-in, truth-bound).
- [ ] Capture aging.
- [ ] General promotion to any system.
- [ ] Gated belief emission surfaces one sentence.

## 29. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Capture store | `captures[]` in state | Implemented |
| Classifier | `PerchParse` in `perch_core.js` (regex) | Implemented |
| Capture types | `TYPES` in `perch_capture.html` | Implemented |
| Brain Inbox | `renderBrainInbox()` in Today | Implemented |
| Lifecycle/archive | Memory Explorer filters, status set | Implemented |
| Confirm-interpretation | `interp-*` flow in Today | Implemented |
| Search (substring) | `_capSearch` in Memory Explorer | Prototype |
| Promotion | event→future_horizon, goal→Goals | Prototype |
| Source metadata | `source`, `seed`/`user_created` | Implemented |
| Confidence metadata | — | Concept (none on captures) |
| Semantic memory / vectors | — | Concept |
| AI interpretation | — | Concept |
| Capture aging | — | Concept |
| Belief emission | `mayEmitToUI()` → false | Concept (gated) |

## 30. Notes

The honest headline: **Brain is a strong typed-capture system, not yet a memory.** It captures at the speed of thought, classifies deterministically without AI, preserves the user's actual words, runs a real lifecycle, and directly powers Today — genuinely among the most complete systems in the repo. What it is *not*, yet: semantic memory. Search is substring filtering. There is no AI interpretation, no vector store, no embeddings, no associative recall, no capture aging. Belief collection exists but emission is gated fully off.

So Brain sits at **Prototype**: more built than Projects (Concept) or the general Goal system, less than a finished chapter, because the defining ambition — *externalized working memory* — requires the semantic layer that doesn't exist. The status labels carry the split: Implemented for capture, classification, lifecycle, and Today integration; Prototype for search and promotion; Concept for semantic memory, AI interpretation, aging, and belief emission.

The single most important honest distinction: **capture ≠ memory.** Perch reliably remembers *what you told it, in your words*. It cannot yet recall *by meaning* or connect related thoughts. That gap is the whole future of this chapter.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Prototype. Verified capture system Implemented (typed, first-class, source-preserving, lifecycle, Today-integrated) via `PerchParse`/`captures`/Memory Explorer. Confirmed search is substring-only (no semantic/vector), no AI interpretation, no capture aging, no confidence on captures, belief emission gated off. Question/Note/Thought types labeled Concept. |
