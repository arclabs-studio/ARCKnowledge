---
name: arc-project-setup
description: |
  Project setup and configuration for Swift Packages and iOS Apps. Covers
  Package.swift templates, ARCDevTools integration (SwiftLint, SwiftFormat,
  Git hooks), Xcode project configuration, SPM best practices, GitHub Actions
  CI/CD, and development workflow automation. Use when "creating a new
  package", "setting up an iOS app", "integrating ARCDevTools", "configuring
  CI/CD", or "managing SPM dependencies".
user-invocable: true
metadata:
  author: ARC Labs Studio
  version: "3.0.0"
---

# ARC Labs Studio - Project Setup & Configuration

## Instructions

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
        .library(name: "ARCPackageName",
                 targets: ["ARCPackageName"])
    ],

    dependencies: [
        .package(url: "https://github.com/arclabs-studio/ARCLogger", from: "1.0.0")
    ],

    targets: [
        .target(name: "ARCPackageName",
                dependencies: [
                    .product(name: "ARCLogger", package: "ARCLogger")
                ],
                path: "Sources/ARCPackageName",
                swiftSettings: [
                    .enableUpcomingFeature("StrictConcurrency")
                ]),
        .testTarget(name: "ARCPackageNameTests",
                    dependencies: ["ARCPackageName"],
                    path: "Tests/ARCPackageNameTests")
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

## Semantic Versioning

```
MAJOR.MINOR.PATCH

Breaking change -> MAJOR (1.0.0 -> 2.0.0)
New feature    -> MINOR (1.0.0 -> 1.1.0)
Bug fix        -> PATCH (1.0.0 -> 1.0.1)
```

## Demo Apps in Packages

Demo apps **MUST** be standalone Xcode projects:

```
Example/
└── ARCPackageNameDemoApp/
    └── ARCPackageNameDemoApp.xcodeproj
```

**NOT** executable targets in Package.swift.

## References

For complete guides:
- **@references/packages.md** - Swift Package creation and standards
- **@references/apps.md** - iOS App guidelines
- **@references/arcdevtools.md** - ARCDevTools integration and configuration
- **@references/spm.md** - SPM commands and troubleshooting
- **@references/xcode.md** - Xcode project configuration

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
# In Xcode: Product -> Scheme -> Manage Schemes -> Check "Shared"
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

## Examples

### Creating a new Swift Package from scratch
User says: "Create a new ARCAnalytics package"

1. Create directory and `Package.swift` using template
2. Set up `Sources/ARCAnalytics/` and `Tests/ARCAnalyticsTests/` structure
3. Add ARCDevTools as submodule, run setup
4. Create initial `README.md` following template
5. Commit: `chore: initial package setup`
6. Result: Complete package ready for development with CI/CD

### Integrating ARCDevTools into an existing project
User says: "Add ARCDevTools to my app"

1. `git submodule add https://github.com/arclabs-studio/ARCDevTools`
2. `./ARCDevTools/arcdevtools-setup --with-workflows`
3. Verify `.swiftlint.yml`, `.swiftformat`, `Makefile` created
4. Test: `make lint && make format`
5. Commit: `chore: integrate ARCDevTools`
6. Result: Automated linting, formatting, and CI workflows

## Related Skills

| If you need...              | Use                       |
|-----------------------------|---------------------------|
| Architecture decisions      | `/arc-swift-architecture` |
| Testing patterns            | `/arc-tdd-patterns`       |
| Code quality standards      | `/arc-quality-standards`  |
| Git workflow                | `/arc-workflow`           |
