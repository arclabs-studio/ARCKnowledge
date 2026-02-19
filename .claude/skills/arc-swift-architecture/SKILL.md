---
name: arc-swift-architecture
description: |
  ARC Labs Studio Swift architecture patterns and principles. Covers Clean
  Architecture with three layers (Presentation, Domain, Data), MVVM+Coordinator
  pattern with ARCNavigation Router, SOLID principles applied to Swift, Protocol-Oriented
  Design, dependency injection, layer boundaries, data flow, and singleton patterns.

  **INVOKE THIS SKILL** when:
  - Designing a new feature or module architecture
  - Setting up layer boundaries (Presentation/Domain/Data)
  - Implementing MVVM+C pattern with ViewModels and Routers
  - Creating Use Cases, Entities, or Repository protocols
  - Reviewing code for architectural compliance
  - Discussing or explaining architectural decisions
---

# ARC Labs Studio - Swift Architecture Patterns

## When to Use This Skill

Use this skill when you need to:
- **Design new features or modules** following Clean Architecture
- **Refactor existing code** to improve architecture
- **Answer questions** about layer boundaries and dependencies
- **Implement MVVM+C pattern** (Model-View-ViewModel-Coordinator)
- **Set up dependency injection** properly
- **Make Protocol-Oriented Design decisions**
- **Review code architecture** and provide feedback
- **Explain architectural patterns** to team members
- **Resolve dependency issues** between layers
- **Design domain entities and use cases**
- **Understand when singletons are appropriate**

## Quick Reference

### Clean Architecture - Three Layers

```
┌─────────────────────────────────────────────┐
│        PRESENTATION LAYER                    │
│   SwiftUI Views • ViewModels • Routers      │
│   (User Interface & Navigation)             │
├─────────────────────────────────────────────┤
│             DOMAIN LAYER                     │
│   Entities • Use Cases • Protocols          │
│   (Business Logic & Rules)                  │
├─────────────────────────────────────────────┤
│              DATA LAYER                      │
│   Repositories • Data Sources • DTOs        │
│   (Data Access & External Services)         │
└─────────────────────────────────────────────┘

▲ DEPENDENCY RULE: Dependencies flow INWARD only ▲
```

**Key Principle**: Inner layers NEVER depend on outer layers.
- Presentation can depend on Domain
- Domain NEVER depends on Presentation or Data
- Data can depend on Domain (implements protocols)

### Layer Structure

```
Sources/
├── Presentation/
│   ├── Features/
│   │   └── [FeatureName]/
│   │       ├── View/           # SwiftUI Views (*View.swift)
│   │       ├── ViewModel/      # ViewModels (*ViewModel.swift)
│   │       └── Router/         # Routers (*Router.swift)
│   └── Shared/                 # Reusable UI components
│
├── Domain/
│   ├── Entities/              # Core business objects
│   ├── UseCases/              # Business logic (*UseCase.swift)
│   └── Repositories/          # Protocol definitions only
│
└── Data/
    ├── Repositories/          # Protocol implementations
    ├── DataSources/           # API clients, Database managers
    └── Models/                # DTOs, API responses
```

### MVVM+C Pattern with ARCNavigation

```swift
// Route Definition (enum-based, type-safe)
enum AppRoute: Route {
    case home
    case profile(userID: String)
    case settings

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home: HomeView()
        case .profile(let userID): ProfileView(userID: userID)
        case .settings: SettingsView()
        }
    }
}

// View (Presentation Layer - pure presentation)
struct UserListView: View {
    @Environment(Router<AppRoute>.self) private var router
    @State var viewModel: UserListViewModel

    var body: some View {
        List(viewModel.users) { user in
            Button(user.name) {
                router.navigate(to: .profile(userID: user.id))
            }
        }
    }
}

// ViewModel (Presentation Layer - coordinates UI state, NO business logic)
@Observable
final class UserListViewModel {
    private(set) var users: [User] = []
    private(set) var isLoading = false

    private let getUsersUseCase: GetUsersUseCaseProtocol

    init(getUsersUseCase: GetUsersUseCaseProtocol) {
        self.getUsersUseCase = getUsersUseCase
    }

    // @MainActor only on methods that update UI-bound state
    @MainActor
    func loadUsers() async {
        isLoading = true
        users = (try? await getUsersUseCase.execute()) ?? []
        isLoading = false
    }
}

// Use Case Protocol (Domain Layer)
protocol GetUsersUseCaseProtocol: Sendable {
    func execute() async throws -> [User]
}

// Use Case (Domain Layer - ALL business logic lives here)
final class GetUsersUseCase: GetUsersUseCaseProtocol, Sendable {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [User] {
        let users = try await repository.getUsers()
        return users.filter { $0.isActive }  // Business rule
    }
}

// Entity (Domain Layer - pure business object)
struct User: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let email: String
    let isActive: Bool
}

// Repository Protocol (Domain Layer)
protocol UserRepositoryProtocol: Sendable {
    func getUsers() async throws -> [User]
}

// Repository Implementation (Data Layer)
final class UserRepositoryImpl: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSourceProtocol

    func getUsers() async throws -> [User] {
        let dtos = try await remoteDataSource.fetchUsers()
        return dtos.map { $0.toDomain() }
    }
}
```

### Use Case Patterns

**Single-responsibility** (default — one operation per Use Case):
```swift
protocol GetUsersUseCaseProtocol: Sendable {
    func execute() async throws -> [User]
}
```

**Grouped Use Case** (when actions are closely related and share dependencies):
```swift
protocol UserFavoritesUseCaseProtocol: Sendable {
    func execute(_ action: UserFavoritesAction) async throws
}

enum UserFavoritesAction: Sendable {
    case add(restaurantID: UUID)
    case remove(restaurantID: UUID)
    case check(restaurantID: UUID)
}

final class UserFavoritesUseCase: UserFavoritesUseCaseProtocol, Sendable {
    private let repository: RestaurantRepositoryProtocol
    private let userRepository: UserRepositoryProtocol

    init(repository: RestaurantRepositoryProtocol,
         userRepository: UserRepositoryProtocol) {
        self.repository = repository
        self.userRepository = userRepository
    }

    func execute(_ action: UserFavoritesAction) async throws {
        switch action {
        case .add(let restaurantID):
            try await addFavorite(restaurantID)
        case .remove(let restaurantID):
            try await removeFavorite(restaurantID)
        case .check(let restaurantID):
            try await checkFavorite(restaurantID)
        }
    }
}

// MARK: - Private Functions

private extension UserFavoritesUseCase {
    func addFavorite(_ restaurantID: UUID) async throws { /* ... */ }
    func removeFavorite(_ restaurantID: UUID) async throws { /* ... */ }
    func checkFavorite(_ restaurantID: UUID) async throws { /* ... */ }
}
```

Use grouped Use Cases ONLY when:
- Actions share the same dependencies (same repositories)
- Actions are semantically related (CRUD on the same resource)
- Splitting would create near-duplicate classes with identical dependencies

**Testing rule**: Every UseCase MUST have corresponding unit tests using Swift Testing.

### Concurrency Guidelines (`@MainActor`)

Follow the **progressive concurrency model** (WWDC 2025-268):

1. **Do NOT apply `@MainActor` to entire ViewModels** — apply it only to specific methods that update UI-bound state
2. **Never put `@MainActor` on Use Cases** — Domain layer is actor-agnostic
3. **Never put `@MainActor` on Repository implementations** — they may run on background
4. **Use `@concurrent` (Swift 6.2+)** for CPU-intensive work
5. **Use actors** for non-UI subsystems with independent mutable state

```swift
// ✅ Correct: @MainActor only on methods that update UI state
@Observable
final class UserListViewModel {
    private(set) var users: [User] = []

    private let getUsersUseCase: GetUsersUseCaseProtocol

    @MainActor
    func loadUsers() async {
        users = (try? await getUsersUseCase.execute()) ?? []
    }
}

// ❌ Wrong: Blanket @MainActor
@MainActor @Observable
final class UserListViewModel { /* ... */ }
```

### SOLID Principles Quick Guide

1. **Single Responsibility**: Each class has one reason to change
2. **Open/Closed**: Open for extension, closed for modification
3. **Liskov Substitution**: Subtypes must be substitutable for base types
4. **Interface Segregation**: Many specific protocols > one general
5. **Dependency Inversion**: Depend on abstractions (protocols), not concretions

### Protocol-Oriented Design

```swift
// Define protocols in Domain layer
protocol UserRepository: Sendable {
    func fetchUsers() async throws -> [User]
    func saveUser(_ user: User) async throws
}

// Implement in Data layer
final class RemoteUserRepository: UserRepository {
    func fetchUsers() async throws -> [User] { /* ... */ }
    func saveUser(_ user: User) async throws { /* ... */ }
}

// Inject via protocols (Dependency Inversion)
final class GetUsersUseCase {
    private let repository: UserRepository  // Protocol, not concrete type

    init(repository: UserRepository) {
        self.repository = repository
    }
}
```

### Dependency Injection Pattern

```swift
// Composition Root (App level)
@MainActor
final class AppDependencies {
    func makeUserListView() -> UserListView {
        let repository = RemoteUserRepository()
        let useCase = GetUsersUseCase(repository: repository)
        let viewModel = UserListViewModel(getUsersUseCase: useCase)
        return UserListView(viewModel: viewModel)
    }
}
```

### When Singletons Are Appropriate

Use singletons ONLY for truly global, unique resources:
- Hardware access (camera, location)
- App configuration
- Analytics/logging

**Always wrap with protocols for testability:**
```swift
protocol LocationServiceProtocol: Sendable {
    func getCurrentLocation() async throws -> Location
}

final class LocationService: LocationServiceProtocol {
    static let shared = LocationService()
    private init() {}

    func getCurrentLocation() async throws -> Location { /* ... */ }
}
```

## Detailed Documentation

For complete patterns, examples, and guidelines:

- **@clean-architecture.md** - Complete Clean Architecture guide with examples
- **@mvvm-c.md** - MVVM+Coordinator pattern implementation details
- **@solid-principles.md** - SOLID principles applied to Swift
- **@protocol-oriented.md** - Protocol-Oriented Programming best practices
- **@singletons.md** - When and how to use singletons safely
- **@domain.md** - Domain layer: Entities, Use Cases, Repository Protocols

## Anti-Patterns to Avoid

- ❌ Business logic in Views or ViewModels (move to Use Cases)
- ❌ ViewModels depending on concrete Repository implementations
- ❌ Domain layer importing UIKit or SwiftUI
- ❌ Data layer containing business logic
- ❌ Massive ViewModels doing everything
- ❌ Global singletons without protocol abstraction
- ❌ Direct navigation without Router (NavigationLink, .sheet)
- ❌ Reverse dependencies (Domain importing Presentation/Data)
- ❌ Blanket `@MainActor` on entire classes (apply per-method)
- ❌ `@MainActor` on Use Cases or Repository implementations
- ❌ Private methods inside type body (use `private extension` instead)

## Related Skills

When working on architecture, you may also need:

| If you need...              | Use                       |
|-----------------------------|---------------------------|
| Data layer implementation   | `/arc-data-layer`         |
| Presentation layer patterns | `/arc-presentation-layer` |
| Testing patterns            | `/arc-tdd-patterns`       |
| Code quality standards      | `/arc-quality-standards`  |
