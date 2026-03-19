# 📜 ARCKnowledge

![Documentation](https://img.shields.io/badge/Type-Documentation-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Git Submodule](https://img.shields.io/badge/Integration-Git%20Submodule-brightgreen.svg)
![Skills](https://img.shields.io/badge/Claude%20Code-Skills%20Enabled-purple.svg)

**Central knowledge base and development standards at ARC Labs Studio**

Development guidelines • Architecture standards • Best practices • AI agent collaboration

---

## 🎯 Overview

ARCKnowledge is the **single source of truth** for ARC Labs Studio's development guidelines, architectural standards, and best practices. Designed for AI agents (primarily Claude Code) and developers working on ARC Labs projects.

**What's included:**

- Clean Architecture & MVVM+C patterns
- SOLID & Protocol-Oriented programming
- Quality standards (testing, code review, documentation)
- Git workflow & commit conventions
- Development tools integration

---

## 🧠 Claude Code Skills Integration

ARCKnowledge now uses **Claude Code Skills** for progressive context loading, reducing token usage by ~87% compared to loading all documentation at once.

### Available Skills

| Skill | Command | Use When |
|-------|---------|----------|
| **Swift Architecture** | `/arc-swift-architecture` | Designing features, MVVM+C, Clean Architecture, SOLID |
| **TDD Patterns** | `/arc-tdd-patterns` | Writing tests, Swift Testing, coverage requirements |
| **Quality Standards** | `/arc-quality-standards` | Code review, SwiftLint/Format, documentation, accessibility |
| **Data Layer** | `/arc-data-layer` | Repositories, API clients, DTOs, caching |
| **Presentation Layer** | `/arc-presentation-layer` | Views, ViewModels, @Observable, navigation |
| **Workflow** | `/arc-workflow` | Git commits, branches, PRs, Plan Mode |
| **Project Setup** | `/arc-project-setup` | New packages/apps, ARCDevTools, Xcode, CI/CD |
| **Xcode Cloud** | `/arc-xcode-cloud` | Xcode Cloud setup, ci_scripts, workflows, hour budget |

### How It Works

1. **CLAUDE.md** loads automatically with core philosophy and critical rules (~200 lines)
2. Use **slash commands** to load detailed context only when needed
3. Each skill includes a **SKILL.md** summary + detailed documentation files

### Example Usage

```
User: "I need to implement a new repository for user data"

Claude: [Uses /arc-data-layer to load data layer patterns]
        [Uses /arc-swift-architecture if architecture questions arise]
```

---

## 🚀 Installation

### Adding to Your Project

```bash
# Add ARCKnowledge as a submodule
git submodule add https://github.com/ARCLabsStudio/ARCKnowledge.git ARCKnowledge

# Initialize the submodule
git submodule update --init --recursive
```

This creates an `ARCKnowledge/` directory in your project with all documentation.

### Cloning Projects with ARCKnowledge

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/YourOrg/YourProject.git

# Or initialize after cloning
git submodule update --init --recursive
```

### Updating to Latest Version

```bash
# Update submodule to latest
git submodule update --remote ARCKnowledge

# Commit the update
git add ARCKnowledge
git commit -m "chore: update ARCKnowledge documentation"
```

---

## 📖 Usage

### For AI Agents (Claude Code)

**Start with `CLAUDE.md`** - loads automatically with core philosophy, critical rules, and skill references.

**Load skills on-demand:**
- Use `/arc-swift-architecture` when designing features
- Use `/arc-tdd-patterns` when writing tests
- Use `/arc-quality-standards` when reviewing code
- Use `/arc-workflow` when committing code

### For Developers

Access documentation directly from your project:

```bash
# View main guidelines
cat ARCKnowledge/CLAUDE.md

# View skill documentation
cat ARCKnowledge/.claude/skills/arc-swift-architecture/SKILL.md

# Check specific topics
cat ARCKnowledge/Architecture/clean-architecture.md
cat ARCKnowledge/Quality/testing.md
```

---

## 🏗️ Documentation Structure

```
ARCKnowledge/
├── CLAUDE.md                    # Main entry point (minified)
├── README.md                    # This file
│
├── .claude/                     # Claude Code Skills
│   └── skills/
│       ├── arc-swift-architecture/
│       ├── arc-tdd-patterns/
│       ├── arc-quality-standards/
│       ├── arc-data-layer/
│       ├── arc-presentation-layer/
│       ├── arc-workflow/
│       └── arc-project-setup/
│
├── Architecture/                # Architectural patterns (reference)
│   ├── swift-design-principles.md   ← Foundational design principles
│   ├── clean-architecture.md
│   ├── mvvm-c.md
│   ├── protocol-oriented.md
│   ├── singletons.md
│   └── solid-principles.md
│
├── Layers/                      # Implementation layers (reference)
│   ├── data.md
│   ├── domain.md
│   └── presentation.md
│
├── Projects/                    # Project types (reference)
│   ├── apps.md
│   └── packages.md
│
├── Quality/                     # QA standards (reference)
│   ├── code-review.md
│   ├── code-style.md
│   ├── documentation.md
│   ├── package-structure.md
│   ├── readme-standards.md
│   ├── testing.md
│   └── ui-guidelines.md
│
├── Tools/                       # Development tools (reference)
│   ├── arcdevtools.md
│   ├── spm.md
│   └── xcode.md
│
└── Workflow/                    # Development workflow (reference)
    ├── git-branches.md
    ├── git-commits.md
    └── plan-mode.md
```

---

## 📚 Skills Documentation Index

### arc-swift-architecture
Covers Swift design principles, Clean Architecture, MVVM+C pattern, SOLID principles, Protocol-Oriented Design, dependency injection, and singleton patterns.

**Files included:**
- `swift-design-principles.md`, `clean-architecture.md`, `mvvm-c.md`, `solid-principles.md`, `protocol-oriented.md`, `singletons.md`, `domain.md`

### arc-tdd-patterns
Covers Swift Testing framework, TDD workflow, mocking patterns, coverage requirements, and CI testing.

**Files included:**
- `testing.md`

### arc-quality-standards
Covers code review checklists, SwiftLint/SwiftFormat, documentation, README templates, package structure, and UI guidelines.

**Files included:**
- `code-review.md`, `code-style.md`, `documentation.md`, `readme-standards.md`, `package-structure.md`, `ui-guidelines.md`

### arc-data-layer
Covers Repository pattern, Data Sources, DTOs, caching strategies, error mapping, and SwiftData integration.

**Files included:**
- `data.md`

### arc-presentation-layer
Covers SwiftUI Views, @Observable ViewModels, ARCNavigation Router, state management, and MVVM+C implementation.

**Files included:**
- `presentation.md`

### arc-workflow
Covers Conventional Commits, branch naming, Git Flow, PRs, and Plan Mode.

**Files included:**
- `git-commits.md`, `git-branches.md`, `plan-mode.md`

### arc-project-setup
Covers Swift Package creation, iOS App setup, ARCDevTools integration, Xcode configuration, and CI/CD.

**Files included:**
- `packages.md`, `apps.md`, `arcdevtools.md`, `spm.md`, `xcode.md`

### arc-xcode-cloud
Covers Xcode Cloud setup, `ci_scripts/` configuration, recommended workflows (CI, PR validation, Release), environment variables, private SPM dependency authorization, and 25-hour budget strategy.

**Files included:**
- `SKILL.md` (self-contained)

---

## 🎯 Core Principles

ARCKnowledge embodies ARC Labs Studio's commitment to quality:

**Core Values:** Simple, Lovable, Complete • Quality Over Speed • Modular by Design • Professional Standards • Native First

**Technical Standards:** Clean Architecture • SOLID Principles • Protocol-Oriented Design • Dependency Injection • Swift 6 • 100% Test Coverage (packages) / 80%+ (apps)

For complete philosophy and guidelines, see [CLAUDE.md](CLAUDE.md).

---

## 🤝 Contributing

Contributions to improve ARC Labs Studio's documentation are welcome!

**Process:**

1. Fork and clone the repository
2. Create a feature branch following [git-branches.md](Workflow/git-branches.md)
3. Make focused changes - keep documents concise
4. Update relevant SKILL.md if changing skill documentation
5. Create a pull request with clear description

**Commit format:**

```
docs: add guidance on SwiftUI previews

Expanded presentation.md to include detailed requirements
for SwiftUI preview implementation with examples.
```

---

## 🔄 Maintenance

### Troubleshooting

**Submodule not initialized:**
```bash
git submodule update --init --recursive
```

**Submodule detached HEAD:**
```bash
cd ARCKnowledge
git checkout main
git pull origin main
cd ..
git add ARCKnowledge
git commit -m "chore: update ARCKnowledge"
```

**Remove submodule:**
```bash
git submodule deinit ARCKnowledge
git rm ARCKnowledge
rm -rf .git/modules/ARCKnowledge
```

---

## 📄 License

ARCKnowledge is available under the MIT License. See [LICENSE](LICENSE) for details.

---

<div align="center">

**[ARC Labs Studio](https://github.com/ARCLabsStudio)** • Made with 💛

For questions or support, open an issue on [GitHub](https://github.com/ARCLabsStudio/ARCKnowledge/issues)

</div>
