# 📝 Documentation Standards

## Overview

ARC Labs Studio maintains comprehensive documentation across all projects to ensure knowledge transfer, maintainability, and professional standards. Documentation is written in **English** and follows Apple's DocC format for packages and clear markdown standards for architectural decisions.

---

## Documentation Hierarchy

### 1. Package-Level Documentation (DocC)

Every Swift package must include:

**Package Documentation Catalog** (`Documentation.docc/`):
````
ARCStorage.docc/
├── ARCStorage.md              # Package overview
├── Articles/
│   ├── GettingStarted.md     # Quick start guide
│   ├── Architecture.md        # Design decisions
│   └── Migration.md           # Version migration guides
├── Tutorials/
│   └── YourFirstStorage.tutorial
└── Resources/
    └── Images/
````

**Package Root Documentation**:
````swift
/// # ARCStorage
///
/// A flexible, protocol-based storage abstraction layer for iOS applications.
///
/// ## Overview
///
/// ARCStorage provides a unified interface for multiple persistence backends
/// including SwiftData, CloudKit, UserDefaults, and Keychain. The package
/// enables switching storage providers without changing application code.
///
/// ## Topics
///
/// ### Essentials
/// - ``StorageProvider``
/// - ``Repository``
/// - ``StorageError``
///
/// ### Storage Providers
/// - ``SwiftDataProvider``
/// - ``CloudKitProvider``
/// - ``UserDefaultsProvider``
/// - ``KeychainProvider``
///
/// ### Advanced Usage
/// - <doc:CustomProviders>
/// - <doc:Migration>
````

### 2. Code Documentation

#### Public APIs (Mandatory)

Every public type, method, and property requires documentation:
````swift
/// Manages restaurant data persistence across multiple storage backends.
///
/// `RestaurantRepository` provides a clean interface for CRUD operations
/// on restaurant entities, abstracting the underlying storage mechanism.
///
/// ## Usage
///
/// ```swift
/// let repository = RestaurantRepository(
///     storage: SwiftDataProvider()
/// )
/// try await repository.save(restaurant)
/// ```
///
/// - Important: Repository operations are async and may throw errors.
/// - Note: All operations are thread-safe through actor isolation.
public actor RestaurantRepository {
    
    /// The underlying storage provider.
    private let storage: StorageProvider
    
    /// Creates a repository with the specified storage provider.
    ///
    /// - Parameter storage: The storage backend to use for persistence.
    public init(storage: StorageProvider) {
        self.storage = storage
    }
    
    /// Saves a restaurant to persistent storage.
    ///
    /// This method persists the restaurant data and handles CloudKit
    /// synchronization if the provider supports it.
    ///
    /// - Parameter restaurant: The restaurant to save.
    /// - Throws: ``StorageError`` if the save operation fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let restaurant = Restaurant(name: "Le Bernardin")
    /// try await repository.save(restaurant)
    /// ```
    public func save(_ restaurant: Restaurant) async throws {
        try await storage.save(restaurant)
    }
}
````

#### Documentation Keywords

Use Apple's documentation markup:

| Keyword | Purpose | Example |
|---------|---------|---------|
| `///` | Single-line documentation | `/// Saves a restaurant` |
| `/** */` | Multi-line documentation | `/** Detailed explanation */` |
| `- Parameter` | Parameter description | `- Parameter id: Restaurant ID` |
| `- Returns` | Return value description | `- Returns: Saved restaurant` |
| `- Throws` | Error conditions | `- Throws: StorageError` |
| `- Important` | Critical information | `- Important: Thread-safe` |
| `- Note` | Additional context | `- Note: Supports CloudKit` |
| `- Warning` | Potential issues | `- Warning: May fail offline` |
| `- Todo` | Future improvements | `- Todo: Add batch operations` |
| ` `` ` | Code reference | `` `StorageProvider` `` |
| `## Example` | Code example | See above |

### 3. Architectural Documentation

#### README Files

Every project and package requires a README:
````markdown
# ARCStorage

A flexible, protocol-based storage abstraction for iOS apps.

## Features

- ✅ Multiple storage backends (SwiftData, CloudKit, UserDefaults, Keychain)
- ✅ Protocol-based architecture for testability
- ✅ Swift 6 concurrency support
- ✅ Type-safe repository pattern
- ✅ Comprehensive error handling

## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/arclabs/ARCStorage", from: "1.0.0")
]
```

## Quick Start
```swift
import ARCStorage

// 1. Choose a storage provider
let storage = SwiftDataProvider(
    modelContainer: container
)

// 2. Create a repository
let repository = RestaurantRepository(
    storage: storage
)

// 3. Perform operations
let restaurant = Restaurant(name: "Le Bernardin")
try await repository.save(restaurant)
```

## Documentation

Full documentation is available at [arclabs.github.io/ARCStorage](https://arclabs.github.io/ARCStorage)

## Requirements

- iOS 17.0+
- Swift 6.0+
- Xcode 16.0+

## License

Proprietary - ARC Labs Studio
````

#### Architecture Decision Records (ADRs)

Document significant architectural decisions:
````markdown
# ADR-001: Storage Provider Abstraction

## Status
✅ Accepted

## Context
FavRes needs persistent storage that can:
- Work offline
- Sync with CloudKit
- Support multiple data types
- Enable easy testing

## Decision
Implement protocol-based storage abstraction with:
- `StorageProvider` protocol
- Multiple backend implementations
- Repository pattern for domain isolation

## Consequences

### Positive
- Testable through mock providers
- Flexible backend switching
- Clean separation of concerns
- No SwiftData coupling in domain layer

### Negative
- Additional abstraction layer
- Learning curve for new patterns
- More boilerplate code

## Alternatives Considered

### Direct SwiftData Usage
❌ Rejected - Couples domain to persistence framework

### Core Data
❌ Rejected - Legacy API, verbose implementation

### Realm
❌ Rejected - Third-party dependency, licensing concerns
````

### 4. Inline Comments

**When to Use Comments**:
- Complex algorithms requiring explanation
- Non-obvious business logic
- Workarounds for platform bugs
- Performance optimizations
- Temporary solutions

**When NOT to Use Comments**:
- Obvious code that's self-explanatory
- Restating what the code does
- Outdated or misleading information
````swift
// ❌ Bad - Obvious
// Create a restaurant
let restaurant = Restaurant(name: "Le Bernardin")

// ✅ Good - Explains why
// Use haversine formula for accurate distance calculation
// accounting for Earth's curvature (critical for < 1km distances)
let distance = calculateHaversineDistance(from: userLocation, to: restaurant.location)

// ✅ Good - Workaround
// FIXME: iOS 17.2 bug - MapKit annotation selection crashes on dismiss
// Temporary workaround: manually deselect before navigation
mapView.deselectAnnotation(annotation, animated: false)
````

---

## README Standards

### Package README Structure
````markdown
# PackageName

[One-line description]

## Overview

[2-3 paragraphs explaining what, why, and key benefits]

## Features

- ✅ Feature 1
- ✅ Feature 2
- ✅ Feature 3

## Requirements

- iOS X.0+
- Swift X.0+
- Xcode X.0+

## Installation

### Swift Package Manager

[Installation instructions]

## Quick Start

[Minimal example showing core functionality]

## Usage

### Basic Usage

[Common use cases with code examples]

### Advanced Usage

[More complex scenarios]

## Architecture

[High-level architecture overview with diagrams if helpful]

## Documentation

[Link to full DocC documentation]

## Testing

[How to run tests, coverage requirements]

## Contributing

[Internal contribution guidelines]

## License

Proprietary - ARC Labs Studio

## Changelog

[Link to CHANGELOG.md]
````

### App README Structure
````markdown
# App Name

[App description and purpose]

## Project Overview

### Goals
- Goal 1
- Goal 2

### Target Platforms
- iOS X.0+
- [Other platforms]

## Architecture

[Brief architecture overview, link to detailed docs]

## Project Structure
````
AppName/
├── Presentation/
├── Domain/
├── Data/
└── Core/
````

## Getting Started

### Prerequisites
[Required tools, accounts, configurations]

### Installation
[Setup steps]

### Configuration
[Environment setup, API keys, etc.]

## Development

### Building
[Build instructions]

### Testing
[Test execution]

### Code Style
[Link to code style guide]

## Dependencies

### Swift Packages
- ARCStorage (1.0.0)
- ARCNetworking (1.0.0)

### Third-Party
[Any external dependencies]

## Deployment

[Release process overview]

## Documentation

- [Architecture Documentation](docs/architecture.md)
- [API Documentation](docs/api.md)

## Team

ARC Labs Studio

## License

Proprietary
````

---

## DocC Best Practices

### 1. Article Structure
````markdown
# Getting Started with ARCStorage

Learn how to integrate ARCStorage into your iOS app.

## Overview

ARCStorage provides a flexible persistence layer that adapts to your
app's needs. This guide walks through basic integration and common patterns.

## Choose Your Storage Backend

ARCStorage supports multiple backends...

### SwiftData (Recommended)

For most apps, SwiftData provides...
```swift
let container = try ModelContainer(
    for: Restaurant.self,
    configurations: ModelConfiguration()
)
```

## Create a Repository

Repositories provide type-safe...

## Perform Operations

### Saving Data
```swift
try await repository.save(restaurant)
```

### Fetching Data
```swift
let restaurants = try await repository.fetchAll()
```

## Next Steps

- <doc:AdvancedQuerying>
- <doc:CloudKitIntegration>
````

### 2. Tutorial Structure
````swift
@Tutorial(time: 15) {
    @Intro(title: "Building Your First Repository") {
        Learn to create a repository for restaurant data.
        
        @Image(source: "repository-hero")
    }
    
    @Section(title: "Setting Up Storage") {
        @ContentAndMedia {
            Configure your storage provider.
            
            @Image(source: "storage-setup")
        }
        
        @Steps {
            @Step {
                Import ARCStorage.
```swift
                import ARCStorage
```
            }
            
            @Step {
                Create a SwiftData model container.
```swift
                let container = try ModelContainer(
                    for: Restaurant.self
                )
```
            }
        }
    }
}
````

---

## Documentation Checklist

Before publishing a package or merging significant features:

### Package Documentation
- [ ] Package overview with clear description
- [ ] Installation instructions
- [ ] Quick start guide with working example
- [ ] All public APIs documented
- [ ] Architecture explanation
- [ ] Usage examples for common scenarios
- [ ] Migration guides (if applicable)
- [ ] DocC documentation builds without warnings

### Code Documentation
- [ ] All public types have doc comments
- [ ] All public methods documented with parameters and return values
- [ ] Complex logic has inline comments explaining *why*
- [ ] Examples included for non-trivial APIs
- [ ] Important considerations highlighted
- [ ] Known limitations documented

### Architectural Documentation
- [ ] README.md is complete and accurate
- [ ] Architecture decisions recorded (ADRs)
- [ ] Project structure explained
- [ ] Dependencies listed with versions
- [ ] Setup instructions verified

### Maintenance
- [ ] CHANGELOG.md updated
- [ ] Version numbers follow semantic versioning
- [ ] Breaking changes clearly documented
- [ ] Migration path provided for breaking changes

---

## Tools and Generation

### DocC Generation

Build documentation locally:
````bash
# Generate DocC archive
xcodebuild docbuild \
  -scheme ARCStorage \
  -derivedDataPath ./build

# Preview locally
open ./build/Build/Products/Debug/ARCStorage.doccarchive
````

### Hosting Documentation
````bash
# Export for web hosting
xcrun docc process-archive transform-for-static-hosting \
  ./build/Build/Products/Debug/ARCStorage.doccarchive \
  --output-path ./docs \
  --hosting-base-path ARCStorage
````

### CI/CD Integration
````yaml
# GitHub Actions workflow
name: Documentation

on:
  push:
    branches: [main]

jobs:
  docs:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build Documentation
        run: |
          xcodebuild docbuild \
            -scheme ARCStorage \
            -derivedDataPath ./build
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
````

---

## Style Guidelines

### Writing Style

1. **Be Clear and Concise**
   - Use simple, direct language
   - Avoid jargon unless necessary
   - Define technical terms on first use

2. **Use Active Voice**
   - ✅ "The repository saves the data"
   - ❌ "The data is saved by the repository"

3. **Be Specific**
   - ✅ "Throws `StorageError.notFound` if restaurant doesn't exist"
   - ❌ "May throw an error"

4. **Provide Examples**
   - Include working code samples
   - Show common use cases
   - Demonstrate best practices

### Code Examples

1. **Complete and Runnable**
````swift
// ✅ Good - Complete context
import ARCStorage

let repository = RestaurantRepository(
    storage: SwiftDataProvider()
)
try await repository.save(restaurant)
````
````swift
// ❌ Bad - Incomplete
repository.save(restaurant)
````

2. **Show Real-World Usage**
````swift
// ✅ Good - Realistic scenario
func loadFavoriteRestaurants() async {
    do {
        let restaurants = try await repository.fetchAll()
        self.favorites = restaurants.filter { $0.isFavorite }
    } catch {
        self.error = "Failed to load favorites: \(error.localizedDescription)"
    }
}
````

3. **Include Error Handling**
````swift
// ✅ Good - Shows error handling
do {
    try await repository.save(restaurant)
} catch StorageError.duplicate {
    // Handle duplicate
} catch {
    // Handle other errors
}
````

---

## Maintenance

### Review Schedule

- **Monthly**: Review package READMEs for accuracy
- **Per Release**: Update CHANGELOG and migration guides
- **Quarterly**: Audit ADRs and update as needed
- **As Needed**: Update inline documentation with code changes

### Documentation Debt

Track documentation gaps:
````markdown
## Documentation TODO

- [ ] Add tutorial for custom storage providers
- [ ] Document CloudKit sync conflict resolution
- [ ] Create migration guide for v2.0
- [ ] Add performance optimization examples
````

---

## Resources

- [Apple DocC Documentation](https://www.swift.org/documentation/docc/)
- [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Semantic Versioning](https://semver.org/)

---

## Summary

Comprehensive documentation is not optional at ARC Labs—it's a core requirement for professional, maintainable software. Every package must have DocC documentation, every public API must be documented, and every significant architectural decision must be recorded. By maintaining high documentation standards, we ensure that our code is accessible, understandable, and maintainable for years to come.