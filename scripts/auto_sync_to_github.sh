#!/bin/zsh

set -euo pipefail

REPO_DIR="/Users/heytea/Documents/obsidian_note"
LOG_DIR="$REPO_DIR/.git/auto-sync"
mkdir -p "$LOG_DIR"

cd "$REPO_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository: $REPO_DIR" >&2
  exit 1
fi

commit_msg=""

if [[ -n "$(git status --porcelain)" ]]; then
  changed_files=$(git status --porcelain | awk '{print $2}' | head -n 8)
  changed_count=$(git status --porcelain | wc -l | tr -d ' ')
  summary=$(printf "%s\n" "$changed_files" | paste -sd ', ' -)
  if [[ -z "$summary" ]]; then
    summary="obsidian updates"
  fi
  if [[ "$changed_count" -gt 8 ]]; then
    summary="$summary, etc"
  fi

  commit_msg="obsidian: sync ${summary}"

  git add -A
  git commit -m "$commit_msg"
fi

git fetch origin main

ahead_behind=$(git rev-list --left-right --count origin/main...HEAD)
behind_count=$(printf '%s\n' "$ahead_behind" | awk '{print $1}')
ahead_count=$(printf '%s\n' "$ahead_behind" | awk '{print $2}')

if [[ "$ahead_count" -gt 0 && "$behind_count" -gt 0 ]]; then
  printf '%s sync blocked: local and origin/main diverged (ahead=%s, behind=%s)\n' \
    "$(date '+%Y-%m-%d %H:%M:%S')" "$ahead_count" "$behind_count" >> "$LOG_DIR/sync.log"
  echo "Sync blocked: local branch diverged from origin/main (ahead=$ahead_count, behind=$behind_count)." >&2
  echo "Please resolve with manual pull/rebase or merge before retrying auto sync." >&2
  exit 2
fi

branch_state=$(git status --short --branch)
if [[ "$branch_state" == *"[ahead "* && "$behind_count" -eq 0 ]]; then
  git push origin main
fi

if [[ -n "$commit_msg" ]]; then
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$commit_msg" >> "$LOG_DIR/sync.log"
else
  printf '%s no changes\n' "$(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_DIR/sync.log"
fi
