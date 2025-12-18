# 🔧 ARCDevTools Integration

## Overview

**ARCDevTools** is ARC Labs' centralized quality automation package. It provides standardized tooling for code quality, project setup, and development workflows across all iOS projects and packages. By consolidating linting, formatting, and automation scripts, ARCDevTools ensures consistency and reduces configuration drift.

---

## What is ARCDevTools?

ARCDevTools is a Swift package that bundles:
- **SwiftLint** configuration and rules
- **SwiftFormat** configuration and rules
- **Pre-commit hooks** for automated quality checks
- **Project setup scripts** for new projects
- **CI/CD templates** for GitHub Actions
- **Utility scripts** for common tasks

**Repository**: `https://github.com/arclabs/ARCDevTools`

---

## Installation

### Adding to a Project

#### Swift Package Manager
```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/arclabs/ARCDevTools", from: "1.0.0")
]
```

#### Xcode Project

1. File → Add Package Dependencies
2. Enter: `https://github.com/arclabs/ARCDevTools`
3. Select version: `1.0.0` or later
4. Add to target: **None** (development-only tools)

**Note**: ARCDevTools is not linked to app targets—it only provides development tools.

---

## Core Components

### 1. SwiftLint Configuration

ARCDevTools includes a comprehensive `.swiftlint.yml` that enforces ARC Labs' code style:
```yaml
# Included in ARCDevTools/Resources/.swiftlint.yml

disabled_rules:
  - trailing_whitespace  # Handled by SwiftFormat
  - multiple_closures_with_trailing_closure  # Allow for clarity

opt_in_rules:
  - empty_count
  - explicit_init
  - first_where
  - sorted_first_last
  - contains_over_first_not_nil
  - explicit_self
  - explicit_type_interface
  - file_header
  - missing_docs

included:
  - Sources
  - Tests

excluded:
  - .build
  - .swiftpm
  - DerivedData
  - Packages

line_length:
  warning: 120
  error: 150

type_body_length:
  warning: 300
  error: 400

file_length:
  warning: 500
  error: 800

function_body_length:
  warning: 40
  error: 60

identifier_name:
  min_length:
    warning: 3
  excluded:
    - id
    - x
    - y
    - z

type_name:
  min_length: 3
  max_length: 40

custom_rules:
  no_empty_line_after_guard:
    name: "No Empty Line After Guard"
    regex: 'guard\s+.+\{\s*\n\s*\n'
    message: "Remove empty line after guard statement"
    severity: warning
```

### 2. SwiftFormat Configuration

ARCDevTools provides a `.swiftformat` file with ARC Labs' formatting rules:
```
# Included in ARCDevTools/configs/swiftformat

# Indentation
--indent 4
--tabwidth 4
--xcodeindentation enabled

# Line width
--maxwidth 120

# Brace style
--allman false
--wraparguments before-first
--wrapparameters before-first
--wrapcollections before-first
--closingparen balanced

# Imports
--importgrouping testable-bottom
--stripunusedargs always

# Spacing
--trimwhitespace always
--commas never
--semicolons inline
--linebreaks lf

# Self
--self remove

# Wrapping
--wrapternary before-operators

# Attributes - Always on same line (ARC Labs style)
--type-attributes same-line
--func-attributes same-line
--stored-var-attributes same-line
--computed-var-attributes same-line
--complex-attributes same-line

# Organization
--organizetypes actor,class,enum,struct
--structthreshold 0
--classthreshold 0
--enumthreshold 0

# Swift 6 specific
--marktypes always
--extensionacl on-declarations

# Exclude
--exclude .build,DerivedData,Pods,Carthage,Generated
```

### 3. Pre-Commit Hooks

ARCDevTools includes Git hooks for automated quality checks:
```bash
#!/bin/bash
# ARCDevTools/Scripts/pre-commit

echo "🔍 Running pre-commit checks..."

# 1. SwiftLint
echo "  → SwiftLint..."
if which swiftlint >/dev/null; then
    swiftlint lint --strict --quiet
    if [ $? -ne 0 ]; then
        echo "❌ SwiftLint failed"
        exit 1
    fi
else
    echo "⚠️  SwiftLint not installed"
fi

# 2. SwiftFormat
echo "  → SwiftFormat..."
if which swiftformat >/dev/null; then
    swiftformat --lint . --quiet
    if [ $? -ne 0 ]; then
        echo "❌ SwiftFormat failed"
        echo "💡 Run 'swiftformat .' to fix"
        exit 1
    fi
else
    echo "⚠️  SwiftFormat not installed"
fi

# 3. Build Check
echo "  → Build Check..."
swift build > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Pre-commit checks passed"
```

### 4. Project Setup Scripts

ARCDevTools provides scripts for setting up new projects:
```bash
#!/bin/bash
# ARCDevTools/Scripts/setup-project.sh

echo "🚀 Setting up ARC Labs project..."

# 1. Install SwiftLint
if ! which swiftlint >/dev/null; then
    echo "📦 Installing SwiftLint..."
    brew install swiftlint
fi

# 2. Install SwiftFormat
if ! which swiftformat >/dev/null; then
    echo "📦 Installing SwiftFormat..."
    brew install swiftformat
fi

# 3. Copy configuration files
echo "📋 Copying configuration files..."
cp ARCDevTools/Resources/.swiftlint.yml .swiftlint.yml
cp ARCDevTools/Resources/.swiftformat .swiftformat

# 4. Install Git hooks
echo "🪝 Installing Git hooks..."
mkdir -p .git/hooks
cp ARCDevTools/Scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# 5. Create directory structure
echo "📁 Creating directory structure..."
mkdir -p Sources/Presentation/Features
mkdir -p Sources/Domain/Entities
mkdir -p Sources/Domain/UseCases
mkdir -p Sources/Data/Repositories
mkdir -p Tests

echo "✅ Project setup complete!"
echo ""
echo "Next steps:"
echo "  1. Review .swiftlint.yml and .swiftformat"
echo "  2. Run 'swiftformat .' to format existing code"
echo "  3. Run 'swiftlint autocorrect' to fix violations"
echo "  4. Commit changes"
```

---

## Usage

### Running Quality Checks

#### SwiftLint
```bash
# Lint entire project
swiftlint lint

# Lint with strict mode (warnings as errors)
swiftlint lint --strict

# Auto-correct violations
swiftlint autocorrect

# Lint specific files
swiftlint lint --path Sources/MyFile.swift

# Generate HTML report
swiftlint lint --reporter html > swiftlint-report.html
```

#### SwiftFormat
```bash
# Format entire project
swiftformat .

# Check formatting without changes
swiftformat --lint .

# Format specific files
swiftformat Sources/MyFile.swift

# Dry run (preview changes)
swiftformat --dryrun .

# Format with verbose output
swiftformat --verbose .
```

### Setting Up a New Project
```bash
# 1. Add ARCDevTools package
# (via SPM or Xcode)

# 2. Run setup script
swift run arcdevtools-setup

# Or manually:
# 3. Copy configurations
cp .build/checkouts/ARCDevTools/Resources/.swiftlint.yml .
cp .build/checkouts/ARCDevTools/Resources/.swiftformat .

# 4. Install hooks
cp .build/checkouts/ARCDevTools/Scripts/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit

# 5. Initial format
swiftformat .
swiftlint autocorrect

# 6. Commit
git add .
git commit -m "chore: setup ARCDevTools"
```

### Setting Up an Existing Project
```bash
# 1. Add ARCDevTools package

# 2. Copy configurations
cp .build/checkouts/ARCDevTools/Resources/.swiftlint.yml .
cp .build/checkouts/ARCDevTools/Resources/.swiftformat .

# 3. Format existing code
swiftformat .

# 4. Review and fix SwiftLint violations
swiftlint lint
swiftlint autocorrect

# 5. Install hooks
cp .build/checkouts/ARCDevTools/Scripts/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit

# 6. Commit changes
git add .
git commit -m "chore: integrate ARCDevTools"
```

---

## Xcode Integration

### Build Phases

Add quality checks to Xcode build process:

#### SwiftLint Build Phase

1. Target → Build Phases → + → New Run Script Phase
2. Name: "SwiftLint"
3. Script:
```bash
if which swiftlint >/dev/null; then
    swiftlint lint --strict
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
```

4. Move before "Compile Sources"

#### SwiftFormat Build Phase (Optional)

1. Target → Build Phases → + → New Run Script Phase
2. Name: "SwiftFormat"
3. Script:
```bash
if which swiftformat >/dev/null; then
    swiftformat --lint .
else
    echo "warning: SwiftFormat not installed"
fi
```

4. **Warning**: This only checks formatting. Run `swiftformat .` manually to format.

### Xcode Scheme

Add pre-actions to run quality checks:

1. Product → Scheme → Edit Scheme
2. Build → Pre-actions → + → New Run Script Action
3. Provide build settings from: [Your Target]
4. Script:
```bash
# Run SwiftLint and SwiftFormat
swiftlint lint --strict --quiet
swiftformat --lint . --quiet
```

---

## CI/CD Integration

### GitHub Actions

ARCDevTools includes workflow templates:
```yaml
# .github/workflows/quality.yml
name: Code Quality

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  quality:
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Swift
        uses: swift-actions/setup-swift@v1
        with:
          swift-version: '6.0'
      
      - name: Install SwiftLint
        run: brew install swiftlint
      
      - name: Install SwiftFormat
        run: brew install swiftformat
      
      - name: SwiftLint
        run: swiftlint lint --strict
      
      - name: SwiftFormat Check
        run: swiftformat --lint .
      
      - name: Build
        run: swift build -v
      
      - name: Test
        run: swift test -v
```

### Fastlane Integration
```ruby
# Fastfile
lane :quality do
  # Run SwiftLint
  swiftlint(
    mode: :lint,
    strict: true,
    quiet: true
  )
  
  # Check SwiftFormat
  sh("swiftformat --lint .")
  
  # Build
  sh("swift build")
end

lane :format do
  # Format code
  sh("swiftformat .")
  
  # Auto-correct SwiftLint
  swiftlint(
    mode: :autocorrect
  )
end
```

---

## Customization

### Project-Specific Rules

Override ARCDevTools defaults when needed:
```yaml
# .swiftlint.yml (project root)

# Import base configuration
parent_config: .build/checkouts/ARCDevTools/Resources/.swiftlint.yml

# Project-specific overrides
line_length:
  warning: 140  # Longer lines for this project

disabled_rules:
  - explicit_self  # Don't require explicit self

custom_rules:
  project_specific_rule:
    name: "Custom Rule"
    regex: 'pattern'
    message: "Custom message"
```

### Disabling Rules Locally

When necessary, disable rules inline:
```swift
// swiftlint:disable line_length
let veryLongString = "This is an exceptionally long string that exceeds the line length limit but is necessary for this specific case"
// swiftlint:enable line_length

// Disable for entire file
// swiftlint:disable:this file_length

// Disable specific rule for next line
// swiftlint:disable:next force_cast
let value = object as! MyType
```

**Use Sparingly**: Inline disables should be rare and well-justified.

---

## Best Practices

### Do ✅

- Run `swiftformat .` before committing
- Fix SwiftLint violations immediately
- Use pre-commit hooks
- Keep configurations up to date
- Document any rule overrides
- Run quality checks in CI/CD
- Review quality reports regularly

### Don't ❌

- Commit code with violations
- Disable rules without justification
- Ignore quality check failures
- Skip pre-commit hooks
- Modify ARCDevTools directly (fork if needed)
- Use inline disables excessively
- Ignore SwiftFormat suggestions

---

## Troubleshooting

### SwiftLint Not Found
```bash
# Install via Homebrew
brew install swiftlint

# Or via Mint
mint install realm/SwiftLint

# Verify installation
which swiftlint
swiftlint version
```

### SwiftFormat Not Found
```bash
# Install via Homebrew
brew install swiftformat

# Verify installation
which swiftformat
swiftformat --version
```

### Pre-Commit Hook Not Running
```bash
# Make hook executable
chmod +x .git/hooks/pre-commit

# Test manually
.git/hooks/pre-commit

# Check Git config
git config --get core.hooksPath
```

### Configuration Not Found
```bash
# Copy from ARCDevTools
cp .build/checkouts/ARCDevTools/Resources/.swiftlint.yml .
cp .build/checkouts/ARCDevTools/Resources/.swiftformat .

# Or download directly
curl -o .swiftlint.yml https://raw.githubusercontent.com/arclabs/ARCDevTools/main/Resources/.swiftlint.yml
curl -o .swiftformat https://raw.githubusercontent.com/arclabs/ARCDevTools/main/Resources/.swiftformat
```

### Build Phase Errors
```bash
# Xcode can't find tools
# Add to Build Phase script:

export PATH="$PATH:/opt/homebrew/bin"

if which swiftlint >/dev/null; then
    swiftlint lint --strict
fi
```

---

## Migration Guide

### From No Tooling
```bash
# 1. Add ARCDevTools package
# 2. Setup project
swift run arcdevtools-setup

# 3. Format existing code
swiftformat .

# 4. Fix violations
swiftlint autocorrect

# 5. Review remaining violations
swiftlint lint

# 6. Fix manually or disable with justification

# 7. Commit
git add .
git commit -m "chore: integrate ARCDevTools"
```

### From Custom Configuration
```bash
# 1. Backup existing configs
cp .swiftlint.yml .swiftlint.yml.backup
cp .swiftformat .swiftformat.backup

# 2. Add ARCDevTools package

# 3. Copy new configs
cp .build/checkouts/ARCDevTools/Resources/.swiftlint.yml .
cp .build/checkouts/ARCDevTools/Resources/.swiftformat .

# 4. Migrate custom rules
# Add project-specific overrides to .swiftlint.yml

# 5. Test
swiftformat .
swiftlint lint

# 6. Adjust as needed

# 7. Commit
git add .
git commit -m "chore: migrate to ARCDevTools"
```

---

## Advanced Usage

### Custom Scripts

Create project-specific scripts using ARCDevTools:
```bash
#!/bin/bash
# scripts/quality-check.sh

echo "🔍 Running comprehensive quality checks..."

# 1. SwiftLint
swiftlint lint --strict

# 2. SwiftFormat
swiftformat --lint .

# 3. Build
swift build

# 4. Tests
swift test

# 5. Coverage
swift test --enable-code-coverage

echo "✅ All checks passed!"
```

### Pre-Push Hook

Prevent pushing broken code:
```bash
#!/bin/bash
# .git/hooks/pre-push

echo "🚀 Running pre-push checks..."

# Run full quality suite
./scripts/quality-check.sh

if [ $? -ne 0 ]; then
    echo "❌ Pre-push checks failed"
    echo "Fix issues before pushing"
    exit 1
fi

echo "✅ Ready to push"
```

---

## Package Structure
```
ARCDevTools/
├── Package.swift
├── README.md
├── Sources/
│   └── ARCDevTools/
│       └── ARCDevTools.swift
├── Resources/
│   ├── .swiftlint.yml
│   ├── .swiftformat
│   └── .gitignore
├── Scripts/
│   ├── pre-commit
│   ├── pre-push
│   ├── setup-project.sh
│   └── quality-check.sh
└── Templates/
    ├── GitHub/
    │   └── workflows/
    │       ├── quality.yml
    │       └── tests.yml
    └── Fastlane/
        └── Fastfile
```

---

## Resources

- [SwiftLint Documentation](https://realm.github.io/SwiftLint/)
- [SwiftFormat Documentation](https://github.com/nicklockwood/SwiftFormat)
- [Git Hooks Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [Swift Package Manager](https://swift.org/package-manager/)

---

## Summary

ARCDevTools is the cornerstone of code quality at ARC Labs. By centralizing linting, formatting, and automation scripts, it ensures consistency across all projects while reducing configuration overhead. Every project should integrate ARCDevTools from day one, enabling automated quality checks that maintain our high standards without manual intervention. Quality is not optional—it's automated.