# Claude-MD-Tester

Swap `~/.claude/CLAUDE.md` for test configs via symlink, with terminal-only restore that does not depend on the Claude harness.

## Why

You want to try weird, joke, or character-heavy CLAUDE.md configs without risking your real one. Naive approaches (rename the file, write a new one in place) are fragile: a partial failure can leave you with no real CLAUDE.md, and a hostile test config can instruct Claude to refuse to restore it.

This plugin uses a **symlink swap** plus **terminal-only recovery scripts** so the harness is never in the recovery path. If the test config tells Claude to do nothing but recite a UUID, you still recover by running one shell command.

## Layout

- `configs/` — the library of test CLAUDE.md files
- `bin/activate.sh <name>` — swap CLAUDE.md for `configs/<name>.md` (terminal only)
- `bin/restore.sh` — restore the real CLAUDE.md, idempotent (terminal only)
- `bin/status.sh` — report current state
- `skills/safety-check/` — plugin skill that walks the user through the swap *without executing it*

## Usage

```bash
# see what's currently active
~/repos/github/my-repos/Claude-MD-Tester/bin/status.sh

# swap in a test config
~/repos/github/my-repos/Claude-MD-Tester/bin/activate.sh symlink-test

# (start a fresh Claude Code session to test)

# restore — always safe, always idempotent
~/repos/github/my-repos/Claude-MD-Tester/bin/restore.sh
```

The first activate moves the real `~/.claude/CLAUDE.md` to `~/.claude/CLAUDE.md.real` and symlinks `CLAUDE.md` to the chosen config. Restore reverses that. Subsequent activates just relink — the backup is touched only on the first swap.

## Safety guarantees

- **Restore never depends on Claude.** It's a 20-line bash script that you can run from any terminal, even with no internet, even if Claude is unresponsive.
- **Activate refuses to clobber a backup.** If `CLAUDE.md.real` already exists when activate is asked to back up a regular file, it aborts. You will never silently lose your real config to a stale backup collision.
- **Symlink mode is detectable.** `status.sh` shows whether you're in test mode at a glance.

## Adding a new test config

Drop a markdown file in `configs/`. The filename (without `.md`) becomes the config name. That's it.
