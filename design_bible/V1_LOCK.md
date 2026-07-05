# Perch Design Bible — v1.0 Lock

**Lock date:** July 5, 2026  
**Lock type:** Architecture baseline  
**Repository:** `PigOMatic/Perch`  
**Branch prepared from:** `main`

---

## What is locked

The Design Bible is locked as the authoritative product architecture for Perch v1.0.

This lock covers:

- The three-layer model: Vision, Design Bible, Repository
- The Atlas chapter map
- The core domain and engine boundaries
- Global trust laws
- Status language
- Source lineage requirements
- The rule that every feature must have a home

---

## What is not claimed

This lock does **not** claim that:

- Every chapter is implemented.
- Every chapter has equal depth.
- Chapters 15–19 are as deeply audited as chapters 1–14.
- The repository already matches the finished product.
- External integrations, semantic search, full world state, or unified engines exist.

Those claims would be false. v1.0 is an architecture baseline, not a production-complete implementation certificate.

---

## Locked chapter map

| # | File | Status at lock |
|---|---|---|
| 1 | `chapters/01-today.md` | Prototype |
| 2 | `chapters/02-money.md` | Concept / Partial |
| 3 | `chapters/03-calendar-obligations.md` | Prototype |
| 4 | `chapters/04-goals.md` | Prototype |
| 5 | `chapters/05-projects.md` | Concept |
| 6 | `chapters/06-brain.md` | Prototype |
| 7 | `chapters/07-truth-engine.md` | Prototype |
| 8 | `chapters/08-priority-engine.md` | Prototype |
| 9 | `chapters/09-recommendation-engine.md` | Prototype |
| 10 | `chapters/10-living-world.md` | Concept |
| 11 | `chapters/11-voice-engine.md` | Prototype |
| 12 | `chapters/12-knowledge-search.md` | Prototype |
| 13 | `chapters/13-integrations.md` | Concept |
| 14 | `chapters/14-home-property.md` | Prototype |
| 15 | `chapters/15-people.md` | Concept |
| 16 | `chapters/16-home.md` | Concept |
| 17 | `chapters/17-knowledge.md` | Concept |
| 18 | `chapters/18-search.md` | Concept |
| 19 | `chapters/19-atlas.md` | Concept |

---

## Known lock caveats

The following are intentionally left as future work after v1.0 lock:

1. **Chapters 15–19 need deeper implementation audits.** They now have canonical homes and metadata, but are not as mature as chapters 1–14.
2. **Chapter overlap remains deliberate.** Chapter 12 documents current combined Knowledge & Search; chapters 17 and 18 define future separated domains. Chapter 14 documents current Home & Property; chapter 16 defines the future dedicated Home surface.
3. **Runtime truth enforcement is incomplete.** Truth doctrine exists, but universal runtime enforcement does not.
4. **Priority and Recommendation are not fully separated in code.** Their boundaries are defined here before the code catches up.
5. **Integrations are absent.** Banking, calendar, email, weather, and other external sources are future work.
6. **Living World is philosophical, not yet systemic.** It must not render unsupported facts.

---

## Change control after lock

After this lock, changes to the Design Bible should be made through pull requests that clearly label one of these types:

- **Clarification** — improves wording without changing architecture.
- **Correction** — fixes inaccurate implementation or status claims.
- **Expansion** — adds detail to a locked chapter without changing boundaries.
- **Architecture change** — changes domain boundaries, engine responsibilities, or global law.

Architecture changes require an ADR in `design_bible/decisions/`.

---

## Lock statement

Perch Design Bible v1.0 is locked as the canonical architecture baseline for future design, implementation, AI-agent work, and repository review.

> The Bible is the destination. The repository is the journey.
