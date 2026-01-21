---
name: arc-quality-standards
description: |
  ARC Labs Studio code quality standards and best practices. Covers code review
  checklists for AI-generated code, SwiftLint and SwiftFormat configuration, naming
  conventions, documentation standards with DocC, README templates, package folder
  structure guidelines, UI/UX guidelines following Apple HIG, accessibility (VoiceOver,
  Dynamic Type), dark mode support, and localization. Use when reviewing code,
  setting up linting tools, fixing style issues, writing documentation, creating
  READMEs, organizing package folders, implementing accessibility features, supporting
  dark mode, or ensuring UI follows Human Interface Guidelines.
---

# ARC Labs Studio - Code Quality Standards

## When to Use This Skill

Use this skill when:
- **Reviewing code** (human or AI-generated)
- **Setting up SwiftLint/SwiftFormat** in a project
- **Fixing code style issues** or warnings
- **Writing DocC documentation** for public APIs
- **Creating README files** for packages or projects
- **Organizing package folder structure** by size
- **Implementing accessibility** (VoiceOver, Dynamic Type)
- **Supporting dark mode** properly
- **Following Apple HIG** for UI/UX
- **Localizing user-facing strings**

## Quick Reference

### Code Review Checklist (AI-Generated Code)

#### SwiftUI Deprecated APIs to Replace
```swift
// ❌ foregroundColor() → ✅ foregroundStyle()
Text("Hello").foregroundStyle(.blue)

// ❌ cornerRadius() → ✅ clipShape()
Rectangle().clipShape(.rect(cornerRadius: 12))

// ❌ NavigationView → ✅ NavigationStack
NavigationStack { ContentView() }

// ❌ ObservableObject → ✅ @Observable
@Observable final class ViewModel { }

// ❌ DispatchQueue.main.async → ✅ @MainActor async/await
@MainActor func loadData() async { }

// ❌ Task.sleep(nanoseconds:) → ✅ Task.sleep(for:)
try await Task.sleep(for: .seconds(1))
```

#### Accessibility Requirements
```swift
// ❌ onTapGesture → ✅ Button (for VoiceOver)
Button { action() } label: {
    Image(systemName: "star")
}

// ✅ All buttons need text labels
Button("Add Item", systemImage: "plus") { addItem() }

// ❌ Fixed font sizes → ✅ Dynamic Type
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
```

### Naming Conventions

```swift
// Types: PascalCase
struct UserProfile { }
class NetworkManager { }
enum LoadingState { }
protocol DataSourceProtocol { }

// Variables/Constants: camelCase
let userName = "John"
var isLoading = false
private let apiClient: APIClient

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

### Package Folder Structure

**Small Package (< 10 files)**
```
Sources/PackageName/
├── PackageName.swift       # Main entry point
├── Models/                 # Data models
└── Extensions/             # Swift extensions
```

**Medium Package (10-30 files)**
```
Sources/PackageName/
├── Public/                 # Public API
├── Internal/               # Internal implementation
├── Models/                 # Data models
├── Protocols/              # Protocol definitions
├── Extensions/             # Swift extensions
└── Utilities/              # Helper functions
```

**Large Package (> 30 files)**
```
Sources/PackageName/
├── Public/
│   ├── API/               # Public interfaces
│   └── Models/            # Public models
├── Internal/
│   ├── Services/          # Internal services
│   ├── Repositories/      # Data access
│   └── Managers/          # Business logic
├── Protocols/
├── Extensions/
└── Resources/             # Assets, localization
```

### UI Guidelines (Apple HIG)

```swift
// ✅ Semantic colors (adapt to dark mode)
Color.primary          // Text color
Color.secondary        // Secondary text
Color.accentColor      // Tint color
Color(.systemBackground)

// ✅ Dynamic Type
.font(.body)           // Scales with user settings
.font(.title)
.font(.headline)

// ✅ Safe area respect
.safeAreaInset(edge: .bottom) { }
.ignoresSafeArea(.keyboard)

// ✅ Accessibility
.accessibilityLabel("Add new item")
.accessibilityHint("Double tap to add")
.dynamicTypeSize(...DynamicTypeSize.accessibility3)
```

### Localization

```swift
// ✅ All user-facing text must use String(localized:)
Text(String(localized: "welcome_message"))

// In Localizable.strings (English keys)
"welcome_message" = "Welcome to FavRes!"

// ❌ Never hardcode strings
Text("Welcome!")  // BAD
```

## Detailed Documentation

For complete guidelines:
- **@code-review.md** - AI-generated code review checklist
- **@code-style.md** - SwiftLint/SwiftFormat configuration
- **@documentation.md** - DocC documentation standards
- **@readme-standards.md** - README template
- **@package-structure.md** - Package folder organization
- **@ui-guidelines.md** - HIG, accessibility, dark mode

## Critical Rules (Never Break)

1. **No Force Unwrapping** (`!`, `try!`, `as!`)
2. **No print()** - Use ARCLogger
3. **No Magic Numbers** - Use named constants
4. **No Hardcoded Strings** - Use localization
5. **No Skipping Accessibility** - VoiceOver labels required
6. **No Skipping Dark Mode** - Test both modes
7. **One Type Per File** - Separate files for each type
8. **Public APIs Must Be Documented** - DocC required

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

## Anti-Patterns to Avoid

- ❌ Force unwrapping in production code
- ❌ Using `print()` instead of ARCLogger
- ❌ Magic numbers without named constants
- ❌ Massive files (>500 lines) or functions (>60 lines)
- ❌ Missing access control on public APIs
- ❌ Stringly-typed code (use enums/structs)
- ❌ Fixed font sizes (breaks Dynamic Type)
- ❌ Using `onTapGesture` for interactive elements
- ❌ Deprecated SwiftUI APIs

## Need More Help?

For related topics:
- Architecture patterns → Use `/arc-swift-architecture`
- Testing → Use `/arc-tdd-patterns`
- Git workflow → Use `/arc-workflow`
- Project setup → Use `/arc-project-setup`
