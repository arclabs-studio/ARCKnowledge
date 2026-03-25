# Changelog

All notable changes to ARCKnowledge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.13.0] - 2026-03-25

### Added
- **`/arc-localization` skill** (`.claude/skills/arc-localization/`) — Localization standards for ARC Labs Studio apps and packages: in-app locale switching, String Catalogs, `nameKey` pattern for domain entities, `LocalizedStringKey` vs `String(localized:)`, navigation title localization, and `LanguageManager` pattern
- **`Quality/localization.md`** — Comprehensive localization reference document covering String Catalogs, `nameKey` pattern, `LanguageManager`, and testing strategies

### Changed
- **`Skills/skills-index.md`** — Added `arc-localization` skill entry

---

## [2.12.0] - 2026-03-24

### Added
- **Claude GitHub Actions workflows** (`.github/workflows/`) — `claude.yml` responds to `@claude` mentions in issues/PRs; `claude-code-review.yml` runs automated PR code reviews following ARC Labs Swift standards
- **`/arc-worktrees-workflow` skill** — Parallel development workflow using git worktrees
- **`/arc-memory` skill** — Memory directories system for persistent context across sessions
- **`/arc-final-review` skill** — Pre-merge quality checks inspired by Staff iOS Engineer review patterns; invokes Axiom skills by domain; produces prioritized finalization plan
- **`/arc-audit` skill** — Full project compliance audit against all ARCKnowledge standards
- **`/arc-xcode-cloud` skill** — Xcode Cloud CI/CD setup and configuration workflows
- **iOS 26 Liquid Glass patterns** in `arc-presentation-layer` — `.glassEffect` modifier, backward-compatible glass implementations, tinting patterns, toolbar Liquid Glass treatment
- **`@Previewable` macro patterns** in `arc-presentation-layer` — SwiftUI preview best practices for iOS 18+
- **`Skills/skills-index.md`** — Comprehensive routing guide mapping tasks to skill sources (ARC Labs, Van der Lee, Axiom), decision matrix, and coverage gaps
- **`Architecture/swift-design-principles.md`** cross-references added to `solid-principles.md` and `protocol-oriented.md`
- **Security patterns** added to `.gitignore` for ARC Labs projects

### Changed
- **All ARC Labs skills** aligned with Anthropic skill guide format (`arc-final-review`, `arc-audit`, `arc-memory`, `arc-worktrees-workflow`, `arc-data-layer`, `arc-tdd-patterns`, `arc-presentation-layer`, `arc-workflow`, `arc-swift-architecture`, `arc-quality-standards`, `arc-project-setup`)
- **`CLAUDE.md`** — Comprehensive rewrite as primary agent guide; updated ViewModel/UseCase/concurrency patterns; `@MainActor` per-method annotation; multiline formatting and private extension patterns; grouped UseCase pattern with `Sendable` conformance; surfaced Swift design principles
- **`Layers/presentation.md`** — `@MainActor` placement guidance updated; ViewModel examples use `private extension` pattern with per-method annotation
- **`Architecture/mvvm-c.md`** — Added `@Environment` for Router clarification note
- **`Skills/skills-index.md`** — Added Agents section with routing table for all 12 agents; added `arc-xcode-cloud` and new review skills

### Fixed
- **`arc-spm-manager`** — Corrected GitHub org URL (`arcdevtools` → `arclabs-studio`); added ARCPurchasing and ARCAuthentication to known packages table

---

## [2.11.0] - 2026-03-21

### Added
- **`Layers/presentation.md`** — `@MainActor` placement deep dive: explains why method-level annotation is preferred over class-level, with Swift 6.2 SE-0466 note on `DefaultIsolation = @MainActor` for app targets vs packages
- **`Layers/presentation.md`** — Dependency Injection Strategy section: decision matrix for init injection vs `@Environment`, documents when to use `@Environment` for `@Observable` models (Router, UserSession) vs init injection for Domain/Data layers
- **`Architecture/mvvm-c.md`** — Added `@Environment` for Router clarification note explaining why Router uses environment in Views but init injection in ViewModels
- **`Architecture/swift-design-principles.md`** — Minor cross-reference improvements

### Changed
- **`Layers/presentation.md`** — ViewModel examples updated: removed blanket `@MainActor` from class, moved to `private extension` pattern with per-method `@MainActor` annotation
- **`.claude/skills/arc-swift-architecture/references/`** — Synced all reference documents with updated Layers and Architecture content
- **`CLAUDE.md`** — Updated `@MainActor` quick reference to reflect per-method annotation pattern

---

## [2.10.0] - 2026-03-19

### Added
- **`Architecture/swift-design-principles.md`** — Foundational document defining ARC Labs' technical position on Swift software design. Six principles expressed in Swift's native vocabulary: Value Semantics by Default, Protocol-Driven Abstraction, Composition Over Inheritance, Well-Defined Ownership, Structured Concurrency, and Compile-Time Correctness. Includes honest SOLID mapping table showing which principles are reinforced, transformed, or dissolved in Swift, plus anti-patterns section.

### Changed
- **`Architecture/solid-principles.md`** — Added ARC Labs context note referencing `swift-design-principles.md` as the interpretive lens
- **`Architecture/protocol-oriented.md`** — Added cross-reference to `swift-design-principles.md`
- **`CLAUDE.md`** — Updated Technical Principles section: replaced bare "SOLID Principles" entry with reference to the six Swift design principles and `swift-design-principles.md`
- **`.claude/skills/arc-swift-architecture/SKILL.md`** — Replaced "SOLID Principles Quick Guide" with "Swift Design Principles" section; added `swift-design-principles.md` as primary reference
- **`.claude/skills/arc-swift-architecture/references/`** — Added `swift-design-principles.md` reference copy for skill context
- **`Skills/skills-index.md`** — Updated arc-swift-architecture entry to mention Swift design principles
- **`README.md`** — Added `swift-design-principles.md` to Architecture directory listing and arc-swift-architecture skill files

---

## [2.9.0] - 2026-03-14

### Added
- **ARC Labs Subagents system** (`AGENTS.md`, `.claude/agents/`) — 12 autonomous agents that invoke skills dynamically
  - **arc-swift-tdd** (sonnet) — TDD implementation, writes tests before code
  - **arc-swift-reviewer** (sonnet) — Delegated code review, structured report
  - **arc-swift-debugger** (sonnet) — Build/test failure diagnosis, environment-first
  - **arc-spm-manager** (haiku) — Package.swift management and verification (ARCPurchasing, ARCAuthentication added)
  - **arc-xcode-explorer** (haiku) — Read-only codebase navigation and architecture mapping
  - **arc-linear-bridge** (haiku) — Linear ticket to Swift test scaffolding + branch creation
  - **arc-pr-publisher** — Validates pre-PR checklist, creates GitHub PR, links Linear ticket, updates issue to "In Review"
  - **arc-release-orchestrator** — Bumps version, updates CHANGELOG, creates release branch and PR
  - **arc-testflight** — Orchestrates archive → upload → TestFlight configuration and tester groups
  - **arc-aso** — App Store Optimization, orchestrates 8 ASO skills, produces ready-to-upload metadata
  - **arc-swiftdata-migration** — High-risk schema migration agent, test-before-code, confirms before breaking changes
  - **arc-dependency-auditor** — Read-only SPM dependency audit across project ecosystem

### Changed
- **arc-linear-bridge** — Added `mcp__ARC_Linear_GitHub__github_create_branch` tool; creates branch after scaffolding
- **arc-spm-manager** — Fixed GitHub org URL (`arcdevtools` → `arclabs-studio`); added ARCPurchasing and ARCAuthentication to known packages table
- **Skills/skills-index.md** — Added Agents section with routing table for all 12 agents

---

## [2.8.0] - 2026-03-12

### Added
- **arc-xcode-cloud skill** (`.claude/skills/arc-xcode-cloud/`) - Complete Xcode Cloud CI/CD setup guidance: ci_scripts configuration, recommended workflows (CI, PR validation, Release), environment variables, private SPM authorization, and 25-hour budget strategy
- **Claude GitHub Actions workflows** - `claude.yml` for @claude mentions in issues/PRs and `claude-code-review.yml` for automated PR code reviews
- **arc-worktrees-workflow skill** - Parallel feature development with git worktrees
- **arc-memory skill** - Persistent context across Claude Code sessions
- **arc-final-review skill** - Pre-merge quality checks inspired by Staff iOS Engineer review patterns

### Changed
- **CLAUDE.md** comprehensive agent guide rewrite with full architecture patterns
  - Progressive concurrency model (`@MainActor` only per-method, never blanket on class)
  - Grouped Use Case pattern with action enums
  - Private extension pattern enforcement
  - Multiline declaration alignment rules
  - ARCKnowledge submodule chain documentation
  - Skills routing table with Axiom and Van der Lee complementary skills
  - Critical rules expanded to 15
- **arc-presentation-layer skill** - Added iOS 26 Liquid Glass material effects, `@Previewable` macro, toolbar glass treatment, backward-compatible glass implementations
- **arc-swift-architecture skill** - Added Use Case grouping patterns, ISP examples, concurrency guidelines
- **Skills/skills-index.md** - Updated routing guide with arc-xcode-cloud and CI/CD scenario
- **Tools/xcode.md** - Added Xcode Cloud section with quick setup guide
- **Architecture and layer documentation** - Updated ViewModel/UseCase patterns, `@MainActor` per-method examples, Sendable conformance

---

## [2.7.0] - 2026-02-22

### Changed
- **All 11 skills aligned with Anthropic's official skill guide** (Feb 2026)
  - Rewritten `description` fields with concise trigger phrases
  - Added `metadata` blocks (author, version) to all skills
  - Renamed section headings (`Instructions`, `References`, `Common Mistakes`, `Examples`)
  - Added `## Examples` sections with concrete usage scenarios
  - Removed `**INVOKE THIS SKILL**` blocks from descriptions
- **23 supplemental files moved to `references/` subdirectories** for progressive disclosure
  - `arc-data-layer`, `arc-tdd-patterns`, `arc-presentation-layer` (1 file each)
  - `arc-workflow` (3 files), `arc-swift-architecture` (6 files)
  - `arc-quality-standards` (6 files), `arc-project-setup` (5 files)
- **Skills updated**: arc-final-review, arc-audit, arc-memory, arc-data-layer, arc-tdd-patterns, arc-presentation-layer, arc-workflow, arc-swift-architecture, arc-quality-standards, arc-project-setup, arc-worktrees-workflow

## [2.6.0] - 2026-02-19

### Added
- **arc-audit skill** (`.claude/skills/arc-audit/`) - Comprehensive project compliance audit against all ARCKnowledge standards
- **ARC Labs security patterns** in `.gitignore` - Protects sensitive files from accidental commits

### Changed
- **CLAUDE.md** major expansion with detailed architecture patterns
  - Progressive concurrency model (`@MainActor` only where needed, not blanket)
  - Grouped Use Case pattern with action enums
  - Private extension pattern enforcement (all private methods in `private extension`)
  - Multiline declaration alignment rules (first param on same line)
  - Enhanced critical rules (15 rules, up from 13)
- **arc-swift-architecture skill** - Added Use Case grouping patterns, ISP examples, concurrency guidelines
- **arc-presentation-layer skill** - Enhanced ViewModel patterns with progressive `@MainActor`
- **arc-quality-standards skill** - Added audit checklist sections
- **arc-tdd-patterns skill** - Enhanced testing patterns and coverage requirements
- **arc-final-review skill** - Refined review workflow
- **Layers/domain.md** - Expanded Domain layer documentation with grouped Use Cases and business rules
- **Quality/code-style.md** - Updated with private extension pattern and multiline alignment rules
- **Skills/skills-index.md** - Updated routing guide

## [2.5.0] - 2026-02-06

### Added
- **Swift 6 Concurrency Testing Patterns** - @MainActor isolation, mock extension isolation, tag centralization
- **Clean Architecture Learnings** from FVRS-73 audit
  - @Observable + lazy var incompatibility patterns (use IUOs + init)
  - Composition Root pattern for AppCoordinator DI
  - Interface Segregation: Reader/Writer protocol separation for repositories
  - Pure Use Cases (stateless, no dependencies)
  - Real-world ISP example with Toggle/Get/Filter use cases
- **Mock Factory Best Practices** - avoiding false matches, Swift 6 compatibility

### Changed
- Updated `arc-presentation-layer` skill with @Observable/lazy var patterns
- Updated `arc-swift-architecture` skill with ISP examples and Composition Root
- Updated `arc-tdd-patterns` skill with Swift 6 testing patterns
- Updated `Layers/presentation.md` with comprehensive ViewModel patterns
- Updated `Quality/testing.md` with Swift 6 mock isolation patterns

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

[2.13.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.12.0...v2.13.0
[2.12.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.11.0...v2.12.0
[2.11.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.10.0...v2.11.0
[2.10.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.9.0...v2.10.0
[2.9.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.8.0...v2.9.0
[2.8.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.7.0...v2.8.0
[2.7.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.6.0...v2.7.0
[2.6.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.5.0...v2.6.0
[2.5.0]: https://github.com/arclabs-studio/ARCKnowledge/compare/v2.4.0...v2.5.0
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
