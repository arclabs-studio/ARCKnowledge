# 🔌 Protocol-Oriented Design in Swift

**Protocol-Oriented Programming (POP) uses protocols as the primary abstraction mechanism, enabling flexible, testable, and reusable code.**

---

## 🎯 Core Philosophy

**"Don't start with a class. Start with a protocol."** - Apple WWDC 2015

Protocol-Oriented Design prioritizes:
1. **Protocols** over classes
2. **Composition** over inheritance
3. **Value types** (structs) over reference types (classes)
4. **Behavior** over data

---

## 🤔 When to Use Protocols

### Decision Tree

```
Do I need abstraction for this type?
├─ YES
│   ├─ Multiple implementations exist? → Protocol
│   ├─ Need dependency injection? → Protocol
│   ├─ Need to mock for testing? → Protocol
│   └─ Defining a contract? → Protocol
│
└─ NO
    ├─ Simple data container? → Struct (no protocol)
    ├─ Single concrete implementation? → Struct/Class (no protocol yet)
    └─ Framework/Library API? → Consider protocol for flexibility
```

### ✅ Use Protocols When:

**1. Multiple Implementations**
```swift
protocol DataSource {
    func fetch() async throws -> Data
}

struct NetworkDataSource: DataSource { }
struct CacheDataSource: DataSource { }
struct MockDataSource: DataSource { }  // For testing
```

**2. Dependency Injection**
```swift
protocol UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User
}

final class GetUserUseCase {
    private let repository: UserRepositoryProtocol  // Injected
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
}
```

**3. Testing & Mocking**
```swift
protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// Easy to mock in tests
final class MockAPIClient: APIClient {
    var mockResponse: Any?
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        mockResponse as! T
    }
}
```

**4. Defining Contracts**
```swift
// Contract: All payment methods must process payments
protocol PaymentMethod {
    func process(amount: Decimal) async throws
    func refund(amount: Decimal) async throws
}
```

---

### ❌ Don't Use Protocols When:

**1. Single, Simple Implementation**
```swift
// WRONG: Unnecessary protocol
protocol UserFormatterProtocol {
    func format(_ user: User) -> String
}

struct UserFormatter: UserFormatterProtocol {
    func format(_ user: User) -> String {
        "\(user.firstName) \(user.lastName)"
    }
}

// RIGHT: No protocol needed (yet)
struct UserFormatter {
    func format(_ user: User) -> String {
        "\(user.firstName) \(user.lastName)"
    }
}
```

**2. Pure Data Containers**
```swift
// WRONG: Protocol for simple entity
protocol UserProtocol {
    var id: UUID { get }
    var name: String { get }
}

struct User: UserProtocol {
    let id: UUID
    let name: String
}

// RIGHT: Just a struct
struct User {
    let id: UUID
    let name: String
}
```

**3. UI-Only Logic**
```swift
// WRONG: Protocol for SwiftUI view helpers
protocol ViewHelperProtocol {
    func formatDate(_ date: Date) -> String
}

// RIGHT: Simple struct with utility methods
struct ViewHelper {
    func formatDate(_ date: Date) -> String {
        // Implementation
    }
}
```

**3. Presentation-Only Logic**
```swift
// WRONG: Protocol for ViewModel
protocol ViewModelProtocol {
    func setup()
}

// RIGHT: Simple class with presentation methods
@Observable
final class ViewModel {
    func setup() {
        // Implementation
    }
}
```

---

## 📋 Protocol Design Patterns

### Pattern 1: Repository Protocol (Data Layer)

**Purpose**: Abstract data access for testing and flexibility

```swift
// MARK: - Domain Layer (Protocol Definition)

protocol UserRepositoryProtocol: Sendable {
    func getUser(by id: UUID) async throws -> User
    func listUsers() async throws -> [User]
    func saveUser(_ user: User) async throws
    func deleteUser(by id: UUID) async throws
}

// MARK: - Data Layer (Implementation)

final class UserRepositoryImpl: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSourceProtocol
    private let localDataSource: UserLocalDataSourceProtocol
    
    init(
        remoteDataSource: UserRemoteDataSourceProtocol,
        localDataSource: UserLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getUser(by id: UUID) async throws -> User {
        // Try cache first
        if let cached = try? await localDataSource.getUser(by: id) {
            return cached.toDomain()
        }
        
        // Fetch from remote
        let dto = try await remoteDataSource.fetchUser(by: id)
        let user = dto.toDomain()
        
        // Cache for next time
        try? await localDataSource.saveUser(dto)
        
        return user
    }
    
    // ... other methods
}

// MARK: - Testing

final class MockUserRepository: UserRepositoryProtocol {
    var getUserResult: Result<User, Error> = .failure(TestError.notImplemented)
    
    func getUser(by id: UUID) async throws -> User {
        try getUserResult.get()
    }
    
    // ... mock other methods
}
```

---

### Pattern 2: Use Case Protocol (Domain Layer)

**Purpose**: Define business operations as testable units

```swift
// MARK: - Protocol

protocol GetUserProfileUseCaseProtocol: Sendable {
    func execute(userId: UUID) async throws -> User
}

// MARK: - Implementation

final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    private let validator: UserValidatorProtocol
    
    init(
        userRepository: UserRepositoryProtocol,
        validator: UserValidatorProtocol
    ) {
        self.userRepository = userRepository
        self.validator = validator
    }
    
    func execute(userId: UUID) async throws -> User {
        // Validation
        try validator.validateUserId(userId)
        
        // Fetch
        let user = try await userRepository.getUser(by: userId)
        
        // Business rule
        guard user.isActive else {
            throw DomainError.userInactive
        }
        
        return user
    }
}

// MARK: - Testing

final class MockGetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    var executeResult: Result<User, Error> = .failure(TestError.notImplemented)
    var executeCalled = false
    
    func execute(userId: UUID) async throws -> User {
        executeCalled = true
        return try executeResult.get()
    }
}
```

---

### Pattern 3: Protocol Composition

**Purpose**: Combine multiple protocols for flexible requirements

```swift
// Small, focused protocols
protocol Fetchable {
    func fetch() async throws -> Data
}

protocol Cacheable {
    func cache(_ data: Data) async throws
    func getCached() async -> Data?
}

protocol Syncable {
    func sync() async throws
}

// Compose when needed
typealias DataRepository = Fetchable & Cacheable

// Or create new protocol that inherits
protocol FullDataRepository: Fetchable, Cacheable, Syncable { }

// Implementation
final class NetworkRepository: FullDataRepository {
    func fetch() async throws -> Data { }
    func cache(_ data: Data) async throws { }
    func getCached() async -> Data? { }
    func sync() async throws { }
}

// Use cases only depend on what they need
final class GetDataUseCase {
    private let repository: Fetchable  // Only needs fetching
    
    init(repository: Fetchable) {
        self.repository = repository
    }
}
```

---

### Pattern 4: Protocol with Associated Types

**Purpose**: Generic protocols for type-safe operations

```swift
// Generic repository protocol
protocol Repository {
    associatedtype Entity: Identifiable
    
    func get(by id: Entity.ID) async throws -> Entity
    func list() async throws -> [Entity]
    func save(_ entity: Entity) async throws
    func delete(by id: Entity.ID) async throws
}

// Concrete implementation
final class UserRepository: Repository {
    typealias Entity = User
    
    func get(by id: UUID) async throws -> User {
        // Implementation
    }
    
    func list() async throws -> [User] {
        // Implementation
    }
    
    func save(_ entity: User) async throws {
        // Implementation
    }
    
    func delete(by id: UUID) async throws {
        // Implementation
    }
}

// Another implementation
final class RestaurantRepository: Repository {
    typealias Entity = Restaurant
    
    func get(by id: UUID) async throws -> Restaurant {
        // Implementation
    }
    
    // ... other methods
}
```

---

### Pattern 5: Protocol Extensions (Default Implementations)

**Purpose**: Provide default behavior while allowing customization

```swift
protocol Loggable {
    func log(_ message: String)
}

// Default implementation
extension Loggable {
    func log(_ message: String) {
        print("[LOG] \(message)")
    }
    
    func logError(_ error: Error) {
        log("ERROR: \(error.localizedDescription)")
    }
}

// Types get default behavior for free
struct NetworkService: Loggable {
    func fetchData() async throws -> Data {
        log("Fetching data...")
        // Implementation
    }
}

// Can override if needed
struct CustomService: Loggable {
    func log(_ message: String) {
        // Custom logging implementation
        ARCLogger.shared.debug(message)
    }
}
```

---

## 🏗️ ARC Labs Protocol Patterns

### Repositories (Always Use Protocols)

```swift
// ✅ ALWAYS define protocol in Domain layer
protocol RestaurantRepositoryProtocol: Sendable {
    func getRestaurants() async throws -> [Restaurant]
    func getRestaurant(by id: UUID) async throws -> Restaurant
    func saveRestaurant(_ restaurant: Restaurant) async throws
}

// ✅ ALWAYS implement in Data layer
final class RestaurantRepositoryImpl: RestaurantRepositoryProtocol {
    // Implementation
}
```

### Use Cases (Always Use Protocols)

```swift
// ✅ ALWAYS define protocol
protocol GetRestaurantsUseCaseProtocol: Sendable {
    func execute() async throws -> [Restaurant]
}

// ✅ ALWAYS implement
final class GetRestaurantsUseCase: GetRestaurantsUseCaseProtocol {
    private let repository: RestaurantRepositoryProtocol
    
    func execute() async throws -> [Restaurant] {
        try await repository.getRestaurants()
    }
}
```

### ViewModels (Usually No Protocol)

```swift
// ❌ DON'T use protocol for ViewModels (usually)
protocol UserProfileViewModelProtocol {
    var user: User? { get }
    func loadUser() async
}

// ✅ DO use concrete class
@Observable
@MainActor
final class UserProfileViewModel {
    private(set) var user: User?
    private let getUserUseCase: GetUserProfileUseCaseProtocol
    
    func loadUser() async {
        user = try? await getUserUseCase.execute(userId: userId)
    }
}
```

**Exception**: Protocol for ViewModel when:
- Shared between multiple Views
- Need to mock in integration tests
- Multiple implementations exist

---

## 🧪 Protocols for Testing

### Mock Pattern

```swift
// Protocol
protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// Mock implementation
final class MockAPIClient: APIClient {
    var requestCalled = false
    var requestEndpoint: Endpoint?
    var requestResult: Result<Any, Error> = .failure(TestError.notSet)
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        requestCalled = true
        requestEndpoint = endpoint
        
        let result = try requestResult.get()
        guard let typed = result as? T else {
            throw TestError.invalidType
        }
        return typed
    }
}

// Test
@Test
func fetchUser_callsAPIWithCorrectEndpoint() async throws {
    // Arrange
    let mockAPI = MockAPIClient()
    mockAPI.requestResult = .success(UserDTO.mock)
    let repository = UserRepositoryImpl(apiClient: mockAPI)
    
    // Act
    _ = try await repository.getUser(by: UUID())
    
    // Assert
    #expect(mockAPI.requestCalled == true)
    #expect(mockAPI.requestEndpoint == .user(UUID()))
}
```

---

## ✅ Protocol Best Practices

### 1. Keep Protocols Focused (ISP)

```swift
// ✅ Good: Small, focused protocols
protocol UserReader {
    func getUser(by id: UUID) async throws -> User
}

protocol UserWriter {
    func saveUser(_ user: User) async throws
}

typealias UserRepository = UserReader & UserWriter

// ❌ Bad: Fat protocol
protocol UserManager {
    func getUser(by id: UUID) async throws -> User
    func saveUser(_ user: User) async throws
    func deleteUser(by id: UUID) async throws
    func listUsers() async throws -> [User]
    func searchUsers(query: String) async throws -> [User]
    func exportUsers() async throws -> Data
}
```

### 2. Use Sendable for Concurrency Safety

```swift
// ✅ Always mark protocols as Sendable when used across actors
protocol UserRepositoryProtocol: Sendable {
    func getUser(by id: UUID) async throws -> User
}
```

### 3. Provide Default Implementations Wisely

```swift
protocol Cacheable {
    func cache(_ data: Data, for key: String) async throws
    func getCached(for key: String) async -> Data?
}

// ✅ Good: Useful default that can be overridden
extension Cacheable {
    func cache(_ data: Data, for key: String) async throws {
        // Default in-memory caching
        InMemoryCache.shared.store(data, key: key)
    }
}

// ❌ Bad: Don't provide defaults for core functionality
extension Repository {
    func save(_ entity: Entity) async throws {
        fatalError("Must override")  // ❌ Never do this!
    }
}
```

### 4. Name Protocols Clearly

```swift
// ✅ Good: Clear, descriptive names
protocol UserRepositoryProtocol { }
protocol PaymentServiceProtocol { }
protocol DataSourceProtocol { }

// ❌ Bad: Vague or redundant names
protocol UserProtocol { }  // What does this represent?
protocol IUser { }         // Hungarian notation (outdated)
protocol Userable { }      // Awkward naming
```

---

## 🚫 Common Mistakes

### Mistake 1: Premature Protocol Abstraction

```swift
// ❌ Bad: Protocol before you need it
protocol DateFormatterProtocol {
    func format(_ date: Date) -> String
}

struct DateFormatter: DateFormatterProtocol {
    func format(_ date: Date) -> String {
        // Only one implementation exists!
    }
}

// ✅ Good: Start with struct, add protocol when second implementation appears
struct DateFormatter {
    func format(_ date: Date) -> String {
        // Implementation
    }
}

// Later, if you add MockDateFormatter for tests:
protocol DateFormatterProtocol {
    func format(_ date: Date) -> String
}

struct DateFormatter: DateFormatterProtocol { }
struct MockDateFormatter: DateFormatterProtocol { }
```

### Mistake 2: Protocol for Everything

```swift
// ❌ Bad: Entity with protocol
protocol UserProtocol {
    var id: UUID { get }
    var name: String { get }
}

struct User: UserProtocol {
    let id: UUID
    let name: String
}

// ✅ Good: Plain struct
struct User {
    let id: UUID
    let name: String
}
```

### Mistake 3: Forgetting Sendable

```swift
// ❌ Bad: Protocol used across actors without Sendable
protocol APIClient {
    func request() async throws -> Data
}

@MainActor
func useAPI(client: APIClient) async {
    // Compiler warning! APIClient not Sendable
}

// ✅ Good: Add Sendable conformance
protocol APIClient: Sendable {
    func request() async throws -> Data
}
```

---

## 📊 Protocol Decision Matrix

| Scenario | Use Protocol? | Reasoning |
|----------|---------------|-----------|
| Repository (Data Layer) | ✅ YES | Need abstraction for testing, multiple sources |
| Use Case (Domain Layer) | ✅ YES | Testability, dependency injection |
| ViewModel (Presentation) | ❌ NO* | Usually single implementation (*unless shared/tested) |
| Entity (Domain Model) | ❌ NO | Pure data, no abstraction needed |
| Data Source (Data Layer) | ✅ YES | Multiple implementations (network, cache, mock) |
| API Client | ✅ YES | Testability, swap implementations |
| Formatter/Validator | ❌ NO* | Usually single impl (*add protocol if mocking needed) |

---

## ✅ Protocol Checklist

Before creating a protocol, verify:

- [ ] Multiple implementations exist or will exist
- [ ] Need dependency injection for testability
- [ ] Defining a contract that others will implement
- [ ] Protocol is focused and cohesive (ISP)
- [ ] Protocol is marked Sendable if used with async/await
- [ ] Protocol name is clear and descriptive
- [ ] Default implementations (if any) are genuinely useful
- [ ] Not prematurely abstracting a single implementation

---

## 📚 Further Reading

- [Protocol-Oriented Programming in Swift (WWDC 2015)](https://developer.apple.com/videos/play/wwdc2015/408/)
- [Protocol-Oriented Programming is Not a Silver Bullet](https://chris.eidhof.nl/post/protocol-oriented-programming/)
- Swift Language Guide: Protocols

---

**Remember**: Protocols are powerful but should be used **purposefully**. Start simple, add protocols when you need abstraction, not before. 🎯
