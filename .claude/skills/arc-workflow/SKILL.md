---
name: arc-workflow
description: |
  Git workflow and development process covering Conventional Commits (feat,
  fix, docs, refactor, test, chore), branch naming with Linear integration,
  PR templates, Plan Mode for complex tasks, and Git Flow with main/develop
  branches. Use when "writing commits", "creating branches", "opening PRs",
  "planning features", or "understanding Git Flow".
user-invocable: true
metadata:
  author: ARC Labs Studio
  version: "3.0.0"
---

# ARC Labs Studio - Git Workflow & Development Process

## Instructions

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Commit Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(storage): add CloudKit provider` |
| `fix` | Bug fix | `fix(map): resolve annotation crash` |
| `docs` | Documentation | `docs(readme): update installation` |
| `style` | Formatting | `style: apply SwiftFormat rules` |
| `refactor` | Code restructure | `refactor(repository): extract protocol` |
| `perf` | Performance | `perf(search): optimize filtering` |
| `test` | Tests | `test(storage): add provider tests` |
| `chore` | Maintenance | `chore(deps): update ARCLogger` |
| `build` | Build system | `build(spm): add ARCNetworking` |
| `ci` | CI/CD | `ci(github): add test workflow` |

### Commit Message Rules

```bash
# Good
feat(storage): add SwiftData migration support
fix(map): prevent crash when selecting annotation
docs(architecture): document coordinator pattern

# Bad
feat(storage): added migration  # Past tense
fix(map): fixed a bug          # Vague
docs: updates                  # Too generic
```

**Guidelines**:
- Imperative mood: "add", "fix", "update" (not "added", "fixed")
- No capital first letter
- No period at end
- Max 50 characters subject
- Be specific

### Branch Naming

```
<type>/<issue-id>-<short-description>
```

**Examples**:
```bash
feature/ARC-123-restaurant-search
bugfix/ARC-145-map-crash
hotfix/ARC-178-auth-vulnerability
docs/update-readme
spike/swiftui-animations
release/1.2.0
```

### Branch Types

| Type | Purpose | Branch from | Merge to |
|------|---------|-------------|----------|
| `feature/` | New features | `develop` | `develop` |
| `bugfix/` | Non-critical fixes | `develop` | `develop` |
| `hotfix/` | Critical production fixes | `main` | `main` + `develop` |
| `docs/` | Documentation | `develop` | `develop` |
| `spike/` | Experiments | any | optional |
| `release/` | Release prep | `develop` | `main` + `develop` |

### Git Flow

```
main <------------- (production, tagged releases)
  ^
  | merge
  |
release/1.2.0 <- (version bump, final testing)
  ^
  | branch
  |
develop <--------- (integration branch)
  ^
  | merge (PR)
  |
feature/ARC-123-search <- (feature development)
```

### Workflow Commands

```bash
# Start new feature
git checkout develop
git pull origin develop
git checkout -b feature/ARC-123-restaurant-search

# Commit changes
git add .
git commit -m "feat(search): implement search logic"

# Push and create PR
git push -u origin feature/ARC-123-restaurant-search

# After PR merge, cleanup
git checkout develop
git pull
git branch -d feature/ARC-123-restaurant-search
```

### PR Template

```markdown
## Summary
[What this PR does]

## Related Issue
Closes: ARC-123

## Type of Change
- [ ] Feature
- [ ] Bugfix
- [ ] Hotfix
- [ ] Documentation

## Testing
- [ ] Unit tests added/updated
- [ ] All tests passing

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
```

### PR Naming

```
<Type>/<Issue-ID>: <Title>

Feature/ARC-123: Restaurant Search Implementation
Bugfix/ARC-145: Map Annotation Crash Fix
Hotfix/ARC-178: Authentication Vulnerability Patch
```

## Plan Mode

### When to Enter Plan Mode

Enter Plan Mode when:
- Feature is **complex** (touches multiple layers/files)
- Requirements are **ambiguous**
- Multiple **architectural approaches** are valid
- **Trade-offs** need evaluation
- User explicitly requests planning

### Plan Mode Process

1. **Deep Reflection** - Analyze scope, identify ambiguities
2. **Ask Clarifying Questions** (4-6 questions)
3. **Draft Step-by-Step Plan** with files/types
4. **Get Approval** before implementing
5. **Progress Updates** after each phase

## References

For complete guidelines:
- **@references/git-commits.md** - Complete commit message guide
- **@references/git-branches.md** - Branch naming and workflow
- **@references/plan-mode.md** - When and how to use Plan Mode

## Branch Protection Rules

### main Branch
- Require PR reviews (1+ approvals)
- Status checks must pass
- No force push
- No deletion

### develop Branch
- Require PR reviews
- Status checks must pass
- No force push

## Examples

### Committing a new feature
User says: "Commit my restaurant search implementation"

1. Run `git status` to see changed files
2. Stage relevant files: `git add Sources/Features/Search/`
3. Commit: `feat(search): add restaurant search with filtering`
4. Push: `git push -u origin feature/ARC-123-restaurant-search`
5. Result: Clean commit following Conventional Commits format

### Creating a PR for a bugfix
User says: "Create a PR for my map crash fix"

1. Verify branch naming: `bugfix/ARC-145-map-crash`
2. Push branch if not yet pushed
3. Create PR with template: `Bugfix/ARC-145: Map Annotation Crash Fix`
4. Link to Linear issue in PR body
5. Result: PR ready for review with proper template

## Related Skills

| If you need...              | Use                       |
|-----------------------------|---------------------------|
| Code quality standards      | `/arc-quality-standards`  |
| Architecture decisions      | `/arc-swift-architecture` |
| Testing patterns            | `/arc-tdd-patterns`       |
| Project setup               | `/arc-project-setup`      |
