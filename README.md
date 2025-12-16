# 📜 ARCKnowledge

![Documentation](https://img.shields.io/badge/Type-Documentation-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Git Submodule](https://img.shields.io/badge/Integration-Git%20Submodule-brightgreen.svg)

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

### Pinning to Specific Version

```bash
cd ARCKnowledge
git checkout v1.0.0
cd ..
git add ARCKnowledge
git commit -m "chore: pin ARCKnowledge to v1.0.0"
```

---

## 📖 Usage

### For AI Agents

**Start with `CLAUDE.md`** - the main entry point containing ARC Labs philosophy, core values, and navigation to all specialized documentation.

**Context loading strategy:**

1. Load `CLAUDE.md` for overarching guidelines
2. Load category-specific docs based on task:
   - New feature → Architecture + Layers
   - Bug fix → Quality + Testing
   - Code review → Quality/code-review.md
   - Git workflow → Workflow

**Recommended docs by task:**

| Task | Documents |
|------|-----------|
| **New iOS Feature** | `CLAUDE.md`, `Architecture/clean-architecture.md`, `Architecture/mvvm-c.md`, `Layers/presentation.md` |
| **Adding Use Case** | `CLAUDE.md`, `Layers/domain.md`, `Quality/testing.md` |
| **Data Layer Work** | `CLAUDE.md`, `Layers/data.md`, `Architecture/protocol-oriented.md` |
| **Code Review** | `CLAUDE.md`, `Quality/code-review.md`, `Quality/code-style.md` |
| **Setting Up Tests** | `CLAUDE.md`, `Quality/testing.md`, `Architecture/solid-principles.md` |
| **New Swift Package** | `CLAUDE.md`, `Projects/packages.md`, `Tools/spm.md` |
| **Git Workflow** | `Workflow/git-commits.md`, `Workflow/git-branches.md` |

### For Developers

Access documentation directly from your project:

```bash
# View main guidelines
cat ARCKnowledge/CLAUDE.md

# Check specific topics
cat ARCKnowledge/Architecture/clean-architecture.md
cat ARCKnowledge/Quality/testing.md
cat ARCKnowledge/Workflow/git-commits.md
```

---

## 🏗️ Documentation Structure

```
ARCKnowledge/
├── CLAUDE.md                    # Main AI agent entry point
│
├── Architecture/                # Architectural patterns
│   ├── clean-architecture.md
│   ├── mvvm-c.md
│   ├── protocol-oriented.md
│   └── solid-principles.md
│
├── Layers/                      # Implementation layers
│   ├── data.md
│   ├── domain.md
│   └── presentation.md
│
├── Projects/                    # Project types
│   ├── apps.md
│   └── packages.md
│
├── Quality/                     # QA standards
│   ├── code-review.md
│   ├── code-style.md
│   ├── documentation.md
│   ├── readme-standards.md
│   └── testing.md
│
├── Tools/                       # Development tools
│   ├── arcdevtools.md
│   ├── spm.md
│   └── xcode.md
│
└── Workflow/                    # Development workflow
    ├── git-branches.md
    ├── git-commits.md
    └── plan-mode.md
```

---

## 📚 Documentation Index

### Architecture

| Document | Description |
|----------|-------------|
| [clean-architecture.md](Architecture/clean-architecture.md) | Clean Architecture layers, dependency rules, data flow |
| [mvvm-c.md](Architecture/mvvm-c.md) | MVVM+Coordinator pattern with Router implementation |
| [solid-principles.md](Architecture/solid-principles.md) | SOLID principles applied to Swift development |
| [protocol-oriented.md](Architecture/protocol-oriented.md) | Protocol-oriented programming guidelines |

### Implementation Layers

| Document | Description |
|----------|-------------|
| [presentation.md](Layers/presentation.md) | Views, ViewModels, Routers/Coordinators |
| [domain.md](Layers/domain.md) | Entities, Use Cases, business logic |
| [data.md](Layers/data.md) | Repositories, Data Sources, persistence |

### Project Types

| Document | Description |
|----------|-------------|
| [apps.md](Projects/apps.md) | iOS App development guidelines |
| [packages.md](Projects/packages.md) | Swift Package development guidelines |

### Quality Assurance

| Document | Description |
|----------|-------------|
| [code-review.md](Quality/code-review.md) | Code review checklist and AI-generated code standards |
| [code-style.md](Quality/code-style.md) | SwiftLint, SwiftFormat, naming conventions |
| [documentation.md](Quality/documentation.md) | DocC, README standards, inline comments |
| [readme-standards.md](Quality/readme-standards.md) | Standardized README template with visual format |
| [testing.md](Quality/testing.md) | Swift Testing framework and coverage requirements |

### Tools & Integration

| Document | Description |
|----------|-------------|
| [arcdevtools.md](Tools/arcdevtools.md) | ARCDevTools package integration |
| [spm.md](Tools/spm.md) | Swift Package Manager best practices |
| [xcode.md](Tools/xcode.md) | Xcode project configuration, schemes, build settings |

### Workflow

| Document | Description |
|----------|-------------|
| [git-branches.md](Workflow/git-branches.md) | Branch naming conventions and Git flow |
| [git-commits.md](Workflow/git-commits.md) | Conventional Commits specification |
| [plan-mode.md](Workflow/plan-mode.md) | When and how AI agents enter Plan Mode |

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
4. Follow existing markdown formatting
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
