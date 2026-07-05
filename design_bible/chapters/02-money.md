# Chapter 2 — Money

> **Chapter:** Money
> **Chapter ID:** PERCH-02
> **Version:** 1.0
> **Status:** Concept — no standalone Money page exists; money logic lives inside Today and Life
> **Confidence:** 85% — the questions and truth rules are settled; the page form and banking depth are not
> **Owner:** Jeff
> **Implementation:** Partial — core money *math* is built and shipping inside other pages; a dedicated Money page is not built
> **Depends On:** Money Intelligence *(Concept)*, Priority Engine *(Prototype, in-engine)*, Recommendation Engine *(Concept)*, Inbox Intelligence *(Concept)*, Truth Engine *(Implemented as doctrine)*
> **Last Updated:** July 4, 2026

*Money is held to a stricter standard than every other chapter. A wrong number on the Money page doesn't just look bad — it makes the user distrust every number Perch has ever shown them. Trust in money breaks fast and comes back slowly. So this chapter's rule is: **Perch shows a financial figure only when it can name exactly where that figure came from, and it says "I don't track that" the instant it can't.***

---

## 1. Vision

Money answers the question a person carries quietly all the time: **where do I stand, and what changed?** Not "here is a budget to maintain" — that's a chore. Money's job is to let someone glance and *know*: am I covered until payday, is anything about to go wrong, did anything move since I last looked.

Money is the highest-stakes chapter because it's the one where Perch's core promise — clarity you can trust — is tested against hard numbers the user can independently verify. If Perch says "$1,240 to breathe with" and the real figure is $900, the whole product is finished. So Money is where the epistemology in `perch_truth.md` is enforced most literally: **every figure is a Fact traceable to stored data, or it is not shown.**

**Primary question this page answers:** *Where do I stand financially, and what changed?*

---

## 2. Questions Answered

- **Primary:** Am I covered until payday?
- **Primary:** What's my balance, and what's already spoken for?
- **Primary:** What changed since I last looked?
- **Secondary:** What bills are coming, and when?
- **Secondary:** When's payday, and how much?
- **Secondary:** How much can I safely move toward a goal right now?
- **Occasional (all Concept):** Am I being charged twice for something? Is a subscription creeping up? Where did the money go last month?

The occasional questions are the ones that require data Perch doesn't have. They are specified below and marked honestly — they are the reason Money Intelligence is a `Concept` engine, not a `Planning` one.

---

## 3. Current Money Flow behavior (repo-verified)

This is exactly what the repository computes today, traced to source. Every figure below is a **Fact** derived from manually-entered data.

**The core computation — `financeSnapshot()` in `perch_core.js`:**
- **Balance** = the balance of the account whose name matches `/check/i` (checking), or the first account if none matches, or `0`. *Only the checking account is read.* Savings and other accounts are not included in the working figure.
- **Bills before payday** = unsettled bills (`status` not in `paid_this_month`, `pulled_this_month`, `skipped_this_month`, `completed`, `dismissed`) whose due date falls on or after today and strictly before the next payday. A bill due *on* payday is treated as covered by that deposit.
- **Total before** = the sum of those bills' amounts.
- **Projected** = `balance − totalBefore`. This is the single most important number Perch computes: what the user will have left after the bills that land before their next paycheck.
- **Covered** = `projected >= 0`.
- **Safe until payday** = currently an alias for `projected`.

**Payday — `getNextPayday()`:**
- Reads `finances.paycheck.next_date` and `.amount`.
- If the stored date is in the past, it **steps forward by 7 days** until it's in the future, flagging `stale`.
- **Known imprecision (disclosed):** the step is weekly (7 days) even when the user's pay is biweekly. The code comment acknowledges biweekly is "not assumed." This means a stale biweekly payday can roll to the wrong week. *This is a real limitation and is logged as a defect to fix before the Money page ships — see §12.*

**Bill lifecycle — monthly reset:**
- `resetMonthlyBillStatuses()` runs on load; when the month changes, bills marked `paid/pulled/skipped_this_month` reset to `active`. This is how recurring monthly bills come back each month. All manual.

**Where money currently surfaces (there is no Money page):**
- **Today → payday card** (`renderPaydayCard`): appears when payday lands. Shows amount landed, cushion after bills, and goal room.
- **Today → bills card / pay card** (`renderBillsCard`, `renderPayCard`): upcoming bills and pay context.
- **Life page:** goal funding math, "safe to move" transfer suggestions (`Math.min(balance*0.15, remaining/4)`), projected goal completion dates.
- **The "My OK" check** (`evaluateOK`): a `bills_before_payday` rule that passes/fails on `projected < 0`.

**Status of the above: Implemented** — but scattered across Today and Life, not consolidated into a Money chapter.

---

## 4. What is Manual vs. Inferred

The single most important honesty table in this chapter.

| Figure | How Perch knows it | Class |
|---|---|---|
| Checking balance | User typed it | **Manual** |
| Bill amount & due day | User typed it | **Manual** |
| Paycheck amount & date | User typed it | **Manual** |
| Bill is autopay vs manual | User set it | **Manual** |
| Bills-before-payday total | Summed from manual bills | **Inferred (Fact-level arithmetic)** |
| Projected balance | `balance − billsBefore` | **Inferred (Fact-level arithmetic)** |
| Covered / not covered | `projected >= 0` | **Inferred (Fact-level arithmetic)** |
| Next payday (when rolled) | Stepped forward from stored date | **Inferred (with known weekly-step imprecision)** |
| Safe-to-move-to-goal amount | Heuristic (`balance*0.15` etc.) | **Inferred (Inference-level — a suggestion, not a fact)** |
| Actual spending / where money went | — | **Not tracked** |
| Duplicate or recurring charges | — | **Not tracked** |
| Real-time balance | — | **Not tracked** (balance is as-of-last-entry) |
| Income other than the one paycheck | — | **Not tracked** |

**The rule this table enforces:** anything in the "Manual" or "Fact-level arithmetic" rows may be stated plainly. The "Inference-level" row (safe-to-move) must be phrased as a suggestion. The "Not tracked" rows must **never** be implied to exist — Perch may not hint at spending patterns, duplicate charges, or a live balance it doesn't have.

---

## 4a. Financial Truth vs. Financial Interpretation

The distinction every financial feature inherits. These are two different kinds of statement and must never be blurred.

**Financial Truth (objective — stored or computed):**
- Current checking balance
- Bill due dates
- Bill amounts
- Next payday
- Account balances
- Posted transactions *(when banking exists)*

**Financial Interpretation (judgment — from the engines):**
- "You're safe until payday."
- "Delay this purchase."
- "You can afford this."
- "You're falling behind."
- "You should pay Card A first."

Truth is objective and stated plainly. Interpretation comes from the Recommendation Engine (or a future Money Intelligence engine) and **must always expose its reasoning** — the user can see the Facts the judgment rests on. Perch may show "$1,042 in bills land before payday" (Truth) and, separately and visibly reasoned, "so you're covered with room" (Interpretation). It must never present the second as if it were the first.

---

## 4b. The strict confidence policy

Most of Perch can tolerate uncertainty. Money cannot. Every money statement is classified, and the classes are never blurred (this applies the global statement-classification law from the Bible README, made absolute here):

| Statement | Classification |
|---|---|
| Checking balance: $2,183 | **Fact** |
| Electric bill due July 12 | **Fact** |
| Bills before payday: $1,042 | **Derived Fact** |
| You should wait until Friday to buy this | **Recommendation** |
| You'll be fine this month | **Prediction** |

Facts and Derived Facts may be stated plainly. Recommendations must expose their reasoning. Predictions must expose their assumptions *and* their uncertainty — a prediction stated as a fact is the most dangerous thing Perch could do with money. Nothing in Money blurs these lines.

---

## 4c. Known Unknowns

These are not bugs. They are the **limits of the available data**, and stating them upfront is itself a trust-builder — it tells the user exactly where Perch's picture ends. Every figure Money shows is true *within* these limits, and Perch should be ready to name them when a number might be affected.

- Pending debit-card authorizations not yet posted
- Paper checks written but not yet cleared
- Cash spending
- Offline / in-person purchases
- Manual bills the user hasn't entered
- Future income not recorded (side work, gifts, reimbursements)
- Recurring subscriptions not yet discovered

Because of these, the balance Perch shows is *"what you've told me, as of your last entry"* — never *"what's in your account right now."* When banking integration lands, some of these unknowns close (posted transactions become visible) but others never do (cash spending, uncleared checks). The Known Unknowns list is permanent and evolves; it is never claimed to be empty.

---

## 4d. Source lineage

Every number in Money must answer **"where did this come from?"** with a complete chain to its origin. This makes trust debuggable and gives the user (and us) a way to audit any figure.

Today, manual:
```
Projected Balance
    ↓  Finance Snapshot (balance − billsBefore)
    ↓  Checking Balance
    ↓  Manual User Entry
```

Future, with banking:
```
Projected Balance
    ↓  Checking Account
    ↓  Plaid / aggregator
    ↓  Bank
```

No figure ships without a lineage this explicit. When two sources in a lineage disagree (e.g. a manual balance and a bank-fed balance), see the trust rule in §13: Perch shows the disagreement, it does not silently pick one.



---

## 5. Read Mode (planned)

*Status: Concept — this page does not exist yet.*

The Money page's Read Mode should open with a single, plain-language standing statement — the money equivalent of Today's hero:

> "You're covered through payday, with about $1,240 after the bills that land first."

or, when not covered:

> "Two bills land before payday and they run about $180 past your balance."

Then, beneath: what changed since last look, the next bill, and payday. Prose first, never a grid of account tiles. The same note-first, subtraction-driven philosophy as Today (see Chapter 1). No charts as headlines. The number the user needs is in the sentence; supporting figures sit quiet beneath.

**Every figure in Read Mode is Fact-level or it is not shown.** The standing statement is built only from balance, bills-before-payday, and payday — all Facts.

---

## 6. Explore Mode (planned)

*Status: Concept.*

Explore Mode is where the user digs into the money picture: the full bill calendar, each bill's history, account detail, goal-allocation modeling ("if I move $200, here's what payday looks like"). Still calm, still readable — a more detailed page of the same notebook, not a banking dashboard.

Explore Mode is also where **Money Intelligence** features would eventually live (spending review, duplicate detection) — every one of them gated on data Perch cannot yet ingest (§8).

---

## 7. Information Hierarchy & Priority Impact

**What rises on Money:** coverage status first (am I okay?), then what changed, then the nearest obligation. The Priority Engine decides ordering.

**Priority Engine dependency (Prototype, in-engine):** the existing scorer already boosts money items — `context.shortMoney && rec.type==='bill'` adds +30, and bills timed to today/payday score highest. So money already influences what rises *on Today*. A standalone Priority Engine would let the Money page rank its own contents (which bill matters most, whether coverage risk outranks a goal nudge) with the same brain. Until then, Money's internal hierarchy is hardcoded, not engine-driven.

**Cross-page priority impact:** a coverage risk (`projected < 0`) is one of the highest-priority signals in all of Perch — it should be able to rise onto Today's note. This is already partially true via the `bills_before_payday` OK rule.

---

## 8. Recommendation Rules & Limits

Money is where recommendation discipline matters most. **A money recommendation without a named evidence source is forbidden.**

**What Money may recommend today (evidence-based, shipping):**
- "There's room to add toward Yellowstone" — evidence: `projected > 0` by more than the suggested amount. This is the only money recommendation currently made, and it's phrased as availability, not advice.

**What Money may recommend once its engines exist (Concept, with required evidence):**
- "This looks like a duplicate charge" — **requires transaction ingestion.** Forbidden until then.
- "This subscription went up $4 this month" — **requires transaction history.** Forbidden until then.
- "You could move $200 to savings and still cover everything" — allowed *now* as an Inference-level suggestion, because it's computed from Facts (balance, bills). This is the boundary case: it's permitted because every input is real.

**The canonical cross-domain recommendation** ("Tuesday is cool, you're off... good day to mow") does not belong to Money and is Concept (Chapter 1, §7).

**Forbidden on Money, permanently:**
- Never state or imply a balance more recent than the user's last entry. Perch does not have live banking.
- Never claim a spending pattern ("you spent more on dining this month") without transaction data.
- Never flag a duplicate or recurring charge without transaction data.
- Never present an Inference-level suggestion (safe-to-move) as a Fact.
- Never guess income Perch wasn't told about.

---

## 9. Data Sources

| Data | Source | Available today? | Ingestion path (if not) |
|---|---|---|---|
| Checking balance | `finances.accounts` | ✅ Manual | User enters/updates |
| Other accounts (savings etc.) | `finances.accounts` | ✅ Stored, ⚠️ not used in projection | Only checking feeds `projected` today |
| Bills | `bills` | ✅ Manual | User enters |
| Paycheck | `finances.paycheck` | ✅ Manual | User enters |
| Bill paid/pulled/skipped state | `bills[].status` | ✅ Manual | User marks |
| **Live balance** | bank | ❌ **No** | *Banking API / aggregator. Concept. Blocks any "current balance" claim.* |
| **Transactions** | bank / Tiller | ❌ **No** | *Tiller import or banking API. Concept. Blocks spending, duplicates, recurring-charge detection.* |
| **Bills from email** | inbox | ❌ **No** | *Inbox Intelligence. Concept. Would reduce manual bill entry.* |
| **Multiple income sources** | — | ❌ **No** | *Only one paycheck modeled. Concept.* |

**The through-line:** every money figure Perch shows today comes from something the user typed. Every ambitious Money Intelligence feature — spending, duplicates, live balance, auto-entered bills — waits on an ingestion path that does not exist. The Bible states this plainly so no reader mistakes the ambition for reality.

---

## 10. Future Banking Integration (Concept)

The dependency that unlocks most of Money Intelligence. Specified now, built later, deliberately.

- **Read-only aggregation** (balance + transactions) via a banking aggregator or Tiller sheet import.
- **Strict posture:** read-only always; Perch never moves money. Local-first if feasible. Full disclosure of what's connected.
- **What it unlocks:** live-ish balance, spending review, duplicate-charge detection, subscription-creep alerts, real "where did it go" answers.
- **What it must not change:** the truth rules. A figure from a bank feed is still shown only when Perch can name it as such and timestamp it ("as of this morning"). Aggregated data is not a license to guess; it's more Facts to be honest about.
- **Sequencing:** banking integration should not begin until the Money page's manual-data Read Mode is shipped and trusted. Walk before running.

---

## 11. Acceptance Tests

**Current money math (Implemented — verified in repo):**
- [x] `projected` = checking balance minus bills strictly before payday.
- [x] A bill due *on* payday is treated as covered.
- [x] Settled bills (paid/pulled/skipped/dismissed) are excluded from the projection.
- [x] Monthly bill statuses reset when the month changes.
- [x] `covered` is true iff `projected >= 0`.
- [x] Only the checking account feeds the working figure (documented limitation).

**Known defects to fix before Money page ships:**
- [ ] Biweekly payday rolls forward by 14 days, not 7, when stale.
- [ ] Projection optionally accounts for non-checking accounts or is explicitly labeled "checking only."

**Money page (Concept — not built):**
- [ ] Read Mode opens with a plain-language coverage statement built only from Facts.
- [ ] No figure appears whose source can't be named.
- [ ] "What changed" reflects real deltas since last view.

**Recommendation limits (enforced always):**
- [ ] No duplicate/spending/live-balance claim appears without the corresponding data source connected.
- [ ] Safe-to-move suggestions are phrased as suggestions, never facts.

---

## 12. Implementation Notes & Build Order

1. **Fix the biweekly payday step** in `getNextPayday` — a correctness bug that matters more on a Money page than anywhere else. *Highest priority; it's a trust bug.*
2. **Decide the account-scope rule** — either include savings in a clearly-labeled way or state "checking only" explicitly. No silent partial truth.
3. **Extract money surfaces** from Today/Life into a dedicated Money page with a Fact-only Read Mode.
4. **Build "what changed"** — deltas since last view, from stored snapshots.
5. **Explore Mode** — bill calendar, allocation modeling.
6. **Banking integration** (Concept) — only after 1–5 ship and are trusted.
7. **Money Intelligence** (Concept) — duplicates, spending, subscriptions — each unlocked only by the data source it needs.

Each step testable in isolation, following the established pattern (data → math → surface → gate).

---

## 13. What Money Must Never Claim Without Source Data

The stricter core of this chapter. Above every rule below sits one sentence:

> **Perch never invents financial certainty.**

And its corollary, for when data conflicts: **if two sources disagree, show the disagreement, explain it, and never silently choose one.** A manual balance that conflicts with a bank-fed balance is surfaced as a conflict, not resolved behind the user's back.

The absolutes:

- **Never a live balance.** The balance is as-of-last-entry. Perch may say "last you told me, $3,241," never "you have $3,241 right now."
- **Never a spending claim** — no "you spent," "you usually spend," "dining was up" — without transaction data.
- **Never a duplicate or recurring-charge flag** without transaction data.
- **Never invented income.** One paycheck is modeled; Perch doesn't assume others.
- **Never an Inference dressed as a Fact.** Safe-to-move is a suggestion; coverage is a fact. They are phrased differently.
- **Never a projection that hides its scope.** If only checking is counted, that's stated.
- **Never a figure without a nameable source.** The universal rule: if Perch can't say where a number came from, Perch doesn't show the number.

---

## 14. What Does Not Belong on Money

- **No budgeting nag.** Perch is not a budget you maintain; it's clarity you glance at.
- **No account-tile dashboard.** Prose-first, like Today.
- **No charts as headlines.** A figure lives in a sentence; charts support in Explore Mode only.
- **No gamified savings streaks.**
- **No financial *advice*** (what to invest in, whether to buy) — Perch presents standing and facts; it does not advise. (Reinforces the assistant's general posture: information, not recommendation, on regulated decisions.)
- **No cross-domain recommendation** until data sources are real.

---

## 15. Living World Relationship

Money's relationship to the world is indirect. Financial priorities (e.g. "Financial Freedom") can influence world districts per `perch_world.md` (finances → workshop/storage improves), but **the Money page itself renders no world** — it is the most utilitarian chapter, and clarity dominates entirely. Any world presence on Money is a distant future consideration, `Concept` at most.

---

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 4 2026 | 1.0 | Chapter created at status Concept (no standalone page). Core money math verified Implemented and traced to `financeSnapshot`/`getNextPayday`. Disclosed two known limitations (biweekly step, checking-only scope). Money Intelligence, banking integration, duplicate/spending detection all marked Concept with required data sources named. Held to stricter no-figure-without-a-source standard. |
| Jul 4 2026 | 1.1 | Added inherited principles: §4a Financial Truth vs Interpretation, §4b strict confidence policy (Fact/Derived Fact/Interpretation/Recommendation/Prediction), §4c Known Unknowns, §4d Source lineage. Elevated statement-classification, source-lineage, and trust rules to global law in the Bible README. Bolded "Perch never invents financial certainty" and added source-disagreement handling to §13. |
