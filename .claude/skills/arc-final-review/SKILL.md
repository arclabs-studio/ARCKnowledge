---
name: arc-final-review
description: |
  Final code review before merge. Analyzes branch changes by domain (SwiftUI, Data,
  Concurrency, Architecture), invokes specialized Axiom skills, and generates a
  prioritized finalization plan with verification gates and tech debt cleanup items.

  **INVOKE THIS SKILL** when:
  - About to merge a feature branch
  - Finishing a significant code change
  - Preparing a PR for review
  - Wanting a comprehensive quality check before ship
  - Need to identify remaining tech debt
user-invocable: true
---

# ARC Labs Studio - Final Review

You are a **Staff iOS Engineer** reviewing code changes before merge. Your goal is to ensure the code is production-ready, follows ARC Labs standards, and identifies any remaining work.

## Review Process

### Step 1: Analyze Current State

First, understand what changed in this branch:

```bash
# Get the base branch (usually develop or main)
git merge-base HEAD develop 2>/dev/null || git merge-base HEAD main

# List all changed files
git diff --name-only $(git merge-base HEAD develop 2>/dev/null || git merge-base HEAD main)..HEAD

# Get a summary of changes
git diff --stat $(git merge-base HEAD develop 2>/dev/null || git merge-base HEAD main)..HEAD
```

### Step 2: Categorize Changes by Domain

Based on changed files, categorize into domains:

| Domain | File Patterns | Axiom Skill to Use |
|--------|--------------|-------------------|
| **SwiftUI** | `*View.swift`, `*Screen.swift`, UI components | `/swiftui-expert-skill` |
| **Concurrency** | `async/await`, `@MainActor`, actors, Tasks | `/swift-concurrency` |
| **Data Layer** | `*Repository.swift`, `*DataSource.swift`, Core Data, SwiftData | `/axiom:axiom-ios-data` |
| **Architecture** | ViewModels, Use Cases, Coordinators | `/arc-swift-architecture` |
| **Testing** | `*Tests.swift`, test targets | `/arc-tdd-patterns` |
| **Navigation** | Router, NavigationStack, deep links | `/axiom:axiom-swiftui-nav` |
| **Performance** | Heavy computations, memory, energy | `/axiom:axiom-ios-performance` |

### Step 3: Generate Domain-Specific Analysis

For each detected domain, use the appropriate skill to analyze:

**SwiftUI Changes:**
- Use `/swiftui-expert-skill` to review for:
  - Deprecated APIs (`foregroundColor`, `cornerRadius`, `NavigationView`)
  - `@Observable` vs `ObservableObject` usage
  - Proper state management (`@State`, `@Binding`)
  - Accessibility compliance

**Concurrency Changes:**
- Use `/swift-concurrency` to review for:
  - Swift 6 strict concurrency compliance
  - `@MainActor` correctness
  - `Sendable` conformance
  - Actor isolation issues
  - `Task.detached` capturing `self` incorrectly

**Data Layer Changes:**
- Use `/axiom:axiom-ios-data` to review for:
  - Core Data/SwiftData migration safety
  - Background context configuration
  - `mergePolicy` settings
  - Thread-confinement violations

**Architecture Changes:**
- Use `/arc-swift-architecture` to review for:
  - Clean Architecture compliance
  - Layer boundary violations
  - Protocol-oriented design
  - Dependency injection patterns

## Output Format

Structure your final review as follows:

```markdown
# Final Review: [Branch Name]

## Current State (What Changed)

### Domain Summary
- **SwiftUI**: [summary of UI changes]
- **Data Layer**: [summary of data changes]
- **Concurrency**: [summary of async changes]
- **Other**: [any other significant changes]

### Changed Files
[List of changed files grouped by domain]

---

## Finalization Plan (Prioritized by Risk)

### 1. Critical Issues (Must Fix)
> Issues that will cause crashes, data loss, or security vulnerabilities

- [ ] **[Domain]**: Issue description
  - **File**: `path/to/file.swift:line`
  - **Problem**: Detailed explanation
  - **Fix**: Recommended solution
  - **Risk**: High - [reason]

### 2. Important Issues (Should Fix)
> Issues that affect code quality or may cause subtle bugs

- [ ] **[Domain]**: Issue description
  - **File**: `path/to/file.swift:line`
  - **Problem**: Detailed explanation
  - **Fix**: Recommended solution

### 3. Improvements (Nice to Have)
> Suggestions that improve code but aren't blocking

- [ ] **[Domain]**: Suggestion description
  - **File**: `path/to/file.swift:line`
  - **Current**: What it does now
  - **Better**: Recommended improvement

---

## Verification Gates

Before shipping, verify:

### Unit/Package Tests
- [ ] Run tests: `swift test` or `xcodebuild test`
- [ ] Coverage meets threshold (100% packages, 80%+ apps)

### Thread Safety
- [ ] Run with Thread Sanitizer enabled
- [ ] No data race warnings

### Data Migration (if applicable)
- [ ] Test migration from previous version
- [ ] Verify data integrity after migration
- [ ] Test with production-like data volume

### UI/UX
- [ ] Test on multiple device sizes
- [ ] Test with Dynamic Type (accessibility sizes)
- [ ] Test VoiceOver navigation
- [ ] Test Dark Mode

---

## Tech Debt Cleanup (Small, High Leverage)

Items that can be addressed now or tracked for later:

### Immediate (Address in this PR)
- [ ] [Item description] - [File location]

### Follow-up (Create Linear ticket)
- [ ] [Item description] - Estimated effort: [S/M/L]

---

## Strengths

What's done well in this change:
- [Positive observation 1]
- [Positive observation 2]

---

## Recommendation

[ ] **Ready to Merge** - All critical and important issues addressed
[ ] **Needs Work** - Address [N] critical issues before merge
[ ] **Major Revision** - Significant architectural concerns
```

## Domain-Specific Checklists

### SwiftUI Checklist
- [ ] No `foregroundColor()` - use `foregroundStyle()`
- [ ] No `cornerRadius()` - use `clipShape(.rect(cornerRadius:))`
- [ ] No `NavigationView` - use `NavigationStack`
- [ ] No `ObservableObject` - use `@Observable`
- [ ] `Button` instead of `onTapGesture` for actions
- [ ] Dynamic Type (no fixed font sizes)
- [ ] Accessibility labels on interactive elements

### Concurrency Checklist
- [ ] No `Task.detached` capturing `@MainActor` state
- [ ] `@MainActor` on ViewModels
- [ ] `Sendable` conformance where needed
- [ ] No `DispatchQueue.main.async` - use `@MainActor`
- [ ] `Task.sleep(for:)` instead of nanoseconds

### Data Layer Checklist
- [ ] `mergePolicy` configured on contexts
- [ ] No `NSManagedObject` passed across contexts
- [ ] Background contexts for heavy operations
- [ ] Migration tested from previous schema
- [ ] Error handling (no `assertionFailure` in production paths)

### Architecture Checklist
- [ ] No business logic in Views
- [ ] ViewModels use `@Observable` + `@MainActor`
- [ ] Dependencies injected via protocols
- [ ] Use Cases in Domain layer
- [ ] Repository pattern for data access

## Related Skills

When issues are found, use these skills for detailed guidance:

| Issue Type | Skill |
|-----------|-------|
| SwiftUI patterns | `/swiftui-expert-skill` |
| Concurrency bugs | `/swift-concurrency` |
| Core Data issues | `/axiom:axiom-core-data` |
| SwiftData issues | `/axiom:axiom-swiftdata` |
| Performance | `/axiom:axiom-ios-performance` |
| Testing gaps | `/arc-tdd-patterns` |
| Architecture violations | `/arc-swift-architecture` |

## Example Usage

```
User: /arc-final-review

Claude:
1. Runs git diff to identify changed files
2. Categorizes changes by domain
3. Invokes relevant Axiom skills for each domain
4. Generates comprehensive finalization plan
5. Lists verification gates
6. Identifies tech debt items
7. Provides merge recommendation
```

## Integration with ARC Labs Workflow

This skill fits into the workflow:

```
1. Develop feature on branch
2. Run /arc-final-review before PR
3. Address critical/important issues
4. Run verification gates
5. Create PR using /arc-workflow
6. Get review, merge to develop
```
