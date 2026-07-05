# Chapter 18 — Search

> **Chapter:** Search
> **Chapter ID:** PERCH-18
> **Version:** 1.0
> **Status:** Concept — this defines the future dedicated Search domain; current repository search is literal/substring and documented in Chapter 12.
> **Confidence:** 80% — universal retrieval is necessary; semantic/vector implementation details remain future work.
> **Owner:** Jeff
> **Implementation:** Planning — no dedicated Search page is verified as implemented.
> **Depends On:** Knowledge *(Concept)*, Brain *(Prototype)*, People *(Concept)*, Projects *(Concept)*, Truth Engine *(Prototype)*
> **Last Updated:** July 5, 2026

Search is the universal retrieval surface for Perch. It helps the user find anything Perch knows, captured, planned, tracked, or explained.

---

## 1. Primary Question

**How do I instantly find anything across Perch?**

---

## 2. Design Intent

Search should feel like asking Perch where something lives. It must search broadly but answer carefully, preserving source, confidence, and domain boundaries.

---

## 3. Relationship to Chapter 12

Chapter 12 documents the current Knowledge & Search reality: keyword and substring search only.

This chapter defines the future dedicated Search page and universal retrieval model.

---

## 4. Default State

Search should show:

- Recent searches
- Recently touched items
- Suggested useful searches
- Search scope controls

---

## 5. Result Filters

Search results should be filterable by:

- Domain
- Date
- Person
- Source
- Confidence
- Status
- File or document type

---

## 6. Core Information

Every result should show:

- Title or summary
- Domain
- Source
- Confidence or status
- Last updated
- Why it matched
- Link or action to open the source record

---

## 7. AI Responsibilities

The AI should:

- Interpret natural-language searches.
- Explain why results match.
- Distinguish facts from inferred matches.
- Avoid fabricating missing results.
- Say when Perch does not know.

---

## 8. Does Not Belong

- Results without provenance
- Hidden ranking rules
- Web search pretending to be Perch knowledge
- AI answers without links to underlying records

---

## 9. Success Criteria

The user can find anything important without remembering which page owns it.
