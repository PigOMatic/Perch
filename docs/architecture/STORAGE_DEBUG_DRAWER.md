# Storage Debug Drawer

**Status:** Dev-only read-only preview aid  
**Created:** July 5, 2026

---

## Purpose

`src/dev/storageDebugDrawer.js` adds a collapsible debug drawer to the read-only Today preview.

It explains what the rebuilt Today preview used from storage and what stayed on fallback data.

---

## Preview

Open:

```text
readonly_today_preview.html
```

The drawer appears below the rebuilt Today surface.

---

## Safety boundary

This drawer is dev-only and read-only.

It must not:

- Write localStorage
- Delete localStorage
- Rename keys
- Migrate data
- Appear as a normal user-facing product surface

---

## Current fields

The drawer shows:

- Source label
- Read mode
- Whether money came from storage
- Whether captures came from storage
- Whether recommendation preferences came from storage
- Whether data was written
- Whether data was migrated

---

## Next step

Use this drawer while expanding `todayStorageInput.js` so each new storage mapping can be verified safely before it becomes part of the normal rebuilt Today page.
