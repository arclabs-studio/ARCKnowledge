# 🧠 Domain Layer

**The Domain Layer is the heart of the application, containing business logic, business rules, and the (Swift Data) models that define what the application does.**

---

## 🎯 Layer Purpose

The Domain Layer is responsible for:
1. **Business Entities** - (Swift data) structures that model the problem domain
2. **Business Logic** - Use Cases that implement business operations
3. **Repository Contracts** - Protocols defining data access (implementations in Data Layer)
4. **Business Rules** - Validation, constraints, and domain-specific logic

**Critical Rule**: Domain Layer is **independent**. It knows nothing about:
- How data is stored (Data Layer)
- How data is displayed (Presentation Layer)
- What frameworks are used
- What UI components exist

---

## 🏗️ Layer Structure

```
Domain/
├── Entities/
│   ├── User.swift
│   ├── Restaurant.swift
│   ├── Review.swift
│   └── Location.swift
│
├── UseCases/
│   ├── GetRestaurantsUseCase.swift
│   ├── SaveFavoriteRestaurantUseCase.swift
│   ├── GetUserProfileUseCase.swift
│   └── UpdateUserProfileUseCase.swift
│
└── Repositories/
    ├── UserRepositoryProtocol.swift
    ├── RestaurantRepositoryProtocol.swift
    └── LocationRepositoryProtocol.swift
```

---

## 🎲 Entities

### What are Entities?

Entities are **pure business objects** that:
- Model real-world concepts
- Contain business logic and validation
- Are framework-independent
- Are value types (structs) or simple reference types

### Entity Structure

```swift
import Foundation

/// Represents a restaurant in the system.
///
/// A restaurant contains all information needed to display
/// and manage restaurant data throughout the application.
struct Restaurant: Identifiable, Equatable {
    
    // MARK: Properties
    
    let id: UUID
    let name: String
    let cuisine: String
    let rating: Double
    let priceLevel: Int
    let address: String
    let location: Location
    let imageURL: URL?
    let phoneNumber: String?
    let website: URL?
    let openingHours: [String]
    let isFavorite: Bool
    
    // MARK: Computed Properties
    
    /// Returns a formatted rating string (e.g., "4.5")
    var displayRating: String {
        String(format: "%.1f", rating)
    }
    
    /// Returns price level as dollar signs (e.g., "$$")
    var displayPrice: String {
        String(repeating: "$", count: priceLevel)
    }
    
    /// Validates if restaurant data is complete
    var isValid: Bool {
        !name.isEmpty &&
        rating >= 0 && rating <= 5 &&
        priceLevel > 0 && priceLevel <= 4 &&
        !address.isEmpty
    }
    
    /// Returns true if restaurant is highly rated (4.0+)
    var isHighlyRated: Bool {
        rating >= 4.0
    }
    
    /// Returns true if restaurant is expensive ($$$+)
    var isExpensive: Bool {
        priceLevel >= 3
    }
}

// MARK: - Initialization Helpers

extension Restaurant {
    /// Creates a new restaurant with default values
    init(
        id: UUID = UUID(),
        name: String,
        cuisine: String,
        rating: Double,
        priceLevel: Int,
        address: String,
        location: Location
    ) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.rating = rating
        self.priceLevel = priceLevel
        self.address = address
        self.location = location
        self.imageURL = nil
        self.phoneNumber = nil
        self.website = nil
        self.openingHours = []
        self.isFavorite = false
    }
}

// MARK: - Mock Data

#if DEBUG
extension Restaurant {
    static var mock: Restaurant {
        Restaurant(
            id: UUID(),
            name: "The Italian Kitchen",
            cuisine: "Italian",
            rating: 4.5,
            priceLevel: 2,
            address: "123 Main St, San Francisco, CA",
            location: Location(latitude: 37.7749, longitude: -122.4194),
            imageURL: URL(string: "https://example.com/image.jpg"),
            phoneNumber: "+1-555-0123",
            website: URL(string: "https://example.com"),
            openingHours: ["Mon-Fri: 11:00-22:00", "Sat-Sun: 10:00-23:00"],
            isFavorite: false
        )
    }
    
    static func mock(
        name: String = "Test Restaurant",
        rating: Double = 4.0,
        isFavorite: Bool = false
    ) -> Restaurant {
        Restaurant(
            id: UUID(),
            name: name,
            cuisine: "Italian",
            rating: rating,
            priceLevel: 2,
            address: "123 Main St",
            location: .mock,
            imageURL: nil,
            phoneNumber: nil,
            website: nil,
            openingHours: [],
            isFavorite: isFavorite
        )
    }
}
#endif
```

### Entity Best Practices

#### 1. Value Types (Structs)

```swift
// ✅ Good: Use struct for entities
struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
    let email: String
}

// ❌ Bad: Class for simple entity
class User {
    let id: UUID
    var name: String
    var email: String
}
```

#### 2. Immutability

```swift
// ✅ Good: Immutable properties
struct Restaurant {
    let id: UUID
    let name: String
    let rating: Double
}

// ❌ Bad: Mutable properties
struct Restaurant {
    var id: UUID  // ID should never change!
    var name: String
    var rating: Double
}
```

#### 3. Validation in Computed Properties

```swift
struct User {
    let email: String
    
    // ✅ Good: Validation as computed property
    var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
    
    // ❌ Bad: Validation method
    func validateEmail() -> Bool {
        email.contains("@")
    }
}
```

#### 4. Business Rules in Entity

```swift
struct Order {
    let items: [OrderItem]
    let discount: Decimal
    
    // ✅ Good: Business logic in entity
    var subtotal: Decimal {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var total: Decimal {
        subtotal - discount
    }
    
    var requiresShipping: Bool {
        items.contains { $0.isPhysicalProduct }
    }
}
```

---

## ⚙️ Use Cases

### What are Use Cases?

Use Cases are **business operations** that:
- Implement specific business workflows
- Coordinate between entities and repositories
- Contain business logic and validation
- Are single-responsibility (one operation each)

### Use Case Structure

```swift
import Foundation

/// Protocol defining the contract for getting restaurants.
protocol GetRestaurantsUseCaseProtocol: Sendable {
    /// Executes the use case to fetch restaurants.
    ///
    /// - Parameter filter: Optional filter criteria
    /// - Returns: Array of restaurants matching the filter
    /// - Throws: `DomainError` if operation fails
    func execute(filter: RestaurantFilter?) async throws -> [Restaurant]
}

/// Use case for retrieving restaurants with business logic.
///
/// This use case:
/// 1. Validates input parameters
/// 2. Fetches restaurants from repository
/// 3. Applies business rules (sorting, filtering)
/// 4. Returns processed results
final class GetRestaurantsUseCase: GetRestaurantsUseCaseProtocol {
    
    // MARK: - Properties
    
    private let repository: RestaurantRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: RestaurantRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Execute
    
    func execute(filter: RestaurantFilter? = nil) async throws -> [Restaurant] {
        // Fetch from repository
        var restaurants = try await repository.getRestaurants()
        
        // Apply business rules
        
        // Rule 1: Only show valid restaurants
        restaurants = restaurants.filter { $0.isValid }
        
        // Rule 2: Apply filter if provided
        if let filter = filter {
            restaurants = applyFilter(filter, to: restaurants)
        }
        
        // Rule 3: Sort by rating (highest first)
        restaurants.sort { $0.rating > $1.rating }
        
        return restaurants
    }
    
    // MARK: - Private Methods
    
    private func applyFilter(
        _ filter: RestaurantFilter,
        to restaurants: [Restaurant]
    ) -> [Restaurant] {
        var filtered = restaurants
        
        if let cuisine = filter.cuisine {
            filtered = filtered.filter { $0.cuisine == cuisine }
        }
        
        if let minRating = filter.minRating {
            filtered = filtered.filter { $0.rating >= minRating }
        }
        
        if let maxPriceLevel = filter.maxPriceLevel {
            filtered = filtered.filter { $0.priceLevel <= maxPriceLevel }
        }
        
        return filtered
    }
}

// MARK: - Supporting Types

struct RestaurantFilter {
    let cuisine: String?
    let minRating: Double?
    let maxPriceLevel: Int?
}

// MARK: - Domain Errors

enum DomainError: LocalizedError {
    case invalidInput
    case notFound
    case unauthorized
    case businessRuleViolation(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input provided"
        case .notFound:
            return "Resource not found"
        case .unauthorized:
            return "Unauthorized access"
        case .businessRuleViolation(let rule):
            return "Business rule violation: \(rule)"
        }
    }
}
```

### Use Case Patterns

#### 1. Simple Query Use Case

```swift
protocol GetUserProfileUseCaseProtocol: Sendable {
    func execute(userId: UUID) async throws -> User
}

final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: UUID) async throws -> User {
        // Validation
        guard userId != UUID() else {
            throw DomainError.invalidInput
        }
        
        // Fetch
        let user = try await repository.getUser(by: userId)
        
        // Business rule
        guard user.isActive else {
            throw DomainError.unauthorized
        }
        
        return user
    }
}
```

#### 2. Command Use Case (Mutation)

```swift
protocol SaveFavoriteRestaurantUseCaseProtocol: Sendable {
    func execute(restaurantId: UUID) async throws
}

final class SaveFavoriteRestaurantUseCase: SaveFavoriteRestaurantUseCaseProtocol {
    private let repository: RestaurantRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(
        repository: RestaurantRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.repository = repository
        self.userRepository = userRepository
    }
    
    func execute(restaurantId: UUID) async throws {
        // Validation
        let user = try await userRepository.getCurrentUser()
        
        guard user.isActive else {
            throw DomainError.unauthorized
        }
        
        // Business rule: Max 100 favorites
        let favorites = try await repository.getFavoriteRestaurants(userId: user.id)
        guard favorites.count < 100 else {
            throw DomainError.businessRuleViolation("Maximum favorites limit reached")
        }
        
        // Execute
        try await repository.saveFavorite(restaurantId: restaurantId, userId: user.id)
    }
}
```

#### 3. Complex Business Logic Use Case

```swift
protocol CalculateRestaurantScoreUseCaseProtocol: Sendable {
    func execute(restaurantId: UUID) async throws -> Double
}

final class CalculateRestaurantScoreUseCase: CalculateRestaurantScoreUseCaseProtocol {
    private let repository: RestaurantRepositoryProtocol
    private let reviewRepository: ReviewRepositoryProtocol
    
    init(
        repository: RestaurantRepositoryProtocol,
        reviewRepository: ReviewRepositoryProtocol
    ) {
        self.repository = repository
        self.reviewRepository = reviewRepository
    }
    
    func execute(restaurantId: UUID) async throws -> Double {
        // Fetch data
        let restaurant = try await repository.getRestaurant(by: restaurantId)
        let reviews = try await reviewRepository.getReviews(for: restaurantId)
        
        // Business logic: Calculate weighted score
        
        // Base score from rating (50% weight)
        let ratingScore = restaurant.rating * 0.5
        
        // Review count bonus (25% weight)
        let reviewBonus = min(Double(reviews.count) / 100, 1.0) * 0.25
        
        // Recent activity bonus (25% weight)
        let recentReviews = reviews.filter { $0.isRecent }
        let activityBonus = min(Double(recentReviews.count) / 20, 1.0) * 0.25
        
        return ratingScore + reviewBonus + activityBonus
    }
}
```

### Use Case Best Practices

#### 1. Single Responsibility

```swift
// ✅ Good: One operation per use case
final class GetRestaurantsUseCase {
    func execute() async throws -> [Restaurant] { }
}

final class SaveFavoriteUseCase {
    func execute(restaurantId: UUID) async throws { }
}

// ❌ Bad: Multiple operations
final class RestaurantUseCase {
    func getRestaurants() async throws -> [Restaurant] { }
    func saveFavorite() async throws { }
    func deleteFavorite() async throws { }
}
```

#### 2. Validation First

```swift
func execute(userId: UUID) async throws -> User {
    // ✅ Good: Validate before processing
    guard userId != UUID() else {
        throw DomainError.invalidInput
    }
    
    let user = try await repository.getUser(by: userId)
    return user
}
```

#### 3. Business Rules Explicit

```swift
func execute(order: Order) async throws {
    // ✅ Good: Clear business rules
    
    // Rule: Minimum order value
    guard order.total >= 10.0 else {
        throw DomainError.businessRuleViolation("Minimum order is $10")
    }
    
    // Rule: Valid delivery address
    guard order.deliveryAddress.isValid else {
        throw DomainError.invalidInput
    }
    
    try await repository.saveOrder(order)
}
```

---

## 📜 Repository Protocols

### What are Repository Protocols?

Repository Protocols define **data access contracts**:
- Live in Domain Layer (protocols only)
- Implemented in Data Layer (concrete classes)
- Abstract away data source details
- Enable dependency inversion

### Repository Protocol Structure

```swift
import Foundation

/// Protocol defining data access for restaurants.
///
/// Implementations should handle:
/// - Network requests
/// - Local caching
/// - Error handling
/// - Data transformation
protocol RestaurantRepositoryProtocol: Sendable {
    
    // MARK: - Query Methods
    
    /// Fetches all restaurants.
    ///
    /// - Returns: Array of all available restaurants
    /// - Throws: `RepositoryError` if fetch fails
    func getRestaurants() async throws -> [Restaurant]
    
    /// Fetches a specific restaurant by ID.
    ///
    /// - Parameter id: The unique identifier
    /// - Returns: The restaurant if found
    /// - Throws: `RepositoryError.notFound` if restaurant doesn't exist
    func getRestaurant(by id: UUID) async throws -> Restaurant
    
    /// Fetches restaurants matching search criteria.
    ///
    /// - Parameter query: Search query string
    /// - Returns: Array of matching restaurants
    /// - Throws: `RepositoryError` if search fails
    func searchRestaurants(query: String) async throws -> [Restaurant]
    
    /// Fetches user's favorite restaurants.
    ///
    /// - Parameter userId: The user's identifier
    /// - Returns: Array of favorite restaurants
    /// - Throws: `RepositoryError` if fetch fails
    func getFavoriteRestaurants(userId: UUID) async throws -> [Restaurant]
    
    // MARK: - Command Methods
    
    /// Saves a restaurant to favorites.
    ///
    /// - Parameters:
    ///   - restaurantId: Restaurant identifier
    ///   - userId: User identifier
    /// - Throws: `RepositoryError` if save fails
    func saveFavorite(restaurantId: UUID, userId: UUID) async throws
    
    /// Removes a restaurant from favorites.
    ///
    /// - Parameters:
    ///   - restaurantId: Restaurant identifier
    ///   - userId: User identifier
    /// - Throws: `RepositoryError` if deletion fails
    func removeFavorite(restaurantId: UUID, userId: UUID) async throws
}

// MARK: - Repository Errors

enum RepositoryError: LocalizedError {
    case notFound
    case networkError
    case unauthorized
    case cacheError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Resource not found"
        case .networkError:
            return "Network request failed"
        case .unauthorized:
            return "Unauthorized access"
        case .cacheError:
            return "Cache operation failed"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
```

### Repository Protocol Patterns

#### 1. Simple CRUD Protocol

```swift
protocol UserRepositoryProtocol: Sendable {
    func getUser(by id: UUID) async throws -> User
    func saveUser(_ user: User) async throws
    func deleteUser(by id: UUID) async throws
    func listUsers() async throws -> [User]
}
```

#### 2. Specialized Query Protocol

```swift
protocol UserSearchRepositoryProtocol: Sendable {
    func searchUsers(query: String) async throws -> [User]
    func searchByEmail(_ email: String) async throws -> User?
    func searchByName(_ name: String) async throws -> [User]
}
```

#### 3. Composition

```swift
// Small, focused protocols
protocol UserReader: Sendable {
    func getUser(by id: UUID) async throws -> User
    func listUsers() async throws -> [User]
}

protocol UserWriter: Sendable {
    func saveUser(_ user: User) async throws
    func deleteUser(by id: UUID) async throws
}

// Compose when needed
typealias UserRepository = UserReader & UserWriter
```

---

## ✅ Domain Layer Checklist

Before considering Domain Layer complete:

### Entities
- [ ] All core business objects defined
- [ ] Entities are value types (structs)
- [ ] Properties are immutable (let)
- [ ] Validation in computed properties
- [ ] Business logic in entity methods
- [ ] Mock data provided for testing
- [ ] Conform to Identifiable, Equatable, Sendable (structs are Sendable by default)

### Use Cases
- [ ] One operation per use case
- [ ] Protocol defined for each use case
- [ ] Input validation performed
- [ ] Business rules enforced
- [ ] Repository protocols used (not implementations)
- [ ] Proper error handling
- [ ] DocC documentation

### Repository Protocols
- [ ] Protocols in Domain Layer only
- [ ] Clear method signatures
- [ ] Return domain entities (not DTOs)
- [ ] Sendable conformance
- [ ] DocC documentation
- [ ] Error types defined

---

## 🚫 Common Mistakes

### Mistake 1: Framework Dependencies

```swift
// ❌ WRONG: Domain depends on SwiftUI
import SwiftUI

struct Restaurant {
    var image: Image  // SwiftUI type!
}

// ✅ RIGHT: Domain is framework-independent
struct Restaurant {
    var imageURL: URL?
}
```

### Mistake 2: Business Logic in Presentation

```swift
// ❌ WRONG: Business logic in ViewModel
@Observable
final class RestaurantViewModel {
    func calculateScore() -> Double {
        // Complex business logic here!
    }
}

// ✅ RIGHT: Business logic in Use Case
final class CalculateScoreUseCase {
    func execute(restaurantId: UUID) async throws -> Double {
        // Business logic here
    }
}
```

### Mistake 3: Repository Implementation in Domain

```swift
// ❌ WRONG: Implementation in Domain
final class UserRepository: UserRepositoryProtocol {
    func getUser() async throws -> User {
        // Network call implementation
    }
}

// ✅ RIGHT: Only protocol in Domain
protocol UserRepositoryProtocol: Sendable {
    func getUser() async throws -> User
}
```

---

## 📚 Further Reading

- Clean Architecture by Robert C. Martin
- Domain-Driven Design by Eric Evans
- SOLID Principles documentation

---

**Remember**: The Domain Layer is **pure business logic**. No frameworks, no UI, no databases. Just the core of what your application does. 🎯
