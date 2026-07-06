# Money Freedom Choice

**Status:** Product pattern proposal  
**Created:** July 6, 2026

---

## Origin

User idea from Maura:

```text
You will have $800 left after bills.
Want to transfer to savings/settings, or be irresponsible?
```

This is a strong Perch idea because it adds personality while still helping the user make a safe decision.

---

## Product framing

The feature should not encourage harmful financial behavior.

The safe product framing is:

```text
Freedom choice
```

User-facing language can still be playful:

```text
Be responsible
Be a little irresponsible
Show me fun options
```

But the system logic should be safety-first.

---

## When this appears

This should only appear after Perch has accounted for:

```text
bills before payday
minimum required cushion
known scheduled payments
trust/source certainty
```

If money is tight or uncertain, Perch should not offer playful spend prompts.

---

## Example UI moment

```text
You should have about $800 left after bills.

Responsible move:
Transfer $500 to savings.

Fun move:
Keep $150 for something enjoyable.

Irresponsible-ish:
Show me ways to spend $200 without wrecking the week.
```

---

## Action types

### Responsible action

Examples:

```text
Transfer to savings
Pay extra on debt
Hold cushion
Set aside for mortgage
Move to vacation fund
```

### Fun action

Examples:

```text
Plan a family outing
Buy something useful but enjoyable
Date night
Kids activity
Small project purchase
```

### Irresponsible-ish action

Examples:

```text
Show me fun splurges under $100
Give me three ridiculous but safe ideas
Pick a treat that will not hurt the week
```

---

## Guardrails

Do not suggest spending money that is needed for bills, food, housing, safety, transportation, or debt minimums.

Do not suggest gambling, high-interest debt, risky financing, or purchases that would cause overdraft.

Do not use shame language.

Do not make the responsible option boring and the spending option emotionally dominant.

---

## Perch personality

This feature should feel like:

```text
Perch knows I am human.
Perch helps me be responsible without being joyless.
Perch lets me choose fun intentionally.
```

---

## Layout role

This belongs in Today under:

```text
Money terrain
Next step
What can wait
```

It should not dominate the whole page unless money is the primary marker for the day.

---

## Future action integration

The transfer button should be treated as an intent first.

Actual transfer execution requires a safe integration boundary, confirmation, and financial account permissions.

Until then, the UI can say:

```text
Mark this as the plan
Copy transfer note
Open bank manually
```
