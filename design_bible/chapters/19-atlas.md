# Chapter 19 — Atlas

> **Chapter:** Atlas
> **Chapter ID:** PERCH-19
> **Version:** 1.0
> **Status:** Concept — the Atlas is the organizing model for the full Life OS; individual chapters exist, but a dedicated Atlas navigation/intelligence page is not verified as implemented.
> **Confidence:** 86% — the one-question-per-domain model is settled; the user-facing Atlas surface remains future work.
> **Owner:** Jeff
> **Implementation:** Planning — no dedicated Atlas page is verified as implemented.
> **Depends On:** Today *(Prototype)*, all domain chapters, Truth Engine *(Prototype)*, Priority Engine *(Prototype)*, Recommendation Engine *(Prototype)*
> **Last Updated:** July 5, 2026

Atlas is the map of Perch. It explains how every domain works together as one Life OS rather than a pile of disconnected pages.

---

## 1. Vision

The Atlas is the skeleton that holds Perch together. It shows the user and the builder where every domain lives, what it owns, what it connects to, and why it exists.

The vision is a transparent, navigable map where no feature is orphaned, no responsibility is duplicated, and every recommendation can be traced back to its source domains. The Atlas is Perch's commitment to coherence: one question per domain, one answer per question, one system instead of chaos.

This chapter itself is the Design Bible's living Atlas.

---

## 2. Primary Question

**How does every domain work together as one Life OS?**

---

## 3. Design Intent

The Atlas gives Perch a coherent shape. Every page answers one primary question. Every feature belongs somewhere. Every cross-domain recommendation must be traceable to the domains it uses.

---

## 4. Core Rule

> Every feature must have a home.

If a feature does not belong to a chapter, either the chapter map is incomplete or the feature does not belong in Perch.

---

## 5. Read Mode

Shows:

- The user's current life map
- Domains with active attention items
- Domain status and maturity
- Cross-domain relationships
- Where Perch is confident vs incomplete

---

## 6. Explore Mode

Allows browsing by:

- Domain
- Engine
- Status
- Confidence
- Data source
- User goal
- Current attention

---

## 7. Core Information

- Domain list
- Primary question per domain
- Connected engines
- Connected data sources
- Implementation status
- Known gaps
- Build dependencies

---

## 8. AI Responsibilities

The AI should:

- Route ideas to the correct chapter.
- Detect orphan features.
- Explain cross-domain recommendations.
- Preserve boundaries between fact, priority, recommendation, and voice.
- Refuse to treat a feature as ready when its owning chapter marks it Concept or Planning.

---

## 9. Does Not Belong

- A random app menu
- A feature wishlist without status
- Hidden architecture
- Claims that current implementation is more complete than verified

---

## 10. Acceptance Tests

The Atlas page is ready when:

- [ ] A user can see all locked domains and engines with their primary questions.
- [ ] Each domain shows its status.
- [ ] Cross-domain dependencies are visible.
- [ ] A user or builder can ask where a feature belongs and find the owning chapter.
- [ ] Every new feature is mapped to a domain or rejected as orphaned.
- [ ] No orphaned features exist in the architecture.
- [ ] A builder can compare repository implementation against the Design Bible map.

---

## 11. Success Criteria

A user or builder can understand where every part of Perch belongs and why.
