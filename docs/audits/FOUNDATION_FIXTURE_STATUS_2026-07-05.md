# Perch Foundation Fixture Status — 2026-07-05

**Status:** Foundation fixture pass complete  
**Date:** July 5, 2026

---

## Summary

Perch now has executable foundation checks for the first extracted domain and engine modules.

The restored source candidate is still preserved. No live HTML app pages have been changed.

---

## Executable modules

| Area | File | Fixture coverage |
|---|---|---|
| Money | `src/domain/money.js` | Bills before payday |
| Capture | `src/domain/capture.js` | Reminder parsing, waiting-item parsing |
| Priority | `src/engines/priority.js` | Urgent money item before low task |
| Recommendation | `src/engines/recommendation.js` | User-suppressed recommendation does not show |
| Truth | `src/engines/truth.js` | Stale manual balance is limited certainty |

---

## Test command

```bash
npm test
```

This runs:

```bash
node tools/fixture-runner.js
```

---

## CI

A GitHub Actions workflow now runs the fixture check on pull requests and pushes to `main`.

```text
.github/workflows/fixtures.yml
```

---

## Current boundary

These modules are not wired into the live restored HTML pages yet.

That is intentional.

The safe rebuild sequence remains:

```text
extract small behavior
protect with fixture
then rebuild UI around stable modules
```

---

## Next implementation phase

The next safe phase is app shell planning and/or first UI rebuild work behind existing routes.

Recommended next PR:

```text
engineering: add app shell scaffold
```

Do not replace Today yet until the shell can load safely beside existing pages.
