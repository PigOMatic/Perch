# Perch Today View Renderer

**Status:** Initial rebuilt Today surface  
**Created:** July 5, 2026

---

## Purpose

`src/ui/todayView.js` is the first visible rebuilt Today renderer.

It consumes `src/state/todayState.js` and renders a calm read-mode Today surface inside `app_shell_preview.html`.

---

## Rebuild rule

This view is not based on the legacy Today layout.

The legacy Today file remains a fallback and behavior reference only.

---

## Current visible structure

The rebuilt Today view currently renders:

- Hero statement
- Trust note
- Needs Attention card
- Money card
- Brain card
- Suggestion card
- Legacy fallback link

---

## Current preview path

Open:

```text
app_shell_preview.html
```

The preview now loads:

```text
src/domain/money.js
src/domain/capture.js
src/engines/priority.js
src/engines/recommendation.js
src/engines/truth.js
src/state/todayState.js
src/ui/todayView.js
```

---

## Safe boundary

This PR does not:

- Replace `index.html`
- Replace `perch_today_live.html`
- Remove legacy links
- Change localStorage keys
- Claim live data integrations

---

## Next implementation target

Move preview sample data into a fixture/dev-data file so the preview page is thinner.

Then begin connecting read-only localStorage data through the storage adapter.
