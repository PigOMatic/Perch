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

## 1. Vision

Search transforms scattered information across Perch into one clear answer: "Where is this thing?" The vision is semantic, domain-aware retrieval that preserves source, confidence, and context.

A user should be able to search across people, projects, goals, facts, captures, and memories without needing to remember which page owns each record. Search should feel like asking a knowledgeable assistant where something lives, not fighting a keyword box. Chapter 12 documents the current literal search reality; this chapter defines the future intelligent retrieval layer.

---

## 2. Primary Question

**How do I instantly find anything across Perch?**

---

## 3. Design Intent

Search should feel like asking Perch where something lives. It must search broadly but answer carefully, preserving source, confidence, and domain boundaries.

---

## 4. Relationship to Chapter 12

Chapter 12 documents the current Knowledge & Search reality: keyword and substring search only.

This chapter defines the future dedicated Search page and universal retrieval model.

---

## 5. Read Mode

The default state when Search opens should show:

- Recent searches
- Recently touched items
- Suggested useful searches based on current context
- Search scope controls

---

## 6. Explore Mode

When results appear, Explore Mode should support:

- Results sorted by relevance, date, and domain
- Filters by domain, date, person, source, confidence, and status
- Match explanations for each result
- A direct way to open the source record or related context

---

## 7. Result Filters

Search results should be filterable by:

- Domain
- Date
- Person
- Source
- Confidence
- Status
- File or document type

---

## 8. Core Information

Every result should show:

- Title or summary
- Domain
- Source
- Confidence or status
- Last updated
- Why it matched
- Link or action to open the source record

---

## 9. AI Responsibilities

The AI should:

- Interpret natural-language searches.
- Explain why results match.
- Distinguish facts from inferred matches.
- Avoid fabricating missing results.
- Say when Perch does not know.

---

## 10. Does Not Belong

- Results without provenance
- Hidden ranking rules
- Web search pretending to be Perch knowledge
- AI answers without links to underlying records

---

## 11. Acceptance Tests

The Search page is ready when:

- [ ] A user can search across all implemented domains from one place.
- [ ] Results are sorted by relevance with an explanation for each match.
- [ ] Each result shows source, confidence, and domain.
- [ ] Filters work by domain, date, person, source, status, and confidence where those fields exist.
- [ ] Sensitive records respect privacy and visibility rules.
- [ ] Empty results say Perch does not know rather than inventing matches.
- [ ] Search does not imply semantic/vector capability until that capability exists.

---

## 12. Success Criteria

The user can find anything important without remembering which page owns it.
