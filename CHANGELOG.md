# Changelog

All notable changes to ARCAgentsDocs will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CHANGELOG.md for version history tracking
- Professional README.md as repository index
- .gitattributes for submodule optimization
- .gitignore for system files

### Changed
- Fixed broken links in CLAUDE.md (corrected path casing)
- Removed redundant package listings in Learning Resources section
- Removed non-existent workflow/code-review.md reference
- Updated README.md to English and professional format
- Renamed `ai-code-review.md` to `code-review.md` for consistency
- Removed hardcoded dates from code-review.md
- Added emoji headers to all documentation files for consistency
- Moved CLAUDE.md to repository root for better Claude Code discovery

### Removed
- Duplicate ARC Labs packages descriptions in CLAUDE.md

## [1.0.0] - 2024-12-07

### Added
- Initial documentation structure
- **CLAUDE.md** - Main entry point for AI agents
- **Architecture/**
  - clean-architecture.md - Clean Architecture principles
  - mvvm-c.md - MVVM+Coordinator pattern
  - solid-principles.md - SOLID principles for Swift
  - protocol-oriented.md - Protocol-oriented programming
- **Layers/**
  - presentation.md - Presentation layer guidelines
  - domain.md - Domain layer guidelines
  - data.md - Data layer guidelines
- **Projects/**
  - apps.md - iOS App development guidelines
  - packages.md - Swift Package guidelines
- **Quality/**
  - ai-code-review.md - AI-generated code review guide
  - code-style.md - Code style standards
  - documentation.md - Documentation standards
  - testing.md - Testing strategy and requirements
- **Tools/**
  - arcdevtools.md - ARCDevTools integration
  - spm.md - Swift Package Manager guide
  - xcode.md - Xcode configuration
- **Workflow/**
  - git-branches.md - Branch naming conventions
  - git-commits.md - Commit message standards
  - plan-mode.md - Plan Mode process

[Unreleased]: https://github.com/ARC-Labs/ARCAgentsDocs/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ARC-Labs/ARCAgentsDocs/releases/tag/v1.0.0
