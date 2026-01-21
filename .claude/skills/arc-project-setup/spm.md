# 📦 Swift Package Manager (SPM)

## Overview

Swift Package Manager (SPM) is Apple's official dependency management and distribution tool for Swift code. At ARC Labs, SPM is the **exclusive method** for managing dependencies, creating reusable packages, and organizing modular architecture across all projects.

> **📚 Related Documentation**
> - For ARC Labs package standards, templates, and quality requirements, see [`packages.md`](../Projects/packages.md)
> - This document focuses on SPM as a tool: commands, features, and troubleshooting

---

## Why SPM?

### Advantages

**Native Integration**:
- Built into Swift and Xcode
- First-class support from Apple
- No third-party tools required

**Modern Design**:
- Declarative package manifests
- Semantic versioning
- Dependency resolution

**Performance**:
- Parallel builds
- Incremental compilation
- Optimized for Swift

**Ecosystem**:
- Growing package index
- GitHub integration
- Cross-platform support (iOS, macOS)

### vs CocoaPods / Carthage

| Feature | SPM | CocoaPods | Carthage |
|---------|-----|-----------|----------|
| Native Integration | ✅ | ❌ | ❌ |
| No Installation | ✅ | ❌ | ❌ |
| Swift-First | ✅ | Partial | Partial |
| Binary Frameworks | ✅ | ✅ | ✅ |
| Resource Bundles | ✅ | ✅ | ❌ |
| Active Development | ✅ | Declining | Minimal |

**ARC Labs Policy**: SPM only. No CocoaPods, no Carthage.

---

## Package Structure

### Basic Structure
```
MyPackage/
├── Package.swift          # Package manifest (required)
├── README.md              # Documentation (required)
├── Sources/
│   └── MyPackage/
│       └── MyPackage.swift
└── Tests/
    └── MyPackageTests/
        └── MyPackageTests.swift
```

### Complete Package
```
ARCStorage/
├── Package.swift
├── README.md
├── LICENSE
├── CHANGELOG.md
├── .swiftlint.yml
├── .swiftformat
├── .gitignore
├── Sources/
│   └── ARCStorage/
│       ├── ARCStorage.swift
│       ├── Protocols/
│       │   ├── StorageProvider.swift
│       │   └── Repository.swift
│       ├── Providers/
│       │   ├── SwiftDataProvider.swift
│       │   ├── CloudKitProvider.swift
│       │   └── UserDefaultsProvider.swift
│       ├── Repositories/
│       │   └── GenericRepository.swift
│       └── Errors/
│           └── StorageError.swift
├── Tests/
│   └── ARCStorageTests/
│       ├── Unit/
│       │   ├── ProvidersTests.swift
│       │   └── RepositoryTests.swift
│       ├── Integration/
│       │   └── SwiftDataIntegrationTests.swift
│       └── Mocks/
│           └── MockStorageProvider.swift
├── Example/                          # Example Demo App (standalone Xcode project)
│   └── ExampleApp/
│       ├── ExampleApp.xcodeproj      # Independent Xcode project
│       ├── ExampleApp/
│       │   ├── App.swift
│       │   └── ContentView.swift
│       └── README.md
└── Documentation.docc/
    ├── ARCStorage.md
    └── Articles/
        └── GettingStarted.md
```

**Note**: The Example folder contains a standalone Xcode project (`.xcodeproj`), NOT an executable target in `Package.swift`. See [packages.md](../Projects/packages.md#-example-demo-apps) for detailed guidelines.

---

## Package.swift Manifest

### Basic Structure
```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyPackage",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MyPackage",
            targets: ["MyPackage"]
        )
    ],
    dependencies: [
        // External dependencies
    ],
    targets: [
        .target(
            name: "MyPackage",
            dependencies: []
        ),
        .testTarget(
            name: "MyPackageTests",
            dependencies: ["MyPackage"]
        )
    ],
    swiftLanguageModes: [.v6]
)
```

> **📦 ARC Labs Template**
> For the standard ARC Labs Package.swift template with all required settings, see [`packages.md`](../Projects/packages.md#-packageswift-configuration)

### Advanced Features

#### Resources
```swift
.target(
    name: "ARCDesignSystem",
    resources: [
        .process("Resources/Fonts"),
        .process("Resources/Colors.xcassets"),
        .copy("Resources/Config.json")
    ]
)
```

**Resource Rules**:
- `.process()`: Build-time processing (asset catalogs, xibs)
- `.copy()`: Copied as-is (JSON, data files)

#### Binary Targets
```swift
.binaryTarget(
    name: "ThirdPartySDK",
    url: "https://example.com/SDK.xcframework.zip",
    checksum: "abc123..."
)
```

#### Conditional Dependencies
```swift
dependencies: [
    .package(
        url: "https://github.com/firebase/firebase-ios-sdk",
        from: "10.0.0"
    )
],
targets: [
    .target(
        name: "ARCAnalytics",
        dependencies: [
            .product(
                name: "FirebaseAnalytics",
                package: "firebase-ios-sdk",
                condition: .when(platforms: [.iOS])
            )
        ]
    )
]
```

---

## Dependency Management

### Adding Dependencies

#### In Xcode

1. File → Add Package Dependencies
2. Enter package URL or search
3. Select version rule
4. Add to target

#### In Package.swift
```swift
dependencies: [
    .package(
        url: "https://github.com/arclabs/ARCLogger",
        from: "1.2.0"
    )
]
```

### Version Requirements

#### Exact Version
```swift
.package(
    url: "https://github.com/arclabs/ARCLogger",
    exact: "1.2.0"
)
```

#### Version Range
```swift
// Up to next major (recommended)
.package(
    url: "https://github.com/arclabs/ARCLogger",
    from: "1.2.0"  // Allows 1.2.0 to <2.0.0
)

// Up to next minor
.package(
    url: "https://github.com/arclabs/ARCLogger",
    .upToNextMinor(from: "1.2.0")  // Allows 1.2.0 to <1.3.0
)

// Specific range
.package(
    url: "https://github.com/arclabs/ARCLogger",
    "1.2.0"..<"1.5.0"
)
```

#### Branch or Commit
```swift
// Branch (development only)
.package(
    url: "https://github.com/arclabs/ARCLogger",
    branch: "develop"
)

// Specific commit (avoid in production)
.package(
    url: "https://github.com/arclabs/ARCLogger",
    revision: "abc123def456"
)
```

### Local Packages

For development:
```swift
dependencies: [
    .package(path: "../ARCLogger")
]
```

Or add via Xcode:
1. File → Add Package Dependencies
2. Add Local...
3. Select package directory

---

## Creating Packages

### Initialize New Package
```bash
# Create package directory
mkdir ARCLogger
cd ARCLogger

# Initialize package
swift package init --type library

# Or for executable
swift package init --type executable
```

### Package Template

Use ARC Labs template:
```bash
# Clone template
git clone https://github.com/arclabs/SPMTemplate ARCNewPackage
cd ARCNewPackage

# Update Package.swift
# Update README.md
# Implement functionality
```

### Package Naming

**Convention**: `ARC<Feature>`

**Examples**:
- ARCLogger
- ARCStorage
- ARCNetworking
- ARCDesignSystem
- ARCUIComponents

**Rules**:
- Prefix with "ARC"
- PascalCase
- Descriptive but concise
- No abbreviations unless obvious

---

## Building and Testing

### Build Package
```bash
# Build package
swift build

# Build for release
swift build -c release

# Build specific target
swift build --target ARCLogger
```

### Run Tests
```bash
# Run all tests
swift test

# Run with code coverage
swift test --enable-code-coverage

# Run specific test
swift test --filter ARCLoggerTests
```

### Clean
```bash
# Clean build artifacts
swift package clean

# Reset (clean + delete .build)
swift package reset

# Purge resolved dependencies
swift package purge-cache
```

---

## Publishing Packages

### Versioning

Follow [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`

> **📦 ARC Labs Versioning**
> For detailed versioning strategy and version bumping rules, see [`packages.md`](../Projects/packages.md#-versioning-strategy)

### Tagging Releases
```bash
# Create tag
git tag -a v1.2.0 -m "Release version 1.2.0"

# Push tag
git push origin v1.2.0

# Push all tags
git push --tags
```

### Release Checklist

- [ ] Update version in Package.swift (if applicable)
- [ ] Update CHANGELOG.md
- [ ] All tests passing
- [ ] Documentation updated
- [ ] README reflects changes
- [ ] SwiftLint/SwiftFormat passing
- [ ] Create Git tag
- [ ] Push tag to GitHub
- [ ] Create GitHub release with notes

---

## Package Collections

### Creating a Collection
```json
{
  "name": "ARC Labs Packages",
  "overview": "Official Swift packages from ARC Labs Studio",
  "keywords": ["ios", "swift", "arclabs"],
  "packages": [
    {
      "url": "https://github.com/arclabs/ARCLogger",
      "summary": "Centralized logging infrastructure"
    },
    {
      "url": "https://github.com/arclabs/ARCStorage",
      "summary": "Flexible storage abstraction layer"
    }
  ],
  "version": "1.0.0"
}
```

### Adding Collection
```bash
# Add collection
swift package-collection add https://arclabs.com/packages.json

# List collections
swift package-collection list

# Search in collections
swift package-collection search --keywords logging
```

---

## Best Practices

### Package Design

**Single Responsibility**:
```swift
// ✅ Good - Focused package
ARCLogger: Logging only

// ❌ Bad - Too broad
ARCUtilities: Logging, networking, storage, UI...
```

**Clear API Surface**:
```swift
// ✅ Good - Explicit public API
public protocol StorageProvider { }
public struct SwiftDataProvider: StorageProvider { }

// ❌ Bad - Everything public
public struct InternalHelper { }  // Should be internal
```

**Protocol-First Design**:
```swift
// ✅ Good - Protocol + implementation
public protocol Logger { }
public struct ConsoleLogger: Logger { }

// ❌ Bad - Concrete type only
public struct Logger { }  // Hard to test/mock
```

### Dependency Management

**Minimal Dependencies**:
- Prefer fewer, well-maintained packages
- Avoid deep dependency trees
- Consider vendoring small dependencies

**Version Pinning**:
```swift
// ✅ Good - Flexible version range
.package(url: "...", from: "1.2.0")

// ⚠️ Acceptable - Exact for stability
.package(url: "...", exact: "1.2.0")

// ❌ Bad - Branch reference in production
.package(url: "...", branch: "develop")
```

**Internal vs Public**:
```swift
// Internal dependency (not exposed)
dependencies: [
    .package(url: "github.com/vendor/InternalTool", from: "1.0.0")
]

// Public dependency (part of API)
public import ARCLogger  // Clients must also import
```

### Testing

**Best Practices**:
- 100% public API coverage
- Integration tests for critical paths
- Mock implementations for protocols

> **📦 ARC Labs Testing**
> For testing requirements, coverage targets, and test organization, see [`packages.md`](../Projects/packages.md#-testing-requirements)

---

## Common Issues

### Dependency Resolution
```bash
# Update to latest versions
swift package update

# Resolve without updating
swift package resolve

# Reset and resolve
swift package reset
swift package resolve
```

### Build Failures
```bash
# Clean and rebuild
swift package clean
swift build

# Check for errors
swift package diagnose
```

### Cache Issues
```bash
# Clear SPM cache
rm -rf ~/Library/Caches/org.swift.swiftpm

# Clear derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
```

---

## Migration Guides

### From CocoaPods

1. Remove Podfile and Pods/
2. Add dependencies via SPM
3. Update imports
4. Test thoroughly
```bash
# Before
pod install
import Alamofire

# After
# Add via Xcode or Package.swift
import Alamofire  # Same import
```

### From Carthage

1. Remove Cartfile
2. Add dependencies via SPM
3. Remove copy frameworks script
4. Update imports

---

## Advanced Topics

### Custom Build Tools
```swift
// Package.swift
targets: [
    .plugin(
        name: "CodeGenerator",
        capability: .buildTool()
    )
]
```

### Platform-Specific Code
```swift
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public func platformSpecific() {
    #if os(iOS)
    // iOS implementation
    #elseif os(macOS)
    // macOS implementation
    #endif
}
```

### Unsafe Flags
```swift
.target(
    name: "MyTarget",
    swiftSettings: [
        .unsafeFlags(["-warnings-as-errors"])
    ]
)
```

**Use Sparingly**: Unsafe flags can break package compatibility.

---

## Resources

- [Swift Package Manager Documentation](https://swift.org/package-manager/)
- [Package Manager Evolution](https://github.com/apple/swift-evolution#package-manager)
- [Swift Packages Index](https://swiftpackageindex.com/)
- [Semantic Versioning](https://semver.org/)

---

## Summary

Swift Package Manager is the foundation of modular development at ARC Labs. By creating focused, well-documented packages with clear APIs and comprehensive tests, we build a reusable ecosystem that accelerates development across all projects. Every package should be treated as a product—professional, reliable, and designed for longevity. Master SPM, embrace modularity, and build packages that stand the test of time.