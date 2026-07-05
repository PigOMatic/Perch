# Fixture Index

**Created:** July 5, 2026  
**Purpose:** Track behavior fixtures that protect restored Perch logic before refactor/rebuild work.

---

## Fixtures

| Fixture | Path | Protects |
|---|---|---|
| Bills before payday | `money/bills-before-payday-basic.json` | Money math and payday filtering |
| Capture reminder | `capture/reminder-basic.json` | Reminder parsing and lifecycle |
| Waiting item | `capture/waiting-item-basic.json` | Waiting capture parsing and lifecycle |
| Priority ordering | `priority/urgent-money-before-low-task.json` | Priority ranking logic |
| Recommendation suppression | `recommendations/suppressed-recommendation.json` | User preference suppression |
| Stale manual balance | `trust/manual-stale-balance.json` | Trust labeling and certainty limits |

---

## Next fixture candidates

- Goal funding suggestion
- Work shift recurrence
- Bill already paid before payday
- Capture question routing
- Behavior preference learning
- Quick answer suppression

---

## Rule for future changes

Any refactor that touches money, capture parsing, priority, recommendations, or trust labeling should either preserve these expectations or update the fixture with an explicit architecture note.
