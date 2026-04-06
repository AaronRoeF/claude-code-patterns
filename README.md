# Claude Code Pattern Library

**106 techniques for getting the most out of Claude Code + VS Code — for power users, business operators, and anyone who wants to 10x their productivity.**

By the RoebotOS community | March 2026 | 106 techniques

> This is a community-maintained collection of real-world patterns, tips, and architectural decisions for Claude Code. Everything here has been tested in production setups. Contributions welcome — see the bottom of this file.

---

## How This Guide Is Organized

1. **What I'm Already Doing Well** — patterns from a real setup worth sharing
2. **Pro-Tips by Category** — 85 researched techniques, each rated Beginner / Intermediate / Advanced
3. **Quick Reference** — cheat sheets, keyboard shortcuts, and slash commands

---

# Part 1: What I'm Already Doing Well

These are patterns from a live setup that are genuinely worth replicating. Each one represents real operational leverage.

## 1. The "Two OS" Architecture

I run two separate repos, each with their own `CLAUDE.md`:
- **WorkOS** — work skills (meeting prep, memos, RFDs, PM methodology, voice ghostwriting, ICP evaluation, rhetorical analysis)
- **PersonalOS** — personal skills and compute (health data, iMessage relationship analysis, MCP servers)

**Why it matters:** Clean separation of concerns. Work context never bleeds into personal tools and vice versa. Each CLAUDE.md stays focused and under the ~300-line sweet spot.

**Pattern to copy:** If you have distinct domains (work vs. personal, or multiple projects), give each its own repo with its own CLAUDE.md rather than cramming everything into one.

## 2. Trigger-Phrase Architecture

Instead of slash commands or memorizing syntax, I use natural language triggers:

| I say... | Claude loads... |
|----------|----------------|
| "prep [name]" | meeting-prep skill → full meeting pre-brief |
| "draft a post" | ghostwriter skill → ghostwritten content |
| "PM a [concept]" | product-mgmt skill → 9-step Working Backwards process |
| "grade this" | content-review skill → rhetorical analysis |
| "health sleep" | health-tracker skill → sleep analysis |

**Why it matters:** Zero friction. I don't think about *tools* — I think about *outcomes*. Claude matches my intent to the right skill using LLM reasoning, not regex.

**Pattern to copy:** Write your skill descriptions as natural phrases people would actually say. "Create a deployment plan for staging or production" beats "Deploy stuff."

## 3. Skills as Markdown Files with Reference Data

Each skill is a directory:
```
skills/meeting-prep/
├── meeting-prep.md    ← the skill (triggers, workflows, guardrails)
└── ref-tools.md       ← reference material (API docs, tool catalog)
```

**Why it matters:** The skill file tells Claude *what to do*. The ref file gives it *what it needs to know*. Progressive disclosure — Claude loads ref data only when the skill is triggered, not on every conversation.

**Pattern to copy:** Don't paste your entire API reference into CLAUDE.md. Put it in a ref file and tell Claude where to find it.

## 4. MCP-First Data Gathering

My skills are designed to pull live data from every available source *before* producing output. The meeting-prep skill, for example:
- Pulls calendar events (Google Calendar MCP)
- Searches email threads (Gmail MCP)
- Researches attendees (Playwright MCP → LinkedIn)
- Pulls meeting transcripts (Granola MCP)
- Searches Notion for relevant docs
- Does web research on companies

**Why it matters:** The briefing is always richer than what I could assemble manually. Claude does in 30 seconds what would take me 15-20 minutes.

**Pattern to copy:** When building skills, list every data source Claude should pull from. Be explicit: "Search Gmail for threads with [attendee]. Search Notion for relevant docs. Web search [company] for recent news."

## 5. Global MCP Configuration

All 7+ MCP servers are configured globally in `~/.claude.json`, not per-project. They're available everywhere:

| Server | What It Does |
|--------|-------------|
| Google Drive | Drive, Docs, Sheets, Slides, Calendar |
| Gmail | Read/send email |
| Jira | Issues, projects, boards, sprints |
| Slack | Channels, messages, conversations |
| iMessage | 25 read-only tools for message history |
| Playwright | Browser automation (LinkedIn, web research) |
| Granola | Meeting transcripts |
| Notion | Search, fetch, create/update (built-in connector) |

**Why it matters:** No configuration drift. Every session has the same capabilities. I never think "do I have access to X?" — the answer is always yes.

**Pattern to copy:** Use `claude mcp add` to configure servers globally. Reserve per-project MCP for project-specific servers only.

## 6. Confirmation Gates on Destructive Actions

My skills explicitly do NOT send emails, push Slack messages, or make calendar changes without confirmation. Claude drafts, I confirm.

**Why it matters:** I can let Claude operate with broad access (push to git, read all my email, access Slack) because the guardrails are in the *skills*, not the *permissions*. Trust but verify at the action boundary.

**Pattern to copy:** In your skill files, add explicit rules like: "Draft the Slack message and present it for approval. Do NOT send until the user confirms."

## 7. Pre-Approved Permissions for Speed

My `settings.local.json` pre-approves dozens of commands:
- Safe git operations (log, status, diff, push to specific repos)
- npm/node commands for MCP servers
- Specific MCP tools (Jira search, iMessage read, Notion fetch)
- WebFetch for specific domains

**Why it matters:** Eliminates the "approve/deny" friction that makes Claude feel slow. Safe commands fly through instantly. Risky commands still prompt me.

**Pattern to copy:** Start with a small allowlist and expand it over time. Pre-approve `git log`, `git status`, `git diff`, and your test runner first.

## 8. Structured Output to Defined Locations

- Analyses → `analyses/<firstname-lastname>.md`
- PM packages → `products/`
- RFDs → Notion database
- Meeting debriefs → Slack (after confirmation)

**Why it matters:** I always know where to find things. No ad hoc files scattered everywhere.

**Pattern to copy:** Define output locations in your skill files. "Save the analysis to `analyses/<name>.md`" ensures consistency.

## 9. Environment-Aware Skills

Every skill documents what's available in Claude Code vs. Claude AI:
```
Claude Code: Google Drive MCP, Gmail MCP, Jira MCP, Slack MCP, Playwright...
Claude AI: Google Calendar (built-in), Email (built-in), Web search...
```

**Why it matters:** The same skills work in both environments. Claude gracefully degrades when a tool isn't available, following inline fallbacks.

**Pattern to copy:** If your skills need to work across environments, document what's available where and add fallback instructions.

## 10. User Identity System

WorkOS detects who's using it (via `git config user.name`) and adapts:
- If the owner → use the ghostwriter voice for memos and posts
- If a team member → use professional prose, but can still invoke the ghostwriter to write *for* the owner

**Why it matters:** One skill set serves the entire team. No per-user configuration needed.

**Pattern to copy:** If multiple people share your CLAUDE.md, add identity detection. "Check `git config user.name` to determine the current user."

## 11. Hook-Driven Self-Maintenance

The most durable environments don't need manual upkeep — the hooks keep them in sync. Three hooks run silently on every file edit:

- **`claude-context-updater.sh`** — when a skill, hook script, or MCP source file is modified, appends a timestamped note to `MEMORY.md` so the next session knows what changed
- **`test-suite-updater.sh`** — when a new skill or MCP source file is created, automatically inserts the corresponding `assert_file_exists` assertion into `run-tests.sh`, keeping test coverage current without manual edits
- **`remote-approver.sh`** — on any `PermissionRequest`, sends a push notification to phone via ntfy.sh with Approve/Deny action buttons; falls back to local prompt after 90 seconds

The result: add a new skill file → tests automatically cover it. Edit a hook → MEMORY.md logs it. Start a long autonomous task → approve permissions from your phone.

**Why it matters:** Maintenance work that requires developer attention compounds over time. Hooks that maintain the environment autonomously pay back immediately and permanently.

**Pattern to copy:** Think about what goes stale in your setup (tests, docs, logs) and write PostToolUse hooks that update them. Start with file existence tests — they're simple to auto-generate and prevent silent gaps.

---

# Part 2: Pro-Tips by Category

85 researched techniques organized into 15 categories. Each rated:
- **Beginner** — anyone can do this today
- **Intermediate** — requires some setup or familiarity
- **Advanced** — power-user territory

---

## Category 1: Writing Effective CLAUDE.md Files

### 1. Keep It Under 300 Lines
Your CLAUDE.md is loaded into every conversation. Long instruction files cause Claude to miss critical rules — shorter files get better adherence. Ruthlessly prune instructions for things Claude already does correctly. Focus only on rules where Claude's default behavior diverges from what you want.
**Level:** Beginner
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

### 2. Use Progressive Disclosure
Don't dump all information into CLAUDE.md. Tell Claude *how to find* information instead. Write `"For database schema details, read /docs/schema.md"` rather than pasting the entire schema.
**Level:** Intermediate
**Source:** [Builder.io Guide](https://www.builder.io/blog/claude-md-guide)

### 3. Use Emphasis for Critical Rules
Add `IMPORTANT:` or `YOU MUST` before non-negotiable instructions. But don't overuse it — if everything is "IMPORTANT," nothing is.
**Level:** Beginner
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

### 4. Use Multiple CLAUDE.md Files for Large Projects
Keep a general CLAUDE.md in your project root and add specific ones in sub-folders (`/frontend/CLAUDE.md`, `/api/CLAUDE.md`). Claude picks up the most relevant one based on which files it's working with.
**Level:** Intermediate
**Source:** [Builder.io Guide](https://www.builder.io/blog/claude-md-guide)

### 5. Structure as WHAT, WHY, HOW
Organize into three sections: WHAT (tech stack & project structure), WHY (project purpose), HOW (coding standards & conventions). Gives Claude a complete mental model.
**Level:** Beginner
**Source:** [Arize Blog](https://arize.com/blog/claude-md-best-practices-learned-from-optimizing-claude-code-with-prompt-learning/)

### 6. Check CLAUDE.md Into Git
Version-control your CLAUDE.md so your team can contribute. Treat it like code: review it when things go wrong, prune regularly, test whether changes actually shift behavior.
**Level:** Beginner
**Source:** [HumanLayer Blog](https://www.humanlayer.dev/blog/writing-a-good-claude-md)

---

## Category 2: Context Management

### 7. Use /clear Between Unrelated Tasks
Wipe conversation history when switching topics. Claude re-reads your CLAUDE.md and retains file access. Prevents "kitchen sink" sessions where mixing tasks degrades quality.
**Level:** Beginner

### 8. Use /compact at 70% Capacity
Manually run `/compact` when your context window reaches ~70%, rather than waiting for auto-compaction at 95%. You can focus it: `/compact Focus on the API changes`.
**Level:** Intermediate
**Source:** [MCPcat Guide](https://mcpcat.io/guides/managing-claude-code-context/)

### 9. Audit Context with /context
Run `/context` to see exactly how many tokens each component consumes — system prompt, MCP tools, memory, skills, conversation. MCP servers can consume 30%+ of your window before you type anything.
**Level:** Intermediate

### 10. Target 3-5 Files, Not Your Entire Project
Never bulk-load your whole project. Three to five targeted files yield better results than fifty files loaded at once. Use @-mentions to reference specific files.
**Level:** Beginner

### 11. Use Subagents to Preserve Main Context
Delegate exploration and research to subagents, which run in their own context windows. Keeps your main conversation clean and focused.
**Level:** Advanced
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/sub-agents)

### 12. Write Design Docs to Markdown Files
Instead of repeating complex instructions in conversation, write design docs and task lists to markdown files that Claude can reference on demand without consuming ongoing context.
**Level:** Intermediate

### 84. Reduce Defensive Checkpointing as Context Grows
With 1M token context, most workflows complete without compaction. Audit and eliminate elaborate recovery mechanisms (state snapshots, breadcrumb trails, mid-session save points) that were built for smaller windows — they're now overhead that costs tokens and adds complexity.
**Level:** Advanced
**Source:** [Adventures in Claude — One Million Tokens](https://adventuresinclaude.ai/posts/2026-03-14-one-million-tokens-and-four-commands-to-rewrite/)

### 85. Audit Old Patterns When Constraints Change
Sequential workarounds persist from old constraints. When context size increases 5x or a new feature drops, audit the entire dependency chain — checkpoint frequency, recovery mechanisms, context splitting strategies — for optimization candidates. What was necessary at 200K may be waste at 1M.
**Level:** Intermediate
**Source:** [Adventures in Claude — One Million Tokens](https://adventuresinclaude.ai/posts/2026-03-14-one-million-tokens-and-four-commands-to-rewrite/)

---

## Category 3: Slash Commands & Built-in Features

### 13. Plan Mode (Shift+Tab)
Press Shift+Tab twice to enter Plan Mode — Claude generates a plan without making changes. Review and approve before execution. Essential for multi-file or complex tasks.
**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/common-workflows)

### 14. /resume to Pick Up Where You Left Off
Browse and restore previous conversations with `/resume`, or start from terminal with `claude --continue` to immediately continue your last session.
**Level:** Beginner

### 15. /simplify After Completing Features
Spawns three specialized review agents that check for reuse opportunities, quality issues, and efficiency improvements. An automated code review pipeline.
**Level:** Intermediate

### 16. /batch for Parallel Worktree Operations
Spawns agents in isolated worktrees and creates PRs automatically. Good for parallelizing independent tasks.
**Level:** Advanced

### 17. /model to Switch Models Mid-Session
`/model haiku` for quick tasks (2x faster, 3x cheaper). `/model opus` for complex reasoning. `/model opusplan` uses Opus for planning and Sonnet for execution.
**Level:** Intermediate

### 18. /cost to Track Token Spending
See detailed token usage, total cost, API duration, and code changes for your current session.
**Level:** Beginner

### 19. /install-github-app for Automated PR Reviews
Set up Claude as an automated PR reviewer that launches 4 review agents in parallel, scores issues by confidence, and posts comments. Trigger with `@claude` on any PR.
**Level:** Intermediate
**Source:** [Claude Code GitHub Actions](https://code.claude.com/docs/en/github-actions)

---

## Category 4: Hooks (Automated Triggers)

### 20. Auto-Format Code After Every Edit
Set up a PostToolUse hook that runs your formatter (prettier, gofmt) automatically after every file write or edit. Run `/hooks` to set up.
**Level:** Intermediate
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/hooks)

### 21. Block Writes to Sensitive Files
PreToolUse hook that blocks writes to `.env`, production configs, or `.git`. Exits with code 2 to prevent the action — deterministic safety net.
**Level:** Advanced

### 22. Inject Context at Session Start
SessionStart hook that loads recent tickets, coding checklists, or project status into every new conversation automatically.
**Level:** Advanced

### 23. Run Tests After Code Changes
PostToolUse hook that runs your test suite after every code edit. Catches regressions immediately.
**Level:** Intermediate

### 24. HTTP Hooks for External Integrations
POST JSON to a URL and receive JSON back — integrate with Slack notifications, logging platforms, or custom APIs.
**Level:** Advanced

### 25. MCP Audit Logging
PostToolUse hook on Gmail, Slack, and Google Drive that logs every external action with timestamp, tool name, and key parameters (to, subject, channel, fileId). Creates a paper trail at `~/.claude/mcp-audit.log` for accountability and debugging.
**Level:** Intermediate

### 26. Post-Compact Context Reload
SessionStart hook with `compact` matcher that re-injects current git branch, recent commits, active projects, and context management rules after `/compact`. Prevents the "Claude forgets everything" problem that makes compaction feel lossy.
**Level:** Intermediate

### 27. Block Destructive Commands
PreToolUse hook on Bash that checks for `git push --force`, `git reset --hard`, `rm -rf`, and `DROP TABLE`. Exit code 2 blocks the action deterministically — can't be reasoned around like an instruction in CLAUDE.md.
**Level:** Advanced

### 28. Auto-Update MEMORY.md on Structural Changes
PostToolUse hook (`Edit|Write`) that watches for edits to skills, hook scripts, MCP source files, and CLAUDE.md. When a match fires, it appends a timestamped entry to `MEMORY.md` — so the *next* session automatically knows what was recently modified without you having to remember to log it. Debounced to prevent duplicate entries for rapid edits.
**Level:** Intermediate
**Script:** `~/.claude/hooks/claude-context-updater.sh`

### 29. Mobile Permission Approvals via ntfy.sh
`PermissionRequest` hook that forwards every Claude permission prompt to your phone as a push notification via [ntfy.sh](https://ntfy.sh). The notification includes Approve/Deny action buttons — tapping one sends the decision back via ntfy's HTTP action API, which the hook polls every 3 seconds. Falls back to the local prompt after 90 seconds. Zero server required — ntfy.sh is the relay. Setup: install the ntfy.sh app and subscribe to a private topic.
**Level:** Advanced
**Script:** `~/.claude/hooks/remote-approver.sh`

### 30. Auto-Sync Test Suite on Skill/MCP Changes
PostToolUse hook (`Edit|Write`) that detects new skill markdown files or MCP TypeScript source files. When a file is created that lacks test coverage, it automatically inserts the appropriate assertion into `run-tests.sh` — either into the `SKILLS=()` array or after the last `assert_file_exists` for that MCP server. Uses `awk` for atomic file writes. Idempotent — re-running for the same file is a no-op.
**Level:** Advanced
**Script:** `~/.claude/hooks/test-suite-updater.sh`

### 86. Circuit Breakers via Disk-Based State
Block irreversible actions (git push, email send) at the session-file level, not just via CLAUDE.md instructions. Write a state file (e.g., `.claude-session/TICKET-XXX.json`) that tracks whether the plan was approved. Even if context compaction causes amnesia, the disk-based gate still enforces the approval requirement. Instructions can be reasoned around; file checks cannot.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### 87. Post-Commit TIL Capture Hook
A lighter counterpart to the session-end TIL hook. PostToolUse hook on Bash that detects `git commit` commands and nudges: "Anything surprising in this commit?" Only fires if fewer than 3 observations captured today (quality over quantity). The compact hook does the full scan; this one catches learnings while the commit context is still fresh.
**Level:** Intermediate
**Script:** `~/.claude/hooks/commit-til-capture.sh`

---

## Category 5: Skills (Reusable Workflows)

### 28. Create Skills for Repetitive Tasks
Build custom skills (`SKILL.md` files in `.claude/skills/`) for any task you do repeatedly. Markdown-based instructions with YAML frontmatter.
**Level:** Intermediate
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/skills)

### 29. Use disable-model-invocation for Dangerous Skills
Set `disable-model-invocation: true` in skill frontmatter to prevent Claude from accidentally triggering destructive skills (deploy, send emails). Only explicit slash commands invoke these.
**Level:** Intermediate

### 30. Write Strong Trigger Descriptions
Claude uses LLM reasoning (not regex) to decide which skill to invoke. Write descriptions like "Create a deployment plan for staging or production" rather than "Deploy stuff."
**Level:** Intermediate

### 31. Install Office Document Skills
Install skills for DOCX, PDF, PPTX, and XLSX to create professional documents through natural language. "Create a PowerPoint about Q1 results."
**Level:** Beginner
**Source:** [GitHub - claude-office-skills](https://github.com/tfriedel/claude-office-skills)

### 32. Build a Daily Briefing Skill
Pull from Calendar, Gmail, Slack, and Notion to generate a personalized morning briefing. Reduces 30 minutes of planning to 2 minutes.
**Level:** Advanced
**Source:** [Claude Resources](https://claude.com/resources/use-cases/build-a-daily-briefing-across-your-tools)

### 88. Bootstrap Prompt Under 2,000 Tokens
A small bootstrap prompt that teaches Claude to search for and follow relevant skill files intercepts the impulse to jump straight to coding. The key behavior: brainstorming before implementation (Socratic design questions, architecture alternatives) and verification before handoff (run tests, confirm output). Keeps the always-loaded instruction budget tiny while the skills handle domain depth.
**Level:** Advanced
**Source:** [Adventures in Claude — Two Thousand Tokens of Discipline](https://adventuresinclaude.ai/posts/two-thousand-tokens-of-discipline/)

### 89. TDD Enforcement via Skill File
A skill that forces restart if implementation precedes test creation. Red-green-refactor without negotiation. The skill checks whether test files exist before allowing implementation code to be written. Unlike a CLAUDE.md instruction (which can be reasoned around), a skill with explicit step ordering is harder to skip.
**Level:** Advanced
**Source:** [Adventures in Claude — Two Thousand Tokens of Discipline](https://adventuresinclaude.ai/posts/two-thousand-tokens-of-discipline/)

### 90. Parameterized Skills for Portability
Externalize hardcoded values (API keys, workspace IDs, brand voices, output paths) into configuration files rather than embedding them in skill markdown. The same skill then works across different companies, teams, or personal contexts. Claude Code's directory-scoped isolation means the config file naturally scopes which values get loaded.
**Level:** Intermediate
**Source:** [Adventures in Claude — Treasure Troves and Portable Companies](https://adventuresinclaude.ai/posts/2026-02-22-dev-diary/)

---

## Category 6: MCP (Model Context Protocol)

### 33. Start with High-Value MCP Servers
For business users, prioritize: GitHub (issues/PRs), Slack (communication), Notion/Confluence (docs), Jira/Linear (project management). Use `claude mcp add` with appropriate auth.
**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/mcp)

### 34. Disable Unused MCP Servers Per Session
MCP tool definitions consume tokens just by being available. Run `/mcp` to see per-server token costs and disable servers you aren't using.
**Level:** Intermediate

### 35. MCP Tool Search Loads Tools On-Demand
When you have many MCP servers, Claude Code automatically loads tools on-demand (via ToolSearch) instead of preloading all of them — reducing token overhead by ~85%. This activates automatically.
**Level:** Intermediate

### 36. Use Environment Variables for Tokens
Configure auth via environment variables rather than hardcoding in config files. Prevents accidental key exposure.
**Level:** Beginner

### 37. The 3-Point MCP Debug Check
90% of MCP errors are resolved by checking: (1) the binary is accessible, (2) the token is valid, (3) the network port is open.
**Level:** Beginner

### 104. Follow the MCP Spec for Tool Definitions
Every tool must include `name`, `title` (human-readable), `description`, and `inputSchema` (with `additionalProperties: false`). Add `outputSchema` for tools with structured responses. These aren't optional decorations — they're what the LLM reads to decide tool selection and validate responses. Early servers often ship without `title` and `outputSchema`. New servers should follow the spec from day one; existing servers should get a backfill pass.
**Level:** Intermediate
**Source:** [MCP Specification — Tools](https://modelcontextprotocol.io/specification/2025-11-25/server/tools.md)

### 105. SQLite for Reads, JXA Only for Writes
For macOS app MCP servers, default to reading the app's SQLite database directly (sub-ms, works when the app is closed, handles search well) and reserve JXA/AppleScript only for operations that require app interaction (creating items, marking complete). The URL scheme (`app:///verb?params`) is a reliable middle ground for creates/updates. This minimizes brittleness — JXA depends on the scripting bridge, which Apple doesn't actively maintain and can break across macOS versions.
**Level:** Advanced

### 106. Register MCP Servers via CLI, Not Manual JSON Edits
Use `claude mcp add -s user` instead of hand-editing `~/.claude.json`. The CLI handles format validation, scope, and transport type. Manual edits risk malformed JSON that silently fails at session start.
**Level:** Beginner
**Source:** [Claude Code Docs — MCP](https://code.claude.com/docs/en/mcp)

---

## Category 7: VS Code Integration

### 38. @-Mentions with Line Ranges
Type `@file.ts#5-10` to reference specific line ranges. Press **Option+K** (Mac) to insert an @-mention from your current editor selection.
**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/vs-code)

### 39. Automatic Selection Detection
Select text in VS Code → Claude sees your highlighted code automatically. The prompt box footer shows how many lines are selected. No copy-paste needed.
**Level:** Beginner

### 40. Cmd+Esc to Toggle Focus
Toggle between your code editor and Claude's prompt box. Rapid back-and-forth without the mouse.
**Level:** Beginner

### 41. Sidebar vs. Panel Placement
Use Cmd+Shift+P → search "Claude Code" to move between sidebar (like file explorer) and panel (bottom). Sidebar enables side-by-side workflow.
**Level:** Beginner

### 42. Cmd+T for Extended Thinking
Toggle extended thinking for complex reasoning. Significantly improves quality for architectural decisions, debugging, and complex problems.
**Level:** Intermediate

### 43. Customize Keyboard Shortcuts
Cmd+K, Cmd+S → search "Claude" to see all available commands and rebind them.
**Level:** Beginner

---

## Category 8: Permission Management & Security

### 44. Create a Targeted Allowlist
Define specific allowed tools in `.claude/settings.json`. Pre-approve safe commands (`git log`, `npm test`, `git diff`) while keeping risky operations on "Ask."
**Level:** Intermediate
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/permissions)

### 45. Use Deny Rules for Destructive Commands
Explicit deny for `rm -rf`, `git push --force`, `npm publish`. Deny always takes precedence over allow.
**Level:** Intermediate

### 46. Project-Level vs. Local Settings
`.claude/settings.json` (in git) for team-shared rules. `.claude/settings.local.json` (gitignored) for personal preferences.
**Level:** Intermediate

### 47. Sandbox Restrictions
Claude Code's built-in sandbox prevents Bash commands from reaching resources outside defined boundaries. For maximum isolation, run in Docker.
**Level:** Advanced

### 48. Review Shell Commands Before Authorizing
Stay in Normal Mode for important work. Only use Auto-Accept for low-risk tasks on feature branches with recent commits.
**Level:** Beginner

### 83. Approval Gates for Sensitive Content in Skills
In operational skills (meeting briefs, recaps, memos), add a guardrail that detects sensitive content before it reaches any output — HR/personnel matters, unannounced deals, confidential strategy — then stops, issues a named warning (`WARNING: You are about to include HR-related or sensitive information.`), lists each instance, and requires per-item approval. This prevents private information from leaking into Slack recaps, email drafts, or briefs without the user noticing. The gate fires on *detection*, not on a general "be careful" instruction — so it works even when context is rich and the model has plausible reasons to include the information. Add the rule to both your global CLAUDE.md (all skills) and the highest-risk individual skill (meeting-prep, memo-writer, etc.) for defense in depth.
**Level:** Advanced

### 91. URL-Parser Validation Over String Checks
For redirect validation, login callbacks, and any user-controlled URL handling: use `new URL(path, "https://placeholder.invalid")` instead of string prefix checks like `startsWith("/")`. String checks miss backslash bypasses (`\evil.com`), protocol-relative tricks (`//evil.com`), and encoded characters. Build it once as a shared utility (`isSafeRelativeRedirect()`) at the platform level so every app uses the same defense.
**Level:** Advanced
**Source:** [Adventures in Claude — Sixty Tickets and a Backslash](https://adventuresinclaude.ai/posts/sixty-tickets-and-a-backslash/)

### 92. Error Message Sanitization for Auth Flows
Replace verbose error messages in redirect URLs with opaque codes. `?error=Token+has+expired` leaks implementation details via Referer headers to any downstream page. Use `?error=auth_error` instead — map codes to user-facing messages on the client side. Apply to every redirect that carries error state.
**Level:** Intermediate
**Source:** [Adventures in Claude — Friday Night Fun](https://adventuresinclaude.ai/posts/friday-night-fun/)

---

## Category 9: Agent Orchestration & Parallel Work

### 49. Git Worktrees for Parallel Sessions
Run multiple Claude sessions in parallel, each in its own git worktree with an isolated branch and filesystem. No branch-switching overhead.
**Level:** Advanced

### 50. Agent Teams (3-5 Teammates)
Start with 3-5 teammates. Give each rich context about the project and their specific goal. Teammates can message each other (unlike subagents). Enable with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.
**Level:** Advanced
**Source:** [Addy Osmani](https://addyosmani.com/blog/claude-code-agent-teams/)

### 51. Subagents for Quick, Focused Work
Use subagents (not agent teams) for quick tasks that complete and report back. Simpler, faster, fewer tokens than full agent teams.
**Level:** Intermediate

### 52. Background Agents (Ctrl+B)
Move a running agent to the background and continue working. See status, token usage, and progress.
**Level:** Intermediate

### 53. Give Each Agent a Narrow Scope
LLMs perform worse as context expands. Narrow scope + clean context = better reasoning, independent quality checks, and graceful degradation.
**Level:** Advanced

### 93. Run Quality Gates Concurrently
Type-checking, linting, and tests are independent — run them in parallel rather than sequentially. Saves 20-30 seconds per commit cycle. Use explicit `--concurrency` flags or separate Bash calls. Apply the same principle to review agents: spawn them in parallel, merge findings.
**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### 94. Three-Level Review Triage
Classify commits by risk to avoid wasteful reviews: **NONE** (docs, tests, config changes), **LIGHT** (under 10 files), **FULL** (10+ files or sensitive paths like auth, middleware, migrations). Path-based overrides force full review for security-critical files regardless of file count. Implement as a pre-commit skill or hook.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### 95. Simplify Before Review
Run a "simplify pass" (extract utilities, remove redundancy, clean up imports) *before* launching review agents. Review agents then see cleaner code and their findings don't reference already-refactored patterns. Order matters: simplify → review → commit.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### 96. Autonomous Ticket Chains
For batch refactoring work, run chains of independent tickets where each promotes app-specific code to shared platform libraries. Auto-approve plans and auto-commit between tickets. Works best when tickets are truly independent and the pattern is mechanical (e.g., extracting duplicated utilities).
**Level:** Advanced
**Source:** [Adventures in Claude — Forty-Three Tickets and a Cancer App](https://adventuresinclaude.ai/posts/2026-02-17-dev-diary/)

---

## Category 10: Memory & Persistence

### 54. Auto Memory for Cross-Session Learning
Claude accumulates knowledge across sessions: build commands, debugging insights, architecture notes, code style, workflow habits. Verify with `/memory`.
**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/memory)

### 55. Subagent MEMORY.md
Give subagents a memory directory. The first 200 lines of MEMORY.md are injected into the agent's system prompt on every run, building knowledge over time.
**Level:** Advanced

### 56. --continue for Momentum
`claude --continue` picks up your last conversation with all context preserved. `claude --resume <session-id>` for a specific session.
**Level:** Beginner

### 57. Project Plans in Your Knowledge Base, Not Hidden Dirs
Claude Code stores plans in `.claude/plans/` with auto-generated names like `peaceful-imagining-kite.md`. These are invisible in Finder and VS Code. Instead, store active project plans in a visible repo with lifecycle prefixes: `wip-installer-plan.md` while building, rename to `ref-` when done. Link from MEMORY.md so Claude finds them across sessions. The `.claude/` files still exist (Claude manages those), but your authoritative version lives where you can browse it.
**Level:** Intermediate

### 97. Persist Workflow State to Disk
Store workflow progress in session state files (e.g., `.claude-session/TICKET-XXX.json`) tracking current step, status, target directory, and approval gates. The filesystem is reliable; context memory is not. After compaction, Claude can read the state file to resume exactly where it left off. Separate plan tracking (checkbox markdown) from session metadata (JSON).
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### 98. Symlink MEMORY.md Across Worktrees
When running parallel Claude sessions in git worktrees, symlink MEMORY.md so every session starts with identical institutional knowledge. Without this, worktree-specific MEMORY.md copies drift apart as different sessions learn different things.
**Level:** Intermediate
**Source:** [Adventures in Claude — Supermemory Evaluation](https://adventuresinclaude.ai/posts/2026-02-17-supermemory-evaluation/)

### 58. Self-Improving Learning Loop (Capture → Graduate)

Auto memory captures individual learnings, but it can't spot *patterns across sessions*. Build a two-phase learning loop:

**Phase 1 — Capture:** Write raw observations to daily files (`observations/YYYY-MM-DD.md`) during or after each session. Categorize each entry: `mcp`, `skill`, `claude`, `code`, `workflow`, `product`, `meta`. Claude proposes TIL candidates based on what it observed in the session — corrections, surprises, MCP gotchas, approaches that worked. You approve/edit.

**Phase 2 — Graduate:** Periodically review accumulated observations, group by theme, and score cross-day repetition. One day = anecdote (skip). Two days = pattern (watch). Three+ separate days = graduation candidate. Promote graduated patterns into permanent rules: CLAUDE.md, skill files, learnings.md, or MEMORY.md. Graduation is always human-approved.

**The key insight:** Rules that describe *what failure looks like at the moment you're about to write it* prevent more errors than rules describing correct behavior. "Use `prop?: T | undefined`" is weaker than "When you see `exactOptionalPropertyTypes` error on a generic constraint, the fix is adding `| undefined` to the constraint."

**Hook implementation:** Attach a shell script to `SessionStart` compact so the TIL prompt fires at natural session boundaries — right after `/compact`, when context is about to be lost.

```json
// ~/.claude/settings.json — add to existing SessionStart compact hooks array
{
  "type": "command",
  "command": "/path/to/til-reminder.sh"
}
```

The script should:
- Count today's observations and total unreviewed observations
- Track days since last graduation review
- Instruct Claude to PROPOSE 2-5 TILs (not ask the user to provide them)
- Trigger a `learn review` recommendation when thresholds are hit (30+ unreviewed observations, 7+ days since last review, or 15+ with no review ever)
- Trigger a `learn validate` reminder when a graduation is 7+ days old and hasn't been validated — the "trust but verify" cycle

**The full loop:** Capture → Accumulate → Graduate → Validate → (revise if ineffective) → back to Capture. All three checkpoints (TIL capture, review recommendation, validation reminder) fire from the same hook at the right time based on thresholds.

**Graduation targets by pattern type:**

| Pattern Type | Target File |
|---|---|
| Claude errors | `learnings.md` (self-calibrating log) |
| MCP gotchas | `CLAUDE.md` or relevant skill file |
| Skill failure modes | The relevant skill file |
| Cross-session guardrails | `MEMORY.md` |
| Workflow patterns | `CLAUDE.md` |

**Post-graduation validation:** 7 days after a graduation, the hook prompts `learn validate`. This checks each graduated rule: Is it still present in the target file? Is it being applied (no repeat failures)? Is it being ignored (same correction happening again)? Ineffective rules get revised or moved to a more prominent location. Validation is logged in REVIEW-LOG.md so the hook knows not to nag again.

**Level:** Advanced
**Source:** [Adventures in Claude](https://adventuresinclaude.ai/posts/one-hundred-forty-observations-and-a-dog-name/)

---

## Category 11: Prompt Engineering

### 59. The 4-Block Prompt Pattern
Structure complex prompts: INSTRUCTIONS (what to do), CONTEXT (background), TASK (specific request), OUTPUT FORMAT (desired result shape). Reduces iterations by ~60%.
**Level:** Intermediate

### 60. Be Explicit About Actions
"Change this function to improve performance" vs. "Can you suggest some changes?" — Claude is trained for precise instruction following.
**Level:** Beginner

### 61. Specify Target Files and Constraints
"Fix the auth timeout bug in `/src/auth/login.ts` — we use JWT tokens with 24-hour expiry" beats "Fix the login bug."
**Level:** Beginner

### 62. Iterate in 2-3 Cycles Maximum
The sweet spot is 2-3 feedback cycles. Beyond that, use `/clear` and restart with a refined prompt.
**Level:** Intermediate

### 63. Start Simple, Add Complexity Only When Needed
Longer prompts are NOT always better. Start with one sentence and add constraints only when results need improvement.
**Level:** Beginner

### 64. Explore → Plan → Implement
Follow Claude's natural three-phase workflow. Skipping exploration significantly increases the risk of undo. Start with "Explore this and tell me how it works" before asking for changes.
**Level:** Intermediate

### 99. Markdown as State Machine for Workflows
Structure workflow instructions as numbered decision trees with explicit branching, not prose paragraphs. Step numbers provide unambiguous control flow: "Step 3: If ticket has comments containing 'bug' or 'regression', go to Step 3a. Otherwise, Step 4." Claude follows numbered steps more reliably than prose because the structure eliminates ambiguity about ordering and branching.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

---

## Category 12: Business User Workflows

### 65. Claude Cowork for Non-Technical Tasks
Claude Desktop's Cowork mode provides the same agent without requiring a terminal. Draft documents, analyze data, reorganize files, manage invoices. Available on all paid plans.
**Level:** Beginner
**Source:** [Claude Cowork](https://claude.com/product/cowork)

### 66. Process Meeting Notes Automatically
Point Claude at meeting transcripts → get action-items organized by owner, priority, and due date. Reduces 15-30 minutes to 2 minutes.
**Level:** Intermediate

### 67. Headless Mode for Automation
`claude -p "your prompt"` runs non-interactively as a Unix utility. Compatible with pipes: `cat data.csv | claude -p "Analyze trends" --output-format json`
**Level:** Advanced
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/headless)

### 68. Content Creation Pipelines
Use skills and MCPs together: research topics → draft content → format for platforms → schedule distribution. Connect Notion (content DB), Google Drive (storage), Slack (distribution).
**Level:** Advanced

### 69. Multi-Tool Research
Create a skill that combines web search, Playwright (for sites requiring browser automation), and Notion (for internal knowledge) to produce comprehensive research reports.
**Level:** Advanced

### 100. Capture Edit Diffs for Voice Learning
At publish time, automatically diff Claude's draft against the human's final edited version. The edits reveal voice preferences, structural habits, and phrasing patterns that improve future drafts. Store diffs as training data for voice-matching skills. Over time, the gap between draft and final version should shrink.
**Level:** Advanced
**Source:** [Adventures in Claude — Voice Learning via Edit Diffs](https://adventuresinclaude.ai/posts/2026-02-17-dev-diary/)

---

## Category 13: Cost Optimization

### 70. The opusplan Model Alias
`/model opusplan` uses Opus for planning/reasoning and Sonnet for code execution. Opus-quality thinking at Sonnet execution costs.
**Level:** Intermediate

### 71. Haiku for Quick Tasks
`/model haiku` for simple queries, boilerplate, and routine tasks. 90% of Sonnet capability at 2x speed and 3x cost savings.
**Level:** Beginner

### 72. Refresh After Major Milestones
Use `/clear` after completing features or merging PRs. Long sessions accumulate context that makes everything slower and more expensive.
**Level:** Beginner

---

## Category 14: Common Pitfalls

### 73. Don't Trust Auto-Accept for Complex Tasks
Auto-accept bypasses human review. Use only on feature branches with recent commits, never on main/production.
**Level:** Beginner

### 74. Always Verify Output
Claude may produce plausible-looking code that doesn't handle edge cases. Run tests, review diffs, and check edge cases before committing.
**Level:** Beginner

### 75. Don't Skip the Explore Phase
Let Claude explore before it changes things. Exploration reveals patterns, dependencies, and constraints that affect implementation.
**Level:** Beginner

### 76. Avoid "Kitchen Sink" Sessions
Starting with one task, asking something unrelated, then going back degrades quality for everything. Use `/clear` between topics.
**Level:** Beginner

### 77. Don't Over-Specify CLAUDE.md
If Claude keeps ignoring a rule, the file is probably too long. The fix is pruning, not adding more emphasis. A bloated CLAUDE.md is worse than none.
**Level:** Intermediate

### 78. Watch for Large Stdin Limitations
Headless mode may return empty output with ~7,000+ character stdin input. For large documents, use file-based input (@-mentions) instead.
**Level:** Intermediate

### 101. Inspect Data Before Hypothesizing
For data-dependent bugs, examine actual data first — don't theorize about code paths. Claude defaults to reasoning about code rather than observing data flow. Explicitly instruct: "dump the field values at each pipeline stage before suggesting a fix." Add diagnostic logging early. Run with real data once. One production data inspection often solves bugs faster than 10 hours of code-path reasoning.
**Level:** Intermediate
**Source:** [Adventures in Claude — The Bug That Was Right in Front of Me](https://adventuresinclaude.ai/posts/the-bug-that-was-right-in-front-of-me/)

### 102. Snapshot-Based Regression Testing for Data Pipelines
Take snapshots of algorithm outputs against production data and commit as baselines. Wire into pre-commit hooks to force review when outputs change. Catches silent behavioral regressions that unit tests miss — especially in ranking, scoring, or transformation logic where "correct" is defined by expected output, not by code structure.
**Level:** Advanced
**Source:** [Adventures in Claude — Snapshots and Dead Code](https://adventuresinclaude.ai/posts/2026-02-25-dev-diary/)

### 103. Documentation Accuracy Audits
Periodically verify that docs match actual code behavior. Incorrect docs are worse than missing docs — they create false confidence that leads to security vulnerabilities and integration bugs. Build a skill or checklist that cross-references README claims, API docs, and inline comments against what the code actually does.
**Level:** Intermediate
**Source:** [Adventures in Claude — Sixty Tickets and a Backslash](https://adventuresinclaude.ai/posts/sixty-tickets-and-a-backslash/)

---

## Category 15: Latest Features (2025-2026)

### 79. Shared Configs Across Worktrees
Project configs and auto memory automatically share across git worktrees of the same repo. Consistent settings across parallel agents.
**Level:** Intermediate

### 80. Custom Status Line
Install a custom status line showing current model, git branch, uncommitted file count, sync status, and a visual context usage progress bar.
**Level:** Advanced
**Source:** [ykdojo/claude-code-tips](https://github.com/ykdojo/claude-code-tips)

### 81. Container Mode for Safe Experimentation
Run Claude Code in Docker with `--dangerously-skip-permissions` for fully autonomous experimentation in isolated environments. Never on your actual system.
**Level:** Advanced

### 82. 200+ Environment Variables
Claude Code supports 200+ env vars (only ~50 documented). Control API endpoints, model selection, privacy, experimental features, and session parameters.
**Level:** Advanced
**Source:** [Eesel Blog](https://www.eesel.ai/blog/environment-variables-claude-code)

### 83. /permissions to Audit Rules
List all permission rules and see which settings.json they're sourced from. Debug unexpected permission behavior.
**Level:** Intermediate

---

# Part 3: Quick Reference

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

---

# Part 4: Implemented Patterns — Live Examples

What's actually running in a production setup, as of March 2026. Not aspirational — deployed.

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

## Key Sources

- [Adventures in Claude](https://adventuresinclaude.ai/) — 22 posts on Claude Code workflows, learning loops, security patterns, and workflow state machines
- [Claude Code Official Docs](https://code.claude.com/docs/en/best-practices)
- [Builder.io — How to Write a Good CLAUDE.md](https://www.builder.io/blog/claude-md-guide)
- [HumanLayer — Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [Arize — CLAUDE.md Best Practices](https://arize.com/blog/claude-md-best-practices-learned-from-optimizing-claude-code-with-prompt-learning/)
- [SFEIR Institute — Claude Code Courses](https://institute.sfeir.com/en/claude-code/)
- [Addy Osmani — Claude Code Agent Teams](https://addyosmani.com/blog/claude-code-agent-teams/)
- [MCPcat — Managing Context](https://mcpcat.io/guides/managing-claude-code-context/)
- [ykdojo/claude-code-tips](https://github.com/ykdojo/claude-code-tips)
- [DataCamp — Claude Code Hooks Tutorial](https://www.datacamp.com/tutorial/claude-code-hooks)
- [Claude Cowork](https://claude.com/product/cowork)
- [MCP Specification — Tools](https://modelcontextprotocol.io/specification/2025-11-25/server/tools.md) — official tool definition requirements, error handling, naming rules

---

## Contributing

This pattern library is a living document. If you've discovered a technique that makes Claude Code significantly more effective, we'd love to include it.

**How to contribute:**

1. **Fork this repo** and create a branch
2. **Add your pattern** in the appropriate category, following the existing format:
   - Title as `### N. Pattern Name`
   - 2-4 sentence explanation of what it does and why it matters
   - `**Level:**` rating (Beginner / Intermediate / Advanced)
   - `**Source:**` link if applicable
3. **Submit a PR** with a brief description of the pattern and how you've used it

**Guidelines:**
- Patterns should be tested in real workflows, not theoretical
- Include the difficulty level — this helps readers prioritize
- Link to sources where possible so readers can go deeper
- Keep explanations concise: what it does, why it matters, how to set it up
- Genericize any personal or company-specific details

**What we're looking for:**
- Novel hook configurations
- Creative skill architectures
- MCP server patterns and gotchas
- Cost optimization strategies
- Multi-agent orchestration patterns
- Security and permission patterns
