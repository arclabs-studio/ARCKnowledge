# ARCAgentsDocs

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS-blue.svg)](https://developer.apple.com)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Central knowledge base and development standards for AI agents at ARC Labs Studio.**

ARCAgentsDocs is a Swift Package that provides programmatic access to ARC Labs Studio's development guidelines, architectural standards, and best practices. It serves as the single source of truth for coding standards, patterns, and workflows—designed specifically for AI agents (primarily Claude Code) working on ARC Labs projects.

## Overview

This package contains comprehensive documentation covering:

- **Architecture**: Clean Architecture, MVVM+C, SOLID principles, Protocol-Oriented Programming
- **Implementation Layers**: Presentation, Domain, and Data layer guidelines
- **Project Types**: Standards for iOS apps and Swift packages
- **Quality Assurance**: Code review checklists, testing strategies, documentation standards
- **Development Tools**: ARCDevTools integration, SPM best practices, Xcode configuration
- **Workflow**: Git conventions, commit standards, AI agent collaboration patterns

### Why ARCAgentsDocs Exists

At ARC Labs Studio, we maintain multiple iOS apps and reusable Swift packages. Our AI agents need consistent, accessible context to maintain quality standards across all projects. ARCAgentsDocs provides:

1. **Centralized Documentation**: Single source of truth for all development standards
2. **Programmatic Access**: Swift API for AI agents to load context dynamically
3. **Version Control**: Semantic versioning ensures consistent standards across projects
4. **Easy Integration**: Add as a Swift Package dependency—no git submodules needed

## Installation

### Swift Package Manager

Add ARCAgentsDocs to your project using Xcode or by editing your `Package.swift` file:

#### Using Xcode

1. Open your project in Xcode
2. Select **File → Add Package Dependencies...**
3. Enter the repository URL: `https://github.com/ARCLabsStudio/ARCAgentsDocs.git`
4. Select the version or branch you want to use
5. Click **Add Package**

#### Using Package.swift

Add ARCAgentsDocs as a dependency in your `Package.swift` file:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "YourProject",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/ARCLabsStudio/ARCAgentsDocs.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: ["ARCAgentsDocs"]
        )
    ]
)
```

## Usage

### For Developers

#### Accessing Documentation Programmatically

```swift
import ARCAgentsDocs

// Load the main Claude.md entry point
let mainDoc = try ARCAgentsDocs.loadDocumentation(at: "CLAUDE.md")

// Load specific architecture guidelines
let cleanArchDoc = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Architecture/clean-architecture.md")

// Get URL to a documentation file
let testingURL = try ARCAgentsDocs.documentURL(for: "Documentation/Quality/testing.md")

// Explore available categories
let categories = ARCAgentsDocs.availableCategories
for category in categories {
    print("\(category.rawValue): \(category.description)")
}

// List all documents in a category
let archDocs = try ARCAgentsDocs.listDocuments(in: .architecture)
// Returns: ["clean-architecture.md", "mvvm-c.md", "protocol-oriented.md", "solid-principles.md"]
```

#### Error Handling

```swift
do {
    let doc = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Quality/testing.md")
    print(doc)
} catch DocumentationError.fileNotFound(let path) {
    print("Documentation not found at: \(path)")
} catch DocumentationError.invalidEncoding(let path) {
    print("Could not decode file at: \(path)")
} catch {
    print("Unexpected error: \(error)")
}
```

### For AI Agents

#### Primary Entry Point

The main entry point is `CLAUDE.md`, which provides:

- ARC Labs Studio philosophy and core values
- Navigation to all specialized documentation
- Quick reference checklists
- Critical rules that must never be broken

**Loading Claude.md:**

```swift
let claudeContext = try ARCAgentsDocs.loadDocumentation(at: "CLAUDE.md")
```

#### Context Loading Strategy

When working on ARC Labs projects, AI agents should:

1. **Always load `CLAUDE.md` first** for overarching guidelines
2. **Load category-specific docs** based on task type:
   - New feature → Architecture + Layers
   - Bug fix → Quality + Testing
   - Code review → Quality/code-review.md
   - Git workflow → Workflow
3. **Reference project-type docs** (apps.md or packages.md) for structural guidance

#### Recommended Documentation by Task

| Task Type | Recommended Documents |
|-----------|----------------------|
| **New iOS Feature** | `CLAUDE.md`, `Architecture/clean-architecture.md`, `Architecture/mvvm-c.md`, `Layers/presentation.md` |
| **Adding Use Case** | `CLAUDE.md`, `Layers/domain.md`, `Quality/testing.md` |
| **Data Layer Work** | `CLAUDE.md`, `Layers/data.md`, `Architecture/protocol-oriented.md` |
| **Code Review** | `CLAUDE.md`, `Quality/code-review.md`, `Quality/code-style.md` |
| **Setting Up Tests** | `CLAUDE.md`, `Quality/testing.md`, `Architecture/solid-principles.md` |
| **New Swift Package** | `CLAUDE.md`, `Projects/packages.md`, `Tools/spm.md` |
| **Git Workflow** | `Workflow/git-commits.md`, `Workflow/git-branches.md` |

#### Example: Loading Context for a New Feature

```swift
// AI Agent loads context before implementing a new iOS feature
let mainContext = try ARCAgentsDocs.loadDocumentation(at: "CLAUDE.md")
let cleanArch = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Architecture/clean-architecture.md")
let mvvm = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Architecture/mvvm-c.md")
let presentation = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Layers/presentation.md")

// Agent now has full context for implementing feature following ARC Labs standards
```

## Documentation Structure

This is a **documentation-only package** following industry best practices. All markdown files are in the repository root for easy access by AI agents and developers:

```
ARCAgentsDocs/
├── Package.swift                           # Swift Package manifest
├── README.md                               # This file
├── LICENSE                                 # MIT License
├── CHANGELOG.md                            # Version history
├── .swift-version                          # Swift 6.0
├── .gitignore                              # Git ignore rules
│
├── CLAUDE.md                               # Main AI agent entry point
│
├── Documentation/                          # All documentation (in root for accessibility)
│   ├── Architecture/                       # Architectural patterns
│   │   ├── clean-architecture.md
│   │   ├── mvvm-c.md
│   │   ├── protocol-oriented.md
│   │   └── solid-principles.md
│   ├── Layers/                            # Implementation layers
│   │   ├── data.md
│   │   ├── domain.md
│   │   └── presentation.md
│   ├── Projects/                          # Project types
│   │   ├── apps.md
│   │   └── packages.md
│   ├── Quality/                           # QA standards
│   │   ├── code-review.md
│   │   ├── code-style.md
│   │   ├── documentation.md
│   │   └── testing.md
│   ├── Tools/                             # Development tools
│   │   ├── arcdevtools.md
│   │   ├── spm.md
│   │   └── xcode.md
│   └── Workflow/                          # Development workflow
│       ├── git-branches.md
│       ├── git-commits.md
│       └── plan-mode.md
│
├── Sources/
│   └── ARCAgentsDocs/
│       └── ARCAgentsDocs.swift            # Optional programmatic API
│
└── Tests/
    └── ARCAgentsDocs Tests/
        └── ARCAgentsDocsTests.swift       # API tests
```

### Why This Structure?

1. **Documentation in Root** - AI agents can directly access files without navigating complex package structures
2. **No Resource Bundling** - Files accessed from their original locations using filesystem
3. **Optional API** - Swift API provided for programmatic access, but not required
4. **Industry Standard** - Follows documentation-only package best practices

## Documentation Index

### Architecture

| Document | Description |
|----------|-------------|
| [clean-architecture.md](Documentation/Architecture/clean-architecture.md) | Clean Architecture layers, dependency rules, data flow |
| [mvvm-c.md](Documentation/Architecture/mvvm-c.md) | MVVM+Coordinator pattern with Router implementation |
| [solid-principles.md](Documentation/Architecture/solid-principles.md) | SOLID principles applied to Swift development |
| [protocol-oriented.md](Documentation/Architecture/protocol-oriented.md) | Protocol-oriented programming guidelines |

### Implementation Layers

| Document | Description |
|----------|-------------|
| [presentation.md](Documentation/Layers/presentation.md) | Views, ViewModels, Routers/Coordinators |
| [domain.md](Documentation/Layers/domain.md) | Entities, Use Cases, business logic |
| [data.md](Documentation/Layers/data.md) | Repositories, Data Sources, persistence |

### Project Types

| Document | Description |
|----------|-------------|
| [apps.md](Documentation/Projects/apps.md) | iOS App development guidelines |
| [packages.md](Documentation/Projects/packages.md) | Swift Package development guidelines |

### Quality Assurance

| Document | Description |
|----------|-------------|
| [code-review.md](Documentation/Quality/code-review.md) | Code review checklist and AI-generated code standards |
| [code-style.md](Documentation/Quality/code-style.md) | SwiftLint, SwiftFormat, naming conventions |
| [documentation.md](Documentation/Quality/documentation.md) | DocC, README standards, inline comments |
| [testing.md](Documentation/Quality/testing.md) | Swift Testing framework and coverage requirements |

### Tools & Integration

| Document | Description |
|----------|-------------|
| [arcdevtools.md](Documentation/Tools/arcdevtools.md) | ARCDevTools package integration |
| [spm.md](Documentation/Tools/spm.md) | Swift Package Manager best practices |
| [xcode.md](Documentation/Tools/xcode.md) | Xcode project configuration, schemes, build settings |

### Workflow

| Document | Description |
|----------|-------------|
| [git-branches.md](Documentation/Workflow/git-branches.md) | Branch naming conventions and Git flow |
| [git-commits.md](Documentation/Workflow/git-commits.md) | Conventional Commits specification |
| [plan-mode.md](Documentation/Workflow/plan-mode.md) | When and how AI agents enter Plan Mode |

## Core Principles

### ARC Labs Studio Values

1. **Simple, Lovable, Complete** - Every feature should be intuitive, delightful, and fully realized
2. **Quality Over Speed** - Write code that lasts, not code that works once
3. **Modular by Design** - Build reusable components that serve multiple projects
4. **Professional Standards** - Indie doesn't mean amateur; maintain enterprise-level quality
5. **Native First** - Leverage Apple frameworks before external dependencies

### Technical Standards

- **Clean Architecture** - Strict separation of Presentation, Domain, and Data layers
- **SOLID Principles** - Single responsibility and clear abstractions
- **Protocol-Oriented Design** - Use protocols for abstraction and testing
- **Dependency Injection** - No singletons; all dependencies injected
- **Swift 6** - Modern concurrency and type safety
- **100% Test Coverage** - For packages (80%+ for apps)

## Requirements

- **Swift**: 6.0+
- **Platforms**:
  - iOS 17.0+
  - macOS 14.0+
  - watchOS 10.0+
  - tvOS 17.0+
  - visionOS 1.0+
- **Xcode**: 16.0+

## Integration in ARC Labs Projects

### iOS Apps

ARC Labs iOS apps (FavRes, FavBook, TicketMind, Pizzeria La Famiglia) should add ARCAgentsDocs as a dependency to ensure AI agents have access to current standards:

```swift
dependencies: [
    .package(url: "https://github.com/ARCLabsStudio/ARCAgentsDocs.git", from: "1.0.0")
]
```

### Swift Packages

ARC Labs Swift Packages (ARCLogger, ARCNavigation, ARCStorage, etc.) should also include ARCAgentsDocs for development consistency:

```swift
dependencies: [
    .package(url: "https://github.com/ARCLabsStudio/ARCAgentsDocs.git", from: "1.0.0")
]
```

### Example: Using in a Project

```swift
import ARCAgentsDocs

// In your AI agent integration or development tooling
func loadDevelopmentContext() {
    do {
        // Load main guidelines
        let guidelines = try ARCAgentsDocs.loadDocumentation(at: "CLAUDE.md")

        // Load specific standards based on project type
        let testingStandards = try ARCAgentsDocs.loadDocumentation(
            at: "Documentation/Quality/testing.md"
        )

        // Use documentation to inform development decisions
        print("Guidelines loaded successfully")
    } catch {
        print("Failed to load documentation: \(error)")
    }
}
```

## Contributing

We welcome contributions to improve ARC Labs Studio's documentation standards!

### Guidelines

When updating documentation:

1. **Create a feature branch** following [git-branches.md](Documentation/Workflow/git-branches.md)
2. **Make focused changes** - keep documents concise and single-purpose
3. **Update CHANGELOG.md** with your changes
4. **Follow existing formatting** - consistency matters
5. **Create a pull request** with clear description

### Documentation Style

- Use clear, concise language
- Include code examples where helpful
- Follow existing markdown formatting
- Keep documents focused on single topics
- Add DocC-style comments to Swift code

### Commit Messages

Follow [Conventional Commits](Documentation/Workflow/git-commits.md):

```
docs: add guidance on SwiftUI previews

Expanded presentation.md to include detailed requirements
for SwiftUI preview implementation with examples.
```

## Versioning

ARCAgentsDocs follows [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes to API or fundamental documentation restructuring
- **MINOR**: New documentation added or significant enhancements
- **PATCH**: Fixes, clarifications, or minor updates

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

ARCAgentsDocs is available under the MIT License. See [LICENSE](LICENSE) for details.

---

**Maintained by:** [ARC Labs Studio](https://github.com/ARCLabsStudio)
**Repository:** [ARCAgentsDocs](https://github.com/ARCLabsStudio/ARCAgentsDocs)
**Version:** See [CHANGELOG.md](CHANGELOG.md)
**Last Updated:** December 2025

---

## Quick Links

- [Main Documentation Entry Point (CLAUDE.md)](CLAUDE.md)
- [Contributing Guidelines](#contributing)
- [Documentation Index](#documentation-index)
- [API Documentation](#usage)

For questions or support, please open an issue on [GitHub](https://github.com/ARCLabsStudio/ARCAgentsDocs/issues).
