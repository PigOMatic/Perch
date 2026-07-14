# Perch Scene Kit v1

Perch Scene Kit is the contract between artwork, life state, interaction, and Flutter. It allows Home Perch, the evolving world, and future downloadable sets to use one renderer instead of hard-coded screens.

## Core model

A set is a believable place made from:

- a stable base composition
- replaceable visual layers
- percentage-based hit regions
- named camera targets
- state-driven object variants
- ambient effect channels
- evolution and memory-placement rules

The art never owns the user's state. `PerchWorldState` selects which set layers and variants are visible.

## Package layout

```text
assets/sets/<set_id>/
  manifest.json
  base/
  layers/
  objects/
  effects/
  collectibles/
  memories/
  previews/
```

Only `manifest.json` is required for an empty or development set. Asset files may be added incrementally.

## Coordinate system

All positions, hit regions, camera frames, and object slots use normalized coordinates from `0.0` to `1.0`.

- `(0, 0)` is the top-left of the composed scene.
- `(1, 1)` is the bottom-right.
- A hit box remains correct across phone sizes because it is expressed as a percentage of the scene.
- Each hit region also defines a minimum logical touch size so small props remain usable on phones.

## Scene layers

The initial Cabin set reserves these ordered groups:

1. sky
2. distant landscape
3. weather behind glass
4. window exterior
5. room shell
6. permanent furniture
7. desk surface
8. identity props
9. state props
10. memories
11. collectibles
12. foreground ambience
13. interaction feedback

A set may omit groups, but must preserve their semantic meaning and z-order.

## Object categories

### Core objects

Functional tools available in every compatible set:

- journal
- capture tool
- correspondence / email
- money
- calendar
- projects
- world portal

### Identity objects

Chosen by the user and changed infrequently:

- drink vessel and beverage
- journal style
- writing tool
- plant species
- lamp style
- desk material

### State objects

Reflect current conditions:

- drink fill and steam
- sticky-note text
- journal page
- lantern state
- unread correspondence
- current photograph

### Memory objects

Quiet evidence of real life:

- family drawing
- trip map
- work badge
- birthday card
- campground tag

### Collectibles

Persistent earned or downloaded decorative items:

- park tokens
- pins
- coins
- figurines
- stickers
- charms

## Cameras

Every set defines named normalized camera frames. Cabin v1 starts with:

- `home`
- `journal`
- `correspondence`
- `sticky_note`
- `plant`
- `photo`
- `window`
- `world_transition`

Camera movement is presentation. Functional panels may still render in Flutter after the camera arrives.

## Hit regions

A hit region links a visible scene area to an action and optional camera.

Example actions:

- focus a camera
- open a journal workspace
- open quick capture
- open email intelligence
- open money
- enter World View
- customize an identity object

Hit regions may be larger than the visible prop. They must retain accessibility labels and keyboard focus behavior.

## Evolution

Evolution rules map durable life events into visual changes.

Examples:

- completed hiking milestones increase plant growth or add a regional leaf
- a completed trip adds a map, sticker, or collectible
- sustained project progress improves a world landmark
- seasonal dates add temporary décor
- weather changes ambience, not permanent memory

Evolution must remain non-punitive. A missed habit does not destroy earned memories.

## Set portability

Future downloadable sets should contain only assets and declarative manifests. Executable code is not part of a set package.

A set may define new decorative semantics but must map its functional objects to the shared core actions. A starship can replace an envelope with a communications console while still opening Email Intelligence.

## Validation requirements

Before a set can be installed it must pass:

- schema/version compatibility
- unique identifiers
- normalized geometry validation
- referenced asset existence
- minimum touch-target checks
- known action validation
- safe path validation
- accessibility-label checks
- performance budget checks

## Cabin v1 goal

The first Cabin manifest is intentionally functional before final artwork. It establishes:

- one master phone-ratio scene
- interactive hit boxes
- named camera positions
- identity choices for drink, journal, plant, pen, and lamp
- state variants
- collectible and memory slots
- ambient channels
- evolution rules shared with World View
