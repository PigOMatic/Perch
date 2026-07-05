# Today People and Work Shifts Mapping

**Status:** Initial read-only mapping  
**Created:** July 5, 2026

---

## Purpose

The rebuilt Today read-only path now attempts to normalize people and work shifts from existing Perch memory data.

This expands `src/state/todayStorageInput.js` without changing storage data.

---

## Safety boundary

This mapping remains read-only.

It does not:

- Write localStorage
- Delete localStorage
- Rename keys
- Migrate records
- Change legacy pages

---

## Current people sources

The adapter checks:

```text
memory.people
memory.basics.people
memory.family
memory.relationships
```

---

## Current work shift sources

The adapter checks:

```text
memory.workShifts
memory.shifts
memory.schedule
memory.basics.workShifts
memory.basics.shifts
```

---

## Debug drawer

The read-only preview debug drawer now reports:

- People from storage
- People count
- Work shifts from storage
- Work shift count

---

## Fixture coverage

```text
tests/fixtures/state/today-storage-input-basic.json
tests/fixtures/dev/storage-debug-drawer.json
```

---

## Next step

Use the debug drawer to verify real saved Perch data shapes, then decide whether to render a small People/Work context strip in the rebuilt Today view.
