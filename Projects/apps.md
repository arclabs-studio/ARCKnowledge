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

### UX
- [ ] Loading states handled
- [ ] Error states handled
- [ ] Empty states handled
- [ ] Accessibility labels provided
- [ ] Dark mode supported

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

## 🔧 ARCDevTools Integration for iOS Apps

### Overview

ARCDevTools automatically detects iOS app projects (by finding `.xcodeproj` or `.xcworkspace`) and configures tooling accordingly. The key differences from Swift Packages are:

| Aspect | Swift Packages | iOS Apps |
|--------|----------------|----------|
| Test Command | `swift test` | `xcodebuild test` |
| Build Command | `swift build` | `xcodebuild build` |
| Platform Support | macOS + Linux | Apple platforms only |
| Source Paths | `Sources/` | `AppName/` (varies) |
| CI Runner | `ubuntu-latest` or `macos-latest` | `macos-latest` only |

### Installation

```bash
# Navigate to your iOS app project root
cd /path/to/YourApp

# Add ARCDevTools as submodule
git submodule add https://github.com/arclabs-studio/ARCDevTools

# Run setup (auto-detects iOS app)
./ARCDevTools/arcdevtools-setup --with-workflows
```

The setup script will:
1. Detect the project type (iOS App vs Swift Package)
2. Copy appropriate SwiftLint/SwiftFormat configurations
3. Generate iOS-specific Makefile commands
4. Install git hooks adapted for xcodebuild
5. Copy iOS-specific GitHub Actions workflows

### SwiftLint Configuration for iOS Apps

The generated `.swiftlint.yml` includes iOS app-specific paths:

```yaml
# .swiftlint.yml for iOS Apps

included:
  - YourAppName        # Main app target
  - YourAppNameTests   # Test target
  - Shared             # Shared code (if exists)
  - Widgets            # Widget extensions (if exists)

excluded:
  - DerivedData
  - .build
  - Pods
  - Carthage
  - ARCDevTools
  - "*/Generated/*"
  - "*.generated.swift"

# Same rules as packages (see arcdevtools.md)
```

**Important**: After setup, verify the `included` paths match your project structure. Common iOS app structures:

```
# Standard structure
YourApp/
├── YourApp/           # Main target ← Include this
├── YourAppTests/      # Tests ← Include this
└── YourAppUITests/    # UI Tests ← Optional

# Multi-module structure
YourApp/
├── App/               # Main target ← Include this
├── Features/          # Feature modules ← Include this
├── Core/              # Core utilities ← Include this
└── Tests/             # All tests ← Include this
```

### Makefile Commands for iOS Apps

The generated Makefile includes iOS-specific commands:

```bash
make help          # Show all available commands
make lint          # Run SwiftLint on app sources
make format        # Check formatting (dry-run)
make fix           # Apply SwiftFormat
make build         # Build using xcodebuild
make test          # Run tests using xcodebuild
make clean         # Clean DerivedData
make setup         # Re-run ARCDevTools setup
make hooks         # Re-install git hooks
```

**Build and Test Commands** (what runs under the hood):

```bash
# Build
xcodebuild build \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO

# Test
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -configuration Debug \
  -resultBundlePath TestResults.xcresult \
  CODE_SIGNING_ALLOWED=NO
```

### Git Hooks for iOS Apps

**Pre-commit Hook** (same as packages):
1. Runs SwiftFormat on staged files
2. Runs SwiftLint in strict mode
3. Blocks commit if errors exist

**Pre-push Hook** (iOS-specific):
1. Runs `xcodebuild test` instead of `swift test`
2. Uses configured scheme and simulator
3. Blocks push if tests fail

---

## 🔄 GitHub Actions for iOS Apps

### CI/CD Configuration

ARCDevTools provides iOS-specific workflows in the `workflows-ios/` directory. Copy them during setup:

```bash
# Automatic (copies from workflows-ios/ for iOS apps)
./ARCDevTools/arcdevtools-setup --with-workflows

# Or manually
mkdir -p .github/workflows
cp ARCDevTools/workflows-ios/*.yml .github/workflows/
```

### tests.yml (iOS Version)

```yaml
name: Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test-ios:
    runs-on: macos-15

    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_16.2.app

      - name: Show destinations
        run: xcodebuild -scheme "YourApp" -showdestinations

      - name: Build
        run: |
          xcodebuild build \
            -scheme "YourApp" \
            -destination "platform=iOS Simulator,name=iPhone 16" \
            -configuration Debug \
            CODE_SIGNING_ALLOWED=NO

      - name: Test
        run: |
          xcodebuild test \
            -scheme "YourApp" \
            -destination "platform=iOS Simulator,name=iPhone 16" \
            -configuration Debug \
            -resultBundlePath TestResults.xcresult \
            CODE_SIGNING_ALLOWED=NO

      - name: Upload Test Results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results
          path: TestResults.xcresult
```

### quality.yml (Same as Packages)

```yaml
name: Quality

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    runs-on: macos-latest

    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Install SwiftLint
        run: brew install swiftlint

      - name: Run SwiftLint
        run: swiftlint lint --strict --config .swiftlint.yml

  format:
    runs-on: macos-latest

    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Install SwiftFormat
        run: brew install swiftformat

      - name: Check SwiftFormat
        run: swiftformat . --lint --config .swiftformat
```

### Key Differences from Package Workflows

| Aspect | Package Workflow (`workflows-spm/`) | iOS App Workflow (`workflows-ios/`) |
|--------|-------------------------------------|-------------------------------------|
| Runner | `macos-latest` + `ubuntu-latest` | `macos-latest` only |
| Build | `swift build` | `xcodebuild build` |
| Test | `swift test --parallel` | `xcodebuild test` |
| Platforms | macOS, Linux | iOS Simulator |
| Xcode Selection | Not needed | Required (`xcode-select`) |
| Code Signing | N/A | `CODE_SIGNING_ALLOWED=NO` |

---

## 🔧 Manual Configuration

### Adapting SwiftLint Paths

If ARCDevTools doesn't detect your project structure correctly, manually edit `.swiftlint.yml`:

```yaml
# Before (default paths)
included:
  - Sources
  - Tests

# After (iOS app paths)
included:
  - FavRes           # Your main app folder
  - FavResTests      # Your test folder
  - Shared           # Shared components (if any)
```

### Adapting Makefile

If your scheme name differs, edit the generated `Makefile`:

```makefile
# Variables (edit these)
SCHEME = YourActualSchemeName
DESTINATION = platform=iOS Simulator,name=iPhone 16
CONFIGURATION = Debug

# Build target
build:
	xcodebuild build \
		-scheme "$(SCHEME)" \
		-destination "$(DESTINATION)" \
		-configuration $(CONFIGURATION) \
		CODE_SIGNING_ALLOWED=NO

# Test target
test:
	xcodebuild test \
		-scheme "$(SCHEME)" \
		-destination "$(DESTINATION)" \
		-configuration $(CONFIGURATION) \
		CODE_SIGNING_ALLOWED=NO
```

### Finding Your Scheme Name

```bash
# List all schemes in your project
xcodebuild -list

# Output example:
# Information about project "FavRes":
#     Targets:
#         FavRes
#         FavResTests
#     Schemes:
#         FavRes          ← Use this
#         FavResTests
```

---

## 🔍 Troubleshooting iOS Apps

### Workflow Fails: "Scheme not found"

```bash
# Error: xcodebuild: error: Unable to find a scheme named "YourApp"

# Solution 1: Check scheme name
xcodebuild -list

# Solution 2: Ensure scheme is shared
# In Xcode: Product → Scheme → Manage Schemes → Check "Shared"
```

### Workflow Fails: "No matching destination"

```bash
# Error: xcodebuild: error: Unable to find a destination matching...

# Solution: List available destinations
xcodebuild -scheme "YourApp" -showdestinations

# Use an available destination in your workflow
# Example: platform=iOS Simulator,name=iPhone 16,OS=18.2
```

### SwiftLint: "No lintable files found"

```bash
# Error: No lintable files found at paths: 'Sources'

# Solution: Update .swiftlint.yml paths
# Check your actual folder structure:
ls -la

# Update included paths in .swiftlint.yml
```

### Pre-push Hook Fails: "No scheme"

```bash
# Error in pre-push: requires a project to be specified

# Solution: Edit .git/hooks/pre-push
# Find the xcodebuild line and add -project:
xcodebuild test \
  -project "YourApp.xcodeproj" \
  -scheme "YourApp" \
  ...
```

---

## 📚 Further Reading

- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [xcodebuild Documentation](https://developer.apple.com/documentation/xcode/building-from-the-command-line)
- [GitHub Actions for iOS](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-swift)
- ARC Labs Package Documentation

---

**Remember**: Apps deliver **features**, packages provide **infrastructure**. Focus on user experience, leverage existing tools. 📱
