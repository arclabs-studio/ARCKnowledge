# 📐 SOLID Principles in Swift

**SOLID principles guide object-oriented design to create maintainable, scalable, and testable code.**

---

## 🎯 The Five Principles

1. **S**ingle Responsibility Principle
2. **O**pen/Closed Principle
3. **L**iskov Substitution Principle
4. **I**nterface Segregation Principle
5. **D**ependency Inversion Principle

---

## 1️⃣ Single Responsibility Principle (SRP)

**Definition**: A class should have one, and only one, reason to change.

**Translation**: Each type should do **one thing** and do it well.

### ❌ Violation Example

```swift
// WRONG: UserManager does too many things
final class UserManager {
    func fetchUser(id: UUID) async throws -> User {
        // Network logic
        let url = URL(string: "https://api.example.com/users/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func saveUser(_ user: User) throws {
        // Database logic
        let context = PersistenceController.shared.container.viewContext
        // ... CoreData save logic
    }
    
    func validateUser(_ user: User) -> Bool {
        // Validation logic
        return !user.email.isEmpty && user.email.contains("@")
    }
    
    func formatUserDisplay(_ user: User) -> String {
        // Formatting logic
        return "\(user.firstName) \(user.lastName)"
    }
}
```

**Problem**: `UserManager` has **4 reasons to change**:
1. API changes
2. Database changes
3. Validation rules change
4. Display format changes

### ✅ Correct Implementation

```swift
// Network responsibility
final class UserAPIClient {
    func fetchUser(id: UUID) async throws -> UserDTO {
        let url = URL(string: "https://api.example.com/users/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(UserDTO.self, from: data)
    }
}

// Persistence responsibility
final class UserLocalDataSource {
    func save(_ user: User) throws {
        let context = PersistenceController.shared.container.viewContext
        // ... CoreData save logic
    }
}

// Validation responsibility
struct UserValidator {
    func validate(_ user: User) -> ValidationResult {
        guard !user.email.isEmpty else {
            return .failure(.emptyEmail)
        }
        guard user.email.contains("@") else {
            return .failure(.invalidEmail)
        }
        return .success
    }
}

// Formatting responsibility
struct UserFormatter {
    func displayName(for user: User) -> String {
        "\(user.firstName) \(user.lastName)"
    }
}
```

**Benefit**: Each type now has **one reason to change**.

### SRP in ARC Labs Architecture

```swift
// ✅ Good: Each type has single responsibility

// UseCase: Business logic only
final class GetUserProfileUseCase {
    private let repository: UserRepositoryProtocol
    
    func execute(userId: UUID) async throws -> User {
        try await repository.getUser(by: userId)
    }
}

// Repository: Data access only
final class UserRepositoryImpl: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSourceProtocol
    
    func getUser(by id: UUID) async throws -> User {
        let dto = try await remoteDataSource.fetchUser(by: id)
        return dto.toDomain()
    }
}

// ViewModel: UI coordination only
@Observable
final class UserProfileViewModel {
    private let getUserUseCase: GetUserProfileUseCaseProtocol
    
    func loadUser() async {
        user = try? await getUserUseCase.execute(userId: userId)
    }
}
```

---

## 2️⃣ Open/Closed Principle (OCP)

**Definition**: Software entities should be **open for extension** but **closed for modification**.

**Translation**: Add new behavior without changing existing code.

### ❌ Violation Example

```swift
// WRONG: Adding new payment methods requires modifying existing class
final class PaymentProcessor {
    func processPayment(method: String, amount: Decimal) {
        if method == "creditCard" {
            // Credit card logic
        } else if method == "paypal" {
            // PayPal logic
        } else if method == "applePay" {
            // Apple Pay logic
        }
        // Adding new payment method requires modifying this class!
    }
}
```

**Problem**: Every new payment method forces modification of `PaymentProcessor`.

### ✅ Correct Implementation

```swift
// Protocol defines contract
protocol PaymentMethod {
    func process(amount: Decimal) async throws
}

// Each payment method is a separate implementation
struct CreditCardPayment: PaymentMethod {
    let cardNumber: String
    
    func process(amount: Decimal) async throws {
        // Credit card processing
    }
}

struct PayPalPayment: PaymentMethod {
    let email: String
    
    func process(amount: Decimal) async throws {
        // PayPal processing
    }
}

struct ApplePayPayment: PaymentMethod {
    func process(amount: Decimal) async throws {
        // Apple Pay processing
    }
}

// Processor is now closed for modification, open for extension
final class PaymentProcessor {
    func processPayment(method: PaymentMethod, amount: Decimal) async throws {
        try await method.process(amount: amount)
    }
}

// Adding new payment method: no modification needed!
struct GooglePayPayment: PaymentMethod {
    func process(amount: Decimal) async throws {
        // Google Pay processing
    }
}
```

**Benefit**: Add new payment methods without touching `PaymentProcessor`.

### OCP with Swift Protocols

```swift
// Base protocol
protocol DataSource {
    func fetch() async throws -> Data
}

// Implementations
struct NetworkDataSource: DataSource {
    func fetch() async throws -> Data {
        // Network fetch
    }
}

struct CacheDataSource: DataSource {
    func fetch() async throws -> Data {
        // Cache fetch
    }
}

struct DatabaseDataSource: DataSource {
    func fetch() async throws -> Data {
        // Database fetch
    }
}

// Repository: open for new data sources, closed for modification
final class Repository {
    private let dataSources: [DataSource]
    
    init(dataSources: [DataSource]) {
        self.dataSources = dataSources
    }
    
    func fetch() async throws -> Data {
        for source in dataSources {
            if let data = try? await source.fetch() {
                return data
            }
        }
        throw RepositoryError.noDataAvailable
    }
}
```

---

## 3️⃣ Liskov Substitution Principle (LSP)

**Definition**: Objects of a superclass should be replaceable with objects of a subclass without breaking the application.

**Translation**: Subtypes must be **substitutable** for their base types.

### ❌ Violation Example

```swift
// WRONG: Square violates LSP
class Rectangle {
    var width: Double
    var height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    func area() -> Double {
        width * height
    }
}

class Square: Rectangle {
    override var width: Double {
        didSet { height = width }  // Forces height = width
    }
    
    override var height: Double {
        didSet { width = height }  // Forces width = height
    }
}

// This breaks when using Square as Rectangle!
func testRectangle(_ rect: Rectangle) {
    rect.width = 5
    rect.height = 10
    print(rect.area())  // Expected: 50
}

let square = Square(width: 5, height: 5)
testRectangle(square)  // Prints: 100 (not 50!)
```

**Problem**: `Square` **violates expectations** of `Rectangle`.

### ✅ Correct Implementation

```swift
// Protocol defines behavior
protocol Shape {
    func area() -> Double
}

// Separate, unrelated implementations
struct Rectangle: Shape {
    let width: Double
    let height: Double
    
    func area() -> Double {
        width * height
    }
}

struct Square: Shape {
    let side: Double
    
    func area() -> Double {
        side * side
    }
}

// Now both are substitutable for Shape
func calculateTotalArea(shapes: [Shape]) -> Double {
    shapes.reduce(0) { $0 + $1.area() }
}
```

### LSP in Repository Pattern

```swift
// ✅ Good: All implementations satisfy protocol contract
protocol UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User
}

// Implementation 1: Network + Cache
final class NetworkUserRepository: UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User {
        // Fetch from network, cache result
    }
}

// Implementation 2: Local only
final class LocalUserRepository: UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User {
        // Fetch from local database
    }
}

// Implementation 3: Mock for testing
final class MockUserRepository: UserRepositoryProtocol {
    var mockUser: User?
    
    func getUser(by id: UUID) async throws -> User {
        guard let user = mockUser else {
            throw RepositoryError.notFound
        }
        return user
    }
}

// All implementations are substitutable
final class GetUserUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository  // Any implementation works!
    }
    
    func execute(userId: UUID) async throws -> User {
        try await repository.getUser(by: userId)
    }
}
```

---

## 4️⃣ Interface Segregation Principle (ISP)

**Definition**: No client should be forced to depend on methods it does not use.

**Translation**: Keep protocols **small and focused**.

### ❌ Violation Example

```swift
// WRONG: Fat protocol
protocol DataManager {
    func fetchData() async throws -> Data
    func saveData(_ data: Data) throws
    func deleteData() throws
    func syncData() async throws
    func exportData() throws -> URL
    func importData(from url: URL) throws
}

// This class only needs to fetch, but must implement everything!
final class ReadOnlyDataManager: DataManager {
    func fetchData() async throws -> Data {
        // Real implementation
    }
    
    // Forced to implement these even though not needed
    func saveData(_ data: Data) throws {
        fatalError("Read-only!")
    }
    
    func deleteData() throws {
        fatalError("Read-only!")
    }
    
    func syncData() async throws {
        fatalError("Read-only!")
    }
    
    func exportData() throws -> URL {
        fatalError("Read-only!")
    }
    
    func importData(from url: URL) throws {
        fatalError("Read-only!")
    }
}
```

**Problem**: `ReadOnlyDataManager` forced to implement methods it doesn't need.

### ✅ Correct Implementation

```swift
// Split into focused protocols
protocol DataReader {
    func fetchData() async throws -> Data
}

protocol DataWriter {
    func saveData(_ data: Data) throws
    func deleteData() throws
}

protocol DataSyncer {
    func syncData() async throws
}

protocol DataExporter {
    func exportData() throws -> URL
    func importData(from url: URL) throws
}

// Now implement only what you need
final class ReadOnlyDataManager: DataReader {
    func fetchData() async throws -> Data {
        // Implementation
    }
}

final class FullDataManager: DataReader, DataWriter, DataSyncer {
    func fetchData() async throws -> Data { }
    func saveData(_ data: Data) throws { }
    func deleteData() throws { }
    func syncData() async throws { }
}
```

### ISP in ARC Labs

```swift
// ✅ Good: Focused protocols

// Minimal reading protocol
protocol UserReader {
    func getUser(by id: UUID) async throws -> User
    func listUsers() async throws -> [User]
}

// Minimal writing protocol
protocol UserWriter {
    func saveUser(_ user: User) async throws
    func deleteUser(by id: UUID) async throws
}

// Combine when needed
typealias UserRepository = UserReader & UserWriter

// Use cases depend only on what they need
final class GetUserUseCase {
    private let reader: UserReader  // Only needs reading
    
    init(reader: UserReader) {
        self.reader = reader
    }
}

final class UpdateUserUseCase {
    private let writer: UserWriter  // Only needs writing
    
    init(writer: UserWriter) {
        self.writer = writer
    }
}
```

---

## 5️⃣ Dependency Inversion Principle (DIP)

**Definition**: High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Translation**: Depend on **protocols**, not concrete implementations.

### ❌ Violation Example

```swift
// WRONG: ViewModel depends on concrete implementation
final class UserProfileViewModel {
    private let apiClient = URLSession.shared  // Direct dependency!
    
    func loadUser() async {
        let url = URL(string: "https://api.example.com/user")!
        let (data, _) = try! await apiClient.data(from: url)
        // Process data...
    }
}
```

**Problem**: 
- Can't test without real network
- Tightly coupled to URLSession
- Can't swap implementations

### ✅ Correct Implementation

```swift
// Protocol (abstraction)
protocol UserRepositoryProtocol {
    func getUser() async throws -> User
}

// Concrete implementation
final class UserRepositoryImpl: UserRepositoryProtocol {
    private let apiClient: URLSession
    
    init(apiClient: URLSession = .shared) {
        self.apiClient = apiClient
    }
    
    func getUser() async throws -> User {
        let url = URL(string: "https://api.example.com/user")!
        let (data, _) = try await apiClient.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }
}

// ViewModel depends on abstraction
final class UserProfileViewModel {
    private let repository: UserRepositoryProtocol  // Protocol!
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadUser() async {
        user = try? await repository.getUser()
    }
}

// Easy to test with mock
final class MockUserRepository: UserRepositoryProtocol {
    var mockUser: User?
    
    func getUser() async throws -> User {
        guard let user = mockUser else {
            throw TestError.noMockData
        }
        return user
    }
}

// Test
@Test
func loadUser_withMockData_updatesUser() async {
    let mockRepo = MockUserRepository()
    mockRepo.mockUser = User.mock
    
    let viewModel = UserProfileViewModel(repository: mockRepo)
    await viewModel.loadUser()
    
    #expect(viewModel.user == User.mock)
}
```

### DIP in Clean Architecture

```
┌──────────────────┐
│   Presentation   │
│   (ViewModel)    │ ──depends on──→ Protocol
└──────────────────┘                    ↑
                                        │
┌──────────────────┐                    │
│     Domain       │                    │
│   (Use Case)     │ ──depends on──→ Protocol
└──────────────────┘                    ↑
                                        │
┌──────────────────┐                    │
│      Data        │                    │
│  (Repository)    │ ──implements──→ Protocol
└──────────────────┘
```

**Key Point**: All layers depend on **abstractions** (protocols), not concrete implementations.

---

## 🎯 SOLID in Practice: Complete Example

### Scenario: Restaurant Review Feature

```swift
// MARK: - Domain Layer (Abstractions)

protocol RestaurantRepositoryProtocol {
    func getRestaurants() async throws -> [Restaurant]
    func saveReview(_ review: Review) async throws
}

struct Restaurant: Identifiable {
    let id: UUID
    let name: String
    let rating: Double
}

struct Review {
    let restaurantId: UUID
    let rating: Int
    let comment: String
}

// MARK: - Use Case (Business Logic)

// ✅ SRP: Single responsibility (get restaurants)
// ✅ DIP: Depends on protocol, not implementation
final class GetRestaurantsUseCase {
    private let repository: RestaurantRepositoryProtocol
    
    init(repository: RestaurantRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Restaurant] {
        try await repository.getRestaurants()
    }
}

// MARK: - Data Layer (Concrete Implementations)

// ✅ OCP: Can add new implementations without modifying existing code
// ✅ LSP: Substitutable for protocol
final class NetworkRestaurantRepository: RestaurantRepositoryProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getRestaurants() async throws -> [Restaurant] {
        let dtos = try await apiClient.fetch(endpoint: .restaurants)
        return dtos.map { $0.toDomain() }
    }
    
    func saveReview(_ review: Review) async throws {
        try await apiClient.post(endpoint: .reviews, body: review)
    }
}

// ✅ LSP: Another valid implementation
final class MockRestaurantRepository: RestaurantRepositoryProtocol {
    var mockRestaurants: [Restaurant] = []
    
    func getRestaurants() async throws -> [Restaurant] {
        mockRestaurants
    }
    
    func saveReview(_ review: Review) async throws {
        // Mock implementation
    }
}

// MARK: - Presentation Layer

// ✅ SRP: Only coordinates UI
// ✅ DIP: Depends on protocol
@MainActor
@Observable
final class RestaurantListViewModel {
    private let getRestaurantsUseCase: GetRestaurantsUseCaseProtocol
    
    private(set) var restaurants: [Restaurant] = []
    private(set) var isLoading = false
    
    init(getRestaurantsUseCase: GetRestaurantsUseCaseProtocol) {
        self.getRestaurantsUseCase = getRestaurantsUseCase
    }
    
    func loadRestaurants() async {
        isLoading = true
        restaurants = (try? await getRestaurantsUseCase.execute()) ?? []
        isLoading = false
    }
}
```

---

## ✅ SOLID Checklist

Before finalizing any design, verify:

### Single Responsibility
- [ ] Each class/struct has one reason to change
- [ ] Each function does one thing
- [ ] Responsibilities clearly separated

### Open/Closed
- [ ] Can add new behavior without modifying existing code
- [ ] Uses protocols for extension points
- [ ] No need to edit existing implementations

### Liskov Substitution
- [ ] Subtypes can replace base types
- [ ] Protocol implementations fulfill contracts
- [ ] No unexpected behavior in substitutions

### Interface Segregation
- [ ] Protocols are focused and small
- [ ] No methods forced to implement but not use
- [ ] Can compose protocols when needed

### Dependency Inversion
- [ ] High-level modules depend on abstractions
- [ ] Concrete implementations depend on protocols
- [ ] Easy to swap implementations
- [ ] Fully testable with mocks

---

## 🚫 Common Mistakes

### Mistake 1: God Objects
```swift
// WRONG: Violates SRP
class AppManager {
    func fetchUser() { }
    func saveUser() { }
    func authenticate() { }
    func processPayment() { }
    func sendNotification() { }
    // ... more methods
}
```

### Mistake 2: Tight Coupling
```swift
// WRONG: Violates DIP
class ViewModel {
    let api = NetworkAPI()  // Concrete dependency!
}
```

### Mistake 3: Fat Protocols
```swift
// WRONG: Violates ISP
protocol Everything {
    func method1()
    func method2()
    // ... more methods
}
```

---

## 📚 Further Reading

- [SOLID Principles (Wikipedia)](https://en.wikipedia.org/wiki/SOLID)
- Clean Architecture by Robert C. Martin
- Agile Software Development by Robert C. Martin

---

**Remember**: SOLID isn't about perfection; it's about **maintainability**. Apply these principles pragmatically to create code that's easy to understand, test, and extend. 🏗️
