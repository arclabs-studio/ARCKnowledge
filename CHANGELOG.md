# Changelog

All notable changes to ARCKnowledge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.4.0] - 2026-02-05

### Added
- **arc-final-review skill** (`.claude/skills/arc-final-review/`) - Comprehensive pre-merge quality check
  - Analyzes changes by domain (SwiftUI, Concurrency, Data, Architecture)
  - Invokes specialized Axiom skills for each domain
  - Generates prioritized finalization plan with verification gates
  - Identifies tech debt cleanup items
  - Provides merge recommendation

### Changed
- Updated CLAUDE.md with arc-final-review skill in the workflow documentation

## [2.3.0] - 2026-02-03

### Added
- **Skills Index** (`Skills/skills-index.md`) - Comprehensive guide for choosing the right skill source (ARC Labs, Van der Lee, Axiom)
- **iOS 26 Liquid Glass patterns** in `arc-presentation-layer` skill
  - `.glassEffect()` modifier examples
  - Backward compatible implementations
  - Glass effect tinting patterns
- **@Previewable macro** documentation for SwiftUI previews (iOS 18+)
- **Git Worktrees workflow skill** (`arc-worktrees-workflow`) for parallel feature development
- **Memory skill** (`arc-memory`) for persistent context across Claude Code sessions

### Changed
- Updated `arc-presentation-layer` to include iOS 26 patterns and modern preview syntax
- Expanded related skills table with Axiom iOS 26 references

## [2.2.0] - 2026-01-28

### Added
- Claude GitHub Actions workflows for automated code review
  - `claude.yml`: Respond to @claude mentions in issues/PRs
  - `claude-code-review.yml`: Automated PR code reviews

## [2.1.0] - 2026-01-24

### Added
- Automatic skills installation documentation
- Skills setup via `arcdevtools-setup` script

## [2.0.1] - 2026-01-22

### Added
- Initial CHANGELOG.md with version history

### Fixed
- Various documentation improvements

## [2.0.0] - 2026-01-21

### Added
- **Claude Code Skills system** with 7 specialized skills for progressive context loading
  - `arc-swift-architecture` - Clean Architecture, MVVM+C, SOLID, Protocol-Oriented Design
  - `arc-tdd-patterns` - Swift Testing, mocking, coverage requirements
  - `arc-quality-standards` - Code review, SwiftLint/Format, documentation, accessibility
  - `arc-data-layer` - Repositories, DTOs, caching, API clients
  - `arc-presentation-layer` - Views, ViewModels, @Observable, navigation
  - `arc-workflow` - Git commits, branches, PRs, Plan Mode
  - `arc-project-setup` - Packages, apps, ARCDevTools, CI/CD
- New `.claude/skills/` directory structure
- SKILL.md files with quick reference summaries for each skill
- Skills badge in README.md

### Changed
- **CLAUDE.md** minified from ~850 to ~200 lines for progressive disclosure
- **README.md** updated with Skills documentation and usage instructions
- Token usage reduced by ~87% per typical session

## [1.6.0] - 2026-01-17

### Added
- Standardized naming convention for Example Demo Apps (`[PackageName]DemoApp`)

## [1.5.0] - 2026-01-15

### Changed
- Documentation cleanup and improvements
- Removed duplicated ARCDevTools content from apps.md

## [1.4.0] - 2026-01-15

### Added
- ARCDevTools support differentiation between iOS Apps and Swift Packages
- Project type detection (Package vs iOS App)
- iOS-specific workflows and Makefile commands

## [1.3.0] - 2026-01-13

### Added
- `singletons.md` - Guidelines for when and how to use singletons safely
- Protocol abstraction patterns for singletons

## [1.2.1] - 2025-12-19

### Changed
- Clarified Example Demo App standards
- Demo apps must be standalone Xcode projects, NOT executable targets

## [1.2.0] - 2025-12-19

### Added
- `package-structure.md` - Package folder organization guidelines by size
- ARCDevTools documentation overhaul (Git Submodule integration)
- GitHub Actions workflow templates
- SwiftLint custom rules (`observable_viewmodel`, `no_force_cast`, `no_force_try`)

### Changed
- Fixed documentation paths in CLAUDE.md
- Simplified package structure section in packages.md

## [1.1.0] - 2025-12-18

### Added
- Additional documentation improvements
- Cross-references between related documents

## [1.0.0] - 2025-12-16

### Added
- Initial stable release
- **CLAUDE.md** - Main AI agent entry point
- **Architecture/** - Clean Architecture, MVVM+C, SOLID, Protocol-Oriented Design
- **Layers/** - Presentation, Domain, Data layer guidelines
- **Projects/** - Swift Packages and iOS Apps guidelines
- **Quality/** - Code review, style, documentation, testing standards
- **Tools/** - ARCDevTools, SPM, Xcode configuration
- **Workflow/** - Git commits, branches, Plan Mode

---

[2.4.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.0.1...v2.1.0
[2.0.1]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v1.6.0...v2.0.0
[1.6.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/arclabs-studio/ARCKnowledge/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/arclabs-studio/ARCKnowledge/releases/tag/v1.0.0
