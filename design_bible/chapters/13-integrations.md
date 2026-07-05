# Chapter 13 — Integrations

> **Chapter:** Integrations
> **Chapter ID:** PERCH-13
> **Version:** 1.0
> **Status:** Concept — Perch has **zero external integrations**. Every piece of data is entered by hand. There is no import, no sync, no API, no OAuth anywhere in the codebase.
> **Confidence:** 90% — the absence is total and verified; the eventual shape of integrations is open design
> **Owner:** Jeff
> **Implementation:** Not Started — the only network call in the app is a local file-existence check at boot
> **Depends On:** Truth Engine *(Prototype — imported data must carry provenance)*, Money *(Implemented math)*, Calendar *(Implemented engine)*, Brain *(Prototype)*
> **Last Updated:** July 5, 2026

*Integrations are how Perch would eventually learn things without being told — bank transactions, calendar events, weather, email receipts. This chapter is the most clear-cut in the Design Bible: **none of it exists.** Perch is, today, a fully manual, fully local, fully offline application. That is not a gap to hide — it is a deliberate starting point. A manual Perch that is correct and trustworthy (the v0.5 goal) must come before an integrated Perch that is convenient. This chapter documents the empty room and the rules any future integration must obey when it arrives.*

---

## 1. Purpose

This chapter governs how Perch would connect to **external data sources** — and, just as importantly, the rules those connections must follow to preserve trust. It is the boundary between Perch's private, manual world and the outside systems that could feed it.

**Primary question this chapter answers:** *Where does Perch's data come from, and how would outside data enter without breaking trust?*

---

## 2. Vision

The convenience ceiling of Perch is bounded by manual entry. A person will not hand-enter every transaction, every calendar event, every bill. The vision of integrations is to let real-world data flow in — read-only, provenance-tagged, never trusted blindly — so Perch's picture of a life is complete without being a chore to maintain. Bank transactions would sharpen Money; a calendar would complete the timeline; weather would unlock the cross-domain recommendation ("good day to mow"); email receipts would auto-populate bills.

The vision is bounded hard by discipline: **integrations come last, not first.** Every prior chapter's Known Unknowns ("Perch only knows what you entered") is an argument *for* integrations — and a reminder that until they exist, Perch must be honest that its picture is partial. When they do arrive, they enter as a distinct, clearly-labeled provenance class that never silently overrides what the user told Perch.

---

## 3. Design Philosophy

- **Manual first, integrated later.** Trust the manual system before automating it (v0.5 build plan).
- **Read-only by default.** Perch reads external data; it does not write to external systems or act on the user's behalf without explicit, per-action confirmation. It never moves money.
- **Provenance always.** Imported data is tagged with its source and timestamp — never blended anonymously into manual data.
- **Manual truth wins on conflict.** If an import disagrees with what the user entered, Perch surfaces the disagreement (global law); it does not silently overwrite the user.
- **Offline-first, permanently.** Perch must work fully with no connection. Integrations enrich; they are never required.
- **Opt-in, disclosed, revocable.** Every integration is the user's explicit choice, clearly explained, and can be disconnected.

---

## 4. Current Implementation (repo-verified)

Brutally honest, and the finding is absolute.

### 4a. There are zero integrations
An exhaustive search for network calls, APIs, imports, sync, and OAuth found **nothing**:
- **The only `fetch()` in the entire codebase** is in `index.html`: a local `HEAD` request (`checkFile`) that verifies app files exist during boot. It contacts no external server. It is not an integration.
- **No `XMLHttpRequest`, no WebSocket, no axios, no external `https://` calls, no API clients.**
- **No OAuth, no tokens, no credentials, no webhooks.**

### 4b. All data is manual
Every value in Perch enters by hand and is tagged accordingly: `source: 'perch_input'`, `user_created`, `user_owned`, or `seed` (demo data). There is **no import path of any kind** — no CSV import, no file ingestion, no external write into the stores.

### 4c. Storage is local only
State lives in `localStorage` (`PerchMemory`, keyed store). There is **no server, no database, no cloud, no sync.** Save/load is local read/write; `refresh()` rebuilds an in-memory cache. Nothing leaves the device.

### 4d. Named integrations — all absent (verified)
| Integration | Status | Evidence |
|---|---|---|
| **Tiller** (transactions) | Concept | No code. Not referenced anywhere in the app. |
| **Banking / Plaid** | Concept | No code. (Money is manual — Chapter 2.) |
| **Calendar** (Google/Apple/Outlook) | Concept | No code. Only the internal work schedule exists (Chapter 3). |
| **Email** (Gmail receipts/bills) | Concept | No code. (Inbox Intelligence is Concept — Chapter 2.) |
| **Weather** | Concept | No code. Blocks the cross-domain recommendation (Chapters 1, 9). |
| **GitHub** | Concept | No code. (Not part of a life-OS surface today.) |
| **Health** (HealthKit/Google Fit) | Concept | No code. (Health is a future chapter, 16.) |
| **Any external API** | Concept | None exists. |

The only textual mentions of "Google/Apple sync planned later" appear in **orphan experimental files** (`perch_v2.html`, `perch_v3.html`) as placeholder UI copy — not code, not in the deployed app, and slated for archival (v0.5 hygiene).

### 4e. Synchronization & offline (by omission)
- **Sync strategy:** none — there is nothing to sync with.
- **Offline behavior:** Perch is **offline-only by nature.** With no network dependency, it works fully offline already. This is an accidental strength: the offline-first ideal is met because nothing is online.

---

## 5. Planned Architecture

When integrations arrive (last, per discipline):
- An **ingestion layer** that pulls read-only external data.
- A **provenance tag** on every imported record (source, timestamp, confidence).
- A **conflict surface** (manual vs. imported disagreement — global law).
- **Per-integration opt-in/disconnect** controls (Settings, Chapter 19).
- **Sync strategy** — polling or manual refresh; no real-time requirement.
- **Offline preservation** — imports cache; absence never breaks Perch.
All Concept.

---

## 6. Integration Types (all Concept)

- **Financial** (Tiller / banking) — transactions, balances → Money. The highest-value integration; unlocks spending, duplicates, live-ish balance (Chapter 2 §10).
- **Calendar** (Google/Apple/Outlook) — events → the timeline. Completes Calendar (Chapter 3).
- **Email** (receipts/bills) — auto-populate obligations → Brain/Money (Inbox Intelligence).
- **Weather** — forecast → cross-domain recommendations (Chapter 9's flagship).
- **Health** — activity/sleep → a future Health chapter (16).
- **Developer** (GitHub, etc.) — only if a life-OS surface ever needs it; lowest priority.

---

## 7. Import Models

- **Manual import** *(Concept)* — user uploads a file (e.g. a Tiller CSV). The simplest first step; no live connection.
- **Automatic import** *(Concept)* — a live read-only connection polls or receives data.
Today: **neither exists.** All data is direct manual entry, which is not "import" — it's origination.

## 8. Synchronization Strategy

*Concept.* No sync exists. Planned posture: pull-based, low-frequency, user-triggerable; never real-time; never write-back without per-action confirmation. Conflicts surface, never auto-resolve.

## 9. Offline Behavior

*Implemented by omission.* Perch is fully functional offline because it has no online dependency. When integrations arrive, the rule is that offline must remain first-class: cached imports persist, and a missing connection degrades gracefully to the last-known (clearly timestamped) data — never an error, never a blank.

## 10. Source Lineage & Provenance

*Prototype (manual only).* Today provenance is the three manual signals — `seed` / `user_created` / `source:'perch_input'` (Chapter 7 §4d). There is **no imported-data provenance** because there is no imported data. When integrations arrive, every record must carry a full lineage (Chapter 7's planned runtime provenance): e.g. `Balance → Checking → Plaid → Bank`, with a timestamp. An imported figure is shown only as "as of [time], via [source]," never as a bare fact.

## 11. Confidence Propagation

*Concept.* Imported data would carry a confidence appropriate to its source and freshness (a bank balance from this morning is high-confidence; a three-day-old cached one lower). Today, confidence exists only for beliefs (Chapter 7 §4c); imported-data confidence is entirely unbuilt. The rule: **an integration's confidence must propagate to anything derived from it** — a projection built on a stale imported balance inherits that staleness.

---

## 12. Read Mode / Explore Mode

Integrations have **no user-facing surface today.** When built, their surface is primarily in **Settings** (Chapter 19): connect/disconnect, see what's synced, view provenance. Data from integrations would appear *within* the relevant chapter's pages (a bank transaction on Money, an event on Calendar), always provenance-tagged — never in a separate "integrations" feed.

---

## 13. Relationships

- **Truth Engine (Prototype):** the gatekeeper of imported data — every import is provenance-tagged, conflict-surfaced, and confidence-propagated. Integrations are the scenario the Truth Engine's cross-source disagreement rule (Chapter 7 §12) was written for, and the reason to build it.
- **Money (Implemented math):** the highest-value integration target (transactions/balance). Money's strict rules (Chapter 2) govern any financial import: no live-balance claim without a real feed; imported figures timestamped.
- **Calendar & Obligations (Implemented):** external-calendar ingestion completes the timeline; today only the internal work schedule exists.
- **Brain (Prototype):** email/receipt integration would auto-create captures — which must still preserve source truth and be user-correctable.
- **Recommendation Engine (Prototype):** the cross-domain flagship ("mow Tuesday") is *blocked* on weather + calendar integrations. This chapter is why that recommendation is Concept.
- **Health / People / Home (future chapters):** each has an eventual integration (health devices, contacts, property services) — all Concept.
- **Living World (Concept):** richer real data (a logged trip via location, a completed project via receipts) would feed truthful world scenery — far future.
- **Settings (Chapter 19):** the control surface for every integration.

---

## 14. Integration Rules

- **Read-only by default; never act without explicit per-action confirmation; never move money.**
- **Every imported record is provenance-tagged and timestamped.**
- **Manual truth wins on conflict; disagreements are surfaced, not silently resolved.**
- **Offline is never broken by an integration.**
- **Opt-in, disclosed, disconnectable.**
- **Confidence propagates** from source to everything derived.
- **No integration is required** for Perch to function.

## 15. Known Unknowns

- **Everything** — with zero implementation, this chapter is design intent, not validated behavior.
- **Which integration comes first** (Tiller/banking is highest-value, but also highest-risk and most complex).
- **How conflicts should be surfaced** in the UI without alarming the user.
- **Privacy/security posture** for held external data (Chapter 20 territory).
- **Whether some integrations should be local-only** (e.g. a Tiller CSV parsed on-device, never uploaded).

## 16. What Does NOT Belong

- **No write-back or autonomous action** — Perch never acts on external systems unprompted, never moves money.
- **No silent overwrite of manual data.**
- **No untagged imported data** — provenance is mandatory.
- **No required connectivity** — offline-first is permanent.
- **No integration before the manual system is trustworthy** (v0.5 first).
- **No blending of demo/seed and real/imported data** — provenance keeps them distinct.

## 17. Dependencies

- Truth Engine *(Prototype)* — provenance, conflict, confidence for imports.
- The target chapters (Money, Calendar, Brain, Health) — where imported data lands.
- Settings *(Concept, Ch.19)* — the control surface.

## 18. Missing Dependencies

- **An ingestion layer** *(Concept)* — nothing exists.
- **Imported-data provenance model** *(Concept)*.
- **Cross-source conflict detection** *(Concept — Chapter 7's unbuilt piece)*.
- **Confidence propagation** *(Concept)*.
- **Per-integration opt-in/disconnect UI** *(Concept)*.
- **A backend or sync mechanism** *(Concept — Perch is currently serverless/local-only)*.

## 19. Future Build Order

*(Gated: do not begin until v0.5's manual system is trustworthy.)*
1. **Manual file import first** — e.g. a Tiller CSV parsed on-device, provenance-tagged, conflict-surfaced. Lowest-risk way to prove the ingestion rules with no live connection.
2. **Provenance + conflict plumbing** — build Chapter 7's imported-data lineage and disagreement surface here, where it's first needed.
3. **Calendar ingestion** (read-only) — completes the timeline; high value, moderate risk.
4. **Weather** — small, unlocks the cross-domain recommendation.
5. **Banking / Plaid** (live financial) — highest value, highest risk; only after 1–4 prove the rules.
6. **Email receipts** — auto-captures; needs strong privacy posture.
7. **Health / others** — as their chapters mature.

Step 1 is the keystone: **prove the import rules with an on-device file, no live API,** before connecting anything.

## 20. Acceptance Tests

**Current (verified):**
- [x] No external network calls exist (only a local file-existence `HEAD` check at boot).
- [x] No OAuth, tokens, credentials, or webhooks exist.
- [x] All data is manual (`perch_input`/`user_created`/`seed`); no import path.
- [x] Storage is `localStorage` only; no server, no sync.
- [x] Perch functions fully offline (no online dependency).
- [x] Named integrations (Tiller, Plaid, Calendar, Email, Weather, GitHub, Health) are all absent; the only mentions are placeholder copy in orphan files.

**Planned (Concept — not built):**
- [ ] An ingestion layer imports read-only external data.
- [ ] Every imported record is provenance-tagged and timestamped.
- [ ] Manual/imported conflicts are surfaced, never silently resolved.
- [ ] Confidence propagates from source to derived values.
- [ ] Each integration is opt-in and disconnectable.
- [ ] Offline remains fully functional with cached imports.

## 21. Repository Mapping

| Concept | Repository location | Status |
|---|---|---|
| Local file-existence check | `checkFile`/`fetch(HEAD)` in `index.html` | Implemented (not an integration) |
| Manual data provenance | `seed`/`user_created`/`source` in `perch_core.js` | Prototype |
| Local storage | `PerchMemory` / `localStorage` | Implemented |
| Tiller / banking / Plaid | — | Concept |
| Calendar ingestion | — | Concept |
| Email ingestion | — | Concept |
| Weather | — | Concept |
| GitHub | — | Concept |
| Health | — | Concept |
| Ingestion layer / sync | — | Concept |
| Imported-data provenance | — | Concept |
| Confidence propagation | — | Concept |

## 22. Notes

The honest headline: **Perch has no integrations, and that is correct for now.** The audit is unambiguous — the only network call in the entire application is a local check that its own files exist. There is no API, no import, no sync, no OAuth, no external data of any kind. Every number, date, person, and note was typed by the user or seeded as demo data. Perch is fully manual, fully local, fully offline.

Answering the audit directly: **there are zero current integrations; no manual or automatic imports; no Tiller, Calendar, Email, Weather, GitHub, or Health; no external APIs; no synchronization strategy (nothing to sync); offline behavior is total (offline-first by omission); source lineage is the three manual provenance signals; confidence propagation from imports does not exist.**

This is the emptiest chapter in the Bible, and deliberately so. Integrations are the convenience layer, and Perch's discipline is that **convenience comes after trust.** Every other chapter's "Perch only knows what you told it" is both an argument for integrations and a warning: the moment external data flows in, the Truth Engine's provenance, conflict, and confidence machinery (Chapter 7's unbuilt pieces) become mandatory, not optional. So the build order starts with the safest possible integration — an on-device file import that proves the rules before a single live connection is made. Perch will earn integrations the same way it earns everything else: by being trustworthy first.

## Change Log

| Date | Version | Change |
|---|---|---|
| Jul 5 2026 | 1.0 | Chapter created at status Concept. Exhaustive audit confirmed ZERO external integrations: the only `fetch` is a local file-existence `HEAD` check; no API, import, sync, OAuth, or external data anywhere. All data manual (`perch_input`/`user_created`/`seed`); storage is `localStorage` only; Perch is offline-first by omission. Tiller/Plaid/Calendar/Email/Weather/GitHub/Health all absent (only placeholder copy in orphan files). Documented the integration rules any future import must obey (read-only, provenance-tagged, manual-wins-on-conflict, confidence-propagating, opt-in). Keystone = prove import rules with an on-device file before any live API. |
