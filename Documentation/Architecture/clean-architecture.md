# 🏛️ Clean Architecture

**Clean Architecture establishes clear boundaries between business logic and external concerns, making code testable, maintainable, and independent of frameworks.**

---

## 🎯 Core Principle: The Dependency Rule

**Dependencies can only point inward**. Source code dependencies must point only toward higher-level policies.

```
┌─────────────────────────────────────┐
│         Presentation Layer          │  ─┐
│  (Views, ViewModels, Coordinators)  │   │
└─────────────────────────────────────┘   │
              │                            │
              │ depends on                 │  Dependencies
              ↓                            │  flow INWARD
┌─────────────────────────────────────┐   │
│          Domain Layer                │   │
│     (Entities, Use Cases)            │   │
└─────────────────────────────────────┘   │
              ↑                            │
              │ depends on                 │
              │                            │
┌─────────────────────────────────────┐   │
│           Data Layer                 │   │
│  (Repositories, Data Sources)        │  ─┘
└─────────────────────────────────────┘
```

**Critical**: The **Domain Layer** is the center. It knows nothing about:
- How data is stored (Data Layer)
- How data is presented (Presentation Layer)
- What frameworks are used
- What UI components exist

---

## 📂 ARC Labs Layer Structure

### Directory Organization

```
Sources/
├── Presentation/
│   ├── Features/
│   │   └── UserProfile/
│   │       ├── View/
│   │       │   ├── UserProfileView.swift
│   │       │   └── UserProfileDetailView.swift
│   │       ├── ViewModel/
│   │       │   └── UserProfileViewModel.swift
│   │       └── Coordinator/
│   │           └── UserProfileRouter.swift
│   └── Shared/
│       ├── Components/
│       └── Modifiers/
│
├── Domain/
│   ├── Entities/
│   │   ├── User.swift
│   │   └── UserProfile.swift
│   └── UseCases/
│       ├── GetUserProfileUseCase.swift
│       ├── UpdateUserProfileUseCase.swift
│       └── DeleteUserUseCase.swift
│
└── Data/
    ├── Repositories/
    │   └── UserRepositoryImpl.swift
    ├── DataSources/
    │   ├── Remote/
    │   │   └── UserRemoteDataSource.swift
    │   └── Local/
    │       └── UserLocalDataSource.swift
    └── Models/
        └── UserDTO.swift
```

---

## 🏛️ Layer Responsibilities

### 1. Presentation Layer

**Purpose**: Handle user interface and user interactions.

**Components**:
- **Views**: Pure SwiftUI presentation (zero business logic)
- **ViewModels**: Coordinate between View and Use Cases, manage UI state
- **Routers/Coordinators**: Handle navigation and screen flow

**Responsibilities**:
- ✅ Display data to user
- ✅ Capture user input
- ✅ Trigger Use Cases via ViewModels
- ✅ Transform domain data for display
- ✅ Manage UI state (loading, error, success)
- ❌ NO business logic
- ❌ NO direct data access
- ❌ NO knowledge of how data is stored

**Example ViewModel**:
```swift
import Foundation

@Observable
@MainActor
final class UserProfileViewModel {

    // MARK: Private Properties
    
    private(set) var user: User?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    
    // MARK: Initialization
    
    init(getUserProfileUseCase: GetUserProfileUseCaseProtocol) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }
    
    // MARK: Public Functions
    
    func loadUserProfile(userId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await getUserProfileUseCase.execute(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

// MARK: - Private Functions

private extension UserProfileViewModel {
    ...
}
```

---

### 2. Domain Layer

**Purpose**: Contain business logic and business rules. This is the heart of the application.

**Components**:
- **Entities**: Core business objects (User, Product, Order, etc.)
- **Use Cases**: Single-responsibility business operations
- **Repository Protocols**: Abstractions for data access (protocols only, no implementations)

**Responsibilities**:
- ✅ Define business entities
- ✅ Implement business rules
- ✅ Validate business constraints
- ✅ Define repository contracts (protocols)
- ❌ NO knowledge of UI
- ❌ NO knowledge of databases
- ❌ NO knowledge of frameworks
- ❌ NO implementation of data access (only protocols)

**Example Entity**:
```swift
import Foundation

/// Represents a user profile in the system.
///
/// This is a pure business object with no dependencies on frameworks.
struct User: Identifiable, Equatable, Sendable {
    let id: UUID
    let email: String
    let name: String
    let avatarURL: URL?
    let createdAt: Date
    
    /// Validates if the user profile is complete.
    var isProfileComplete: Bool {
        !name.isEmpty && avatarURL != nil
    }
    
    /// Returns a display-friendly name.
    var displayName: String {
        name.isEmpty ? "Anonymous User" : name
    }
}
```

**Example Use Case**:
```swift
import Foundation

/// Protocol defining the contract for getting a user profile.
protocol GetUserProfileUseCaseProtocol: Sendable {
    func execute(userId: UUID) async throws -> User
}

/// Use case for retrieving a user profile.
///
/// This encapsulates the business logic for fetching a user,
/// including any validation or transformation rules.
final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    
    // MARK: Private Properties
    
    private let userRepository: UserRepositoryProtocol
    
    // MARK: Initialization
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    // MARK: Public Functions
    
    func execute(userId: UUID) async throws -> User {
        // Business rule: Validate UUID is not empty
        guard userId != UUID(uuidString: "00000000-0000-0000-0000-000000000000") else {
            throw DomainError.invalidUserId
        }
        
        // Fetch user from repository
        let user = try await userRepository.getUser(by: userId)
        
        // Business rule: User must be active
        guard user.isActive else {
            throw DomainError.userInactive
        }
        
        return user
    }
}

// MARK: - Errors

enum DomainError: LocalizedError {
    case invalidUserId
    case userInactive
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidUserId: return "Invalid user identifier"
        case .userInactive: return "User account is inactive"
        case .userNotFound: return "User not found"
        }
    }
}
```

**Example Repository Protocol** (Domain Layer):
```swift
import Foundation

/// Protocol defining the contract for user data access.
///
/// This lives in the Domain layer but is implemented in the Data layer.
protocol UserRepositoryProtocol: Sendable {
    func getUser(by id: UUID) async throws -> User
    func updateUser(_ user: User) async throws
    func deleteUser(by id: UUID) async throws
    func listUsers() async throws -> [User]
}
```

---

### 3. Data Layer

**Purpose**: Implement data access and persistence.

**Components**:
- **Repository Implementations**: Concrete implementations of Domain protocols
- **Data Sources**: API clients, database managers, cache handlers
- **DTOs**: Data Transfer Objects for API/Database mapping

**Responsibilities**:
- ✅ Implement repository protocols from Domain
- ✅ Handle API communication
- ✅ Manage database operations
- ✅ Cache data when appropriate
- ✅ Map DTOs to Domain entities
- ❌ NO business logic (only data access logic)
- ❌ NO knowledge of UI

**Example Repository Implementation**:
```swift
import Foundation

/// Concrete implementation of UserRepositoryProtocol.
///
/// Coordinates between remote and local data sources.
final class UserRepositoryImpl {
    
    // MARK: Private Properties
    
    private let remoteDataSource: UserRemoteDataSourceProtocol
    private let localDataSource: UserLocalDataSourceProtocol
    
    // MARK: Initialization
    
    init(
        remoteDataSource: UserRemoteDataSourceProtocol,
        localDataSource: UserLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
}

// MARK: - UserRepositoryProtocol

extension UserRepositoryImpl: UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User {
        // Try local cache first
        if let cachedUser = try? await localDataSource.getUser(by: id) {
            return cachedUser.toDomain()
        }
        
        // Fetch from remote
        let userDTO = try await remoteDataSource.fetchUser(by: id)
        let user = userDTO.toDomain()
        
        // Cache locally
        try? await localDataSource.saveUser(userDTO)
        
        return user
    }
    
    func updateUser(_ user: User) async throws {
        let userDTO = UserDTO.fromDomain(user)
        
        // Update remote
        try await remoteDataSource.updateUser(userDTO)
        
        // Update local cache
        try? await localDataSource.saveUser(userDTO)
    }
    
    func deleteUser(by id: UUID) async throws {
        // Delete from remote
        try await remoteDataSource.deleteUser(by: id)
        
        // Delete from local cache
        try? await localDataSource.deleteUser(by: id)
    }
    
    func listUsers() async throws -> [User] {
        let userDTOs = try await remoteDataSource.fetchAllUsers()
        return userDTOs.map { $0.toDomain() }
    }
}
```

**Example Data Source**:
```swift
import Foundation

protocol UserRemoteDataSourceProtocol: Sendable {
    func fetchUser(by id: UUID) async throws -> UserDTO
    func updateUser(_ user: UserDTO) async throws
    func deleteUser(by id: UUID) async throws
    func fetchAllUsers() async throws -> [UserDTO]
}

final class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    
    // MARK: Private Properties

    private let apiClient: APIClientProtocol
    
    // MARK: Initialization

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
}

// MARK: - UserRemoteDataSourceProtocol

extension UserRemoteDataSource: UserRemoteDataSourceProtocol {
    func fetchUser(by id: UUID) async throws -> UserDTO {
        try await apiClient.request(
            endpoint: .user(id),
            method: .get,
            responseType: UserDTO.self
        )
    }
    
    func updateUser(_ user: UserDTO) async throws {
        try await apiClient.request(
            endpoint: .user(user.id),
            method: .put,
            body: user,
            responseType: UserDTO.self
        )
    }
    
    func deleteUser(by id: UUID) async throws {
        try await apiClient.request(
            endpoint: .user(id),
            method: .delete,
            responseType: EmptyResponse.self
        )
    }
    
    func fetchAllUsers() async throws -> [UserDTO] {
        try await apiClient.request(
            endpoint: .users,
            method: .get,
            responseType: [UserDTO].self
        )
    }
}
```

**Example DTO**:
```swift
import Foundation

/// Data Transfer Object for User.
///
/// This represents the API/Database structure, not the business entity.
struct UserDTO: Codable, Sendable {
    let id: String
    let email: String
    let name: String
    let avatarUrl: String?
    let isActive: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case avatarUrl = "avatar_url"
        case isActive = "is_active"
        case createdAt = "created_at"
    }
    
    /// Maps DTO to Domain entity.
    func toDomain() -> User {
        User(
            id: UUID(uuidString: id) ?? UUID(),
            email: email,
            name: name,
            avatarURL: avatarUrl.flatMap(URL.init(string:)),
            isActive: isActive,
            createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date()
        )
    }
    
    /// Maps Domain entity to DTO.
    static func fromDomain(_ user: User) -> UserDTO {
        UserDTO(
            id: user.id.uuidString,
            email: user.email,
            name: user.name,
            avatarUrl: user.avatarURL?.absoluteString,
            isActive: user.isActive,
            createdAt: ISO8601DateFormatter().string(from: user.createdAt)
        )
    }
}
```

---

## 🔄 Data Flow Example

### Complete Flow: User Profile Feature

**1. User Action (Presentation Layer)**
```swift
// UserProfileView.swift
Button("Load Profile") {
    Task {
        await viewModel.loadUserProfile(userId: currentUserId)
    }
}
```

**2. ViewModel Coordinates (Presentation Layer)**
```swift
// UserProfileViewModel.swift
func loadUserProfile(userId: UUID) async {
    isLoading = true
    
    do {
        // Call Use Case (Domain Layer)
        user = try await getUserProfileUseCase.execute(userId: userId)
    } catch {
        errorMessage = error.localizedDescription
    }
    
    isLoading = false
}
```

**3. Use Case Executes Business Logic (Domain Layer)**
```swift
// GetUserProfileUseCase.swift
func execute(userId: UUID) async throws -> User {
    // Validate business rules
    guard userId != UUID() else {
        throw DomainError.invalidUserId
    }
    
    // Request data from Repository Protocol
    let user = try await userRepository.getUser(by: userId)
    
    // Apply business rules
    guard user.isActive else {
        throw DomainError.userInactive
    }
    
    return user
}
```

**4. Repository Fetches Data (Data Layer)**
```swift
// UserRepositoryImpl.swift
func getUser(by id: UUID) async throws -> User {
    // Check cache
    if let cached = try? await localDataSource.getUser(by: id) {
        return cached.toDomain()
    }
    
    // Fetch from API
    let dto = try await remoteDataSource.fetchUser(by: id)
    
    // Cache for future use
    try? await localDataSource.saveUser(dto)
    
    // Map to Domain entity
    return dto.toDomain()
}
```

**5. Data Source Makes Network Call (Data Layer)**
```swift
// UserRemoteDataSource.swift
func fetchUser(by id: UUID) async throws -> UserDTO {
    try await apiClient.request(
        endpoint: .user(id),
        method: .get,
        responseType: UserDTO.self
    )
}
```

---

## 🧪 Testing Benefits

Clean Architecture makes testing straightforward:

### Testing Use Case (Domain Layer)
```swift
@Test
func getUserProfile_withValidId_returnsUser() async throws {
    // Arrange
    let mockRepository = MockUserRepository()
    let expectedUser = User.mock
    mockRepository.getUserResult = .success(expectedUser)
    
    let useCase = GetUserProfileUseCase(userRepository: mockRepository)
    
    // Act
    let user = try await useCase.execute(userId: expectedUser.id)
    
    // Assert
    #expect(user == expectedUser)
    #expect(mockRepository.getUserCalled == true)
}
```

### Testing ViewModel (Presentation Layer)
```swift
@Test
func loadUserProfile_withValidId_updatesUser() async throws {
    // Arrange
    let mockUseCase = MockGetUserProfileUseCase()
    let expectedUser = User.mock
    mockUseCase.executeResult = .success(expectedUser)
    
    let viewModel = UserProfileViewModel(getUserProfileUseCase: mockUseCase)
    
    // Act
    await viewModel.loadUserProfile(userId: expectedUser.id)
    
    // Assert
    #expect(viewModel.user == expectedUser)
    #expect(viewModel.isLoading == false)
    #expect(viewModel.errorMessage == nil)
}
```

### Testing Repository (Data Layer)
```swift
@Test
func getUser_withCachedData_returnsCachedUser() async throws {
    // Arrange
    let mockRemote = MockUserRemoteDataSource()
    let mockLocal = MockUserLocalDataSource()
    let cachedUser = UserDTO.mock
    mockLocal.getUserResult = .success(cachedUser)
    
    let repository = UserRepositoryImpl(
        remoteDataSource: mockRemote,
        localDataSource: mockLocal
    )
    
    // Act
    let user = try await repository.getUser(by: cachedUser.id)
    
    // Assert
    #expect(mockLocal.getUserCalled == true)
    #expect(mockRemote.fetchUserCalled == false) // Should NOT call remote
    #expect(user.id.uuidString == cachedUser.id)
}
```

---

## ✅ Clean Architecture Checklist

Before considering your architecture correct, verify:

### Dependency Direction
- [ ] Presentation depends on Domain ✅
- [ ] Data depends on Domain ✅
- [ ] Domain depends on nothing ✅
- [ ] No reverse dependencies ❌

### Layer Isolation
- [ ] Views contain zero business logic
- [ ] ViewModels only coordinate, don't implement business rules
- [ ] Use Cases contain all business logic
- [ ] Entities are pure data with behavior
- [ ] Repositories only handle data access

### Protocol Usage
- [ ] Repository protocols defined in Domain
- [ ] Repository implementations in Data
- [ ] Use Case protocols for dependency injection
- [ ] No protocol in Presentation unless for testing

### Testing
- [ ] Use Cases testable without UI
- [ ] Repositories testable without real network/database
- [ ] ViewModels testable with mock Use Cases
- [ ] No test depends on external systems

---

## 🚫 Common Mistakes

### ❌ Mistake 1: ViewModel Contains Business Logic
```swift
// WRONG: Business logic in ViewModel
@Observable
final class BadViewModel {
    func calculateDiscount(price: Decimal) -> Decimal {
        if price > 100 {
            return price * 0.9  // Business rule in Presentation!
        }
        return price
    }
}
```

✅ **Correct**: Use Case in Domain
```swift
// Domain/UseCases/CalculateDiscountUseCase.swift
final class CalculateDiscountUseCase {
    func execute(price: Decimal) -> Decimal {
        if price > 100 {
            return price * 0.9
        }
        return price
    }
}

// Presentation/ViewModel
@Observable
final class GoodViewModel {
    private let calculateDiscountUseCase: CalculateDiscountUseCase
    
    func applyDiscount(to price: Decimal) -> Decimal {
        calculateDiscountUseCase.execute(price: price)
    }
}
```

---

### ❌ Mistake 2: Domain Depends on Data
```swift
// WRONG: Entity imports Data layer
import Foundation
import DataLayer  // ❌ Domain should NOT import Data!

struct User {
    let repository: UserRepository  // ❌ Domain entity knows about Data!
}
```

✅ **Correct**: Dependency Inversion
```swift
// Domain/Repositories/UserRepositoryProtocol.swift
protocol UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User
}

// Data/Repositories/UserRepositoryImpl.swift
final class UserRepositoryImpl: UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User {
        // Implementation
    }
}
```

---

### ❌ Mistake 3: No Use Cases (Direct Repository Access)
```swift
// WRONG: ViewModel calls Repository directly
@Observable
final class BadViewModel {
    private let userRepository: UserRepositoryProtocol
    
    func loadUser() async {
        let user = try? await userRepository.getUser(by: userId)
        // Where does business logic go?
    }
}
```

✅ **Correct**: Use Case as Intermediary
```swift
// Domain/UseCases/GetUserUseCase.swift
final class GetUserUseCase {
    private let repository: UserRepositoryProtocol
    
    func execute(userId: UUID) async throws -> User {
        // Business logic here
        let user = try await repository.getUser(by: userId)
        
        guard user.isActive else {
            throw DomainError.userInactive
        }
        
        return user
    }
}

// Presentation/ViewModel
@Observable
final class GoodViewModel {
    private let getUserUseCase: GetUserUseCase
    
    func loadUser() async {
        user = try? await getUserUseCase.execute(userId: userId)
    }
}
```

---

## 📚 Further Reading

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [The Clean Architecture (Book)](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)
- SOLID Principles documentation
- Dependency Inversion Principle

---

**Remember**: Clean Architecture is about **boundaries and dependencies**. Keep the Domain pure, make everything testable, and let the architecture guide you toward maintainable code. 🏛️
