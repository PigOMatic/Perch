# Chapter 16 — Home

> **Chapter:** Home
> **Chapter ID:** PERCH-16
> **Version:** 1.0
> **Status:** Concept — this defines the future user-facing Home domain; Chapter 14 remains the audited implementation record for current Home & Property data.
> **Confidence:** 78% — the need for a dedicated Home surface is clear; its exact model depends on location hierarchy work.
> **Owner:** Jeff
> **Implementation:** Planning — no dedicated Home page is verified as implemented.
> **Depends On:** Home & Property *(Prototype)*, Projects *(Concept)*, Calendar & Obligations *(Prototype)*, Money *(Concept/Partial)*, Truth Engine *(Prototype)*
> **Last Updated:** July 5, 2026

Home is the user-facing domain for the user's physical world: residence, land, rooms, buildings, equipment, animals, maintenance, utilities, and place-based obligations.

---

## 1. Vision

The Home page gives the user a complete, navigable view of their physical world without becoming an inventory app or property management system. It should answer at a glance: what needs care right now, where it is, why it matters, and what is connected to it.

Eventually, Home becomes one of the places the Living World can reflect — a structure, animal, garden, system, or place may appear visually only when backed by stored truth. Chapter 14 documents the current implementation reality; this chapter defines the future Home surface that grows from it.

---

## 2. Primary Question

**What is happening in my physical world?**

---

## 3. Design Intent

Home turns scattered physical-life responsibilities into a clear operating view. It should not become a generic notes app, contractor database, or smart-home dashboard. It should answer what needs care, where it is, why it matters, and what is connected to it.

---

## 4. Relationship to Chapter 14

Chapter 14 — Home & Property documents the current repository reality: shallow but real `properties[]` and `homestead{}` data.

This chapter defines the eventual Home page/domain experience that grows out of that model.

---

## 5. Read Mode

Shows:

- Urgent maintenance
- Upcoming physical-world obligations
- Property alerts
- Animal/livestock care items
- Utility or equipment reminders
- Open projects tied to a place

---

## 6. Explore Mode

Allows browsing by:

- Property
- Building
- Room
- Land area
- System/equipment
- Animal/group
- Project
- Maintenance history

---

## 7. Core Information

- Location hierarchy
- Maintenance items
- Equipment and systems
- Utility relationships
- Property financial links
- Animal/homestead records
- Documents and photos
- History and notes

---

## 8. AI Responsibilities

The AI should:

- Surface overdue or risky home items.
- Connect home work to money, calendar, and projects.
- Explain why something matters now.
- Never invent property facts, locations, costs, due dates, rooms, buildings, or systems.

---

## 9. Does Not Belong

- Smart-home automation as a first requirement
- Unverified contractor recommendations
- Insurance or legal claims without source documents
- Decorative property fantasy detached from stored truth

---

## 10. Acceptance Tests

The Home page is ready when:

- [ ] A user can see urgent maintenance items quickly.
- [ ] Each maintenance item shows what, where, urgency, cost estimate if known, and next step.
- [ ] Properties are browsable by a location hierarchy.
- [ ] Financial data is linked and sourced rather than copied ambiguously.
- [ ] No invented property facts or assumed structures appear.
- [ ] Calendar & Obligations connections are visible when due dates or recurrence exist.

---

## 11. Success Criteria

The user can answer:

- What needs care?
- Where is it?
- What does it cost or affect?
- What is overdue?
- What should be planned next?
