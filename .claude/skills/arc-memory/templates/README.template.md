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

## Session Workflow

### Starting Work
1. Check relevant feature file in `features/`
2. Review recent entries in DECISIONS.md
3. Note any blockers from previous session

### Ending Work
1. Update feature progress in `features/FVRS-XXX.md`
2. Document any decisions made
3. Note patterns or gotchas discovered
4. Commit: `git add memory/ && git commit -m "docs(memory): update session progress"`
