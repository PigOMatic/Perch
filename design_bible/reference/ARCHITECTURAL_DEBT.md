# ARCHITECTURAL_DEBT.md

# Perch Architectural Debt

## Purpose

This document tracks known architectural weaknesses, unresolved decisions, and future risks in Perch.

Architectural debt is not failure.

It is a visible list of places where Perch is not yet as clean, strong, or permanent as it needs to become.

The goal is not to fix everything immediately.

The goal is to prevent hidden rot.

---

## Debt Rules

Architectural debt must be:

- named clearly
- documented honestly
- tied to a real risk
- assigned a severity
- revisited before major releases
- never hidden because it is inconvenient

Debt should not become a dumping ground for random feature ideas.

If something is a desired feature, it belongs in the roadmap.

If something is a weakness in the foundation, it belongs here.

---

## Severity Levels

### Critical

Threatens trust, privacy, data integrity, or core product direction.

Critical debt must be resolved before public release.

### High

Creates confusion, fragility, or repeated development friction.

High debt should be resolved before v1.0.

### Medium

Important, but not blocking current progress.

Medium debt should be tracked and scheduled intentionally.

### Low

Known imperfection that does not meaningfully threaten the product yet.

Low debt should not distract from core work.

---

## Current Debt Register

| ID | Area | Debt | Severity | Status |
|---|---|---|---|---|
| AD-001 | Source of Truth | Perch must keep Design Bible destination, repository reality, and implementation status separate. | High | Open |
| AD-002 | Reference Drift | Some reference files lagged behind the current Atlas/chapter architecture. | High | Open |
| AD-003 | Truth Engine | Truth exists as doctrine and belief-scoped runtime logic, not a universal runtime gate. | Critical | Open |
| AD-004 | Priority Engine | Priority exists as multiple independent scorers, not one unified explainable engine. | High | Open |
| AD-005 | Recommendation Engine | Recommendations are currently top priority-scored candidates rather than a standalone reasoning engine. | High | Open |
| AD-006 | Voice Engine | Voice exists as three independent systems and does not yet fully phrase the main brief through one path. | Medium | Open |
| AD-007 | Living World | Living World is concept-level; current implementation is only a static decorative preview. | Medium | Open |
| AD-008 | Goals | Goals are fragmented across multiple collections and are not yet a unified life-goal system. | High | Open |
| AD-009 | Money | Money logic is manual and split across Today and Life; payday logic has known imprecision. | Critical | Open |
| AD-010 | Brain | Brain has typed capture but no semantic memory, vector search, or capture aging. | High | Open |
| AD-011 | Knowledge & Search | Knowledge is scattered across separate stores; search is substring-only and not unified. | High | Open |
| AD-012 | Integrations | There are zero external integrations; all data is manual/local/offline. | Medium | Open |
| AD-013 | Home & Property | Property and homestead data are flat; no rooms, buildings, land hierarchy, equipment, or maintenance history model. | High | Open |
| AD-014 | Projects / Home Overlap | Home maintenance and Projects overlap but do not share a durable task/project model. | High | Open |
| AD-015 | Demo Data | Demo/sample data must never be confused with real user data. | Critical | Open |
| AD-016 | Data Freshness | User-entered information may become stale without visible freshness indicators. | High | Open |
| AD-017 | Explanation Layer | Perch needs consistent “why am I seeing this?” explanations across all major surfaces. | High | Open |
| AD-018 | Notifications | Notification rules must avoid becoming noisy, repetitive, or anxiety-producing. | High | Open |
| AD-019 | Import / Export | Perch needs a future-safe data portability strategy before serious user data accumulation. | Medium | Open |
| AD-020 | Navigation Authority | Atlas/page navigation has evolved several times and needs an ADR to lock the canonical model. | Medium | Open |

---

## Protected Principles

Debt resolution must not violate:

- the Perch Constitution
- privacy by default
- clarity over feature count
- simple user-facing language
- visible uncertainty
- Design Bible authority
- source lineage for important claims
- honest implementation status

---

## v0.5 Blocking Debt

The following debt should be addressed before v0.5 is considered ready:

1. AD-002 — Reference Drift
2. AD-003 — Truth Engine boundaries clearly documented
3. AD-009 — Money payday correctness and false precision risk
4. AD-011 — Unified search scope defined, even if semantic search is deferred
5. AD-015 — Demo data distinction
6. AD-017 — Explanation layer baseline
7. AD-020 — Navigation authority documented

---

## Review Schedule

Architectural debt should be reviewed:

- before v0.5 implementation begins
- before v0.5 is declared complete
- before any public beta
- before any major intelligence or automation feature
- whenever a repeated bug reveals a deeper design weakness

---

## Closing Standard

A debt item may only be closed when the weakness is actually resolved, documented, and reflected in the relevant source of truth.

Do not close debt because it is annoying.

Do not close debt because it is old.

Do not close debt because the app “seems fine.”

Close debt only when Perch is stronger because the issue was handled.
