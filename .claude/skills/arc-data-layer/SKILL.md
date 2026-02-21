---
name: arc-data-layer
description: |
  Implements the Data layer using Repository pattern, DTOs, API clients, and
  SwiftData persistence. Use when "creating a repository", "implementing API
  client", "setting up SwiftData", "designing caching", "mapping DTOs to
  domain entities", or "handling data layer errors". Covers caching strategies,
  error mapping, and data transformation.
user-invocable: true
metadata:
  author: ARC Labs Studio
  version: "3.0.0"
---

# ARC Labs Studio - Data Layer Patterns

## Instructions

### Data Layer Structure

```
Data/
├── Repositories/
│   ├── UserRepositoryImpl.swift
│   └── RestaurantRepositoryImpl.swift
├── DataSources/
│   ├── Remote/
│   │   ├── UserRemoteDataSource.swift
│   │   └── APIClient.swift
│   └── Local/
│       ├── UserLocalDataSource.swift
│       └── CacheManager.swift
└── Models/
    ├── UserDTO.swift
    └── RestaurantDTO.swift
```

### Repository Implementation Pattern

```swift
final class UserRepositoryImpl {

    // MARK: Private Properties

    private let remoteDataSource: UserRemoteDataSourceProtocol
    private let localDataSource: UserLocalDataSourceProtocol
    private let cacheManager: CacheManagerProtocol

    // MARK: Initialization

    init(remoteDataSource: UserRemoteDataSourceProtocol,
         localDataSource: UserLocalDataSourceProtocol,
         cacheManager: CacheManagerProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.cacheManager = cacheManager
    }
}

// MARK: - UserRepositoryProtocol

extension UserRepositoryImpl: UserRepositoryProtocol {
    func getUser(by id: UUID) async throws -> User {
        // 1. Check cache first
        let cacheKey = "user:\(id.uuidString)"
        if let cached = await cacheManager.get(key: cacheKey) as? UserDTO {
            return cached.toDomain()
        }

        // 2. Try local database
        if let local = try? await localDataSource.getUser(by: id) {
            await cacheManager.set(local, for: cacheKey)
            return local.toDomain()
        }

        // 3. Fetch from remote
        let dto = try await remoteDataSource.fetchUser(by: id)

        // 4. Cache results
        try? await localDataSource.saveUser(dto)
        await cacheManager.set(dto, for: cacheKey)

        return dto.toDomain()
    }
}
```

### Remote Data Source

```swift
protocol UserRemoteDataSourceProtocol: Sendable {
    func fetchUser(by id: UUID) async throws -> UserDTO
    func updateUser(_ user: UserDTO) async throws
}

final class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchUser(by id: UUID) async throws -> UserDTO {
        try await apiClient.request(endpoint: .user(id),
                                    method: .get,
                                    responseType: UserDTO.self)
    }
}
```

### Local Data Source (SwiftData)

```swift
protocol UserLocalDataSourceProtocol: Sendable {
    func getUser(by id: UUID) async throws -> UserDTO
    func saveUser(_ user: UserDTO) async throws
}

final class UserLocalDataSource: UserLocalDataSourceProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getUser(by id: UUID) async throws -> UserDTO {
        let predicate = #Predicate<UserModel> { user in
            user.id == id
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard let model = try modelContext.fetch(descriptor).first else {
            throw DataError.notFound
        }
        return model.toDTO()
    }

    func saveUser(_ user: UserDTO) async throws {
        let model = UserModel.from(user)
        modelContext.insert(model)
        try modelContext.save()
    }
}
```

### DTO Structure

```swift
struct UserDTO: Codable {
    let id: String
    let email: String
    let name: String
    let avatarUrl: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
    }
}

// MARK: - Domain Mapping

extension UserDTO {
    func toDomain() -> User {
        User(id: UUID(uuidString: id) ?? UUID(),
             email: email,
             name: name,
             avatarURL: avatarUrl.flatMap { URL(string: $0) },
             createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date())
    }

    static func fromDomain(_ user: User) -> UserDTO {
        UserDTO(id: user.id.uuidString,
                email: user.email,
                name: user.name,
                avatarUrl: user.avatarURL?.absoluteString,
                createdAt: ISO8601DateFormatter().string(from: user.createdAt))
    }
}
```

### API Client

```swift
protocol APIClientProtocol: Sendable {
    func request<T: Decodable>(endpoint: Endpoint,
                               method: HTTPMethod,
                               body: Encodable?,
                               responseType: T.Type) async throws -> T
}

final class APIClient: APIClientProtocol {
    private let baseURL: URL
    private let session: URLSession

    func request<T: Decodable>(endpoint: Endpoint,
                               method: HTTPMethod = .get,
                               body: Encodable? = nil,
                               responseType: T.Type) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError((response as? HTTPURLResponse)?.statusCode ?? 0)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
```

### Error Mapping

```swift
func getUser(by id: UUID) async throws -> User {
    do {
        let dto = try await remoteDataSource.fetchUser(by: id)
        return dto.toDomain()
    } catch let error as NetworkError {
        throw mapNetworkError(error)
    } catch {
        throw RepositoryError.unknown(error)
    }
}

private func mapNetworkError(_ error: NetworkError) -> RepositoryError {
    switch error {
    case .notFound: return .notFound
    case .unauthorized: return .unauthorized
    case .networkUnavailable: return .networkError
    default: return .unknown(error)
    }
}
```

### Caching Strategies

**Cache-First (fastest)**
```swift
if let cached = await cache.get(key) { return cached }
if let local = try? await local.get() { return local }
let remote = try await remote.fetch()
```

**Network-First (freshest)**
```swift
if let remote = try? await remote.fetch() {
    await cache.set(remote)
    return remote
}
return try await local.get()  // Fallback to cache
```

**Offline-First (reliable)**
```swift
try await local.save(data)  // Always save locally first
Task.detached { try? await remote.save(data) }  // Sync in background
```

## References

For complete patterns:
- **@references/data.md** - Complete Data layer guide with examples

## Common Mistakes

- Putting business logic in repositories (filtering, sorting, validation)
- Returning DTOs to Domain layer
- Exposing network errors directly
- Storing Domain entities in database (use DTOs)
- Tight coupling to specific data source

## Examples

### Creating a repository for restaurants
User says: "Create a repository for restaurants"

1. Define `RestaurantRepositoryProtocol` in Domain layer
2. Implement `RestaurantRepositoryImpl` in Data layer with remote + local data sources
3. Create `RestaurantDTO` with `toDomain()` mapper
4. Add cache-first strategy for list endpoints
5. Result: Complete repository with protocol, implementation, DTO, and error mapping

### Adding SwiftData persistence
User says: "Add local persistence for user favorites"

1. Create `FavoriteModel` as SwiftData `@Model`
2. Create `FavoriteLocalDataSource` with `FavoriteLocalDataSourceProtocol`
3. Add DTO mapping between model and domain entity
4. Integrate into existing repository with cache-first strategy
5. Result: Offline-capable favorites with SwiftData backing

## Related Skills

| If you need...              | Use                       |
|-----------------------------|---------------------------|
| Architecture patterns       | `/arc-swift-architecture` |
| Testing data layer          | `/arc-tdd-patterns`       |
| Presentation layer          | `/arc-presentation-layer` |
| Code quality standards      | `/arc-quality-standards`  |
