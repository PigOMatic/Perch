# Perch Layout System

**Status:** Foundational layout direction  
**Created:** July 5, 2026

---

## Core idea

Perch needs a reusable layout system, not a one-off Today page.

The same Perch data and meaning should be able to appear on different surfaces:

```text
Today page
journal page
field guide page
map surface
guidebook view
mobile surface
future widget
```

The layout should keep the same identity even when the surface changes.

---

## What must stay consistent

The visual surface can change, but these positions should remain recognizable:

```text
Orientation
Primary marker
Terrain/context
Margin notes
Trust/source
Next step
What can wait
```

These are not just sections. They are roles in the Perch layout system.

---

## Layout roles

### 1. Orientation

Answers:

```text
Where am I today?
```

This is the opening page title or locating statement.

It should be the first thing the eye understands.

---

### 2. Primary marker

Answers:

```text
What matters first?
```

This should be visually dominant or clearly marked.

There should usually be only one primary marker.

---

### 3. Terrain/context

Answers:

```text
What is the surrounding situation?
```

This can include money, schedule, family, work, captured notes, projects, or risk.

It supports the primary marker without competing with it.

---

### 4. Margin notes

Answers:

```text
What should I notice but not obsess over?
```

These are secondary notes, reminders, loose captures, warnings, or hints.

They should feel like notes in the side of a page or edge of a map.

---

### 5. Trust/source

Answers:

```text
Why does Perch think this?
How certain is it?
Where did this come from?
```

This should be available, but quiet.

It should not dominate the page.

---

### 6. Next step

Answers:

```text
What is the next useful move?
```

This should be clear, small, and humane.

Perch should not create pressure by offering too many actions.

---

### 7. What can wait

Answers:

```text
What does not need my attention now?
```

This is part of Perch's calm value.

Not everything should be pushed forward.

---

## Surface translation

The same roles can move depending on the surface.

### Journal/page surface

```text
Orientation = page heading
Primary marker = large written statement
Terrain/context = body blocks
Margin notes = side notes
Trust/source = footnote
Next step = closing line
What can wait = quiet lower note
```

### Map surface

```text
Orientation = you are here
Primary marker = first marker
Terrain/context = map regions
Margin notes = labels around the map
Trust/source = legend
Next step = path arrow
What can wait = greyed region
```

### Guidebook surface

```text
Orientation = chapter/page title
Primary marker = highlighted field note
Terrain/context = guide sections
Margin notes = callouts
Trust/source = source note
Next step = route advice
What can wait = optional trail
```

### Mobile surface

```text
Orientation = top statement
Primary marker = first card or page fold
Terrain/context = stacked context
Margin notes = expandable notes
Trust/source = small disclosure
Next step = one thumb action
What can wait = collapsed section
```

---

## Design rule

Do not design Perch as a dashboard and then decorate it like a journal.

Design the layout as a journal/map/guidebook system first.

Then let the data inhabit that system.

---

## Current implementation implication

`today_field_guide_preview.html` is closer to the intended metaphor than the earlier brief and dashboard previews.

The next implementation target should be a reusable layout contract/module that names these roles directly so any future surface can render the same meaning in a different arrangement.

Suggested next file:

```text
src/ui/perchLayoutRoles.js
```

This should define canonical layout role names before more visual polishing continues.
