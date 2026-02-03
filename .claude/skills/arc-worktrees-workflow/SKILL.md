---
name: arc-worktrees-workflow
description: |
  Git worktrees workflow for parallel feature development at ARC Labs Studio.
  Covers worktree creation, submodule initialization, cleanup procedures,
  shell aliases for quick navigation, and integration with Linear ticketing
  system (FVRS-XXX format).

  **INVOKE THIS SKILL** when:
  - Starting a new feature that requires isolated development
  - Setting up parallel development environments
  - Managing multiple in-progress features simultaneously
  - Cleaning up after PR merge
  - Configuring shell aliases for worktree navigation
---

# ARC Labs Studio - Git Worktrees Workflow

## Overview

Git worktrees allow you to have multiple working directories from the same repository, each on a different branch. This enables true parallel development without stashing or switching branches.

### Benefits
- Work on multiple features simultaneously
- Run tests in one worktree while coding in another
- Keep context separate per feature
- Run 3 Claude Code instances (one per worktree)
- No stashing, no branch switching

### ARC Labs Directory Structure

```
~/Developer/ARCLabsStudio/Apps/
├── FavRes-iOS/                    # Main worktree (develop branch)
│   ├── .git/                      # Git directory (shared)
│   └── Tools/ARCDevTools/         # Submodule
│       └── ARCKnowledge/          # Nested submodule
│
└── FavRes-iOS-worktrees/          # Feature worktrees
    ├── FVRS-123/                  # Worktree for ticket FVRS-123
    │   └── Tools/ARCDevTools/     # Initialized submodules
    ├── FVRS-124/
    └── FVRS-125/
```

## Creating a New Worktree

### Step 1: Create Branch and Worktree

From the main repository (FavRes-iOS):

```bash
# Navigate to main repo
cd ~/Developer/ARCLabsStudio/Apps/FavRes-iOS

# Fetch latest changes
git fetch origin

# Create worktree with new branch from develop
git worktree add \
  ../FavRes-iOS-worktrees/FVRS-123 \
  -b feature/FVRS-123-description \
  origin/develop

# Or from main (for hotfixes)
git worktree add \
  ../FavRes-iOS-worktrees/FVRS-123 \
  -b hotfix/FVRS-123-description \
  origin/main
```

### Step 2: Initialize Submodules

Submodules are NOT automatically initialized in new worktrees:

```bash
# Navigate to new worktree
cd ../FavRes-iOS-worktrees/FVRS-123

# Initialize and update submodules recursively
git submodule update --init --recursive

# Verify submodules
git submodule status
```

Expected output:
```
 2862218b18... Tools/ARCDevTools (v2.0.1-2-g2862218)
 5fabb991e0... Tools/ARCDevTools/ARCKnowledge (v2.0.1-1-g5fabb99)
```

### Step 3: Open Claude Code

```bash
# Open Claude Code in the new worktree
claude

# Or open in new Ghostty tab
# ⌘+T to create new tab, then:
cd ~/Developer/ARCLabsStudio/Apps/FavRes-iOS-worktrees/FVRS-123 && claude
```

## Managing Worktrees

### List All Worktrees

```bash
# From any worktree
git worktree list
```

Output:
```
/Users/arclabs/Developer/ARCLabsStudio/Apps/FavRes-iOS               abc1234 [develop]
/Users/arclabs/Developer/ARCLabsStudio/Apps/FavRes-iOS-worktrees/FVRS-123  def5678 [feature/FVRS-123]
/Users/arclabs/Developer/ARCLabsStudio/Apps/FavRes-iOS-worktrees/FVRS-124  ghi9012 [feature/FVRS-124]
```

### Check Worktree Status

```bash
# Quick status of all worktrees
for wt in ~/Developer/ARCLabsStudio/Apps/FavRes-iOS-worktrees/*/; do
  echo "=== $(basename $wt) ==="
  git -C "$wt" status -sb
done
```

## Cleanup After PR Merge

### Step 1: Remove Worktree

```bash
# Navigate to main repo
cd ~/Developer/ARCLabsStudio/Apps/FavRes-iOS

# Remove worktree (keeps branch)
git worktree remove ../FavRes-iOS-worktrees/FVRS-123

# Or force remove if there are untracked files
git worktree remove --force ../FavRes-iOS-worktrees/FVRS-123
```

### Step 2: Delete Branch (Optional)

```bash
# Delete local branch (if PR was merged)
git branch -d feature/FVRS-123

# Force delete if not merged
git branch -D feature/FVRS-123

# Delete remote branch
git push origin --delete feature/FVRS-123
```

### Step 3: Prune Stale Entries

```bash
# Clean up stale worktree entries
git worktree prune

# Verify
git worktree list
```

## Shell Aliases for Quick Navigation

Add to `~/.zshrc`:

```bash
# =============================================================================
# ARC Labs Worktrees Navigation
# =============================================================================

# Base paths
export ARC_APPS="$HOME/Developer/ARCLabsStudio/Apps"
export ARC_FAVRES="$ARC_APPS/FavRes-iOS"
export ARC_WORKTREES="$ARC_APPS/FavRes-iOS-worktrees"

# Quick navigation to main worktree
alias zf="cd $ARC_FAVRES && pwd"

# Quick navigation to worktrees (za, zb, zc pattern)
# These get dynamically assigned based on active worktrees
alias za="cd $ARC_WORKTREES/\$(ls $ARC_WORKTREES | head -1) 2>/dev/null && pwd || echo 'No worktrees'"
alias zb="cd $ARC_WORKTREES/\$(ls $ARC_WORKTREES | sed -n '2p') 2>/dev/null && pwd || echo 'No second worktree'"
alias zc="cd $ARC_WORKTREES/\$(ls $ARC_WORKTREES | sed -n '3p') 2>/dev/null && pwd || echo 'No third worktree'"

# Navigate to specific worktree by ticket ID
zw() {
  local ticket="$1"
  if [ -z "$ticket" ]; then
    echo "Usage: zw FVRS-123"
    echo "Available worktrees:"
    ls "$ARC_WORKTREES" 2>/dev/null || echo "No worktrees found"
    return 1
  fi

  local path="$ARC_WORKTREES/$ticket"
  if [ -d "$path" ]; then
    cd "$path" && pwd
  else
    echo "Worktree not found: $path"
    echo "Available: $(ls $ARC_WORKTREES 2>/dev/null | tr '\n' ' ')"
    return 1
  fi
}

# List all worktrees with status
zwl() {
  echo "=== FavRes Worktrees ==="
  git -C "$ARC_FAVRES" worktree list
  echo ""
  echo "=== Navigation Aliases ==="
  echo "zf  → main (develop)"
  echo "za  → $(ls $ARC_WORKTREES 2>/dev/null | head -1 || echo 'none')"
  echo "zb  → $(ls $ARC_WORKTREES 2>/dev/null | sed -n '2p' || echo 'none')"
  echo "zc  → $(ls $ARC_WORKTREES 2>/dev/null | sed -n '3p' || echo 'none')"
  echo "zw  → specific ticket (e.g., zw FVRS-123)"
}

# Create new worktree (from develop)
zwn() {
  local ticket="$1"
  local desc="$2"

  if [ -z "$ticket" ]; then
    echo "Usage: zwn FVRS-123 [description]"
    return 1
  fi

  local branch_name="feature/$ticket"
  if [ -n "$desc" ]; then
    branch_name="feature/$ticket-$(echo $desc | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
  fi

  cd "$ARC_FAVRES" || return 1
  git fetch origin

  git worktree add \
    "$ARC_WORKTREES/$ticket" \
    -b "$branch_name" \
    origin/develop

  if [ $? -eq 0 ]; then
    cd "$ARC_WORKTREES/$ticket"
    git submodule update --init --recursive
    echo ""
    echo "✅ Worktree created: $ARC_WORKTREES/$ticket"
    echo "📁 Branch: $branch_name"
    echo "🚀 Run 'claude' to start coding"
  fi
}

# Remove worktree after PR merge
zwr() {
  local ticket="$1"

  if [ -z "$ticket" ]; then
    echo "Usage: zwr FVRS-123"
    echo "Available worktrees:"
    ls "$ARC_WORKTREES" 2>/dev/null || echo "No worktrees found"
    return 1
  fi

  local path="$ARC_WORKTREES/$ticket"

  if [ ! -d "$path" ]; then
    echo "Worktree not found: $path"
    return 1
  fi

  echo "Removing worktree: $path"
  cd "$ARC_FAVRES" || return 1

  git worktree remove "$path" --force
  git worktree prune

  echo "✅ Worktree removed"
  echo "💡 Don't forget to delete the branch if PR was merged:"
  echo "   git branch -d feature/$ticket-*"
}
```

After adding, reload shell:
```bash
source ~/.zshrc
```

## Linear Integration

### Branch Naming Convention

| Type | Format | Example |
|------|--------|---------|
| Feature | `feature/FVRS-XXX-description` | `feature/FVRS-123-add-search` |
| Bugfix | `bugfix/FVRS-XXX-description` | `bugfix/FVRS-456-fix-crash` |
| Hotfix | `hotfix/FVRS-XXX-description` | `hotfix/FVRS-789-critical-fix` |

### Workflow with Linear

1. **Get ticket from Linear** (e.g., FVRS-123)
2. **Create worktree**: `zwn FVRS-123 add-restaurant-search`
3. **Open Claude Code**: `claude`
4. **Code and commit**: Follow conventional commits
5. **Create PR**: Link to Linear ticket
6. **After merge**: `zwr FVRS-123`

## Memory Directory Integration

Each worktree should maintain its own `/memory` directory for context:

```
FVRS-123/
├── memory/
│   ├── CONTEXT.md       # Feature context and decisions
│   ├── PROGRESS.md      # What's done, what's next
│   └── BLOCKERS.md      # Issues encountered
├── FavRes-iOS/
└── Tools/
```

See `/memory` skill for detailed memory directory patterns.

## Best Practices

### Recommended Limits
- **Maximum 3 active worktrees** (matches Ghostty tabs 1-3)
- **Complete and clean up** before creating new ones
- **Keep develop branch clean** - only merge via PR

### Common Issues

| Issue | Solution |
|-------|----------|
| Submodules not showing | Run `git submodule update --init --recursive` |
| "Already exists" error | Remove stale entry: `git worktree prune` |
| Can't remove worktree | Use `--force` flag or check for running processes |
| Branch already exists | Delete branch first or use existing branch |

### Daily Workflow

```bash
# Morning: Check worktree status
zwl

# Start work on feature
zw FVRS-123
claude

# Switch context (different Ghostty tab)
# ⌘+2 or ⌘+3

# End of day: commit and push all worktrees
for wt in ~/Developer/ARCLabsStudio/Apps/FavRes-iOS-worktrees/*/; do
  echo "=== $(basename $wt) ==="
  git -C "$wt" status -sb
done
```

## Related Skills

| If you need... | Use |
|----------------|-----|
| Memory directories | `/memory` |
| Git workflow | `/arc-workflow` |
| Project setup | `/arc-project-setup` |
| Feature development | `/arc-create-feature` |
