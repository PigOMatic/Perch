# Perch Fixture Runner

**Status:** Initial behavior validation tool  
**Created:** July 5, 2026  
**Updated:** July 5, 2026  
**Tool:** `tools/fixture-runner.js`

---

## 1. Purpose

The fixture runner is the first validation tool for the restored Perch source rebuild.

It validates fixture shape and now executes extracted behavior for:

```text
Money
Capture
```

---

## 2. Current checks

The runner checks every JSON fixture under:

```text
tests/fixtures/
```

Each fixture must include:

```text
name
status
description
given
expect
```

---

## 3. Current executable checks

| Fixture | Module | Behavior |
|---|---|---|
| `tests/fixtures/money/bills-before-payday-basic.json` | `src/domain/money.js` | Calculates bills due before payday and remaining cushion. |
| `tests/fixtures/capture/reminder-basic.json` | `src/domain/capture.js` | Parses basic reminder capture text. |
| `tests/fixtures/capture/waiting-item-basic.json` | `src/domain/capture.js` | Parses basic waiting-item capture text. |

---

## 4. How to run

From the repo root:

```bash
node tools/fixture-runner.js
```

Expected output:

```text
Perch fixture runner
Fixtures checked: <number>
Passed: <number>
Failed: 0
```

---

## 5. Non-goals

This runner does not yet:

- Load HTML pages.
- Simulate browser DOM.
- Execute `perch_core.js` directly.
- Execute `perch_engine.js` directly.
- Validate visual UI.

---

## 6. Next targets

```text
priority ordering
recommendation suppression
trust labeling
```
