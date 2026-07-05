# Perch Full Repository Audit — 2026-07-05

**Audit date:** July 5, 2026  
**Repository:** `PigOMatic/Perch`  
**Audit type:** Architecture + repository readiness  
**Authority:** Design Bible v1.0 Architecture Baseline  
**Auditor:** Chief Architect

---

## 1. Executive conclusion

Perch now has a strong, locked Design Bible, but the GitHub repository is not yet an implementation-ready codebase.

The most important finding is this:

> **The repository currently functions primarily as an architecture/documentation repository. The application source files repeatedly referenced by the Design Bible are not present in GitHub `main`.**

This does not invalidate the Design Bible. It changes the next milestone.

Before engineering work can begin, the project must either:

1. Add the actual application source code to GitHub, or
2. Explicitly declare that implementation will restart from the Design Bible and build a new source tree.

Do not proceed as if GitHub already contains the full application implementation.

---

## 2. Audit evidence

### 2.1 Repository metadata

GitHub reports repository `PigOMatic/Perch` as public with a small repository size. Current repository work has been centered on documentation PRs and Design Bible files.

### 2.2 Source-code search result

Searches for key source files referenced throughout the Design Bible returned no GitHub results:

- `perch_core`
- `perch_engine`
- `perch_today_live`

### 2.3 Local uploaded repository ZIP

The available repository ZIP inspected during the audit contained documentation, governance, AI workspace files, updates, and Design Bible files, but no actual app source files such as:

- `perch_core.js`
- `perch_engine.js`
- `perch_today_live.html`
- `perch_life.html`
- `perch_voice.js`
- `perch_beliefs.js`
- `index.html`
- tests
- package/build files
- app source folders

### 2.4 Design Bible references to missing files

The Design Bible repeatedly references implementation files that are not present in GitHub `main`, including but not limited to:

- `perch_core.js`
- `perch_engine.js`
- `perch_today_live.html`
- `perch_life.html`
- `perch_voice.js`
- `perch_beliefs.js`
- `perch_core_merge.js`
- `index.html`

These references may be historically accurate from a previous local working copy, but they are not currently verifiable from GitHub.

---

## 3. Repository state by area

| Area | Status | Finding |
|---|---|---|
| Design Bible | Strong / locked | v1.0 Architecture Baseline is present and mature. |
| Governance | Strong | Constitution, philosophy, ADRs, and authority rules exist. |
| AI workspace | Present | Needs periodic alignment but no longer owns product architecture. |
| Reference docs | Present | Master index, debt, roadmap/backlog exist. |
| Application source | Missing from GitHub | Major blocker. Bible references source files not present in repo. |
| Tests | Missing / not verified | No test suite found in available repo snapshot. |
| Build system | Missing / not verified | No package/build/runtime setup found in available repo snapshot. |
| Assets | Missing / not verified | No app assets verified. |
| CI/CD | Missing / not verified | No workflow files verified. |

---

## 4. Highest-priority blocker

### Blocker 1 — GitHub does not contain the app implementation

The Design Bible says many features are implemented/prototype and traces them to concrete files, but those files are not currently visible in GitHub.

This creates a source-of-truth split:

- **Design Bible:** claims implementation/prototype status based on repository audits.
- **GitHub main:** does not contain the referenced implementation files.

That split must be resolved before coding.

### Required decision

Choose one:

| Option | Meaning | Recommendation |
|---|---|---|
| A | Recover/upload the existing local app source into GitHub | Best if the source still exists and is worth preserving. |
| B | Treat the Design Bible as the source of truth and rebuild the app cleanly from scratch | Best if the existing source is messy, lost, or not worth preserving. |
| C | Keep Design Bible repo separate from app repo | Not recommended right now; increases coordination cost. |

**Chief Architect recommendation:** choose **A** if the app source exists; otherwise choose **B** quickly and stop referencing unavailable code as current implementation.

---

## 5. Architectural drift risks

### 5.1 Design Bible implementation claims may be stale

Chapters 1–14 contain detailed implementation claims that reference files not present in GitHub. Until the source is restored or rebuilt, those claims should be treated as:

> historically audited but not currently repository-verifiable.

### 5.2 Engineering foundation cannot safely target missing code

Documents like `SYSTEM_ARCHITECTURE.md`, `DATA_MODEL.md`, and `ENGINE_INTERFACES.md` can still be written, but they should not assume the old implementation files exist unless those files are restored.

### 5.3 Claude/AI agents may hallucinate repository reality

If agents read only the Design Bible, they may assume files exist that GitHub does not contain. Agent prompts must explicitly say:

> The Design Bible is the product contract. Current GitHub may not contain the referenced app source yet.

---

## 6. Documentation quality audit

### Strengths

- Design Bible v1.0 is locked and certified.
- Chapters 1–19 exist and are named consistently.
- Chapters 15–19 have now been polished.
- ADR-001 prevents destructive template rewrites.
- Canonical terminology exists.
- Implementation backlog exists.
- Global trust laws are explicit.

### Remaining documentation cleanup

| Item | Severity | Action |
|---|---:|---|
| Some docs may imply GitHub contains implementation files | High | Add source-availability caveat to repository/audit docs. |
| AI workspace may lag behind Design Bible authority | Medium | Audit AI workspace after source decision. |
| Updates folder contains historical update files | Low | Keep as archive unless it confuses current work. |
| Older docs outside Design Bible may overlap with Bible | Medium | Treat Design Bible as authoritative; archive or mark older docs as legacy if needed. |

---

## 7. Engineering readiness decision

Previous audit language said the repository was ready for the engineering foundation sprint. That remains directionally true only if the next sprint begins with **source-of-truth reconciliation**.

Updated readiness:

| Category | Grade | Notes |
|---|---:|---|
| Product architecture | A | Strong Design Bible. |
| Documentation governance | A- | ADR and terminology systems exist. |
| Repository organization | B | Documentation structure is improving. |
| Implementation source availability | F | App source is not currently present in GitHub. |
| Testing/build readiness | F | No verified build/test system. |
| Overall engineering readiness | C- | Ready for planning; not ready for feature coding. |

---

## 8. Required next actions

### Action 1 — Resolve source availability

Find and upload the actual app source files, or decide to rebuild.

If recovering source, expected files include:

```text
index.html
perch_core.js
perch_engine.js
perch_today_live.html
perch_life.html
perch_voice.js
perch_beliefs.js
perch_world.md
perch_truth.md
```

This list is based on Design Bible references and may not be complete.

### Action 2 — Create source manifest

Add:

```text
docs/architecture/SOURCE_MANIFEST.md
```

It should answer:

- What files make up the current app?
- Which Design Bible chapter each file supports?
- Which files are active, orphaned, or legacy?
- Which files are missing?

### Action 3 — Build engineering foundation only after source decision

Proceed with:

```text
docs/architecture/SYSTEM_ARCHITECTURE.md
docs/architecture/DATA_MODEL.md
docs/architecture/ENGINE_INTERFACES.md
docs/architecture/EVENT_MODEL.md
docs/architecture/UI_STATE_MODEL.md
docs/architecture/BUILD_SEQUENCE.md
docs/architecture/MVP_SCOPE.md
```

But those documents must be explicit whether they target restored source or clean rebuild.

### Action 4 — Reconcile Design Bible statuses

If source cannot be recovered, Chapters 1–14 may need status language adjusted from repository-verified implementation to historical/proposed implementation. That would require an ADR because it changes the meaning of current status.

---

## 9. Recommended immediate branch sequence

1. `docs/full-repository-audit` — this audit report.
2. `docs/source-manifest` — define missing/restored source files.
3. `engineering/source-restore` or `engineering/rebuild-foundation` — depending on source decision.
4. `docs/engineering-foundation` — architecture docs after source decision.

---

## 10. Final audit statement

Perch has a strong architecture but an unresolved implementation-source gap.

Do not write feature code yet.

The next correct move is to resolve whether the existing app source will be restored into GitHub or whether Perch will be rebuilt from the locked Design Bible.

> The Bible is ready. The repository is not yet the app.
