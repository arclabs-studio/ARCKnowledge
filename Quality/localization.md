# Localization Standards

**Comprehensive localization standards for ARC Labs Studio apps and packages.**

All ARC Labs apps **MUST** implement these standards for in-app locale switching support.

---

## Core Principle

> **Packages are text-agnostic. Apps own all user-facing strings.**

Packages use `LocalizedStringKey` for display text so the consuming app's String Catalog provides translations. Packages never embed their own `.xcstrings` files.

---

## String Resolution: Two Systems

Understanding the difference is critical for in-app locale switching:

| API | Resolves Against | Updates Immediately? | Use In |
|-----|-----------------|---------------------|--------|
| `LocalizedStringKey` | `@Environment(\.locale)` | Yes | SwiftUI `Text`, `Label`, `Button`, `Tab` |
| `String(localized:)` | `Locale.current` (process locale) | No (cold restart only) | Non-SwiftUI contexts, logging, formatters |
| `String(localized:locale:)` | Explicit `Locale` parameter | Yes (when locale comes from `@Environment`) | Navigation titles, any `String` context in views |

### The Problem

When the user changes language in-app, `.environment(\.locale, newLocale)` updates SwiftUI's locale environment. But `Locale.current` (the process locale) doesn't change until cold restart. So:

- `Text("Favorites")` (LocalizedStringKey) -- updates immediately
- `String(localized: "Favorites")` -- does NOT update until restart
- `String(localized: "Favorites", locale: locale)` with `@Environment(\.locale)` -- updates immediately

---

## Pattern: Navigation Titles

Navigation titles backed by UIKit's `UINavigationBar` do not reliably re-resolve `LocalizedStringKey` on locale change. Use explicit `String(localized:locale:)`:

```swift
struct FavoritesView: View {
    @Environment(\.locale) private var locale

    var body: some View {
        content
            .navigationTitle(String(localized: "Favorites", locale: locale))
    }
}
```

**Rule**: Every view with `.navigationTitle()` must use `String(localized:locale:)` with `@Environment(\.locale)`.

---

## Pattern: Domain Entity Display Names (`nameKey`)

Domain entities must not import SwiftUI. They provide raw localization keys; the Presentation layer converts them to `LocalizedStringKey`.

### Domain Layer

```swift
// Domain/Entities/CuisineType.swift
enum CuisineType: String, Codable, CaseIterable {
    case italian, japanese, mexican

    /// Localized name (resolves against process locale -- for non-SwiftUI contexts)
    var name: String {
        switch self {
        case .italian: String(localized: "Italian")
        case .japanese: String(localized: "Japanese")
        case .mexican: String(localized: "Mexican")
        }
    }

    /// Raw localization key for SwiftUI views (responds to environment locale)
    var nameKey: String {
        switch self {
        case .italian: "Italian"
        case .japanese: "Japanese"
        case .mexican: "Mexican"
        }
    }
}
```

### Presentation Layer

```swift
// In SwiftUI views -- use nameKey for immediate locale response
Text(LocalizedStringKey(cuisineType.nameKey))
Label(LocalizedStringKey(category.nameKey), systemImage: category.icon)

// In non-SwiftUI contexts (logging, analytics) -- use name
logger.debug("Selected cuisine", metadata: ["type": .public(cuisineType.name)])
```

---

## Pattern: Package Components

Package enums and views use `LocalizedStringKey` so the app's String Catalog resolves them:

### Enum Titles

```swift
// In ARCUIComponents package
public enum ARCAppLanguage: String, CaseIterable {
    case system, spanish, english

    public var title: LocalizedStringKey {
        switch self {
        case .system: "System"     // App's xcstrings: "Sistema"
        case .spanish: "Spanish"   // App's xcstrings: "Espanol"
        case .english: "English"   // App's xcstrings: "Ingles"
        }
    }
}
```

### Configurable View Titles

Picker views accept `LocalizedStringKey` parameters with sensible defaults:

```swift
public struct ARCMenuLanguagePickerView: View {
    public init(
        selectedLanguage: Binding<ARCAppLanguage>,
        navigationTitle: LocalizedStringKey = "Language",
        onDone: (() -> Void)? = nil
    ) { ... }
}
```

The app passes localized titles when needed:

```swift
ARCMenuLanguagePickerView(
    selectedLanguage: $viewModel.selectedLanguage,
    navigationTitle: String(localized: "Language", locale: locale),
    onDone: { dismiss() }
)
```

---

## Pattern: Protocol Title Types

Navigation protocols use `LocalizedStringKey` for tab titles:

```swift
// ARCTabItem (ARCUIComponents), NavigationTab (ARCNavigation)
public protocol ARCTabItem {
    var title: LocalizedStringKey { get }  // Not String
    var icon: String { get }
}
```

---

## String Catalog Standards

### File Organization
- One `Localizable.xcstrings` per target (app or extension)
- `InfoPlist.xcstrings` for Info.plist localizations
- Source language: English (`en`)
- Keys are English strings (not identifiers like `SCREEN_TITLE`)

### Key Format
```
"Favorites"        -- navigation title, tab label
"Bug Report"       -- feedback type name
"Price: Low to High"  -- sort option
```

### Build Settings
- **Use Compiler to Extract Swift Strings**: Yes
- **Localization Prefers String Catalogs**: Yes
- **SWIFT_EMIT_LOC_STRINGS**: Yes

---

## LanguageManager Pattern

Mirrors `AppearanceManager`. Manages user preference with immediate SwiftUI re-rendering:

```swift
@Observable @MainActor
final class LanguageManager {
    var language: ARCAppLanguage { didSet { /* persist + AppleLanguages */ } }
    var locale: Locale? { /* maps language to Locale */ }
}

// App root
.environment(\.locale, languageManager.locale ?? Locale.current)
```

---

## Decision Matrix

| Context | Pattern |
|---------|---------|
| Tab labels | `LocalizedStringKey` via protocol (ARCTabItem) |
| Navigation titles | `String(localized:locale:)` + `@Environment(\.locale)` |
| Domain entity names in views | `LocalizedStringKey(entity.nameKey)` |
| Domain entity names for logging | `entity.name` (String(localized:)) |
| Menu item labels | `String(localized:)` in view context |
| Package enum titles | `LocalizedStringKey` property |
| Package view titles | `LocalizedStringKey` parameter |
| Subtitle in `ARCMenuItem` | `String(localized:locale:)` via ViewModel helper |
