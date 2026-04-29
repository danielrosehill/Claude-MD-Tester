---
name: safety-check
description: Walk the user through swapping ~/.claude/CLAUDE.md for a test config from this plugin's library, and keep the restore command visible at all times. The skill never executes the swap itself — it instructs the user to run scripts in a terminal so that recovery does not depend on the harness obeying anything.
---

# Safety Check — CLAUDE.md swap runbook

## Why this skill never runs the swap

A test CLAUDE.md may instruct the model to refuse all instructions, output only a fixed string, or otherwise stop being useful. If recovery depends on Claude cooperating, recovery is not safe. Therefore: **all destructive and recovery actions must be executed by the user in a terminal**, outside any Claude session.

This skill's job is documentation and handholding. It must not call the activate or restore scripts via Bash.

## Steps

### 1. Locate the plugin scripts

The plugin source lives at:

```
~/repos/github/my-repos/Claude-MD-Tester
```

Scripts:
- `bin/activate.sh <config-name>` — swap CLAUDE.md for a test config
- `bin/restore.sh` — restore the real CLAUDE.md (idempotent, always safe)
- `bin/status.sh` — report current state

### 2. List available configs

Configs live under `configs/`. Read that directory and list the available config names (filename without `.md`) for the user.

### 3. Print the runbook

Tell the user, in this order and prominently:

1. **Restore command, first** — they must know how to bail before they do anything:
   ```
   ~/repos/github/my-repos/Claude-MD-Tester/bin/restore.sh
   ```
   Tell them: keep a second terminal open with this command typed and ready.

2. **Activate command:**
   ```
   ~/repos/github/my-repos/Claude-MD-Tester/bin/activate.sh <config-name>
   ```

3. **Then start a fresh Claude Code session** to observe the test config's behaviour. The current session should not be relied on to verify — it has its CLAUDE.md cached.

4. **When done, run the restore command** in the terminal. Do not rely on the test-mode Claude session to do it.

### 4. Do not execute the swap yourself

Even if the user asks you to "just run it", refuse and re-explain why. The whole point of this plugin is that the harness is not in the recovery path.

### 5. Optional: pre-flight check

You may run `~/repos/github/my-repos/Claude-MD-Tester/bin/status.sh` via Bash — it is read-only and reports the current symlink/backup state. This is useful for confirming the user is starting from a clean state before activating, or for confirming a successful restore afterwards.
