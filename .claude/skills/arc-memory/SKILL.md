---
name: arc-memory
description: |
  Memory directories system for persistent context across Claude Code sessions.
  Based on Boris Cherny's recommendations for maintaining project knowledge,
  decisions, progress, and patterns. Use when "setting up memory structure",
  "documenting decisions", "starting a new feature", "ending a session",
  "recording patterns or gotchas", or "persistent context across sessions".
metadata:
  author: ARC Labs Studio
  version: "3.0.0"
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

## Instructions

### Directory Structure

#### Project-Level Memory (Main Repo)

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

#### Feature-Level Memory (Worktrees)

```
FavRes-iOS-worktrees/
└── FVRS-123/
    └── memory/
        ├── CONTEXT.md      # What this feature is about
        ├── PROGRESS.md     # What's done, what's next
        ├── BLOCKERS.md     # Current issues and workarounds
        └── LEARNINGS.md    # Things discovered during implementation
```

### CLAUDE.md Integration

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

### Session Workflow

#### Starting a Session

1. Claude reads CLAUDE.md (which references memory/)
2. If working on feature FVRS-XXX, read `memory/features/FVRS-XXX.md`
3. Check PROGRESS.md for current state

#### During a Session

1. Make decisions -> Note them for DECISIONS.md
2. Discover patterns -> Note them for PATTERNS.md
3. Hit blockers -> Document in feature's BLOCKERS.md

#### Ending a Session

```markdown
## Session End Checklist

- [ ] Update memory/features/FVRS-XXX.md with progress
- [ ] Add any new decisions to DECISIONS.md
- [ ] Document any patterns discovered in PATTERNS.md
- [ ] Note blockers in feature memory if unresolved
- [ ] Commit memory changes: `git add memory/ && git commit -m "docs(memory): update session progress"`
```

## References

File templates are available in the `templates/` directory:

- **@templates/README.template.md** - Memory directory README
- **@templates/ARCHITECTURE.template.md** - Architecture memory template
- **@templates/DECISIONS.template.md** - ADR template
- **@templates/PATTERNS.template.md** - Patterns and gotchas template
- **@templates/DEPENDENCIES.template.md** - Dependencies memory template
- **@templates/FEATURE.template.md** - Feature-specific memory template

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

## Examples

### Setting up memory for a new project
User says: "Set up memory directories for my new app"

1. Create `memory/` directory in project root
2. Generate README.md, ARCHITECTURE.md, DECISIONS.md, PATTERNS.md, DEPENDENCIES.md from templates
3. Create `memory/features/` directory
4. Add memory references to CLAUDE.md
5. Result: Complete memory structure ready for use

### Documenting a decision mid-session
User says: "Document why we chose SwiftData over Core Data"

1. Read `memory/DECISIONS.md` to find next ADR number
2. Add ADR entry with context, decision, and consequences
3. Commit: `docs(memory): add ADR-003 SwiftData selection`
4. Result: Decision preserved for future sessions

## Related Skills

| If you need... | Use |
|----------------|-----|
| Worktrees setup | `/arc-worktrees-workflow` |
| Git workflow | `/arc-workflow` |
| Architecture patterns | `/arc-swift-architecture` |
