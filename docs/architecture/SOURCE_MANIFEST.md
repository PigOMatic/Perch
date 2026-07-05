# Perch Source Manifest

**Status:** Required before feature coding  
**Created:** July 5, 2026  
**Purpose:** Reconcile the Design Bible's implementation references with the actual source files present in GitHub.

---

## Current finding

The Design Bible references application source files that are not currently present in GitHub `main`.

Until this manifest is completed, Perch should be treated as having a strong architecture baseline but an unresolved implementation-source gap.

---

## Required source decision

Choose one:

| Option | Meaning |
|---|---|
| Restore existing source | Add the current working Perch app source files to GitHub. |
| Clean rebuild | Treat the Design Bible as the source of truth and rebuild the app source cleanly. |

---

## Expected files referenced by the Design Bible

| File | Referenced by | Current GitHub status | Notes |
|---|---|---|---|
| `index.html` | Integrations / app shell references | Missing / not verified | Referenced as having local file `fetch` behavior. |
| `perch_core.js` | Money, Calendar, Goals, Brain, Priority, Knowledge, Home | Missing / not verified | Central source referenced by many chapters. |
| `perch_engine.js` | Priority, Recommendation, Voice, Calendar, Goals | Missing / not verified | Referenced as holding `whyNowScore`, `buildMorningBrief`, and recommendation candidate logic. |
| `perch_today_live.html` | Today, Goals, Priority, Recommendation, Living World, Voice, Home | Missing / not verified | Referenced as the active Today surface. |
| `perch_life.html` | Goals, Recommendation | Missing / not verified | Referenced as Life page / goal funding surface. |
| `perch_voice.js` | Voice Engine | Missing / not verified | Referenced as relationship voice path. |
| `perch_beliefs.js` | Truth Engine, Belief Engine | Missing / not verified | Referenced as current truth/belief implementation. |
| `perch_truth.md` | Truth Engine / doctrine | Missing / not verified | May exist locally or historically. |
| `perch_world.md` | Living World doctrine | Missing / not verified | Referenced as doctrine not loaded by code. |
| `perch_core_merge.js` | Priority Engine debt | Missing / not verified | Referenced as orphan duplicate. |

---

## Rules for completing this manifest

For each source file, record:

- File path
- Active / legacy / orphan / missing
- Owning Design Bible chapter
- Related chapters
- Runtime role
- Known debt
- Whether it should survive v0.5

---

## Next action

Before writing feature code, either:

1. Upload/restore the app source files and complete this manifest, or
2. Mark all referenced implementation as historical and begin a clean rebuild from the Design Bible.
