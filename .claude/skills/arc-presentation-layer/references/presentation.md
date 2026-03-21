# 🖼️ Presentation Layer

**The Presentation Layer handles UI rendering, user interaction, and navigation. It's where users experience your app.**

---

## 🎯 Layer Purpose

The Presentation Layer is responsible for:
1. **Displaying data** to users (Views)
2. **Managing UI state** and coordinating with business logic (ViewModels)
3. **Handling navigation** between screens (Routers)

**Key Rule**: Presentation Layer **never contains business logic**. It coordinates, displays, and navigates—nothing more.

---

## 🏗️ Layer Structure

```
Presentation/
├── Features/
│   ├── Home/
│   │   ├── View/
│   │   │   ├── HomeView.swift
│   │   │   ├── RestaurantCardView.swift
│   │   │   └── FilterButtonView.swift
│   │   ├── ViewModel/
│   │   │   └── HomeViewModel.swift
│   │   └── Router/
│   │       └── HomeRouter.swift (if complex navigation)
│   │
│   ├── RestaurantDetail/
│   │   ├── View/
│   │   ├── ViewModel/
│   │   └── Router/
│   │
│   └── Settings/
│       ├── View/
│       └── ViewModel/
│
└── Shared/
    ├── Components/
    │   ├── LiquidGlassButton.swift
    │   └── EmptyStateView.swift
    └── Modifiers/
        ├── LiquidGlassModifier.swift
        └── ShimmerModifier.swift
```

---

## 👁️ Views

### Responsibility

Views are **pure presentation**:
- ✅ Display data from ViewModel
- ✅ Forward user actions to ViewModel
- ✅ Handle local UI state (animations, selections)
- ❌ NO business logic
- ❌ NO data access
- ❌ NO navigation decisions

### Basic View Structure

```swift
import SwiftUI

struct UserProfileView: View {
    
    // MARK: Private Properties
    
    @State private var viewModel: UserProfileViewModel
    
    // MARK: Initialization
    
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: View
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                profileDetails
                actionButtons
            }
            .padding()
        }
        .navigationTitle("Profile")
        .task {
            await viewModel.onAppear()
        }
    }
}

// MARK: - Private Views

private extension USerProfileView {    
    var profileHeader: some View {
        VStack {
            AsyncImage(url: viewModel.user?.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            Text(viewModel.user?.name ?? "Unknown")
                .font(.title)
        }
    }
    
    var profileDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            DetailRow(title: "Email", value: viewModel.user?.email ?? "N/A")
            DetailRow(title: "Member Since", value: viewModel.memberSinceText)
        }
    }
    
    var actionButtons: some View {
        VStack(spacing: 12) {
            Button("Edit Profile") {
                viewModel.onTappedEditProfile()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Sign Out") {
                viewModel.onTappedSignOut()
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Previews

#Preview("Loaded") {
    let mockViewModel = UserProfileViewModel.mock
    mockViewModel.user = .mock
    return UserProfileView(viewModel: mockViewModel)
}

#Preview("Loading") {
    let mockViewModel = UserProfileViewModel.mock
    mockViewModel.isLoading = true
    return UserProfileView(viewModel: mockViewModel)
}
```

### View Best Practices

#### 1. Extract Subviews

```swift
// ✅ Good: Small, focused views
struct RestaurantListView: View {
    let restaurants: [Restaurant]
    
    var body: some View {
        List(restaurants) { restaurant in
            RestaurantRowView(restaurant: restaurant)
        }
    }
}

struct RestaurantRowView: View {
    let restaurant: Restaurant
    
    var body: some View {
        HStack {
            restaurantImage
            restaurantDetails
            ratingBadge
        }
    }
}

// MARK: - Private Views

extension RestaurantRowView {
    private var restaurantImage: some View { /* ... */ }
    private var restaurantDetails: some View { /* ... */ }
    private var ratingBadge: some View { /* ... */ }
}
```

#### 2. Use Computed Properties for Complex Views

```swift
struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                header
                stats
                recentActivity
            }
        }
    }
}

// MARK: - Private Views

private extension ProfileView {
    var header: some View {
        VStack {
            // Header implementation
        }
    }
    
    var stats: some View {
        HStack {
            // Stats implementation
        }
    }
    
    var recentActivity: some View {
        VStack {
            // Activity implementation
        }
    }
}
```

#### 3. Handle All States

```swift
struct ContentView: View {
    @State private var viewModel: ContentViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Text("Ready")
                
            case .loading:
                ProgressView("Loading...")
                
            case .loaded(let data):
                dataView(data)
                
            case .error(let message):
                ErrorView(message: message) {
                    Task { await viewModel.retry() }
                }
            }
        }
    }
}

// MARK: - Private Functions

private extension ContentView: View {
    func dataView(_ data: [Item]) -> some View {
        List(data) { item in
            ItemRow(item: item)
        }
    }
}
```

#### 4. Accessibility

```swift
struct ActionButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to \(title.lowercased())")
    }
}
```

> 📖 **Full Guidelines**: See [`ui-guidelines.md`](../Quality/ui-guidelines.md) for complete accessibility, dark mode, SF Symbols animations, and localization requirements.

---

## 🧠 ViewModels

### Responsibility

ViewModels are **coordinators**:
- ✅ Manage UI state (`@Observable`)
- ✅ Call Use Cases for business logic
- ✅ Transform domain data for display
- ✅ Tell Router to navigate
- ❌ NO business logic implementation
- ❌ NO direct data access
- ❌ NO knowledge of SwiftUI Views

### Basic ViewModel Structure

```swift
import ARCLogger
import ARCNavigation
import Foundation

@Observable
final class UserProfileViewModel {
    
    // MARK: Private Properties
    
    private(set) var user: User?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    private let signOutUseCase: SignOutUseCaseProtocol
    private let router: Router<AppRoute>
    
    // MARK: Public Properties
    
    var memberSinceText: String {
        guard let user = user else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: user.createdAt)
    }
    
    var canEditProfile: Bool {
        user != nil && !isLoading
    }

    // MARK: Initialization
    
    init(
        getUserProfileUseCase: GetUserProfileUseCaseProtocol,
        signOutUseCase: SignOutUseCaseProtocol,
        router: Router<AppRoute>
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.signOutUseCase = signOutUseCase
        self.router = router
    }
    
    // MARK: Lifecycle

    func onAppear() async {
        await loadProfile()
    }

    // MARK: Public Functions

    func onTappedEditProfile() {
        guard let user = user else { return }

        ARCLogger.shared.info("User tapped edit profile")
        router.navigate(to: .editProfile(user))
    }

    @MainActor
    func onTappedSignOut() async {
        ARCLogger.shared.info("User requested sign out")

        isLoading = true

        do {
            try await signOutUseCase.execute()
            router.popToRoot()
            router.navigate(to: .login)
        } catch {
            errorMessage = "Failed to sign out"
            ARCLogger.shared.error("Sign out failed", metadata: [
                "error": error.localizedDescription
            ])
        }

        isLoading = false
    }

    func onTappedRetry() async {
        await loadProfile()
    }
}

// MARK: - Private Functions

private extension UserProfileViewModel {
    @MainActor
    func loadProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            user = try await getUserProfileUseCase.execute()
            ARCLogger.shared.debug("Profile loaded successfully")
        } catch {
            errorMessage = "Failed to load profile"
            ARCLogger.shared.error("Profile load failed", metadata: [
                "error": error.localizedDescription
            ])
        }

        isLoading = false
    }
}

// MARK: - Mock

#if DEBUG
extension UserProfileViewModel {
    static var mock: UserProfileViewModel {
        UserProfileViewModel(
            getUserProfileUseCase: MockGetUserProfileUseCase(),
            signOutUseCase: MockSignOutUseCase(),
            router: Router()
        )
    }
}
#endif
```

### ViewModel Best Practices

#### ⚠️ @Observable + lazy var Incompatibility

**Critical**: The `@Observable` macro is incompatible with `lazy var`. This causes cryptic compiler errors.

```swift
// ❌ WRONG: This will NOT compile
@MainActor
@Observable
final class AppCoordinator {
    lazy var searchUseCase: SearchRestaurantsUseCase = {
        SearchRestaurantsUseCase()  // ❌ Compiler error!
    }()
}
```

**Solution**: Use implicitly unwrapped optionals and initialize in `init()`:

```swift
// ✅ CORRECT: Use implicitly unwrapped optionals
@MainActor
@Observable
final class AppCoordinator {
    // Declare as implicitly unwrapped optionals
    private var searchUseCase: SearchRestaurantsUseCaseProtocol!
    private var filterUseCase: FilterRestaurantsUseCaseProtocol!
    private var sortUseCase: SortRestaurantsUseCaseProtocol!

    init() {
        // Initialize in init()
        self.searchUseCase = SearchRestaurantsUseCase()
        self.filterUseCase = FilterRestaurantsUseCase()
        self.sortUseCase = SortRestaurantsUseCase()
    }
}
```

**Why this works**:
- Implicitly unwrapped optionals defer initialization safely
- All initialization happens in `init()` where `self` is fully available
- Use Cases are created once and reused throughout the app

---

#### @MainActor Placement: Why Methods, Not the Class

`@MainActor` on a **class** isolates every member — all stored properties, all methods, and `init` — to the main actor. This is a blanket constraint that forces even non-UI methods to hop to the main thread on every call, adds overhead, and prevents packages from being called from non-main-actor contexts without `await`.

`@MainActor` on a **method** is targeted: after any `await` suspension point, the runtime guarantees execution returns to the main actor before continuing. This is what you need when a method awaits nonisolated async code and then writes to `@Observable` properties that drive UI.

```swift
// ✅ Correct: @MainActor only where the write-after-await happens
@Observable
final class UserViewModel {
    private(set) var user: User?

    // loadUser awaits a nonisolated UseCase, then writes to `user`.
    // @MainActor guarantees the write happens on the main actor.
    @MainActor
    func loadUser() async {
        user = try? await getUserUseCase.execute()
    }

    // Pure delegation — the @MainActor hop happens inside loadUser.
    // No annotation needed here.
    func onAppear() async {
        await loadUser()
    }
}

// ❌ Wrong: Blanket @MainActor — all methods locked to main thread,
// prevents calling from background actors without await overhead.
@MainActor
@Observable
final class UserViewModel { ... }
```

> **Swift 6.2 note (SE-0466)**: App targets can opt into `DefaultIsolation = @MainActor` via a build setting, which infers `@MainActor` for all non-explicitly-isolated code in the module. This is a valid alternative for apps. For **packages**, it is inappropriate — callers may be off the main actor. Per-method annotation is always safe for both.

---

#### 1. Use Enums for Complex State

```swift
enum LoadingState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(String)
}

@Observable
final class RestaurantListViewModel {
    private(set) var state: LoadingState<[Restaurant]> = .idle
    
    var restaurants: [Restaurant] {
        if case .loaded(let restaurants) = state {
            return restaurants
        }
        return []
    }
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
}
```

#### 2. Private(set) for Mutable State

```swift
@Observable
final class SearchViewModel {
    // ✅ Good: Private setter
    private(set) var results: [Restaurant] = []
    private(set) var isSearching = false

    // ❌ Bad: Public mutable state
    var results: [Restaurant] = []
}
```

#### 3. Method Naming Convention

```swift
@Observable
final class HomeViewModel {
    // ✅ Good: Prefix with "on" for user actions
    func onTappedRestaurant(_ restaurant: Restaurant) { ... }
    func onChangedSearchText(_ text: String) { ... }
    func onAppear() { }

    // ✅ Good: Standard naming for internal methods
    @MainActor private func loadRestaurants() async { ... }
    private func formatDate(_ date: Date) -> String { ... }
}
```

---

## 🧭 Routers (Coordinators)

### When to Use Routers

**Simple Apps**: Router handled by ARCNavigation at app level
**Complex Apps**: Feature-specific routers for complex navigation flows

### App-Level Router

```swift
// AppRoute.swift
import ARCNavigation
import SwiftUI

enum AppRoute: Route {
    // Authentication
    case login
    case register
    case forgotPassword
    
    // Main App
    case home
    case restaurantDetail(Restaurant)
    case search(query: String?)
    
    // Profile
    case profile
    case editProfile(User)
    case settings
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .login:
            LoginView(viewModel: LoginViewModel.create())
            
        case .register:
            RegisterView(viewModel: RegisterViewModel.create())
            
        case .forgotPassword:
            ForgotPasswordView(viewModel: ForgotPasswordViewModel.create())
            
        case .home:
            HomeView(viewModel: HomeViewModel.create())
            
        case .restaurantDetail(let restaurant):
            RestaurantDetailView(
                viewModel: RestaurantDetailViewModel.create(restaurant: restaurant)
            )
            
        case .search(let query):
            SearchView(viewModel: SearchViewModel.create(initialQuery: query))
            
        case .profile:
            ProfileView(viewModel: ProfileViewModel.create())
            
        case .editProfile(let user):
            EditProfileView(viewModel: EditProfileViewModel.create(user: user))
            
        case .settings:
            SettingsView(viewModel: SettingsViewModel.create())
        }
    }
}

// MARK: - HomeViewModel

// ViewModel factory methods
extension HomeViewModel {
    static func create() -> HomeViewModel {
        HomeViewModel(
            getRestaurantsUseCase: createGetRestaurantsUseCase(),
            router: Router.shared
        )
    }
    
    private func createGetRestaurantsUseCase() -> GetRestaurantsUseCase {
            .init(
                repository: RestaurantRepositoryImpl.shared
            )
    }
}
```

### Composition Root Pattern (AppCoordinator)

The **Composition Root** is where all dependencies are wired together. In ARC Labs apps, the `AppCoordinator` serves this role:

```swift
// AppCoordinator.swift - The Composition Root
@MainActor
@Observable
final class AppCoordinator {
    // MARK: - Infrastructure (owns concrete implementations)

    private var repository: RestaurantRepositoryProtocol!
    private var geocodingService: GeocodingServiceProtocol!

    // MARK: - Use Cases (created once, reused)

    private var getRestaurantsUseCase: GetRestaurantsUseCaseProtocol!
    private var filterUseCase: FilterRestaurantsUseCaseProtocol!
    private var searchUseCase: SearchRestaurantsUseCaseProtocol!
    private var sortUseCase: SortRestaurantsUseCaseProtocol!
    private var toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol!
    private var addRestaurantUseCase: AddRestaurantUseCaseProtocol!

    // MARK: - Initialization (Wire All Dependencies)

    init(modelContainer: ModelContainer? = nil) {
        // 1. Create infrastructure
        self.repository = RestaurantRepositoryImpl(storage: storage)
        self.geocodingService = GeocodingService()

        // 2. Create use cases with their dependencies
        self.getRestaurantsUseCase = GetRestaurantsUseCase(repository: repository)
        self.filterUseCase = FilterRestaurantsUseCase()
        self.searchUseCase = SearchRestaurantsUseCase()
        self.sortUseCase = SortRestaurantsUseCase()
        self.toggleFavoriteUseCase = ToggleFavoriteUseCase(
            reader: repository,
            writer: repository
        )
        self.addRestaurantUseCase = AddRestaurantUseCase(
            writer: repository,
            geocodingService: geocodingService
        )
    }

    // MARK: - Factory Methods (Create ViewModels with Dependencies)

    @ViewBuilder
    func makeRestaurantGridView() -> some View {
        let viewModel = RestaurantGridViewModel(
            getRestaurantsUseCase: getRestaurantsUseCase,
            filterUseCase: filterUseCase,
            sortUseCase: sortUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            coordinator: self
        )
        RestaurantGridView(viewModel: viewModel)
    }

    @ViewBuilder
    func makeSearchView() -> some View {
        let viewModel = SearchViewModel(
            getRestaurantsUseCase: getRestaurantsUseCase,
            searchUseCase: searchUseCase,
            filterUseCase: filterUseCase,
            coordinator: self
        )
        SearchView(viewModel: viewModel)
    }
}
```

**Key Principles**:
1. **Single Point of DI**: All dependencies wired in one place
2. **Factory Methods**: ViewModels created with correct dependencies
3. **Protocol-Based**: ViewModels depend on protocols, not concrete types
4. **Use Cases Reused**: Same use case instance shared across ViewModels

---

### Dependency Injection Strategy

ARC Labs uses two complementary DI mechanisms. Choosing the right one keeps layers clean and tests simple.

#### Decision Matrix

| Dependency | Mechanism | Why |
|---|---|---|
| Use Cases → ViewModel | Init injection (protocol) | Testability; Domain layer abstraction |
| Repositories → Use Case | Init injection (protocol) | Testability; Data layer abstraction |
| Router → View | `@Environment(Router<AppRoute>.self)` | `@Observable`, shared across deep hierarchy |
| Router → ViewModel | Init injection | Unit testability |
| Shared app model (e.g., `UserSession`) → View | `@Environment(Type.self)` | `@Observable`, avoids threading through every init |
| System values (`colorScheme`, `reduceMotion`) | `@Environment(\.keyPath)` | SwiftUI built-in key paths |
| Services, API clients | Init injection (protocol) | Not `@Observable`; testability |

#### The Rule

`@Environment` is a **delivery mechanism** for Presentation-layer `@Observable` models. It does **not** replace the Composition Root — the `AppCoordinator` still creates and wires all dependencies. `.environment()` is how some of those objects reach deep Views without threading through every intermediate View's init.

> Init injection remains the **primary** DI mechanism for Domain and Data layers. `@Environment` is strictly a Presentation-layer concern.

#### Type-Based `@Environment` for @Observable (iOS 17+)

The Router pattern generalises to any `@Observable` model that needs to be shared across a deep view hierarchy:

```swift
// Composition Root — inject into environment once
WindowGroup {
    ContentView()
        .environment(userSession)   // userSession: UserSession (@Observable)
        .withRouter(router)
}

// Any descendant View — read from environment
struct ProfileView: View {
    @Environment(UserSession.self) private var userSession
    // ...
}
```

#### `@Entry` Macro for Custom Environment Keys (iOS 18+)

The `@Entry` macro eliminates the boilerplate of `EnvironmentKey` conformances:

```swift
// Before @Entry (iOS 17 and earlier)
private struct UserSessionKey: EnvironmentKey {
    static let defaultValue: UserSession? = nil
}

extension EnvironmentValues {
    var userSession: UserSession? {
        get { self[UserSessionKey.self] }
        set { self[UserSessionKey.self] = newValue }
    }
}

// After @Entry (iOS 18+)
extension EnvironmentValues {
    @Entry var userSession: UserSession?
}
```

#### Anti-Patterns

**Never inject these via `@Environment`**:

```swift
// ❌ Use Cases via @Environment — breaks testability, violates layer boundaries
@Environment(GetRestaurantsUseCase.self) private var getRestaurantsUseCase

// ❌ Repositories via @Environment — same issues
@Environment(RestaurantRepositoryImpl.self) private var repository

// ❌ Non-@Observable services — they don't participate in SwiftUI's update cycle
@Environment(NetworkService.self) private var networkService
```

Use init injection for all Domain and Data layer dependencies. `@Environment` is reserved for `@Observable` models that need to propagate across the Presentation layer.

#### `@EnvironmentObject` Deprecation

`@EnvironmentObject` is superseded by `@Environment(Type.self)` when the model conforms to `@Observable` (iOS 17+). ARC Labs code targeting iOS 17+ **must not** use `@EnvironmentObject`. The `@Observable` macro provides the same propagation mechanism with better performance and compile-time safety.

---

### Feature-Specific Router (for complex features)

```swift
// RestaurantFlowRouter.swift
import ARCNavigation

@MainActor
@Observable
final class RestaurantFlowRouter {

    private let appRouter: Router<AppRoute>

    init(appRouter: Router<AppRoute>) {
        self.appRouter = appRouter
    }

    func showRestaurantList() {
        appRouter.navigate(to: .home)
    }

    func showRestaurantDetail(_ restaurant: Restaurant) {
        appRouter.navigate(to: .restaurantDetail(restaurant))
    }

    func showRestaurantSearch(query: String? = nil) {
        appRouter.navigate(to: .search(query: query))
    }

    func dismissFlow() {
        appRouter.popToRoot()
    }
}
```

---

## 🔄 Data Flow

### View → ViewModel → Use Case → Repository

```
┌──────────┐
│   View   │
│ (SwiftUI)│
└─────┬────┘
      │ User taps button
      ↓
┌──────────────┐
│  ViewModel   │
│ (@Observable)│
└──────┬───────┘
       │ Calls execute()
       ↓
┌──────────────┐
│   Use Case   │
│ (Business)   │
└──────┬───────┘
       │ Calls getUser()
       ↓
┌──────────────┐
│  Repository  │
│ (Data Access)│
└──────────────┘
```

### Complete Example

```swift
// 1. User Action (View)
Button("Load Profile") {
    Task {
        await viewModel.onTappedLoadProfile()
    }
}

// 2. ViewModel Coordinates
@Observable
final class ProfileViewModel {
    @MainActor
    func onTappedLoadProfile() async {
        isLoading = true

        do {
            // Call Use Case
            user = try await getUserProfileUseCase.execute(userId: currentUserId)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

// 3. Use Case Executes Business Logic
final class GetUserProfileUseCase {
    func execute(userId: UUID) async throws -> User {
        // Validation
        guard userId != UUID() else {
            throw DomainError.invalidUserId
        }
        
        // Call Repository
        let user = try await repository.getUser(by: userId)
        
        // Business rule
        guard user.isActive else {
            throw DomainError.userInactive
        }
        
        return user
    }
}

// 4. Repository Fetches Data
final class UserRepositoryImpl: UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User {
        // Check cache
        if let cached = try? await localDataSource.getUser(by: id) {
            return cached.toDomain()
        }
        
        // Fetch from API
        let dto = try await remoteDataSource.fetchUser(by: id)
        
        // Cache result
        try? await localDataSource.saveUser(dto)
        
        return dto.toDomain()
    }
}
```

---

## ✅ Presentation Layer Checklist

### Views
- [ ] Zero business logic
- [ ] All states handled (loading, error, empty, success)
- [ ] Accessibility labels provided (see [`ui-guidelines.md`](../Quality/ui-guidelines.md))
- [ ] Dark mode supported (see [`ui-guidelines.md`](../Quality/ui-guidelines.md))
- [ ] SwiftUI previews included
- [ ] Subviews extracted for reusability

### ViewModels
- [ ] State is `private(set)`
- [ ] Dependencies injected via init
- [ ] Uses `@Observable`; `@MainActor` on specific methods only
- [ ] User actions prefixed with "on"
- [ ] Calls Use Cases (not Repositories directly)
- [ ] Tells Router to navigate (doesn't navigate itself)
- [ ] Logging via ARCLogger

### Routers
- [ ] Routes defined as enum
- [ ] Type-safe with associated values
- [ ] Integrated with ARCNavigation
- [ ] ViewBuilder creates views
- [ ] Tested independently

---

## 🚫 Common Mistakes

### Mistake 1: Business Logic in View

```swift
// ❌ WRONG
struct RestaurantView: View {
    var body: some View {
        Button("Save") {
            if restaurant.rating > 4.0 && !restaurant.isFavorite {
                // Business logic in View!
                saveFavorite(restaurant)
            }
        }
    }
}

// ✅ RIGHT
struct RestaurantView: View {
    @State private var viewModel: RestaurantViewModel
    
    var body: some View {
        Button("Save") {
            viewModel.onTappedSave()  // ViewModel decides
        }
    }
}
```

### Mistake 2: ViewModel Knows About View

```swift
// ❌ WRONG
@Observable
final class BadViewModel {
    var destinationView: ProfileView?  // Never!
}

// ✅ RIGHT
@Observable
final class GoodViewModel {
    private let router: Router<AppRoute>
    
    func navigate() {
        router.navigate(to: .profile)
    }
}
```

### Mistake 3: Public Mutable State

```swift
// ❌ WRONG
@Observable
final class BadViewModel {
    var isLoading: Bool = false  // Anyone can change!
}

// ✅ RIGHT
@Observable
final class GoodViewModel {
    private(set) var isLoading: Bool = false  // Only ViewModel changes
}
```

---

## 📚 Further Reading

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Observation Framework](https://developer.apple.com/documentation/observation)
- ARCNavigation documentation
- MVVM+C pattern guide

---

**Remember**: Presentation is about **coordination**, not **computation**. Keep it simple, keep it clean. 🎨
