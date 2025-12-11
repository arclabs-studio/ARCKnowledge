# Changelog

All notable changes to ARCAgentsDocs will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-12-11

### Added - Documentation-Only Swift Package
- **Package.swift** - Swift Package manifest with support for iOS 17+, macOS 14+, watchOS 10+, tvOS 17+, visionOS 1+
- **Sources/ARCAgentsDocs/ARCAgentsDocs.swift** - Public API for programmatic documentation access
  - `loadDocumentation(at:)` - Load documentation content as String
  - `documentURL(for:)` - Get URL to documentation file
  - `packageRootURL` - Get package root directory for file access
  - `listDocuments(in:)` - List documents in a category
  - `availableCategories` - Discover documentation categories
  - `DocumentCategory` enum - Architecture, Layers, Projects, Quality, Tools, Workflow
  - `DocumentationError` - Typed error handling for file operations
- **Tests/ARCAgentsDocs Tests/** - Comprehensive test suite
  - ARCAgentsDocsTests.swift - Tests for all API functionality (10 tests, all passing)
- **.swift-version** - Swift 6.0 specification
- **README.md** - Completely rewritten in English for Swift Package distribution
  - Installation instructions (Xcode + Package.swift)
  - Usage examples for developers and AI agents
  - Comprehensive API documentation
  - Integration guidelines for ARC Labs projects
- **.gitignore** - Enhanced for Swift Package Manager (added *.xcodeproj)

### Documentation Structure
All documentation files are in the repository root for easy access by AI agents:

- **CLAUDE.md** - Main entry point for AI agents
- **Documentation/Architecture/** - Architectural patterns and principles
  - clean-architecture.md - Clean Architecture layers and dependency rules
  - mvvm-c.md - MVVM+Coordinator pattern with Router
  - solid-principles.md - SOLID principles applied to Swift
  - protocol-oriented.md - Protocol-oriented programming guidelines
- **Documentation/Layers/** - Implementation layer guidelines
  - presentation.md - Views, ViewModels, Routers/Coordinators
  - domain.md - Entities, Use Cases, business logic
  - data.md - Repositories, Data Sources, persistence
- **Documentation/Projects/** - Project type guidelines
  - apps.md - iOS App development standards
  - packages.md - Swift Package development standards
- **Documentation/Quality/** - Quality assurance standards
  - code-review.md - Code review checklist and AI-generated code standards
  - code-style.md - SwiftLint, SwiftFormat, naming conventions
  - documentation.md - DocC, README standards, inline comments
  - testing.md - Swift Testing framework and coverage requirements
- **Documentation/Tools/** - Development tools integration
  - arcdevtools.md - ARCDevTools package setup and usage
  - spm.md - Swift Package Manager best practices
  - xcode.md - Xcode project configuration and schemes
- **Documentation/Workflow/** - Development workflow
  - git-branches.md - Branch naming conventions and Git flow
  - git-commits.md - Conventional Commits specification
  - plan-mode.md - When and how AI agents enter Plan Mode

### Technical Details
- **Documentation-only package** - Files in repository root for direct access
- **Swift 6.0** with strict concurrency
- All types are `Sendable` for concurrency safety
- 100% test coverage of API functionality
- Platform availability annotations: iOS 17+, macOS 14+, etc.
- No external dependencies
- Files accessed via filesystem using `#file` for package root discovery

### Philosophy
This package follows industry best practices for documentation-only Swift packages:
- Documentation files remain in repository root (not buried in Sources/)
- Direct filesystem access for AI agents
- Optional programmatic API for Swift integration
- No resource bundling - files accessed from their original locations

[Unreleased]: https://github.com/ARCLabsStudio/ARCAgentsDocs/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ARCLabsStudio/ARCAgentsDocs/releases/tag/v1.0.0
