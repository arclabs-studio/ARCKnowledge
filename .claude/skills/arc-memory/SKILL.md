---
name: arc-memory
description: |
  Memory directories system for persistent context across Claude Code sessions.
  Based on Boris Cherny's recommendations for maintaining project knowledge,
  decisions, progress, and patterns that Claude can reference automatically.

  **INVOKE THIS SKILL** when:
  - Starting a new project and need to set up memory structure
  - Beginning work on a feature and need to understand context
  - Ending a session and need to document progress
  - Making architectural decisions that should be remembered
  - Encountering patterns or gotchas worth documenting
---

# ARC Labs Studio - Memory Directories System

## Overview

The `/memory` directory system provides persistent context across Claude Code sessions. Instead of repeating context in every conversation, document it in markdown files that Claude reads automatically via CLAUDE.md references.

### Why Memory Directories?

| Problem | Solution |
|---------|----------|
| Repeating context each session | Write once, reference always |
| Forgetting decisions made | Document rationale in DECISIONS.md |
| Losing track of progress | Update PROGRESS.md each session |
| Repeating same mistakes | Document gotchas in PATTERNS.md |
| Context window limits | Summarize key info, reference details |

## Directory Structure

### Project-Level Memory (Main Repo)

```
FavRes-iOS/
├── memory/
│   ├── README.md           # What this directory is for
│   ├── ARCHITECTURE.md     # High-level architecture decisions
│   ├── DECISIONS.md        # ADRs (Architecture Decision Records)
│   ├── PATTERNS.md         # Project-specific patterns and gotchas
│   ├── DEPENDENCIES.md     # Why we chose each dependency
│   └── features/           # Feature-specific memory
│       ├── FVRS-66-add-restaurant.md
│       └── FVRS-67-search.md
└── CLAUDE.md               # References memory/ for context
```

### Feature-Level Memory (Worktrees)

```
FavRes-iOS-worktrees/
└── FVRS-123/
    └── memory/
        ├── CONTEXT.md      # What this feature is about
        ├── PROGRESS.md     # What's done, what's next
        ├── BLOCKERS.md     # Current issues and workarounds
        └── LEARNINGS.md    # Things discovered during implementation
```

## File Templates

### memory/README.md

```markdown
# Memory Directory

This directory contains persistent context for Claude Code sessions.
Files here are referenced in CLAUDE.md and provide project knowledge
that doesn't need to be repeated each conversation.

## Files

| File | Purpose | Update Frequency |
|------|---------|------------------|
| ARCHITECTURE.md | System design decisions | When architecture changes |
| DECISIONS.md | ADRs with rationale | Each significant decision |
| PATTERNS.md | Code patterns & gotchas | When patterns emerge |
| DEPENDENCIES.md | Why we use each dep | When deps change |
| features/*.md | Feature-specific context | Per feature lifecycle |

## Usage

Claude Code reads these files when referenced in CLAUDE.md.
Keep files concise - summarize, don't duplicate documentation.
```

### memory/ARCHITECTURE.md

```markdown
# Architecture Memory

Last updated: YYYY-MM-DD

## System Overview

[Brief description of the system architecture]

## Key Components

### Component Name
- **Purpose**: What it does
- **Location**: Where to find it
- **Dependencies**: What it needs
- **Gotchas**: Common issues

## Data Flow

[Describe how data moves through the system]

## Integration Points

[External services, APIs, packages]
```

### memory/DECISIONS.md

```markdown
# Architecture Decision Records

## ADR-001: [Decision Title]

**Date**: YYYY-MM-DD
**Status**: Accepted | Superseded | Deprecated
**Ticket**: FVRS-XXX

### Context
What is the issue that we're seeing that is motivating this decision?

### Decision
What is the change that we're proposing and/or doing?

### Consequences
What becomes easier or more difficult because of this change?

---

## ADR-002: [Next Decision]
...
```

### memory/PATTERNS.md

```markdown
# Project Patterns & Gotchas

## Patterns We Follow

### Pattern Name
```swift
// Example code showing the pattern
```
**When to use**: [Situation]
**Why**: [Rationale]

## Gotchas & Pitfalls

### Gotcha: [Issue Name]
**Symptom**: What you see when this happens
**Cause**: Why it happens
**Solution**: How to fix/avoid it
**Ticket**: FVRS-XXX (if applicable)

## Anti-Patterns to Avoid

### Don't Do This
```swift
// Bad example
```
**Why it's bad**: [Explanation]
**Do this instead**: [Better approach]
```

### memory/DEPENDENCIES.md

```markdown
# Dependencies Memory

## ARC Packages

| Package | Version | Purpose | Notes |
|---------|---------|---------|-------|
| ARCDesignSystem | 2.3.1 | Design tokens, typography | Use .arcSpacing*, .arcCorner* |
| ARCUIComponents | 1.6.0 | Reusable UI components | Check before building custom |
| ARCNavigation | 1.2.0 | Type-safe routing | Router<AppRoute> pattern |

## Third-Party

| Package | Version | Purpose | Why This One |
|---------|---------|---------|--------------|
| [Name] | X.Y.Z | [Purpose] | [Why we chose it] |

## Dependency Decisions

### Why ARCDesignSystem over custom tokens?
[Explanation]

### Why not [Alternative]?
[Explanation]
```

### memory/features/FVRS-XXX.md (Feature Template)

```markdown
# FVRS-XXX: [Feature Title]

**Status**: In Progress | Completed | On Hold
**Branch**: feature/FVRS-XXX-description
**Started**: YYYY-MM-DD
**Completed**: YYYY-MM-DD (if done)

## Overview

[What this feature does and why]

## Scope

### In Scope
- [ ] Task 1
- [ ] Task 2

### Out of Scope
- Item explicitly not included

## Technical Approach

[How we're implementing this]

## Key Decisions

| Decision | Rationale | Date |
|----------|-----------|------|
| Used X instead of Y | Because... | YYYY-MM-DD |

## Progress Log

### YYYY-MM-DD
- Completed: [What was done]
- Next: [What's planned]
- Blockers: [If any]

## Learnings

[Things discovered that might help future features]

## Related

- Ticket: [Linear link]
- PR: [GitHub link]
- Related features: FVRS-YYY
```

## CLAUDE.md Integration

Add to your project's CLAUDE.md:

```markdown
## Project Memory

For persistent context across sessions, see the `/memory` directory:

- **Architecture**: `memory/ARCHITECTURE.md` - System design and components
- **Decisions**: `memory/DECISIONS.md` - ADRs with rationale
- **Patterns**: `memory/PATTERNS.md` - Code patterns and gotchas
- **Dependencies**: `memory/DEPENDENCIES.md` - Why we use each package
- **Features**: `memory/features/` - Feature-specific context

When starting a new feature, check `memory/features/` for related context.
When making decisions, document in `memory/DECISIONS.md`.
```

## Session Workflow

### Starting a Session

1. Claude reads CLAUDE.md (which references memory/)
2. If working on feature FVRS-XXX, read `memory/features/FVRS-XXX.md`
3. Check PROGRESS.md for current state

### During a Session

1. Make decisions → Note them for DECISIONS.md
2. Discover patterns → Note them for PATTERNS.md
3. Hit blockers → Document in feature's BLOCKERS.md

### Ending a Session

```markdown
## Session End Checklist

- [ ] Update memory/features/FVRS-XXX.md with progress
- [ ] Add any new decisions to DECISIONS.md
- [ ] Document any patterns discovered in PATTERNS.md
- [ ] Note blockers in feature memory if unresolved
- [ ] Commit memory changes: `git add memory/ && git commit -m "docs(memory): update session progress"`
```

## Memory Maintenance

### Keep Files Concise

Memory files should be **summaries**, not documentation:
- Link to detailed docs instead of duplicating
- Use tables for quick reference
- Remove outdated information

### Regular Cleanup

Monthly or per-release:
- Archive completed feature memories
- Update ARCHITECTURE.md if system evolved
- Review DECISIONS.md for superseded entries
- Clean PATTERNS.md of obsolete gotchas

### Worktree Memory

When using worktrees:
1. Main repo memory = shared project knowledge
2. Worktree memory = feature-specific context
3. After PR merge, move relevant learnings to main memory

## Related Skills

| If you need... | Use |
|----------------|-----|
| Worktrees setup | `/arc-worktrees-workflow` |
| Git workflow | `/arc-workflow` |
| Architecture patterns | `/arc-swift-architecture` |
