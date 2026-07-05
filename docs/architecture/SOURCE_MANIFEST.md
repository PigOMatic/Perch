# Perch Source Manifest

**Status:** Source candidate found; restore to GitHub required before feature coding  
**Created:** July 5, 2026  
**Updated:** July 5, 2026  
**Purpose:** Reconcile the Design Bible's implementation references with the actual source files present in GitHub.

---

## Current finding

A user-uploaded ZIP named `perch deploy 2.zip` contains a plausible Perch app deployment/source bundle.

It includes the core source files that the repository audit identified as missing from GitHub `main`.

However, these files are **not yet restored into GitHub main**. Until they are uploaded/merged, GitHub remains documentation/architecture-first rather than a complete implementation repository.

---

## Source decision

Decision: **Restore existing source** if the uploaded `perch deploy 2.zip` files are confirmed as the latest working app copy.

Do **not** choose clean rebuild unless this ZIP is outdated, broken, or not the intended app source.

---

## Files found in `perch deploy 2.zip`

| File | Size | Initial status | Notes |
|---|---:|---|---|
| `index.html` | 7,787 bytes | Found in ZIP | App entry/shell. Links to Today, Week, Capture. |
| `perch_settings.html` | 65,896 bytes | Found in ZIP | Settings page; imports `perch_core.js`. |
| `perch_today_live.html` | 234,785 bytes | Found in ZIP | Main Today surface; imports `perch_core.js` and `perch_engine.js`. |
| `perch_memory_explorer.html` | 74,474 bytes | Found in ZIP | Memory explorer; imports `perch_core.js`. |
| `perch_engine.js` | 19,815 bytes | Found in ZIP | Intelligence engine. |
| `perch_life.html` | 35,991 bytes | Found in ZIP | Life / What Matters page; imports `perch_core.js`. |
| `perch_core.js` | 115,023 bytes | Found in ZIP | Core date, memory, event, and data layer. |
| `perch_week_live.html` | 54,372 bytes | Found in ZIP | Week view; imports `perch_core.js`. |
| `perch_month_live.html` | 27,781 bytes | Found in ZIP | Month view; imports `perch_core.js`. |
| `perch_capture.html` | 40,953 bytes | Found in ZIP | Capture page; imports `perch_core.js`. |

---

## Expected Design Bible files still not found in this ZIP

| File | Referenced by | Status | Notes |
|---|---|---|---|
| `perch_voice.js` | Voice Engine | Missing from ZIP | Voice logic may be embedded elsewhere or lost from this deploy bundle. |
| `perch_beliefs.js` | Truth Engine, Belief Engine | Missing from ZIP | Belief logic may be embedded elsewhere or absent from deploy bundle. |
| `perch_truth.md` | Truth Engine / doctrine | Missing from ZIP | Doctrine exists in Design Bible; standalone file not in deploy bundle. |
| `perch_world.md` | Living World doctrine | Missing from ZIP | Doctrine exists in Design Bible; standalone file not in deploy bundle. |
| `perch_core_merge.js` | Priority Engine debt | Missing from ZIP | May have been an old/orphan file and should not be restored unless found. |

---

## Restore recommendation

Restore the found ZIP contents into GitHub root first:

```text
index.html
perch_settings.html
perch_today_live.html
perch_memory_explorer.html
perch_engine.js
perch_life.html
perch_core.js
perch_week_live.html
perch_month_live.html
perch_capture.html
```

After restore, rerun repository audit and update this manifest from `Found in ZIP` to `Present in GitHub`.

---

## Manual upload path

Because the GitHub connector requires file contents inline and these files are large, the safest upload path is manual:

1. Extract `perch deploy 2.zip`.
2. Open the `perch deploy/` folder.
3. Upload the 10 files to the root of `PigOMatic/Perch` on GitHub, or use GitHub Desktop to commit them.
4. Commit message:

```text
restore Perch app source from deploy bundle
```

5. Tell ChatGPT when pushed.

---

## Rules for completing this manifest after upload

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

Upload/restore the app source files to GitHub, then rerun the repository audit against GitHub `main`.
