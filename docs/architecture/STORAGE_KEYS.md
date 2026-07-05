# Perch Storage Keys

**Status:** Engineering foundation / source inventory  
**Created:** July 5, 2026  
**Source:** Restored source candidate Phase 0 inventory

---

## 1. Purpose

This document records the browser storage keys used by the restored Perch source candidate.

These keys must not be renamed, deleted, or migrated without an explicit migration plan.

---

## 2. Core rule

> Local data is user trust. Do not break it casually.

Perch is currently local/manual-first. Until a future data layer is created, localStorage compatibility is part of the product contract.

---

## 3. Discovered keys

| Key | Owner / primary file | Current purpose | Migration priority |
|---|---|---|---|
| `perch_memory_v1` | `perch_core.js` | Primary Perch memory/data store | Critical |
| `perch_payday_card` | `perch_today_live.html` | Payday card status/display data | Medium |
| `perch_rec_prefs` | `perch_today_live.html` | Recommendation done/snoozed/suppressed preferences | Medium |
| `perch_behavior_prefs` | Today, Life, Settings | Behavior/personalization signals | High |
| `perch_quick_answer_prefs` | Today, Settings | Quick answer ordering, hidden items, counts | Medium |
| `perch_goal_qs` | Today | Goal-related questions | Medium |
| `perch_noticed_v1` | Today | Lightweight noticed-item storage | Medium |
| `perch_changes_snap` | Today, Settings | Snapshot for detecting change since last load | Low/Medium |
| `perch_goal_updated` | Life, Engine, Today | Cross-page goal updated flag | Medium |
| `perch_sug_prefs` | Life | Suggestion done/suppressed preferences | Medium |

---

## 4. Key-specific notes

### `perch_memory_v1`

Primary data store. This is the highest-risk key.

Any rebuild must either:

1. Continue reading it directly, or
2. Provide an adapter/migration layer.

Do not clear this key except through explicit user action.

### `perch_behavior_prefs`

Shared by multiple pages. Treat as cross-page preference/history data.

May contain signals used for personalization, but should not be treated as hard truth without source/context.

### `perch_goal_updated`

Appears to be a lightweight cross-page event flag. This should eventually move into a formal event bus or interaction history model.

---

## 5. Migration rules

Before changing any key:

- Document old key.
- Document new key.
- Provide a read fallback.
- Preserve user data.
- Provide reset/export path if practical.

---

## 6. First code-change guidance

Before rebuilding UI, create a small storage adapter layer or wrapper plan.

Possible future shape:

```js
PerchStorage = {
  get(key, fallback),
  set(key, value),
  remove(key),
  migrate(oldKey, newKey, transform),
  snapshot()
}
```

Do not introduce this until fixtures or manual test cases exist.

---

## 7. Acceptance criteria

Storage compatibility is protected when:

- [ ] Every existing key has a documented owner.
- [ ] The rebuilt UI can read existing `perch_memory_v1` data.
- [ ] No migration deletes user data.
- [ ] Old pages can coexist with new pages during transition.
- [ ] Storage changes are tested with fixture data.
