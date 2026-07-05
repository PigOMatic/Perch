# Perch Fixture Plan

**Status:** Engineering foundation  
**Created:** July 5, 2026  
**Purpose:** Define the first safe behavior checks before refactoring restored source code.

---

## 1. Why fixtures come first

The restored source candidate contains useful behavior inside large HTML pages and shared JavaScript files.

Before refactoring or rebuilding UI, Perch needs repeatable examples that prove behavior has not changed.

---

## 2. Fixture rule

> Same inputs should produce the same derived facts, attention order, and user-visible explanations unless an intentional architectural change is documented.

---

## 3. Initial fixture cases

| Fixture | Purpose | Source area |
|---|---|---|
| Bills before payday | Verify money math and payday logic | Money / Today |
| Next work shift | Verify schedule/date helpers | Calendar / Today |
| Capture reminder parse | Verify Brain capture parsing | Brain / Capture |
| Capture waiting item parse | Verify waiting/lifecycle behavior | Brain / Capture |
| Goal funding suggestion | Verify Life/Goals suggestion logic | Goals / Recommendation |
| Priority ordering | Verify `whyNowScore` behavior | Priority Engine |
| Recommendation suppression | Verify user preference suppression | Recommendation Engine |
| Stale/manual data notice | Verify trust labeling | Truth / UI State |

---

## 4. Minimum fixture format

Early fixtures can be plain JSON files or documented manual cases.

Suggested future folder:

```text
/tests/fixtures/
```

Suggested shape:

```json
{
  "name": "bills-before-payday-basic",
  "given": {
    "today": "2026-07-05",
    "balance": 1200,
    "payday": "2026-07-12",
    "bills": [
      { "name": "Mortgage", "amount": 800, "dueDate": "2026-07-08" }
    ]
  },
  "expect": {
    "billsBeforePayday": 800,
    "cushion": 400
  }
}
```

---

## 5. First implementation recommendation

First code PR should not redesign UI.

Recommended first code PR:

```text
engineering: add behavior fixtures for restored source
```

Then:

```text
engineering: add storage adapter without changing keys
```

Then:

```text
engineering: build new app shell behind existing routes
```

---

## 6. Acceptance criteria

Fixtures are sufficient for first refactor when:

- [ ] Money math has at least one fixture.
- [ ] Capture parsing has at least two fixtures.
- [ ] Priority ordering has at least one fixture.
- [ ] Recommendation suppression has at least one fixture.
- [ ] Existing localStorage keys are represented or mocked.
