← [Back to README](README.md) | [Part 2: Pro-Tips](PART2-PRO-TIPS.md) | [Part 3: AI Wiki](PART3-AI-WIKI.md) | [Part 4: Quick Reference](PART4-QUICK-REFERENCE.md) | **Part 5: Implemented Patterns**

---

# Part 5: Implemented Patterns — Live Examples

What's actually running in a production setup, as of April 2026. Not aspirational — deployed.

## Hooks (`~/.claude/settings.json`)

| Hook | Event | Matcher | What It Does | Script/Command |
|------|-------|---------|-------------|----------------|
| Desktop notification | `Notification` | `*` | macOS Glass sound when Claude needs input | `osascript` inline |
| Post-compact reload | `SessionStart` | `compact` | Re-injects git branch, recent commits, active projects, context rules | `echo` inline |
| MCP audit log | `PostToolUse` | `mcp__gmail__\|mcp__slack__\|mcp__google-drive__*` | Logs timestamp + tool + key params to `~/.claude/mcp-audit.log` | inline |
| Test runner | `PostToolUse` | `Edit\|Write` | Runs project test suite after edits, surfaces failures | inline |
| MEMORY.md updater | `PostToolUse` | `Edit\|Write` | Logs structural file changes (skills, hooks, MCP, CLAUDE.md) to MEMORY.md | `claude-context-updater.sh` |
| Test suite syncer | `PostToolUse` | `Edit\|Write` | Adds `assert_file_exists` for new skill/MCP files to run-tests.sh | `test-suite-updater.sh` |
| Mobile approvals | `PermissionRequest` | `*` | Forwards permission prompts to phone via ntfy.sh with Approve/Deny buttons | `remote-approver.sh` |

## Test Suites

Two zero-dependency bash test runners, one per repo.

### PersonalOS (`tests/run-tests.sh`)

| Section | What's Tested |
|---------|--------------|
| Core Files | CLAUDE.md, README.md, setup.sh existence |
| Skill Files | All `.md` files in `skills/` (via `SKILLS=()` array — auto-updated by hook) |
| Skill Structure | Knowledge base references, content patterns |
| CLAUDE.md Structure | 8 required sections present |
| MCP Servers | Source files, TypeScript typecheck (`tsc --noEmit`), build/start/auth scripts |
| Configs | naming-conventions.env (4 prefixes), settings-template.json |
| Docs | man.md, pattern-library.md, template.md with section validation |
| Setup Script | Syntax, executable bit, no hardcoded paths, no plaintext secrets |
| Architecture Rules | No cross-repo references in skills or MCP source |

### WorkOS (`tests/run-tests.sh`)

| Section | What's Tested |
|---------|--------------|
| Core Files | CLAUDE.md, setup.sh, LICENSE, ref-mcp-infrastructure.md, .gitignore |
| Skill Files | All work skills + ICP data files |
| Skill Structure | SKILL SUMMARY block in each skill, CLAUDE.md required sections |
| Isolation | Scans all `.md/.ts/.js/.json/.sh/.env` for forbidden cross-repo refs |
| MCP Servers | Source files (index, client, tool modules), TypeScript typecheck |
| Setup Script | MCP registration commands, npm install, credential safety |
| Installer Validation | Syntax, add_mcp function, all MCPs registered, docs sections |

## Hook Scripts

Three scripts in `~/.claude/hooks/`:

**`claude-context-updater.sh`**
- Fires on: `PostToolUse → Edit|Write`
- Path filter: `skills/*.md`, `.claude/hooks/*`, `CLAUDE.md`, `mcp/src/*.ts`, `configs/*`
- Action: Appends `## [date] — Auto: structural change` entry to `MEMORY.md`
- Debounce: skips if same basename logged in last 20 lines

**`test-suite-updater.sh`**
- Fires on: `PostToolUse → Edit|Write`
- Path filter: `skills/<dir>/<name>.md`, `mcp/<server>/src/<name>.ts`
- Action (skills): inserts `"<dir>/<name>"` into `SKILLS=()` array in `run-tests.sh` before closing `)`
- Action (MCP): inserts `assert_file_exists "<path>"` after last matching src/ assertion
- Repo detection: PersonalOS vs WorkOS by path, updates correct test file
- Idempotent: no-op if file already covered

**`remote-approver.sh`**
- Fires on: `PermissionRequest`
- Action: POSTs to ntfy.sh with HTTP action buttons (use a private topic name)
- Buttons POST `<id>:approve` or `<id>:deny` to a response topic
- Hook polls response topic every 3s with unique request ID matching
- Timeout: 90s → falls back to local Claude Code prompt
- Setup required: install ntfy.sh app, subscribe to your approval topic

---

← [Part 4: Quick Reference](PART4-QUICK-REFERENCE.md) | [Back to README](README.md)
