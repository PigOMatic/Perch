# Perch Engine Interfaces

**Status:** Engineering foundation  
**Created:** July 5, 2026  
**Source:** Design Bible v1.0, Source Candidate Audit, UI State Model

---

## 1. Purpose

This document defines the boundary between Perch's core engines before major refactoring or UI rebuild work begins.

The restored source candidate contains useful engine-like logic, especially inside `perch_engine.js`, but the Design Bible requires clearer separation between Truth, Priority, Recommendation, and Voice.

---

## 2. Constitutional boundary

Perch's engine triad must never blur:

```text
Truth answers: What is true?
Priority answers: What deserves attention?
Recommendation answers: What could the user do?
Voice answers: How should Perch say it?
```

No engine may do another engine's job silently.

---

## 3. Shared input model

All engines should receive a shared context object.

```js
EngineContext = {
  today: Date,
  user: UserContext,
  data: DataSnapshot,
  sources: SourceRecord[],
  captures: CaptureRecord[],
  events: EventRecord[],
  finances: FinanceSnapshot,
  goals: GoalRecord[],
  preferences: PreferenceRecord[],
  history: InteractionHistory
}
```

Engines may ignore fields they do not need, but they should not reach into the DOM to discover state.

---

## 4. Source record contract

Every claim-making engine depends on source records.

```js
SourceRecord = {
  id: string,
  type: 'manual_entry' | 'stored_record' | 'derived' | 'system_default' | 'future_integration',
  label: string,
  value: unknown,
  timestamp: string,
  confidence: number,
  stale: boolean,
  lineage: string[]
}
```

If a source cannot be named, the engine should not produce a high-trust statement from it.

---

## 5. Truth Engine interface

### Question

```text
Is Perch allowed to say this?
```

### Input

```js
TruthInput = {
  claim: string,
  classification: 'fact' | 'derived_fact' | 'interpretation' | 'recommendation' | 'prediction',
  sourceIds: string[],
  assumptions: string[],
  context: EngineContext
}
```

### Output

```js
TruthResult = {
  allowed: boolean,
  truthStatus: 'allowed' | 'limited' | 'blocked',
  confidence: number,
  requiredLabel: string | null,
  explanation: string,
  sourceIds: string[],
  warnings: string[]
}
```

### Rules

- Facts require a source.
- Derived facts require explainable arithmetic or transformation.
- Interpretations require visible reasoning.
- Recommendations require source and why.
- Predictions require assumptions and uncertainty.
- Blocked claims must not be shown as normal copy.

---

## 6. Priority Engine interface

### Question

```text
What deserves attention right now?
```

### Input

```js
PriorityInput = {
  candidates: AttentionCandidate[],
  context: EngineContext
}
```

```js
AttentionCandidate = {
  id: string,
  domain: string,
  title: string,
  summary: string,
  dueDate: string | null,
  sourceIds: string[],
  urgencySignals: string[],
  consequenceSignals: string[],
  userPreferenceSignals: string[]
}
```

### Output

```js
PriorityResult = {
  ordered: PriorityItem[],
  top: PriorityItem | null,
  explanation: string
}
```

```js
PriorityItem = {
  candidateId: string,
  score: number,
  reasons: string[],
  truthStatus: 'allowed' | 'limited' | 'blocked'
}
```

### Rules

- Priority may rank only candidates that already exist.
- Priority must not create new claims.
- Priority should be deterministic.
- Priority must be gated by Truth before display.
- Priority should explain why-now, not just importance.

---

## 7. Recommendation Engine interface

### Question

```text
Given what is true and what matters, what could the user do?
```

### Input

```js
RecommendationInput = {
  priorityItems: PriorityItem[],
  context: EngineContext
}
```

### Output

```js
RecommendationResult = {
  recommendations: Recommendation[],
  suppressed: SuppressedRecommendation[]
}
```

```js
Recommendation = {
  id: string,
  title: string,
  body: string,
  actionLabel: string | null,
  sourceIds: string[],
  reasoning: string[],
  confidence: number,
  riskLevel: 'low' | 'medium' | 'high',
  userActionRequired: true
}
```

### Rules

- Recommendation never auto-acts.
- Recommendation must expose reasoning.
- Recommendation must be suppressible by user feedback.
- Recommendation must not use absent data.
- Recommendation must remain separate from Priority.

---

## 8. Voice Engine interface

### Question

```text
How should Perch say this?
```

### Input

```js
VoiceInput = {
  statement: UIStatement,
  audienceContext: UserContext,
  toneTarget: 'calm' | 'clear' | 'urgent' | 'reassuring' | 'neutral',
  context: EngineContext
}
```

### Output

```js
VoiceResult = {
  text: string,
  tone: string,
  avoidedPhrases: string[],
  confidenceLabel: string | null
}
```

### Rules

- Voice may soften wording but not certainty.
- Voice may not hide uncertainty.
- Voice may not upgrade interpretation into fact.
- Voice should be calm and human-readable.
- Voice should preserve source/trust labels when required.

---

## 9. Brief Builder interface

The morning/daily brief is not itself an engine. It is an orchestrator.

```js
BriefBuilderInput = {
  context: EngineContext,
  truthEngine: TruthEngine,
  priorityEngine: PriorityEngine,
  recommendationEngine: RecommendationEngine,
  voiceEngine: VoiceEngine
}
```

```js
BriefBuilderResult = {
  opening: VoiceResult,
  headline: UIStatement,
  topAttentionItem: PriorityItem | null,
  recommendation: Recommendation | null,
  sections: UISection[],
  trustNotices: TrustNotice[]
}
```

The brief builder may assemble, but it should not silently replace the engines.

---

## 10. Migration from restored source

### Current likely source

| Restored logic | Future interface |
|---|---|
| `whyNowScore` | Priority Engine |
| `recCandidates` / top candidate | Recommendation Engine after separation |
| `buildMorningBrief` | Brief Builder |
| opening/tone functions | Voice Engine |
| belief/confidence checks if present | Truth Engine |

### Migration rule

Do not rewrite all engine logic at once. First wrap existing behavior behind interfaces, then refactor internals.

---

## 11. Non-goals

Do not:

- Add AI cloud calls.
- Add external integrations.
- Add live banking.
- Build autonomous actions.
- Replace all restored logic before tests/fixtures exist.

---

## 12. Acceptance criteria

Engine separation is successful when:

- [ ] Truth can block or label a claim before UI display.
- [ ] Priority can rank candidates without creating recommendations.
- [ ] Recommendation can propose actions without being identical to the top priority item.
- [ ] Voice can phrase output without changing certainty.
- [ ] The daily brief is an orchestrator, not a hidden mega-engine.
- [ ] Existing useful logic from `perch_engine.js` is preserved behind cleaner boundaries.
