# ARC Labs Subagents

Subagents are **autonomous executors** — they take a task, use tools, and return a result. This is distinct from Skills, which are **knowledge containers** that load patterns for Claude to apply.

| Concept | Role | How to trigger |
|---------|------|----------------|
| **Skills** | Load reference patterns — Claude applies them | `/arc-tdd-patterns`, `/swiftui-expert-skill`, etc. |
| **Agents** | Execute autonomously — Claude delegates the task | "Implement X with TDD", "Review before commit", "Debug this error" |

---

## The 12 ARC Labs Agents

### `arc-swift-tdd`
**Implements features using strict TDD** — writes Swift Testing test suites before any production code.

| | |
|--|--|
| **Model** | claude-sonnet-4-6 |
| **Read-only** | No |
| **Triggers** | "Implement a feature", "write tests first", "create a UseCase", "create a ViewModel", "add a Repository" |

Skills invoked dynamically: `arc-tdd-patterns`, `arc-swift-architecture`, `arc-presentation-layer`, `arc-data-layer`, `swiftui-expert-skill`, `swiftui-liquid-glass`, `swiftdata-pro`, `swift-concurrency`, `axiom:axiom-swift-testing`

---

### `arc-swift-reviewer`
**Delegated code reviewer** — evaluates code against 9 ARC Labs domains and produces a structured report.

| | |
|--|--|
| **Model** | claude-sonnet-4-6 |
| **Read-only** | Yes |
| **Triggers** | "Review this code", "pre-merge review", "check for architecture violations", "audit this file", "review before I commit" |

Skills invoked dynamically: `arc-quality-standards`, `swiftui-expert-skill`, `swift-concurrency`, `swiftdata-pro`, `axiom:axiom-hig`, `axiom:axiom-ios-accessibility`, `localization`

> **Distinction**: For guided review where you conduct the review with Claude's help, use the `/arc-final-review` skill instead.

---

### `arc-swift-debugger`
**Diagnoses and fixes build/test failures** — environment-first diagnostics, then code fixes.

| | |
|--|--|
| **Model** | claude-sonnet-4-6 |
| **Read-only** | No |
| **Triggers** | "Build failed", "BUILD FAILED", Sendable violation, actor-isolated error, "no such module", test failures, pasted Xcode errors |

Skills invoked dynamically: `swift-concurrency`, `axiom:axiom-swift-concurrency`, `axiom:axiom-ios-build`, `axiom:axiom-xcode-debugging`, `swiftdata-pro`, `axiom:axiom-swiftdata`, `axiom:axiom-swift-testing`

---

### `arc-spm-manager`
**Manages Swift Package Manager** — adds/removes/updates dependencies and verifies builds.

| | |
|--|--|
| **Model** | claude-haiku-4-5-20251001 |
| **Read-only** | No |
| **Triggers** | "Add a Swift package", "add a dependency", "update SPM", "resolve package conflict", "fix Package.swift", "add a new target" |

Skills invoked dynamically: `arc-project-setup`, `xcodebuildmcp`

---

### `arc-xcode-explorer`
**Read-only codebase navigator** — maps architecture, traces data flows, finds symbols.

| | |
|--|--|
| **Model** | claude-haiku-4-5-20251001 |
| **Read-only** | Yes |
| **Triggers** | "Where is X implemented?", "find all ViewModels", "map the architecture", "trace the data flow for", "what calls this function?", "show me the dependency graph" |

No skills invoked — lightweight by design for speed.

---

### `arc-linear-bridge`
**Linear-to-Swift scaffolding** — reads tickets via MCP, creates test skeleton + feature memory file + branch.

| | |
|--|--|
| **Model** | claude-haiku-4-5-20251001 |
| **Read-only** | No |
| **Triggers** | "Start working on FVRS-[N]", "scaffold ticket ARC-[N]", "set up tests for [issue ID]" |

Skills invoked dynamically: `arc-tdd-patterns`, `arc-memory`

---

### `arc-pr-publisher`
**Publishes a feature branch as a PR** — validates checklist, creates PR on GitHub, links Linear ticket, updates issue to "In Review".

| | |
|--|--|
| **Model** | claude-sonnet-4-6 |
| **Read-only** | No (creates PR via MCP) |
| **Triggers** | "Create a PR", "open a pull request", "publish my branch", "I'm ready to merge", "submit for review" |

Skills invoked dynamically: `arc-quality-standards`, `arc-tdd-patterns`

---

### `arc-release-orchestrator`
**Orchestrates the full release cycle** — bumps version, updates CHANGELOG, creates release branch and PR, reports manual steps (tag + App Store).

| | |
|--|--|
| **Model** | claude-sonnet-4-6 |
| **Read-only** | No |
| **Triggers** | "Prepare a release", "bump version to X.Y.Z", "create release branch", "ship vX.Y.Z" |

Skills invoked dynamically: `arc-release`

---

### `arc-testflight`
**Orchestrates beta distribution** — archive → upload → TestFlight tester configuration and release notes. Distinct from `arc-release-orchestrator` which handles code/PR; this handles distribution only.

| | |
|--|--|
| **Model** | claude-haiku-4-5-20251001 |
| **Read-only** | No (generates release notes, configures tester groups) |
| **Triggers** | "Send to TestFlight", "create beta build", "upload to TestFlight", "add testers", "update beta release notes", "distribute beta" |

Skills invoked dynamically: `arc-testflight`, `arc-xcode-cloud`, `arc-release`

---

### `arc-aso`
**Executes App Store Optimization** — orchestrates the full ASO skill ecosystem and produces ready-to-upload metadata files (title, keywords, screenshots brief, release notes).

| | |
|--|--|
| **Model** | claude-sonnet-4-6 |
| **Read-only** | No (writes `aso/[app-id]/` output files) |
| **Triggers** | "Optimize my App Store listing", "ASO audit", "improve my keywords", "update screenshots strategy", "write release notes", "prepare App Store metadata", "improve conversion rate" |

Skills invoked dynamically: `app-marketing-context`, `aso-audit`, `keyword-research`, `metadata-optimization`, `screenshot-optimization`, `app-store-featured`, `ab-test-store-listing`, `app-launch`

---

### `arc-swiftdata-migration`
**Manages SwiftData schema migrations** — the most conservative agent in the system. Classifies changes as lightweight or custom, confirms with the user before any breaking change, and always writes migration tests before migration code.

| | |
|--|--|
| **Model** | claude-sonnet-4-6 |
| **Read-only** | No |
| **Triggers** | "Add a SwiftData attribute", "rename a model property", "add a relationship", "SwiftData migration crash", "schema version", "VersionedSchema" |

Skills invoked dynamically: `swiftdata-pro`, `axiom:axiom-swiftdata-migration`, `axiom:axiom-swiftdata-migration-diag`, `axiom:axiom-swiftdata`, `arc-data-layer`, `arc-tdd-patterns`

---

### `arc-dependency-auditor`
**Audits SPM dependencies** — read-only analysis of packages across the project or full ARC Labs ecosystem. Detects outdated versions, version inconsistencies, and branch pins. Produces a prioritized report; apply updates with `arc-spm-manager`.

| | |
|--|--|
| **Model** | claude-haiku-4-5-20251001 |
| **Read-only** | Yes |
| **Triggers** | "Audit my dependencies", "check for outdated packages", "are my dependencies up to date?", "check version consistency across projects", "dependency health check" |

Skills invoked dynamically: `arc-project-setup`

---

## Master Table — Skills and MCPs per Agent

| Agent | ARC Labs Skills | Van der Lee | Axiom Skills | MCPs |
|-------|----------------|-------------|-------------|------|
| `arc-swift-tdd` | arc-tdd-patterns, arc-swift-architecture, arc-presentation-layer, arc-data-layer | swift-concurrency, swiftdata-pro, swiftui-expert-skill, swiftui-liquid-glass | axiom:axiom-swift-testing | cupertino (search, symbols, read) |
| `arc-swift-reviewer` | arc-quality-standards | swift-concurrency, swiftdata-pro, swiftui-expert-skill, localization | axiom:axiom-hig, axiom:axiom-ios-accessibility | cupertino search, apple-docs |
| `arc-swift-debugger` | — | swift-concurrency, swiftdata-pro | axiom:axiom-swift-concurrency, axiom:axiom-ios-build, axiom:axiom-xcode-debugging, axiom:axiom-swiftdata, axiom:axiom-swift-testing | cupertino (search, symbols) |
| `arc-spm-manager` | arc-project-setup | xcodebuildmcp | — | cupertino search |
| `arc-xcode-explorer` | — (inlined) | — | — | cupertino search (optional) |
| `arc-linear-bridge` | arc-tdd-patterns, arc-memory | — | — | linear_get_issue, linear_list_issues, github_create_branch |
| `arc-pr-publisher` | arc-quality-standards, arc-tdd-patterns | — | — | github_create_pr, linear_get_issue, linear_update_issue, workflow_get_conventions |
| `arc-release-orchestrator` | arc-release | — | — | github_create_branch, github_create_pr, linear_list_issues, workflow_get_conventions |
| `arc-testflight` | arc-testflight, arc-xcode-cloud, arc-release | — | — | cupertino search, apple-docs (search + content) |
| `arc-aso` | — | app-marketing-context, aso-audit, metadata-optimization, screenshot-optimization, app-store-featured, ab-test-store-listing, keyword-research, app-launch | — | apple-docs (search + content), WebSearch, WebFetch |
| `arc-swiftdata-migration` | arc-data-layer, arc-tdd-patterns | swiftdata-pro | axiom:axiom-swiftdata-migration, axiom:axiom-swiftdata-migration-diag, axiom:axiom-swiftdata | cupertino (search + symbols), apple-docs (search + content) |
| `arc-dependency-auditor` | arc-project-setup | — | — | cupertino search, apple-docs search |

---

## Design Principles

- **Minimum privilege**: read-only agents (`arc-swift-reviewer`, `arc-xcode-explorer`) have no Edit/Write tools
- **Dynamic skill invocation**: agents invoke skills relevant to the task, not all skills by default
- **Environment first**: `arc-swift-debugger` always checks environment before touching code
- **Model selection**: Haiku for deterministic tasks (SPM, exploration, scaffolding); Sonnet for complex reasoning (TDD, review, debugging)
- **No commit/push**: all agents with write access are constrained from committing

---

## Integration with arcdevtools-setup

Symlinks for agents follow the same pattern as skills. To install in a project:

```bash
./ARCDevTools/arcdevtools-setup
```

The setup script symlinks `.claude/agents/arc-*.md` into the project's `.claude/agents/` directory.

Add to `.gitignore`:
```
.claude/agents/arc-*.md
```

> **Note**: `arcdevtools-setup` update is required in each project repo (FavRes-iOS, etc.) — tracked separately.

---

## Adding a New Agent

1. Create `.claude/agents/arc-[name].md` with frontmatter (`name`, `description`, `model`, `tools`)
2. List the skills it will invoke dynamically in its instructions
3. Add entry to this `AGENTS.md`
4. Add entry to `Skills/skills-index.md` under the Agents section
