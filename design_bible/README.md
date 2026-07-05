# The Perch Design Bible

*The authoritative guide for what Perch must become.*

An encyclopedia explains what is. A design bible explains what a product must become. Films have them. Disney has them. Apple has its Human Interface Guidelines. This is Perch's.

**This document describes the finished product, not the current repository.** Systems that do not yet exist in code are expected to appear here first, clearly marked as planned. The codebase evolves toward the Bible — never the other way around.

---

## The three layers

Perch is understood at three layers. Keeping them separate is what prevents confusion between what Perch *is* and what Perch *will be*.

### Layer 1 — Vision
The mission and philosophy. Changes rarely. This is the "why" that every decision answers to.
- *Clarity, presented beautifully.*
- Perch is a Life Operating System.
- The Atlas: every page answers one question.
- The Living World: the experience has a place.
- Governed by: `01-vision.md` and the foundation docs (`perch_truth.md`, `perch_world.md`, `perch_design.md`, `perch_inference.md`, `future.md`).

### Layer 2 — Product Specification (this Bible)
What each part of Perch must eventually do. Every chapter describes planned behavior and carries a **status** and **confidence**. A chapter may describe an engine that does not exist yet — it is simply marked `Planning` or `Concept` until it does. Chapters mature; they do not disappear.

### Layer 3 — Repository
The current code. Nothing more. What actually ships today. Tracked in each chapter's **Implementation Status** section, which is the single place the Bible touches reality.

> The Bible is the destination. The repository is the journey.

---

## Status system

Every chapter and every major feature carries a status. This is what lets the Bible describe the whole product honestly without pretending it exists.

| Status | Meaning |
|---|---|
| **Concept** | An idea we believe in but haven't specified in detail. May still change substantially. |
| **Planning** | Being specified now. Behavior is being defined; not yet built. |
| **Prototype** | Partially built or spiked. Exists in code but not production-ready. |
| **Implemented** | Shipped and working in the repository today. |

Alongside status, features carry:
- **Confidence** — how sure we are this feature will exist in roughly this form (e.g. 95%). Low confidence is fine and honest; it flags things likely to change.
- **Dependencies** — what must exist first (engines, data sources, other chapters).
- **Required engines** — which intelligence systems power it.
- **Required data sources** — what data it needs, and whether Perch has an ingestion path for it yet.
- **Future implementation notes** — how it will eventually be built.

---

## The Atlas — chapter index

Every Atlas page is a chapter. Each answers one primary question. Status reflects the **page as specified in the Bible**, not merely whether some version exists in code.

| # | Chapter | Primary question | Status | Bible file |
|---|---|---|---|---|
| 0 | Overview | What is Perch? | Planning | `chapters/00-overview.md` |
| 1 | Today | What deserves my attention today? | Prototype | `chapters/01-today.md` ✍ |
| 2 | Money | Where do I stand financially, and what changed? | Concept | `chapters/02-money.md` ✍ |
| 3 | Calendar & Obligations | What's coming, and what do I owe? | Prototype | `chapters/03-calendar-obligations.md` ✍ |
| 4 | Goals | Am I building the life I want? | Prototype | `chapters/04-goals.md` ✍ |
| 5 | Projects | What am I in the middle of building? | Concept | `chapters/05-projects.md` ✍ |
| 6 | Brain | What am I carrying? | Prototype | `chapters/06-brain.md` ✍ |
| 7 | People | Who matters right now? | Concept | `chapters/07-people.md` *(planned)* |
| 8 | Home & Property | What do I own, and what needs care? | Prototype | `chapters/14-home-property.md` ✍ |
| 9 | Knowledge & Search | What am I learning / what do I want to know? | Prototype | `chapters/12-knowledge-search.md` ✍ |

*Chapters marked "planned" are not yet written. This index is the backlog of chapters to author.*

---

## The engines — systems index

The intelligence that powers the Atlas. Each will eventually have its own chapter. Status reflects what exists in the repository today.

| Engine | Purpose | Status | Repo file |
|---|---|---|---|
| Truth Engine | What Perch is allowed to say (epistemology) | Prototype *(doctrine complete; runtime gate belief-only)* | `perch_truth.md`, `chapters/07-truth-engine.md` ✍ |
| Belief Engine | Forms/ages beliefs from evidence | Prototype *(forms beliefs, surfaces nothing)* | `perch_beliefs.js` |
| Inference Engine | Observation → permission pipeline | Planning *(architecture only)* | `perch_inference.md` |
| Learning Engine | Captures personal context from language | Implemented | `perch_learn.js` |
| Voice Engine | Relationship-aware phrasing | Prototype *(three separate voice systems; `PerchVoice` powers only learning)* | `perch_voice.js`, `chapters/11-voice-engine.md` ✍ |
| Priority Engine | Decides what rises for attention | Prototype *(four uncoordinated scorers, not one engine)* | `perch_engine.js`, `chapters/08-priority-engine.md` ✍ |
| Recommendation Engine | Cross-domain, evidence-based suggestions | Prototype *(recs = top priority candidate; no standalone engine; feedback loop real)* | `perch_engine.js`, `chapters/09-recommendation-engine.md` ✍ |
| Money Intelligence | Bill detection, duplicates, allocation | Concept | — |
| Inbox Intelligence | Ingests bills/receipts from email | Concept | — |
| Integrations | External data ingestion (banking, calendar, email, weather) | Concept *(zero integrations; fully manual/local/offline)* | `chapters/13-integrations.md` ✍ |
| Pattern Detection | Finds recurring behavior | Prototype *(inside Belief Engine)* | `perch_beliefs.js` |
| Living World | The place clarity is presented within | Concept *(one static decorative preview)* | `perch_world.md`, `chapters/10-living-world.md` ✍ |

---

## Rules for authoring the Bible

1. **Every feature must have a home.** No feature is introduced without a chapter (or engine section) to hold it. If it has no home, either find one or create the chapter first.
2. **Every feature has a permanent ID.** Format: `PERCH-<chapter#>-<slug>`, e.g. `PERCH-02-duplicate-charges`. IDs never change or get reused, even if a feature is cut — a cut feature is marked, not deleted.
3. **Status before detail.** A chapter's header block (status, confidence, dependencies) is written before its body. We never spec behavior we can't place on the maturity map.
4. **Honesty about data.** Any behavior that needs data Perch can't yet ingest (weather, calendar, transactions, email) must say so explicitly and name the required ingestion path. This keeps `perch_truth.md`'s evidence rules intact even in planning.
5. **Chapters mature, they don't vanish.** When something ships, its status flips to `Implemented`. The chapter stays. Six months later the Bible reads as a history of how Perch became itself.
6. **Long-term consistency over short-term implementation.** When a quick build would contradict the Bible, the Bible wins, or the Bible is deliberately updated first.

---

## Statement classification (global law)

Every sentence Perch shows, in any chapter, is one of five kinds. High-trust chapters (Money, Health, anything with hard numbers) must never blur them. This is the runtime companion to `perch_truth.md`'s certainty levels — where Truth defines *how sure* Perch is, this defines *what kind of claim* it's making.

| Class | What it is | Example | Must expose |
|---|---|---|---|
| **Fact** | Directly stored/observed | "Checking balance: $2,183" | its source |
| **Derived Fact** | Arithmetic over Facts | "Bills before payday: $1,042" | its inputs |
| **Interpretation** | A judgment from Facts | "You're safe until payday." | its reasoning |
| **Recommendation** | A suggested action | "Wait until Friday to buy this." | its reasoning + evidence |
| **Prediction** | A claim about the future | "You'll be fine this month." | its assumptions + uncertainty |

Facts and Derived Facts are objective and may be stated plainly. Interpretations, Recommendations, and Predictions come from the engines and **must always expose their reasoning** — the user can see why. A chapter that presents an Interpretation as a Fact has failed.

## Source lineage (global law)

Every figure Perch shows must be able to answer **"where did this come from?"** with a complete chain to its origin. Lineage is what makes trust debuggable.

```
Projected Balance → Finance Snapshot → Checking Balance → Manual User Entry
```
or, once banking exists:
```
Projected Balance → Checking Account → Plaid → Bank
```

If a figure can't produce its lineage, it doesn't ship. This applies to every chapter, but it is enforced most strictly where numbers are involved.

## The trust rule (global law)

> **Perch never invents certainty.**

When two sources disagree, Perch shows the disagreement, explains it, and does not silently choose one. This holds everywhere; in Money it is absolute.

---

## The chapter template

Every chapter follows one structure, defined in `chapters/_TEMPLATE.md`. It opens with a metadata block (Chapter, Version, Status, Confidence, Owner, Implementation, Depends On, Last Updated), then: Vision → Questions Answered → Read Mode → Explore Mode → Information Hierarchy → Intelligence & AI Behaviors → Recommendation Rules → Data Sources → Wireframes → Acceptance Tests → Implementation Notes & Build Order → Edge Cases → Change Log.

---

*Perch Design Bible · established Jul 4 2026.*
*Layer 1 (Vision) in `01-vision.md`. Layer 2 (this Bible) in `chapters/`. Layer 3 (Repository) is the code.*
*The Bible is the destination. The repository is the journey.*

---

## Bible Change Log

*The canonical change log now lives in [`CHANGELOG.md`](CHANGELOG.md). Summary retained below.*

| Date | Change |
|---|---|
| Jul 4 2026 | Bible established. README (three-layer model, status system, indexes, authoring rules), Layer 1 Vision, chapter template created. |
| Jul 4 2026 | Chapter 0 (Overview) and Chapter 1 (Today) written. Today serves as proof-of-method. |
| Jul 4 2026 | Chapter 2 (Money) written at stricter standard. Elevated Statement Classification, Source Lineage, and Trust rules to global law. |
| Jul 4 2026 | Chapter 3 (Calendar & Obligations) written at status Prototype. Reconciled Atlas index (Calendar+Obligations merged into Ch.3; Goals/Brain/People/Home/Knowledge/Search renumbered 4–9). Traced all time logic to `PerchDate`/`PerchEvents`. |
| Jul 4 2026 | Chapter 4 (Goals) written at status Prototype. Verified funded-savings loop Implemented; documented three-collection fragmentation (`future_horizon`/`goals`/`homestead.goals`); labeled hierarchy, non-financial types, and per-goal history as Concept. |
| Jul 4 2026 | Chapter 5 (Projects) written at status Concept. Verified no first-class project system exists (no collection, no type, no task/progress model); identified `homestead.maintenance`/`homestead.goals` as only project-adjacent data. Inserted Projects at slot 5; renumbered Brain/People/Home/Knowledge/Search to 6–10. |
| Jul 4 2026 | Chapter 6 (Brain) written at status Prototype. Verified typed first-class capture system Implemented (PerchParse, lifecycle, Today integration, source preservation); search is substring-only (no semantic/vector), no AI interpretation, no capture aging, belief emission gated off. Key distinction recorded: capture ≠ memory. |
| Jul 4 2026 | Perch v0.5 build plan created (`build_plans/perch-v0.5-build-plan.md`) — shortest trustworthy daily-use path; 6 trust risks, 4-phase build order, acceptance tests, daily-use script. |
| Jul 4 2026 | Chapter 7 (Truth Engine) written at status Prototype — the constitutional law chapter. Verified runtime truth logic (truth_level, confidence, thresholds, permission gate, contradiction handling) exists ONLY in `perch_beliefs.js`, belief-scoped, emission gated off. Confirmed no unified Truth Engine; enforcement is mostly editorial doctrine. Flagged editorial-only enforcement as the key structural trust risk; keystone fix = generalize the belief `evaluate()` gate. |
| Jul 4 2026 | Chapter 8 (Priority Engine) written at status Prototype. Identified FOUR independent scorers (`whyNowScore`, `priorityScore`, Today `_score`, PerchEvents sort) plus an orphan duplicate — not one engine. Confidence doesn't affect priority; Truth doesn't gate it; no user override; inconsistent tie-breaks; Recommendations reuse the priority scorer (blurring the boundary). Keystone fix = consolidate to one truth-gated scorer. |
| Jul 4 2026 | Chapter 9 (Recommendation Engine) written at status Prototype. Verified no standalone engine — `recommendation = recCandidates[0]` from `whyNowScore` (conflated with Priority). Real evidence-gated Life/Today suggestions with impact + reasoning and a genuine `_lpbSignal` feedback loop that suppresses declined types. Recommendations never auto-execute (key safety property), are not Truth-gated, and cross-domain synthesis is Concept (needs un-ingested data). Keystone fix = separate Recommendation from Priority, then Truth-gate. |
| Jul 4 2026 | Chapter 10 (Living World) written at status Concept. Entire Living World in code is one static, decorative `aria-hidden` SVG on Today — no world state, no data-driven rendering, no unlocks/evolution/shared state; `perch_world.md` is doctrine not loaded by code. Gap documented as deliberate discipline (world must reflect stored truth). Keystone = finish belief store + Truth-gated emission first. Canonical change log migrated to `CHANGELOG.md`. |
| Jul 5 2026 | Chapter 11 (Voice Engine) written at status Prototype. Identified THREE independent voice systems (`PerchVoice` learning-only, engine `buildOpening`/tone for Today's copy, `message_styles` wording selector); named Voice Engine doesn't phrase the main brief; Truth→Voice boundary is editorial not runtime. Keystone = route the brief through `PerchVoice`. |
| Jul 5 2026 | Chapter 12 (Knowledge & Search) written at status Prototype. Verified structured knowledge across three Learning/People stores plus Brain captures (unlinked); per-area confidence Implemented; keyword first-match recall and two substring searches Prototype. NO semantic search, NO vector search, NO knowledge graph, no unified index, no dedicated Search page. Merged Knowledge+Search in Atlas index. Keystone = unify search scope across all knowledge. |
| Jul 5 2026 | Chapter 13 (Integrations) written at status Concept. Exhaustive audit confirmed ZERO external integrations — only `fetch` is a local file-existence check; no API/import/sync/OAuth; all data manual; `localStorage` only; offline-first by omission. Tiller/Plaid/Calendar/Email/Weather/GitHub/Health all absent. Documented the rules future imports must obey (read-only, provenance-tagged, manual-wins, confidence-propagating, opt-in). Keystone = prove import rules with an on-device file before any live API. |
| Jul 5 2026 | Chapter 14 (Home & Property) written at status Prototype. Verified two `properties[]` records (primary and rental properties w/ real financials; rental cash flow surfaces on Today) and `homestead{}` (animals, four maintenance chores, greenhouse stub, empty log). NO location hierarchy, NO rooms/buildings/land, NO equipment, NO utility model (utilities are bills), NO maintenance history, NO Home page. Flagged Projects overlap and location hierarchy as foundational gap. Keystones = unify maintenance with Projects' task model, then build location hierarchy. |
