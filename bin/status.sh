#!/usr/bin/env bash
# status.sh
# Report the current state of ~/.claude/CLAUDE.md.
set -euo pipefail

TARGET="$HOME/.claude/CLAUDE.md"
BACKUP="$HOME/.claude/CLAUDE.md.real"

echo "== Claude-MD-Tester status =="

if [ -L "$TARGET" ]; then
    LINK="$(readlink "$TARGET")"
    if [ -e "$TARGET" ]; then
        echo "CLAUDE.md: SYMLINK -> $LINK (target exists)"
    else
        echo "CLAUDE.md: SYMLINK -> $LINK (DANGLING)"
    fi
elif [ -f "$TARGET" ]; then
    echo "CLAUDE.md: regular file ($(wc -l < "$TARGET") lines, $(wc -c < "$TARGET") bytes)"
else
    echo "CLAUDE.md: MISSING"
fi

if [ -e "$BACKUP" ]; then
    if [ -L "$BACKUP" ]; then
        echo "backup:    symlink (unexpected) -> $(readlink "$BACKUP")"
    else
        echo "backup:    present at $BACKUP ($(wc -l < "$BACKUP") lines, $(wc -c < "$BACKUP") bytes)"
    fi
else
    echo "backup:    none"
fi
