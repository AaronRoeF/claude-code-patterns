← [Back to README](README.md) | [Part 1: Core Architecture](PART1-CORE-ARCHITECTURE.md) | [Part 2: Techniques](PART2-TECHNIQUES.md) | [Part 3: Build a Knowledge Base](PART3-BUILD-A-KNOWLEDGE-BASE.md) | **Part 4: Quick Reference** | [Part 5: Live Examples](PART5-LIVE-EXAMPLES.md)

---

# Part 4: Quick Reference

## Essential Keyboard Shortcuts (VS Code)

| Shortcut | Action |
|----------|--------|
| Cmd+Esc | Toggle focus between editor and Claude |
| Option+K | Insert @-mention from current selection |
| Shift+Tab (x2) | Enter Plan Mode |
| Cmd+T | Toggle extended thinking |
| Cmd+K, Cmd+S | Open keyboard shortcuts (search "Claude") |

## Essential Slash Commands

| Command | What It Does |
|---------|-------------|
| `/clear` | Wipe conversation, start fresh (CLAUDE.md persists) |
| `/compact` | Compress context (use at 70% capacity) |
| `/context` | Show token usage breakdown |
| `/cost` | Show session cost and token stats |
| `/model [name]` | Switch model (haiku, sonnet, opus, opusplan) |
| `/resume` | Restore a previous conversation |
| `/simplify` | Auto-review code for quality and efficiency |
| `/batch` | Parallel worktree operations |
| `/mcp` | Show MCP server status and token costs |
| `/permissions` | Audit all permission rules |
| `/hooks` | Manage automation hooks |
| `/memory` | View auto memory status |

## The MCP Starter Kit for Business Users

**Tier 1 — Start here:**
- **Gmail** — read/send email (`@gongrzhe/server-gmail-autoauth-mcp`)
- **Google Calendar** — events, scheduling (built-in Anthropic connector, or via Google Drive MCP)
- **Slack** — channels, messages, conversations (`slack-mcp-server`)
- **Notion** — docs, databases, search (built-in Anthropic connector)

**Tier 2 — Add when needed:**
- **Google Drive** — Drive, Docs, Sheets, Slides (`@piotr-agier/google-drive-mcp`)
- **Jira / Linear** — project management, issues, sprints
- **Playwright** — browser automation for web research (`@playwright/mcp`)
- **Granola** — meeting transcripts

**Tier 3 — Specialized:**
- **iMessage** — messaging history analysis (`imessage-mcp`)
- **Health APIs** — biometric data (Fitbit, Garmin, etc.)
- **GitHub** — issues, PRs, code search (use `gh` CLI directly or GitHub MCP)

## The 5-Minute Setup Checklist

1. **Install Claude Code** in VS Code (Extensions → search "Claude Code")
2. **Create CLAUDE.md** in your project root with: what the project is, key conventions, what NOT to do
3. **Add your first MCP** — start with `claude mcp add gmail` or Slack
4. **Set up permissions** — pre-approve `git log`, `git status`, `git diff` in settings
5. **Try a skill** — create `.claude/skills/daily-brief/SKILL.md` with a morning briefing workflow
6. **Run `/context`** — see how your token budget is being used and optimize

---

← [Part 3: Build a Knowledge Base](PART3-BUILD-A-KNOWLEDGE-BASE.md) | [Next: Part 5 — Live Examples](PART5-LIVE-EXAMPLES.md) | [Back to README](README.md)
