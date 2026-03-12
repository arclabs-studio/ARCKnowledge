---
name: arc-xcode-cloud
description: |
  Xcode Cloud CI/CD setup and configuration for ARC Labs iOS apps. Covers
  ci_scripts/ setup (ci_post_clone, ci_pre_xcodebuild, ci_post_xcodebuild),
  Package.resolved requirements, workflow configuration in Xcode/ASC, private
  SPM dependency authorization, recommended workflows (CI, PR, Release), and
  25-hour budget strategy. Use when "setting up Xcode Cloud", "configuring CI
  for iOS", "ci_scripts not running", or "Xcode Cloud workflow".
user-invocable: true
metadata:
  author: ARC Labs Studio
  version: "1.0.0"
---

# arc-xcode-cloud: Xcode Cloud CI/CD for ARC Labs iOS Apps

Xcode Cloud is the **recommended CI/CD solution** for ARC Labs iOS apps. It provides 25 free compute hours/month, native simulator support, and automatic code signing — with zero YAML configuration.

---

## Pre-flight Checklist

Before setting up Xcode Cloud, verify all four items:

- [ ] `Package.resolved` is tracked in git (not in `.gitignore`)
  - Path: `<AppName>.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`
- [ ] Apple Developer Program membership active
- [ ] App Store Connect app record exists for this app
- [ ] Private SPM dependencies authorized in Xcode Cloud settings (see below)

---

## ci_scripts/ Setup

Xcode Cloud auto-detects scripts in `ci_scripts/` at the **project root** (same level as `.gitignore`). Scripts must be **executable**.

### Copy from ARCDevTools templates

```bash
mkdir -p ci_scripts
cp Tools/ARCDevTools/templates/ci_scripts/*.sh ci_scripts/
chmod +x ci_scripts/*.sh
git add ci_scripts/
git commit -m "feat(ci): add Xcode Cloud ci_scripts"
```

### Script reference

| Script | When It Runs | What It Does |
|--------|-------------|--------------|
| `ci_post_clone.sh` | After repo clone | Verify Package.resolved, install SwiftLint |
| `ci_pre_xcodebuild.sh` | Before each xcodebuild action | Log build context (action, platform, PR/tag) |
| `ci_post_xcodebuild.sh` | After each xcodebuild action | Log results (archive path, test results path) |

### Common mistake: scripts not running

If scripts are not being picked up by Xcode Cloud:
1. Confirm `ci_scripts/` is at the **project root** (not inside an app subfolder)
2. Confirm scripts have the executable bit: `ls -la ci_scripts/`
3. If missing: `chmod +x ci_scripts/*.sh && git add -u && git commit -m "fix(ci): make scripts executable"`

---

## Recommended Workflows

Configure these three workflows in Xcode or App Store Connect:

| Workflow | Trigger | Actions | Est. Time |
|----------|---------|---------|-----------|
| **CI** | Push to `main` or `develop` | Build + Test | ~8 min |
| **PR Validation** | PR opened/updated | Build + Test | ~8 min |
| **Release** | Tag `v*.*.*` | Archive → TestFlight | ~12 min |

### Setting up in Xcode

1. Open Xcode → Report Navigator (⌘9) → **Cloud** tab
2. Click **Get Started** (first time) or **Manage Workflows**
3. Create workflow → configure Start Condition and Actions
4. Save and run a test build

---

## Environment Variables

Key variables available in `ci_scripts/`:

| Variable | When Available | Value |
|----------|---------------|-------|
| `CI_BRANCH` | Always | Branch name |
| `CI_WORKFLOW` | Always | Workflow name |
| `CI_BUILD_NUMBER` | Always | Build number |
| `CI_COMMIT` | Always | Git commit hash |
| `CI_XCODEBUILD_ACTION` | pre/post_xcodebuild | `build`, `test`, `archive` |
| `CI_PRODUCT_PLATFORM` | pre/post_xcodebuild | `iOS`, `macOS`, etc. |
| `CI_PULL_REQUEST_NUMBER` | PR builds | PR number |
| `CI_TAG` | Tag builds | Tag name (e.g., `v1.2.0`) |
| `CI_ARCHIVE_PATH` | post_xcodebuild (archive) | `.xcarchive` path |
| `CI_TEST_RESULTS_PATH` | post_xcodebuild (test) | `.xcresult` path |

---

## Hour Budget (25 hrs/month free)

Typical monthly consumption with recommended workflows:

| Workflow | Runs/Month | Time Each | Monthly Cost |
|----------|-----------|-----------|-------------|
| CI (main/develop pushes) | ~20 | ~8 min | ~2.7 hrs |
| PR Validation | ~30 | ~8 min | ~4.0 hrs |
| Release (tags) | ~4 | ~12 min | ~0.8 hrs |
| **Total** | | | **~7.5 hrs** |

**Tips to stay within budget**:
- Trigger CI only on `main`/`develop`, not feature branches
- Limit archive/TestFlight to version tags only
- Use file path filters to skip builds for doc-only changes
- Set max 1 concurrent build per workflow

---

## Private SPM Authorization

For private GitHub packages (including submodules like `Tools/ARCDevTools`):

1. Open **App Store Connect** → your app → **Xcode Cloud**
2. Navigate to **Settings** → **Additional Repositories**
3. Click **+** and add each private repository
4. Xcode Cloud uses your connected GitHub account credentials

If a submodule requires access, add the submodule's repository URL as well.

---

## Troubleshooting

| Issue | Likely Cause | Fix |
|-------|-------------|-----|
| SPM resolution fails | `Package.resolved` missing or private dep not authorized | Commit `Package.resolved`; add repo in ASC → Additional Repositories |
| `ci_post_clone.sh` not running | Script not executable or wrong directory | `chmod +x ci_scripts/*.sh` and commit; confirm `ci_scripts/` is at project root |
| Code signing fails on archive | No distribution certificate or profile | Enable Automatic Signing in workflow's Archive action |
| Build times out | First run downloads iOS runtime (~5-10 min extra) | Expected on first build; subsequent runs are faster |
| Workflow not triggering on PR | Branch filter mismatch or webhook not connected | Edit workflow Start Condition; verify SCM integration in Xcode Cloud settings |

---

## Examples

### "Set up Xcode Cloud from scratch"

```
1. Run pre-flight checklist (Package.resolved, Developer account, ASC app record)
2. Copy ci_scripts/ from ARCDevTools templates + chmod +x + commit
3. In Xcode → Report Navigator → Cloud → Get Started
4. Authorize GitHub SCM provider
5. Add private repos in App Store Connect → Additional Repositories
6. Create CI workflow (push to main/develop → build + test)
7. Create PR Validation workflow (PR opened/updated → build + test)
8. Create Release workflow (tag v*.*.* → archive → TestFlight)
```

### "Add ci_post_clone to existing project"

```bash
# From project root:
mkdir -p ci_scripts
cp Tools/ARCDevTools/templates/ci_scripts/ci_post_clone.sh ci_scripts/
chmod +x ci_scripts/ci_post_clone.sh
git add ci_scripts/ci_post_clone.sh
git commit -m "feat(ci): add ci_post_clone for Xcode Cloud"
# Push and verify in Xcode Cloud build log
```

---

## Related Skills

- `/arc-project-setup` — Setting up a new ARC Labs iOS app with ARCDevTools
- `/arc-workflow` — Git commits, branches, PRs
