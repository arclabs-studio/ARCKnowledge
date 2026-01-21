# 🌿 Git Branch Naming Conventions

## Overview

ARC Labs uses a structured branch naming strategy integrated with Linear issue tracking. Clear branch names improve collaboration, automate workflows, and maintain organized repositories across all projects.

---

## Branch Naming Format

### Standard Format
```
<type>/<issue-id>-<short-description>
```

### Components

1. **Type**: Branch category
2. **Issue ID**: Linear issue reference (e.g., `ARC-123`). Optional, just if linear issue exists
3. **Short Description**: Kebab-case summary (2-5 words)

---

## Branch Types

### Feature Branches

For new features or enhancements:
```
feature/<issue-id>-<description>
```

**Examples**:
```
feature/ARC-123-restaurant-search
feature/ARC-156-rating-filter
feature/ARC-201-ai-recommendations
feature/ARC-234-cloudkit-sync
```

**Usage**:
- New user-facing functionality
- New internal capabilities
- Feature enhancements
- Experimental features

**Lifecycle**:
- Branch from: `develop`
- Merge to: `develop`
- Delete after: Merge completion

### Bugfix Branches

For fixing non-critical bugs:
```
bugfix/<issue-id>-<description>
```

**Examples**:
```
bugfix/ARC-145-map-annotation-crash
bugfix/ARC-167-search-performance
bugfix/ARC-189-camera-permission
bugfix/ARC-212-data-persistence
```

**Usage**:
- Non-critical bugs
- UI glitches
- Logic errors
- Performance issues

**Lifecycle**:
- Branch from: `develop`
- Merge to: `develop`
- Delete after: Merge completion

### Hotfix Branches

For critical production fixes:
```
hotfix/<issue-id>-<description>
```

**Examples**:
```
hotfix/ARC-178-auth-vulnerability
hotfix/ARC-199-data-loss-prevention
hotfix/ARC-223-crash-on-launch
hotfix/ARC-245-payment-failure
```

**Usage**:
- Critical production bugs
- Security vulnerabilities
- Data loss prevention
- Crash fixes

**Lifecycle**:
- Branch from: `main`
- Merge to: `main` AND `develop`
- Tag with version number
- Delete after: Merge completion

---

## Primary Branches

### main

**Purpose**: Production-ready code

**Rules**:
- Always stable and deployable
- Only receives merges from `hotfix/*` or `release/*`
- Protected branch (requires PR)
- Tagged with version numbers
- Triggers production deployment

**Never**:
- Direct commits
- Work in progress
- Experimental features

### develop

**Purpose**: Integration branch for features

**Rules**:
- Latest development changes
- Receives merges from `feature/*` and `bugfix/*`
- Base for new feature branches
- Protected branch (requires PR)
- Triggers staging deployment

**Never**:
- Direct commits (except emergency fixes)
- Untested code
- Breaking changes without migration

---

## Special Branch Types

### Release Branches

Preparing a new production release:
```
release/<version>
```

**Examples**:
```
release/1.2.0
release/2.0.0
release/1.3.1
```

**Usage**:
- Final testing before release
- Version bumps
- CHANGELOG updates
- Last-minute bug fixes

**Lifecycle**:
- Branch from: `develop`
- Merge to: `main` AND `develop`
- Tag `main` with version
- Delete after: Merge completion

**Workflow**:
```bash
# Create release branch
git checkout develop
git checkout -b release/1.2.0

# Bump version
# Update CHANGELOG.md
# Final testing

# Merge to main
git checkout main
git merge --no-ff release/1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"

# Merge back to develop
git checkout develop
git merge --no-ff release/1.2.0

# Delete release branch
git branch -d release/1.2.0
```

### Spike (Experiment) Branches

For exploratory work or prototypes:
```
spike/<description>
```

**Examples**:
```
spike/swiftui-animations
spike/core-ml-integration
spike/widget-prototype
spike/visionos-adaptation
```

**Usage**:
- Research and exploration
- Technical experiments
- Proof of concepts
- Learning new APIs

**Lifecycle**:
- Branch from: `develop` or any feature branch
- Merge to: Optional (may be discarded)
- Delete after: Decision to adopt or reject

**Note**: No Linear issue required for spikes

### Documentation Branches

For documentation-only changes:
```
docs/<description>
```

**Examples**:
```
docs/update-readme
docs/api-documentation
docs/architecture-guide
docs/contributing-guidelines
```

**Usage**:
- README updates
- DocC documentation
- Architecture documentation
- Code comments

**Lifecycle**:
- Branch from: `develop`
- Merge to: `develop`
- Delete after: Merge completion

---

## Branch Naming Guidelines

### Short Description Rules

**Format**: Kebab-case (lowercase, hyphen-separated)

**Length**: 2-5 words maximum

**Be Specific**:
```
# ✅ Good
feature/ARC-123-restaurant-search
feature/ARC-156-rating-filter-ui
bugfix/ARC-189-map-annotation-crash

# ❌ Bad
feature/ARC-123-new-feature      # Too vague
feature/ARC-156-stuff             # Not descriptive
bugfix/ARC-189-fix                # What fix?
```

**Focus on What, Not How**:
```
# ✅ Good
feature/ARC-201-ai-recommendations
bugfix/ARC-212-data-persistence

# ❌ Bad
feature/ARC-201-add-ml-model
bugfix/ARC-212-fix-swiftdata-query
```

**Avoid Redundancy**:
```
# ✅ Good
feature/ARC-234-cloudkit-sync
bugfix/ARC-245-payment-failure

# ❌ Bad
feature/ARC-234-add-cloudkit-sync-feature
bugfix/ARC-245-fix-payment-failure-bug
```

---

## Linear Integration

### Issue Reference Format

**Linear Issue Format**: `<PROJECT>-<NUMBER>`

**Projects at ARC Labs Studio**:
- `ARC`: Core packages and infrastructure
- `FAVRES`: FavRes app
- `PIZ`: Pizzeria La Famiglia app
- `TIC`: TicketMind app

**Examples**:
```
feature/ARC-123-storage-abstraction     # ARCStorage package
feature/FAVRES-45-restaurant-search     # FavRes feature
bugfix/PIZ-78-menu-sync-error           # Pizzeria La Famiglia bugfix
hotfix/TIC-12-rendering-crash           # TicketMind hotfix
```

### Automatic Linking

Branch names automatically link to Linear:
```bash
# Create branch from Linear issue ARC-123
git checkout -b feature/ARC-123-restaurant-search

# Commits reference the issue
git commit -m "feat(search): implement basic search"
# Appears in Linear issue ARC-123 timeline

# PR title includes issue
# "Feature/ARC-123: Restaurant Search Implementation"
# Automatically links to Linear
```

---

## Branch Workflow

### Creating a Branch
```bash
# 1. Update develop
git checkout develop
git pull origin develop

# 2. Create feature branch
git checkout -b feature/ARC-123-restaurant-search

# 3. Push to remote
git push -u origin feature/ARC-123-restaurant-search
```

### Working on a Branch
```bash
# Regular commits following commit conventions
git add .
git commit -m "feat(search): add search bar component"
git push

# Keep branch updated with develop
git checkout develop
git pull origin develop
git checkout feature/ARC-123-restaurant-search
git merge develop
# Or: git rebase develop (if no shared commits)
```

### Completing a Branch
```bash
# 1. Ensure all tests pass
swift test

# 2. Ensure code quality
swiftlint
swiftformat --lint .

# 3. Update from develop
git checkout develop
git pull origin develop
git checkout feature/ARC-123-restaurant-search
git merge develop

# 4. Push final changes
git push

# 5. Create pull request on GitHub
# 6. After merge, delete branch
git checkout develop
git pull
git branch -d feature/ARC-123-restaurant-search
git push origin --delete feature/ARC-123-restaurant-search
```

---

## Branch Protection Rules

### main Branch

**Required**:
- Pull request reviews (1+ approvals)
- Status checks must pass:
  - All tests passing
  - SwiftLint validation
  - Build success
- No force push
- No deletion

**Optional**:
- Require linear history
- Require signed commits

### develop Branch

**Required**:
- Pull request reviews (1+ approvals)
- Status checks must pass:
  - All tests passing
  - SwiftLint validation
  - Build success
- No force push
- No deletion

**Optional**:
- Require branches up to date before merge

---

## Pull Request Naming

### Format
```
<Type>/<Issue-ID>: <Title>
```

### Examples
```
Feature/ARC-123: Restaurant Search Implementation
Bugfix/ARC-145: Map Annotation Crash Fix
Hotfix/ARC-178: Authentication Vulnerability Patch
Docs/Update Architecture Guide
```

### PR Description Template
```markdown
## Description
[Clear description of what this PR does]

## Related Issue
Closes: ARC-123

## Type of Change
- [ ] Feature
- [ ] Bugfix
- [ ] Hotfix
- [ ] Documentation
- [ ] Refactoring

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] All tests passing

## Screenshots (if applicable)
[Add screenshots for UI changes]

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests provide adequate coverage

## Additional Notes
[Any additional context or notes for reviewers]
```

---

## Common Workflows

### Feature Development
```bash
# 1. Create feature branch
git checkout develop
git pull origin develop
git checkout -b feature/ARC-123-restaurant-search

# 2. Implement feature
# ... make changes ...
git add .
git commit -m "feat(search): implement search logic"
git push

# 3. Create PR when ready
# GitHub: Create Pull Request
# Title: "Feature/ARC-123: Restaurant Search Implementation"
# Base: develop

# 4. Address review feedback
# ... make changes ...
git commit -m "refactor(search): address review feedback"
git push

# 5. Merge via GitHub
# Delete branch after merge

# 6. Clean up locally
git checkout develop
git pull
git branch -d feature/ARC-123-restaurant-search
```

### Bug Fix
```bash
# 1. Create bugfix branch
git checkout develop
git pull origin develop
git checkout -b bugfix/ARC-145-map-crash

# 2. Fix bug
# ... make changes ...
git add .
git commit -m "fix(map): resolve annotation crash"
git push

# 3. Create PR
# Similar to feature workflow

# 4. Merge and clean up
```

### Hotfix
```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/ARC-178-auth-vulnerability

# 2. Fix critical issue
# ... make changes ...
git add .
git commit -m "hotfix(auth): patch security vulnerability"
git push

# 3. Create PR to main
# Merge to main first

# 4. Create PR to develop
# Ensure fix is in develop too

# 5. Tag main
git checkout main
git pull
git tag -a v1.2.1 -m "Hotfix: Auth vulnerability patch"
git push --tags

# 6. Clean up
git branch -d hotfix/ARC-178-auth-vulnerability
git push origin --delete hotfix/ARC-178-auth-vulnerability
```

---

## Best Practices

### Do ✅

- Always create branches from latest `develop` (or `main` for hotfixes)
- Use Linear issue IDs in branch names
- Keep branch names concise and descriptive
- Delete branches after merging
- Keep branches up to date with base branch
- Create PR early for visibility (draft if not ready)
- Squash commits when merging (if many small commits)

### Don't ❌

- Create branches without Linear issues (except experiments/docs)
- Use vague branch names
- Leave stale branches
- Commit directly to `main` or `develop`
- Force push to shared branches
- Merge without PR review
- Work on multiple unrelated features in one branch

---

## Troubleshooting

### Renaming a Branch
```bash
# Rename local branch
git branch -m old-name new-name

# Delete old remote branch
git push origin :old-name

# Push new branch
git push -u origin new-name
```

### Syncing Fork
```bash
# Add upstream remote (original repo)
git remote add upstream https://github.com/arclabs/original-repo.git

# Fetch upstream
git fetch upstream

# Merge upstream changes
git checkout develop
git merge upstream/develop

# Push to your fork
git push origin develop
```

### Recovering Deleted Branch
```bash
# Find deleted branch commit
git reflog

# Recreate branch
git checkout -b recovered-branch <commit-hash>
```

---

## Automation

### GitHub Actions

Automatic branch operations:
```yaml
name: Branch Cleanup

on:
  pull_request:
    types: [closed]

jobs:
  cleanup:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Delete merged branch
        run: |
          gh pr view ${{ github.event.pull_request.number }} \
            --json headRefName -q .headRefName | \
          xargs -I {} gh api \
            -X DELETE repos/${{ github.repository }}/git/refs/heads/{}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## Resources

- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Linear Git Integration](https://linear.app/docs/github)
- [Git Branch Best Practices](https://www.git-tower.com/learn/git/ebook/en/command-line/branching-merging/best-practices)

---

## Summary

A well-organized branching strategy is fundamental to efficient collaboration at ARC Labs. By consistently following these conventions and integrating with Linear, we maintain a clean, navigable repository structure that scales across multiple projects and team members. Every branch tells a story—make sure yours is clear, purposeful, and properly documented.