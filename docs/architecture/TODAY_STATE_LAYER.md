# Perch Today State Layer

**Status:** Initial PageState builder  
**Created:** July 5, 2026

---

## Purpose

`src/state/todayState.js` is the first rebuilt PageState layer for Perch Today.

It does not render DOM and does not replace the legacy Today page.

It converts domain and engine outputs into a clean Today state object that the rebuilt shell can render later.

---

## Current inputs

The initial builder can compose:

- Money before payday
- Capture summaries
- Priority result
- Recommendation visibility
- Trust notice

---

## Current output

The builder returns:

```text
pageId
mode
headline
generatedAt
sections
trustNotice
legacyFallback
```

---

## Protected fixture

```text
tests/fixtures/state/today-state-basic.json
```

This fixture confirms:

- Today state uses `pageId: today`
- Read mode is default
- Attention, money, brain, and recommendation sections are present
- Trust notice can be surfaced
- Legacy fallback remains available

---

## Safe boundary

This layer does not:

- Change `perch_today_live.html`
- Change `index.html`
- Change localStorage keys
- Render UI
- Replace legacy behavior

---

## Next step

Render `todayState` into the app shell preview.

That should still remain behind `app_shell_preview.html` until the rebuilt Today surface is strong enough to replace the legacy page.
