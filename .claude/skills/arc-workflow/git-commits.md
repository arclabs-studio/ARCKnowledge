# 💬 Git Commit Standards

## Overview

ARC Labs Studio follows strict commit message conventions to maintain a clear, searchable project history. Well-crafted commit messages facilitate code reviews, debugging, and understanding project evolution over time.

---

## Commit Message Format

### Structure
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Components

#### Type (Required)
Describes the kind of change:

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(storage): add CloudKit provider` |
| `fix` | Bug fix | `fix(map): resolve annotation crash on iOS 17.2` |
| `docs` | Documentation only | `docs(readme): update installation steps` |
| `style` | Code style changes (formatting, no logic change) | `style(restaurant): apply SwiftFormat rules` |
| `refactor` | Code restructuring (no feature/bug change) | `refactor(repository): extract protocol` |
| `perf` | Performance improvement | `perf(search): optimize restaurant filtering` |
| `test` | Adding or updating tests | `test(storage): add SwiftData provider tests` |
| `chore` | Maintenance tasks | `chore(deps): update ARCLogger to 1.2.0` |
| `build` | Build system or dependencies | `build(spm): add ARCNetworking package` |
| `ci` | CI/CD configuration | `ci(github): add test workflow` |
| `revert` | Revert previous commit | `revert: feat(map): remove experimental feature` |

#### Scope (Optional but Recommended)
The affected module, feature, or component:

**Package-Level**:
- `storage`, `networking`, `logger`, `navigation`, `maps`, `intelligence`

**Feature-Level**:
- `restaurant-list`, `scanner`, `favorites`, `map-view`, `search`

**Layer-Level**:
- `presentation`, `domain`, `data`, `ui`

**File/Component-Level**:
- `restaurant-repository`, `map-coordinator`, `login-view`

#### Subject (Required)
Clear, concise description in imperative mood:
```
# ✅ Good
feat(storage): add SwiftData migration support
fix(map): prevent crash when selecting annotation
docs(architecture): document coordinator pattern

# ❌ Bad
feat(storage): added SwiftData migration support  # Past tense
fix(map): fixed a bug                              # Vague
docs: updates                                      # Too generic
```

**Guidelines**:
- Use imperative mood: "add", "fix", "update" (not "added", "fixed", "updated")
- Don't capitalize first letter
- No period at the end
- Maximum 50 characters
- Be specific and descriptive

#### Body (Optional)
Additional context about the change:
```
feat(storage): add CloudKit synchronization

Implements automatic CloudKit sync for restaurant data:
- Sync on app launch and background refresh
- Conflict resolution with server-wins strategy
- Batch operations for efficiency
- Exponential backoff for network failures

The sync process runs in a background actor to avoid
blocking the main thread during large data transfers.
```

**Guidelines**:
- Wrap at 72 characters
- Explain *what* and *why*, not *how*
- Reference related issues or decisions
- Include breaking changes

#### Footer (Optional)
Reference issues, breaking changes, or reviewers:
```
BREAKING CHANGE: StorageProvider protocol now requires async/await

Refs: ARC-123, ARC-124
Co-authored-by: John Doe <john@arclabs.com>
```

---

## Examples by Scenario

### Feature Addition
```
feat(restaurant): add rating filter to search

Implements a 5-star rating filter in the restaurant search:
- New RatingFilterView component
- Filter state managed in RestaurantListViewModel
- Persisted filter preferences in UserDefaults
- Smooth animation on filter selection

Refs: ARC-156
```

### Bug Fix
```
fix(map): resolve annotation crash on iOS 17.2

Fixes crash when dismissing map view with selected annotation
on iOS 17.2. The issue was caused by MapKit attempting to
access deallocated annotation state.

Solution: Manually deselect annotation before navigation.

Closes: ARC-189
```

### Refactoring
```
refactor(storage): extract protocol from repository

Splits RestaurantRepository into:
- RestaurantRepositoryProtocol (interface)
- RestaurantRepositoryImpl (implementation)

This enables dependency injection and simplifies testing
with mock implementations.

No functional changes.
```

### Documentation
```
docs(architecture): document storage abstraction

Adds comprehensive documentation for the storage layer:
- Protocol-based architecture rationale
- SwiftData vs CloudKit trade-offs
- Migration strategies
- Testing approaches

Refs: ARC-145
```

### Performance
```
perf(search): optimize restaurant filtering algorithm

Reduces search time from ~300ms to ~50ms for 1000 restaurants:
- Pre-build search index on background thread
- Use Set intersection instead of sequential filtering
- Cache normalized search terms

Maintains identical search results.
```

### Testing
```
test(storage): add comprehensive provider tests

Achieves 100% coverage for storage providers:
- SwiftDataProviderTests (CRUD operations)
- CloudKitProviderTests (sync scenarios)
- UserDefaultsProviderTests (simple storage)
- KeychainProviderTests (secure storage)

All tests use mock data and run in < 1 second.
```

### Chore
```
chore(deps): update ARC packages to latest

Updates all ARC packages to newest stable versions:
- ARCLogger: 1.1.0 → 1.2.0
- ARCStorage: 1.3.0 → 1.4.0
- ARCNavigation: 1.0.0 → 1.1.0

No breaking changes, maintenance updates only.
```

### Build System
```
build(spm): add ARCIntelligence package dependency

Integrates ARCIntelligence for AI-powered recommendations:
- Added package dependency (version 1.0.0)
- Updated minimum iOS version to 17.0
- Configured Swift 6 language mode

Refs: ARC-201
```

### Breaking Change
```
feat(storage): migrate to async/await API

BREAKING CHANGE: All StorageProvider methods now use async/await
instead of completion handlers.
Migration guide:

Replace completion: @escaping with async throws
Use try await instead of callback-based patterns
Remove completion handler calls

Before:

```
repository.fetch(id: id) { result in
    // handle result
}
```

After:

```
let item = try await repository.fetch(id: id)
```

Refs: ARC-178
```
---

## Commit Frequency

### When to Commit

**Commit Often**:
- Each logical unit of work
- When tests pass
- Before switching context
- End of work session

**Atomic Commits**:
- One concern per commit
- Independently revertable
- Buildable and testable
```
# ✅ Good - Atomic commits
feat(restaurant): add Restaurant entity model
feat(restaurant): implement repository protocol
feat(restaurant): add SwiftData persistence
test(restaurant): add repository tests

# ❌ Bad - Combined commit
feat(restaurant): implement entire feature
```

### Commit Size

**Small, Focused Commits**:
- Easier to review
- Simpler to debug
- Safer to revert
- Better history clarity
```
# ✅ Good - Small, focused
feat(ui): add restaurant card component          (50 lines)
style(ui): apply design system colors           (20 lines)
test(ui): add restaurant card tests             (80 lines)

# ❌ Bad - Large, unfocused
feat(restaurant): complete restaurant feature   (1500 lines)
```

---

## Branch-Specific Conventions

### Feature Branches
```
feat(restaurant-detail): add photo gallery
feat(restaurant-detail): implement share functionality
feat(restaurant-detail): add directions button
```

### Bugfix Branches
```
fix(scanner): resolve camera permission crash
fix(scanner): improve QR code detection accuracy
```

### Hotfix Branches
```
hotfix(auth): patch critical login vulnerability
```

---

## Special Cases

### Work in Progress

For incomplete work (avoid in main/develop):
```
WIP: feat(search): implement autocomplete

Partial implementation of search autocomplete.
TODO: Add debouncing and result caching.
```

### Merge Commits

Keep merge messages informative:
```
# ✅ Good
Merge branch 'feature/ARC-123-restaurant-search'

Adds comprehensive restaurant search functionality with
filters, sorting, and map integration.

Closes: ARC-123

# ❌ Bad
Merge branch 'feature/ARC-123-restaurant-search'
```

### Revert Commits

Explain why the revert is necessary:
```
revert: feat(map): add experimental clustering

This reverts commit abc123def456.

The clustering feature causes crashes on iOS 17.0-17.1.
Will re-implement after iOS 17.2 release with proper
backwards compatibility.

Refs: ARC-234
```

---

## Commit Message Templates

### Git Template Configuration

Create `~/.gitmessage`:
```
# <type>(<scope>): <subject>
# |<----  Using a Maximum Of 50 Characters  ---->|

# Explain why this change is being made
# |<----   Try To Limit Each Line to a Maximum Of 72 Characters   ---->|

# Provide links or keys to any relevant tickets, articles or other resources
# Example: Refs: ARC-123

# --- COMMIT END ---
# Type can be:
#    feat     (new feature)
#    fix      (bug fix)
#    refactor (refactoring code)
#    style    (formatting, missing semicolons, etc)
#    docs     (changes to documentation)
#    test     (adding or refactoring tests)
#    chore    (updating build tasks, package manager configs, etc)
#    perf     (performance improvements)
#    ci       (CI/CD changes)
#    build    (build system changes)
#    revert   (revert a previous commit)
# --------------------
# Remember to:
#   - Use imperative mood in subject
#   - Don't capitalize first letter
#   - Don't end subject with period
#   - Separate subject from body with blank line
#   - Use body to explain what and why vs. how
#   - Reference issues and pull requests
# --------------------
```

Configure Git to use template:
```bash
git config --global commit.template ~/.gitmessage
```

---

## Verification

### Pre-Commit Checks

Automated checks before commit (via ARCDevTools):
```bash
#!/bin/bash
# .git/hooks/pre-commit

# 1. Run SwiftLint
swiftlint lint --strict

# 2. Run SwiftFormat check
swiftformat --lint .

# 3. Run tests
swift test

# 4. Check commit message format
# (implemented in commit-msg hook)
```

### Commit Message Validation
```bash
#!/bin/bash
# .git/hooks/commit-msg

commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# Check format: type(scope): subject
pattern="^(feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert)(\([a-z0-9-]+\))?: .{1,50}$"

if ! echo "$commit_msg" | head -n1 | grep -qE "$pattern"; then
    echo "❌ Invalid commit message format"
    echo ""
    echo "Format: <type>(<scope>): <subject>"
    echo ""
    echo "Example: feat(storage): add CloudKit provider"
    echo ""
    echo "Types: feat, fix, docs, style, refactor, perf, test, chore, build, ci, revert"
    exit 1
fi

echo "✅ Commit message format valid"
```

---

## Tools and Automation

### Commitizen

For interactive commit message creation:
```bash
# Install
npm install -g commitizen cz-conventional-changelog

# Configure
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc

# Use
git cz
```

### GitHub Actions

Validate commit messages in PR:
```yaml
name: Commit Message Validation

on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Validate Commits
        uses: wagoid/commitlint-github-action@v5
        with:
          configFile: .commitlintrc.json
```

---

## Best Practices Summary

### Do ✅

- Write clear, descriptive commit messages
- Use imperative mood ("add" not "added")
- Keep subject line under 50 characters
- Include context in body when needed
- Reference related issues
- Commit logical units of work
- Test before committing
- Follow conventional commit format

### Don't ❌

- Write vague messages ("fix bug", "update code")
- Use past tense in subject
- Combine unrelated changes
- Skip testing before commit
- Commit incomplete work to main branches
- Use generic scopes
- Ignore commit message format
- Commit generated or temporary files

---

## Examples Reference

### Quick Reference
```bash
# Feature
git commit -m "feat(auth): add biometric authentication"

# Bug fix
git commit -m "fix(map): resolve annotation selection crash"

# Documentation
git commit -m "docs(readme): update setup instructions"

# Refactoring
git commit -m "refactor(storage): extract provider protocol"

# Performance
git commit -m "perf(search): optimize query algorithm"

# Testing
git commit -m "test(repository): add comprehensive CRUD tests"

# Chore
git commit -m "chore(deps): update ARCLogger to 1.2.0"

# Style
git commit -m "style: apply SwiftFormat rules"
```

---

## Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Commitizen](https://github.com/commitizen/cz-cli)

---

## Summary

High-quality commit messages are essential for maintaining a professional, navigable project history. By following these conventions, ARC Labs ensures that every commit tells a clear story, making code reviews efficient, debugging straightforward, and project evolution transparent. Treat commit messages as permanent documentation of your decision-making process—future you (and your teammates) will be grateful.