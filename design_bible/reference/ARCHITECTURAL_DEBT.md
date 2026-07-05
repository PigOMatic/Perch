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
| AD-001 | Source of Truth | Perch must maintain a clear distinction between Design Bible, repository state, and implementation reality. | High | Open |
| AD-002 | Demo Data | Demo/sample data must never be confused with real user data. | Critical | Open |
| AD-003 | Privacy | Future analytics and intelligence must avoid exposing private user content unnecessarily. | Critical | Open |
| AD-004 | Intelligence | Perch risks becoming too “smart” before it is reliably clear. | High | Open |
| AD-005 | Data Freshness | User-entered information may become stale without visible freshness indicators. | High | Open |
| AD-006 | Explanation Layer | Perch needs consistent “why am I seeing this?” explanations across major surfaces. | Medium | Open |
| AD-007 | Capture Flow | Captures, reminders, questions, and waiting items need a durable shared model. | High | Open |
| AD-008 | Money Flow | Money features must avoid appearing more precise than the available user data supports. | Critical | Open |
| AD-009 | Notifications | Notification rules must avoid becoming noisy, repetitive, or anxiety-producing. | High | Open |
| AD-010 | Mobile Future | iPhone widget and mobile-first behavior are expected later but not yet structurally planned. | Medium | Open |
| AD-011 | Import/Export | Perch needs a future-safe data portability strategy. | Medium | Open |
| AD-012 | AI Hand-Off | Claude, ChatGPT, and future agents need consistent boot instructions and boundaries. | Medium | Open |
| AD-013 | Status Labels | Documentation needs clear status labels: proposed, designed, implemented, tested, deprecated. | High | Open |
| AD-014 | Naming Consistency | Terms like Brain, Today, Week, Tell Perch, Daily Brief, and Basics must stay consistent. | Medium | Open |

---

## Protected Principles

Debt resolution must not violate:

- the Perch Constitution
- privacy by default
- clarity over feature count
- simple user-facing language
- visible uncertainty
- Design Bible authority

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
