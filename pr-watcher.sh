#!/bin/bash
# PR Watcher — polls GitHub for open PRs and triggers a Claude Code review
# for any PR that hasn't been reviewed at its current commit (head SHA).
#
# Usage:
#   bash pr-watcher.sh
#
# Config (env vars or edit defaults below):
#   REPO        GitHub repo in owner/name format   (required)
#   MAX_AGE_DAYS  Only review PRs updated within N days (default: 7)

export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

REPO="${REPO:-"owner/repo"}"
MAX_AGE_DAYS="${MAX_AGE_DAYS:-7}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_FILE="$SCRIPT_DIR/.pr-reviewed.txt"
LOG_FILE="$SCRIPT_DIR/.pr-watcher.log"

touch "$STATE_FILE" "$LOG_FILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Rotate log when it exceeds 5000 lines
if [ "$(wc -l < "$LOG_FILE")" -gt 5000 ]; then
    tail -1000 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

cd "$SCRIPT_DIR" || exit 1

OPEN_PRS=$(gh pr list --repo "$REPO" --state open \
    --json number,headRefOid,updatedAt 2>/dev/null || true)

if [ -z "$OPEN_PRS" ] || [ "$OPEN_PRS" = "[]" ]; then
    exit 0
fi

while IFS=$'\t' read -r PR_NUM HEAD_SHA; do
    [ -z "$PR_NUM" ] && continue

    KEY="${PR_NUM}:${HEAD_SHA}"

    if grep -qF "$KEY" "$STATE_FILE" 2>/dev/null; then
        continue
    fi

    log "PR #$PR_NUM detected (${HEAD_SHA:0:8}), queuing review..."
    echo "$KEY" >> "$STATE_FILE"

    nohup env -u CLAUDECODE claude --dangerously-skip-permissions \
        -p "/review-pr $PR_NUM" >> "$LOG_FILE" 2>&1 &

    log "Review started for PR #$PR_NUM (PID: $!)"

done < <(python3 -c "
import sys, json
from datetime import datetime, timezone, timedelta

prs = json.load(sys.stdin)
cutoff = datetime.now(timezone.utc) - timedelta(days=$MAX_AGE_DAYS)

for pr in prs:
    updated = datetime.fromisoformat(pr['updatedAt'].replace('Z', '+00:00'))
    if updated >= cutoff:
        print(pr['number'], pr['headRefOid'], sep='\t')
" <<< "$OPEN_PRS")
