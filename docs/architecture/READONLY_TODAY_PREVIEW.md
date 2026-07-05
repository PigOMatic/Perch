# Read Only Today Preview

**Status:** Initial preview page  
**Created:** July 5, 2026

---

## Purpose

`readonly_today_preview.html` renders the rebuilt Today surface using the read-only storage path.

It loads:

```text
src/core/storage.js
src/state/todayStorageInput.js
src/dev/appShellReadonlyBoot.js
```

and falls back to sample data when localStorage is empty or incomplete.

---

## Safety boundary

This preview must remain read-only.

It does not write, migrate, delete, or rename localStorage data.

---

## How to use

Open:

```text
readonly_today_preview.html
```

Use this for checking how the rebuilt Today view behaves with existing browser data.
