# Perch Behavior Fixtures

**Status:** Initial behavior protection fixtures  
**Created:** July 5, 2026

These fixtures protect behavior from the restored source candidate while Perch is rebuilt.

They are intentionally plain JSON first. A future test harness can load these files and compare outputs from `perch_core.js`, `perch_engine.js`, and future modules.

## Rule

Same inputs should produce the same derived facts, priority ordering, and recommendation suppression unless an intentional architecture change is documented.

## Fixture groups

```text
money/
capture/
priority/
recommendations/
trust/
```

## First protected behaviors

- Bills before payday
- Capture reminder parsing
- Capture waiting item parsing
- Priority ordering
- Recommendation suppression
- Stale/manual data trust notice
