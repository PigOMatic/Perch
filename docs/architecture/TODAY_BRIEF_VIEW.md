# Today Brief View

**Status:** Initial visual prototype  
**Created:** July 5, 2026

---

## Purpose

`src/ui/todayBriefView.js` is a second visual prototype for the rebuilt Today page.

It exists because the first rebuilt preview was better than legacy, but still felt too much like a dashboard.

---

## Design intent

Today Brief View should feel more like:

```text
a calm daily brief
a personal operating surface
a daily clearing ritual
```

and less like:

```text
a dashboard grid
a task manager
an admin panel
a developer preview
```

---

## Structure

The brief view renders:

1. A single dominant opening answer
2. The top attention item in plain language
3. Supporting evidence from Money, Brain, and Suggestion sections
4. Quiet source/trust disclosure

---

## Files

```text
src/ui/todayBriefView.js
today_brief_preview.html
```

---

## Safety boundary

This does not replace legacy Today.

This does not remove the existing structural Today preview.

This does not change localStorage.

It consumes the same `TodayState` that the existing renderer consumes.

---

## How to view

Open:

```text
today_brief_preview.html
```

If GitHub Pages is enabled:

```text
https://pigomatic.github.io/Perch/today_brief_preview.html
```

---

## Next step

Compare this brief view against the current read-only preview.

If it feels closer to the Perch vision, keep refining the brief view and eventually make it the default Today preview.
