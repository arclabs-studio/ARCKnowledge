# 📱 iOS Apps

**iOS Apps at ARC Labs are private, product-focused applications that deliver delightful user experiences using our reusable package infrastructure.**

---

## 🎯 App Philosophy

### Core Principles

1. **Simple, Lovable, Complete** - Every feature is intuitive, delightful, and fully realized
2. **Feature-Focused** - Apps implement business logic, not infrastructure
3. **Package-Powered** - Leverage ARC Labs packages for infrastructure
4. **User-First** - Prioritize UX over technical complexity
5. **Quality-Conscious** - 60%+ test coverage target, 80% ideal
6. **Native-First** - Embrace Apple frameworks and design patterns

### App Goals

- **Delightful UX** - Users love the experience
- **Reliable** - Stable, predictable behavior
- **Maintainable** - Easy to understand and modify
- **Scalable** - Can grow with user needs

---

## 📱 Current ARC Labs Studio Projects

### FavRes - Restaurant Discovery
**Purpose**: Discover and manage favorite restaurants

**Key Features**:
- Restaurant search and discovery
- Personal favorites management
- Map-based exploration
- Place details and reviews

### FavBook - Book Tracking
**Purpose**: Track and manage book reading

**Key Features**:
- Book search and cataloging
- Reading progress tracking
- Personal library management
- Reading recommendations

### Pizzeria La Famiglia (iOS and Vapor) - Restaurant management
**Purpose**: Full-Stack for bussiness management (delivery and booking)

**Key Features**:
- User Management: Registration, login, profile management with JWT authentication
- Multi-Location Support: Two physical restaurant locations with delivery zones
- Menu System: Categories, items, with availability and dietary flags
- Shopping Cart: Persistent cart with item customization
- Order Management: Complete order lifecycle with status tracking
- Reservations: Table booking system with confirmation workflow
- Admin APIs: Restaurant management endpoints
- Payment Abstraction: Ready for integration with payment gateways (Stripe, Redsys, etc.)

### TicketMind - Domestic spending tracker
**Purpose**: Scan physical and digital receipts, extract line items automatically, and analyze your household spending—all

**Key Features**:
- Scan physical receipts with your camera
- Import digital receipts (PDF, images) from email or Files
- Extract items automatically using on-device OCR
- Analyze spending by category, store, and time period
- Keep private: all data stored locally with SwiftData

---

## 🏗️ App Structure

### Standard Directory Layout

```
FavRes/
├── FavRes.xcodeproj
├── FavRes/
│   ├── App/
│   │   ├── FavResApp.swift
│   │   └── AppDelegate.swift (if needed)
│   │
│   ├── Presentation/
│   │   ├── Features/
│   │   │   ├── Home/
│   │   │   │   ├── View/
│   │   │   │   │   ├── HomeView.swift
│   │   │   │   │   └── RestaurantCardView.swift
│   │   │   │   ├── ViewModel/
│   │   │   │   │   └── HomeViewModel.swift
│   │   │   │   └── Router/
│   │   │   │       └── HomeRouter.swift
│   │   │   │
│   │   │   ├── RestaurantDetail/
│   │   │   │   ├── View/
│   │   │   │   ├── ViewModel/
│   │   │   │   └── Router/
│   │   │   │
│   │   │   └── Search/
│   │   │       ├── View/
│   │   │       ├── ViewModel/
│   │   │       └── Router/
│   │   │
│   │   └── Shared/
│   │       ├── Components/
│   │       └── Modifiers/
│   │
│   ├── Domain/
│   │   ├── Entities/
│   │   │   ├── Restaurant.swift
│   │   │   └── Review.swift
│   │   └── UseCases/
│   │       ├── GetRestaurantsUseCase.swift
│   │       └── SaveFavoriteUseCase.swift
│   │
│   ├── Data/
│   │   ├── Repositories/
│   │   │   └── RestaurantRepositoryImpl.swift
│   │   ├── DataSources/
│   │   │   ├── Remote/
│   │   │   └── Local/
│   │   └── Models/
│   │       └── RestaurantDTO.swift
│   │
│   └── Resources/
│       ├── Assets.xcassets
│       ├── Localizable.xcstrings
│       └── Info.plist
│
├── FavResTests/
│   ├── Presentation/
│   ├── Domain/
│   └── Data/
│
└── FavResUITests/ (deferred)
```

### Feature Organization

Each feature follows MVVM+C structure:

```
FeatureName/
├── View/           # SwiftUI Views
├── ViewModel/      # State management & coordination
└── Router/         # Navigation (if complex)
```

---

## 📦 Package Dependencies

### Required Packages (All Apps)

```swift
// Package.swift or Xcode project
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCDesignSystem", from: "1.0.0"),
    .package(url: "https://github.com/arclabs-studio/ARCDevTools", from: "1.0.0"),
    .package(url: "https://github.com/arclabs-studio/ARCLogger", from: "1.0.0")
    .package(url: "https://github.com/arclabs-studio/ARCMetrics", from: "1.0.0"),
    .package(url: "https://github.com/arclabs-studio/ARCNavigation", from: "1.0.0"),
    .package(url: "https://github.com/arclabs-studio/ARCStorage", from: "1.0.0"),
    .package(url: "https://github.com/arclabs-studio/ARCUIComponents", from: "1.0.0")
]
```
**ARCDesignSystem**: Consistent design system
- Configure typography
- Configure colors
- Configure accessibility

**ARCDevTools**: Development tooling
- SwiftLint configuration
- SwiftFormat rules
- Quality standards

**ARCLogger**: Logging infrastructure
- Structured logging
- Privacy-conscious
- Multiple destinations

**ARCMetrics**: Implementing analytics
- Apple MetricKit
- TelemetryDeck

**ARCNavigation**: Type-safe routing
- MVVM+C navigation
- Testable flows
- Compile-time safety

**ARCStorage**: Use when app needs:
- SwiftData persistence
- CloudKit sync
- Caching layer
- Keychain storage

**ARCUIComponents**: Custom components
- Reusable UI components
- "Liquid Glass" aesthetic

### Optional Packages (As Needed)

```swift
.package(url: "https://github.com/arclabs-studio/ARCIntelligence", from: "1.0.0"),
.package(url: "https://github.com/arclabs-studio/ARCMaps", from: "1.0.0")
```

**ARCFirebase**: Use when app needs:
- Auth
- Analytics
- Crashlytics
- Firestore
- RemoteConfig

**ARCIntelligence**: Use when app needs:
- IA from different models

**ARCMaps**: Use when app needs:
- Map integration
- Place search
- Location features

**ARCNetworking**: Use when app needs:
- Network connectivity

---

## 🎨 App Architecture

### Clean Architecture Layers

**Presentation Layer** (Views, ViewModels, Routers)
- SwiftUI views for UI
- ViewModels for state & coordination
- Routers for navigation

**Domain Layer** (Entities, Use Cases)
- Business entities (Restaurant, User, etc.)
- Business logic (Use Cases)
- Repository protocols

**Data Layer** (Repositories, Data Sources)
- Repository implementations
- API clients (remote data)
- Database managers (local data)
- DTOs for API mapping

### Dependency Flow

```
Views → ViewModels → Use Cases → Repositories
  ↓         ↓            ↓            ↓
Router   Logger      Logger      Data Sources
```

**Rule**: Dependencies flow **inward**. Outer layers depend on inner layers, never reverse.

---

## 🚀 App Initialization

### FavResApp.swift

```swift
import ARCLogger
import ARCNavigation
import SwiftUI

@main
struct FavResApp: App {
    
    // MARK: Private Properties
    
    @State private var router = Router<AppRoute>()
    
    // MARK: Initialization
    
    init() {
        setupLogging()
        setupAppearance()
    }
    
    // MARK: View
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withRouter(router) { $0.view() }
                .onAppear {
                    ARCLogger.shared.info("App launched")
                }
        }
    }
}

// MARK: - Private Functions

private extension FavResApp {    
    func setupLogging() {
        ARCLogger.configure(
            minimumLevel: .debug,
            destinations: [ConsoleDestination()]
        )
    }
    
    func setupAppearance() {
        // Configure global UI appearance
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }
}
```

---

## 🧩 Feature Implementation Pattern

### Example: Restaurant List Feature

#### 1. Entity (Domain)

```swift
// Domain/Entities/Restaurant.swift

import Foundation

/// Represents a restaurant in the system.
struct Restaurant: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let cuisine: String
    let rating: Double
    let priceLevel: Int
    let imageURL: URL?
    let isFavorite: Bool
    
    var displayRating: String {
        String(format: "%.1f", rating)
    }
    
    var displayPrice: String {
        String(repeating: "$", count: priceLevel)
    }
}

// MARK: - Mock Data

extension Restaurant {
    static var mock: Restaurant {
        Restaurant(
            id: UUID(),
            name: "The Italian Kitchen",
            cuisine: "Italian",
            rating: 8.5,
            priceLevel: 2,
            imageURL: nil,
            isFavorite: false
        )
    }
}
```

#### 2. Use Case (Domain)

```swift
// Domain/UseCases/GetRestaurantsUseCase.swift

import Foundation

protocol GetRestaurantsUseCaseProtocol: Sendable {
    func execute() async throws -> [Restaurant]
}

final class GetRestaurantsUseCase {
    
    // MARK: Private Properties
    
    private let repository: RestaurantRepositoryProtocol
    
    // MARK: Initialization
    
    init(repository: RestaurantRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - GetRestaurantsUseCaseProtocol

extension GetRestaurantsUseCase: GetRestaurantsUseCaseProtocol {
    func execute() async throws -> [Restaurant] {
        let restaurants = try await repository.getRestaurants()
        
        // Business logic: Sort by rating
        return restaurants.sorted { $0.rating > $1.rating }
    }
}
```

#### 3. Repository Protocol (Domain)

```swift
// Domain/Repositories/RestaurantRepositoryProtocol.swift

import Foundation

protocol RestaurantRepositoryProtocol: Sendable {
    func getRestaurants() async throws -> [Restaurant]
    func getRestaurant(by id: UUID) async throws -> Restaurant
    func toggleFavorite(_ restaurant: Restaurant) async throws
}
```

#### 4. Repository Implementation (Data)

```swift
// Data/Repositories/RestaurantRepositoryImpl.swift

import ARCLogger
import Foundation

final class RestaurantRepositoryImpl: RestaurantRepositoryProtocol {
    
    // MARK: Private Properties
    
    private let remoteDataSource: RestaurantRemoteDataSourceProtocol
    private let localDataSource: RestaurantLocalDataSourceProtocol
    
    // MARK: Initialization
    
    init(
        remoteDataSource: RestaurantRemoteDataSourceProtocol,
        localDataSource: RestaurantLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
}

// MARK: - RestaurantRepositoryProtocol

extension RestaurantRepositoryImpl: RestaurantRepositoryProtocol {
    func getRestaurants() async throws -> [Restaurant] {
        ARCLogger.shared.debug("Fetching restaurants")
        
        // Try cache first
        if let cached = try? await localDataSource.getRestaurants(),
           !cached.isEmpty {
            ARCLogger.shared.debug("Returning \(cached.count) cached restaurants")
            return cached.map { $0.toDomain() }
        }
        
        // Fetch from remote
        let dtos = try await remoteDataSource.fetchRestaurants()
        ARCLogger.shared.info("Fetched \(dtos.count) restaurants from API")
        
        // Cache for next time
        try? await localDataSource.saveRestaurants(dtos)
        
        return dtos.map { $0.toDomain() }
    }
    
    func getRestaurant(by id: UUID) async throws -> Restaurant {
        let dto = try await remoteDataSource.fetchRestaurant(by: id)
        return dto.toDomain()
    }
    
    func toggleFavorite(_ restaurant: Restaurant) async throws {
        try await localDataSource.toggleFavorite(restaurantId: restaurant.id)
    }
}

```

#### 5. ViewModel (Presentation)

```swift
// Presentation/Features/Home/ViewModel/HomeViewModel.swift

import ARCLogger
import ARCNavigation
import Foundation

@MainActor
@Observable
final class HomeViewModel {
    
    // MARK: Private Properties
    
    private(set) var restaurants: [Restaurant] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
        
    private let getRestaurantsUseCase: GetRestaurantsUseCaseProtocol
    private let router: Router<AppRoute>
    
    // MARK: Initialization
    
    init(
        getRestaurantsUseCase: GetRestaurantsUseCaseProtocol,
        router: Router<AppRoute>
    ) {
        self.getRestaurantsUseCase = getRestaurantsUseCase
        self.router = router
    }
    
    // MARK: - Public Functions
    
    func onAppear() async {
        await loadRestaurants()
    }
    
    func onTappedRestaurant(_ restaurant: Restaurant) {
        ARCLogger.shared.info("User tapped restaurant", metadata: [
            "restaurantId": restaurant.id.uuidString,
            "restaurantName": restaurant.name
        ])
        router.navigate(to: .restaurantDetail(restaurant))
    }
    
    func onPulledToRefresh() async {
        await loadRestaurants()
    }
}

// MARK: - Private Functions

private extension HomeViewModel {
    func loadRestaurants() async {
        isLoading = true
        errorMessage = nil
        
        do {
            restaurants = try await getRestaurantsUseCase.execute()
            ARCLogger.shared.debug("Loaded \(restaurants.count) restaurants")
        } catch {
            errorMessage = "Failed to load restaurants"
            ARCLogger.shared.error("Failed to load restaurants", metadata: [
                "error": error.localizedDescription
            ])
        }
        
        isLoading = false
    }
}
```

#### 6. View (Presentation)

```swift
// Presentation/Features/Home/View/HomeView.swift

import ARCNavigation
import SwiftUI

struct HomeView: View {
    
    // MARK: Private Properties
    
    @State private var viewModel: HomeViewModel
    
    // MARK: Initialization
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading restaurants...")
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Unable to Load",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else if viewModel.restaurants.isEmpty {
                    ContentUnavailableView(
                        "No Restaurants",
                        systemImage: "fork.knife",
                        description: Text("No restaurants found")
                    )
                } else {
                    restaurantList
                }
            }
            .navigationTitle("Restaurants")
            .refreshable {
                await viewModel.onPulledToRefresh()
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

// MARK: - Private Views

private extension HomeView {
    var restaurantList: some View {
        List(viewModel.restaurants) { restaurant in
            RestaurantCardView(restaurant: restaurant)
                .onTapGesture {
                    viewModel.onTappedRestaurant(restaurant)
                }
        }
        .listStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Loading") {
    let mockUseCase = MockGetRestaurantsUseCase()
    mockUseCase.executeDelay = 10
    
    let viewModel = HomeViewModel(
        getRestaurantsUseCase: mockUseCase,
        router: Router()
    )
    
    return HomeView(viewModel: viewModel)
}

#Preview("Success") {
    let mockUseCase = MockGetRestaurantsUseCase()
    mockUseCase.executeResult = .success([.mock, .mock, .mock])
    
    let viewModel = HomeViewModel(
        getRestaurantsUseCase: mockUseCase,
        router: Router()
    )
    
    return HomeView(viewModel: viewModel)
}

#Preview("Error") {
    let mockUseCase = MockGetRestaurantsUseCase()
    mockUseCase.executeResult = .failure(TestError.networkError)
    
    let viewModel = HomeViewModel(
        getRestaurantsUseCase: mockUseCase,
        router: Router()
    )
    
    return HomeView(viewModel: viewModel)
}
```

---

## 🧪 Testing Strategy

### Coverage Requirements

**Apps**: 60% minimum, 80% target

### What to Test

✅ **ALWAYS Test**:
- ViewModels (state, coordination, user actions)
- Use Cases (business logic)
- Repositories (data access)
- Entities (validation, computed properties)

❌ **DON'T Test** (for now):
- Views (UI testing deferred)
- Navigation flows (deferred)

### Example ViewModel Test

```swift
import Testing
@testable import FavRes

@MainActor
@Suite("Home ViewModel Tests")
struct HomeViewModelTests {
    
    @Test("Load restaurants updates state")
    func loadRestaurants_updatesState() async {
        // Arrange
        let mockUseCase = MockGetRestaurantsUseCase()
        mockUseCase.executeResult = .success([.mock, .mock])
        let viewModel = HomeViewModel(
            getRestaurantsUseCase: mockUseCase,
            router: Router()
        )
        
        // Act
        await viewModel.onAppear()
        
        // Assert
        #expect(viewModel.restaurants.count == 2)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Tapping restaurant navigates")
    func tappingRestaurant_navigates() {
        // Arrange
        let mockRouter = MockRouter<AppRoute>()
        let viewModel = HomeViewModel(
            getRestaurantsUseCase: MockGetRestaurantsUseCase(),
            router: mockRouter as! Router<AppRoute>
        )
        let restaurant = Restaurant.mock
        
        // Act
        viewModel.onTappedRestaurant(restaurant)
        
        // Assert
        #expect(mockRouter.navigateCalled == true)
    }
}
```

---

## 📋 App Checklist

Before releasing a feature:

### Code Quality
- [ ] 60%+ test coverage (target 80%)
- [ ] All tests pass
- [ ] SwiftLint passes
- [ ] SwiftFormat applied
- [ ] No force unwrapping in production code

### Architecture
- [ ] Clean Architecture followed
- [ ] MVVM+C pattern used
- [ ] Dependencies properly injected
- [ ] Business logic in Use Cases
- [ ] No business logic in Views

### UX & States
- [ ] Loading states handled
- [ ] Error states handled
- [ ] Empty states handled

### Accessibility & Appearance (Required)
- [ ] All interactive elements have VoiceOver labels
- [ ] Dynamic Type supported (system fonts or `.relativeTo:`)
- [ ] Animations respect `accessibilityReduceMotion`
- [ ] View renders correctly in light mode
- [ ] View renders correctly in dark mode
- [ ] Tested with VoiceOver enabled

### Localization (Required)
- [ ] All user-facing strings use `String(localized:)`
- [ ] Keys follow naming convention: `feature.screen.element`
- [ ] English translations provided (base)
- [ ] Spanish translations provided
- [ ] No hardcoded strings in Views

### Integration
- [ ] ARCLogger used for logging
- [ ] ARCNavigation used for routing
- [ ] ARCDevTools integrated
- [ ] Builds and runs on device

---

## 🚫 Common Mistakes

### Mistake 1: Business Logic in View

```swift
// ❌ WRONG
struct RestaurantView: View {
    var body: some View {
        Button("Save") {
            // Business logic in View!
            if restaurant.rating > 4.0 {
                saveToFavorites()
            }
        }
    }
}

// ✅ RIGHT
struct RestaurantView: View {
    let viewModel: RestaurantViewModel
    
    var body: some View {
        Button("Save") {
            viewModel.onTappedSave()  // ViewModel handles logic
        }
    }
}
```

### Mistake 2: Not Using Packages

```swift
// ❌ WRONG: Reimplementing infrastructure
class AppLogger {
    static func log(_ message: String) {
        print(message)
    }
}

// ✅ RIGHT: Use ARCLogger
import ARCLogger

ARCLogger.shared.info("User logged in")
```

---

## 🔧 ARCDevTools Integration

iOS apps integrate ARCDevTools the same way as Swift Packages, with automatic detection of project type.

**Quick Start:**

```bash
git submodule add https://github.com/arclabs-studio/ARCDevTools
./ARCDevTools/arcdevtools-setup --with-workflows
```

ARCDevTools auto-detects iOS apps (by finding `.xcodeproj` or `.xcworkspace`) and configures:
- iOS-specific SwiftLint paths (`YourApp/`, `YourAppTests/`)
- Makefile with `xcodebuild` commands
- Pre-push hooks using `xcodebuild test`
- GitHub Actions workflows from `workflows-ios/`

> 📖 **Full Documentation**: See [`arcdevtools.md`](../Tools/arcdevtools.md) for complete setup instructions, configuration options, workflow details, and troubleshooting guides.

---

## ♿ Accessibility & Appearance (Required)

All ARC Labs apps **MUST** implement full accessibility support and appearance adaptation. This is not optional.

### Dark/Light Mode Support

**Requirement**: Every view must render correctly in both light and dark modes.

#### Implementation Guidelines

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

#### Asset Catalog Setup

```
Assets.xcassets/
├── Colors/
│   ├── BrandPrimary.colorset/    # Define Any, Light, Dark variants
│   ├── BackgroundPrimary.colorset/
│   └── TextSecondary.colorset/
```

#### Preview Testing

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

### Accessibility Requirements

**Requirement**: Every interactive element must be accessible via VoiceOver.

#### 1. Accessibility Labels

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

#### 2. Accessibility Hints

```swift
Button("Submit") {
    viewModel.onTappedSubmit()
}
.accessibilityHint("Double tap to submit your order")
```

#### 3. Accessibility Traits

```swift
Text("Welcome to FavRes")
    .font(.largeTitle)
    .accessibilityAddTraits(.isHeader)

Button("Delete", role: .destructive) {
    viewModel.onTappedDelete()
}
.accessibilityAddTraits(.isButton)  // Automatic for Button, but explicit is clearer
```

#### 4. Dynamic Type Support

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

#### 5. Reduce Motion Support

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

var body: some View {
    content
        .animation(reduceMotion ? .none : .spring(), value: isExpanded)
}
```

### Accessibility Checklist

Before releasing any feature:

- [ ] All interactive elements have accessibility labels
- [ ] Icons/images have descriptive labels
- [ ] Complex views use `.accessibilityElement(children: .combine)` appropriately
- [ ] Headers marked with `.isHeader` trait
- [ ] All text uses Dynamic Type (system fonts or `.relativeTo:`)
- [ ] Animations respect `accessibilityReduceMotion`
- [ ] View renders correctly in light mode
- [ ] View renders correctly in dark mode
- [ ] Tested with VoiceOver enabled
- [ ] Tested with larger accessibility text sizes

---

## 🌍 Localization (Required)

All ARC Labs apps **MUST** support localization from the start. This is not optional.

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

### Localization Checklist

Before releasing any feature:

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
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [xcodebuild Documentation](https://developer.apple.com/documentation/xcode/building-from-the-command-line)
- [GitHub Actions for iOS](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-swift)
- ARC Labs Package Documentation

---

**Remember**: Apps deliver **features**, packages provide **infrastructure**. Focus on user experience, leverage existing tools. 📱
