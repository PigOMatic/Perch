# Chapter 3 — Calendar & Obligations

> **Chapter:** Calendar & Obligations
> **Chapter ID:** PERCH-03
> **Version:** 1.0
> **Status:** Prototype — a real date engine and event-aggregation layer exist; a Calendar *page*, true recurrence, external calendars, and notifications do not
> **Confidence:** 88% — the obligation model and time horizons are settled; recurrence depth and external ingestion are open
> **Owner:** Jeff
> **Implementation:** Partial — `PerchDate` and `PerchEvents` are Implemented and power Today; no dedicated Calendar page exists
> **Depends On:** Priority Engine *(Prototype, in-engine)*, Recommendation Engine *(Concept)*, Truth Engine *(Implemented as doctrine)*, Notification system *(Concept)*
> **Last Updated:** July 4, 2026

*Calendar and Obligations are one chapter because in Perch they are inseparable. A calendar is just obligations and events placed in time. A bill is an obligation with a date. A shift is an obligation that recurs. A waiting item is an obligation someone else owes you. Splitting them would fracture a single truth. This chapter is held to the same strict standard as Money: a missed obligation or a phantom recurring event breaks trust as fast as a wrong balance.*

---

## 1. Purpose

This chapter governs everything Perch knows about **time** and **obligation**: what's due, what's coming, what recurs, what's overdue, what the user is waiting on, and how all of it is placed on a timeline the user can trust.

**Primary question this chapter answers:** *What's coming, and what do I owe (or am I owed)?*

---

## 2. Vision

The user should never be surprised by a date they could have known about. Not a bill, not a shift, not an anniversary, not a returning item they're waiting on. Perch holds the timeline so the user doesn't have to carry it in their head.

But holding the timeline is a promise, and a broken calendar promise is severe: a bill Perch failed to surface, a deadline it placed on the wrong day, a recurring event that silently stopped recurring. So the vision is bounded by strictness — **Perch surfaces an obligation only when it can trace the date to a real source, and it never implies it's tracking something it isn't.**

---

## 3. Design Philosophy

- **Time is a spine, not a grid.** Perch does not aspire to be a month-grid calendar app. Obligations flow along a timeline of horizons (today → someday). The grid, if it ever appears, is an Explore-Mode detail, never the Read-Mode surface.
- **Obligations are the unit, dates are the attribute.** Perch models *what must happen* and *what's owed*, and time is one property of each. This is why Calendar and Obligations are one chapter.
- **Overdue is stated, never scolded.** An overdue obligation is surfaced as a fact ("this was due Tuesday"), never as a reprimand. (Voice rules, §17.)
- **Absence of a date is honest, not hidden.** A someday item with no date is fine; Perch says "no date yet," it does not invent one.

---

## 4. Current Implementation (repo-verified)

Traced to code. This is what actually exists.

### 4a. The Date Engine — `PerchDate` (Implemented)
A complete, dependency-free date utility in `perch_core.js`. Verified functions:
- `today()` — midnight-normalized current date.
- `fmt(d)` / `fromStr(str)` — ISO string ↔ Date.
- `plusDays(n)`, `plusMonths(n)` — offsets.
- `thisWeekday(dow)`, `nextWeekday(dow)`, `thisSaturday()`, `nextThursday()`, `thisMonthDay(day)` — day resolution.
- `daysUntil(d)` — integer day delta.
- `intel(d)` — returns `{ daysUntil, isToday, isThisWeek (0–6), isThisMonth (0–30), isOverdue (<0) }`. **This is the core time-classification primitive.**
- `label(du)` — human day label ("today," "tomorrow," etc.).
- `weekRange(base)` — the current week's span.

**Status: Implemented.** Zero hardcoded years; all date logic flows through here.

### 4b. The Event Engine — `PerchEvents` (Implemented, aggregation-level)
`PerchEvents.all()` assembles a single unified event stream from four data sources, each normalized through `norm()` which attaches `PerchDate.intel()` classification:
- **Bills** → monthly, dated via `thisMonthDay(due_day)`.
- **Work schedule** → weekly, dated via `day_of_week`.
- **Work opportunities** → dated one-offs.
- **Future horizon** (goals, anniversaries, waiting items) → dated via `date_start`.
- **Captures** (Tell Perch: reminders, waiting-on, opportunities, recurring) → dated via `expected`.

Query methods, all verified: `getToday()`, `getOverdue()`, `getThisWeek()`, `getThisMonth()`, `getUpcoming(n)`, `getByPriority(pid)`, `getOpportunitiesThisWeek()`. Events are sorted by `daysUntil` ascending (nulls last), then score. Status filters exist: `DONE_STATUSES` (completed/resolved/dismissed/snoozed/archived) and `HIDDEN_STATUSES` (dismissed/snoozed/archived).

**Status: Implemented** as an aggregation-and-classification engine. This is more than a prototype — it's the working obligation backbone.

### 4c. Recurrence (Prototype)
Recurrence exists but is **implicit and fixed-interval**, not a true recurrence engine:
- Bills recur **monthly** by regenerating from `due_day` each load.
- Shifts recur **weekly** by regenerating from `day_of_week`.
- Captures can be tagged `recurring` → `weekly`.
- The Learning Engine recognizes recurrence *language* ("every Tuesday," "weekly," "most Fridays") via regex patterns.

**What does NOT exist:** arbitrary intervals ("every 3 weeks"), complex rules ("every 3rd Tuesday"), biweekly (the payday bug from Chapter 2 is the same limitation), end dates, or exceptions. There is no RRULE-style engine.

**Status: Prototype.** Monthly-and-weekly recurrence works; anything else is Concept.

### 4d. "Why now" timing (Prototype)
`whyNowScore()` in `perch_engine.js` scores obligations by timing urgency: `timedToToday` (+40), `timedToPayday` (+35), goal-connected (+20), high urgency (+25), with penalties for untimed/low-urgency items. This is how a dated obligation earns its way onto Today's note.

**Status: Prototype** (lives inside the engine; not yet a standalone Priority Engine — see Chapter 1 §5).

### 4e. Overdue & waiting (Implemented)
- **Overdue:** `intel().isOverdue` (daysUntil < 0); `getOverdue()` surfaces them; the `no_waiting_past_due` OK-rule checks waiting items past their expected date.
- **Waiting items:** modeled in two shapes — `future_horizon[]` with `status:'waiting_on'` + `date_start`, and `captures[]` with `perch_action:'waiting_on'` + `expected`. Both are tracked and can go overdue.

**Status: Implemented.**

---

## 5. Planned Architecture

The destination this Prototype converges toward:
- A dedicated **Calendar & Obligations page** with Read Mode (timeline) and Explore Mode (detail/grid).
- A true **recurrence engine** (arbitrary intervals, rules, exceptions, end dates).
- **External calendar ingestion** (read-only) beyond the internal work schedule.
- A **notification/surfacing system** so time-sensitive obligations reach the user off-screen.
- **Delegated obligations** (things the user owes *to* others, or has handed off) as a first-class type.

All of the above is Concept or Planning; none exists in code today.

---

## 6. Calendar Data Sources

| Source | Provides | Available? | Status |
|---|---|---|---|
| `work.schedule` | Weekly shifts | ✅ Manual | Implemented |
| `work.opportunities` | One-off work events | ✅ Manual | Implemented |
| `future_horizon` | Goals, anniversaries, milestones | ✅ Manual | Implemented |
| `captures` (event/recurring) | User-captured events | ✅ User input | Implemented |
| **External calendar (Google/Apple/Outlook)** | Everything else in the user's life | ❌ **No** | Concept — no ingestion path |

## 7. Obligation Data Sources

| Source | Provides | Available? | Status |
|---|---|---|---|
| `bills` | Recurring financial obligations | ✅ Manual | Implemented |
| `captures` (reminder) | One-time obligations | ✅ User input | Implemented |
| `captures` (waiting_on) | Items owed *to* the user | ✅ User input | Implemented |
| `future_horizon` (waiting_on) | Larger waiting items | ✅ Manual | Implemented |
| **Delegated items** (owed *by* user to others) | — | ❌ **No** | Concept |
| **Email-detected obligations** | Auto-found bills/deadlines | ❌ **No** | Concept (Inbox Intelligence) |

---

## 8. Current Date Engine

`PerchDate` (§4a). Fully Implemented. Every date in Perch is midnight-normalized and classified through `intel()`. No timezone handling beyond the device's local time — **Known Unknown** (§16): travel across timezones is not modeled.

## 9. Future Date Engine

Planned additions (Concept): timezone awareness, a true recurrence rule engine, relative-date resolution from natural language beyond the current regex set, and duration/all-day event modeling. None exist.

---

## 10. Time Horizons

How obligations are placed in time. All except "Someday" are Implemented via `PerchDate.intel()`.

| Horizon | Definition | Repo source | Status |
|---|---|---|---|
| **Today** | daysUntil === 0 | `intel().isToday`, `getToday()` | Implemented |
| **Tomorrow** | daysUntil === 1 | `PerchDate.label()` | Implemented |
| **This Week** | daysUntil 0–6 | `intel().isThisWeek`, `getThisWeek()` | Implemented |
| **This Month** | daysUntil 0–30 | `intel().isThisMonth`, `getThisMonth()` | Implemented |
| **Future** | daysUntil > 30 | `getUpcoming()` | Implemented |
| **Someday** | no date | *(items with null date, sorted last)* | Prototype — held but not a first-class horizon with its own view |
| **Overdue** | daysUntil < 0 | `intel().isOverdue`, `getOverdue()` | Implemented |

---

## 11. Obligation Model

The types Perch models, with honest status:

- **Recurring obligations** — bills (monthly), shifts (weekly). *Prototype* — fixed intervals only (§4c).
- **One-time obligations** — reminders via captures, dated future_horizon items. *Implemented.*
- **Conditional obligations** — obligations that depend on a condition ("if the ring arrives, then…"). *Concept* — not modeled; only unconditional dates exist.
- **Waiting items** — things owed *to* the user, with an expected date and overdue detection. *Implemented.*
- **Delegated items** — things the user has handed to someone else to do. *Concept* — not modeled.
- **Deadlines** — a dated obligation with consequence weight. *Prototype* — dates exist; "deadline" as a distinct high-stakes type with escalation does not.

---

## 12. Scheduling Philosophy

Perch does not schedule *for* the user (it books nothing, moves nothing). It **surfaces** what's already true about their time and helps them see it clearly. Any future scheduling capability (suggesting when to do something) is a Recommendation-Engine function, Concept, and bound by the same evidence rules — Perch may only suggest timing it can justify from real data (a free day on the schedule, a bill's real due date). It must never invent availability.

---

## 13. Read Mode (planned)

*Status: Concept — no Calendar page exists.*

Read Mode opens with the nearest, most-consequential obligation in plain language — the timeline's "hero":

> "Duke Energy lands tomorrow, and you're on at 7 the next three nights."

Then a short, scannable horizon: today, this week, what's overdue (if anything), what you're waiting on. Prose and a light timeline, never a month grid as the default. Same subtraction discipline as Today.

## 14. Explore Mode (planned)

*Status: Concept.*

The full timeline: a scrollable horizon or optional month grid, each obligation expandable to its detail (amount, source, recurrence, history), waiting items with their expected dates, and the full recurrence picture. Calm, readable, never a wall of tiles.

---

## 15. Engine Relationships

**Priority Engine (Prototype, in-engine):** timing is a primary priority input. `whyNowScore` already boosts today-timed (+40) and payday-timed (+35) obligations. A standalone Priority Engine would let the Calendar page rank its own obligations (which deadline outranks which) and let a critical dated obligation rise onto Today.

**Recommendation Engine (Concept):** the source of any *timing suggestion* ("Thursday looks like the day to mow — you're off and rain's coming Friday"). This is the canonical cross-domain recommendation and it needs weather + calendar + home data Perch lacks (Chapter 1 §7). Forbidden until those sources exist.

**Living World (Concept for this chapter):** obligations do not render world scenery. Seasonal or event-based world touches (a festival, a holiday) are a distant `Concept`; the Calendar page itself is utilitarian and renders no world.

---

## 16. Known Unknowns

The limits of Perch's time picture. Not bugs — boundaries, stated so the user knows where the timeline's certainty ends.

- **Anything not entered.** Perch only knows obligations the user (or a seed) put in. An unentered appointment is invisible.
- **External calendars.** Google/Apple/Outlook events are not ingested.
- **Timezones & travel.** All dates are device-local; crossing timezones is not modeled.
- **Complex recurrence.** "Every 3rd Tuesday," biweekly, custom intervals, end dates, and exceptions are not supported.
- **Conditional and delegated obligations.** Not modeled.
- **All-day vs timed vs duration.** Events carry a date and optional time; true duration/all-day semantics are not modeled.
- **Real-time changes.** No live sync; the timeline is as-of-last-entry.

Because of these, Perch's timeline is *"everything you've told me, placed in time"* — never *"everything in your life."*

---

## 17. Truth Rules (chapter-specific)

Applying `perch_truth.md` and the Bible's global laws to time:
- A date is a **Fact** only if it traces to a stored source. Perch shows no date it can't source.
- "Overdue" is a **Derived Fact** (daysUntil < 0) — stated plainly, never as blame.
- "You're free Thursday" is an **Interpretation** (absence of known obligations ≠ actual freedom — see Known Unknowns) and must be phrased as such: "nothing on Perch's calendar Thursday," not "you're free Thursday."
- A recurring event's *next* occurrence is a **Prediction** when it depends on the pattern holding; if the pattern is fixed (monthly bill), it's a Derived Fact. Perch distinguishes them.
- **Perch never invents a date.** No date is ever guessed to fill a gap. A someday item stays dateless.

## 18. Voice Rules (chapter-specific)

- Timing folded into observation, never stated as a bare label ("This lands tomorrow," not "Due: tomorrow"). (Established in Chapter 1's subtraction pass.)
- Overdue stated without reproach: "This was due Tuesday" — never "You missed this."
- Waiting items phrased as awaited, not nagged: "Maura's ring is expected back around the 14th."
- No false urgency. An untimed item is not dressed as urgent.

---

## 19. Source Lineage examples

Every obligation answers "where did this come from?"

Monthly bill, today:
```
"Duke Energy lands tomorrow"
    ↓  PerchEvents.all()  (bill → monthly event)
    ↓  PerchDate.thisMonthDay(due_day)
    ↓  bills[].due_day
    ↓  Manual User Entry
```

Waiting item:
```
"Maura's ring is expected back around the 14th"
    ↓  PerchEvents  (captures → waiting_on)
    ↓  captures[].expected
    ↓  Manual User Entry (Tell Perch)
```

Future, with external calendar (Concept):
```
"Dentist at 2pm Thursday"
    ↓  Calendar page
    ↓  external calendar ingestion
    ↓  Google Calendar API
```

---

## 20. Statement Classification examples

| Statement | Classification |
|---|---|
| Electric bill due July 12 | **Fact** |
| Anniversary is in 23 days | **Derived Fact** (daysUntil) |
| This was due Tuesday | **Derived Fact** (isOverdue) |
| Nothing on your calendar Thursday | **Interpretation** (bounded by Known Unknowns) |
| Your next shift is probably Friday | **Prediction** (recurrence assumption) |
| Good day to mow Thursday | **Recommendation** (cross-domain; Concept) |

---

## 21. What Does NOT Belong

- **No month-grid as the default surface.** The grid is Explore-Mode at most; Read Mode is a timeline of obligations.
- **No scheduling on the user's behalf.** Perch books/moves nothing.
- **No invented dates or invented availability.**
- **No "you're free" claims** — only "nothing on Perch's calendar," bounded by Known Unknowns.
- **No overdue shaming.**
- **No notification spam** — when notifications exist, they follow the Rule of Surprise's restraint: only genuinely time-critical, never nagging.
- **No cross-domain timing recommendation** until weather/calendar/home data is ingested.

---

## 22. Dependencies

- Truth Engine *(Implemented as doctrine)* — governs every date claim.
- Priority Engine *(Prototype, in-engine)* — ranks obligations by timing.
- `PerchDate` / `PerchEvents` *(Implemented)* — the working backbone.

## 23. Missing Dependencies

- **Recurrence engine** *(Concept)* — for anything beyond monthly/weekly.
- **External calendar ingestion** *(Concept)* — the biggest gap; most of a user's real calendar is invisible without it.
- **Notification system** *(Concept)* — obligations currently surface only when the app is open.
- **Recommendation Engine** *(Concept)* — for timing suggestions.
- **Timezone handling** *(Concept)*.

---

## 24. Future Build Order

1. **Consolidate a Calendar & Obligations page** from the existing `PerchEvents` engine — Read Mode timeline first. *(Backbone already exists.)*
2. **Someday as a first-class horizon** — a home for dateless obligations.
3. **True recurrence engine** — replace fixed monthly/weekly with real rules; fixes the biweekly bug (shared with Chapter 2).
4. **Delegated + conditional obligations** — new obligation types.
5. **External calendar ingestion** (read-only) — the big unlock.
6. **Notification system** — off-screen surfacing, restraint-bound.
7. **Timing recommendations** — only after calendar + weather data exist.

Each step independently testable, following the established pattern (data → classify → surface → gate).

---

## 25. Acceptance Tests

**Date engine (Implemented — verified):**
- [x] `intel()` correctly classifies today/thisWeek/thisMonth/overdue by daysUntil.
- [x] Dates are midnight-normalized; no hardcoded years.
- [x] Overdue is daysUntil < 0.

**Event engine (Implemented — verified):**
- [x] Bills, shifts, opportunities, future_horizon, and captures all aggregate into one event stream.
- [x] Done/hidden statuses are filtered from the appropriate queries.
- [x] Events sort by daysUntil ascending, nulls last.
- [x] Waiting items go overdue past their expected date.

**Recurrence (Prototype — honest limits):**
- [x] Bills recur monthly; shifts recur weekly.
- [ ] Arbitrary intervals / rules / exceptions (Concept — not built).
- [ ] Biweekly handled correctly (shared bug with Chapter 2).

**Calendar page (Concept — not built):**
- [ ] Read Mode opens with the nearest consequential obligation in prose.
- [ ] "Free" is never claimed; only "nothing on Perch's calendar."
- [ ] Every obligation exposes its source lineage.

---

## 26. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Date primitives | `PerchDate` in `perch_core.js` | Implemented |
| Event aggregation | `PerchEvents` in `perch_core.js` | Implemented |
| Time classification | `PerchDate.intel()` | Implemented |
| Overdue / waiting | `getOverdue()`, `no_waiting_past_due` rule | Implemented |
| Recurrence (fixed) | bill `due_day`, shift `day_of_week` | Prototype |
| Recurrence language | Learning Engine regex (`perch_learn.js` / core patterns) | Prototype |
| Why-now timing | `whyNowScore()` in `perch_engine.js` | Prototype |
| Calendar page | — | Concept |
| External calendar | — | Concept |
| Notifications | — | Concept |
| Delegated/conditional obligations | — | Concept |

---

## 27. Notes

The honest headline: **Perch has a genuinely strong obligation backbone and no calendar page.** `PerchDate` and `PerchEvents` are among the most solid, well-factored code in the repository — a real event engine that classifies everything by time horizon and already feeds Today. What's missing is (a) a surface dedicated to it, (b) recurrence beyond fixed monthly/weekly, and (c) the whole external-calendar and notification story.

This is the inverse of Money: Money had strong math and a weak page-story with dangerous gaps; Calendar has a strong engine and simply hasn't been given its own room yet. The Prototype status reflects that — more built than Money's Concept, less finished than Today's page.

The single biggest trust risk here is the **Known Unknowns gap**: because Perch only sees entered obligations, a user could over-trust an empty calendar. Every "nothing scheduled" statement must be bounded as "nothing *on Perch's* calendar." That distinction is the difference between honest and dangerous.

---

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Prototype. Verified `PerchDate` and `PerchEvents` Implemented; recurrence and why-now Prototype; Calendar page, external ingestion, notifications, delegated/conditional obligations Concept. Traced all time logic to `perch_core.js` / `perch_engine.js`. Flagged timezone and empty-calendar-trust as key gaps. |
