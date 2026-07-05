# Today Rebuild Decision

**Status:** Binding rebuild decision  
**Created:** July 5, 2026

---

## Decision

The legacy Today page is not the target UI.

Perch Today is being rebuilt around a completely different product and visual vision.

The old page is kept only as:

- A behavior reference
- A compatibility fallback
- A source of salvageable logic
- A temporary route while the rebuild matures

---

## What this means

Do not polish the legacy Today page and call it progress.

Do not copy its visual layout into the rebuilt Today surface.

Do not treat its density, card structure, copy style, or interaction model as canonical.

---

## Rebuilt Today target

The new Today surface should feel:

- Calm
- Clear
- Sparse before dense
- Human-readable
- Trust-aware
- Source-aware
- Beautiful before dashboard-like
- More like a personal operating surface than an admin panel

---

## Required design separation

The rebuilt Today page must separate:

```text
facts
computed facts
attention
recommendations
trust notes
legacy fallback
```

It must not blend all of those together into one noisy dashboard.

---

## Legacy role

`perch_today_live.html` remains available during transition.

It should not be deleted until:

- The rebuilt Today surface renders the main Today experience
- Existing localStorage data is readable
- Core behaviors are covered by fixtures
- The legacy route has a safe replacement path

---

## Current rebuild path

```text
source inventory
fixtures
storage adapter
domain modules
engine modules
app shell
Today PageState
Today renderer
legacy retirement later
```

---

## Next implementation target

Render `src/state/todayState.js` inside the rebuilt app shell preview.

This begins the new Today UI without replacing the legacy Today file yet.
