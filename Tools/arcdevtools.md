# 🔧 ARCDevTools Integration

## Overview

**ARCDevTools** is ARC Labs Studio's centralized configuration repository that provides standardized tooling for all projects. It ensures consistent code quality, automated checks, and streamlined CI/CD across all packages and apps.

**Repository**: `https://github.com/arclabs-studio/ARCDevTools`

### What ARCDevTools Provides

- **SwiftLint configuration** - Linting rules optimized for Swift 6 and ARC Labs standards
- **SwiftFormat configuration** - Code formatting rules for consistency
- **Git hooks** - Automated pre-commit and pre-push quality checks
- **GitHub Actions workflows** - CI/CD templates for testing, docs, and releases
- **Utility scripts** - Automation for common tasks
- **Makefile generation** - Convenient commands for daily development

---

## 📋 Requirements

| Requirement | Version | Notes |
|-------------|---------|-------|
| Swift | 6.0+ | Strict concurrency enabled |
| Platforms | macOS 13.0+ / iOS 17.0+ | |
| Xcode | 16.0+ | |
| Git | 2.30+ | Submodule support required |
| SwiftLint | Latest | `brew install swiftlint` |
| SwiftFormat | Latest | `brew install swiftformat` |

---

## 🚀 Installation

### 1. Install Required Tools

```bash
brew install swiftlint swiftformat
```

### 2. Add ARCDevTools as Submodule

Navigate to your project root and add ARCDevTools:

```bash
cd /path/to/your/project
git submodule add https://github.com/arclabs-studio/ARCDevTools
git submodule update --init --recursive
```

This creates an `ARCDevTools/` directory in your project with all configuration files and scripts.

### 3. Run Setup Script

```bash
./ARCDevTools/arcdevtools-setup
```

**Setup options:**
- `--with-workflows` - Include GitHub Actions workflows
- `--no-workflows` - Skip workflows
- No arguments - Interactive mode

The setup script will:
- Copy `.swiftlint.yml` to your project root
- Copy `.swiftformat` to your project root
- Install git hooks (pre-commit, pre-push)
- Generate `Makefile` with useful commands
- Optionally copy GitHub Actions workflows

### 4. Commit the Integration

```bash
git add .gitmodules ARCDevTools/ .swiftlint.yml .swiftformat Makefile
git commit -m "chore: integrate ARCDevTools for quality automation"
git push
```

---

## 📁 Project Structure

```
ARCDevTools/
├── arcdevtools-setup            # Main setup script (Swift executable)
├── configs/
│   ├── swiftlint.yml           # SwiftLint configuration
│   └── swiftformat             # SwiftFormat configuration
├── hooks/
│   ├── pre-commit              # Pre-commit hook
│   ├── pre-push                # Pre-push hook
│   └── install-hooks.sh        # Hook installer
├── scripts/
│   ├── lint.sh                 # Run SwiftLint
│   ├── format.sh               # Run SwiftFormat
│   ├── setup-github-labels.sh  # Configure GitHub labels
│   └── setup-branch-protection.sh # Configure branch protection
├── workflows/                   # GitHub Actions templates
│   ├── quality.yml
│   ├── tests.yml
│   ├── docs.yml
│   ├── enforce-gitflow.yml
│   ├── sync-develop.yml
│   ├── validate-release.yml
│   └── release-drafter.yml
├── templates/
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── release-drafter.yml
│   └── markdown-link-check-config.json
├── ARCKnowledge/               # Nested submodule (standards)
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## 📖 Usage

### Makefile Commands

After setup, use the generated Makefile:

```bash
make help      # Show all available commands
make lint      # Run SwiftLint
make format    # Check formatting (dry-run)
make fix       # Apply SwiftFormat
make setup     # Re-run ARCDevTools setup
make hooks     # Re-install git hooks only
make clean     # Clean build artifacts
```

### Manual Access

All resources are directly accessible in the `ARCDevTools/` directory:

```bash
# Configuration files
ARCDevTools/configs/swiftlint.yml
ARCDevTools/configs/swiftformat

# Git hooks
ARCDevTools/hooks/pre-commit
ARCDevTools/hooks/pre-push

# Utility scripts
ARCDevTools/scripts/lint.sh
ARCDevTools/scripts/format.sh

# GitHub Actions templates
ARCDevTools/workflows/*.yml
```

---

## 🪝 Git Hooks

ARCDevTools installs automatic quality checks via Git hooks.

### Pre-commit Hook

Runs automatically before each commit:

1. Detects staged Swift files
2. Runs SwiftFormat automatically (auto-fixes)
3. Re-stages formatted files
4. Runs SwiftLint in strict mode
5. **Blocks commit if errors exist**

### Pre-push Hook

Runs automatically before each push:

1. Executes `swift test --parallel`
2. **Blocks push if tests fail**
3. Bypass with `--no-verify` (not recommended)

---

## 🧹 SwiftLint Configuration

**File**: `configs/swiftlint.yml`

### Included Directories
- `Sources`
- `Tests`

### Excluded Directories
- `.build`, `DerivedData`, `Pods`, `Carthage`
- `ARCDevTools`, `*/Generated/*`

### Disabled Rules

| Rule | Reason |
|------|--------|
| `trailing_whitespace` | SwiftFormat handles this |
| `todo` | We allow TODOs in development |
| `sorted_imports` | Conflicts with @testable imports |
| `attributes` | SwiftFormat handles this |

### Limits

| Metric | Warning | Error |
|--------|---------|-------|
| Line length | 120 | 150 |
| Type body length | 300 | 500 |
| Function body length | 50 | 100 |
| File length | 500 | 1000 |
| Identifier name | min 2 | max 60 |
| Type name | min 3 | max 50 |

### Custom Rules (ARC Labs)

```yaml
# ViewModels must use @Observable
observable_viewmodel:
  regex: "final\\s+class\\s+\\w+ViewModel(?!.*@Observable)"
  message: "ViewModels must use @Observable in Swift 6"
  severity: warning

# No empty line after guard
no_empty_line_after_guard:
  regex: 'guard\s+.+\{\s*\n\s*\n'
  message: "Remove empty line after guard statement"
  severity: warning

# No force cast (as!)
no_force_cast:
  regex: 'as!'
  message: "Avoid force casting. Use conditional cast (as?) instead"
  severity: error

# No force try (try!)
no_force_try:
  regex: 'try!'
  message: "Avoid force try. Use proper error handling"
  severity: error
```

### Opt-in Rules Enabled (40+)

- `array_init`, `closure_spacing`, `empty_count`, `explicit_init`
- `force_unwrapping`, `implicit_return`, `first_where`, `last_where`
- `multiline_arguments`, `multiline_function_chains`, `multiline_parameters`
- `operator_usage_whitespace`, `overridden_super_call`
- `redundant_nil_coalescing`, `sorted_first_last`, `toggle_bool`
- `vertical_whitespace_closing_braces`, `vertical_whitespace_opening_braces`
- And more...

### Analyzer Rules

- `unused_import`
- `unused_declaration`

---

## 🎨 SwiftFormat Configuration

**File**: `configs/swiftformat`

### Core Settings

| Option | Value | Description |
|--------|-------|-------------|
| `--swiftversion` | 6.0 | Swift 6 support |
| `--indent` | 4 | 4-space indentation |
| `--maxwidth` | 120 | Maximum line width |
| `--allman` | false | K&R brace style |
| `--self` | remove | Omit self when not needed |
| `--linebreaks` | lf | Unix line endings |

### Wrapping

| Option | Value |
|--------|-------|
| `--wraparguments` | before-first |
| `--wrapparameters` | before-first |
| `--wrapcollections` | before-first |

### Imports

| Option | Value |
|--------|-------|
| `--organizeimports` | alphabetized |
| `--importgrouping` | testable-bottom |

### Attributes (ARC Labs Style)

| Option | Value | Example |
|--------|-------|---------|
| `--type-attributes` | prev-line | `@MainActor` on separate line |
| `--func-attributes` | prev-line | `@discardableResult` on separate line |
| `--stored-var-attributes` | same-line | `@Published var` on same line |
| `--computed-var-attributes` | same-line | |
| `--complex-attributes` | prev-line | Complex attributes on separate line |

### Exclusions

`.build`, `DerivedData`, `Pods`, `Carthage`, `Generated`

---

## 🔄 GitHub Actions Workflows

ARCDevTools provides workflow templates in `ARCDevTools/workflows/`:

| Workflow | Trigger | Description |
|----------|---------|-------------|
| `quality.yml` | push/PR | SwiftLint, SwiftFormat, Markdown link check |
| `tests.yml` | push/PR | Tests on macOS 15 and Linux (Swift 6.0) |
| `docs.yml` | push main | Generate and publish DocC documentation |
| `enforce-gitflow.yml` | PR | Validate Git Flow rules and conventional commits |
| `sync-develop.yml` | push main | Auto-sync main → develop |
| `validate-release.yml` | tag v*.* | Validate and create releases from tags |
| `release-drafter.yml` | push/PR main | Auto-draft release notes from PRs |

### Git Flow Validations (enforce-gitflow.yml)

- `feature/*` → can only target `develop`
- `hotfix/*` → can only target `main`
- Only `develop` or `hotfix/*` can target `main`
- Validates conventional commit format (warning)

### Installing Workflows

Copy workflows to your project:

```bash
# During setup (interactive)
./ARCDevTools/arcdevtools-setup

# Or manually
mkdir -p .github/workflows
cp ARCDevTools/workflows/*.yml .github/workflows/
```

---

## 🛠️ Utility Scripts

### setup-github-labels.sh

Configures 15 categorized labels in your GitHub repository:

```bash
./ARCDevTools/scripts/setup-github-labels.sh
```

**Requires**: `gh auth login` first

**Categories**: features, bugs, docs, enhancement, breaking, etc.

### setup-branch-protection.sh

Configures branch protection rules:

```bash
./ARCDevTools/scripts/setup-branch-protection.sh
```

**Rules applied:**
- `main`: 1 approval required, strict status checks, linear history
- `develop`: Non-strict status checks
- Disables force push and branch deletion

---

## 🔄 Updating ARCDevTools

To get the latest configurations and scripts:

```bash
cd ARCDevTools
git pull origin main
cd ..
./ARCDevTools/arcdevtools-setup  # Re-run setup to update configs
git add ARCDevTools
git commit -m "chore: update ARCDevTools to latest version"
```

---

## ⚙️ Customization

After setup, you can customize the copied configurations without affecting ARCDevTools:

### Project-Specific SwiftLint Rules

```yaml
# .swiftlint.yml (your project root)

# Inherit from base config
parent_config: .swiftlint.yml

# Project-specific overrides
disabled_rules:
  - line_length  # If needed for this project

custom_rules:
  my_project_rule:
    name: "My Project Rule"
    regex: "..."
    message: "Custom message"
    severity: warning
```

### Disabling Rules Inline

```swift
// Disable for next line
// swiftlint:disable:next force_cast
let value = object as! MyType

// Disable for section
// swiftlint:disable line_length
let veryLongString = "..."
// swiftlint:enable line_length

// Disable for file
// swiftlint:disable:this file_length
```

**Note**: Customizations are preserved when updating ARCDevTools.

---

## 🍎 Xcode Integration

### Build Phase (Optional)

Add SwiftLint as a build phase for real-time feedback:

1. Target → Build Phases → + → New Run Script Phase
2. Name: "SwiftLint"
3. Script:

```bash
if which swiftlint >/dev/null; then
    swiftlint lint --strict
else
    echo "warning: SwiftLint not installed"
fi
```

4. Move before "Compile Sources"

### PATH Configuration

If Xcode can't find tools:

```bash
# Add to Build Phase script
export PATH="$PATH:/opt/homebrew/bin"
```

---

## 🔍 Troubleshooting

### SwiftLint/SwiftFormat Not Found

```bash
# Verify installation
which swiftlint
which swiftformat

# Reinstall if needed
brew reinstall swiftlint swiftformat
```

### Pre-commit Hook Not Running

```bash
# Make hook executable
chmod +x .git/hooks/pre-commit

# Test manually
.git/hooks/pre-commit

# Reinstall hooks
./ARCDevTools/hooks/install-hooks.sh
```

### Submodule Not Initialized

```bash
# Initialize submodules
git submodule update --init --recursive

# If ARCDevTools directory is empty
git submodule sync
git submodule update --init --force
```

### Configuration Not Applied

```bash
# Re-run setup
./ARCDevTools/arcdevtools-setup

# Verify configs exist
ls -la .swiftlint.yml .swiftformat
```

---

## ✅ Best Practices

### Do

- Run `make lint` before committing
- Fix SwiftLint violations immediately
- Use pre-commit hooks (don't skip)
- Keep ARCDevTools updated
- Document any rule overrides with comments

### Don't

- Commit code with lint errors
- Use `--no-verify` to bypass hooks
- Modify files inside `ARCDevTools/` directly
- Disable rules without justification
- Ignore SwiftFormat suggestions

---

## 📚 Resources

- [SwiftLint Documentation](https://realm.github.io/SwiftLint/)
- [SwiftFormat Documentation](https://github.com/nicklockwood/SwiftFormat)
- [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [ARCDevTools Repository](https://github.com/arclabs-studio/ARCDevTools)

---

## Summary

ARCDevTools is the cornerstone of code quality at ARC Labs Studio. By centralizing linting, formatting, and automation as a Git submodule, it ensures consistency across all projects while allowing easy updates and customization. Every project should integrate ARCDevTools from day one, enabling automated quality checks that maintain our high standards without manual intervention.

**Quality is not optional—it's automated.**
