# Perch UI State Model

**Status:** Engineering foundation  
**Created:** July 5, 2026  
**Source:** Design Bible v1.0, Source Candidate Audit, UX Rebuild Plan

---

## 1. Purpose

This document defines how Perch screens should think about UI state before the HTML rebuild begins.

The goal is to prevent every page from inventing its own state rules. Perch should have one shared way to describe what the user sees, why it is shown, whether it is trustworthy, and what actions are available.

---

## 2. Core rule

> UI state is not decoration. UI state is Perch's visible interpretation of stored facts, derived facts, attention priority, and user permission.

Every visible item should be traceable to:

1. Source data
2. Computed state
3. Trust level
4. Priority reason
5. Allowed user action

---

## 3. Global UI modes

Perch uses two primary modes from the Design Bible.

| Mode | Purpose | User feeling |
|---|---|---|
| Read Mode | Calm default view showing only what matters now | "I understand what is going on." |
| Explore Mode | Deeper view for inspection, editing, filtering, and explanation | "I can dig in and verify this." |

Every major page should support this distinction, even if early versions implement Explore Mode lightly.

---

## 4. Global app state

The app shell should provide shared state to all pages.

```js
AppState = {
  today: Date,
  activeRoute: string,
  activeMode: 'read' | 'explore',
  userContext: UserContext,
  dataSnapshot: DataSnapshot,
  attentionQueue: AttentionItem[],
  trustNotices: TrustNotice[],
  pendingActions: PendingAction[]
}
```

This does not require a framework immediately. It defines the conceptual contract the rebuilt UI should follow.

---

## 5. Page state contract

Every page should be describable with this shape:

```js
PageState = {
  pageId: string,
  chapterId: string,
  primaryQuestion: string,
  mode: 'read' | 'explore',
  headline: UIStatement,
  sections: UISection[],
  actions: UIAction[],
  emptyState: EmptyState | null,
  trustNotices: TrustNotice[]
}
```

---

## 6. UI statement model

Any meaningful sentence or displayed number should use a statement model.

```js
UIStatement = {
  id: string,
  text: string,
  classification: 'fact' | 'derived_fact' | 'interpretation' | 'recommendation' | 'prediction',
  confidence: number,
  sourceIds: string[],
  generatedBy: string | null,
  stale: boolean,
  explanation: string | null
}
```

### Display rules

| Classification | Display rule |
|---|---|
| Fact | May be stated plainly if sourced. |
| Derived Fact | May be stated plainly if arithmetic is explainable. |
| Interpretation | Must be explainable. |
| Recommendation | Must expose why and never auto-act. |
| Prediction | Must show assumptions and uncertainty. |

---

## 7. Attention item model

Anything that rises to Today or a page headline should be represented as an attention item.

```js
AttentionItem = {
  id: string,
  domain: string,
  chapterId: string,
  title: string,
  summary: string,
  priorityScore: number,
  priorityReasons: string[],
  truthStatus: 'allowed' | 'limited' | 'blocked',
  sourceIds: string[],
  actions: UIAction[]
}
```

Priority ranks attention. It does not invent facts.

---

## 8. UI section model

```js
UISection = {
  id: string,
  title: string,
  purpose: string,
  items: Array<UIStatement | AttentionItem | UIRecord>,
  collapsedByDefault: boolean,
  emptyState: EmptyState | null
}
```

Sections should be organized around what the user needs to know, not database categories.

---

## 9. UI action model

```js
UIAction = {
  id: string,
  label: string,
  type: 'view' | 'edit' | 'complete' | 'dismiss' | 'archive' | 'create' | 'explain',
  targetId: string,
  allowed: boolean,
  reasonIfBlocked: string | null,
  consequence: string
}
```

No action should happen without a clear consequence. Recommendations may suggest actions, but user action remains required.

---

## 10. Trust notice model

```js
TrustNotice = {
  id: string,
  severity: 'info' | 'warning' | 'blocked',
  message: string,
  affectedStatementIds: string[],
  sourceIds: string[],
  recoveryAction: UIAction | null
}
```

Trust notices are used when data is stale, missing, conflicting, or manually entered.

---

## 11. Empty states

Empty states must teach the user what belongs on the page.

```js
EmptyState = {
  message: string,
  explanation: string,
  suggestedActions: UIAction[]
}
```

Bad empty state:

```text
Nothing here.
```

Good empty state:

```text
No bills are due before payday. Add a bill if Perch is missing one.
```

---

## 12. Page-specific state notes

### Today

Today should show:

- One calm headline
- One primary attention item
- Money and obligations if relevant
- Brain/capture reminders if relevant
- A way to explain why the user is clear or not clear

### Brain / Capture

Capture state must distinguish:

- Raw capture
- Parsed capture
- Saved record
- Archived/completed capture
- Question needing answer

### Money

Money state must distinguish:

- Manual balance
- Derived bills-before-payday total
- Safe/unsafe interpretation
- Recommendation to move money
- Unknown/untracked financial data

### Calendar / Obligations

Calendar state must distinguish:

- Date fact
- Recurrence rule
- Due item
- Work shift
- Obligation with consequence

### Knowledge / Search

Knowledge state must distinguish:

- Stored fact
- Capture
- Inferred belief
- Search result
- Low-confidence item

---

## 13. Rebuild implications

The rebuilt UI should avoid trapping business logic inside HTML pages.

Recommended split:

```text
core data helpers       → perch_core.js or future modules
engine calculations     → perch_engine.js or future modules
page state builders     → new page/state layer
view rendering          → rebuilt UI components/pages
```

---

## 14. Acceptance criteria

The UI state model is respected when:

- [ ] Every page can describe its state with page ID, mode, headline, sections, actions, and trust notices.
- [ ] Facts and recommendations are visibly different.
- [ ] A surfaced item can explain why it appeared.
- [ ] Empty states teach instead of just saying nothing exists.
- [ ] UI pages do not silently invent missing data.
- [ ] Future code can migrate away from monolithic HTML without losing behavior.
