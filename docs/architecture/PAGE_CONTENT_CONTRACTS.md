# Page Content Contracts

**Status:** Product/layout prerequisite  
**Created:** July 5, 2026

---

## Why this exists

It is hard to judge a layout if we have not defined what should actually be visible on each page.

Before continuing visual design, Perch needs page content contracts.

These contracts define:

```text
what belongs on a page
what should be visible first
what should be quiet
what should be hidden or tucked away
what each page is responsible for
```

This is not final copy or final styling.

It is the content anatomy that layouts must serve.

---

## Global rule

Every page should answer one main question.

Every visible section should have a role.

If a page shows everything equally, the page failed.

---

# Today

## Main question

```text
Where am I today, and what matters first?
```

## Must show first

```text
Orientation statement
Primary marker / first thing to notice
```

## Should support the first thing

```text
Money terrain
Schedule / work terrain
Brain notes / captures
People/family context when relevant
Trust/source note
```

## Should be quiet or tucked away

```text
Debug details
Legacy links
Raw storage source details
Everything that can wait
```

## Today should not be

```text
A full task manager
A full calendar
A full finance dashboard
A settings page
A card grid of equal importance
```

---

# Week

## Main question

```text
What is coming up, and where are the pressure points?
```

## Must show first

```text
Week orientation
Key days / pressure days
```

## Should support the first thing

```text
Work shifts
Bills due
Family commitments
Known deadlines
Things that can be moved
```

## Should be quiet or tucked away

```text
Full raw calendar
Old completed items
Low-priority notes
```

## Week should not be

```text
A normal calendar clone
A giant checklist
A noisy planner
```

---

# Brain / Capture

## Main question

```text
What did I tell Perch, and what needs to happen to it?
```

## Must show first

```text
Open captures needing classification
Questions Perch has for the user
```

## Should support the first thing

```text
Reminders
Waiting items
Ideas
Decisions
Recently archived items
```

## Should be quiet or tucked away

```text
Old resolved captures
System parsing details
Raw localStorage records
```

## Brain should not be

```text
A dumping ground with no triage
A plain notes app
A database browser as the main experience
```

---

# Life / Map

## Main question

```text
What parts of my life are active, quiet, stuck, or changing?
```

## Must show first

```text
Life orientation map
Active zones
Stuck/waiting zones
```

## Should support the first thing

```text
Money
Work
Family
Property
Health
Projects
Travel
Longer-term goals
```

## Should be quiet or tucked away

```text
Deep history
Resolved areas
Raw memory records
```

## Life / Map should not be

```text
A settings dashboard
A category list with no meaning
A generic productivity matrix
```

---

# Knowledge

## Main question

```text
What does Perch know, and how confident is it?
```

## Must show first

```text
Important remembered facts
Recently changed facts
Facts needing confirmation
```

## Should support the first thing

```text
Source labels
Confidence status
Change history
User corrections
```

## Should be quiet or tucked away

```text
Raw storage dumps
Developer-only debug data
Low-confidence details unless relevant
```

## Knowledge should not be

```text
A wall of memory
A hidden black box
A technical database view only
```

---

# Settings

## Main question

```text
How do I control Perch safely?
```

## Must show first

```text
User basics
Privacy/storage controls
Notification preferences
Personalization controls
```

## Should support the first thing

```text
Edit people
Edit bills
Edit work schedule
Clear demo/sample data
Source and trust settings
Object/theme customization later
```

## Should be quiet or tucked away

```text
Advanced debug
Raw key management
Dangerous reset actions
```

## Settings should not be

```text
The emotional center of the app
The place users must live every day
A confusing technical control panel
```

---

## Layout implication

The layout lab should not just compare shapes.

It should compare whether each shape can carry the correct content contract.

For Today, the current layout question is not simply:

```text
Which surface looks best?
```

It is:

```text
Which surface best shows orientation, primary marker, terrain, margin notes, trust/source, next step, and what can wait?
```

---

## Next build target

Update the layout lab so each layout is judged against the Today content contract before continuing visual polish.
