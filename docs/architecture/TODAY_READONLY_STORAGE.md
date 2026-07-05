# Today Read-Only Storage Input

**Status:** Initial read-only adapter  
**Created:** July 5, 2026

---

## Purpose

`src/state/todayStorageInput.js` lets the rebuilt Today surface read existing Perch browser data without writing to storage.

This is the first step toward real saved Perch data appearing in the rebuilt Today UI.

---

## Safety rule

This layer must not:

- Write localStorage
- Delete localStorage
- Rename keys
- Migrate records
- Mutate the storage snapshot
- Claim live integrations

---

## Current source

The adapter reads through:

```text
src/core/storage.js
```

using:

```text
PerchStorage.readKnownJson()
```

---

## Current normalized inputs

The adapter currently tries to normalize:

- Checking balance
- Next payday
- Bills
- Captures
- Recommendation preferences

When stored data is missing or unclear, it keeps fallback data.

---

## Fixture

```text
tests/fixtures/state/today-storage-input-basic.json
```

This protects that storage values override fallback sample values while preserving:

```text
storageRead.mode = read-only
wroteData = false
migratedData = false
```

---

## Dev boot

```text
src/dev/appShellReadonlyBoot.js
```

This boot module renders the rebuilt Today view using read-only storage input with sample data fallback.

---

## Next step

Add a dedicated read-only preview HTML file or safely update the existing preview to load:

```text
src/core/storage.js
src/state/todayStorageInput.js
src/dev/appShellReadonlyBoot.js
```
