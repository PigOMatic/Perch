# Chapter 17 — Knowledge

> **Chapter:** Knowledge
> **Chapter ID:** PERCH-17
> **Version:** 1.0
> **Status:** Concept — this defines the future dedicated Knowledge domain; Chapter 12 remains the audited combined Knowledge & Search implementation record.
> **Confidence:** 80% — the purpose is clear, but the graph/index architecture is still future work.
> **Owner:** Jeff
> **Implementation:** Planning — no dedicated Knowledge page is verified as implemented.
> **Depends On:** Knowledge & Search *(Prototype)*, Brain *(Prototype)*, People *(Concept)*, Truth Engine *(Prototype)*, Belief Engine *(Prototype)*
> **Last Updated:** July 5, 2026

Knowledge is the domain for what Perch knows, how it knows it, how confident it is, and where each fact came from.

---

## 1. Primary Question

**What does Perch know that can help me?**

---

## 2. Design Intent

Knowledge is not trivia storage. It is a trustworthy personal context layer. It lets the user inspect, correct, connect, and reuse what Perch has learned.

---

## 3. Relationship to Chapter 12

Chapter 12 — Knowledge & Search documents the current combined implementation: structured memories, interests, people details, Brain captures, and literal search.

This chapter defines the eventual dedicated Knowledge domain once the model becomes large enough to deserve its own surface.

---

## 4. Read Mode

Shows:

- Recently learned facts
- Low-confidence facts needing review
- Important known preferences
- Connected people/places/projects
- Facts affecting recommendations

---

## 5. Explore Mode

Allows browsing by:

- Topic
- Person
- Place
- Project
- Source
- Confidence
- Last updated

---

## 6. Core Information

- Fact or memory
- Source
- Confidence
- Last updated
- Connected domains
- Evidence chain
- User corrections

---

## 7. AI Responsibilities

The AI should:

- Explain what Perch knows and why.
- Ask for confirmation when confidence is low.
- Connect facts without overstating certainty.
- Never convert guesses into stored truth.

---

## 8. Does Not Belong

- Unverified personality profiling
- Hidden memory the user cannot inspect
- Semantic claims without source lineage
- Permanent facts that cannot be corrected

---

## 9. Success Criteria

The user can inspect and trust what Perch believes it knows.
