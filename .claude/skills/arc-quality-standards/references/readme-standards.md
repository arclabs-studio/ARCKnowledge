# 📄 README Standards

**Standardized README format for all ARC Labs Studio projects**

---

## 🎯 Overview

Every ARC Labs project (packages and apps) **MUST** include a comprehensive, well-formatted README that follows the visual template defined in this document. A great README is the first impression of your project and serves as the primary documentation entry point.

### Why README Standards Matter

1. **Consistency** - Uniform presentation across all ARC Labs projects
2. **Professionalism** - Enterprise-level quality for indie development
3. **Discoverability** - Easy navigation and understanding for developers and AI agents
4. **Visual Appeal** - Emojis and formatting make documentation engaging and scannable

---

## 📐 Standard README Template

All ARC Labs projects that include ARCKnowledge as a git submodule should follow this template:

```markdown
# [Emoji] ProjectName

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)

**One-line description of what the project does**

Key feature 1 • Key feature 2 • Key feature 3 • Key feature 4

---

## 🎯 Overview

[2-3 paragraphs describing the project, its purpose, and its main goals]

### Key Features

- ✅ **Feature Name** - Feature description
- ✅ **Feature Name** - Feature description
- ✅ **Feature Name** - Feature description
- ✅ **Feature Name** - Feature description

---

## 📋 Requirements

- **Swift:** 6.0+
- **Platforms:** iOS 17.0+ / macOS 14.0+ / watchOS 10.0+ / tvOS 17.0+
- **Xcode:** 16.0+
- **Tools:** [Any required tools like SwiftLint, SwiftFormat, etc.]

---

## 🚀 Installation

### Swift Package Manager

#### For Swift Packages

\`\`\`swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ProjectName", from: "1.0.0")
]
\`\`\`

#### For Xcode Projects

1. **File → Add Package Dependencies**
2. Enter: `https://github.com/arclabs-studio/ProjectName`
3. Select version: `1.0.0` or later
4. **Add to target** [if applicable]

### Additional Setup

[Any additional setup steps like installing tools, configuring API keys, etc.]

---

## 📖 Usage

### Quick Start

\`\`\`swift
import ProjectName

// Basic usage example
// Show the most common use case first
\`\`\`

### [Feature 1 Name]

\`\`\`swift
// Example demonstrating feature 1
\`\`\`

### [Feature 2 Name]

\`\`\`swift
// Example demonstrating feature 2
\`\`\`

### Advanced Usage

\`\`\`swift
// More complex examples for advanced scenarios
\`\`\`

---

## 🏗️ Project Structure

[For packages, show the file/folder structure]

\`\`\`
ProjectName/
├── Sources/
│   └── ProjectName/
│       ├── Core/
│       ├── Models/
│       └── Utilities/
├── Tests/
│   └── ProjectNameTests/
└── Documentation/
\`\`\`

[For apps, describe the architecture and main modules]

---

## 🧪 Testing

[Description of testing approach and how to run tests]

\`\`\`bash
swift test
\`\`\`

### Coverage

- **Packages:** Target 100%, minimum 80%
- **Apps:** Target 80%+

---

## 📐 Architecture

[Brief description of architectural patterns used]

- **Pattern:** MVVM+C with Clean Architecture
- **Layers:** Presentation, Domain, Data
- **Dependencies:** Protocol-based dependency injection

For complete architecture guidelines, see [ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge).

---

## 🛠️ Development

### Prerequisites

\`\`\`bash
# Install required tools
brew install swiftlint swiftformat
\`\`\`

### Setup

\`\`\`bash
# Clone the repository
git clone https://github.com/arclabs-studio/ProjectName.git
cd ProjectName

# Run setup (if using ARCDevTools)
swift run arcdevtools-setup

# Build the project
swift build
\`\`\`

### Available Commands

\`\`\`bash
make help          # Show all available commands
make lint          # Run SwiftLint
make format        # Preview formatting changes
make fix           # Apply SwiftFormat
make test          # Run tests
make clean         # Remove build artifacts
\`\`\`

---

## 🤝 Contributing

[For public projects]

We welcome contributions! Please read our contributing guidelines:

1. Fork the repository
2. Create a feature branch: `feature/your-feature`
3. Follow [ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge) standards
4. Ensure tests pass: `swift test`
5. Run quality checks: `make lint && make format`
6. Create a pull request

[For private/internal projects]

This is an internal project for ARC Labs Studio. Team members:

1. Create a feature branch: `feature/ARC-123-description`
2. Follow [ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge) standards
3. Ensure tests pass: `swift test`
4. Run quality checks: `make lint && make format`
5. Create a pull request to `develop`

### Commit Messages

Follow [Conventional Commits](https://github.com/arclabs-studio/ARCKnowledge/blob/main/Documentation/Workflow/git-commits.md):

\`\`\`
feat(ARC-123): add new authentication feature
fix(ARC-456): resolve crash on logout
docs: update installation instructions
\`\`\`

---

## 📦 Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** - Breaking changes
- **MINOR** - New features (backwards compatible)
- **PATCH** - Bug fixes (backwards compatible)

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## 📄 License

[MIT/Proprietary] License © 2025 ARC Labs Studio

See [LICENSE](LICENSE) for details.

---

## 🔗 Related Resources

- **[ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge)** - Development standards and guidelines
- **[ARCDevTools](https://github.com/arclabs-studio/ARCDevTools)** - Quality tooling and automation
- [Any other related ARC Labs packages or resources]

---

<div align="center">

Made with 💛 by ARC Labs Studio

[**Website**](https://arclabs.studio) • [**GitHub**](https://github.com/ARCLabsStudio) • [**Issues**](https://github.com/arclabs-studio/ProjectName/issues)

</div>
```

---

## 📝 Template Sections Explained

### Header Section

**Required Elements:**

1. **Project Name with Emoji** - Choose an emoji that represents the project
   - 📦 Packages (general)
   - 📱 iOS Apps
   - 🛠️ Development Tools
   - 🔍 Logging/Analytics
   - 🗺️ Maps/Location
   - 🎨 UI/Design
   - 🔐 Security/Auth
   - 💾 Storage/Persistence

2. **Badges** - Always include:
   - Swift version (orange)
   - Platforms (blue)
   - License (green for MIT, yellow for proprietary)
   - Version (blue) - for packages

3. **One-line Description** - Bold, concise summary

4. **Feature Highlights** - 3-5 key features separated by bullets (•)

### Overview Section

**Required Elements:**

1. **Main Description** - 2-3 paragraphs explaining:
   - What the project does
   - Why it exists
   - Who it's for

2. **Key Features** - Bulleted list with:
   - ✅ Checkmark for each feature
   - **Bold feature name**
   - Brief description

### Requirements Section

**Required Elements:**

- Swift version
- Platform minimum versions
- Xcode minimum version
- Any external tools or dependencies

### Installation Section

**Required Elements:**

1. **Swift Package Manager** (primary installation method)
   - Code snippet for Package.swift
   - Xcode UI instructions

2. **Additional Setup** (if needed)
   - Environment variables
   - API keys
   - Tool installation

### Usage Section

**Required Elements:**

1. **Quick Start** - Most common use case first
2. **Feature Examples** - One example per major feature
3. **Advanced Usage** - Complex scenarios (optional)

### Architecture Section

**For Packages:**
- Brief architecture overview
- Link to ARCKnowledge for details

**For Apps:**
- MVVM+C with Clean Architecture
- Layer descriptions
- Link to ARCKnowledge for complete guidelines

### Development Section

**Required Elements:**

1. **Prerequisites** - Tools to install
2. **Setup Instructions** - Clone, build, run
3. **Available Commands** - Make commands or scripts

### Contributing Section

**Required Elements:**

1. **Contribution Process** - Steps to contribute
2. **Standards Reference** - Link to ARCKnowledge
3. **Commit Message Format** - Conventional Commits

### Footer Section

**Required Elements:**

1. **Version Information** - Link to CHANGELOG
2. **License** - Type and link to LICENSE file
3. **Related Resources** - Links to ARCKnowledge, ARCDevTools, etc.
4. **Centered Footer** - "Made with 💛 by ARC Labs Studio" + links

---

## 🎨 Emoji Usage Guidelines

### Recommended Emojis by Section

| Section | Recommended Emoji | Alternatives |
|---------|------------------|--------------|
| Overview | 🎯 | 📖, 💡 |
| Requirements | 📋 | ⚙️, 🔧 |
| Installation | 🚀 | 📦, ⬇️ |
| Usage | 📖 | 💻, 🛠️ |
| Structure | 🏗️ | 📁, 🗂️ |
| Testing | 🧪 | ✅, 🔍 |
| Architecture | 📐 | 🏛️, 🎨 |
| Development | 🛠️ | ⚙️, 🔨 |
| Contributing | 🤝 | 👥, 💪 |
| Versioning | 📦 | 🔢, 🏷️ |
| License | 📄 | ⚖️, 📜 |
| Related | 🔗 | 🌐, 📚 |

### Project-Type Emojis

| Project Type | Emoji |
|-------------|-------|
| Documentation Package | 📚 |
| UI Components | 🎨 |
| Development Tools | 🛠️ |
| Logging/Analytics | 🔍 |
| Maps/Location | 🗺️ |
| Networking | 🌐 |
| Storage/Persistence | 💾 |
| Navigation/Routing | 🧭 |
| Authentication | 🔐 |
| Design System | 🎨 |
| iOS App (general) | 📱 |
| Restaurant App | 🍽️ |
| Book App | 📚 |
| Finance App | 💰 |

---

## ✅ README Quality Checklist

Before considering a README complete, verify:

### Content
- [ ] Project name with appropriate emoji
- [ ] All required badges present
- [ ] One-line description is clear and concise
- [ ] Overview explains what, why, and who
- [ ] Key features listed with checkmarks
- [ ] Installation instructions complete and tested
- [ ] Usage examples cover common scenarios
- [ ] Architecture section present

### Formatting
- [ ] Proper markdown syntax throughout
- [ ] Code blocks have language specified (swift, bash, etc.)
- [ ] Horizontal rules (---) separate major sections
- [ ] Consistent emoji usage
- [ ] Tables formatted correctly
- [ ] Links work and point to correct locations

### Standards
- [ ] Follows template structure
- [ ] Links to ARCKnowledge for detailed standards
- [ ] Includes contribution guidelines
- [ ] References Conventional Commits
- [ ] Includes version and license information
- [ ] Footer properly formatted and centered

### Project-Specific
- [ ] Tailored to package vs. app appropriately
- [ ] Examples are relevant and helpful
- [ ] All custom setup steps documented
- [ ] Related ARC Labs resources linked

---

## 📚 Examples

### Package README Example

See [ARCDevTools README](https://github.com/arclabs-studio/ARCDevTools) for a complete example of a package README following these standards.

### App README Example

See [FavRes README](https://github.com/arclabs-studio/FavRes) for a complete example of an app README following these standards.

---

## 🔄 Updating READMEs

### When to Update

Update the README when:

1. **New Features** - Add to Key Features and Usage sections
2. **Breaking Changes** - Update installation, usage, and version info
3. **New Dependencies** - Update requirements and installation
4. **Architecture Changes** - Update architecture section
5. **New Tools** - Update development section

### Maintenance Schedule

- **Monthly** - Review for accuracy and completeness
- **Per Release** - Update version badges and CHANGELOG link
- **Per Major Change** - Update relevant sections immediately

---

## 🚨 Common Mistakes

### Mistake 1: Missing Emojis

```markdown
❌ WRONG:
## Overview
Project description here

✅ RIGHT:
## 🎯 Overview
Project description here
```

### Mistake 2: Incomplete Badges

```markdown
❌ WRONG:
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)

✅ RIGHT:
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)
```

### Mistake 3: No Visual Hierarchy

```markdown
❌ WRONG:
This project does X, Y, and Z. It's built with Swift 6.

✅ RIGHT:
**One-line description of what the project does**

Feature X • Feature Y • Feature Z

---

## 🎯 Overview

[Detailed explanation with visual structure]
```

### Mistake 4: Missing Links to ARCKnowledge

```markdown
❌ WRONG:
Follow our coding standards and best practices.

✅ RIGHT:
Follow [ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge)
for complete coding standards and best practices.
```

---

## 📖 Further Reading

- [Markdown Guide](https://www.markdownguide.org/)
- [Shields.io Badge Generator](https://shields.io/)
- [GitHub Emoji Cheat Sheet](https://github.com/ikatyang/emoji-cheat-sheet)
- [ARCKnowledge](https://github.com/arclabs-studio/ARCKnowledge)

---

**Remember**: Your README is often the first impression of your project. Make it count with clear structure, visual appeal, and comprehensive information. 📄
