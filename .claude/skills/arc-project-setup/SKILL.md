---
name: arc-project-setup
description: |
  ARC Labs Studio project setup and configuration. Covers Swift Package creation
  (Package.swift templates, structure, versioning), iOS App setup, ARCDevTools
  integration (SwiftLint, SwiftFormat, Git hooks), Xcode project configuration,
  SPM best practices, GitHub Actions CI/CD, and development workflow automation.

  **INVOKE THIS SKILL** when:
  - Creating new Swift Packages with proper structure
  - Setting up new iOS Apps following ARC Labs standards
  - Integrating ARCDevTools (SwiftLint, SwiftFormat, hooks)
  - Configuring Xcode projects or CI/CD pipelines
  - Managing SPM dependencies
  - Troubleshooting build or configuration issues
---

# ARC Labs Studio - Project Setup & Configuration

## When to Use This Skill

Use this skill when:
- **Creating new Swift Packages** with proper structure
- **Setting up new iOS Apps** following ARC Labs standards
- **Integrating ARCDevTools** for quality automation
- **Configuring Xcode projects** properly
- **Managing SPM dependencies** in packages or apps
- **Setting up CI/CD** with GitHub Actions
- **Troubleshooting build** or configuration issues
- **Understanding ARC Labs tooling** and workflow

## Quick Reference

### Swift Package Template (Package.swift)

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ARCPackageName",

    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],

    products: [
        .library(
            name: "ARCPackageName",
            targets: ["ARCPackageName"]
        )
        // Note: Demo apps are standalone Xcode projects, NOT products
    ],

    dependencies: [
        .package(url: "https://github.com/arclabs-studio/ARCLogger", from: "1.0.0")
    ],

    targets: [
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
        .testTarget(
            name: "ARCPackageNameTests",
            dependencies: ["ARCPackageName"],
            path: "Tests/ARCPackageNameTests"
        )
    ],

    swiftLanguageModes: [.v6]
)
```

### Package Structure

```
ARCPackageName/
├── Package.swift              # Manifest
├── README.md                  # Documentation
├── LICENSE                    # MIT license
├── CHANGELOG.md               # Version history
├── Sources/
│   └── ARCPackageName/
│       ├── Protocols/         # Abstractions
│       ├── Implementations/   # Concrete types
│       ├── Models/            # Data types
│       └── Resources/         # Assets
├── Tests/
│   └── ARCPackageNameTests/
│       ├── Unit/
│       └── Mocks/
├── Example/                   # Demo app (standalone Xcode project)
│   └── ARCPackageNameDemoApp/
│       └── ARCPackageNameDemoApp.xcodeproj
└── Documentation.docc/
```

### ARCDevTools Installation

```bash
# 1. Install tools
brew install swiftlint swiftformat

# 2. Add as submodule
git submodule add https://github.com/arclabs-studio/ARCDevTools

# 3. Run setup
./ARCDevTools/arcdevtools-setup --with-workflows

# 4. Commit
git add .gitmodules ARCDevTools/ .swiftlint.yml .swiftformat Makefile
git commit -m "chore: integrate ARCDevTools"
```

### Makefile Commands

```bash
make help      # Show all commands
make lint      # Run SwiftLint
make format    # Check formatting
make fix       # Apply SwiftFormat
make test      # Run tests
make clean     # Clean build
make setup     # Re-run ARCDevTools setup
```

### Key Configuration Files

| File | Purpose |
|------|---------|
| `.swiftlint.yml` | SwiftLint rules (copied from ARCDevTools) |
| `.swiftformat` | SwiftFormat rules (copied from ARCDevTools) |
| `Makefile` | Common development commands |
| `.git/hooks/pre-commit` | Auto-format and lint before commit |
| `.git/hooks/pre-push` | Run tests before push |

### SwiftLint Key Rules

```yaml
# Metrics
line_length: 120 (warning) / 150 (error)
file_length: 500 (warning) / 1000 (error)
function_body_length: 50 (warning) / 100 (error)

# Custom rules (errors)
no_force_cast: as! → severity: error
no_force_try: try! → severity: error

# Custom rules (warnings)
observable_viewmodel: ViewModels must use @Observable
```

### SwiftFormat Key Settings

```
--swiftversion 6.0
--indent 4
--maxwidth 120
--self remove
--type-attributes prev-line    # @MainActor on separate line
--func-attributes prev-line
--stored-var-attributes same-line
```

### GitHub Actions (Swift Packages)

```yaml
# .github/workflows/tests.yml
name: Tests
on: [push, pull_request]

jobs:
  test-macos:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      - run: swift test --parallel

  test-linux:
    runs-on: ubuntu-latest
    container: swift:6.0
    steps:
      - uses: actions/checkout@v4
      - run: swift test --parallel
```

### GitHub Actions (iOS Apps)

```yaml
# .github/workflows/tests.yml
name: Tests
on: [push, pull_request]

jobs:
  test-ios:
    runs-on: macos-15
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_16.2.app

      - name: Test
        run: |
          xcodebuild test \
            -scheme "YourApp" \
            -destination "platform=iOS Simulator,name=iPhone 16" \
            CODE_SIGNING_ALLOWED=NO
```

## ARC Labs Packages

| Package | Purpose |
|---------|---------|
| **ARCLogger** | Structured logging with privacy |
| **ARCNavigation** | Type-safe MVVM+C routing |
| **ARCStorage** | Persistence (SwiftData, CloudKit, Keychain) |
| **ARCMaps** | Mapping (Google Places + Apple MapKit) |
| **ARCUIComponents** | Reusable UI components |
| **ARCDesignSystem** | Typography, colors, accessibility |
| **ARCDevTools** | Linting, formatting, CI/CD |
| **ARCFirebase** | Firebase integration |
| **ARCNetworking** | Network layer |
| **ARCIntelligence** | AI/ML integration |
| **ARCMetrics** | Analytics (MetricKit, TelemetryDeck) |

## Project Type Detection

ARCDevTools auto-detects project type:

| Type | Detection | Generated |
|------|-----------|-----------|
| Swift Package | `Package.swift` | SPM-based Makefile, workflows |
| iOS App | `*.xcodeproj` | xcodebuild Makefile, iOS workflows |

```bash
# Override if needed
./ARCDevTools/arcdevtools-setup --type package
./ARCDevTools/arcdevtools-setup --type ios-app
```

## Semantic Versioning

```
MAJOR.MINOR.PATCH

Breaking change → MAJOR (1.0.0 → 2.0.0)
New feature    → MINOR (1.0.0 → 1.1.0)
Bug fix        → PATCH (1.0.0 → 1.0.1)
```

### Creating a Release

```bash
# Tag release
git tag -a v1.2.0 -m "Release 1.2.0"
git push origin v1.2.0

# Update CHANGELOG.md
# GitHub Actions will create release from tag
```

## Demo Apps in Packages

Demo apps **MUST** be standalone Xcode projects:

```
Example/
└── ARCPackageNameDemoApp/
    └── ARCPackageNameDemoApp.xcodeproj
```

**NOT** executable targets in Package.swift.

## Detailed Documentation

For complete guides:
- **@packages.md** - Swift Package creation and standards
- **@apps.md** - iOS App guidelines
- **@arcdevtools.md** - ARCDevTools integration and configuration
- **@spm.md** - SPM commands and troubleshooting
- **@xcode.md** - Xcode project configuration

## Troubleshooting

### SwiftLint Not Found
```bash
brew reinstall swiftlint
```

### Pre-commit Hook Not Running
```bash
chmod +x .git/hooks/pre-commit
./ARCDevTools/hooks/install-hooks.sh
```

### xcodebuild Scheme Not Found
```bash
xcodebuild -list  # List available schemes
# In Xcode: Product → Scheme → Manage Schemes → Check "Shared"
```

### Code Signing Error in CI
```bash
# Add CODE_SIGNING_ALLOWED=NO to xcodebuild
xcodebuild test -scheme "App" CODE_SIGNING_ALLOWED=NO
```

### Submodule Not Initialized
```bash
git submodule update --init --recursive
```

## Related Skills

When working on project setup, you may also need:

| If you need...              | Use                       |
|-----------------------------|---------------------------|
| Architecture decisions      | `/arc-swift-architecture` |
| Testing patterns            | `/arc-tdd-patterns`       |
| Code quality standards      | `/arc-quality-standards`  |
| Git workflow                | `/arc-workflow`           |
