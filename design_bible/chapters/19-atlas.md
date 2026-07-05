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

## 1. Primary Question

**How does every domain work together as one Life OS?**

---

## 2. Design Intent

The Atlas gives Perch a coherent shape. Every page answers one primary question. Every feature belongs somewhere. Every cross-domain recommendation must be traceable to the domains it uses.

---

## 3. Core Rule

> Every feature must have a home.

If a feature does not belong to a chapter, either the chapter map is incomplete or the feature does not belong in Perch.

---

## 4. Read Mode

Shows:

- The user's current life map
- Domains with active attention items
- Domain status and maturity
- Cross-domain relationships
- Where Perch is confident vs incomplete

---

## 5. Explore Mode

Allows browsing by:

- Domain
- Engine
- Status
- Confidence
- Data source
- User goal
- Current attention

---

## 6. Core Information

- Domain list
- Primary question per domain
- Connected engines
- Connected data sources
- Implementation status
- Known gaps
- Build dependencies

---

## 7. AI Responsibilities

The AI should:

- Route ideas to the correct chapter.
- Detect orphan features.
- Explain cross-domain recommendations.
- Preserve boundaries between fact, priority, recommendation, and voice.

---

## 8. Does Not Belong

- A random app menu
- A feature wishlist without status
- Hidden architecture
- Claims that current implementation is more complete than verified

---

## 9. Success Criteria

A user or builder can understand where every part of Perch belongs and why.
