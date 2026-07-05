# Perch Design Bible — CHANGELOG

*Canonical change log for the Design Bible. Each entry records a chapter or plan, its status, and the key findings that justified it.*

| Date | Change |
|---|---|
| Jul 4 2026 | Bible established. README (three-layer model, status system, indexes, authoring rules), Layer 1 Vision, chapter template created. |
| Jul 4 2026 | Chapter 0 (Overview) and Chapter 1 (Today) written. Today serves as proof-of-method. |
| Jul 4 2026 | Chapter 2 (Money) written at stricter standard. Elevated Statement Classification, Source Lineage, and Trust rules to global law. |
| Jul 4 2026 | Chapter 3 (Calendar & Obligations) written at status Prototype. Reconciled Atlas index (Calendar+Obligations merged into Ch.3). Traced all time logic to `PerchDate`/`PerchEvents`. |
| Jul 4 2026 | Chapter 4 (Goals) written at status Prototype. Verified funded-savings loop Implemented; documented three-collection fragmentation (`future_horizon`/`goals`/`homestead.goals`); labeled hierarchy, non-financial types, and per-goal history as Concept. |
| Jul 4 2026 | Chapter 5 (Projects) written at status Concept. Verified no first-class project system exists; identified `homestead.maintenance`/`homestead.goals` as only project-adjacent data. Inserted Projects at slot 5; renumbered Brain/People/Home/Knowledge/Search to 6–10. |
| Jul 4 2026 | Chapter 6 (Brain) written at status Prototype. Verified typed first-class capture system Implemented (PerchParse, lifecycle, Today integration, source preservation); search is substring-only (no semantic/vector), no AI interpretation, no capture aging, belief emission gated off. Key distinction: capture ≠ memory. |
| Jul 4 2026 | Perch v0.5 build plan created (`build_plans/perch-v0.5-build-plan.md`) — shortest trustworthy daily-use path; 6 trust risks, 4-phase build order, acceptance tests, daily-use script. |
| Jul 4 2026 | Chapter 7 (Truth Engine) written at status Prototype — constitutional law. Runtime truth logic (truth_level, confidence, thresholds, permission gate, contradiction handling) exists ONLY in `perch_beliefs.js`, belief-scoped, emission gated off. No unified Truth Engine; enforcement mostly editorial. Keystone = generalize the belief `evaluate()` gate. |
| Jul 4 2026 | Chapter 8 (Priority Engine) written at status Prototype. Identified FOUR independent scorers (`whyNowScore`, `priorityScore`, Today `_score`, PerchEvents sort) plus an orphan duplicate — not one engine. Confidence doesn't affect priority; Truth doesn't gate it; no user override; inconsistent tie-breaks. Keystone = consolidate to one truth-gated scorer. |
| Jul 4 2026 | Chapter 9 (Recommendation Engine) written at status Prototype. No standalone engine — `recommendation = recCandidates[0]` from `whyNowScore` (conflated with Priority). Real evidence-gated suggestions with a `_lpbSignal` feedback loop; never auto-executes; not Truth-gated; cross-domain synthesis is Concept. Keystone = separate from Priority, then Truth-gate. |
| Jul 4 2026 | Chapter 10 (Living World) written at status Concept. Exhaustive audit found the entire Living World is one static, decorative, `aria-hidden` SVG on Today — no world state, no data-driven rendering, no unlocks, no evolution, no shared state; `perch_world.md` is doctrine not loaded by code. Vision-to-Implementation gap documented as deliberate discipline (world must reflect stored truth; waits on belief-store stability). Keystone = finish belief store + Truth-gated emission before any world build. Migrated canonical change log from README into this file. |
