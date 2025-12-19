# 📦 Swift Packages

**Swift Packages at ARC Labs are public, reusable infrastructure components designed for professional quality and long-term maintainability.**

> **🔧 Related Documentation**
> - For SPM technical details (commands, troubleshooting, advanced features), see [`spm.md`](../Tools/spm.md)
> - This document focuses on ARC Labs standards: philosophy, templates, and quality requirements

---

## 🎯 Package Philosophy

### Core Principles

1. **Public by Design** - All packages are open source (for now)
2. **Zero Business Logic** - Packages provide infrastructure, not business rules
3. **Fully Documented** - DocC documentation for all public APIs
4. **Strictly Versioned** - Semantic versioning with clear changelogs
5. **100% Test Coverage** - Target 100%, minimum 80%
6. **Zero Dependencies** - Avoid third-party dependencies when possible

### Package Goals

- **Reusable** - Used across multiple ARC Labs apps
- **Reliable** - Production-ready, battle-tested
- **Maintainable** - Clear code, comprehensive docs
- **Professional** - Enterprise-level quality

---

## 📁 Standard Package Structure

All ARC Labs packages **MUST** follow a consistent folder structure. The organization depends on package size:

| Size | Files | Organization |
|------|-------|--------------|
| Small | < 10 | Flat structure (no subfolders) |
| Medium | 10-30 | By component type (`Protocols/`, `Implementations/`, `Models/`) |
| Large | > 30 | By type + by functionality |

### Quick Reference

```
ARCPackageName/
├── Package.swift              # Manifest (required)
├── README.md                  # Documentation (required)
├── LICENSE                    # MIT license
├── CHANGELOG.md               # Version history
├── Sources/
│   └── ARCPackageName/
│       ├── Protocols/         # Abstractions
│       ├── Implementations/   # Concrete types
│       ├── Models/            # Data types
│       └── Resources/         # Assets (if needed)
├── Tests/
│   └── ARCPackageNameTests/
│       ├── Unit/
│       ├── Integration/
│       └── Helpers/Mocks/
├── Examples/                  # Demo app (optional, see below)
│   └── ARCPackageNameDemo/
└── Documentation.docc/
```

> **📁 Detailed Structure Guide**
> For complete structure guidelines by package size, folder naming conventions, and industry references, see [`package-structure.md`](../Quality/package-structure.md)

---

## 🎬 Example Demo App

Every package **SHOULD** include a demo app that showcases its features. This helps developers understand usage patterns and serves as a living documentation.

### Purpose
- **Developer-only**: Demo apps are for internal testing and showcase
- **Not for production**: Never imported by consuming apps or packages
- **Living documentation**: Shows real usage patterns and edge cases
- **Quick validation**: Test changes visually before committing

### Demo App Structure

```
Examples/
├── README.md                     # How to run the demo
└── ARCPackageNameDemo/
    ├── ARCPackageNameDemoApp.swift
    ├── Views/
    │   ├── DemoHomeView.swift    # Main navigation
    │   ├── Feature1DemoView.swift
    │   └── Feature2DemoView.swift
    └── Helpers/
        └── SampleData.swift      # Mock data for demos
```

### Demo App Implementation

```swift
// Examples/ARCPackageNameDemo/ARCPackageNameDemoApp.swift
import SwiftUI
import ARCPackageName

@main
struct ARCPackageNameDemoApp: App {
    var body: some Scene {
        WindowGroup {
            DemoHomeView()
        }
    }
}
```

```swift
// Examples/ARCPackageNameDemo/Views/DemoHomeView.swift
import SwiftUI
import ARCPackageName

struct DemoHomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Components") {
                    NavigationLink("Feature 1 Demo") {
                        Feature1DemoView()
                    }
                    NavigationLink("Feature 2 Demo") {
                        Feature2DemoView()
                    }
                }

                Section("States") {
                    NavigationLink("Loading States") {
                        LoadingStatesDemoView()
                    }
                    NavigationLink("Error Handling") {
                        ErrorHandlingDemoView()
                    }
                }
            }
            .navigationTitle("ARCPackageName Demo")
        }
    }
}

#Preview {
    DemoHomeView()
}
```

### Package.swift Configuration (Demo Isolation)

**Critical**: The demo app must be configured as a separate executable target that is NOT included in the library product. This ensures consumers never accidentally import demo code.

```swift
// Key configuration points:
targets: [
    // Main library - exported via products
    .target(
        name: "ARCPackageName",
        path: "Sources/ARCPackageName"
    ),

    // Demo app - NOT in products array, never exported
    .executableTarget(
        name: "ARCPackageNameDemo",
        dependencies: ["ARCPackageName"],
        path: "Examples/ARCPackageNameDemo"
    )
]
```

> **📝 Complete Template**
> See [Package.swift Configuration](#-packageswift-configuration) for the full template with all required settings.

### Running the Demo

```bash
# From package root directory
# Option 1: Run in Xcode
open Package.swift
# Select "ARCPackageNameDemo" scheme → Run on iOS Simulator

# Option 2: Build from command line
swift build --target ARCPackageNameDemo
```

### Demo README Template

Each demo should include a README:

```markdown
# ARCPackageName Demo

Standalone demo app showcasing ARCPackageName features.

## Running the Demo

1. Open `Package.swift` in Xcode
2. Select the `ARCPackageNameDemo` scheme
3. Choose an iOS Simulator
4. Run (⌘R)

## Features Demonstrated

- **Feature 1**: Description of what's shown
- **Feature 2**: Description of what's shown
- **Error States**: How errors are displayed
- **Loading States**: Loading indicators and skeletons

## Screenshots

[Add screenshots here]
```

### When to Skip Demo App

Demo apps are **optional** for:
- Pure utility packages (e.g., ARCLogger, ARCDevTools)
- Packages with no visual components
- Very small, single-purpose packages

Demo apps are **required** for:
- UI component packages (ARCUIComponents, ARCDesignSystem)
- Feature packages with visual output
- Packages with complex APIs that benefit from examples

---

## 📦 Current ARC Labs Packages

### Infrastructure Packages

**ARCDesignSystem**: Consistent design system
- Configure typography
- Configure colors
- Configure accessibility

**ARCDevTools** - Development tooling
- SwiftLint/SwiftFormat configuration
- Pre-commit hooks
- Code generation templates
- Quality standards automation

**ARCFirebase**: Use when app needs:
- Auth
- Analytics
- Crashlytics
- Firestore
- RemoteConfig

**ARCIntelligence**: Use when app needs:
- IA from different models

**ARCLogger** - Structured logging with privacy
- Foundational package, no dependencies
- Privacy-conscious logging (explicit public/private)
- Multiple log levels and destinations
- Structured metadata

**ARCMaps** - Mapping and place enrichment
- Hybrid Google Places + Apple MapKit
- Restaurant data synchronization
- Interactive map displays
- Place search and details

**ARCMetrics**: Implementing analytics
- Apple MetricKit
- TelemetryDeck

**ARCNavigation** - Type-safe routing
- MVVM+C Router pattern
- SwiftUI navigation abstraction
- Testable navigation flows
- Zero dependencies

**ARCNetworking**: Use when app needs:
- Network connectivity

**ARCStorage** - Persistence abstraction
- SwiftData, CloudKit, UserDefaults, Keychain
- LRU caching implementation
- Migration helpers
- Repository pattern support

**ARCUIComponents** - Reusable UI components
- "Liquid Glass" aesthetic
- Apple HIG compliant
- Dark/Light mode support
- Accessibility built-in

---

## 📝 Package.swift Configuration

> **🔧 Advanced Features**
> For resources, binary targets, conditional dependencies, and other advanced SPM features, see [`spm.md`](../Tools/spm.md#advanced-features)

### Complete Template

This template includes the main library, tests, and demo app (isolated from production exports):

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ARCPackageName",

    // MARK: - Platforms

    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],

    // MARK: - Products
    // Only export the main library - Demo is NOT included

    products: [
        .library(
            name: "ARCPackageName",
            targets: ["ARCPackageName"]
        )
        // Note: Demo app is intentionally NOT a product
    ],

    // MARK: - Dependencies

    dependencies: [
        // Prefer zero dependencies
        // If needed, only use other ARC packages or Apple frameworks
        .package(url: "https://github.com/arclabs-studio/ARCLogger", from: "1.0.0")
    ],

    // MARK: - Targets

    targets: [
        // Main library
        .target(
            name: "ARCPackageName",
            dependencies: [
                .product(name: "ARCLogger", package: "ARCLogger")
            ],
            path: "Sources/ARCPackageName",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),

        // Tests
        .testTarget(
            name: "ARCPackageNameTests",
            dependencies: ["ARCPackageName"],
            path: "Tests/ARCPackageNameTests"
        ),

        // Demo app (developer-only, not exported)
        .executableTarget(
            name: "ARCPackageNameDemo",
            dependencies: ["ARCPackageName"],
            path: "Examples/ARCPackageNameDemo"
        )
    ],

    // MARK: - Swift Language

    swiftLanguageModes: [.v6]
)
```

### Key Requirements

| Requirement | Value | Rationale |
|-------------|-------|-----------|
| Swift Tools | 6.0+ | Modern Swift features, strict concurrency |
| iOS Target | 17+ | Latest platform APIs, SwiftData support |
| Concurrency | Strict | Thread-safe by default |
| Dependencies | Minimal | Reduce coupling, prefer ARC packages |
| Demo Export | Never | Demo is `.executableTarget`, not in products |

---

## 📚 Documentation Requirements

### README.md (Required)

Every package **MUST** include:

```markdown
# ARCPackageName

[One-line description]

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platform](https://img.shields.io/badge/platforms-iOS%2017%2B-blue.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

## Features

- ✅ Feature 1
- ✅ Feature 2
- ✅ Feature 3

## Requirements

- iOS 17.0+ / macOS 14.0+ / watchOS 10.0+ / tvOS 17.0+
- Swift 6.0+
- Xcode 16.0+

## Installation

### Swift Package Manager

\`\`\`swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCPackageName", from: "1.0.0")
]
\`\`\`

## Quick Start

\`\`\`swift
import ARCPackageName

// Basic usage example
\`\`\`

## Documentation

Full documentation available at [link to DocC site]

## Examples

See `Examples/` folder for complete demos.

## License

MIT License - see LICENSE file

## Author

**ARC Labs Studio**
```

---

### DocC Documentation (Required)

Every **public API** must have DocC comments:

```swift
/// A protocol defining logging capabilities.
///
/// Use this protocol to create custom log destinations that receive
/// log messages from the system.
///
/// ## Topics
///
/// ### Essentials
/// - ``log(_:level:metadata:)``
///
/// ### Log Levels
/// - ``LogLevel``
///
/// ## Example
///
/// ```swift
/// struct ConsoleLogger: Logger {
///     func log(_ message: String, level: LogLevel, metadata: [String: Any]) {
///         print("[\(level)] \(message)")
///     }
/// }
/// ```
public protocol Logger {
    
    /// Logs a message with the specified level and metadata.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The severity level of the log
    ///   - metadata: Additional structured data
    func log(
        _ message: String,
        level: LogLevel,
        metadata: [String: Any]
    )
}
```

**DocC Requirements**:
- Summary line (first line)
- Detailed description
- Parameters documented
- Return values documented
- Throws documented (if applicable)
- Example usage
- Topics organization

---

### CHANGELOG.md (Required)

Track all changes following [Keep a Changelog](https://keepachangelog.com/):

```markdown
# Changelog

All notable changes to ARCPackageName will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Feature in development

## [1.1.0] - 2025-01-15

### Added
- New feature X
- Support for Y

### Changed
- Improved performance of Z

### Deprecated
- Method `oldMethod()` will be removed in 2.0.0

### Fixed
- Bug in feature A

## [1.0.0] - 2024-01-01

### Added
- Initial public release
- Core functionality
```

---

## 🔢 Versioning Strategy

> **🔧 Git Commands**
> For tagging releases and publishing commands, see [`spm.md`](../Tools/spm.md#publishing-packages)

### Semantic Versioning

Follow [SemVer](https://semver.org/) strictly:

**MAJOR.MINOR.PATCH**

- **MAJOR** - Breaking changes (1.0.0 → 2.0.0)
- **MINOR** - New features, backwards compatible (1.0.0 → 1.1.0)
- **PATCH** - Bug fixes, backwards compatible (1.0.0 → 1.0.1)

### Version Bumping Rules

```
Breaking change:
- Remove public API
- Change function signature
- Rename public type
→ MAJOR version bump (1.0.0 → 2.0.0)

New feature:
- Add new public API
- Add optional parameter with default
- Extend protocol with default implementation
→ MINOR version bump (1.0.0 → 1.1.0)

Bug fix:
- Fix incorrect behavior
- Improve performance
- Update documentation
→ PATCH version bump (1.0.0 → 1.0.1)
```

### Pre-release Versions

Before 1.0.0, use `0.x.y`:
- `0.1.0` - Initial development
- `0.2.0` - Alpha features
- `0.9.0` - Beta, near stable
- `1.0.0` - First stable release

---

## 🧪 Testing Requirements

> **🔧 Test Commands**
> For `swift test`, coverage reports, and testing CLI commands, see [`spm.md`](../Tools/spm.md#building-and-testing)

### Coverage Target

**Packages**: 100% coverage target, 80% minimum

### Test Organization

```swift
import Testing
@testable import ARCPackageName

// MARK: - Unit Tests

@Suite("Logger Unit Tests")
struct LoggerTests {
    
    @Test("Log message with default level")
    func logMessage_withDefaultLevel() {
        // Test implementation
    }
    
    @Test("Log message formats metadata correctly", arguments: [
        ("key1", "value1"),
        ("key2", "value2")
    ])
    func logMessage_formatsMetadata(key: String, value: String) {
        // Parameterized test
    }
}

// MARK: - Integration Tests

@Suite("Logger Integration Tests")
struct LoggerIntegrationTests {
    
    @Test("Multiple loggers receive same message")
    func multipleLoggers_receiveSameMessage() async {
        // Integration test
    }
}

// MARK: - Performance Tests

@Suite("Logger Performance Tests")
struct LoggerPerformanceTests {
    
    @Test("Logging 1000 messages completes quickly")
    func loggingManyMessages_isPerformant() async {
        // Performance test
    }
}
```

### Test Helpers

Provide test utilities for package consumers:

```swift
// Sources/ARCPackageName/TestHelpers/MockLogger.swift
#if DEBUG
/// Mock logger for testing purposes.
///
/// Use this in your tests to verify logging behavior.
public final class MockLogger: Logger {
    public var loggedMessages: [(message: String, level: LogLevel)] = []
    
    public init() {}
    
    public func log(_ message: String, level: LogLevel, metadata: [String: Any]) {
        loggedMessages.append((message, level))
    }
    
    public func reset() {
        loggedMessages.removeAll()
    }
}
#endif
```

---

## 🎨 API Design Guidelines

### Protocol-First Design

```swift
// ✅ Good: Protocol defines contract
public protocol DataStore {
    func save(_ data: Data, for key: String) async throws
    func load(for key: String) async throws -> Data
}

// ✅ Good: Concrete implementation
public struct FileDataStore: DataStore {
    public init() {}
    
    public func save(_ data: Data, for key: String) async throws {
        // Implementation
    }
    
    public func load(for key: String) async throws -> Data {
        // Implementation
    }
}
```

### Value Types Over Reference Types

```swift
// ✅ Good: Struct for data
public struct LogEntry: Sendable {
    public let message: String
    public let level: LogLevel
    public let timestamp: Date
    
    public init(message: String, level: LogLevel, timestamp: Date = Date()) {
        self.message = message
        self.level = level
        self.timestamp = timestamp
    }
}

// ✅ Good: Actor for shared mutable state
public actor LogDestinationRegistry {
    private var destinations: [String: any LogDestination] = [:]
    
    public init() {}
    
    public func register(_ destination: any LogDestination, for id: String) {
        destinations[id] = destination
    }
}
```

### Explicit Access Control

```swift
// ✅ Good: Explicit public for API
public struct Logger {
    // ✅ Public initializer
    public init() {}
    
    // ✅ Public method
    public func log(_ message: String) { }
    
    // ✅ Internal helper (not exposed)
    func formatMessage(_ message: String) -> String { }
    
    // ✅ Private implementation detail
    private var buffer: [String] = []
}
```

### Sendable Conformance

```swift
// ✅ Good: Sendable for concurrency safety
public struct Configuration: Sendable {
    public let apiKey: String
    public let timeout: TimeInterval
    
    public init(apiKey: String, timeout: TimeInterval = 30) {
        self.apiKey = apiKey
        self.timeout = timeout
    }
}

// ✅ Good: Actor for mutable state
public actor Cache {
    private var storage: [String: Data] = [:]
    
    public init() {}
    
    public func set(_ data: Data, for key: String) {
        storage[key] = data
    }
}
```

---

## ⚙️ Quality Standards Integration

### ARCDevTools Integration

All packages **MUST** integrate ARCDevTools:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCDevTools", from: "1.0.0")
]
```

This provides:
- SwiftLint configuration
- SwiftFormat rules
- Pre-commit hooks
- Code generation templates

### Continuous Integration

`.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Swift version
      run: swift --version
    
    - name: Build
      run: swift build
    
    - name: Run tests
      run: swift test --enable-code-coverage
    
    - name: Check coverage
      run: |
        xcrun llvm-cov report \
          .build/debug/ARCPackageNamePackageTests.xctest/Contents/MacOS/ARCPackageNamePackageTests \
          -instr-profile .build/debug/codecov/default.profdata \
          -ignore-filename-regex ".build|Tests"
```

---

## 📋 Package Checklist

Before releasing a package, verify:

### Structure
- [ ] Standard folder structure followed (Public/, Internal/, Models/, etc.)
- [ ] Sources organized by responsibility
- [ ] Tests organized in Unit/, Integration/, Mocks/
- [ ] Demo app in Examples/ (if applicable)
- [ ] Demo app NOT listed in products (isolated from exports)

### Code Quality
- [ ] 80%+ test coverage (target 100%)
- [ ] All tests pass
- [ ] SwiftLint passes with zero warnings
- [ ] SwiftFormat applied
- [ ] No force unwrapping
- [ ] Sendable conformance where needed
- [ ] `@MainActor` on ViewModels and Views
- [ ] Accessibility labels on UI components

### Documentation
- [ ] README.md complete
- [ ] CHANGELOG.md updated
- [ ] All public APIs have DocC comments
- [ ] DocC builds without warnings
- [ ] Demo app with README (if applicable)
- [ ] SwiftUI Previews on all visual components

### Architecture
- [ ] Clean Architecture followed
- [ ] SOLID principles applied
- [ ] Protocol-oriented design
- [ ] Zero business logic
- [ ] Minimal dependencies
- [ ] `@Observable` (not `@Published`)

### Versioning
- [ ] Version number updated (SemVer)
- [ ] Git tag created
- [ ] CHANGELOG reflects changes
- [ ] Breaking changes clearly marked

### Integration
- [ ] ARCDevTools integrated
- [ ] CI/CD configured
- [ ] Pre-commit hooks working
- [ ] Builds on all platforms (iOS, macOS, watchOS, tvOS)
- [ ] Demo app runs on iOS Simulator

---

## 🚫 Common Mistakes

### Mistake 1: Including Business Logic

```swift
// ❌ WRONG: Business logic in package
public struct RestaurantValidator {
    public func validate(_ restaurant: Restaurant) -> Bool {
        // Business rule: must have menu
        return !restaurant.menu.isEmpty
    }
}

// ✅ RIGHT: Generic validation infrastructure
public protocol Validator {
    associatedtype Value
    func validate(_ value: Value) -> ValidationResult
}
```

### Mistake 2: Tight Coupling to App

```swift
// ❌ WRONG: Package knows about app
import FavResApp

public struct Logger {
    func log(_ message: String) {
        FavResApp.shared.handleLog(message)
    }
}

// ✅ RIGHT: Protocol-based abstraction
public protocol LogDestination {
    func receive(_ message: String)
}

public struct Logger {
    private let destination: LogDestination
    
    public init(destination: LogDestination) {
        self.destination = destination
    }
}
```

### Mistake 3: Missing Documentation

```swift
// ❌ WRONG: No documentation
public func process(_ data: Data) throws -> Result { }

// ✅ RIGHT: Comprehensive DocC
/// Processes raw data and returns a structured result.
///
/// This method parses the input data, validates it against
/// the expected format, and returns a typed result.
///
/// - Parameter data: Raw data to process
/// - Returns: Structured result object
/// - Throws: `ProcessingError` if data is invalid
///
/// ## Example
///
/// ```swift
/// let data = Data(...)
/// let result = try process(data)
/// print(result.value)
/// ```
public func process(_ data: Data) throws -> Result { }
```

---

## 📚 Further Reading

- [Swift Package Manager Documentation](https://swift.org/package-manager/)
- [DocC Documentation](https://www.swift.org/documentation/docc/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)

---

**Remember**: Packages are **infrastructure**, not features. Build once, use everywhere, maintain forever. Quality over speed. 📦
