# Perch Data Model

**Status:** Engineering foundation  
**Created:** July 5, 2026  
**Source:** Design Bible v1.0, Source Manifest, UI State Model, Engine Interfaces

---

## 1. Purpose

This document defines the canonical data concepts Perch should preserve while rebuilding the UI and refactoring the restored source candidate.

It is not a database schema yet. It is the product data contract that future code should honor.

---

## 2. Core rule

> Perch data must remain explainable, source-aware, and user-correctable.

Every important record should eventually answer:

- What is it?
- Where did it come from?
- Who or what owns it?
- When was it last updated?
- How confident is Perch?
- What page or engine uses it?

---

## 3. Persistence strategy

The restored source candidate uses browser-local behavior and localStorage-style persistence.

For v0.5/v0.6, preserve local-first behavior unless intentionally changed.

Canonical persistence layers:

| Layer | Meaning |
|---|---|
| Local record | User-entered or locally stored data. |
| Derived record | Computed from one or more local records. |
| System default | Starter/default data used for demo or onboarding. |
| Future integration record | External data imported later with provenance. |

---

## 4. Base record

Every durable object should eventually inherit these fields conceptually.

```js
BaseRecord = {
  id: string,
  type: string,
  title: string,
  createdAt: string,
  updatedAt: string,
  sourceIds: string[],
  confidence: number,
  status: string,
  archived: boolean,
  deleted: boolean
}
```

---

## 5. Source record

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

Source records are the basis for Truth Engine decisions.

---

## 6. Person

Owned by Chapter 15 — People.

```js
PersonRecord = {
  ...BaseRecord,
  type: 'person',
  name: string,
  relationship: string,
  roles: string[],
  importantDates: ImportantDate[],
  contactMethods: ContactMethod[],
  linkedRecordIds: string[],
  notes: string[]
}
```

People are not CRM entries. They are relationship anchors.

---

## 7. Capture / Brain item

Owned by Chapter 6 — Brain.

```js
CaptureRecord = {
  ...BaseRecord,
  type: 'capture',
  rawText: string,
  parsedType: 'reminder' | 'waiting' | 'question' | 'note' | 'task' | 'unknown',
  parsedFields: object,
  lifecycle: 'active' | 'done' | 'archived' | 'deleted',
  promotedRecordId: string | null
}
```

Capture is an inbox, not permanent truth until promoted or confirmed.

---

## 8. Event / obligation

Owned by Chapter 3 — Calendar & Obligations.

```js
EventRecord = {
  ...BaseRecord,
  type: 'event' | 'obligation' | 'work_shift' | 'bill_due' | 'maintenance_due',
  startDate: string,
  endDate: string | null,
  recurrenceRule: string | null,
  consequence: string | null,
  locationId: string | null,
  personIds: string[],
  completed: boolean
}
```

An obligation is not just a calendar event. It has consequence.

---

## 9. Money records

Owned by Chapter 2 — Money.

```js
FinancialSnapshot = {
  ...BaseRecord,
  type: 'financial_snapshot',
  balance: number | null,
  payday: string | null,
  billsBeforePayday: number | null,
  cushion: number | null,
  sourceQuality: 'manual' | 'derived' | 'future_integration',
  notes: string[]
}
```

```js
BillRecord = {
  ...BaseRecord,
  type: 'bill',
  amount: number,
  dueDate: string,
  recurrenceRule: string | null,
  paidStatus: 'unpaid' | 'paid' | 'skipped' | 'unknown',
  autopay: boolean,
  accountHint: string | null
}
```

Money records must preserve source lineage and avoid unsupported certainty.

---

## 10. Goal

Owned by Chapter 4 — Goals.

```js
GoalRecord = {
  ...BaseRecord,
  type: 'goal',
  desiredOutcome: string,
  targetAmount: number | null,
  currentAmount: number | null,
  targetDate: string | null,
  status: 'active' | 'paused' | 'completed' | 'archived',
  linkedProjectIds: string[],
  linkedMoneyRecordIds: string[]
}
```

A goal is a direction. A project is the execution sequence.

---

## 11. Project / task

Owned by Chapter 5 — Projects.

```js
ProjectRecord = {
  ...BaseRecord,
  type: 'project',
  outcome: string,
  status: 'not_started' | 'active' | 'blocked' | 'done' | 'archived',
  taskIds: string[],
  linkedGoalIds: string[],
  linkedLocationIds: string[],
  linkedPersonIds: string[]
}
```

```js
TaskRecord = {
  ...BaseRecord,
  type: 'task',
  projectId: string | null,
  dueDate: string | null,
  status: 'todo' | 'doing' | 'done' | 'blocked' | 'archived',
  recurrenceRule: string | null
}
```

Tasks should eventually unify chores, maintenance actions, and project steps.

---

## 12. Home / property

Owned by Chapter 14 and Chapter 16.

```js
LocationRecord = {
  ...BaseRecord,
  type: 'property' | 'building' | 'room' | 'land_area' | 'system' | 'equipment',
  parentLocationId: string | null,
  address: string | null,
  notes: string[]
}
```

```js
MaintenanceRecord = {
  ...BaseRecord,
  type: 'maintenance',
  locationId: string,
  urgency: 'low' | 'medium' | 'high' | 'unknown',
  dueDate: string | null,
  recurrenceRule: string | null,
  estimatedCost: number | null,
  taskId: string | null
}
```

Home is the physical-world model. It should connect to tasks, money, and obligations.

---

## 13. Knowledge / belief

Owned by Chapter 12, Chapter 17, and Truth Engine.

```js
KnowledgeRecord = {
  ...BaseRecord,
  type: 'knowledge',
  statement: string,
  classification: 'fact' | 'derived_fact' | 'interpretation' | 'preference' | 'belief',
  subjectIds: string[],
  evidenceSourceIds: string[],
  confidence: number,
  userConfirmed: boolean
}
```

Knowledge must be inspectable and correctable.

---

## 14. Preference

```js
PreferenceRecord = {
  ...BaseRecord,
  type: 'preference',
  key: string,
  value: unknown,
  scope: 'global' | 'domain' | 'person' | 'page',
  sourceIds: string[],
  userEditable: boolean
}
```

Preferences affect Voice, Recommendation suppression, and page behavior.

---

## 15. Interaction history

```js
InteractionHistory = {
  id: string,
  eventType: 'viewed' | 'dismissed' | 'accepted' | 'declined' | 'completed' | 'corrected',
  targetId: string,
  timestamp: string,
  metadata: object
}
```

This is how Perch learns without pretending to know more than it does.

---

## 16. Migration from restored source

The restored source candidate should be mapped into these records gradually.

Do not rewrite all storage at once.

Recommended order:

1. Identify current localStorage keys.
2. Document their shape.
3. Add adapter functions.
4. Build new UI against adapters.
5. Migrate only when behavior is stable.

---

## 17. Non-goals

This data model does not yet define:

- Cloud database tables
- Authentication
- Multi-user sync
- Live banking integrations
- External calendar integrations
- Vector search schema

Those are future architecture decisions.

---

## 18. Acceptance criteria

The data model is useful when:

- [ ] Each major user-facing object maps to a Design Bible chapter.
- [ ] Source lineage can be attached to important claims.
- [ ] LocalStorage data can be adapted without immediate destructive migration.
- [ ] Money, obligations, captures, and goals can be represented without UI-specific hacks.
- [ ] Future pages can share records instead of duplicating data.
