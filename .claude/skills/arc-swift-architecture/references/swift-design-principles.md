# Swift Design Principles — ARC Labs Studio

**Version**: 1.0.0
**Date**: 2026-03-19
**Status**: Stable

---

## ARC Labs Position

ARC Labs Studio builds software primarily in Swift — a multi-paradigm language that combines object-oriented, protocol-oriented, and functional programming. Swift's type system, value semantics, and structured concurrency model make it fundamentally different from the object-oriented languages where classical design theory was developed.

This document defines ARC Labs' technical position on software design in Swift. It does not replace SOLID principles as a historical reference, nor does it replace the Protocol-Oriented Programming guide as an implementation reference. It provides the philosophical framework that unifies both: a set of principles expressed in Swift's own vocabulary and mechanisms.

**Why define our own principles?** Because applying OOP design frameworks directly to Swift produces code that fights the language. Swift's compiler, runtime, and standard library are built around value semantics, protocol composition, and structured concurrency. Our principles align with — not against — these foundations.

---

## Philosophical Framework

Swift is a protocol-oriented language with value semantics at its core. Its design philosophy, articulated by Apple at WWDC 2015 and continuously refined through Swift Evolution, rests on three pillars:

1. **Value semantics by default** — structs eliminate shared mutable state; mutations are intentional and local
2. **Protocol composition as abstraction** — protocols replace abstract base classes; conformances replace inheritance hierarchies
3. **Compiler as primary reviewer** — the type system, Sendable checker, and strict concurrency model enforce correctness at compile time, not at runtime

The six principles below express these pillars as actionable design decisions.

---

## Principle 1: Value Semantics by Default

**Statement**: Use structs unless reference semantics are genuinely required.

### Reasoning

Apple's official Swift documentation states: *"Use structures by default."* This is not stylistic preference — it is architectural guidance. Value types eliminate an entire category of bugs: shared mutable state. When a struct is passed to a function, a copy is made. Each call site owns its own data. There are no aliasing bugs, no unexpected mutations from distant call sites, and no need for defensive copying.

Reference types (`class`) remain appropriate when:
- Identity matters (two objects must be the same instance, not just equal)
- The type requires inheritance
- The type is managed by Objective-C runtime
- Shared mutable state is intentional (actors are preferred for this)

### Swift 6 Expression

```swift
// ✅ Value type entity — independent copies, no aliasing
struct Restaurant: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let rating: Double
    let isActive: Bool
}

// ✅ Value type for domain operations
struct SearchCriteria: Sendable {
    let query: String
    let radius: Double
    let minimumRating: Double
}

// ❌ Class for a pure data container — no shared identity needed
final class Restaurant {
    var id: UUID
    var name: String
    // ... reference semantics with no benefit
}
```

### Connection to the Apple Ecosystem

SwiftUI's diffing engine, Swift's copy-on-write optimization for standard collections, and Swift 6's `Sendable` conformance all benefit directly from value types. A `Sendable` struct with all `let` properties requires no additional annotation — the compiler infers conformance automatically.

---

## Principle 2: Protocol-Driven Abstraction

**Statement**: Define capabilities as protocols, not abstract base classes.

### Reasoning

In Swift, protocols are the primary abstraction mechanism. They define what a type can do without dictating what it is. This is more expressive than inheritance: a type can conform to multiple protocols, a struct can satisfy a protocol, and extensions can provide default implementations without modifying the original type.

Protocols serve three distinct purposes in ARC Labs code:
1. **Testability** — inject mock implementations in tests
2. **Flexibility** — swap implementations (network vs. cache vs. mock) without touching consumers
3. **Contracts** — define what Domain layer requires from Data layer, enforced at compile time

Protocols should not be created prematurely. Add a protocol when a second implementation exists (or is clearly needed for testing), not before.

### Swift 6 Expression

```swift
// ✅ Protocol defines the contract Domain needs from Data
protocol RestaurantRepositoryProtocol: Sendable {
    func getRestaurants(matching criteria: SearchCriteria) async throws -> [Restaurant]
    func save(_ restaurant: Restaurant) async throws
}

// ✅ Use Case depends on the protocol, not the implementation
final class SearchRestaurantsUseCase: SearchRestaurantsUseCaseProtocol, Sendable {
    private let repository: RestaurantRepositoryProtocol

    init(repository: RestaurantRepositoryProtocol) {
        self.repository = repository
    }

    func execute(criteria: SearchCriteria) async throws -> [Restaurant] {
        let restaurants = try await repository.getRestaurants(matching: criteria)
        return restaurants.filter { $0.isActive && $0.rating >= criteria.minimumRating }
    }
}

// ❌ Abstract base class — fights Swift's value semantics
class AbstractRepository {
    func getRestaurants() async throws -> [Restaurant] {
        fatalError("Subclasses must override")  // Runtime failure, not compile-time
    }
}
```

### Connection to the Apple Ecosystem

The Swift standard library is built on this principle: `Equatable`, `Hashable`, `Comparable`, `Identifiable`, `Sendable` are all protocols. SwiftUI's `View`, `Shape`, and `ViewModifier` are protocols. Adopting this pattern aligns ARC Labs code with how Apple builds frameworks.

---

## Principle 3: Composition Over Inheritance

**Statement**: Build types by combining protocols and values, not by extending class hierarchies.

### Reasoning

Inheritance creates tight coupling between parent and child. It exposes internal implementation details, makes refactoring difficult, and forces a single taxonomy on types that may belong to multiple categories. In Swift, protocol composition and struct composition achieve the same reuse goals without these costs.

Protocol extensions provide default implementations that any conforming type inherits without creating a class hierarchy. Value type composition (embedding structs in structs) provides data reuse without reference semantics. This is the idiomatic Swift approach to the "favor composition over inheritance" principle.

### Swift 6 Expression

```swift
// ✅ Protocol composition — a type can be both Fetchable and Cacheable
protocol Fetchable: Sendable {
    associatedtype Item
    func fetch(id: UUID) async throws -> Item
}

protocol Cacheable: Sendable {
    associatedtype Item
    func cache(_ item: Item) async throws
    func cachedItem(for id: UUID) async -> Item?
}

// ✅ Protocol extension provides shared default behavior
extension Cacheable {
    func cachedItem(for id: UUID) async -> Item? {
        nil  // Default: no cache
    }
}

// ✅ A concrete type composes multiple capabilities
final class RestaurantRepositoryImpl: RestaurantRepositoryProtocol {
    private let remoteSource: RestaurantRemoteDataSourceProtocol
    private let localSource: RestaurantLocalDataSourceProtocol

    func getRestaurant(by id: UUID) async throws -> Restaurant {
        if let cached = try? await localSource.cachedRestaurant(for: id) {
            return cached
        }
        let dto = try await remoteSource.fetchRestaurant(id: id)
        let restaurant = dto.toDomain()
        try? await localSource.cache(restaurant)
        return restaurant
    }
}

// ❌ Deep inheritance hierarchy for reuse
class BaseRepository {
    func handleError(_ error: Error) { /* ... */ }
}

class NetworkRepository: BaseRepository {
    func fetch() async throws -> Data { /* ... */ }
}

class RestaurantRepository: NetworkRepository {
    // Now tightly coupled to two ancestors
}
```

### Connection to the Apple Ecosystem

SwiftUI uses composition as its foundational design: `ViewModifier`, `ButtonStyle`, `LabelStyle` are all composable protocols. The `some View` and `any View` type erasure system is built on protocol composition. ARC Labs code that follows this principle integrates naturally with SwiftUI's composition model.

---

## Principle 4: Well-Defined Ownership

**Statement**: Every piece of state has one explicit owner; mutations are visible and intentional.

### Reasoning

Unclear ownership is the root cause of most state-related bugs: unexpected mutations, stale data, race conditions, and inconsistent UI. Swift provides two layers of ownership tools:

**Language ownership** (`consuming`, `borrowing`, `~Copyable`): For performance-critical paths and non-copyable resources.

**State ownership in SwiftUI**: `@State` (view owns it), `@Binding` (view borrows it), `@Observable` (external model owns it), `@Environment` (environment injects it). Each modifier makes the ownership relationship explicit and verifiable.

> See `Layers/presentation.md` § Dependency Injection Strategy for when to use `@Environment` vs init injection.

At ARC Labs, the relevant ownership rule is about state in the Presentation layer: the ViewModel owns the state it exposes to Views. Views never mutate ViewModel state directly. Use Cases never hold UI state. The Domain layer has no awareness of how its output is displayed.

### Swift 6 Expression

```swift
// ✅ Clear ownership: ViewModel owns the state
@Observable
final class RestaurantListViewModel {
    private(set) var restaurants: [Restaurant] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let searchUseCase: SearchRestaurantsUseCaseProtocol

    init(searchUseCase: SearchRestaurantsUseCaseProtocol) {
        self.searchUseCase = searchUseCase
    }

    @MainActor
    func search(criteria: SearchCriteria) async {
        isLoading = true
        errorMessage = nil
        do {
            restaurants = try await searchUseCase.execute(criteria: criteria)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// ✅ View borrows state via @Binding when it needs to mutate parent state
struct FilterView: View {
    @Binding var criteria: SearchCriteria

    var body: some View {
        // ...
    }
}

// ❌ View mutates ViewModel internals directly — ownership violation
struct RestaurantListView: View {
    var viewModel: RestaurantListViewModel

    var body: some View {
        Button("Load") {
            viewModel.restaurants = []  // Direct mutation: ownership violation
        }
    }
}
```

### Connection to the Apple Ecosystem

Swift's ownership model (SE-0377, SE-0390) and `~Copyable` types (SE-0427) extend this principle to the language level. The `@Observable` macro (SE-0395) makes ownership of model state explicit and compiler-verified. ARC Labs' rule of `private(set)` on all ViewModel published properties enforces this principle at the API boundary.

---

## Principle 5: Structured Concurrency

**Statement**: Use Swift's structured concurrency model; never create unstructured concurrency unless unavoidable.

### Reasoning

Swift's structured concurrency (SE-0304, SE-0306) guarantees that all async work spawned within a scope completes before the scope exits. This eliminates entire categories of bugs: dangling tasks that outlive their context, forgotten cancellation, and race conditions from uncoordinated `DispatchQueue` calls.

Actors (SE-0306) provide isolation for non-UI mutable state. `Sendable` (SE-0302) and region-based isolation (SE-0414) make the Swift 6 compiler the enforcer of data race freedom. `@MainActor` isolates UI updates to the main thread, but it should be applied surgically — only on methods that update state bound to Views — not as a blanket class annotation.

### Swift 6 Expression

```swift
// ✅ Structured concurrency: TaskGroup within a bounded scope
final class RestaurantSyncUseCase: RestaurantSyncUseCaseProtocol, Sendable {
    private let repository: RestaurantRepositoryProtocol

    func execute(ids: [UUID]) async throws -> [Restaurant] {
        try await withThrowingTaskGroup(of: Restaurant.self) { group in
            for id in ids {
                group.addTask {
                    try await self.repository.getRestaurant(by: id)
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }
    }
}

// ✅ Actor for non-UI mutable state
actor RestaurantCache {
    private var cache: [UUID: Restaurant] = [:]

    func store(_ restaurant: Restaurant) {
        cache[restaurant.id] = restaurant
    }

    func retrieve(id: UUID) -> Restaurant? {
        cache[id]
    }
}

// ✅ @MainActor per-method, not blanket
@Observable
final class RestaurantListViewModel {
    private(set) var restaurants: [Restaurant] = []

    @MainActor
    func loadRestaurants() async {
        restaurants = (try? await searchUseCase.execute(criteria: .default)) ?? []
    }
}

// ❌ Unstructured concurrency: manual DispatchQueue with no lifecycle
final class OldStyleViewModel {
    func loadData() {
        DispatchQueue.global().async {
            // No cancellation, no structured lifetime, no Sendable check
            DispatchQueue.main.async {
                // Hope this arrives after init...
            }
        }
    }
}

// ❌ Blanket @MainActor: over-isolation hurts performance
@MainActor
@Observable
final class RestaurantListViewModel {
    // Every method now runs on main thread, even background work
}
```

### Connection to the Apple Ecosystem

Swift 6 strict concurrency is enabled by default in new projects. All ARC Labs packages target Swift 6 with `swiftLanguageVersion: .v6` in `Package.swift`. The compiler enforces `Sendable` conformance across actor boundaries. Using structured concurrency means the compiler verifies correct behavior — not tests or documentation.

---

## Principle 6: Compile-Time Correctness

**Statement**: Treat compiler warnings as errors; avoid escaping the type system.

### Reasoning

The Swift compiler is the most powerful correctness tool available. It verifies type safety, Sendable conformance, actor isolation, exhaustive switch statements, and optional handling. Every escape hatch — `@unchecked Sendable`, force unwrap (`!`), force cast (`as!`), `try!`, `#if` suppression of warnings — is a decision to defer a potential failure to runtime.

ARC Labs code has zero tolerance for these escape hatches. If the compiler reports a warning, the fix is to address the underlying issue, not to suppress the warning. This discipline catches data races, nil dereferences, and type mismatches during development rather than in production.

### Swift 6 Expression

```swift
// ✅ Explicit optional handling — no force unwrap
func loadRestaurant(id: UUID) async throws -> Restaurant {
    guard let restaurant = try await repository.getRestaurant(by: id) else {
        throw RestaurantError.notFound(id)
    }
    return restaurant
}

// ✅ Exhaustive enum handling — compiler verifies completeness
func message(for state: LoadingState) -> String {
    switch state {
    case .idle: return "Ready"
    case .loading: return "Loading..."
    case .loaded(let count): return "\(count) results"
    case .failed(let error): return error.localizedDescription
    }
}

// ✅ Proper Sendable conformance
struct RestaurantDTO: Codable, Sendable {
    let id: UUID
    let name: String
}

// ❌ Escape hatches — runtime failures instead of compile-time errors
let restaurant = restaurants.first!                      // Force unwrap
let repo = repository as! RestaurantRepositoryImpl       // Force cast
let data = try! JSONEncoder().encode(restaurant)         // Force try

// ❌ Suppressing the compiler's concurrency checks
final class MyService: @unchecked Sendable {
    // "Trust me, I know what I'm doing" — defeats Swift 6 concurrency safety
    var mutableState: [String] = []
}
```

### Connection to the Apple Ecosystem

Xcode's build settings `SWIFT_STRICT_CONCURRENCY = complete` and `SWIFT_TREAT_WARNINGS_AS_ERRORS = YES` enforce this principle at the build system level. ARC Labs packages configure both. The Swift compiler's strictness is a feature, not an obstacle.

---

## Relationship with SOLID

SOLID was formulated in an OOP context (Java, C++, C#) where classes are the primary unit of abstraction. Swift is not a class-first language. Some SOLID principles map directly; others require translation; one dissolves entirely.

| Principle | Status in Swift | Swift Mechanism |
|---|---|---|
| **S** — Single Responsibility | **Vigente, reinforced** | Clean Architecture layers + single-purpose structs and Use Cases |
| **O** — Open/Closed | **Transformed** | Protocol conformances and extensions replace inheritance; new implementations extend without modifying |
| **L** — Liskov Substitution | **Transformed** | Protocol contracts replace inheritance contracts; any conforming type substitutes any other |
| **I** — Interface Segregation | **Dissolved** | Swift protocols are focused by design; standard library (Equatable, Hashable, Sendable) demonstrates this natively |
| **D** — Dependency Inversion | **Vigente, different mechanism** | Protocols + init injection (primary) + `@Environment` (Presentation layer, `@Observable` models); same goal, no abstract base classes needed |

### Honest Analysis by Principle

**Single Responsibility (S)**: Fully applicable and strengthened by Clean Architecture. A Use Case has one reason to change: its business rule. A Repository has one reason to change: its data access strategy. ARC Labs enforces this through layer separation.

**Open/Closed (O)**: The mechanism transforms. In OOP, "open for extension" means "can subclass." In Swift, it means "new types can conform to the protocol" and "new behavior can be added via extensions without modifying the original." The intent is preserved; the mechanism is idiomatic Swift.

**Liskov Substitution (L)**: Relevant but expressed through protocol contracts, not class hierarchies. The classic Rectangle/Square violation occurs because of inheritance. With protocols, Rectangle and Square are independent conformers to `Shape` — no substitution problem exists. Where LSP remains relevant is in ensuring that all implementations of a protocol honor its documented semantics (e.g., a repository that throws `.notFound` when documented to return `nil` violates behavioral substitutability).

**Interface Segregation (I)**: This principle fought against monolithic OOP interfaces. Swift's protocol philosophy — small, focused, composable — makes ISP the default. `Equatable` is not `Equatable & Hashable & Comparable & Identifiable`. Swift's standard library is the canonical implementation of ISP.

**Dependency Inversion (D)**: Fully applicable. The mechanism is protocol injection rather than abstract class injection, but the goal — high-level modules should not depend on low-level modules; both should depend on abstractions — is exactly what ARC Labs' Clean Architecture enforces.

---

## Anti-Patterns

### Java Disguised as Swift

```swift
// ❌ Unnecessary inheritance hierarchy
class BaseViewModel {
    func setup() { }
    func teardown() { }
}

class UserViewModel: BaseViewModel {
    override func setup() {
        super.setup()
        // ...
    }
}

// ✅ Use @Observable, no base class needed
@Observable
final class UserViewModel {
    func onAppear() { }
    func onDisappear() { }
}
```

### @unchecked Sendable as Escape Hatch

```swift
// ❌ Suppresses Swift 6 data race detection
final class DataManager: @unchecked Sendable {
    var cache: [String: Data] = [:]  // Unprotected mutable state
}

// ✅ Use an actor to protect mutable state
actor DataManager {
    private var cache: [String: Data] = [:]

    func store(_ data: Data, for key: String) {
        cache[key] = data
    }
}
```

### God ViewModel

```swift
// ❌ ViewModel containing business logic
@Observable
final class RestaurantViewModel {
    func loadRestaurants() async {
        let all = try? await repository.getRestaurants()
        // Business rule in ViewModel — wrong layer
        restaurants = all?.filter { $0.rating >= 4.0 && $0.isActive } ?? []
    }
}

// ✅ Business logic in Use Case; ViewModel coordinates UI state
@Observable
final class RestaurantViewModel {
    @MainActor
    func loadRestaurants() async {
        restaurants = (try? await getRestaurantsUseCase.execute()) ?? []
    }
}
```

### Protocol for Everything

```swift
// ❌ Protocol for a type that will never have a second implementation
protocol UserFormatterProtocol {
    func formatName(_ user: User) -> String
}

struct UserFormatter: UserFormatterProtocol {
    func formatName(_ user: User) -> String { "\(user.firstName) \(user.lastName)" }
}

// ✅ Protocol-free until a second implementation is needed
struct UserFormatter {
    func formatName(_ user: User) -> String { "\(user.firstName) \(user.lastName)" }
}
```

### Manual DispatchQueue in New Code

```swift
// ❌ Unstructured concurrency — no lifecycle, no cancellation, no Sendable verification
func loadData() {
    DispatchQueue.global(qos: .background).async {
        let data = self.fetchData()
        DispatchQueue.main.async {
            self.state = .loaded(data)
        }
    }
}

// ✅ Structured concurrency — lifecycle-bound, cancellable, Sendable-verified
@MainActor
func loadData() async {
    state = try await dataUseCase.execute()
}
```

---

## References

### WWDC Sessions

- **WWDC 2015, Session 408** — Protocol-Oriented Programming in Swift (Dave Abrahams) — foundational POP philosophy
- **WWDC 2021, Session 10132** — Swift concurrency: Behind the scenes — structured concurrency internals
- **WWDC 2021, Session 10194** — Explore structured concurrency in Swift — TaskGroup, async/await
- **WWDC 2022, Session 110352** — Eliminate data races using Swift Concurrency — actor model
- **WWDC 2023, Session 10149** — Discover Observation in Swift — `@Observable` macro
- **WWDC 2025, Session 268** — Progressive concurrency adoption — `@MainActor` per-method pattern

### Swift Evolution Proposals

- **SE-0302** — Sendable and @Sendable closures
- **SE-0304** — Structured Concurrency
- **SE-0306** — Actors
- **SE-0377** — `borrowing` and `consuming` parameter ownership modifiers
- **SE-0390** — Noncopyable structs and enums
- **SE-0395** — Observation (the `@Observable` macro)
- **SE-0414** — Region-based Isolation

### Official Apple Documentation

- Swift Language Guide: Structures and Classes — "Use structures by default"
- Swift Language Guide: Protocols — protocol composition and extensions
- Swift Language Guide: Concurrency — structured concurrency model
- Choosing Between Structures and Classes — Apple Developer Documentation

### ARC Labs Internal Documents

- `Architecture/clean-architecture.md` — Three-layer architecture implementation
- `Architecture/mvvm-c.md` — MVVM+Coordinator pattern with ARCNavigation
- `Architecture/solid-principles.md` — SOLID principles with Swift examples
- `Architecture/protocol-oriented.md` — Protocol-Oriented Programming patterns
- `Layers/domain.md` — Domain layer: Entities, Use Cases, Repository Protocols

### Motivating Reference

Fernández Muñoz, J.C. — *"SOLID is not the right framework for Swift"* — The article that initiated this reflection and led to the nuanced position expressed here: SOLID is not dead in Swift, but its principles are expressed through different vocabulary and mechanisms.
