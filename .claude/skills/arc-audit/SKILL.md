---
name: arc-audit
description: |
  Comprehensive audit of ARC Labs Studio projects for standards compliance.
  Scans 9 domains (Architecture, Presentation, Domain, Data, Testing, Code
  Style, Documentation, Accessibility, Concurrency) and generates a compliance
  report with severity levels and a letter grade (A-F). Use when "project
  health check", "pre-release audit", "standards compliance", "post-refactor
  verification", or "onboarding to ARC Labs standards".
user-invocable: true
metadata:
  author: ARC Labs Studio
  version: "3.0.0"
---

# ARC Labs Studio - Project Audit

You are a **Staff iOS Engineer** performing a comprehensive standards audit. Your goal is to systematically scan the project against all ARC Labs standards and produce an actionable compliance report.

## Instructions

You can audit at three levels:

| Scope | Command | What It Checks |
|-------|---------|----------------|
| **Full project** | `/arc-audit` | All source files in the project |
| **Directory** | `/arc-audit Sources/Features/` | Only files in the specified path |
| **Single file** | `/arc-audit Sources/MyFile.swift` | One file against all applicable rules |

### Step 1: Discover Project Structure

```bash
# Identify project type
ls Package.swift 2>/dev/null && echo "Swift Package" || echo "Xcode Project"

# Count source files
find Sources -name "*.swift" 2>/dev/null | wc -l
find Tests -name "*.swift" 2>/dev/null | wc -l

# Identify layers
ls -d Sources/*/Presentation 2>/dev/null
ls -d Sources/*/Domain 2>/dev/null
ls -d Sources/*/Data 2>/dev/null
```

### Step 2: Run All 9 Domain Audits

For each domain, scan the relevant files and check against the rules below.

---

## Domain A: Architecture

**Reference**: `/arc-swift-architecture`

**Check for**:
- [ ] Clean Architecture layers exist (Presentation, Domain, Data)
- [ ] No reverse dependencies (Domain importing Presentation/Data/SwiftUI/UIKit)
- [ ] Repository protocols in Domain, implementations in Data
- [ ] Use Cases in Domain layer
- [ ] Dependency injection via protocols (no concrete types in constructors)
- [ ] No singletons without protocol abstraction

**How to scan**:
```bash
# Check for reverse dependencies in Domain layer
grep -r "import SwiftUI\|import UIKit\|import Alamofire" Sources/*/Domain/
# Should return NOTHING

# Check UseCase files exist
find Sources -path "*/Domain/UseCases/*.swift" -type f

# Check Repository protocols exist
find Sources -path "*/Domain/Repositories/*Protocol.swift" -type f
```

---

## Domain B: Presentation Layer

**Reference**: `/arc-presentation-layer`

**Check for**:
- [ ] ViewModels use `@Observable` (NOT `ObservableObject`)
- [ ] No `@Published` properties
- [ ] No blanket `@MainActor` on ViewModel classes
- [ ] `@MainActor` only on specific methods that update UI-bound state
- [ ] No business logic in Views or ViewModels
- [ ] User actions prefixed with `onTapped*`, `onChanged*`
- [ ] Views use `Button` instead of `onTapGesture` for interactive elements
- [ ] Navigation via ARCNavigation Router (no direct `NavigationLink`)
- [ ] Private subviews in `private extension`

**How to scan**:
```bash
# Check for ObservableObject (should be ZERO)
grep -rn "ObservableObject\|@Published" Sources/ --include="*.swift"

# Check for blanket @MainActor on classes
grep -rn "@MainActor.*@Observable\|@MainActor.*final class.*ViewModel" Sources/ --include="*.swift"

# Check for onTapGesture on interactive elements
grep -rn "\.onTapGesture" Sources/ --include="*.swift"

# Check for deprecated SwiftUI APIs
grep -rn "foregroundColor(\|cornerRadius(\|NavigationView" Sources/ --include="*.swift"
```

---

## Domain C: Domain Layer

**Reference**: `/arc-swift-architecture`, `Layers/domain.md`

**Check for**:
- [ ] Entities are value types (structs)
- [ ] Entities conform to `Identifiable`, `Equatable`, `Sendable`
- [ ] UseCase protocols conform to `Sendable`
- [ ] UseCase implementations conform to `Sendable`
- [ ] Grouped UseCases use enum actions (when appropriate)
- [ ] Private methods in `private extension`
- [ ] No framework imports (Foundation only)

**How to scan**:
```bash
# Check UseCase Sendable conformance
grep -rn "UseCaseProtocol" Sources/*/Domain/ --include="*.swift" -A2

# Check for framework imports in Domain
grep -rn "import SwiftUI\|import UIKit\|import CoreData" Sources/*/Domain/ --include="*.swift"
```

---

## Domain D: Data Layer

**Reference**: `/arc-data-layer`

**Check for**:
- [ ] Repository implementations conform to protocols from Domain
- [ ] DTOs are separate from Domain entities
- [ ] Mapping functions exist (DTO -> Entity, Entity -> DTO)
- [ ] No Domain entities used directly in API calls
- [ ] Error handling wraps external errors into domain errors
- [ ] No `@MainActor` on Repository implementations

**How to scan**:
```bash
# Check Repository implementations exist
find Sources -path "*/Data/Repositories/*.swift" -type f

# Check for DTO files
find Sources -path "*/Data/Models/*.swift" -o -path "*/Data/DTOs/*.swift" -type f
```

---

## Domain E: Testing

**Reference**: `/arc-tdd-patterns`

**Check for**:
- [ ] Tests use Swift Testing (`import Testing`, `@Test`, `@Suite`, `#expect`)
- [ ] No XCTest usage (`import XCTest`, `XCTAssert*`)
- [ ] Every UseCase has corresponding tests
- [ ] Every ViewModel has corresponding tests
- [ ] Tests follow AAA/Given-When-Then pattern
- [ ] Mock objects exist for all repository protocols
- [ ] Test coverage meets threshold (100% packages, 80%+ apps)
- [ ] No `@MainActor` on `@Suite` (only on specific test methods)

**How to scan**:
```bash
# Check for XCTest (should be ZERO in new code)
grep -rn "import XCTest\|XCTAssert" Tests/ --include="*.swift"

# Check UseCase test coverage
for uc in $(find Sources -path "*/UseCases/*UseCase.swift" -type f -exec basename {} .swift \;); do
  find Tests -name "${uc}Tests.swift" -type f | grep -q . || echo "MISSING: ${uc}Tests.swift"
done

# Check ViewModel test coverage
for vm in $(find Sources -name "*ViewModel.swift" -type f -exec basename {} .swift \;); do
  find Tests -name "${vm}Tests.swift" -type f | grep -q . || echo "MISSING: ${vm}Tests.swift"
done
```

---

## Domain F: Code Style

**Reference**: `/arc-quality-standards`, `Quality/code-style.md`

**Check for**:
- [ ] No `print()` statements (use ARCLogger)
- [ ] No force unwrap (`!`), force try (`try!`), force cast (`as!`)
- [ ] No magic numbers (named constants required)
- [ ] File length under 500 lines
- [ ] Function length under 60 lines
- [ ] Line length under 150 characters
- [ ] Private methods in `private extension` (not inside type body)
- [ ] Multiline declarations use after-first style
- [ ] MARK sections present and ordered correctly
- [ ] File headers present

**How to scan**:
```bash
# Check for print statements
grep -rn "\bprint(" Sources/ --include="*.swift"

# Check for force unwrap/try/cast
grep -rn "as!\| try!\|[^?]!" Sources/ --include="*.swift" | grep -v "// swiftlint:disable"

# Check file lengths
find Sources -name "*.swift" -type f -exec wc -l {} + | sort -rn | head -20
```

---

## Domain G: Documentation

**Reference**: `/arc-quality-standards`, `Quality/documentation.md`

**Check for**:
- [ ] All `public` types have DocC documentation
- [ ] All `public` functions have DocC documentation
- [ ] DocC includes `- Parameter`, `- Returns`, `- Throws` where applicable
- [ ] README.md exists and follows template
- [ ] No hardcoded user-facing strings (use `String(localized:)`)

**How to scan**:
```bash
# Check for undocumented public APIs
grep -rn "^    public " Sources/ --include="*.swift" -B1 | grep -v "///"

# Check for hardcoded strings in Views
grep -rn 'Text("' Sources/ --include="*.swift" | grep -v "String(localized:"
```

---

## Domain H: Accessibility

**Reference**: `/arc-quality-standards` (UI Guidelines section)

**Check for**:
- [ ] All interactive elements have accessibility labels
- [ ] No fixed font sizes (use Dynamic Type: `.font(.body)`)
- [ ] Semantic colors used (not hardcoded RGB)
- [ ] Dark mode tested (no `.foregroundColor(.black)` or `.white`)
- [ ] `Button` used for tappable elements (not `onTapGesture`)

**How to scan**:
```bash
# Check for fixed font sizes
grep -rn "\.system(size:" Sources/ --include="*.swift"

# Check for hardcoded colors
grep -rn "Color(.sRGB\|UIColor(red:" Sources/ --include="*.swift"

# Check for .black/.white foreground
grep -rn "foregroundStyle(.black)\|foregroundStyle(.white)\|foregroundColor(.black)\|foregroundColor(.white)" Sources/ --include="*.swift"
```

---

## Domain I: Concurrency

**Reference**: `/arc-swift-architecture` (Concurrency section), `axiom-swift-concurrency`

**Check for**:
- [ ] No blanket `@MainActor` on ViewModel or UseCase classes
- [ ] `@MainActor` only on methods that update UI-bound state
- [ ] No `@MainActor` on Use Cases or Repository implementations
- [ ] UseCase protocols and implementations conform to `Sendable`
- [ ] No `DispatchQueue.main.async` (use `@MainActor`)
- [ ] No `Task.sleep(nanoseconds:)` (use `Task.sleep(for:)`)
- [ ] Weak self in stored Tasks
- [ ] Task cancellation handled where appropriate

**How to scan**:
```bash
# Check for DispatchQueue usage
grep -rn "DispatchQueue" Sources/ --include="*.swift"

# Check for Task.sleep(nanoseconds:)
grep -rn "Task.sleep(nanoseconds:" Sources/ --include="*.swift"

# Check for blanket @MainActor on classes
grep -rn "^@MainActor" Sources/ --include="*.swift" -A1 | grep "class\|struct"
```

---

## Compliance Report Format

Generate the report in this format:

```markdown
# ARC Labs Audit Report

**Project**: [Name]
**Date**: [Date]
**Scope**: [Full / Directory / File]
**Overall Grade**: [A-F]

## Summary

| Domain | Issues | Severity | Status |
|--------|--------|----------|--------|
| A. Architecture | [n] | [highest] | [Pass/Fail] |
| B. Presentation | [n] | [highest] | [Pass/Fail] |
| C. Domain | [n] | [highest] | [Pass/Fail] |
| D. Data | [n] | [highest] | [Pass/Fail] |
| E. Testing | [n] | [highest] | [Pass/Fail] |
| F. Code Style | [n] | [highest] | [Pass/Fail] |
| G. Documentation | [n] | [highest] | [Pass/Fail] |
| H. Accessibility | [n] | [highest] | [Pass/Fail] |
| I. Concurrency | [n] | [highest] | [Pass/Fail] |

## Findings

### Critical (Must Fix)

Issues that cause crashes, data loss, or security vulnerabilities.

1. **[Domain]**: [Description]
   - **File**: `path/to/file.swift:line`
   - **Rule**: [Which rule is violated]
   - **Fix**: [Recommended solution]

### Important (Should Fix)

Issues that affect code quality or may cause subtle bugs.

1. **[Domain]**: [Description]
   - **File**: `path/to/file.swift:line`
   - **Rule**: [Which rule is violated]
   - **Fix**: [Recommended solution]

### Improvement (Nice to Have)

Suggestions for better standards compliance.

1. **[Domain]**: [Description]
   - **File**: `path/to/file.swift:line`
   - **Suggestion**: [Recommended improvement]

## Grading Criteria

| Grade | Criteria |
|-------|----------|
| **A** | 0 Critical, 0-2 Important, any Improvements |
| **B** | 0 Critical, 3-5 Important |
| **C** | 0 Critical, 6-10 Important |
| **D** | 1-2 Critical OR 11+ Important |
| **F** | 3+ Critical |

## Recommendations

1. [Prioritized action item 1]
2. [Prioritized action item 2]
3. [Prioritized action item 3]
```

## Verification Steps

After generating the report:

1. **Confirm findings are real** - Read each flagged file to verify the issue exists
2. **Check for false positives** - Some patterns may be intentional (e.g., `print()` in debug-only code)
3. **Prioritize by impact** - Critical > Important > Improvement
4. **Suggest Linear tickets** - For Important+ findings, suggest creating Linear issues

## Examples

### Full project audit before release
User says: "/arc-audit"

1. Discover project structure (Swift Package with 45 source files, 22 test files)
2. Run all 9 domain audits against Sources/ and Tests/
3. Find: 0 Critical, 3 Important (missing Sendable on 2 UseCases, 1 blanket @MainActor)
4. Grade: B
5. Result: Compliance report with specific file:line references and fixes

### Auditing a single directory
User says: "/arc-audit Sources/Features/Search/"

1. Scope audit to Search feature files only
2. Check all 9 domains against those files
3. Find: 1 Important (ViewModel contains business logic)
4. Result: Focused report with recommendation to extract UseCase

## Integration with Workflow

```
1. Run /arc-audit periodically (monthly or per milestone)
2. Address Critical findings immediately
3. Create Linear tickets for Important findings
4. Track Improvement items in tech debt backlog
5. Re-audit after fixes to verify grade improvement
```

## Related Skills

During the audit, invoke these skills for domain-specific deep dives:

| Domain | Invoke |
|--------|--------|
| Architecture violations | `/arc-swift-architecture` |
| Presentation issues | `/arc-presentation-layer` |
| Testing gaps | `/arc-tdd-patterns` |
| Code style violations | `/arc-quality-standards` |
| Concurrency issues | `axiom-swift-concurrency` |
| Accessibility issues | `axiom-ios-accessibility` |
| SwiftUI problems | `swiftui-expert-skill` |

| If you need... | Use |
|----------------|-----|
| Pre-merge review (branch diff) | `/arc-final-review` |
| Code quality details | `/arc-quality-standards` |
| Architecture patterns | `/arc-swift-architecture` |
| Testing patterns | `/arc-tdd-patterns` |
