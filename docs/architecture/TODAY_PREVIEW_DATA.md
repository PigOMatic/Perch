# Today Preview Data

**Status:** Dev preview cleanup  
**Created:** July 5, 2026

---

## Purpose

The rebuilt Today preview now has a separate sample-data module:

```text
src/dev/todaySampleData.js
```

and a separate preview boot module:

```text
src/dev/appShellPreviewBoot.js
```

This keeps preview wiring separate from the renderer and state builder.

---

## Preview files

```text
app_shell_preview.html
```

Original preview file with inline sample data.

```text
app_shell_preview_dev.html
```

Cleaner dev preview that loads sample data and boot logic from `src/dev/`.

---

## Boundary

Sample data is not user data.

It is not live integration data.

It should never be treated as current financial, calendar, or personal information.

---

## Next step

Use `app_shell_preview_dev.html` for new Today UI iteration.

Once connector editing allows it or the file is refactored manually, `app_shell_preview.html` can be simplified to match the dev preview structure.
