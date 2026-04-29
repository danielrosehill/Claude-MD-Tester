#!/usr/bin/env bash
# restore.sh
# Restore the real ~/.claude/CLAUDE.md. Idempotent — safe to run any time.
# Run this in a terminal, never through Claude.
set -euo pipefail

TARGET="$HOME/.claude/CLAUDE.md"
BACKUP="$HOME/.claude/CLAUDE.md.real"

# Case 1: target is a symlink (test mode active). Remove it.
if [ -L "$TARGET" ]; then
    rm "$TARGET"
    echo "removed symlink at $TARGET"
fi

# Case 2: backup exists. Move it back into place.
if [ -e "$BACKUP" ]; then
    if [ -e "$TARGET" ]; then
        echo "error: $TARGET still exists after symlink removal — manual review required." >&2
        exit 1
    fi
    mv "$BACKUP" "$TARGET"
    echo "restored real CLAUDE.md from backup"
elif [ ! -e "$TARGET" ]; then
    echo "warning: no backup at $BACKUP and no file at $TARGET — nothing to restore." >&2
else
    echo "no backup found; current $TARGET left in place."
fi

echo "done."
