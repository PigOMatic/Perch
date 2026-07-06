# Today First-Second Walkthrough

**Status:** Experience target  
**Created:** July 5, 2026

---

## Why this exists

If the Today page does not feel right in the first second, the layout is not working.

The user should not have to decode a dashboard.

The first impression should be:

```text
I opened a personal page.
It knows where I am.
It is not yelling at me.
It has one thing for me to notice first.
```

---

## First 1 second

The eye should land on one large sentence.

The page should feel calm, personal, and already organized.

The user should understand:

```text
Perch is orienting me, not dumping data on me.
```

Do not show first:

```text
Navigation
Debug labels
Raw cards
Legacy copy
System scaffolding
```

---

## First 5 seconds

The user should know the main state of the day.

Example:

```text
I am mostly okay, but money needs the first look.
```

The user should see one primary marker and enough supporting context to believe it.

---

## First 15 seconds

The page should reveal the supporting terrain:

```text
Money terrain
Schedule terrain
Brain notes
People/family context
```

These should support the primary marker, not compete with it.

---

## First 60 seconds

The user should be able to answer:

```text
Why does Perch think this?
What can wait?
What is uncertain?
What is my next small move?
```

---

## Fake data requirement

Design should be judged with realistic fake data, not empty states.

Empty states hide layout problems.

The current story demo uses fake-but-real-feeling data so the layout can be judged honestly.

---

## Current demo

Open:

```text
today_story_demo.html
```

If GitHub Pages is enabled:

```text
https://pigomatic.github.io/Perch/today_story_demo.html
```

---

## Evaluation question

Do not ask first:

```text
Is it pretty?
```

Ask first:

```text
Do I feel oriented in one second?
Do I know what matters first in five seconds?
Do I trust why Perch thinks that within a minute?
```
