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
  git push origin main

  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$commit_msg" >> "$LOG_DIR/sync.log"
else
  printf '%s no changes\n' "$(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_DIR/sync.log"
fi
