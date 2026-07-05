# Daily Intro Overlay

**Status:** Initial experience layer  
**Created:** July 5, 2026

---

## Purpose

Perch can have a short daily opening moment.

The first version says:

```text
Perch
Beautifully designed.
Opening today's page.
```

It appears briefly, fades away, and remembers that it has already shown today.

---

## Behavior

The overlay:

- Shows at most once per day per browser
- Uses localStorage only
- Stores the current date under `perch_daily_intro_seen_date`
- Auto-dismisses after a short duration
- Supports reduced motion preferences
- Does not block the page permanently

---

## Current preview

The intro is currently loaded on:

```text
today_field_guide_preview.html
```

---

## Files

```text
src/ui/dailyIntro.js
src/ui/dailyIntro.css
tests/fixtures/ui/daily-intro.json
```

---

## Design direction

This should feel like opening a personal object, not launching software.

Future versions may align with the object layer:

```text
book opening
journal cover
sticker reveal
page turn
map unfold
saved personal mark
```

---

## Safety rule

This should remain quiet and optional-feeling.

Do not make it an onboarding modal, advertisement, blocker, or persistent pop-up.
