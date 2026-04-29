#!/usr/bin/env bash
# activate.sh <config-name>
# Swap ~/.claude/CLAUDE.md for a test config from this repo's configs/ dir.
# Run this in a terminal, never through Claude.
set -euo pipefail

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
CONFIG_DIR="$REPO_DIR/configs"
TARGET="$HOME/.claude/CLAUDE.md"
BACKUP="$HOME/.claude/CLAUDE.md.real"

if [ $# -ne 1 ]; then
    echo "usage: $0 <config-name>" >&2
    echo "available configs:" >&2
    ls "$CONFIG_DIR" 2>/dev/null | sed 's/\.md$//' | sed 's/^/  /' >&2
    exit 2
fi

NAME="$1"
SOURCE="$CONFIG_DIR/${NAME}.md"

if [ ! -f "$SOURCE" ]; then
    echo "error: no such config: $SOURCE" >&2
    exit 1
fi

if [ -L "$TARGET" ]; then
    CURRENT="$(readlink "$TARGET")"
    echo "note: CLAUDE.md is already a symlink to: $CURRENT"
    echo "      replacing with: $SOURCE"
    ln -sfn "$SOURCE" "$TARGET"
    echo "active config: $NAME"
    echo "to restore: $REPO_DIR/bin/restore.sh"
    exit 0
fi

if [ -e "$TARGET" ]; then
    if [ -e "$BACKUP" ]; then
        echo "error: $BACKUP already exists — refusing to overwrite an existing backup." >&2
        echo "       inspect it manually before retrying. if it is stale, delete it." >&2
        exit 1
    fi
    mv "$TARGET" "$BACKUP"
    echo "backed up real CLAUDE.md to $BACKUP"
fi

ln -s "$SOURCE" "$TARGET"
echo "active config: $NAME -> $SOURCE"
echo "to restore: $REPO_DIR/bin/restore.sh"
