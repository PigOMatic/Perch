# Home Perch Mobile Art Strategy

## Goal

Home Perch needs a wow factor without becoming too heavy for phones.

The right approach is not one giant rendered image and not hundreds of animated widgets. The right approach is a layered scene with a small number of optimized assets and subtle animation.

## Strategy

Use a hybrid scene:

1. **Static high-quality background layers** for visual richness.
2. **Live Flutter text overlays** for real user data.
3. **Tiny animated layers** for life: steam, light drift, rain, fire, water.
4. **Repaint boundaries** so static objects are not repainted every frame.
5. **Compressed WebP/PNG assets** sized for mobile targets.

## Recommended Home Perch Layer Stack

Back to front:

1. `cabin_window_background.webp`
2. `desk_surface.webp`
3. `morning_light_overlay.webp`
4. `notebook_blank.webp`
5. live notebook text overlay
6. `money_envelope_cash_blank.webp`
7. live money text overlay
8. `sticky_note_blank.webp`
9. live sticky note text overlay
10. `shift_ticket_blank.webp`
11. live shift ticket text overlays
12. `coffee_mug.webp`
13. animated steam painter
14. optional foreground dust/light painter

## Performance Rules

- Prefer 6-12 core layers, not 40.
- Keep always-running animations to 1-3 cheap effects.
- Avoid large runtime blur effects.
- Avoid animating full-screen images every frame.
- Animate opacity/transform on small layers only.
- Use `RepaintBoundary` around static and animated groups.
- Use compressed images and target phone resolution.
- Build one excellent scene before adding more.

## Asset Format

Recommended:

- WebP for large background/scene layers.
- PNG only when transparency quality requires it.
- SVG only for simple flat icons, not photorealistic props.

## First Asset Targets

Desktop-sized source exports can be large, but app assets should ship closer to:

- background/surface: 1920px wide max for first pass
- object layers: 512-1200px wide depending on screen size
- tiny overlays: 512px or less

## Product Rule

If a visual layer does not improve the first 60 seconds, remove it.

Home Perch should feel alive, not overloaded.
