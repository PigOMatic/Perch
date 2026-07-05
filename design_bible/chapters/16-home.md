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

## 1. Primary Question

**What is happening in my physical world?**

---

## 2. Design Intent

Home turns scattered physical-life responsibilities into a clear operating view. It should not become a generic notes app or contractor database. It should answer what needs care, where it is, why it matters, and what is connected to it.

---

## 3. Relationship to Chapter 14

Chapter 14 — Home & Property documents the current repository reality: shallow but real `properties[]` and `homestead{}` data.

This chapter defines the eventual Home page/domain experience that grows out of that model.

---

## 4. Read Mode

Shows:

- Urgent maintenance
- Upcoming physical-world obligations
- Property alerts
- Animal/livestock care items
- Utility or equipment reminders
- Open projects tied to a place

---

## 5. Explore Mode

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

## 6. Core Information

- Location hierarchy
- Maintenance items
- Equipment and systems
- Utility relationships
- Property financial links
- Animal/homestead records
- Documents and photos
- History and notes

---

## 7. AI Responsibilities

The AI should:

- Surface overdue or risky home items.
- Connect home work to money, calendar, and projects.
- Explain why something matters now.
- Never invent property facts, locations, costs, or due dates.

---

## 8. Does Not Belong

- Smart-home automation as a first requirement
- Unverified contractor recommendations
- Insurance or legal claims without source documents
- Decorative property fantasy detached from stored truth

---

## 9. Success Criteria

The user can answer:

- What needs care?
- Where is it?
- What does it cost or affect?
- What is overdue?
- What should be planned next?
