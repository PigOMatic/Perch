# Perch Design Bible v1.0 — Release Notes

**Release:** Design Bible v1.0 Architecture Baseline  
**Date:** July 5, 2026  
**Repository:** `PigOMatic/Perch`

---

## What changed

The Design Bible is now locked as the architectural baseline for Perch.

This release establishes:

- A complete 19-chapter Atlas map
- Canonical chapter naming
- A canonical chapter template
- v1 lock record
- v1 chapter audit record
- Design Bible certification
- Updated README and changelog

---

## What this release is

This is a product architecture release.

It defines what Perch must become and how future work should be judged.

---

## What this release is not

This is not a production implementation release.

It does not claim that:

- Perch is feature-complete.
- Every domain has a working page.
- Every engine is fully implemented.
- External integrations exist.
- Chapters 15–19 are as deep as chapters 1–14.

---

## Major architectural decisions now locked

1. The Design Bible is authoritative for product architecture.
2. The repository is authoritative for current implementation reality.
3. The AI workspace governs AI-agent behavior only.
4. Every feature must have a chapter home.
5. Truth, Priority, Recommendation, and Voice are separate architectural responsibilities.
6. Perch must never invent certainty.
7. Source lineage is mandatory for numbers and high-trust claims.
8. Integrations must be opt-in, provenance-tagged, and confidence-aware.
9. Living World must reflect stored truth, not decorative fantasy.
10. Architecture changes after this point require ADRs.

---

## Recommended next milestone

Move from product architecture to engineering foundation.

Recommended next branch:

```text
docs/engineering-foundation
```

Recommended next files:

```text
docs/architecture/SYSTEM_ARCHITECTURE.md
docs/architecture/DATA_MODEL.md
docs/architecture/ENGINE_INTERFACES.md
docs/architecture/EVENT_MODEL.md
docs/architecture/UI_STATE_MODEL.md
docs/architecture/BUILD_SEQUENCE.md
docs/architecture/MVP_SCOPE.md
docs/architecture/IMPLEMENTATION_BACKLOG.md
```

---

## Release status

Ready for implementation planning.
