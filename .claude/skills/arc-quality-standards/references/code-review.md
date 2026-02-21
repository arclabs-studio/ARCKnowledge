# 🔍 Code Review Guide

**Quality checklist for reviewing and improving AI-generated Swift code at ARC Labs.**

> 🤖 As AI-assisted development becomes increasingly common, this guide helps identify and fix common issues in AI-generated Swift code, ensuring it meets ARC Labs' professional standards.

---

## Overview

AI tools like Claude Code, GitHub Copilot, and ChatGPT are powerful development assistants, but they often generate code that needs refinement. This guide covers the most common issues to watch for and how to fix them to maintain ARC Labs' quality standards.

**Target Platform**: iOS 17.0+ (Swift 6.0+)

---

## Core Principles

### 1. AI as Assistant, Not Author

- **Review Everything**: Never merge AI-generated code without review
- **Understand First**: Ensure you understand what the code does
- **Test Thoroughly**: AI-generated code must pass the same quality bar as human-written code
- **Iterate**: Use AI to accelerate, not replace, thoughtful development

### 2. Modern Swift Standards

- Prefer Swift 6 concurrency over legacy patterns
- Use latest SwiftUI APIs (not deprecated ones)
- Follow Apple's Human Interface Guidelines
- Maintain accessibility standards

### 3. ARC Labs Quality Bar

All code, regardless of origin, must meet:
- ✅ Swift 6 concurrency compliance
- ✅ Protocol-oriented design
- ✅ 100% test coverage for public APIs (packages)
- ✅ Comprehensive documentation
- ✅ SwiftLint/SwiftFormat compliance

---

## Common Issues & Fixes

### SwiftUI Modifiers

#### ❌ Deprecated: `foregroundColor()`

```swift
// ❌ AI-generated (deprecated)
Text("Hello")
    .foregroundColor(.blue)
```

```swift
// ✅ ARC Labs standard
Text("Hello")
    .foregroundStyle(.blue)
```

**Why**: `foregroundStyle()` supports advanced features like gradients and is not deprecated.

#### ❌ Deprecated: `cornerRadius()`

```swift
// ❌ AI-generated (deprecated)
RoundedRectangle(cornerRadius: 12)
    .cornerRadius(12)
```

```swift
// ✅ ARC Labs standard
Rectangle()
    .clipShape(.rect(cornerRadius: 12))

// ✅ Or for uneven corners
Rectangle()
    .clipShape(.rect(
        topLeadingRadius: 12,
        bottomTrailingRadius: 12
    ))
```

**Why**: `clipShape()` offers more flexibility and is the modern API.

#### ❌ Unsafe: `onChange()` with 1 parameter

```swift
// ❌ AI-generated (unsafe, deprecated)
.onChange(of: value) {
    performAction()
}
```

```swift
// ✅ ARC Labs standard (2 parameters)
.onChange(of: value) { oldValue, newValue in
    performAction(from: oldValue, to: newValue)
}

// ✅ Or no parameters (Swift 6)
.onChange(of: value) {
    performAction()
}
```

**Why**: The old variant is unsafe and doesn't provide old/new values.

---

### Navigation

#### ❌ Deprecated: `NavigationView`

```swift
// ❌ AI-generated (deprecated)
NavigationView {
    ContentView()
}
```

```swift
// ✅ ARC Labs standard
NavigationStack {
    ContentView()
}
```

**Why**: `NavigationStack` is the modern API with better state management.

#### ❌ Old: Inline `NavigationLink` in Lists

```swift
// ❌ AI-generated (performance issues)
List(items) { item in
    NavigationLink(destination: DetailView(item: item)) {
        RowView(item: item)
    }
}
```

```swift
// ✅ ARC Labs standard
List(items) { item in
    RowView(item: item)
        .navigationDestination(for: Item.self) { item in
            DetailView(item: item)
        }
}
```

**Why**: Better performance and supports type-safe navigation.

#### ❌ Old: `tabItem()` modifier

```swift
// ❌ AI-generated (old API)
TabView {
    HomeView()
        .tabItem {
            Label("Home", systemImage: "house")
        }
}
```

```swift
// ✅ ARC Labs standard (iOS 18+)
TabView {
    Tab("Home", systemImage: "house") {
        HomeView()
    }
}
```

**Why**: Type-safe tab selection and modern API features.

---

### State Management

#### ❌ Old: `ObservableObject`

```swift
// ❌ AI-generated (old pattern)
class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var isLoading = false
}
```

```swift
// ✅ ARC Labs standard
@Observable
final class RestaurantViewModel {
    var restaurants: [Restaurant] = []
    var isLoading = false
}
```

**Why**: `@Observable` is simpler, faster, and provides intelligent view invalidation.

#### ⚠️ SwiftData: `@Attribute(.unique)` with CloudKit

```swift
// ⚠️ AI-generated (doesn't work with CloudKit)
@Model
final class Restaurant {
    @Attribute(.unique) var id: UUID
    var name: String
}
```

```swift
// ✅ ARC Labs standard (CloudKit-compatible)
@Model
final class Restaurant {
    @Attribute(.unique) var id: UUID  // Only if NOT using CloudKit
    var name: String
    
    // Or use server-generated unique identifiers
}
```

**Why**: `@Attribute(.unique)` conflicts with CloudKit sync.

---

### Concurrency

#### ❌ Legacy: `DispatchQueue.main.async`

```swift
// ❌ AI-generated (legacy pattern)
func loadData() {
    fetchDataFromAPI { result in
        DispatchQueue.main.async {
            self.data = result
        }
    }
}
```

```swift
// ✅ ARC Labs standard
@MainActor
func loadData() async {
    let result = await fetchDataFromAPI()
    self.data = result
}
```

**Why**: Swift 6 concurrency is safer and more expressive.

#### ❌ Unnecessary: `@MainActor` in new projects

```swift
// ❌ AI-generated (redundant in new projects)
@MainActor
class ContentView: View {
    // ...
}
```

```swift
// ✅ ARC Labs standard (implicit in iOS 17+)
struct ContentView: View {
    // Main actor isolation is automatic
}
```

**Why**: New app projects have main actor isolation by default.

#### ❌ Old: `Task.sleep(nanoseconds:)`

```swift
// ❌ AI-generated (old API)
try await Task.sleep(nanoseconds: 1_000_000_000)
```

```swift
// ✅ ARC Labs standard
try await Task.sleep(for: .seconds(1))
```

**Why**: Modern API is more readable and type-safe.

---

### User Interaction

#### ❌ Poor Accessibility: `onTapGesture()`

```swift
// ❌ AI-generated (accessibility issues)
Image(systemName: "star")
    .onTapGesture {
        toggleFavorite()
    }
```

```swift
// ✅ ARC Labs standard
Button {
    toggleFavorite()
} label: {
    Image(systemName: "star")
}
```

**Why**: Buttons provide proper VoiceOver support and work with eye tracking on visionOS.

#### ❌ Incomplete: Button without accessibility

```swift
// ❌ AI-generated (no text label)
Button(action: addItem) {
    Image(systemName: "plus")
}
```

```swift
// ✅ ARC Labs standard (inline API)
Button("Add Item", systemImage: "plus") {
    addItem()
}

// ✅ Or with Label
Button {
    addItem()
} label: {
    Label("Add Item", systemImage: "plus")
}
```

**Why**: Text labels are essential for VoiceOver users.

---

### Typography & Layout

#### ❌ Fixed Font Sizes

```swift
// ❌ AI-generated (breaks Dynamic Type)
Text("Hello")
    .font(.system(size: 24))
```

```swift
// ✅ ARC Labs standard
Text("Hello")
    .font(.title2)

// ✅ Or with custom scaling (iOS 18+)
Text("Hello")
    .font(.body.scaled(by: 1.5))
```

**Why**: Dynamic Type respects user's accessibility settings.

#### ❌ Overuse: `fontWeight()` vs `bold()`

```swift
// ❌ AI-generated (inconsistent)
Text("Title")
    .fontWeight(.bold)
```

```swift
// ✅ ARC Labs standard
Text("Title")
    .bold()

// Note: These don't always produce the same result
// Use .bold() for semantic boldness
// Use .fontWeight(.semibold) for specific weights
```

#### ❌ Overuse: `GeometryReader`

```swift
// ❌ AI-generated (unnecessary GeometryReader)
GeometryReader { geometry in
    VStack {
        Text("Hello")
            .frame(width: geometry.size.width * 0.8)
    }
}
```

```swift
// ✅ ARC Labs standard
VStack {
    Text("Hello")
        .containerRelativeFrame(.horizontal) { length, _ in
            length * 0.8
        }
}

// ✅ Or use visualEffect
Text("Hello")
    .visualEffect { content, geometry in
        content
            .scaleEffect(geometry.size.width / 100)
    }
```

**Why**: Modern alternatives don't break layout and are more efficient.

---

### Code Organization

#### ❌ Multiple Types in One File

```swift
// ❌ AI-generated (build time impact)
// RestaurantFeature.swift

struct RestaurantView: View { }
class RestaurantViewModel: ObservableObject { }
struct RestaurantRow: View { }
struct RestaurantDetail: View { }
enum RestaurantError: Error { }
```

```swift
// ✅ ARC Labs standard (separate files)

// RestaurantView.swift
struct RestaurantView: View { }

// RestaurantViewModel.swift
@Observable
final class RestaurantViewModel { }

// RestaurantRow.swift
struct RestaurantRow: View { }

// RestaurantDetail.swift
struct RestaurantDetail: View { }

// RestaurantError.swift
enum RestaurantError: Error { }
```

**Why**: Faster incremental builds and better code organization.

#### ❌ Computed Properties Instead of Views

```swift
// ❌ AI-generated (breaks @Observable optimization)
struct ContentView: View {
    var header: some View {
        Text("Header")
            .font(.title)
    }
    
    var body: some View {
        VStack {
            header
            // ...
        }
    }
}
```

```swift
// ✅ ARC Labs standard (separate views)
struct ContentView: View {
    var body: some View {
        VStack {
            HeaderView()
            // ...
        }
    }
}

struct HeaderView: View {
    var body: some View {
        Text("Header")
            .font(.title)
    }
}
```

**Why**: Separate views benefit from `@Observable`'s intelligent invalidation.

---

### Data Handling

#### ❌ Verbose: Array Enumeration

```swift
// ❌ AI-generated (unnecessary Array initializer)
ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
    Text("\(index): \(item.name)")
}
```

```swift
// ✅ ARC Labs standard
ForEach(items.enumerated(), id: \.element.id) { index, item in
    Text("\(index): \(item.name)")
}
```

#### ❌ Verbose: Documents Directory

```swift
// ❌ AI-generated (verbose)
let documentsPath = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
).first!
```

```swift
// ✅ ARC Labs standard
let documentsPath = URL.documentsDirectory
```

#### ❌ Unsafe: C-style Number Formatting

```swift
// ❌ AI-generated (unsafe, harder to localize)
Text(String(format: "%.2f", abs(myNumber)))
```

```swift
// ✅ ARC Labs standard
Text(abs(myNumber), format: .number.precision(.fractionLength(2)))
```

**Why**: Type-safe, localizable, and more maintainable.

---

### Rendering

#### ❌ Old: `UIGraphicsImageRenderer`

```swift
// ❌ AI-generated (old API for SwiftUI)
func render(view: some View) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
        // ...
    }
}
```

```swift
// ✅ ARC Labs standard
func render(view: some View) -> UIImage {
    let renderer = ImageRenderer(content: view)
    return renderer.uiImage ?? UIImage()
}
```

**Why**: `ImageRenderer` is designed for SwiftUI.

---

## Review Checklist

When reviewing AI-generated code, systematically check:

### SwiftUI
- [ ] No deprecated modifiers (`foregroundColor`, `cornerRadius`, old `onChange`)
- [ ] Using `NavigationStack` instead of `NavigationView`
- [ ] Modern tab API instead of `tabItem()`
- [ ] Buttons instead of `onTapGesture()` (except where tap location needed)
- [ ] Dynamic Type instead of fixed font sizes
- [ ] Modern layout APIs instead of excessive `GeometryReader`

### State Management
- [ ] `@Observable` instead of `ObservableObject`
- [ ] No `@Attribute(.unique)` if using CloudKit
- [ ] Proper actor isolation (Swift 6)

### Concurrency
- [ ] `async/await` instead of `DispatchQueue.main.async`
- [ ] `Task.sleep(for:)` instead of nanoseconds
- [ ] No unnecessary `@MainActor` annotations

### Code Organization
- [ ] One type per file
- [ ] Separate views instead of computed properties
- [ ] Proper file structure following ARC Labs standards

### Accessibility
- [ ] All interactive elements use proper controls
- [ ] All buttons have text labels
- [ ] Respect Dynamic Type

### Data & APIs
- [ ] Modern Collection APIs
- [ ] Type-safe formatters
- [ ] Clean, readable code

### Architecture
- [ ] Follows Clean Architecture principles
- [ ] Protocol-oriented design
- [ ] Proper separation of concerns

---

## AI Tool-Specific Issues

### Claude (Anthropic)

**Common Patterns**:
- ✅ Generally good at architecture
- ⚠️ Loves fixed font sizes
- ⚠️ Overuses `GeometryReader`
- ⚠️ Sometimes creates nested computed properties

**Best Practices**:
- Explicitly request Dynamic Type support
- Ask for separate view files
- Request modern SwiftUI APIs

### GitHub Copilot

**Common Patterns**:
- ⚠️ Often suggests deprecated APIs
- ⚠️ Legacy concurrency patterns
- ✅ Good at completing similar patterns

**Best Practices**:
- Review all suggestions carefully
- Use as code completion, not architecture
- Verify API versions

### ChatGPT

**Common Patterns**:
- ⚠️ Training data may be outdated
- ⚠️ Sometimes hallucinates APIs
- ✅ Good at explaining concepts

**Best Practices**:
- Verify all API names exist
- Check Apple documentation
- Ask for specific iOS versions

---

## Hallucinated APIs

AI tools sometimes generate code using **nonexistent APIs** that look plausible but don't exist in the actual frameworks.

### How to Identify

1. **Xcode doesn't autocomplete** the API
2. **Compiler error** with "no such member"
3. **Documentation search** returns nothing
4. **API looks too good to be true**

### What to Do

```swift
// ❌ AI hallucination (doesn't exist)
List(items)
    .smartFilter(by: \.category)  // Not a real modifier
    .autoSort()                    // Not a real modifier
```

1. Search Apple's documentation
2. Check StackOverflow for real solutions
3. Ask AI to provide official documentation link
4. Implement manually if needed

---

## Working Effectively with AI

### Clear Instructions

```swift
// ❌ Vague
"Create a list view"

// ✅ Specific
"Create a SwiftUI List view using @Observable for state management,
navigationDestination for navigation, and Dynamic Type for fonts.
Target iOS 17+. Follow ARC Labs architecture with MVVM pattern."
```

### Iterative Refinement

1. **Generate**: Let AI create initial implementation
2. **Review**: Apply this checklist
3. **Refine**: Request specific improvements
4. **Verify**: Test and validate
5. **Document**: Add proper documentation

### Context Provision

Always provide:
- Target iOS version
- Architecture requirements
- Specific frameworks in use
- Accessibility needs
- Performance requirements

### Example Prompt

```
Create a restaurant list view following these requirements:

Architecture:
- MVVM pattern with @Observable ViewModel
- Protocol-oriented Repository
- Clean Architecture layers

Technical:
- iOS 17+ target
- Swift 6 concurrency
- SwiftData for persistence
- Dynamic Type support
- Full VoiceOver accessibility

UI:
- NavigationStack with navigationDestination
- Modern Tab API
- Proper buttons (no onTapGesture)
- ARC Labs Liquid Glass design system

Follow the patterns in ARCStorage and ARCDesignSystem packages.
```

---

## Testing AI-Generated Code

### Unit Tests

```swift
// Always verify AI-generated logic
@Test func calculateScore_withValidInput_returnsExpectedScore() async throws {
    let calculator = ScoreCalculator()
    let score = try calculator.calculate(rating: 5.0, visits: 10)
    #expect(score > 0)
    #expect(score <= 100)
}
```

### UI Tests

```swift
// Verify interactions work as expected
@Test func addButton_whenTapped_createsNewItem() async throws {
    let app = XCUIApplication()
    app.launch()
    
    let initialCount = app.tables.cells.count
    app.buttons["Add Item"].tap()
    
    #expect(app.tables.cells.count == initialCount + 1)
}
```

### Accessibility Audits

- Run Accessibility Inspector
- Test with VoiceOver enabled
- Verify Dynamic Type scaling
- Check color contrast

---

## When NOT to Use AI

AI-assisted coding is powerful, but there are cases where human expertise is essential:

### Architecture Decisions

- ❌ Don't let AI design your architecture
- ✅ Use AI to implement patterns you've defined

### Security & Privacy

- ❌ Don't trust AI with sensitive data handling
- ✅ Review all security-critical code manually

### Performance Optimization

- ❌ Don't assume AI code is optimal
- ✅ Profile and optimize manually

### Complex Business Logic

- ❌ Don't trust AI with critical algorithms
- ✅ Verify with thorough testing

---

## Continuous Learning

### Stay Updated

- Follow [Swift Evolution](https://github.com/apple/swift-evolution)
- Read [Apple Documentation](https://developer.apple.com/documentation/)
- Check [Hacking with Swift](https://www.hackingwithswift.com/)
- Review WWDC sessions

### Update This Guide

As Swift and SwiftUI evolve:
1. Document new deprecated APIs
2. Add modern alternatives
3. Share learnings with team
4. Update AI prompts

---

## Resources

- [Swift Evolution](https://github.com/apple/swift-evolution)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Hacking with Swift](https://www.hackingwithswift.com/)
- [Swift by Sundell](https://www.swiftbysundell.com/)
- [ARC Labs Architecture Docs](../Architecture/)

---

## Summary

AI-assisted development is a powerful tool, but it requires careful review and refinement. By systematically checking for these common issues and following ARC Labs standards, you can leverage AI to accelerate development while maintaining the high quality bar that defines our work.

**Remember**:
1. ✅ Review every AI suggestion
2. ✅ Apply this checklist systematically
3. ✅ Test thoroughly
4. ✅ Maintain ARC Labs standards
5. ✅ Document and share learnings

AI is a tool to amplify your expertise, not replace it. Use it wisely, review carefully, and never compromise on quality.
