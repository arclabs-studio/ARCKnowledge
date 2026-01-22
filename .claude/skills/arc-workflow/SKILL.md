---
name: arc-workflow
description: |
  ARC Labs Studio Git workflow and development process. Covers Conventional Commits
  specification (feat, fix, docs, refactor, test, chore), Git branch naming with
  Linear integration (feature/, bugfix/, hotfix/), branch protection rules, PR
  templates, Plan Mode for complex tasks, Git Flow with main/develop branches,
  release process, and commit message templates.

  **INVOKE THIS SKILL** when:
  - Writing commit messages (Conventional Commits format)
  - Creating branches with proper naming
  - Opening Pull Requests with ARC Labs template
  - Planning complex features with Plan Mode
  - Understanding Git Flow (main/develop branches)
  - Setting up branch protection rules
---

# ARC Labs Studio - Git Workflow & Development Process

## When to Use This Skill

Use this skill when:
- **Writing commit messages** following Conventional Commits
- **Creating branches** with proper naming
- **Opening Pull Requests** with templates
- **Planning complex features** with Plan Mode
- **Understanding Git Flow** (main, develop, feature branches)
- **Setting up branch protection** rules
- **Creating releases** with proper tagging

## Quick Reference

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
# ✅ Good
feat(storage): add SwiftData migration support
fix(map): prevent crash when selecting annotation
docs(architecture): document coordinator pattern

# ❌ Bad
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
main ←────────── (production, tagged releases)
  ↑
  │ merge
  │
release/1.2.0 ← (version bump, final testing)
  ↑
  │ branch
  │
develop ←────── (integration branch)
  ↑
  │ merge (PR)
  │
feature/ARC-123-search ← (feature development)
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

### Hotfix Workflow

```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/ARC-178-auth-vulnerability

# Fix and commit
git commit -m "hotfix(auth): patch security vulnerability"

# Merge to main AND develop
# Create PR to main first, then PR to develop
# Tag main with version
git checkout main
git tag -a v1.2.1 -m "Hotfix: Auth vulnerability patch"
git push --tags
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
   - Architecture decisions
   - Scope boundaries
   - Dependencies needed
   - Testing strategy
   - Trade-offs
3. **Draft Step-by-Step Plan** with files/types
4. **Get Approval** before implementing
5. **Progress Updates** after each phase

### Plan Mode Questions

```markdown
## Architecture
- Which layer should this live in?
- Should this be a new package or part of existing?

## Scope
- What's explicitly in/out of scope?
- Any dependencies on other features?

## Testing
- What are the critical test scenarios?
- What coverage is expected?

## Trade-offs
- Performance vs. simplicity?
- Flexibility vs. clarity?
```

## Detailed Documentation

For complete guidelines:
- **@git-commits.md** - Complete commit message guide
- **@git-branches.md** - Branch naming and workflow
- **@plan-mode.md** - When and how to use Plan Mode

## Branch Protection Rules

### main Branch
- ✅ Require PR reviews (1+ approvals)
- ✅ Status checks must pass
- ✅ No force push
- ✅ No deletion

### develop Branch
- ✅ Require PR reviews
- ✅ Status checks must pass
- ✅ No force push

## Quick Commit Examples

```bash
# Feature
git commit -m "feat(auth): add biometric authentication"

# Bug fix
git commit -m "fix(map): resolve annotation selection crash"

# Documentation
git commit -m "docs(readme): update setup instructions"

# Refactoring
git commit -m "refactor(storage): extract provider protocol"

# Testing
git commit -m "test(repository): add comprehensive CRUD tests"

# Chore
git commit -m "chore(deps): update ARCLogger to 1.2.0"
```

## Related Skills

When working on Git workflow, you may also need:

| If you need...              | Use                       |
|-----------------------------|---------------------------|
| Code quality standards      | `/arc-quality-standards`  |
| Architecture decisions      | `/arc-swift-architecture` |
| Testing patterns            | `/arc-tdd-patterns`       |
| Project setup               | `/arc-project-setup`      |
