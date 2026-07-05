# Today Field Guide View

**Status:** Initial visual prototype  
**Created:** July 5, 2026

---

## Why this exists

The rebuilt Today page should not be a dashboard, even a beautiful one.

The stronger metaphor is:

```text
page
journal
map
guidebook
field guide
```

Perch Today should help the user orient themselves in life, not manage a grid of widgets.

---

## Product direction

Today should feel like opening a useful page in a living guidebook.

It should answer:

```text
Where am I?
What is the first marker?
What terrain am I crossing?
What notes are in the margin?
What is the compass direction?
```

---

## Files

```text
src/ui/todayFieldGuideView.js
today_field_guide_preview.html
```

---

## Structure

The first prototype renders:

- Field guide header
- Today map
- First marker
- Money terrain
- Notes in margin
- Compass note
- Source/trust margin note

---

## Design rule

This page should feel printable, readable, and orienting.

It should fit the mental model of:

```text
a page you could keep
a journal entry you could return to
a guidebook page that tells you where you are
```

---

## Not allowed as final direction

Avoid returning to:

```text
widget grid
dashboard cards
admin layout
three equal columns
debug details as primary UI
```

---

## Preview

Open:

```text
today_field_guide_preview.html
```

If GitHub Pages is enabled:

```text
https://pigomatic.github.io/Perch/today_field_guide_preview.html
```

---

## Next step

Compare this against `today_brief_preview.html`.

If this feels closer, continue shaping the app around the field guide metaphor instead of the brief/dashboard metaphor.
