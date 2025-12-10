# 💾 Data Layer

**The Data Layer implements data access, manages persistence, and handles communication with external services. It's the gateway between the application and the outside world.**

---

## 🎯 Layer Purpose

The Data Layer is responsible for:
1. **Repository Implementations** - Concrete implementations of Domain protocols
2. **Data Sources** - API clients, database managers, cache handlers
3. **DTOs** - Data Transfer Objects for API/Database mapping
4. **Data Transformation** - Converting between DTOs and Domain entities

**Critical Rule**: Data Layer implements Domain protocols but never contains business logic.

---

## 🏗️ Layer Structure

```
Data/
├── Repositories/
│   ├── UserRepositoryImpl.swift
│   ├── RestaurantRepositoryImpl.swift
│   └── ReviewRepositoryImpl.swift
│
├── DataSources/
│   ├── Remote/
│   │   ├── UserRemoteDataSource.swift
│   │   ├── RestaurantRemoteDataSource.swift
│   │   └── APIClient.swift
│   │
│   └── Local/
│       ├── UserLocalDataSource.swift
│       ├── RestaurantLocalDataSource.swift
│       └── CacheManager.swift
│
└── Models/
    ├── UserDTO.swift
    ├── RestaurantDTO.swift
    └── ReviewDTO.swift
```

---

## 🗄️ Repository Implementations

### What are Repository Implementations?

Repository Implementations:
- Implement Domain repository protocols
- Coordinate between data sources (remote, local, cache)
- Handle error mapping
- Transform DTOs to Domain entities

### Repository Implementation Structure

```swift
import ARCLogger
import Foundation

/// Concrete implementation of RestaurantRepositoryProtocol.
///
/// This implementation:
/// - Checks local cache first
/// - Falls back to remote API
/// - Caches results for future use
/// - Maps DTOs to domain entities
final class RestaurantRepositoryImpl {
    
    // MARK: Private Properties
    
    private let remoteDataSource: RestaurantRemoteDataSourceProtocol
    private let localDataSource: RestaurantLocalDataSourceProtocol
    private let cacheManager: CacheManagerProtocol
    
    // MARK: Initialization
    
    init(
        remoteDataSource: RestaurantRemoteDataSourceProtocol,
        localDataSource: RestaurantLocalDataSourceProtocol,
        cacheManager: CacheManagerProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.cacheManager = cacheManager
    }
}

// MARK: - RestaurantRepositoryProtocol

extension RestaurantRepositoryImpl: RestaurantRepositoryProtocol {
    func getRestaurants() async throws -> [Restaurant] {
        ARCLogger.shared.debug("Fetching restaurants")
        
        // Try cache first (fastest)
        if let cached = await cacheManager.get(key: "restaurants") as? [RestaurantDTO],
           !cached.isEmpty {
            ARCLogger.shared.debug("Returning \(cached.count) cached restaurants")
            return cached.map { $0.toDomain() }
        }
        
        // Try local database (fast)
        if let local = try? await localDataSource.getRestaurants(),
           !local.isEmpty {
            ARCLogger.shared.debug("Returning \(local.count) local restaurants")
            let restaurants = local.map { $0.toDomain() }
            
            // Update cache
            await cacheManager.set(local, for: "restaurants")
            
            return restaurants
        }
        
        // Fetch from remote (slow)
        ARCLogger.shared.info("Fetching restaurants from API")
        let dtos = try await remoteDataSource.fetchRestaurants()
        
        // Cache for next time
        try? await localDataSource.saveRestaurants(dtos)
        await cacheManager.set(dtos, for: "restaurants")
        
        ARCLogger.shared.info("Fetched and cached \(dtos.count) restaurants")
        
        return dtos.map { $0.toDomain() }
    }
    
    func getRestaurant(by id: UUID) async throws -> Restaurant {
        ARCLogger.shared.debug("Fetching restaurant", metadata: ["id": id.uuidString])
        
        // Check cache
        let cacheKey = "restaurant:\(id.uuidString)"
        if let cached = await cacheManager.get(key: cacheKey) as? RestaurantDTO {
            return cached.toDomain()
        }
        
        // Fetch from remote
        let dto = try await remoteDataSource.fetchRestaurant(by: id)
        
        // Cache
        await cacheManager.set(dto, for: cacheKey)
        
        return dto.toDomain()
    }
    
    func searchRestaurants(query: String) async throws -> [Restaurant] {
        ARCLogger.shared.debug("Searching restaurants", metadata: ["query": query])
        
        let dtos = try await remoteDataSource.searchRestaurants(query: query)
        return dtos.map { $0.toDomain() }
    }
    
    func getFavoriteRestaurants(userId: UUID) async throws -> [Restaurant] {
        let dtos = try await localDataSource.getFavorites(userId: userId)
        return dtos.map { $0.toDomain() }
    }
    
    func saveFavorite(restaurantId: UUID, userId: UUID) async throws {
        try await localDataSource.saveFavorite(restaurantId: restaurantId, userId: userId)
        
        // Invalidate cache
        await cacheManager.remove(key: "restaurants")
    }
    
    func removeFavorite(restaurantId: UUID, userId: UUID) async throws {
        try await localDataSource.removeFavorite(restaurantId: restaurantId, userId: userId)
        
        // Invalidate cache
        await cacheManager.remove(key: "restaurants")
    }
}
```

### Repository Patterns

#### 1. Cache-First Strategy

```swift
func getData() async throws -> [Item] {
    // 1. Check memory cache
    if let cached = await memoryCache.get() {
        return cached
    }
    
    // 2. Check disk cache
    if let diskCached = try? await diskCache.get() {
        await memoryCache.set(diskCached)
        return diskCached
    }
    
    // 3. Fetch from network
    let data = try await remoteSource.fetch()
    
    // 4. Update caches
    try? await diskCache.set(data)
    await memoryCache.set(data)
    
    return data
}
```

#### 2. Offline-First Strategy

```swift
func saveData(_ data: Item) async throws {
    // 1. Save locally first (always succeeds)
    try await localSource.save(data)
    
    // 2. Sync to remote in background
    Task.detached {
        try? await remoteSource.save(data)
    }
}
```

#### 3. Error Mapping

```swift
func getUser(by id: UUID) async throws -> User {
    do {
        let dto = try await remoteDataSource.fetchUser(by: id)
        return dto.toDomain()
    } catch let error as NetworkError {
        // Map network errors to repository errors
        throw mapNetworkError(error)
    } catch {
        throw RepositoryError.unknown(error)
    }
}

private func mapNetworkError(_ error: NetworkError) -> RepositoryError {
    switch error {
    case .notFound:
        return .notFound
    case .unauthorized:
        return .unauthorized
    case .networkUnavailable:
        return .networkError
    default:
        return .unknown(error)
    }
}
```

---

## 🌐 Data Sources

### Remote Data Sources

Handle network communication:

```swift
import Foundation

protocol RestaurantRemoteDataSourceProtocol: Sendable {
    func fetchRestaurants() async throws -> [RestaurantDTO]
    func fetchRestaurant(by id: UUID) async throws -> RestaurantDTO
    func searchRestaurants(query: String) async throws -> [RestaurantDTO]
}

final class RestaurantRemoteDataSource {

    // MARK: Private Properties
    
    private let apiClient: APIClientProtocol
    
    // MARK: Initialization

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
}

// MARK: - RestaurantRemoteDataSourceProtocol

extension RestaurantRemoteDataSource: RestaurantRemoteDataSourceProtocol {
    func fetchRestaurants() async throws -> [RestaurantDTO] {
        try await apiClient.request(
            endpoint: .restaurants,
            method: .get,
            responseType: [RestaurantDTO].self
        )
    }
    
    func fetchRestaurant(by id: UUID) async throws -> RestaurantDTO {
        try await apiClient.request(
            endpoint: .restaurant(id),
            method: .get,
            responseType: RestaurantDTO.self
        )
    }
    
    func searchRestaurants(query: String) async throws -> [RestaurantDTO] {
        try await apiClient.request(
            endpoint: .searchRestaurants(query: query),
            method: .get,
            responseType: [RestaurantDTO].self
        )
    }
}
```

### Local Data Sources

Handle local persistence:

```swift
import Foundation
import SwiftData

protocol RestaurantLocalDataSourceProtocol: Sendable {
    func getRestaurants() async throws -> [RestaurantDTO]
    func saveRestaurants(_ restaurants: [RestaurantDTO]) async throws
    func getFavorites(userId: UUID) async throws -> [RestaurantDTO]
    func saveFavorite(restaurantId: UUID, userId: UUID) async throws
    func removeFavorite(restaurantId: UUID, userId: UUID) async throws
}

final class RestaurantLocalDataSource {
    
    // MARK: Private Properties

    private let modelContext: ModelContext
    
    // MARK: Initialization

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}

// MARK: - RestaurantLocalDataSourceProtocol

extension RestaurantLocalDataSource: RestaurantLocalDataSourceProtocol {
    func getRestaurants() async throws -> [RestaurantDTO] {
        let descriptor = FetchDescriptor<RestaurantModel>()
        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toDTO() }
    }
    
    func saveRestaurants(_ restaurants: [RestaurantDTO]) async throws {
        // Clear existing
        try modelContext.delete(model: RestaurantModel.self)
        
        // Insert new
        for dto in restaurants {
            let model = RestaurantModel.from(dto)
            modelContext.insert(model)
        }
        
        try modelContext.save()
    }
    
    func getFavorites(userId: UUID) async throws -> [RestaurantDTO] {
        let predicate = #Predicate<RestaurantModel> { restaurant in
            restaurant.isFavorite == true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toDTO() }
    }
    
    func saveFavorite(restaurantId: UUID, userId: UUID) async throws {
        let predicate = #Predicate<RestaurantModel> { restaurant in
            restaurant.id == restaurantId
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        if let restaurant = try modelContext.fetch(descriptor).first {
            restaurant.isFavorite = true
            try modelContext.save()
        }
    }
    
    func removeFavorite(restaurantId: UUID, userId: UUID) async throws {
        let predicate = #Predicate<RestaurantModel> { restaurant in
            restaurant.id == restaurantId
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        if let restaurant = try modelContext.fetch(descriptor).first {
            restaurant.isFavorite = false
            try modelContext.save()
        }
    }
}
```

### API Client

```swift
import Foundation

protocol APIClientProtocol: Sendable {
    func request<T: Decodable>(
        endpoint: Endpoint,
        method: HTTPMethod,
        body: Encodable?,
        responseType: T.Type
    ) async throws -> T
}

final class APIClient {

    // MARK: Private Properties
    
    private let baseURL: URL
    private let session: URLSession
    
    // MARK: Initialization

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
}

// MARK: - APIClientProtocol

extension APIClient: APIClientProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        responseType: T.Type
    ) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Endpoint {
    case restaurants
    case restaurant(UUID)
    case searchRestaurants(query: String)
    
    var path: String {
        switch self {
        case .restaurants:
            return "/restaurants"
        case .restaurant(let id):
            return "/restaurants/\(id)"
        case .searchRestaurants(let query):
            return "/restaurants/search?q=\(query)"
        }
    }
}

enum NetworkError: Error {
    case invalidResponse
    case httpError(Int)
    case decodingError
    case networkUnavailable
}
```

---

## 📦 DTOs (Data Transfer Objects)

### What are DTOs?

DTOs are data structures that:
- Match API/Database schema
- Handle serialization/deserialization
- Map to/from Domain entities
- Live only in Data Layer

### DTO Structure

```swift
import Foundation

/// Data Transfer Object for Restaurant API responses.
///
/// This structure matches the API schema and handles JSON encoding/decoding.
struct RestaurantDTO: Codable {
    let id: String
    let name: String
    let cuisine: String
    let rating: Double
    let priceLevel: Int
    let address: String
    let latitude: Double
    let longitude: Double
    let imageUrl: String?
    let phoneNumber: String?
    let website: String?
    let openingHours: [String]?
    let isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cuisine
        case rating
        case priceLevel = "price_level"
        case address
        case latitude = "lat"
        case longitude = "lng"
        case imageUrl = "image_url"
        case phoneNumber = "phone_number"
        case website
        case openingHours = "opening_hours"
        case isFavorite = "is_favorite"
    }
}

// MARK: - Domain Mapping

extension RestaurantDTO {
    /// Converts DTO to Domain entity.
    func toDomain() -> Restaurant {
        Restaurant(
            id: UUID(uuidString: id) ?? UUID(),
            name: name,
            cuisine: cuisine,
            rating: rating,
            priceLevel: priceLevel,
            address: address,
            location: Location(latitude: latitude, longitude: longitude),
            imageURL: imageUrl.flatMap { URL(string: $0) },
            phoneNumber: phoneNumber,
            website: website.flatMap { URL(string: $0) },
            openingHours: openingHours ?? [],
            isFavorite: isFavorite ?? false
        )
    }
    
    /// Converts Domain entity to DTO.
    static func fromDomain(_ restaurant: Restaurant) -> RestaurantDTO {
        RestaurantDTO(
            id: restaurant.id.uuidString,
            name: restaurant.name,
            cuisine: restaurant.cuisine,
            rating: restaurant.rating,
            priceLevel: restaurant.priceLevel,
            address: restaurant.address,
            latitude: restaurant.location.latitude,
            longitude: restaurant.location.longitude,
            imageUrl: restaurant.imageURL?.absoluteString,
            phoneNumber: restaurant.phoneNumber,
            website: restaurant.website?.absoluteString,
            openingHours: restaurant.openingHours,
            isFavorite: restaurant.isFavorite
        )
    }
}

// MARK: - Mock Data

#if DEBUG
extension RestaurantDTO {
    static var mock: RestaurantDTO {
        RestaurantDTO(
            id: UUID().uuidString,
            name: "The Italian Kitchen",
            cuisine: "Italian",
            rating: 4.5,
            priceLevel: 2,
            address: "123 Main St",
            latitude: 37.7749,
            longitude: -122.4194,
            imageUrl: "https://example.com/image.jpg",
            phoneNumber: "+1-555-0123",
            website: "https://example.com",
            openingHours: ["Mon-Fri: 11:00-22:00"],
            isFavorite: false
        )
    }
}
#endif
```

### DTO Best Practices

#### 1. Match API Schema Exactly

```swift
// ✅ Good: Matches API field names
struct UserDTO: Codable {
    let userId: String
    let emailAddress: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case emailAddress = "email_address"
        case createdAt = "created_at"
    }
}
```

#### 2. Handle Optional Fields

```swift
struct RestaurantDTO: Codable {
    let id: String
    let name: String
    let imageUrl: String?  // Optional in API
    let phoneNumber: String?  // Optional in API
}
```

#### 3. Type Safety in Mapping

```swift
func toDomain() -> User {
    User(
        id: UUID(uuidString: id) ?? UUID(),  // Safe UUID conversion
        email: email,
        createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date()  // Safe date conversion
    )
}
```

---

## ✅ Data Layer Checklist

Before considering Data Layer complete:

### Repository Implementations
- [ ] Implements Domain protocols
- [ ] Coordinates data sources (remote, local, cache)
- [ ] Maps DTOs to Domain entities
- [ ] Handles errors properly
- [ ] Logs important operations
- [ ] No business logic

### Data Sources
- [ ] Remote data source for API calls
- [ ] Local data source for persistence
- [ ] Cache manager for performance
- [ ] Error handling implemented
- [ ] Sendable conformance (structs are Sendable by default, not necessary to write it)

### DTOs
- [ ] Matches API/Database schema
- [ ] Codable conformance
- [ ] CodingKeys for snake_case mapping
- [ ] toDomain() method implemented
- [ ] fromDomain() static method (if needed)
- [ ] Mock data for testing

---

## 🚫 Common Mistakes

### Mistake 1: Business Logic in Repository

```swift
// ❌ WRONG: Business logic in repository
func getRestaurants() async throws -> [Restaurant] {
    let dtos = try await remote.fetch()
    
    // Business logic!
    return dtos
        .filter { $0.rating > 4.0 }
        .sorted { $0.rating > $1.rating }
        .map { $0.toDomain() }
}

// ✅ RIGHT: Only data access
func getRestaurants() async throws -> [Restaurant] {
    let dtos = try await remote.fetch()
    return dtos.map { $0.toDomain() }
}
```

### Mistake 2: Domain Entities in Data Layer

```swift
// ❌ WRONG: Storing Domain entities directly
func save(_ restaurant: Restaurant) async throws {
    try await database.save(restaurant)  // Domain entity!
}

// ✅ RIGHT: Convert to DTO first
func save(_ restaurant: Restaurant) async throws {
    let dto = RestaurantDTO.fromDomain(restaurant)
    try await database.save(dto)
}
```

### Mistake 3: No Error Mapping

```swift
// ❌ WRONG: Exposing network errors
func getUser() async throws -> User {
    try await apiClient.fetch()  // Throws NetworkError!
}

// ✅ RIGHT: Map to repository errors
func getUser() async throws -> User {
    do {
        return try await apiClient.fetch()
    } catch {
        throw RepositoryError.networkError
    }
}
```

---

## 📚 Further Reading

- Clean Architecture by Robert C. Martin
- Repository Pattern documentation
- Swift Concurrency guidelines

---

**Remember**: Data Layer is about **data access**, not business logic. Fetch, cache, map, return. Keep it simple. 💾
