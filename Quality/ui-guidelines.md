# 🎨 UI Guidelines

**Comprehensive UI/UX guidelines for ARC Labs apps, based on Apple Human Interface Guidelines (HIG).**

All ARC Labs apps **MUST** implement these guidelines. This is not optional.

---

## 🎯 Overview

This document covers:
1. **SF Symbols & Animations** - When and how to animate system symbols
2. **Dark/Light Mode** - Appearance adaptation requirements
3. **Accessibility** - VoiceOver, Dynamic Type, and more
4. **Localization** - Multi-language support

---

## 🔣 SF Symbols & Animations

SF Symbols provide consistent iconography across Apple platforms. Animations should be **purposeful**, not decorative.

### When to Use Animations

| Use Case | Recommended Effect | Example |
|----------|-------------------|---------|
| Confirm an action | `.bounce` | Add to favorites |
| Indicate ongoing activity | `.pulse`, `.variableColor` | Loading data |
| State change | `.replace` | Toggle on/off |
| Call attention | `.wiggle` | Pending action |
| Progress indication | `.variableColor` | Download progress |

### When NOT to Use Animations

- **Frequent interactions** - "Avoid adding motion to UI interactions that occur frequently"
- **No clear purpose** - "Don't add motion for the sake of adding motion"
- **Decorative icons** - Static information only
- **Tab bars** - Used constantly, animations would be distracting

### Implementation

```swift
// ✅ Good: Bounce on favorite action (infrequent, confirms action)
Button {
    viewModel.onTappedFavorite()
} label: {
    Image(systemName: isFavorite ? "heart.fill" : "heart")
        .symbolEffect(.bounce, value: isFavorite)
}

// ✅ Good: Pulse during loading (indicates activity)
Image(systemName: "arrow.clockwise")
    .symbolEffect(.pulse, isActive: isLoading)

// ✅ Good: Variable color for progress
Image(systemName: "wifi")
    .symbolEffect(.variableColor.iterative, isActive: isConnecting)

// ✅ Good: Replace for state toggle
Image(systemName: isPlaying ? "pause.fill" : "play.fill")
    .contentTransition(.symbolEffect(.replace))

// ❌ Bad: Animation on tab bar icon
TabView {
    HomeView()
        .tabItem {
            Image(systemName: "house")
                .symbolEffect(.bounce)  // Never animate tab icons!
        }
}

// ❌ Bad: Animation without purpose
Image(systemName: "star")
    .symbolEffect(.wiggle)  // Why is it wiggling?
```

### Reduce Motion Support

**Always** respect the user's accessibility preferences:

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

var body: some View {
    Image(systemName: "heart.fill")
        .symbolEffect(
            reduceMotion ? .none : .bounce,
            value: isFavorite
        )
}
```

---

## 🌗 Dark/Light Mode Support

**Requirement**: Every view must render correctly in both light and dark modes.

### Implementation Guidelines

```swift
// ✅ Good: Use semantic colors
Text("Title")
    .foregroundStyle(.primary)

Text("Subtitle")
    .foregroundStyle(.secondary)

// ✅ Good: Use asset catalog colors with light/dark variants
Text("Brand")
    .foregroundStyle(Color("BrandPrimary"))

// ❌ Bad: Hardcoded colors
Text("Title")
    .foregroundStyle(.black)  // Invisible in dark mode!
```

### Asset Catalog Setup

```
Assets.xcassets/
├── Colors/
│   ├── BrandPrimary.colorset/    # Define Any, Light, Dark variants
│   ├── BackgroundPrimary.colorset/
│   └── TextSecondary.colorset/
```

### Preview Testing

```swift
#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
```

### Color Best Practices

| Use Case | Recommended Approach |
|----------|---------------------|
| Text | `.primary`, `.secondary`, `.tertiary` |
| Backgrounds | `.background`, asset catalog colors |
| Accents | Asset catalog with variants |
| Borders/Separators | `.separator`, `.quaternary` |
| Tints | `.tint`, `.accentColor` |

---

## ♿ Accessibility

**Requirement**: Every interactive element must be accessible via VoiceOver.

### 1. Accessibility Labels

```swift
// ✅ Good: Descriptive label for icons/images
Button(action: addItem) {
    Image(systemName: "plus")
}
.accessibilityLabel("Add new item")

// ✅ Good: Custom label when text isn't descriptive enough
Text("$42.99")
    .accessibilityLabel("Price: 42 dollars and 99 cents")

// ✅ Good: Combine related elements
HStack {
    Image("restaurant-icon")
    Text(restaurant.name)
    Text(restaurant.rating)
}
.accessibilityElement(children: .combine)
.accessibilityLabel("\(restaurant.name), rated \(restaurant.rating) stars")
```

### 2. Accessibility Hints

```swift
Button("Submit") {
    viewModel.onTappedSubmit()
}
.accessibilityHint("Double tap to submit your order")
```

### 3. Accessibility Traits

```swift
Text("Welcome to FavRes")
    .font(.largeTitle)
    .accessibilityAddTraits(.isHeader)

Button("Delete", role: .destructive) {
    viewModel.onTappedDelete()
}
.accessibilityAddTraits(.isButton)  // Automatic for Button, but explicit is clearer
```

### 4. Dynamic Type Support

```swift
// ✅ Good: Use system text styles
Text("Title")
    .font(.title)

Text("Body content")
    .font(.body)

// ✅ Good: Custom font with scaling
Text("Custom")
    .font(.custom("Avenir", size: 16, relativeTo: .body))

// ❌ Bad: Fixed font size (won't scale)
Text("Fixed")
    .font(.system(size: 16))
```

### 5. Reduce Motion Support

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

var body: some View {
    content
        .animation(reduceMotion ? .none : .spring(), value: isExpanded)
}
```

### Common Accessibility Patterns

#### Buttons Without Text

```swift
// ❌ Bad: Icon-only button without label
Button(action: share) {
    Image(systemName: "square.and.arrow.up")
}

// ✅ Good: Icon button with accessibility label
Button(action: share) {
    Image(systemName: "square.and.arrow.up")
}
.accessibilityLabel("Share")
```

#### Custom Controls

```swift
// ❌ Bad: Tap gesture without accessibility
Circle()
    .onTapGesture { selectItem() }

// ✅ Good: Use Button for accessibility support
Button(action: selectItem) {
    Circle()
}
.accessibilityLabel("Select item")
```

---

## 🌍 Localization

All ARC Labs apps **MUST** support localization from the start.

### Supported Languages

| Language | Code | Status |
|----------|------|--------|
| English | `en` | **Base language** |
| Spanish | `es` | Required |

### Configuration

#### 1. Project Setup

In Xcode project settings:
1. **Info** → **Localizations** → Add `Spanish (es)`
2. Development Language: **English**
3. Use **String Catalogs** (`.xcstrings`) for all localizable content

#### 2. Directory Structure

```
Resources/
├── Localizable.xcstrings       # Main strings catalog
├── InfoPlist.xcstrings         # Info.plist localizations
└── Assets.xcassets/            # Localized images if needed
```

### String Catalog Usage

#### Key Naming Convention

Keys **MUST** be written in English and follow these patterns:

```
<feature>.<screen>.<element>.<context>
```

**Examples:**

```swift
// Feature.Screen.Element
"home.restaurants.title"           // → "Restaurants" / "Restaurantes"
"home.restaurants.empty_state"     // → "No restaurants found" / "No se encontraron restaurantes"

// Feature.Screen.Element.Context
"restaurant.detail.button.favorite"    // → "Add to Favorites" / "Añadir a Favoritos"
"restaurant.detail.button.unfavorite"  // → "Remove from Favorites" / "Quitar de Favoritos"

// Common/Shared
"common.button.cancel"            // → "Cancel" / "Cancelar"
"common.button.save"              // → "Save" / "Guardar"
"common.error.network"            // → "Network error" / "Error de red"
```

#### Code Implementation

```swift
// ✅ Good: Use String(localized:) with table
Text(String(localized: "home.restaurants.title"))

// ✅ Good: With comment for translators
Text(String(localized: "home.restaurants.title",
            comment: "Navigation title for restaurant list"))

// ✅ Good: String interpolation
let count = 5
Text(String(localized: "home.restaurants.count \(count)",
            comment: "Number of restaurants found"))
// In .xcstrings: "home.restaurants.count %lld" → "%lld restaurants" / "%lld restaurantes"

// ✅ Good: Pluralization (handled in String Catalog)
Text(String(localized: "home.restaurants.count \(count)"))
// String Catalog handles: "1 restaurant" vs "5 restaurants"

// ❌ Bad: Hardcoded strings
Text("Restaurants")  // Not localizable!

// ❌ Bad: Concatenation
Text("Found " + String(count) + " restaurants")  // Grammar issues in other languages!
```

#### String Catalog Structure

In `Localizable.xcstrings`:

```json
{
  "sourceLanguage": "en",
  "strings": {
    "home.restaurants.title": {
      "localizations": {
        "en": { "stringUnit": { "value": "Restaurants" } },
        "es": { "stringUnit": { "value": "Restaurantes" } }
      }
    },
    "home.restaurants.count %lld": {
      "localizations": {
        "en": {
          "variations": {
            "plural": {
              "one": { "stringUnit": { "value": "%lld restaurant" } },
              "other": { "stringUnit": { "value": "%lld restaurants" } }
            }
          }
        },
        "es": {
          "variations": {
            "plural": {
              "one": { "stringUnit": { "value": "%lld restaurante" } },
              "other": { "stringUnit": { "value": "%lld restaurantes" } }
            }
          }
        }
      }
    }
  }
}
```

---

## ✅ UI Guidelines Checklist

### SF Symbols & Animations
- [ ] Animations have clear purpose (confirm, indicate, alert)
- [ ] No animations on frequently used controls
- [ ] No animations on tab bar icons
- [ ] Respects `accessibilityReduceMotion`

### Dark/Light Mode
- [ ] Uses semantic colors (`.primary`, `.secondary`)
- [ ] Custom colors defined in asset catalog with variants
- [ ] No hardcoded colors (`.black`, `.white`)
- [ ] Tested in both light and dark mode
- [ ] Previews include both color schemes

### Accessibility
- [ ] All interactive elements have accessibility labels
- [ ] Icons/images have descriptive labels
- [ ] Complex views use `.accessibilityElement(children: .combine)`
- [ ] Headers marked with `.isHeader` trait
- [ ] All text uses Dynamic Type (system fonts or `.relativeTo:`)
- [ ] Animations respect `accessibilityReduceMotion`
- [ ] Uses `Button` instead of `onTapGesture` for interactivity
- [ ] Tested with VoiceOver enabled
- [ ] Tested with larger accessibility text sizes

### Localization
- [ ] All user-facing strings use `String(localized:)`
- [ ] Keys follow naming convention: `feature.screen.element`
- [ ] English translations provided (base)
- [ ] Spanish translations provided
- [ ] Pluralization handled for countable items
- [ ] No hardcoded strings in Views
- [ ] No string concatenation for sentences
- [ ] Date/time formatting uses `formatted()` (auto-localizes)
- [ ] Number formatting uses `formatted()` (auto-localizes)
- [ ] Tested with Spanish locale in simulator

---

## 📚 Further Reading

- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)
- [SF Symbols Guidelines](https://developer.apple.com/design/human-interface-guidelines/sf-symbols)
- [Accessibility Guidelines](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [Localization Best Practices](https://developer.apple.com/documentation/xcode/localization)

---

**Remember**: Great UI is invisible—users should focus on their tasks, not fight the interface. Make it accessible, adaptable, and delightful.
