# Perch Asset Pipeline

## Purpose

Perch will require a controlled asset pipeline so scenes stay consistent instead of becoming a random collection of AI images.

The goal is reusable scene pieces with live UI layered on top.

## Asset Types

### Background Assets

Full-screen or wide scene foundations.

Examples:

- cabin desk background
- creek view
- firepit setting
- RV campsite table
- nurse break room counter

### Object Assets

Reusable objects that can appear across scenes.

Examples:

- notebook
- envelope
- sticky note
- shift ticket
- journal
- clipboard
- mug
- pen
- keys
- map

### Overlay Assets

Visual layers that create depth.

Examples:

- shadows
- sunlight bands
- rain streaks
- fire glow
- dust/fog
- window reflection

### Audio Assets

Optional ambient loops.

Examples:

- creek
- fire
- rain
- wind
- birds
- hospital HVAC
- campground ambience

## Asset Rule

Do not generate user data into the image.

Wrong:

- an image of an envelope that already says `$800`

Right:

- an envelope image with blank writable space
- Flutter overlays `$800` as live text

## First Asset Pack

### Home Perch Desk Pack

Required:

- `home_perch_background.png`
- `notebook_open_blank.png`
- `cash_envelope_blank_with_money.png`
- `sticky_note_blank.png`
- `shift_ticket_blank.png`
- `coffee_mug.png`
- `pen.png`
- `light_overlay_morning.png`
- `shadow_overlay_soft.png`

Optional:

- `coffee_steam_sequence` or shader/particle equivalent
- `paper_texture_overlay.png`
- `desk_edge_foreground.png`

## Prompt Direction for Asset Generation

Assets should be generated with consistent rules:

- realistic but slightly idealized
- warm natural light
- no text unless intentionally part of a decorative prop
- blank writable areas on information objects
- isolated object assets should have transparent backgrounds
- background scenes should have clear object placement zones
- avoid clutter in data zones

## File Naming Rules

Use lowercase, descriptive, stable names.

```text
assets/scenes/home_perch/background_morning.png
assets/scenes/home_perch/light_overlay_morning.png
assets/objects/notebook/notebook_open_blank_v1.png
assets/objects/money/envelope_cash_blank_v1.png
assets/objects/notes/sticky_yellow_blank_v1.png
assets/objects/work/shift_ticket_blank_v1.png
```

## Versioning

Do not replace major assets silently.

Use version suffixes:

- `_v1`
- `_v2`
- `_v3`

When an asset changes the user-facing look significantly, keep the old version until the scene is intentionally migrated.

## Quality Checklist

Before an asset is accepted:

1. Does it support the Perch emotional target?
2. Does it leave room for live text?
3. Does it match the camera rules?
4. Does it feel like the same world as the other assets?
5. Can it scale to phone screens?
6. Does it avoid fake baked-in user data?
7. Is it calm after repeated daily use?

## Future Asset Packs

- Creek Reflection Pack
- Firepit Evening Pack
- RV Campsite Pack
- Barn Workshop Pack
- Nurse Break Room Pack
- Rainy Window Pack
- Dock Long View Pack
- Trail Map Pack
