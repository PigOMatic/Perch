# Chapter 15 — People

> **Chapter:** People
> **Chapter ID:** PERCH-15
> **Version:** 1.0
> **Status:** Concept — relationship identity, reminders, and linked context are specified; no dedicated People page is verified as implemented in the repository.
> **Confidence:** 82% — the purpose and boundaries are settled; the data model and interaction depth will mature after v1.
> **Owner:** Jeff
> **Implementation:** Planning — this chapter establishes the canonical home for relationship intelligence before build-out.
> **Depends On:** Brain *(Prototype)*, Calendar & Obligations *(Prototype)*, Goals *(Prototype)*, Projects *(Concept)*, Truth Engine *(Prototype)*, Voice Engine *(Prototype)*
> **Last Updated:** July 5, 2026

People is the canonical representation of every person that matters to the user.

People are not merely contacts. They are relationships that connect the entire Perch ecosystem.

---

## 1. Primary Question

**Who matters, what matters about them, and what should I know right now?**

---

## 2. Design Intent

The People page helps users understand their relationships, commitments, history, and future interactions without becoming an address book, CRM, or social feed.

---

## 3. Read Mode

Shows what matters now:

- Upcoming birthdays
- Recent interactions
- Shared goals or projects
- Health or care reminders
- Relationship timeline
- Open obligations involving that person

---

## 4. Explore Mode

Allows exploration by:

- Family
- Friends
- Coworkers
- Medical providers
- Vendors
- Pets, if modeled as household relationships
- Organizations

---

## 5. Core Information

Each person may contain:

- Identity
- Relationship
- Contact methods
- Important dates
- Linked properties
- Linked projects
- Linked goals
- Linked obligations
- Notes
- Documents
- Interaction history

---

## 6. Connected Engines

- Truth Engine
- Priority Engine
- Recommendation Engine
- Voice Engine

---

## 7. Connected Domains

- Today
- Calendar & Obligations
- Money
- Goals
- Projects
- Brain
- Home & Property
- Knowledge & Search

---

## 8. AI Responsibilities

The AI should:

- Surface meaningful reminders.
- Detect stale relationship information.
- Connect people to relevant context.
- Never invent facts about relationships.
- Preserve source and confidence for relationship facts.

---

## 9. Does Not Belong

- Social media feed
- Chat application
- CRM complexity
- Public profile scraping
- Unverified assumptions about relationships

---

## 10. Future Expansion

- Household management
- Shared planning
- Caregiver mode
- Emergency planning
- Family knowledge graph

---

## 11. Success Criteria

A user can immediately understand:

- Who matters.
- What is happening with them.
- What commitments exist.
- What needs attention.
- Why Perch surfaced this information.
