---
name: arc-quality-standards
description: |
  Code quality standards covering code review checklists, SwiftLint/SwiftFormat
  configuration, naming conventions, DocC documentation, README templates,
  package structure, UI/UX guidelines (Apple HIG), accessibility, dark mode,
  and localization. Use when "reviewing code", "writing documentation",
  "creating READMEs", "checking naming", "implementing accessibility",
  or "fixing lint issues".
user-invocable: true
metadata:
  author: ARC Labs Studio
  version: "3.0.0"
---

# ARC Labs Studio - Code Quality Standards

## Instructions

### Code Review Checklist (AI-Generated Code)

#### SwiftUI Deprecated APIs to Replace
```swift
// foregroundColor() -> foregroundStyle()
Text("Hello").foregroundStyle(.blue)

// cornerRadius() -> clipShape()
Rectangle().clipShape(.rect(cornerRadius: 12))

// NavigationView -> NavigationStack
NavigationStack { ContentView() }

// ObservableObject -> @Observable
@Observable final class ViewModel { }

// DispatchQueue.main.async -> @MainActor async/await
@MainActor func loadData() async { }

// Task.sleep(nanoseconds:) -> Task.sleep(for:)
try await Task.sleep(for: .seconds(1))
```

#### Accessibility Requirements
```swift
// onTapGesture -> Button (for VoiceOver)
Button { action() } label: {
    Image(systemName: "star")
}

// All buttons need text labels
Button("Add Item", systemImage: "plus") { addItem() }

// Fixed font sizes -> Dynamic Type
Text("Hello").font(.title2)  // Not .system(size: 24)
```

### SwiftLint Critical Rules

```yaml
# Custom rules (errors)
no_force_cast:
  regex: 'as!'
  severity: error

no_force_try:
  regex: 'try!'
  severity: error

no_print:
  regex: '\bprint\('
  message: "Use ARCLogger instead of print()"
  severity: warning

# Metrics
line_length: 120 (warning) / 150 (error)
file_length: 400 (warning) / 500 (error)
function_body_length: 40 (warning) / 60 (error)
```

### SwiftFormat Key Settings

```
--indent 4
--maxwidth 120
--allman false
--self remove
--type-attributes same-line
--func-attributes same-line
--wraparguments after-first
--wrapparameters after-first
--wrapcollections after-first
--closingparen balanced
```

### Multiline Declarations (after-first)

First parameter on the same line as the opening parenthesis:

```swift
// Correct: first param on first line, aligned
let viewModel = UserViewModel(getUserUseCase: useCase,
                              router: router,
                              analytics: analytics)

// Wrong: first param on new line
// let viewModel = UserViewModel(
//     getUserUseCase: useCase,
//     router: router
// )
```

### Private Extension Pattern

ALL private methods MUST be in a `private extension`, never inside the type body:

```swift
// Correct
final class MyClass {
    // MARK: Public Functions
    func doWork() { helper() }
}

// MARK: - Private Functions
private extension MyClass {
    func helper() { }
}
```

### Naming Conventions

```swift
// Types: PascalCase
struct UserProfile { }
enum LoadingState { }
protocol DataSourceProtocol { }

// Variables/Constants: camelCase
let userName = "John"
var isLoading = false

// Booleans: is/has/should prefix
var isLoading: Bool
var hasPermission: Bool
var shouldRetry: Bool

// Functions: camelCase with descriptive verbs
func loadUser() { }
func validateEmail(_ email: String) -> Bool { }
```

### File Structure

```swift
//
//  FileName.swift
//  ProjectName
//
//  Created by ARC Labs Studio on DD/MM/YYYY.
//

import Foundation
import SwiftUI

// Third-party imports
import ARCLogger
import ARCNavigation

struct UserProfile {

    // MARK: Private Properties
    private(set) var email: String

    // MARK: Public Properties
    let id: UUID
    let name: String

    // MARK: Initialization
    init(id: UUID, name: String, email: String) { }

    // MARK: Public Functions
    func validate() -> Bool { }
}

// MARK: - Private Functions
private extension UserProfile {
    func formatEmail() -> String { }
}

// MARK: - Identifiable
extension UserProfile: Identifiable { }
```

### DocC Documentation

```swift
/// Fetches a user profile from the repository.
///
/// This method first checks the local cache before making a network request.
///
/// - Parameter id: The unique identifier of the user
/// - Returns: The user profile
/// - Throws: `RepositoryError` if the user cannot be fetched
///
/// ## Example
///
/// ```swift
/// let user = try await repository.fetchUser(by: userId)
/// ```
public func fetchUser(by id: UUID) async throws -> User { }
```

### UI Guidelines (Apple HIG)

```swift
// Semantic colors (adapt to dark mode)
Color.primary          // Text color
Color.secondary        // Secondary text
Color.accentColor      // Tint color
Color(.systemBackground)

// Dynamic Type
.font(.body)           // Scales with user settings
.font(.title)

// Safe area respect
.safeAreaInset(edge: .bottom) { }
.ignoresSafeArea(.keyboard)

// Accessibility
.accessibilityLabel("Add new item")
.accessibilityHint("Double tap to add")
```

### Localization

```swift
// All user-facing text must use String(localized:)
Text(String(localized: "welcome_message"))

// Never hardcode strings
// Text("Welcome!")  // BAD
```

## References

For complete guidelines:
- **@references/code-review.md** - AI-generated code review checklist
- **@references/code-style.md** - SwiftLint/SwiftFormat configuration
- **@references/documentation.md** - DocC documentation standards
- **@references/readme-standards.md** - README template
- **@references/package-structure.md** - Package folder organization
- **@references/ui-guidelines.md** - HIG, accessibility, dark mode

## Common Mistakes

- Force unwrapping in production code
- Using `print()` instead of ARCLogger
- Magic numbers without named constants
- Massive files (>500 lines) or functions (>60 lines)
- Missing access control on public APIs
- Stringly-typed code (use enums/structs)
- Fixed font sizes (breaks Dynamic Type)
- Using `onTapGesture` for interactive elements
- Deprecated SwiftUI APIs

## Pre-commit Commands

```bash
# Format code
swiftformat .

# Lint code
swiftlint

# Fix auto-fixable issues
swiftlint --fix

# Check without modifying
swiftformat --lint .
```

## Examples

### Reviewing AI-generated SwiftUI code
User says: "Review this View for quality issues"

1. Check for deprecated APIs (foregroundColor, cornerRadius, NavigationView)
2. Verify accessibility (Button vs onTapGesture, Dynamic Type, labels)
3. Check private extension pattern (no private methods inside type body)
4. Verify multiline style (after-first parameter alignment)
5. Result: List of issues with specific line references and fixes

### Setting up SwiftLint for a new project
User says: "Configure SwiftLint for my package"

1. Install: `brew install swiftlint`
2. Copy `.swiftlint.yml` from ARCDevTools
3. Add custom rules (no_force_cast, no_force_try, no_print)
4. Set up pre-commit hook
5. Result: Automated quality checks on every commit

## Related Skills

| If you need...              | Use                       |
|-----------------------------|---------------------------|
| Architecture decisions      | `/arc-swift-architecture` |
| Writing tests               | `/arc-tdd-patterns`       |
| Git commits/PRs             | `/arc-workflow`           |
| Project setup/ARCDevTools   | `/arc-project-setup`      |
