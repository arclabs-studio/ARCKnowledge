# 🔄 MVVM+C (Model-View-ViewModel-Coordinator)

**MVVM+C separates presentation logic (MVVM) from navigation logic (Coordinator/Router), creating testable, maintainable, and scalable iOS apps.**

---

## 🎯 Core Concept

MVVM+C extends the MVVM pattern with a **Coordinator** (called **Router** in ARC Labs, from package ARCNavigation) that handles all navigation:

```
┌─────────┐      ┌────────────┐      ┌──────────┐
│  View   │ ────→│ ViewModel  │ ────→│ UseCase  │
└─────────┘      └────────────┘      └──────────┘
     │                  │
     │                  │
     ↓                  ↓
┌─────────────────────────────┐
│    Router/Coordinator       │ ← Handles ALL navigation
└─────────────────────────────┘
```

### Responsibilities

**View**: Pure presentation, zero logic
- Displays data from ViewModel
- Forwards user actions to ViewModel
- Never navigates directly

**ViewModel**: Coordinates business logic and UI state
- Manages UI state (@Observable)
- Calls Use Cases for business logic
- Tells Router to navigate (doesn't do it itself)
- Never references SwiftUI Views

**Router/Coordinator**: Controls navigation flow
- Manages navigation stack
- Provides type-safe navigation API
- Testable navigation logic
- Encapsulates routing decisions

---

## 🧭 ARCNavigation: The Router Pattern

ARC Labs uses **ARCNavigation** for type-safe, testable routing.

### Installation

Add to your app's `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCNavigation", from: "1.0.0")
]
```

### Basic Setup

#### 1. Define Routes (Enum-based, Type-Safe)

```swift
import ARCNavigation
import SwiftUI

enum AppRoute: Route {
    case home
    case profile(userID: String)
    case settings
    case editProfile(user: User)
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .profile(let userID):
            ProfileView(userID: userID)
        case .settings:
            SettingsView()
        case .editProfile(let user):
            EditProfileView(user: user)
        }
    }
}
```

**Key Points**:
- Enum cases represent destinations
- Associated values for data passing
- `view()` method constructs the actual SwiftUI View
- Type-safe: compiler enforces correct parameters

#### 2. Setup Router in App

```swift
import ARCNavigation
import SwiftUI

@main
struct FavResApp: App {

    // MARK: Private Properties

    @State private var router = Router<AppRoute>()
    
    // MARK: View
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withRouter(router) { $0.view() }
        }
    }
}
```

#### 3. Inject Router into Environment

The `.withRouter()` modifier automatically injects the Router into SwiftUI's environment, making it available to all child views.

---

## 📱 Navigation Patterns

### Pattern 1: Basic Navigation

**View**:
```swift
import ARCNavigation
import SwiftUI

struct HomeView: View {

    // MARK: Private Properties

    @Environment(Router<AppRoute>.self) private var router
    
    // MARK: View
    
    var body: some View {
        VStack {
            Button("Go to Profile") {
                router.navigate(to: .profile(userID: "123"))
            }
            
            Button("Go to Settings") {
                router.navigate(to: .settings)
            }
        }
    }
}
```

**ViewModel** (if navigation logic is complex):
```swift
import ARCNavigation
import Foundation

@MainActor
@Observable
final class HomeViewModel {
    
    // MARK: Private Properties
    
    private let router: Router<AppRoute>
    private let getUserUseCase: GetUserUseCaseProtocol
    private(set) var isLoading = false
    
    // MARK: Initialization
    
    init(
        router: Router<AppRoute>,
        getUserUseCase: GetUserUseCaseProtocol
    ) {
        self.router = router
        self.getUserUseCase = getUserUseCase
    }
    
    // MARK: Public Functions
    
    func onTappedProfile() async {
        isLoading = true
        
        do {
            let user = try await getUserUseCase.execute()
            router.navigate(to: .profile(userID: user.id.uuidString))
        } catch {
            // Handle error
        }
        
        isLoading = false
    }
    
    func onTappedSettings() {
        router.navigate(to: .settings)
    }
}
```

---

### Pattern 2: Conditional Navigation

Navigate based on business logic:

```swift
@MainActor
@Observable
final class ProfileViewModel {
    
    // MARK: Private Properties
    
    private let router: Router<AppRoute>
    private let authService: AuthServiceProtocol
    
    // MARK: Public Functions
    
    func onTappedEditProfile() async {
        // Business logic: check authentication
        guard await authService.isAuthenticated() else {
            router.navigate(to: .login)
            return
        }
        
        // Navigate to edit if authenticated
        router.navigate(to: .editProfile(user: currentUser))
    }
}
```

---

### Pattern 3: Navigation with Data Loading

Load data before navigating:

```swift
@MainActor
@Observable
final class RestaurantListViewModel {
    
    // MARK: Private Properties
        
    private let router: Router<AppRoute>
    private let getRestaurantDetailsUseCase: GetRestaurantDetailsUseCaseProtocol
    
    // MARK: Public Functions
        
    func onTappedRestaurant(id: String) async {
        // Show loading indicator
        isLoading = true
        
        do {
            // Load full details
            let restaurant = try await getRestaurantDetailsUseCase.execute(id: id)
            
            // Navigate with loaded data
            router.navigate(to: .restaurantDetail(restaurant))
        } catch {
            // Show error, don't navigate
            errorMessage = "Failed to load restaurant"
        }
        
        isLoading = false
    }
}
```

---

## 🔙 Navigation Stack Management

### Going Back

```swift
// Go back one screen
router.pop()

// Go back to root
router.popToRoot()

// Go back to specific route
router.popTo(.home)
```

**ViewModel Example**:
```swift
@MainActor
@Observable
final class EditProfileViewModel {
    
    // MARK: Private Properties
        
    private let router: Router<AppRoute>
    private let updateUserUseCase: UpdateUserUseCaseProtocol
    
    // MARK: Public Functions
        
    func onTappedSave() async {
        do {
            try await updateUserUseCase.execute(user: user)
            
            // Success: go back
            router.pop()
        } catch {
            // Error: stay on screen
            errorMessage = "Failed to save"
        }
    }
    
    func onTappedCancel() {
        // Discard changes: go back
        router.pop()
    }
}
```

---

### Stack Inspection

```swift
// Check if stack is empty
let isEmpty = router.isEmpty

// Get stack count
let count = router.count

// Get current routes
let routes = router.currentRoutes
```

---

## 🧪 Testing Navigation

### Test Route Definitions

```swift
import Testing
@testable import FavRes

@Test
func routeViewCreation() {
    let route = AppRoute.profile(userID: "123")
    let view = route.view()
    
    #expect(view is ProfileView)
}
```

### Test Router Navigation

```swift
import ARCNavigation
import Testing
@testable import FavRes

@Suite("Router Navigation Tests")
struct RouterTests {
    
    @Test
    func navigate_addsRouteToStack() {
        // Arrange
        let router = Router<AppRoute>()
        
        // Act
        router.navigate(to: .profile(userID: "123"))
        
        // Assert
        #expect(router.count == 1)
        #expect(!router.isEmpty)
    }
    
    @Test
    func pop_removesLastRoute() {
        // Arrange
        let router = Router<AppRoute>()
        router.navigate(to: .profile(userID: "123"))
        router.navigate(to: .settings)
        
        // Act
        router.pop()
        
        // Assert
        #expect(router.count == 1)
    }
    
    @Test
    func popToRoot_clearsAllRoutes() {
        // Arrange
        let router = Router<AppRoute>()
        router.navigate(to: .profile(userID: "123"))
        router.navigate(to: .settings)
        router.navigate(to: .editProfile(user: .mock))
        
        // Act
        router.popToRoot()
        
        // Assert
        #expect(router.isEmpty)
    }
}
```

### Test ViewModel Navigation Logic

```swift
import Testing
@testable import FavRes

@Test
func onTappedProfile_withAuthenticatedUser_navigatesToProfile() async {
    // Arrange
    let mockRouter = MockRouter<AppRoute>()
    let mockAuthService = MockAuthService()
    mockAuthService.isAuthenticatedResult = true
    
    let viewModel = ProfileViewModel(
        router: mockRouter,
        authService: mockAuthService
    )
    
    // Act
    await viewModel.onTappedEditProfile()
    
    // Assert
    #expect(mockRouter.navigateCalled == true)
    #expect(mockRouter.lastRoute == .editProfile(user: viewModel.currentUser))
}

@Test
func onTappedProfile_withUnauthenticatedUser_navigatesToLogin() async {
    // Arrange
    let mockRouter = MockRouter<AppRoute>()
    let mockAuthService = MockAuthService()
    mockAuthService.isAuthenticatedResult = false
    
    let viewModel = ProfileViewModel(
        router: mockRouter,
        authService: mockAuthService
    )
    
    // Act
    await viewModel.onTappedEditProfile()
    
    // Assert
    #expect(mockRouter.navigateCalled == true)
    #expect(mockRouter.lastRoute == .login)
}
```

**Mock Router**:
```swift
final class MockRouter<R: Route>: @unchecked Sendable {
    var navigateCalled = false
    var lastRoute: R?
    var popCalled = false
    var popToRootCalled = false
    
    func navigate(to route: R) {
        navigateCalled = true
        lastRoute = route
    }
    
    func pop() {
        popCalled = true
    }
    
    func popToRoot() {
        popToRootCalled = true
    }
}
```

---

## 📋 MVVM+C Best Practices

### ✅ DO: Keep Navigation Logic in ViewModel

```swift
@MainActor
@Observable
final class HomeViewModel {

    // MARK: Private Properties
    
    private let router: Router<AppRoute>
    
    // MARK: Public Functions
    
    func onTappedCreatePost() async {
        // Validate before navigating
        guard await hasPermission() else {
            router.navigate(to: .permissionDenied)
            return
        }
        
        router.navigate(to: .createPost)
    }
}
```

### ✅ DO: Pass Data Through Routes

```swift
enum AppRoute: Route {
    case editRestaurant(Restaurant)  // Pass full object
    case userProfile(userID: String) // Or pass identifier
}
```

### ✅ DO: Use Router for All Navigation

```swift
// Good: Router handles navigation
viewModel.onTappedButton()

// Bad: View navigates directly
NavigationLink("Detail", destination: DetailView())
```

### ❌ DON'T: Reference Views from ViewModel

```swift
// WRONG: ViewModel knows about View
@Observable
final class BadViewModel {
    var destinationView: ProfileView?  // ❌ Never do this!
}

// RIGHT: ViewModel uses Router
@Observable
final class GoodViewModel {
    private let router: Router<AppRoute>
    
    func navigate() {
        router.navigate(to: .profile(userID: "123"))
    }
}
```

### ❌ DON'T: Navigate Without Router

```swift
// WRONG: Direct SwiftUI navigation
struct BadView: View {
    @State private var showDetail = false
    
    var body: some View {
        Button("Show") { showDetail = true }
            .sheet(isPresented: $showDetail) {
                DetailView()  // ❌ Bypasses Router!
            }
    }
}

// RIGHT: Use Router
struct GoodView: View {
    @Environment(Router<AppRoute>.self) private var router
    
    var body: some View {
        Button("Show") {
            router.navigate(to: .detail)
        }
    }
}
```

---

## 🏗️ Complex Navigation Flows

### Feature-Based Routes

For large apps, split routes by feature:

```swift
// App-level routes
enum AppRoute: Route {
    case auth(AuthRoute)
    case home(HomeRoute)
    case settings(SettingsRoute)
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .auth(let route):
            route.view()
        case .home(let route):
            route.view()
        case .settings(let route):
            route.view()
        }
    }
}

// Feature-specific routes
enum AuthRoute: Route {
    case login
    case register
    case forgotPassword
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .login: LoginView()
        case .register: RegisterView()
        case .forgotPassword: ForgotPasswordView()
        }
    }
}
```

### Tab-Based Navigation

Combine Router with TabView:

```swift
struct MainTabView: View {

    // MARK: Private Properties
    
    @Environment(Router<AppRoute>.self) private var router
    @State private var selectedTab = 0
    
    // MARK: View
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)
            
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(1)
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
                .tag(2)
        }
        .withRouter(router) { $0.view() }
    }
}
```

---

## 🎯 When to Use ViewModel vs Direct Router

### Use ViewModel for Navigation When:
- Navigation depends on business logic
- Need to load data before navigating
- Navigation requires validation
- Complex navigation flows

**Example**:
```swift
viewModel.onTappedRestaurant(id: "123") // ViewModel handles logic + navigation
```

### Use Router Directly When:
- Simple, direct navigation
- No business logic involved
- No data loading needed

**Example**:
```swift
Button("Settings") {
    router.navigate(to: .settings)  // Direct, simple
}
```

---

## ✅ MVVM+C Checklist

Before considering your navigation architecture complete:

### Architecture
- [ ] All routes defined in enum(s)
- [ ] Router injected via environment
- [ ] ViewModels receive router via dependency injection
- [ ] No direct SwiftUI navigation (no `NavigationLink`, `.sheet`, etc.)
- [ ] Views never navigate directly

### Testing
- [ ] Router navigation tested
- [ ] ViewModel navigation logic tested
- [ ] Mock router used in tests
- [ ] Navigation flows verified

### Code Quality
- [ ] Routes are type-safe with associated values
- [ ] ViewModels coordinate, not implement business logic
- [ ] Views are pure presentation
- [ ] Navigation decisions in ViewModel, not View

---

## 📚 Further Reading

- [ARCNavigation Documentation](https://github.com/arclabs-studio/ARCNavigation)
- [Coordinator Pattern Explained](https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios)
- MVVM Pattern (Apple documentation)

---

**Remember**: The Router is your **single source of truth** for navigation. Keep Views dumb, ViewModels smart (but not too smart), and let the Router handle the journey. 🧭
