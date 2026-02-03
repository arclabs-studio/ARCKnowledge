# Skills Index for iOS/Swift Development

**Purpose**: Quick reference for choosing the right skill source for your task.

---

## Skill Sources Overview

| Source | Focus | Philosophy |
|--------|-------|------------|
| **ARC Labs** | Architecture, workflow, quality | Prescriptive - MVVM+C, ARCNavigation, Clean Architecture |
| **Axiom** | iOS APIs, diagnostics, performance | Agnóstico - Apple official patterns, comprehensive coverage |
| **Van der Lee** | Education, deep dives | Agnóstico - Teaching concepts, best practices |

---

## Quick Decision Guide

```
What do you need?                         → Primary Skill → Backup
──────────────────────────────────────────────────────────────────────
Architecture (ARC Labs projects)          → arc-swift-architecture
SwiftUI general patterns                  → swiftui-expert-skill ⭐
SwiftUI specific (nav, perf, layout)      → axiom-swiftui-*
Swift Concurrency (learning)              → swift-concurrency
Swift Concurrency (reference, Swift 6.2)  → axiom-swift-concurrency ⭐
Testing & TDD methodology                 → arc-tdd-patterns ⭐
iOS 26 / Liquid Glass                     → swiftui-expert-skill + axiom-liquid-glass
Apple APIs (specific frameworks)          → axiom-* + MCP Cupertino
ViewModels (ARC Labs)                     → arc-presentation-layer
Build failures                            → axiom-ios-build
Data persistence                          → axiom-ios-data
Performance profiling                     → axiom-ios-performance
Accessibility audit                       → axiom-ios-accessibility
```

⭐ = Recommended primary source for this topic

---

## ARC Labs Skills (Internal Standards)

Use for **ARC Labs projects** where consistency with studio standards is required.

| Skill | When to Use |
|-------|-------------|
| `/arc-swift-architecture` | Designing features, setting up layers, MVVM+C |
| `/arc-presentation-layer` | Views, ViewModels, @Observable, ARCNavigation |
| `/arc-data-layer` | Repositories, API clients, DTOs, caching |
| `/arc-tdd-patterns` | Writing tests, Swift Testing, TDD workflow |
| `/arc-quality-standards` | Code review, SwiftLint/Format, documentation |
| `/arc-workflow` | Git commits, branches, PRs, Plan Mode |
| `/arc-project-setup` | New packages/apps, ARCDevTools, CI/CD |
| `/arc-worktrees-workflow` | Parallel feature development with git worktrees |
| `/arc-memory` | Persistent context across Claude Code sessions |

**Characteristics**:
- Prescriptive (imposes specific patterns)
- MVVM+C with Clean Architecture
- @Observable required (no ObservableObject)
- ARCNavigation for navigation
- Swift Testing (not XCTest)
- 100% test coverage for packages

---

## Van der Lee Skills (Education)

Use for **learning** and **general guidance** without architecture constraints.

| Skill | When to Use |
|-------|-------------|
| `swiftui-expert-skill` | SwiftUI patterns, Liquid Glass, animations, general SwiftUI work |
| `swift-concurrency` | Learning async/await, actors, Sendable, migration |

**Characteristics**:
- Agnóstico (no architecture imposed)
- Excellent educational content
- Based on official Apple patterns
- Regular updates for new iOS versions

**Notes**:
- `swiftui-expert-skill` is the best general SwiftUI reference
- `swift-concurrency` now covers Swift 6.2 (`@concurrent`, `NonisolatedNonsendingByDefault`)

---

## Axiom Skills (Comprehensive iOS Coverage)

Use for **specific iOS APIs**, **diagnostics**, and **performance**.

### Router Skills (Start Here)

| Router | Covers |
|--------|--------|
| `axiom-ios-build` | Build failures, environment issues, SPM |
| `axiom-ios-ui` | SwiftUI patterns, navigation, performance |
| `axiom-ios-data` | Persistence, Core Data, SwiftData, GRDB |
| `axiom-ios-concurrency` | Async/await, actors, data races |
| `axiom-ios-performance` | Profiling, memory, energy |
| `axiom-ios-accessibility` | VoiceOver, Dynamic Type, WCAG |
| `axiom-ios-networking` | URLSession, Network.framework |
| `axiom-ios-integration` | Siri, Shortcuts, App Intents |
| `axiom-ios-ai` | Foundation Models, on-device AI |

### Specialized Skills (Via Router or Direct)

| Area | Key Skills |
|------|------------|
| SwiftUI | `axiom-swiftui-nav`, `axiom-swiftui-performance`, `axiom-swiftui-layout` |
| iOS 26 | `axiom-liquid-glass`, `axiom-swiftui-26-ref` |
| Concurrency | `axiom-swift-concurrency`, `axiom-testing-async` |
| Data | `axiom-swiftdata`, `axiom-core-data`, `axiom-grdb` |
| Testing | `axiom-swift-testing`, `axiom-ui-testing` |

**Characteristics**:
- Exhaustive coverage (128+ skills)
- WWDC 2025 content included
- Diagnostic skills for troubleshooting
- Reference skills for API details

**Tip**: Use router skills first, they'll guide you to the right specialized skill.

---

## MCP Cupertino (Apple Documentation)

Use for **official Apple documentation** and **WWDC sessions**.

```
Available sources:
- apple-docs: Modern Apple API documentation
- samples: Sample code projects
- hig: Human Interface Guidelines
- apple-archive: Legacy guides (Core Animation, Quartz 2D)
- swift-evolution: Swift Evolution proposals
- swift-org: Swift.org documentation
- swift-book: The Swift Programming Language book
- packages: Swift package documentation
```

**When to use**:
- Need official API documentation
- Researching WWDC sessions
- Looking for sample code
- Checking Swift Evolution proposals

---

## Coverage Gaps (What Each Source Lacks)

| Area | ARC Labs | Van der Lee | Axiom |
|------|----------|-------------|-------|
| iOS 26 / Liquid Glass | ❌ | ✅ | ✅ |
| @concurrent (Swift 6.2) | ❌ | ✅ | ✅ |
| Foundation Models (AI) | ❌ | ❌ | ✅ |
| SwiftData advanced | ❌ | ❌ | ✅ |
| Accessibility audit | ⚠️ Mentions | ❌ | ✅ |
| Memory profiling | ❌ | ❌ | ✅ |
| Camera/Vision | ❌ | ❌ | ✅ |
| TDD methodology | ✅ | ❌ | ⚠️ |
| MVVM+C patterns | ✅ | ❌ | ❌ |
| ARCNavigation | ✅ | ❌ | ❌ |

---

## Common Scenarios

### "I'm starting a new ARC Labs feature"
1. `/arc-swift-architecture` for layer structure
2. `/arc-presentation-layer` for ViewModel
3. `/arc-tdd-patterns` for tests

### "My SwiftUI view isn't working"
1. `swiftui-expert-skill` for general patterns
2. `axiom-swiftui-debugging` if still stuck
3. `axiom-swiftui-performance` if it's slow

### "I'm getting Swift 6 concurrency errors"
1. `swift-concurrency` for understanding the error
2. `axiom-swift-concurrency` for specific fixes
3. Check build settings (strict concurrency, upcoming features)

### "I need to implement iOS 26 features"
1. `swiftui-expert-skill` for Liquid Glass basics
2. `axiom-liquid-glass` for detailed implementation
3. `axiom-swiftui-26-ref` for API reference

### "My build is failing"
1. `axiom-ios-build` first (environment diagnostics)
2. Check for zombie processes, Derived Data, SPM cache
3. Then investigate code issues

### "I need to add Core Data / SwiftData"
1. `axiom-ios-data` (router) to choose approach
2. `axiom-swiftdata` or `axiom-core-data` for implementation
3. `/arc-data-layer` for ARC Labs patterns

---

## Priority Order

When multiple skills could apply:

1. **Environment/Build** (axiom-ios-build) - Fix environment before debugging code
2. **Architecture** (arc-swift-architecture, axiom-ios-ui) - Determine HOW to structure
3. **Implementation** (specific skills) - Guide specific feature work
4. **Quality** (arc-quality-standards, arc-tdd-patterns) - Review and test

---

## Version Information

| Skill Source | Last Updated | Key Features |
|--------------|--------------|--------------|
| ARC Labs | Jan 2025 | MVVM+C, Swift Testing, @Observable |
| Van der Lee | Feb 2026 | iOS 26, Swift 6.2, Liquid Glass |
| Axiom | Feb 2026 | WWDC 2025, iOS 26, @concurrent |

---

**Note**: This index reflects the current state of skills. As iOS evolves, check for updates to each skill source.
