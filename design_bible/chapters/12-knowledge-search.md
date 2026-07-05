# Chapter 12 — Knowledge & Search

> **Chapter:** Knowledge & Search
> **Chapter ID:** PERCH-12
> **Version:** 1.0
> **Status:** Prototype — real structured knowledge (memories, interests, people, per-area confidence) and keyword recall exist; there is **no semantic search, no vector search, and no knowledge graph**, and knowledge is scattered across separate stores with no unified index.
> **Confidence:** 87% — what Perch knows and how it recalls are settled and working within limits; the "understanding by meaning" layer is entirely unbuilt
> **Owner:** Jeff
> **Implementation:** Partial — Learning Engine stores + People + Brain captures hold knowledge; recall and search are substring/keyword only
> **Depends On:** Learning Engine *(Implemented)*, Brain *(Prototype)*, People/Relationships *(Implemented seed)*, Truth Engine *(Prototype)*, Belief Engine *(Prototype, gated)*
> **Last Updated:** July 5, 2026

*Knowledge & Search answers two linked questions: **what does Perch know, and how does the user find it?** The honest headline: Perch genuinely remembers structured things about the user's life — memories, interests, family, and how confident it is in each area — and it can recall them by keyword. But it does not yet **understand** what it knows: there is no meaning-based search, no vector index, and no graph connecting facts. Knowledge is real but scattered; search is real but literal.*

---

## 1. Purpose

This chapter governs **Perch's stored understanding of the user's life** and the mechanisms for retrieving it — the memory of who and what matters, and the ability to answer "what do you know about X?"

**Primary question this chapter answers:** *What does Perch know, and can it find it?*

---

## 2. Vision

Perch should accumulate a quiet, trustworthy understanding of a person over time — their family, their interests, their patterns, the texture of their life — and surface exactly the right piece at the right moment, whether the user asks directly ("what was that thing about the greenhouse?") or Perch offers it unprompted. The destination is knowledge that connects: knowing that Noah plays baseball *and* that Thursdays are tight *and* that a game costs $35–50, and drawing the line between them. Search that understands meaning, not just matching letters.

The vision is bounded by the current reality (§4): Perch stores facts in separate buckets and finds them by substring. It remembers; it does not yet reason across what it remembers.

---

## 3. Design Philosophy

- **Remember what matters, forget what doesn't.** Knowledge is weighted (children permanent, a mentioned show tiny) — a principle from `perch_truth.md`, only partly realized.
- **Preserve source truth.** What the user said is kept verbatim (`original_text`); Perch's summary is derived, never overwriting (Chapter 6).
- **Know what you don't know.** Per-area confidence is explicit; Perch can say "I'm still learning Emma."
- **Recall is humble.** If Perch doesn't have it, it says so and offers to remember — never fabricates.
- **Search serves clarity.** Finding a thing should be as calm as everything else in Perch.

---

## 4. Current Implementation (repo-verified)

Brutally honest, traced to code. **Knowledge lives in three separate stores; search is two separate substring filters.**

### 4a. Knowledge stores (three, unlinked)
1. **`personal_context[]`** (Learning Engine, `perch_learn.js`) — memories, observations, traits, preferences. Each entry has a `label`, optional `clean_summary`, `original_text`, `type`, `status`. **The main "memory" store.**
2. **`interests[]`** (Learning Engine) — hobbies, projects, things the user is exploring, with `status` (active/archived).
3. **`people[]`** (core) — family and relationships: `name`, `relationship`, `birth_year`, `notes`, `priority_tags`, plus **`known_details[]`** per person. Per-person knowledge.

Plus **`captures[]`** (Brain, Chapter 6) — a *fourth* store of typed life material. These four are not unified; there is no single knowledge index. **Status: Prototype (real stores, no unification).**

### 4b. Per-area confidence (Implemented)
The Learning Engine tracks a `confidence` map across **person, money, work, goals, interests, family** (0–1 each). `confidenceSummary()` turns it into a human line ("Perch knows your family pretty well; still learning your work"). This is genuine self-knowledge of coverage — one of the more sophisticated pieces. **Status: Implemented.**

### 4c. People memory (Implemented, seed-rich)
`people[]` holds the family with relationship, birth year, and notes; `known_details[]` accumulates specifics per person; per-person confidence is derivable (Chapter 11's `relationshipRef` scales by detail count). Real relationship memory. **Status: Implemented** (seeded; grows via learning).

### 4d. Recall (Prototype, keyword)
The Learning Engine's `recall` intent: it tokenizes the query into keywords (`length>2`), then `personal_context.filter(m => keywords.some(kw => (label+summary+original_text).toLowerCase().includes(kw)))`, and returns **`matches[0]`** — the first match. If none: *"I don't have that one. You can tell me and I'll remember it."* This is **keyword substring recall, unranked** — not semantic. **Status: Prototype.**

### 4e. Search (Prototype, two substring filters)
Two independent search boxes, both in the Memory Explorer:
- **`_capSearch`** — captures: `hay.includes(search)` (lowercased).
- **`_qSearch`** — questions & answers: same `.includes()` pattern.
Both are **case-insensitive substring filters.** No ranking, no meaning, no cross-store search. **Status: Prototype.**

### 4f. What does NOT exist (verified absent)
- **No semantic search** — nothing matches by meaning.
- **No vector search / embeddings** — no vector store anywhere.
- **No knowledge graph** — no nodes, edges, or links between facts; Perch cannot connect "Noah" + "baseball" + "Thursdays" + "$35–50" as related.
- **No unified knowledge index** — the four stores don't share a search.
- **No dedicated Knowledge or Search page** — knowledge surfaces via "What Perch Knows" (`perch_knows.html`); search lives inside the Memory Explorer.
- **No AI** — all recall/search is deterministic string matching.

---

## 5. Planned Architecture

- A **unified knowledge index** across memories, interests, people, and captures.
- **Semantic search** — meaning-based retrieval over that index.
- **A knowledge graph** — facts as connected nodes (person ↔ event ↔ cost ↔ time).
- **Ranked recall** — best match, not first match, with confidence.
- A **Search surface** — one place to ask Perch anything it knows.
All Concept.

---

## 6. Knowledge Model

*Current:* three-to-four separate record types (context, interest, person+details, capture), each with its own shape. *Planned:* a unified knowledge node — `{ id, kind, content, source, confidence, weight, links[], timestamps }` — searchable and connectable. Unbuilt.

## 7. Memory Types

| Type | Store | Status |
|---|---|---|
| Memories / observations | `personal_context` | Implemented (store), Prototype (recall) |
| Traits / preferences | `personal_context` (type-filtered) | Implemented |
| Interests / projects | `interests` | Implemented |
| People + known details | `people[]` + `known_details` | Implemented |
| Life material (captures) | `captures[]` (Chapter 6) | Implemented |
| Beliefs (derived) | `perch_beliefs_v1` (gated) | Prototype |

## 8. Knowledge Weighting

*Concept (doctrine-firm).* `perch_truth.md` defines weight (children permanent, a show tiny) and the Belief Engine ages beliefs — but `personal_context`/`interests` do **not** decay or carry weight today. Knowledge aging is Concept for the Learning stores (only beliefs age). Interests carry `status` (archivable) but not automatic weighting.

---

## 9. Search Model

*Prototype (substring).* Two `.includes()` filters over captures and questions. No relevance ranking, no meaning, no unified scope. The Brain chapter (6 §13) labels the capture search the same way; this chapter confirms it extends to questions and that **no search reaches the Learning stores or people at all** — you cannot "search" what Perch knows about Emma; you can only read it on the Knows page.

## 10. Recall Model

*Prototype (keyword, first-match).* §4d. Returns `matches[0]`, not the best match. Humble on miss. A real, working, literal recall.

## 11. Knowledge Graph

*Concept.* **Does not exist.** No fact is linked to another. The relationships that *look* like a graph (a person's `known_details`, `priority_tags`) are attributes, not edges. Perch cannot traverse from a person to their events to their costs. This is the single biggest missing capability for "knowledge that connects."

---

## 12. Read Mode / Explore Mode

**Read Mode — "What Perch Knows" (`perch_knows.html`, Implemented):** a calm, sectioned view — About you (traits/preferences), Family (people + known details), Interests & projects, and a confidence line. This is the primary knowledge surface and it's genuinely good: honest about coverage, editable, no fabrication.

**Explore Mode — Memory Explorer (Prototype):** capture/question browsing with substring search and filters. The deepest retrieval surface.

**Missing:** a unified Search Read Mode — one ask-anything box over all knowledge. Concept.

---

## 13. Relationships

- **Truth Engine (Prototype):** knowledge is Fact (what the user stated) vs. derived belief (gated). Recall must never fabricate — enforced (the "I don't have that one" path). Source truth preserved (`original_text`).
- **Brain (Prototype):** captures are a knowledge store; Brain's substring search is the same mechanism. Capture ≠ semantic memory (Chapter 6).
- **People/Relationships (Implemented):** the richest knowledge domain; `known_details` + confidence. (Full treatment: Chapter 15.)
- **Learning Engine (Implemented):** the writer of `personal_context`/`interests`/confidence; the recall mechanism.
- **Voice (Prototype):** `PerchVoice` phrases recall conversationally and scales references by knowledge depth (Chapter 11) — the one place knowledge confidence already shapes output.
- **Belief Engine (Prototype, gated):** derived knowledge; would feed a future graph. Emits nothing yet.
- **Living World (Concept):** knowledge is what the world would *render* — an interest becomes a workshop, a person a presence. The world needs this knowledge (esp. a graph) to be truthful scenery; today it renders none of it (Chapter 10). Knowledge → World is entirely Concept.
- **Priority/Recommendation (Prototype):** knowledge (interests, people, confidence gaps) could target suggestions and the Curiosity questions; minimally used today.

---

## 14. Knowledge & Truth

Every stored fact is knowledge Perch *was told* (a Fact) or *derived* (a gated belief). The chapter inherits the constitution: recall never invents (verified), source truth is preserved (verified), confidence is explicit (implemented for areas). What's missing is runtime classification of knowledge by certainty — like everywhere else, it's editorial (Chapter 7).

## 15. Knowledge & Living World

The world is the eventual *presentation* of knowledge. A truthful living world requires exactly the connected, weighted knowledge this chapter describes as Concept — which is why the world waits (Chapter 10). Knowledge must be able to say "this interest is real and current" before the world can grow a workshop for it. No link exists today.

## 16. Known Unknowns

- **Perch can't search what it knows about people** — only read it. Knowledge search doesn't reach the Learning/People stores.
- **Recall returns first match, not best** — a relevance gap.
- **No connections between facts** — no graph.
- **Learning-store knowledge doesn't age** — only beliefs do; stale interests persist unless archived by hand.
- **Four stores, no unified index** — the same scatter as Goals and Voice.

## 17. What Does NOT Belong

- **No fabricated recall** — "I don't have that" over a guess.
- **No fake semantic search** — substring is labeled as substring.
- **No invented connections** — Perch won't assert a link it can't source (a graph must be built on real edges).
- **No overwriting source truth.**
- **No claimed knowledge confidence** beyond the real per-area map.

## 18. Dependencies

- Learning Engine *(Implemented)* — knowledge writer + recall.
- Brain *(Prototype)* — capture knowledge + search mechanism.
- People *(Implemented)* — relationship knowledge.
- Truth Engine *(Prototype)* — recall honesty.

## 19. Missing Dependencies

- **Unified knowledge index** *(Concept)*.
- **Semantic search** *(Concept)*.
- **Vector store / embeddings** *(Concept)*.
- **Knowledge graph** *(Concept)* — the biggest gap.
- **Ranked recall** *(Concept)*.
- **Dedicated Search surface** *(Concept)*.
- **Knowledge aging for Learning stores** *(Concept)*.

## 20. Future Build Order

1. **Unify search scope** — one substring search across captures, questions, memories, interests, and people. *(Cheapest real win; ends the "can't search what Perch knows about Emma" gap.)*
2. **Ranked recall** — return best match with confidence, not first match.
3. **Unified knowledge index** — one searchable structure over the four stores.
4. **Knowledge graph** — link facts (person ↔ event ↔ cost ↔ time). Unblocks connected recall and truthful world scenery.
5. **Semantic search** — meaning-based retrieval over the index (may stay non-AI via better indexing, or opt-in AI per Chapter 6).
6. **Dedicated Search surface** — ask-anything over all knowledge.
7. **Knowledge aging** — weight and decay for Learning stores, per `perch_truth.md`.

Step 1 is the keystone: **make everything Perch knows searchable in one place** before adding meaning or graph.

## 21. Acceptance Tests

**Current (verified):**
- [x] `personal_context`, `interests`, and `people`+`known_details` store structured knowledge.
- [x] Per-area confidence (person/money/work/goals/interests/family) is tracked and summarized.
- [x] Recall matches by keyword substring over `personal_context`, returns first match, humble on miss.
- [x] Capture and question search are case-insensitive substring filters.
- [x] "What Perch Knows" renders memories, family, interests, and a confidence line.
- [x] No semantic search, no vector search, no knowledge graph exist.
- [x] Recall never fabricates; source truth (`original_text`) preserved.

**Planned (Concept — not built):**
- [ ] One search reaches all knowledge stores.
- [ ] Recall returns the best match with confidence.
- [ ] A knowledge graph links related facts.
- [ ] Semantic/meaning-based search exists.
- [ ] A dedicated Search surface exists.

## 22. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Memory store | `personal_context` in `perch_learn.js` | Implemented (store) |
| Interests store | `interests` in `perch_learn.js` | Implemented |
| People + details | `people[]` + `known_details` in `perch_core.js` | Implemented |
| Per-area confidence | `confidence{}` + `confidenceSummary()` | Implemented |
| Keyword recall | `recall` intent in `perch_learn.js` | Prototype |
| Capture search | `_capSearch` in `perch_memory_explorer.html` | Prototype |
| Question search | `_qSearch` in `perch_memory_explorer.html` | Prototype |
| Knowledge Read Mode | `perch_knows.html` | Implemented |
| Semantic search | — | Concept |
| Vector search | — | Concept |
| Knowledge graph | — | Concept |
| Unified index / Search page | — | Concept |

## 23. Notes

The honest headline: **Perch remembers, but does not yet understand.** It holds real, structured, source-preserving knowledge across four stores — memories, interests, people with per-person details, and captures — and it knows how well it knows each area (the per-area confidence map is a genuinely nice touch, powering the honest "still learning Emma" voice). "What Perch Knows" is a calm, trustworthy Read Mode.

Answering the audit directly: **knowledge exists (four separate stores); memory exists (Learning stores + Brain captures, unlinked); search exists but is two substring filters; People are remembered richly (`known_details` + confidence); there is no semantic search, no vector search, and no knowledge graph.** Truth interacts with knowledge correctly but editorially (recall never fabricates; source truth preserved). The Living World needs this knowledge — especially a graph — to render truthfully, which is one more reason the world is Concept.

So the status is **Prototype**, and the pattern is by now familiar (Goals, Voice, Priority): good, real parts that are *scattered* rather than unified, and literal rather than semantic. The keystone is the cheapest high-value fix — one search across everything Perch knows — because today Perch can show you what it knows about your family on a page but cannot *search* it, and cannot connect one fact to another. Making knowledge searchable and, eventually, connected is what turns remembering into understanding.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 5 2026 | 1.0 | Chapter created at status Prototype. Verified structured knowledge across three Learning/People stores plus Brain captures (unlinked), per-area confidence Implemented, keyword first-match recall and two substring searches Prototype. Confirmed NO semantic search, NO vector search, NO knowledge graph, no unified index, no dedicated Search page. Documented that knowledge search doesn't reach the Learning/People stores, that recall returns first-not-best match, and that the Living World needs this knowledge (esp. a graph) to render truthfully. Keystone = unify search scope across all knowledge. |
