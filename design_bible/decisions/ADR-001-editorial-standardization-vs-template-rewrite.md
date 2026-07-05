# ADR-001 — Editorial Standardization vs Mechanical Template Rewrite

**Date:** July 5, 2026  
**Status:** Accepted  
**Decision owner:** Chief Architect

---

## Context

After the Design Bible v1.0 Architecture Baseline was locked, the next proposed task was to standardize every chapter against the canonical chapter template.

A strict interpretation would require rewriting Chapters 1–14 into the exact same visible section order as the template.

However, Chapters 1–14 were written through repository-aware audits. Several are stronger because they use specialized structures:

- Truth Engine reads like constitutional law.
- Money emphasizes trust, source lineage, and high-stakes correctness.
- Priority and Recommendation emphasize engine-boundary debt.
- Living World emphasizes doctrine-vs-implementation gap.
- Integrations emphasizes the verified absence of external data paths.

A mechanical rewrite would make them look more uniform but risk weakening the architecture signal.

---

## Decision

Do not mechanically rewrite Chapters 1–14 into the template.

Use the canonical chapter template as a checklist, not a forced visible layout.

Standardize only where doing so improves clarity, correctness, or implementation readiness.

---

## Rationale

Perch values clarity over symmetry.

The purpose of the Design Bible is to guide implementation, not to make every file visually identical. A chapter may deviate from the template when its current structure better communicates architecture, risk, implementation reality, and product intent.

---

## Consequences

Positive:

- Preserves the strongest repository-aware chapters.
- Avoids accidental loss of nuance.
- Keeps architecture-first writing style intact.
- Prevents churn before implementation.

Negative:

- Chapters will not all have identical visible section order.
- Future auditors must read for architectural completeness, not just template compliance.

---

## Follow-up

Use `design_bible/EDITORIAL_STANDARDIZATION_PASS_1.md` as the editorial checklist and audit record.

Future chapter revisions should improve clarity without changing locked architecture unless a new ADR is created.
