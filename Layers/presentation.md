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

@MainActor
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

extension UserProfileViewModel {
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

#### 1. Use Enums for Complex State

```swift
enum LoadingState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(String)
}

@MainActor
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
@MainActor
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
@MainActor
@Observable
final class HomeViewModel {
    // ✅ Good: Prefix with "on" for user actions
    func onTappedRestaurant(_ restaurant: Restaurant) { ... }
    func onChangedSearchText(_ text: String) { ... }
    func onAppear() { }
    
    // ✅ Good: Standard naming for internal methods
    private func loadRestaurants() async { ... }
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
@MainActor
@Observable
final class ProfileViewModel {
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
- [ ] Uses `@Observable` and `@MainActor`
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
