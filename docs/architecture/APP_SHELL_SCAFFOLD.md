# Perch App Shell Scaffold

**Status:** Initial scaffold  
**Created:** July 5, 2026

---

## Purpose

This scaffold starts the UI rebuild without replacing restored legacy pages.

It creates:

```text
src/ui/routes.js
src/ui/shell.js
src/ui/shell.css
app_shell_preview.html
```

---

## Current behavior

The shell renders:

- Perch header
- Route navigation
- Placeholder page panel
- Legacy page link for each route

The shell is intentionally separate from `index.html` and the restored `perch_*.html` pages.

---

## Safe boundary

This PR does not:

- Replace Today
- Replace legacy pages
- Change localStorage keys
- Change existing user data
- Wire the new shell into production entry

---

## Preview

Open:

```text
app_shell_preview.html
```

---

## Next step

Add a `todayState` builder that produces a basic `PageState` for Today, then render that into the shell placeholder.

The target sequence remains:

```text
shell scaffold → Today state builder → Today read-mode surface → legacy Today retirement later
```
