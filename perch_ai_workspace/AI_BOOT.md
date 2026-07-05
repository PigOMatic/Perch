# AI Boot

Read this first before working on Perch.

This file is stable context. It should change rarely.

## Perch Identity

Perch is clarity, presented beautifully.

Perch is a Life Operating System that helps a person understand life, finances, obligations, goals, opportunities, and projects at a moment's notice.

## Source of Truth

The repository is the permanent memory of Perch.

Conversation history is temporary.

No meaningful work is complete until it exists in the repository.

## Core Architecture

The Design Bible describes the destination.

Build Plans describe what to build next.

The repository documents current reality.

Application code is implementation.

## Engine Authority

The core reasoning chain is:

```text
Truth Engine
    ↓
Priority Engine
    ↓
Recommendation Engine
    ↓
Voice Engine
    ↓
Pages
```

## Engine Responsibilities

- Truth answers: What is true?
- Priority answers: What deserves attention?
- Recommendation answers: What should the user do?
- Voice answers: How should this be said?
- Pages answer: How should this be presented?

## Global Laws

- Perch never invents certainty.
- Truth outranks convenience.
- Pages present truth.
- Engines reason about truth.
- If Perch does not know, it says so.
- If two sources disagree, Perch exposes the disagreement.
- Recommendations must explain themselves.
- Every important statement should have source lineage.
- Every status label must be honest.

## Status Labels

- Concept — vision only; no meaningful implementation.
- Planning — designed but not built.
- Prototype — partial implementation exists but is incomplete, fragmented, fragile, or not fully trustworthy.
- Implemented — wired into the app and trustworthy within clearly defined limits.

## AI Roles

ChatGPT is used for:
- architecture
- planning
- strategy
- prompt optimization
- review
- repository organization

Claude is used for:
- focused repository audits
- long-form Design Bible chapter drafting
- documentation updates grounded in code

## Claude Rules

Claude should:
- read this file
- read PROJECT_STATE.md
- read only the specific previous chapter or files needed for the task
- audit only the requested area
- write repository-ready Markdown
- update indexes/changelogs only when asked
- report files changed
- report whether application code changed
- stop after the requested task

Claude should not:
- modify application code unless explicitly requested
- reread the entire repository unless necessary
- duplicate existing documentation
- invent implementation that does not exist
- leave important work only in chat
