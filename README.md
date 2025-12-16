# 📜 ARCKnowledge

![Documentation](https://img.shields.io/badge/Type-Documentation-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Git Submodule](https://img.shields.io/badge/Integration-Git%20Submodule-brightgreen.svg)

**Central knowledge base and development standards at ARC Labs Studio**

Development guidelines • Architecture standards • Best practices • AI agent collaboration

---

## 🎯 Overview

ARCKnowledge is a comprehensive documentation repository that serves as the **single source of truth** for ARC Labs Studio's development guidelines, architectural standards, and best practices. It provides structured, accessible documentation designed specifically for AI agents (primarily Claude Code) working on ARC Labs projects.

### Key Features

- ✅ **Clean Architecture** - Comprehensive guidelines for layered architecture
- ✅ **SOLID Principles** - Applied to Swift development
- ✅ **Protocol-Oriented** - Design patterns and best practices
- ✅ **Quality Standards** - Code review, testing, and documentation requirements
- ✅ **Git Submodule Integration** - Easy to add to any project
- ✅ **Version Controlled** - Track documentation changes over time

---

## 💡 Why ARCKnowledge?

At ARC Labs Studio, we maintain multiple iOS apps and reusable Swift packages. Our AI agents need consistent, accessible context to maintain quality standards across all projects.

**ARCKnowledge provides:**

1. 📖 **Centralized Documentation** - Single source of truth for all development standards
2. 🔌 **Easy Integration** - Add as a git submodule to any project
3. 🏷️ **Version Control** - Track documentation evolution alongside your code
4. 📦 **Direct Access** - Files directly accessible in your repository

---

## 📋 Requirements

- **Git:** Any modern version
- **Projects:** iOS apps, Swift packages, or any ARC Labs Studio project
- **AI Agent:** Claude Code (recommended) or compatible AI development tools

---

## 🚀 Installation

### Adding as Git Submodule

#### Initial Setup

To add ARCKnowledge to your project:

```bash
# Navigate to your project root
cd /path/to/your/project

# Add ARCKnowledge as a submodule
git submodule add https://github.com/ARCLabsStudio/ARCKnowledge.git ARCKnowledge

# Initialize and update the submodule
git submodule update --init --recursive
```

This will create an `ARCKnowledge/` directory in your project containing all documentation.

#### Recommended Structure

```
YourProject/
├── ARCKnowledge/              # Git submodule
│   ├── CLAUDE.md
│   ├── Architecture/
│   ├── Layers/
│   ├── Projects/
│   ├── Quality/
│   ├── Tools/
│   └── Workflow/
├── Sources/
├── Tests/
└── README.md
```

### Cloning Projects with ARCKnowledge

When cloning a project that already includes ARCKnowledge:

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/YourOrg/YourProject.git

# Or if you already cloned without submodules
git submodule update --init --recursive
```

### Updating ARCKnowledge

To update to the latest documentation:

```bash
# Navigate to your project root
cd /path/to/your/project

# Update the submodule to the latest commit
git submodule update --remote ARCKnowledge

# Commit the submodule update
git add ARCKnowledge
git commit -m "chore: update ARCKnowledge documentation"
```

### Pinning to Specific Version

To use a specific version of ARCKnowledge:

```bash
# Navigate to the submodule
cd ARCKnowledge

# Checkout a specific tag or commit
git checkout v1.0.0

# Return to project root
cd ..

# Commit the pinned version
git add ARCKnowledge
git commit -m "chore: pin ARCKnowledge to v1.0.0"
```

---

## 📖 Usage

### For AI Agents

#### Primary Entry Point

The main entry point is **`CLAUDE.md`**, which provides:

- 🎯 ARC Labs Studio philosophy and core values
- 🧭 Navigation to all specialized documentation
- ✅ Quick reference checklists
- 🚨 Critical rules that must never be broken

**Accessing Claude.md:**

```bash
# From your project root
cat ARCKnowledge/CLAUDE.md
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

### For Developers

#### Quick Reference

All documentation is organized by category in the ARCKnowledge directory:

```bash
# View architecture guidelines
cat ARCKnowledge/Architecture/clean-architecture.md

# Check testing standards
cat ARCKnowledge/Quality/testing.md

# Review git commit conventions
cat ARCKnowledge/Workflow/git-commits.md
```

#### IDE Integration

You can create workspace-specific links for quick access:

```bash
# Create symbolic links in your project root (optional)
ln -s ARCKnowledge/CLAUDE.md CLAUDE.md
```

---

## 🏗️ Documentation Structure

ARCKnowledge is organized into focused categories for easy navigation:

```
ARCKnowledge/
├── README.md                               # This file
├── LICENSE                                 # MIT License
├── CHANGELOG.md                            # Version history
├── .gitignore                              # Git ignore rules
├── .gitattributes                          # Git attributes for submodules
│
├── CLAUDE.md                               # Main AI agent entry point
│
├── Architecture/                           # Architectural patterns
│   ├── clean-architecture.md
│   ├── mvvm-c.md
│   ├── protocol-oriented.md
│   └── solid-principles.md
│
├── Layers/                                 # Implementation layers
│   ├── data.md
│   ├── domain.md
│   └── presentation.md
│
├── Projects/                               # Project types
│   ├── apps.md
│   └── packages.md
│
├── Quality/                                # QA standards
│   ├── code-review.md
│   ├── code-style.md
│   ├── documentation.md
│   ├── readme-standards.md
│   └── testing.md
│
├── Tools/                                  # Development tools
│   ├── arcdevtools.md
│   ├── spm.md
│   └── xcode.md
│
└── Workflow/                               # Development workflow
    ├── git-branches.md
    ├── git-commits.md
    └── plan-mode.md
```

### Why This Structure?

1. 📁 **Direct Access** - All documentation at repository root for easy navigation
2. 🎯 **Category-Based** - Organized by concern (Architecture, Quality, Workflow, etc.)
3. 🔌 **Git Submodule Friendly** - Integrates seamlessly into any project
4. ✨ **Version Controlled** - Track documentation changes alongside code

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

### ARC Labs Studio Values

1. **Simple, Lovable, Complete** - Every feature should be intuitive, delightful, and fully realized
2. **Quality Over Speed** - Write code that lasts, not code that works once
3. **Modular by Design** - Build reusable components that serve multiple projects
4. **Professional Standards** - Indie doesn't mean amateur; maintain enterprise-level quality
5. **Native First** - Leverage Apple frameworks before external dependencies

### Technical Standards

- ✅ **Clean Architecture** - Strict separation of Presentation, Domain, and Data layers
- ✅ **SOLID Principles** - Single responsibility and clear abstractions
- ✅ **Protocol-Oriented Design** - Use protocols for abstraction and testing
- ✅ **Dependency Injection** - No singletons; all dependencies injected
- ✅ **Swift 6** - Modern concurrency and type safety
- ✅ **100% Test Coverage** - For packages (80%+ for apps)

---

## 🔗 Integration in ARC Labs Projects

### iOS Apps

ARC Labs iOS apps (FavRes, FavBook, TicketMind, Pizzeria La Famiglia) should include ARCKnowledge as a git submodule:

```bash
git submodule add https://github.com/ARCLabsStudio/ARCKnowledge.git ARCKnowledge
```

### Swift Packages

ARC Labs Swift Packages (ARCLogger, ARCNavigation, ARCStorage, etc.) should also include ARCKnowledge for development consistency:

```bash
git submodule add https://github.com/ARCLabsStudio/ARCKnowledge.git ARCKnowledge
```

### Example: Accessing Documentation

```bash
# In your project root, access any documentation file
cat ARCKnowledge/CLAUDE.md
cat ARCKnowledge/Architecture/clean-architecture.md
cat ARCKnowledge/Quality/testing.md
```

---

## 🤝 Contributing

We welcome contributions to improve ARC Labs Studio's documentation standards!

### Guidelines

When updating documentation:

1. **Fork and clone** the ARCKnowledge repository
2. **Create a feature branch** following [git-branches.md](Workflow/git-branches.md)
3. **Make focused changes** - keep documents concise and single-purpose
4. **Update CHANGELOG.md** with your changes
5. **Follow existing formatting** - consistency matters
6. **Create a pull request** with clear description

### Documentation Style

- Use clear, concise language
- Include code examples where helpful
- Follow existing markdown formatting
- Keep documents focused on single topics
- Use proper headings and sections

### Commit Messages

Follow [Conventional Commits](Workflow/git-commits.md):

```
docs: add guidance on SwiftUI previews

Expanded presentation.md to include detailed requirements
for SwiftUI preview implementation with examples.
```

---

## 📦 Versioning

ARCKnowledge follows [Semantic Versioning](https://semver.org/):

- **MAJOR** - Breaking changes to documentation structure or fundamental restructuring
- **MINOR** - New documentation added or significant enhancements
- **PATCH** - Fixes, clarifications, or minor updates

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## 🔄 Maintenance

### Keeping Documentation Current

To ensure your project uses the latest documentation:

1. **Regularly update** the submodule (weekly or monthly)
2. **Review changes** in the CHANGELOG before updating
3. **Test with AI agents** after updates to ensure compatibility
4. **Pin versions** for production releases

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
git commit -m "chore: update ARCKnowledge to latest"
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

## 🔗 Quick Links

- 📖 [Main Documentation Entry Point (CLAUDE.md)](CLAUDE.md)
- 🤝 [Contributing Guidelines](#contributing)
- 📚 [Documentation Index](#documentation-index)
- 🔄 [Version History (CHANGELOG.md)](CHANGELOG.md)

---

<div align="center">

**Maintained by:** [ARC Labs Studio](https://github.com/ARCLabsStudio)

**Version:** See [CHANGELOG.md](CHANGELOG.md) • **Last Updated:** December 2025

Made with 💛 by ARC Labs Studio

For questions or support, open an issue on [GitHub](https://github.com/ARCLabsStudio/ARCKnowledge/issues)

</div>
