# Perch Fixture Runner

**Status:** Initial validation tool  
**Created:** July 5, 2026  
**Tool:** `tools/fixture-runner.js`

---

## 1. Purpose

The fixture runner is the first validation tool for the restored Perch source rebuild.

Right now it validates fixture shape only. It does not yet execute Perch business logic.

This is intentional. Perch's restored logic still needs stable wrappers before the runner should execute real behavior.

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

## 3. How to run

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

## 4. Why this matters

This gives Perch a simple test entrypoint before the UI rebuild begins.

Future work can upgrade the runner in stages:

1. Validate fixture shape.
2. Load storage adapter.
3. Load extracted domain helpers.
4. Compare actual outputs to expected outputs.
5. Run in GitHub Actions.

---

## 5. Non-goals

This runner does not yet:

- Load HTML pages.
- Simulate browser DOM.
- Execute `perch_core.js` directly.
- Execute `perch_engine.js` directly.
- Validate visual UI.

---

## 6. Next step

Add the first wrapper/module that can be safely tested without the DOM.

Recommended next target:

```text
src/core/storage.js
```

Then:

```text
src/domain/money.js
```

for bills-before-payday math.
