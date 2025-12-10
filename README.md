# ARCAgentsDocs

**Central knowledge base for AI agents at ARC Labs Studio.**

This repository contains the development guidelines, architectural standards, and best practices that AI agents (primarily Claude Code) use when working on ARC Labs projects. It serves as the single source of truth for coding standards, patterns, and workflows.

## Quick Start

### For AI Agents

The main entry point is [`CLAUDE.md`](CLAUDE.md) at the repository root. This file provides:

- ARC Labs Studio philosophy and core values
- Navigation to all specialized documentation
- Quick reference checklists
- Critical rules that must never be broken

### For Developers

1. **New to ARC Labs?** Start with [CLAUDE.md](CLAUDE.md) for an overview
2. **Setting up a project?** Check [Projects/](Documentation/Projects/) for app and package guidelines
3. **Need architecture guidance?** See [Architecture/](Documentation/Architecture/)
4. **Code review?** Use [Quality/code-review.md](Documentation/Quality/code-review.md)

## Repository Structure

```
ARCAgentsDocs/
├── CLAUDE.md                     # Main entry point for AI agents
├── Documentation/
│   ├── Architecture/             # Architectural patterns and principles
│   │   ├── clean-architecture.md
│   │   ├── mvvm-c.md
│   │   ├── protocol-oriented.md
│   │   └── solid-principles.md
│   ├── Layers/                   # Implementation layer guidelines
│   │   ├── data.md
│   │   ├── domain.md
│   │   └── presentation.md
│   ├── Projects/                 # Project type guidelines
│   │   ├── apps.md
│   │   └── packages.md
│   ├── Quality/                  # Quality assurance standards
│   │   ├── code-review.md
│   │   ├── code-style.md
│   │   ├── documentation.md
│   │   └── testing.md
│   ├── Tools/                    # Development tools integration
│   │   ├── arcdevtools.md
│   │   ├── spm.md
│   │   └── xcode.md
│   └── Workflow/                 # Development workflow
│       ├── git-branches.md
│       ├── git-commits.md
│       └── plan-mode.md
├── CHANGELOG.md                  # Version history
├── LICENSE                       # MIT License
└── README.md                     # This file
```

## Documentation Index

### Architecture

| Document | Description |
|----------|-------------|
| [clean-architecture.md](Documentation/Architecture/clean-architecture.md) | Clean Architecture layers, dependency rules, and data flow |
| [mvvm-c.md](Documentation/Architecture/mvvm-c.md) | MVVM+Coordinator pattern with Router implementation |
| [solid-principles.md](Documentation/Architecture/solid-principles.md) | SOLID principles applied to Swift development |
| [protocol-oriented.md](Documentation/Architecture/protocol-oriented.md) | Protocol-oriented programming guidelines |

### Implementation Layers

| Document | Description |
|----------|-------------|
| [presentation.md](Documentation/Layers/presentation.md) | Views, ViewModels, and Routers/Coordinators |
| [domain.md](Documentation/Layers/domain.md) | Entities, Use Cases, and business logic |
| [data.md](Documentation/Layers/data.md) | Repositories, Data Sources, and persistence |

### Project Types

| Document | Description |
|----------|-------------|
| [apps.md](Documentation/Projects/apps.md) | iOS App development guidelines |
| [packages.md](Documentation/Projects/packages.md) | Swift Package development guidelines |

### Quality Assurance

| Document | Description |
|----------|-------------|
| [code-review.md](Documentation/Quality/code-review.md) | Code review checklist and AI-generated code standards |
| [code-style.md](Documentation/Quality/code-style.md) | SwiftLint, SwiftFormat, and naming conventions |
| [documentation.md](Documentation/Quality/documentation.md) | DocC, README standards, and inline comments |
| [testing.md](Documentation/Quality/testing.md) | Swift Testing framework and coverage requirements |

### Tools & Integration

| Document | Description |
|----------|-------------|
| [arcdevtools.md](Documentation/Tools/arcdevtools.md) | ARCDevTools package setup and usage |
| [spm.md](Documentation/Tools/spm.md) | Swift Package Manager best practices |
| [xcode.md](Documentation/Tools/xcode.md) | Xcode project configuration and schemes |

### Workflow

| Document | Description |
|----------|-------------|
| [git-branches.md](Documentation/Workflow/git-branches.md) | Branch naming conventions and Git flow |
| [git-commits.md](Documentation/Workflow/git-commits.md) | Conventional Commits specification |
| [plan-mode.md](Documentation/Workflow/plan-mode.md) | When and how AI agents enter Plan Mode |

## Integration as Git Submodule

This repository is designed to be included as a Git submodule in all ARC Labs projects.

### Adding to a Project

```bash
# Add as submodule
git submodule add git@github.com:ARCLabsStudio/ARCAgentsDocs.git ARCAgentsDocs

# Initialize (for cloning existing projects)
git submodule update --init --recursive
```

### Updating Documentation

```bash
# Update to latest version
cd ARCAgentsDocs
git pull origin main
cd ..
git add ARCAgentsDocs
git commit -m "chore: update ARCAgentsDocs"
```

### Claude Code Configuration

With `CLAUDE.md` at the repository root, Claude Code will automatically detect and use it as context when the submodule is initialized.

For explicit configuration, you can symlink or reference the file in your project's `.claude/` directory:

```bash
# Option 1: Symlink (recommended)
ln -s ARCAgentsDocs/CLAUDE.md .claude/CLAUDE.md

# Option 2: Reference in project CLAUDE.md
echo "See ARCAgentsDocs/CLAUDE.md for ARC Labs guidelines" >> .claude/CLAUDE.md
```

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

## Target Platforms

- **iOS 17.0+**
- **macOS 14.0+** (where applicable)
- **Swift 6.0+**
- **Xcode 16.0+**

## Contributing

When updating documentation:

1. Create a branch following [git-branches.md](Documentation/Workflow/git-branches.md) conventions
2. Make changes following the existing document structure
3. Update [CHANGELOG.md](CHANGELOG.md) with your changes
4. Create a PR with clear description

### Documentation Style

- Use clear, concise language
- Include code examples where helpful
- Follow existing formatting patterns
- Keep documents focused on single topics

## License

This documentation is proprietary to ARC Labs Studio. See [LICENSE](LICENSE) for details.

---

**Maintained by:** ARC Labs Studio
**Last Updated:** December 2024
**Version:** See [CHANGELOG.md](CHANGELOG.md)
