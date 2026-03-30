# Agent Tools & Skills

> Reference document for AI agents working on ARC Labs Studio iOS/macOS projects.
> Lists available skills, MCPs, and Claude Code plugins — what they do and when to use them.

---

## Community Skills

Installed at `~/.agents/skills/` (symlinked from iCloud — available on all studio machines).

### iOS / SwiftUI

| Skill | When to use |
|---|---|
| `swiftui-expert-skill` | Deep SwiftUI review, modern API adoption, best practices |
| `swift-concurrency` | async/await, actors, Sendable errors, Swift 6 migration |
| `swiftui-liquid-glass` | iOS/macOS 26 Liquid Glass API adoption |
| `swiftui-performance-audit` | Performance issues, slow renders, unnecessary re-renders |
| `swiftui-view-refactor` | View files getting too large, inconsistent code across repo |
| `swiftui-ui-patterns` | @Observable, @Environment architecture patterns as app grows |
| `swiftui-pro` | Broad SwiftUI review — modern APIs, maintainability, accessibility |
| `swiftdata-pro` | SwiftData modeling, migrations, relationships |
| `swift-testing-expert` | Swift Testing framework, #expect/#require, parameterized tests |

### Xcode Build Optimization

Six-skill suite by [@AvdLee](https://github.com/AvdLee/Xcode-Build-Optimization-Agent-Skill) for benchmarking and optimizing Xcode build times. Runs 40+ checks across build settings, script phases, compiler flags, and SPM overhead.

**Workflow:** Analyze first → review plan → approve changes → verify improvement. Nothing modified without explicit approval.

| Skill | Role |
|---|---|
| `xcode-build-orchestrator` | **Start here** — coordinates the full pipeline, produces `optimization-plan.md` |
| `xcode-build-benchmark` | Measures clean + incremental build times |
| `xcode-compilation-analyzer` | Finds compile hotspots in source files |
| `xcode-project-analyzer` | Audits build settings against best practices |
| `spm-build-analysis` | Finds SPM overhead and package inefficiencies |
| `xcode-build-fixer` | Applies approved changes from the plan |

**Usage:**
```
Use the /xcode-build-orchestrator skill to analyze build performance
and come up with a plan for improvements.
```

> **Note:** ARC Labs arc-* skills take precedence for studio standards. Use community skills as complementary reference when arc-* doesn't cover the specific area.

---

## MCPs (Model Context Protocol)

Configured in `~/.claude/mcp_settings.json`. Available in Claude Code sessions.

| MCP | What it does |
|---|---|
| **XcodeBuildMCP** v2.3.1 | Build Xcode projects, control simulators, capture screenshots, read logs — all from the terminal without opening Xcode GUI |
| **ARC Linear GitHub MCP** | Integrated Linear issue management + GitHub operations for ARC Labs repos |
| **Firebase MCP** | Firebase project access — Firestore, Auth, Functions from the agent |

### XcodeBuildMCP — key capabilities
- `xcodebuild` scheme/target listing
- Build, test, archive, build-for-testing actions
- Simulator launch and control
- Screenshot capture
- Runtime logs and crash reports
- Keeps the agent in a CLI-first loop without bouncing into Xcode GUI

---

## Claude Code Plugins

Enabled in `~/.claude/settings.json`.

| Plugin | What it does |
|---|---|
| **swift-lsp** (`swift-lsp@claude-plugins-official`) | Swift Language Server Protocol — real-time compiler diagnostics, autocompletion context, type info |
| **axiom** (`axiom@axiom-marketplace`) | Observability and analytics integration |
| **slack** (`slack@claude-plugins-official`) | Slack workspace integration for notifications and communication |

---

## Skill Load Order (precedence)

When the same skill name exists in multiple locations, Claude Code applies this order:

```
Project .claude/skills/   (highest — arc-* skills per project)
    ↓
~/.agents/skills/          (global community skills)
    ↓
~/.claude/skills/          (not currently used)
    ↓
Bundled / plugin skills    (lowest)
```

---

## Adding New Skills

To add a new community skill available on all studio machines:

1. Install to iCloud: `clawhub install <skill-name> --workdir ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/ARCLabsStudio/Develop/Skills/<category>/`
2. Create symlink: `ln -s "<icloud-path>/<skill>" ~/.agents/skills/<skill>`
3. Update this document

Skills are organized in iCloud under:
```
ARCLabsStudio/Develop/Skills/
├── ios/          ← Swift/SwiftUI community skills
├── marketing/    ← Marketing, content, SEO skills
├── app-store/    ← ASO, App Store optimization
└── tools/        ← Utility skills (firecrawl, larry, etc.)
```

---

*Last updated: 2026-03-28 — ARC Labs Studio*
