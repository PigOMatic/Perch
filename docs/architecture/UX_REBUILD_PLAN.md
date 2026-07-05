# Perch UX Rebuild Plan

**Status:** Planning  
**Created:** July 5, 2026  
**Source:** Design Bible v1.0 + restored source candidate audit

---

## 1. Decision

The current restored HTML app is a source candidate and reference implementation, not the final user interface.

Perch should keep useful behavior and logic from the restored source, but rebuild the visual system and page structure from the Design Bible.

---

## 2. Why rebuild the UX

The current app proves behavior, but it does not yet express the finished Perch product identity.

The user does not like the current look, and the files are large monolithic HTML pages. Continuing to polish them directly would create more visual debt.

The correct path is:

```text
salvage behavior → define UI state → rebuild surfaces → retire old HTML progressively
```

---

## 3. UX principles from the Design Bible

Perch should feel:

- Calm
- Clear
- Trustworthy
- Note-first
- Human-readable
- Source-aware
- Less like a dashboard
- More like a Life Operating System

The user should not feel like they are managing a database. They should feel like Perch understands what matters and can explain why.

---

## 4. What to preserve

Preserve these behaviors from the restored app:

- Date helpers
- Manual memory/local data behavior
- Capture parsing and lifecycle
- Bill/payday math
- Goal/funding math
- Calendar/event generation
- Priority scoring ideas
- Recommendation candidate examples
- Settings/basics flows
- Existing localStorage compatibility where practical

---

## 5. What to replace

Replace:

- Current visual style
- Current dense cards where they feel dashboard-like
- Monolithic HTML structure
- Inline page-specific business logic
- Duplicated navigation
- UI copy that lacks source/trust context
- Any page layout that conflicts with the Design Bible

---

## 6. Target page strategy

| Current file | Future role |
|---|---|
| `index.html` | Clean app shell / route entry |
| `perch_today_live.html` | Rebuilt Today home screen |
| `perch_week_live.html` | Rebuilt Week surface |
| `perch_month_live.html` | Rebuilt Month / obligations view |
| `perch_capture.html` | Rebuilt Brain capture surface |
| `perch_life.html` | Rebuilt Goals / Projects / Life planning surface |
| `perch_settings.html` | Rebuilt Settings / Basics / Trust controls |
| `perch_memory_explorer.html` | Rebuilt Knowledge / Memory Explorer |

---

## 7. Rebuild order

### Phase 1 — Protect logic

- Freeze restored source as reference.
- Create source manifest.
- Identify functions and data keys that must survive.
- Avoid feature changes.

### Phase 2 — Define UI architecture

Create:

```text
docs/architecture/UI_STATE_MODEL.md
docs/architecture/DATA_MODEL.md
docs/architecture/ENGINE_INTERFACES.md
```

### Phase 3 — Rebuild shell and Today

- Build a clean app shell.
- Rebuild Today first.
- Preserve existing data compatibility.
- Keep old Today as reference until replacement is validated.

### Phase 4 — Rebuild capture and week

- Capture is the input path.
- Week is the near-term obligation view.
- These two prove the source/data model.

### Phase 5 — Rebuild goals, settings, knowledge

- Rebuild Goals/Life.
- Rebuild Settings/Basics.
- Rebuild Memory Explorer into Knowledge.

---

## 8. Non-goals

Do not:

- Make the current HTML prettier and call it done.
- Add new integrations.
- Add live banking.
- Build Living World before truth/data foundations stabilize.
- Start a new feature before UI state and engine interfaces are documented.

---

## 9. Acceptance criteria

The UX rebuild is successful when:

- [ ] Today looks and feels like the Design Bible, not the old prototype.
- [ ] Existing localStorage data can still be read or migrated.
- [ ] The user can understand why Perch surfaced an item.
- [ ] The UI separates facts, interpretations, and recommendations.
- [ ] The app remains usable without external integrations.
- [ ] Major logic is no longer trapped inside monolithic HTML pages.

---

## 10. Immediate next action

Create `UI_STATE_MODEL.md` and `ENGINE_INTERFACES.md` before rewriting any HTML.
