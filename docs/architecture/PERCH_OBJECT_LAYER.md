# Perch Object Layer

**Status:** Foundational visual/product direction  
**Created:** July 5, 2026

---

## Core idea

Perch should not feel like a flat app screen forever.

The same layout system should be able to develop the feeling of a real personal object:

```text
aged book
field journal
guidebook
map with marks
stickers
tabs
creases
annotations
personal customization
```

This is not decorative only. It supports the product metaphor.

---

## Relationship to layout

The layout roles stay stable:

```text
Orientation
Primary marker
Terrain/context
Margin notes
Trust/source
Next step
What can wait
```

The object layer can change how those roles feel.

For example:

```text
Margin notes may look handwritten.
Trust/source may look like a footnote or legend.
Primary marker may look like a pinned note or circled map point.
Can-wait may look faded, greyed, or tucked behind a tab.
```

---

## Aging

Perch surfaces should be able to age gently over time.

Examples:

```text
subtle page wear
slight patina
used tabs
soft marks
familiar saved places
repeated rituals becoming visually familiar
```

Aging should communicate:

```text
this is yours
this has history
this remembers
this is not sterile software
```

---

## Stickers and personal marks

Stickers and marks can express personality, history, and user customization.

Examples:

```text
family stickers
work stickers
money stickers
project stickers
travel stickers
farm/property stickers
kid-related stickers
achievement stickers
warning stickers
```

These should not break the layout roles.

They should attach to or decorate the stable anatomy.

---

## Customization

Customization should happen in layers:

```text
1. Stable Perch layout anatomy
2. Surface metaphor: page, map, journal, guidebook, mobile
3. Object layer: wear, stickers, tabs, marks, personalization
4. Theme layer: color, texture, type, polish
```

The theme layer comes last.

Do not start with colors before the layout and object roles are clear.

---

## Design warning

Do not make Perch look like a fake scrapbook skin over a dashboard.

The object metaphor must be built into the layout itself.

The stickers, aging, and customization should enhance a real page/map/guidebook structure, not disguise an app grid.

---

## Implementation implication

Future visual modules should separate:

```text
layout role
surface placement
object decoration
styling/theme
```

Suggested future file:

```text
src/ui/perchObjectLayer.js
```

This can eventually define available object-layer elements such as tabs, stickers, margin marks, page age, and saved personal marks.
