# 🔒 Singleton Pattern in Swift

**Singletons provide global access to a shared instance. Use them sparingly and always with protocol abstraction for testability.**

---

## 🎯 Apple's Official Guidance

Apple's documentation on [Managing a Shared Resource Using a Singleton](https://developer.apple.com/documentation/Swift/managing-a-shared-resource-using-a-singleton) states:

> "Provide a globally accessible, shared instance of a class... as a way to provide a unified access point to a resource or service that's shared across an app, like an audio channel to play sound effects or a network manager to make HTTP requests."

However, Apple also warns in [Updating Your Existing Codebase to Accommodate Unit Tests](https://developer.apple.com/documentation/Xcode/updating-your-existing-codebase-to-accommodate-unit-tests):

> "Singleton use can be spread throughout a codebase, which makes it hard to know the singleton's state when it's used by the component you're trying to test. Running tests in different orders may produce different outcomes."

**Key Insight**: Singletons are valid for truly global resources, but must be wrapped in protocols for testability.

---

## ✅ When Singletons ARE Appropriate

Use singletons when managing **truly unique, global resources**:

| Case | Example | Justification |
|------|---------|---------------|
| Unique system resources | `FileManager.default`, `NotificationCenter.default` | Only one filesystem, one notification system exists |
| App-wide configuration | Firebase configuration | App has only one Firebase configuration |
| Unique hardware | Audio engine, camera | Only one audio/camera device |
| Truly global state | App-wide analytics | Single collection point |

### Example: Firebase Configuration

```swift
// ✅ Valid singleton: Firebase configures once per app lifecycle
@MainActor
public final class FirebaseManager: Sendable {
    public static let shared = FirebaseManager()

    public private(set) var isConfigured = false

    private init() { }

    public func configure() throws {
        guard !isConfigured else { return }
        FirebaseApp.configure()
        isConfigured = true
    }
}
```

---

## ❌ When Singletons Are NOT Appropriate

Avoid singletons when:

1. **Multiple implementations could exist** (network, cache, mock)
2. **Frequent mocking is needed** for tests
3. **Mutable state affects test isolation**
4. **Other modules depend on it** (use DI instead)

### Anti-Pattern: Direct Singleton Access

```swift
// ❌ WRONG: Direct access makes testing difficult
class LoginHandler {
    var previousUsername: String? {
        UserDefaults.standard.string(forKey: "username")
    }
}
```

### Apple's Recommended Solution: Protocol Injection

```swift
// ✅ CORRECT: Protocol abstraction enables testing
protocol LoginStorage {
    func string(forKey: String) -> String?
}

extension UserDefaults: LoginStorage { }

class LoginHandler {
    private let storage: LoginStorage

    init(storage: LoginStorage = UserDefaults.standard) {
        self.storage = storage
    }

    var previousUsername: String? {
        storage.string(forKey: "username")
    }
}

// Test with mock
final class MockLoginStorage: LoginStorage {
    var storedValues: [String: String] = [:]

    func string(forKey key: String) -> String? {
        storedValues[key]
    }
}
```

---

## 🔧 Hybrid Pattern: Protocol + Singleton

When a singleton is justified, **always provide protocol abstraction**:

```swift
// MARK: - Protocol (for abstraction)

public protocol FirebaseConfiguring: Sendable {
    var isConfigured: Bool { get }
    func configure() throws
}

// MARK: - Implementation (singleton)

@MainActor
public final class FirebaseManager: FirebaseConfiguring {
    public static let shared = FirebaseManager()

    public private(set) var isConfigured = false

    private init() { }

    public func configure() throws {
        guard !isConfigured else { return }
        FirebaseApp.configure()
        isConfigured = true
    }
}

// MARK: - Usage with DI

final class AppBootstrapper {
    private let firebaseManager: FirebaseConfiguring

    // Production: uses singleton
    init(firebaseManager: FirebaseConfiguring = FirebaseManager.shared) {
        self.firebaseManager = firebaseManager
    }
}

// MARK: - Testing with Mock

final class MockFirebaseManager: FirebaseConfiguring {
    var isConfigured = false
    var configureError: Error?

    func configure() throws {
        if let error = configureError {
            throw error
        }
        isConfigured = true
    }
}
```

**Benefits**:
- Singleton provides global access when needed
- Protocol enables dependency injection
- Tests use mocks without touching real singleton

---

## 🏭 Factory Pattern for Providers

For services that depend on singleton configuration, use the **Factory + Convenience** pattern:

```swift
public actor FirebaseAuthProvider: AuthProviding {

    // MARK: Factory Method (explicit error handling)

    public static func create() throws -> FirebaseAuthProvider {
        guard FirebaseManager.shared.isConfigured else {
            throw FirebaseError.notConfigured
        }
        return FirebaseAuthProvider()
    }

    // MARK: Convenience Property (production use)

    public static var live: FirebaseAuthProvider {
        do {
            return try create()
        } catch {
            // Debug: crash with useful message
            // Release: controlled crash
            fatalError("""
                Firebase not configured.
                Call FirebaseManager.shared.configure() first.
                Error: \(error)
                """)
        }
    }

    // MARK: Private Initialization

    private init() { }
}
```

### Usage

```swift
// Production (99% of cases)
let authProvider = FirebaseAuthProvider.live

// When explicit error handling needed
do {
    let authProvider = try FirebaseAuthProvider.create()
} catch {
    // Handle configuration error
}
```

**Why This Pattern?**
1. `create()` allows explicit error handling when needed
2. `.live` maintains ergonomic API for common cases
3. `fatalError` with descriptive message is better than silent `try!`
4. Follows Apple's "fail fast with useful message" philosophy

---

## 📋 ARC Labs Singleton Rules

### ✅ Singleton PERMITTED When:

1. **Represents a physically unique resource** (hardware, system)
2. **Configuration is truly app-global** (one per app lifecycle)
3. **Always paired with protocol** for test injection

### ❌ Singleton NOT PERMITTED When:

1. **Service could have multiple implementations**
2. **Needs frequent mocking** in tests
3. **Has mutable state** affecting test isolation
4. **Other modules depend on it** (use DI)

### Decision Tree

```
Is this resource physically unique (hardware, system)?
├─ YES
│   └─ Is it app-global configuration?
│       ├─ YES → Singleton with Protocol ✅
│       └─ NO  → Dependency Injection ❌
│
└─ NO
    └─ Could multiple implementations exist?
        ├─ YES → Dependency Injection ❌
        └─ NO  → Consider if truly needed, prefer DI
```

---

## 🎯 Pattern Summary

| Component Type | Pattern | Example |
|----------------|---------|---------|
| App configuration | Singleton + Protocol | `FirebaseManager.shared` |
| Service provider | Factory + .live | `FirebaseAuthProvider.live` |
| Repository | DI only (no singleton) | `UserRepository` injected |
| Use Case | DI only (no singleton) | `GetUserUseCase` injected |
| ViewModel | DI only (no singleton) | `UserViewModel` injected |

---

## ✅ Singleton Checklist

Before using a singleton, verify:

- [ ] Resource is **physically unique** (hardware, system, app-config)
- [ ] No need for **multiple implementations**
- [ ] **Protocol defined** for abstraction
- [ ] **Dependency injection** used in consumers
- [ ] **Mock implementation** available for tests
- [ ] **No mutable state** that affects test isolation
- [ ] Follows **Factory + .live** pattern for providers

---

## 🚫 Common Mistakes

### Mistake 1: Singleton Without Protocol

```swift
// ❌ WRONG: No abstraction for testing
class AnalyticsManager {
    static let shared = AnalyticsManager()
    func track(_ event: String) { }
}

class ViewModel {
    func userTapped() {
        AnalyticsManager.shared.track("tap")  // Untestable!
    }
}
```

### Mistake 2: Spreading Singleton Access

```swift
// ❌ WRONG: Singleton accessed everywhere
class ViewA {
    func action() { UserDefaults.standard.set(...) }
}

class ViewB {
    func action() { UserDefaults.standard.set(...) }
}

// ✅ CORRECT: Inject storage protocol
class ViewA {
    private let storage: StorageProtocol
    init(storage: StorageProtocol) { self.storage = storage }
}
```

### Mistake 3: Using Singleton for Services

```swift
// ❌ WRONG: Service as singleton
class NetworkService {
    static let shared = NetworkService()
    func fetch() async { }
}

// ✅ CORRECT: Inject via protocol
protocol NetworkServiceProtocol {
    func fetch() async throws -> Data
}

class NetworkService: NetworkServiceProtocol { }
```

---

## 📚 References

- [Apple: Managing a Shared Resource Using a Singleton](https://developer.apple.com/documentation/Swift/managing-a-shared-resource-using-a-singleton)
- [Apple: Updating Your Existing Codebase to Accommodate Unit Tests](https://developer.apple.com/documentation/Xcode/updating-your-existing-codebase-to-accommodate-unit-tests)
- [Protocol-Oriented Design](protocol-oriented.md)
- [SOLID Principles - Dependency Inversion](solid-principles.md#5️⃣-dependency-inversion-principle-dip)

---

**Remember**: Singletons are a tool, not an enemy. Use them for truly global resources, always with protocol abstraction, and prefer dependency injection for everything else. 🔒
