---
name: arc-localization
description: |
  Localization standards for ARC Labs Studio apps and packages.
  Covers in-app locale switching, String Catalogs, nameKey pattern for domain entities,
  LocalizedStringKey vs String(localized:), navigation title localization, and
  LanguageManager pattern. Use when "localizing strings", "adding translations",
  "fixing locale switching", "language picker", or "string catalog".
user-invocable: true
metadata:
  author: ARC Labs Studio
  version: "1.0.0"
---

# ARC Labs Studio - Localization

## Quick Decision Tree

```
What are you localizing?
├── Navigation title → String(localized:locale:) + @Environment(\.locale)
├── Tab label → LocalizedStringKey via ARCTabItem protocol
├── Domain entity name in a View → LocalizedStringKey(entity.nameKey)
├── Domain entity name for logging → entity.name (String(localized:))
├── Package enum title → var title: LocalizedStringKey
├── Package view title → LocalizedStringKey parameter
└── Menu item subtitle → String(localized:locale:) via ViewModel helper
```

## Core Principle

> **Packages are text-agnostic. Apps own all strings.**

Packages use `LocalizedStringKey`. Apps provide translations via `.xcstrings`.

## The Two-System Problem

| API | Resolves Against | Immediate? |
|-----|-----------------|------------|
| `LocalizedStringKey` | `@Environment(\.locale)` | Yes |
| `String(localized:)` | `Locale.current` (process) | No (cold restart) |
| `String(localized:locale:)` | Explicit Locale | Yes (with @Environment) |

## Key Patterns

### Navigation Titles
```swift
@Environment(\.locale) private var locale
// ...
.navigationTitle(String(localized: "Favorites", locale: locale))
```

### Domain Entity nameKey
```swift
// Domain layer (no SwiftUI)
var nameKey: String { "Italian" }

// Presentation layer
Text(LocalizedStringKey(cuisineType.nameKey))
```

### Package Enums
```swift
public var title: LocalizedStringKey {
    switch self {
    case .system: "System"  // App's xcstrings provides translation
    }
}
```

## Full Reference

See `Quality/localization.md` for complete standards, LanguageManager pattern, and decision matrix.
