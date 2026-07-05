# Perch Storage Adapter

**Status:** Initial code layer  
**Created:** July 5, 2026  
**File:** `src/core/storage.js`

---

## 1. Purpose

The storage adapter provides a safe wrapper around existing Perch localStorage keys.

It does **not** migrate data.  
It does **not** rename keys.  
It does **not** change current app behavior.  
It is **not wired into restored HTML pages yet**.

Its purpose is to give the rebuilt UI and future modules a safer way to read and write existing local data.

---

## 2. Protected keys

The adapter exposes the known keys from `STORAGE_KEYS.md`:

```js
PerchStorage.keys.memory
PerchStorage.keys.paydayCard
PerchStorage.keys.recommendationPrefs
PerchStorage.keys.behaviorPrefs
PerchStorage.keys.quickAnswerPrefs
PerchStorage.keys.goalQuestions
PerchStorage.keys.noticed
PerchStorage.keys.changesSnapshot
PerchStorage.keys.goalUpdated
PerchStorage.keys.suggestionPrefs
```

---

## 3. Public API

```js
PerchStorage.getRaw(key, fallback)
PerchStorage.setRaw(key, value)
PerchStorage.getJson(key, fallback)
PerchStorage.setJson(key, value)
PerchStorage.remove(key)
PerchStorage.exists(key)
PerchStorage.snapshot(keys)
PerchStorage.readKnownJson()
PerchStorage.safeParse(raw, fallback)
PerchStorage.safeStringify(value)
```

---

## 4. Usage example

```js
const memory = PerchStorage.getJson(PerchStorage.keys.memory, {});
```

```js
PerchStorage.setJson(PerchStorage.keys.behaviorPrefs, {
  dismissed: ['example']
});
```

---

## 5. Rules

- Do not change key names without migration.
- Do not clear `perch_memory_v1` except through explicit user action.
- Do not wire this into live pages until behavior fixtures are ready.
- Do not use this adapter to imply cloud sync or live integrations.

---

## 6. Next step

Add a tiny smoke test or manual validation page/script that proves:

- JSON parsing fallback works.
- Unknown keys return fallback.
- Known key snapshot reads without throwing.
- Existing keys are unchanged.
