# Chapter 14 — Home & Property

> **Chapter:** Home & Property
> **Chapter ID:** PERCH-14
> **Version:** 1.0
> **Status:** Prototype — two real property records and a homestead structure (livestock, maintenance, a build stub) exist and partly surface on Today; there is **no location hierarchy, no rooms/buildings/land model, no equipment, and no dedicated Home page**.
> **Confidence:** 82% — the property/maintenance data is real and useful; the fuller "home as a place with structure" model is open design
> **Owner:** the user
> **Implementation:** Partial — `properties[]` (the primary property, the rental property) and `homestead{}` (animals, maintenance, goals, log) exist; most of the chapter's scope does not
> **Depends On:** Money *(Implemented math)*, Calendar & Obligations *(Implemented)*, Priority Engine *(Prototype)*, Projects *(Concept)*, Truth Engine *(Prototype)*
> **Last Updated:** July 5, 2026

*Home & Property is what Perch knows about the physical places a person owns and cares for — the primary residence, a rental, the land, the animals, the maintenance that never stops. The honest headline: Perch has a real but shallow property model (two properties with financials, a homestead with chores and livestock) and none of the structural depth the chapter's scope implies — no rooms, no buildings, no equipment, no location hierarchy. What exists is genuinely useful (the rental's cash flow and overdue maintenance both reach Today); what's missing is the entire notion of a home as a structured, navigable place.*

---

## 1. Purpose

This chapter governs Perch's model of the **physical places the user owns and maintains** — homes, rentals, land, the things on them, and the upkeep they require.

**Primary question this chapter answers:** *What do I own, and what needs care?*

---

## 2. Vision

A homestead is a living responsibility: a house, a rental generating income, land, animals, equipment, and an endless queue of maintenance. The vision is for Perch to hold the whole physical estate — what's where, what it's worth, what it produces, what it costs, and what needs doing — so the user can see their property at a glance and never be surprised by a lapsed filter or an overdue a livestock-care task. Eventually, the home is also a place the Living World reflects (Chapter 10): a real greenhouse, once built, appears in the scene.

The vision is bounded by current reality (§4): Perch models two properties financially and tracks a handful of chores. The rich structure — rooms, buildings, equipment lifecycles, utility tracking — is unbuilt.

---

## 3. Design Philosophy

- **Property is both asset and obligation.** A home is worth money (equity, cash flow) *and* costs attention (maintenance). Perch holds both truthfully.
- **Maintenance without nagging.** Overdue upkeep is surfaced as fact, never scolded (Voice rules, Chapter 3).
- **Financial truth for property.** Equity, cash flow, and costs obey Money's strict rules (Chapter 2) — no figure without a source.
- **The home can become a place.** Property is the most natural feeder of the Living World; a built project appears in the scene (Rule of Surprise).
- **Structure serves clarity, not inventory for its own sake.** Perch models what helps the user act, not an exhaustive asset registry.

---

## 4. Current Implementation (repo-verified)

Brutally honest, traced to code. Two structures carry everything.

### 4a. Properties (`properties[]`) — Prototype
Two seed records with real financial modeling:
- **primary property** — `type: 'primary_residence'`, notes (private amenity details, omitted here), priority-tagged homestead/financial.
- **rental property** — `type: 'rental'`, with `rent_monthly`, `mortgage_monthly`, `cash_flow_monthly`, `cash_on_cash_return`, `estimated_equity` (values omitted — private).
The rental's cash flow **surfaces on Today** (`snap.properties.find(p => p.type==='rental' && p.cash_flow_monthly>0)`). Seed-flagged and separable (`SEED_PROP_IDS`). **Status: Prototype** — real records, financially modeled, but only two, and only the rental's cash flow is actively used.

### 4b. Homestead (`homestead{}`) — Prototype
A structured object with four parts:
- **`animals[]`** — one entry: a livestock entry (count-level detail only). Minimal livestock model.
- **`maintenance[]`** — four chores with `urgency` bands (high / this_week / soon / upcoming), some with `cost_estimate`, `overdue_months`, or `days_since`: rental HVAC filter (overdue 4mo), lawn mow, a livestock-care task, gutter check.
- **`goals[]`** — one: greenhouse build (`cost_estimate`, `season`) — the Projects-adjacent stub (Chapter 5).
- **`log[]`** — empty; a placeholder for history.
**Status: Prototype** — maintenance is the most real part; it surfaces on Today and drives the `no_urgent_maintenance` OK-rule.

### 4c. How Home surfaces
- **Today — Needs Attention:** maintenance appears by urgency (`ATTN_TYPES` includes `maintenance`); urgent maintenance can block "clear."
- **Today — money:** the rental's `cash_flow_monthly` contributes to the financial picture.
- **Priority:** maintenance is scored as generic `urgency` (Chapter 8) — no property-specific priority.
- **No dedicated Home page** exists; property/homestead data is scattered across Today (and the Life page).

### 4d. What does NOT exist (verified absent)
- **No location hierarchy** — no property → building → room → item nesting. Properties are flat records.
- **No rooms, buildings, barns, sheds, or structures** as objects. ""pool," "workshop," "barn" appear only as **words in notes or a regex pattern**, never as modeled entities.
- **No equipment/appliance objects** — the HVAC filter is a maintenance chore, not a tracked piece of equipment with a lifecycle.
- **No utilities model** — electric/water/internet are **bills** (Chapter 2), not property-linked utilities.
- **No hot tub, pool, or workshop** as objects (only present in the primary property's notes).
- **No land/acreage model.**
- **No maintenance history** — `log[]` is empty; no completed-maintenance record.
- **No property valuation beyond the two seed figures** (equity/cash flow are static seed numbers).

---

## 5. Planned Architecture

- A **location hierarchy**: property → structure (house/barn/greenhouse) → room/zone → item/equipment.
- **Equipment records** with maintenance lifecycles (filter cadence, service history).
- **Utility tracking** linked to properties (not just bills).
- **Maintenance history** (the empty `log[]` filled).
- **Livestock detail** (counts, care schedules, costs).
- A **dedicated Home page** (Read/Explore).
- **Living World links** — built structures appear in the scene.
All Concept.

---

## 6. Property Model

*Prototype.* A property is `{ id, name, type, notes, priority_tags, [financials] }`. Rentals add `rent_monthly`, `mortgage_monthly`, `cash_flow_monthly`, `cash_on_cash_return`, `estimated_equity`. *Planned:* nested structures, equipment, utilities, valuation, and history per property.

## 7. Home Model

*Prototype.* The "home" is the `primary_residence` property (the primary property) plus the `homestead{}` object. There is no unified home model that ties a residence to its structures, rooms, equipment, animals, and upkeep — those live in separate places (property notes vs. homestead) and don't cross-reference.

## 8. Structural Elements (all Concept unless noted)

| Element | Status | Evidence |
|---|---|---|
| **Rooms** | Concept | Not modeled |
| **Buildings / structures** | Concept | Not modeled (greenhouse is a goal, not a structure) |
| **Land / acreage** | Concept | Not modeled |
| **Workshop** | Concept | Word only (regex/notes); the natural first World scene (Ch.10) |
| **Barn** | Concept | Not modeled |
| **Greenhouse** | Prototype (as a goal) | `homestead.goals` build stub — no structure object |
| **Pool** | Concept | the primary residence notes only |
| **Hot tub** | Concept | Not present anywhere |
| **Storage** | Concept | Not modeled |

## 9. Equipment

*Concept.* No equipment objects exist. The HVAC filter is a maintenance task, not a tracked appliance with a service lifecycle. Planned: equipment with cadence, cost, and history.

## 10. Maintenance

*Prototype (the strongest part).* Four chores with urgency bands, cost estimates, and overdue tracking; surfaces on Today; drives an OK-rule. This overlaps heavily with **Projects** (Chapter 5) — maintenance is project-adjacent chore data. Missing: completion history (`log[]` empty), recurrence (a filter is due every N months), and equipment linkage.

## 11. Utilities

*Concept (as property objects).* Utilities exist only as **bills** (electric, water, internet — Chapter 2). They are not linked to a property, have no usage tracking, and no utility model. A property-linked utility model is Concept.

## 12. Livestock

*Prototype (minimal).* One `animals` entry (livestock, count-level detail only). No counts, care schedules, costs, or per-animal detail. The livestock-care maintenance task is the only active livestock-linked behavior.

## 13. Storage

*Concept.* No storage/inventory model (what's in the barn, the shed, the garage).

## 14. Ownership

*Prototype.* Ownership is implicit: properties are the user's (primary property, rental property). `user_owned`/`seed` flags distinguish real from demo (Chapter 7). No co-ownership, no ownership share, no title detail.

## 15. Location Hierarchy

*Concept.* **The single biggest structural gap.** Properties are flat — there is no property → structure → room → item nesting. Perch cannot answer "what's in the barn?" or "what maintenance does the rental's kitchen need?" because it has no place to hang that structure.

## 16. Future Expansion

*Concept.* The homestead is explicitly a *growth* domain (the `homestead_expansion` priority, rank 3, "Develop the property — garden, animals, infrastructure"). The greenhouse is the first expansion. Planned expansion — new structures, more animals, more land use — has a priority home but no structural model to grow into.

---

## 17. Read Mode / Explore Mode

**Read Mode (Concept — no Home page):** planned to open with what needs care most (the overdue filter) and the property's standing (rental cash flow, equity). Today, this is scattered on Today's attention/money sections.

**Explore Mode (Concept):** the full estate — each property, its structures, equipment, animals, utilities, maintenance history. None exists.

---

## 18. Relationships

- **Money (Implemented math):** property financials (rental cash flow, equity, maintenance costs) obey Money's strict rules. The rental's cash flow already feeds Today's financial picture. Equity/cash-flow are static seed figures — a real valuation would need integration (Chapter 13).
- **Calendar & Obligations (Implemented):** maintenance is time-bound (overdue filter, seasonal greenhouse); surfaces through the obligation engine. Recurrence for maintenance (every-N-months filter) is the same gap as elsewhere (Chapter 3).
- **Projects (Concept):** homestead maintenance and the greenhouse are the primary project-adjacent data (Chapter 5). Home and Projects overlap heavily; a built project is a home structure.
- **Priority Engine (Prototype):** maintenance scored as generic urgency; no property-aware priority.
- **Living World (Concept):** the most natural feeder of the world — a built greenhouse, a workshop, the animals become scene elements (Chapter 10). Requires the structural model this chapter lacks.
- **Truth Engine (Prototype):** property figures are Facts (entered) or would be imported (Concept); maintenance overdue is a Derived Fact.
- **Health / People (future):** livestock care and family use of the property (the pool) connect here eventually.

---

## 19. Truth Rules (chapter-specific)

- **Property financials are Facts only when sourced** — the seed equity/cash-flow figures are user-entered; a market valuation would need a real source (never invented).
- **Maintenance overdue is a Derived Fact** (`overdue_months`, `days_since`) — stated plainly, never scolded.
- **Perch never invents structure** — it won't claim a room, building, or piece of equipment it wasn't told about.
- **Cost estimates are Estimates/Predictions**, phrased as such.

## 20. Known Unknowns

- **The actual estate** — Perch knows two properties and four chores; the real home has far more it wasn't told.
- **Equipment and its condition** — untracked.
- **Utility usage/cost trends** — utilities are bills, not modeled.
- **Maintenance history** — `log[]` empty; Perch can't say "you changed this filter in March."
- **Real property value** — equity is a static seed number, not a live valuation.
- **What's stored where** — no inventory.

## 21. What Does NOT Belong

- **No invented structure** — no assumed rooms, buildings, or equipment.
- **No property valuation without a source** — seed equity is not a market appraisal.
- **No maintenance nagging** — overdue stated, not scolded.
- **No exhaustive asset-registry bloat** — model what helps the user act.
- **No duplication of Projects** — home maintenance and projects should share one task model, not two.
- **No cost/estimate stated as certainty.**

## 22. Dependencies

- Money *(Implemented math)* — property financials, maintenance costs.
- Calendar *(Implemented)* — maintenance timing.
- Priority *(Prototype)* — surfacing upkeep.
- Truth Engine *(Prototype)* — sourcing property claims.

## 23. Missing Dependencies

- **Location hierarchy model** *(Concept)* — the foundational gap (property → structure → room → item).
- **Equipment records with lifecycles** *(Concept)*.
- **Utility model linked to properties** *(Concept)*.
- **Maintenance history + recurrence** *(Concept)*.
- **Dedicated Home page** *(Concept)*.
- **Living World structural links** *(Concept)*.
- **Property valuation via integration** *(Concept — Chapter 13)*.

## 24. Future Build Order

1. **Unify maintenance with Projects' task model** — one task/chore system, not homestead-maintenance and captures separately (resolves the Chapter 5 overlap).
2. **Maintenance history + recurrence** — fill `log[]`; make the filter recur every N months.
3. **Location hierarchy** — property → structure → room/zone → item. The foundation for everything richer.
4. **Equipment records** — with service cadence and history.
5. **Dedicated Home page** — Read/Explore over the estate.
6. **Utility model** — link utilities to properties, track usage.
7. **Living World links** — built structures appear in the scene (needs Ch.10).

Step 1 is the keystone: **one task model shared with Projects**, before adding structural depth.

## 25. Acceptance Tests

**Current (verified):**
- [x] Two properties (primary property, rental property) exist with financials.
- [x] The rental's `cash_flow_monthly` surfaces on Today.
- [x] `homestead{}` holds animals, maintenance, goals, and an (empty) log.
- [x] Four maintenance chores with urgency bands surface on Today; drive `no_urgent_maintenance`.
- [x] Seed vs. user property data is separable (`SEED_PROP_IDS`).
- [x] No rooms, buildings, land, equipment, or location hierarchy exist.
- [x] Utilities are bills, not property-linked objects.
- [x] Maintenance history (`log[]`) is empty.

**Planned (Concept — not built):**
- [ ] A location hierarchy nests structures/rooms/items under properties.
- [ ] Equipment records carry maintenance lifecycles.
- [ ] Maintenance has history and recurrence.
- [ ] Utilities link to properties with usage tracking.
- [ ] A dedicated Home page exists.
- [ ] Built structures feed the Living World.

## 26. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Properties | `properties[]` (the primary property, the rental property) in `perch_core.js` | Prototype |
| Rental financials | `cash_flow_monthly`/`estimated_equity` etc. | Prototype |
| Rental cash flow on Today | `snap.properties.find(...)` in `perch_today_live.html` | Implemented |
| Homestead | `homestead{}` (animals/maintenance/goals/log) | Prototype |
| Maintenance | `homestead.maintenance[]` + `no_urgent_maintenance` rule | Prototype |
| Livestock | `homestead.animals[]` (livestock) | Prototype (minimal) |
| Greenhouse | `homestead.goals[]` | Prototype (stub) |
| Maintenance history | `homestead.log[]` (empty) | Concept |
| Location hierarchy | — | Concept |
| Rooms/buildings/land | — | Concept |
| Equipment | — | Concept |
| Utilities (as property objects) | — | Concept (utilities are bills) |
| Dedicated Home page | — | Concept |

## 27. Notes

The honest headline: **Perch tracks two properties and four chores — real, useful, and shallow.** The property records are financially genuine (the rental's cash flow and equity are modeled, and the cash flow reaches Today), and the maintenance list does real work (overdue-aware, surfaces on Today, gates the "clear" state). The homestead object is a thoughtful little structure — animals, maintenance, goals, a log ready for history.

Answering the audit directly: **property model = two flat records with financials; home model = the primary residence plus the homestead object, not unified; no rooms, buildings, land, workshop, barn, hot tub, or storage as objects (only words in notes); greenhouse and pool exist as a goal-stub and a note respectively; equipment = none; utilities = bills, not property objects; livestock = one animals entry; maintenance = four real chores (the strongest part); ownership = implicit via seed/user flags; location hierarchy = none (the biggest gap); future expansion = a priority with no structural model to grow into.**

So the status is **Prototype**, and the pattern rhymes with the rest of the Bible: a small, real, useful implementation under a much larger planned architecture. The two keystones are (1) **unifying home maintenance with Projects' task model** — because a chore and a project step are the same kind of thing, and today they live in two places — and (2) **a location hierarchy**, the foundation that would let Perch finally model a home as a structured place rather than a flat record with a notes field. Until then, Perch knows the user owns two properties and owes four chores, tracks the rental's cash flow honestly, and says nothing it can't source.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 5 2026 | 1.0 | Chapter created at status Prototype. Verified two `properties[]` records (primary property, rental property with real financials; rental cash flow surfaces on Today) and a `homestead{}` object (animals, four maintenance chores, greenhouse goal stub, empty log). Confirmed NO location hierarchy, NO rooms/buildings/land, NO equipment objects, NO utility model (utilities are bills), NO maintenance history, NO dedicated Home page. Flagged heavy overlap with Projects (Ch.5) and the location hierarchy as the foundational gap. Keystones = unify maintenance with Projects' task model, then build a location hierarchy. |
