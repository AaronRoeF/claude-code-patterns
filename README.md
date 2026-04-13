# Claude Code Pattern Library

**153 techniques for getting the most out of Claude Code + VS Code — for power users, business operators, and anyone who wants to 10x their productivity.**

By the community | April 2026 | 153 techniques

> This is a community-maintained collection of real-world patterns, tips, and architectural decisions for Claude Code. Everything here has been tested in production setups. Contributions welcome — see the bottom of this file.

---

## How This Guide Is Organized

| Part | What's Inside | Count |
|------|-------------|-------|
| **[Part 1: What I'm Already Doing Well](#part-1-what-im-already-doing-well)** | Patterns from a real setup worth sharing | 11 |
| **[Part 2: Pro-Tips by Category](PART2-PRO-TIPS.md)** | 129 researched techniques in 15 categories, each rated Beginner / Intermediate / Advanced | 129 |
| **[Part 3: The AI Wiki Pattern](PART3-AI-WIKI.md)** | Building a persistent, compounding knowledge base with Claude Code + Obsidian (Karpathy's LLM Wiki, production-grade) | 13 |
| **[Part 4: Quick Reference](PART4-QUICK-REFERENCE.md)** | Cheat sheets, keyboard shortcuts, slash commands, MCP starter kit | — |
| **[Part 5: Implemented Patterns](PART5-IMPLEMENTED-PATTERNS.md)** | Live examples: hooks, test suites, and scripts actually running in production | — |

---

## Two Ways to Use This

**Browse it.** Read on GitHub, scan categories, click through to what interests you.

**Feed it to Claude.** Add this repo to your Claude Code context — Claude will reference these patterns when relevant. Point at specific parts for targeted guidance:
- `PART2-PRO-TIPS.md` for the full technique catalog
- `PART3-AI-WIKI.md` for building a persistent knowledge base
- `PART4-QUICK-REFERENCE.md` for cheat sheets and shortcuts

---

# Part 1: What I'm Already Doing Well

These are patterns from a live setup that are genuinely worth replicating. Each one represents real operational leverage.

## The "Two OS" Architecture

I run two separate repos, each with their own `CLAUDE.md`:
- **WorkOS** — work skills (meeting prep, memos, RFDs, PM methodology, voice ghostwriting, ICP evaluation, rhetorical analysis)
- **PersonalOS** — personal skills and compute (health data, iMessage relationship analysis, MCP servers)

**Why it matters:** Clean separation of concerns. Work context never bleeds into personal tools and vice versa. Each CLAUDE.md stays focused and under the ~300-line sweet spot.

**Pattern to copy:** If you have distinct domains (work vs. personal, or multiple projects), give each its own repo with its own CLAUDE.md rather than cramming everything into one.

## Trigger-Phrase Architecture

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

## Skills as Markdown Files with Reference Data

Each skill is a directory:
```
skills/meeting-prep/
├── meeting-prep.md    ← the skill (triggers, workflows, guardrails)
└── ref-tools.md       ← reference material (API docs, tool catalog)
```

**Why it matters:** The skill file tells Claude *what to do*. The ref file gives it *what it needs to know*. Progressive disclosure — Claude loads ref data only when the skill is triggered, not on every conversation.

**Pattern to copy:** Don't paste your entire API reference into CLAUDE.md. Put it in a ref file and tell Claude where to find it.

## MCP-First Data Gathering

My skills are designed to pull live data from every available source *before* producing output. The meeting-prep skill, for example:
- Pulls calendar events (Google Calendar MCP)
- Searches email threads (Gmail MCP)
- Researches attendees (Playwright MCP → LinkedIn)
- Pulls meeting transcripts (Granola MCP)
- Searches Notion for relevant docs
- Does web research on companies

**Why it matters:** The briefing is always richer than what I could assemble manually. Claude does in 30 seconds what would take me 15-20 minutes.

**Pattern to copy:** When building skills, list every data source Claude should pull from. Be explicit: "Search Gmail for threads with [attendee]. Search Notion for relevant docs. Web search [company] for recent news."

## Global MCP Configuration

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

## Confirmation Gates on Destructive Actions

My skills explicitly do NOT send emails, push Slack messages, or make calendar changes without confirmation. Claude drafts, I confirm.

**Why it matters:** I can let Claude operate with broad access (push to git, read all my email, access Slack) because the guardrails are in the *skills*, not the *permissions*. Trust but verify at the action boundary.

**Pattern to copy:** In your skill files, add explicit rules like: "Draft the Slack message and present it for approval. Do NOT send until the user confirms."

## Pre-Approved Permissions for Speed

My `settings.local.json` pre-approves dozens of commands:
- Safe git operations (log, status, diff, push to specific repos)
- npm/node commands for MCP servers
- Specific MCP tools (Jira search, iMessage read, Notion fetch)
- WebFetch for specific domains

**Why it matters:** Eliminates the "approve/deny" friction that makes Claude feel slow. Safe commands fly through instantly. Risky commands still prompt me.

**Pattern to copy:** Start with a small allowlist and expand it over time. Pre-approve `git log`, `git status`, `git diff`, and your test runner first.

## Structured Output to Defined Locations

- Analyses → `analyses/<firstname-lastname>.md`
- PM packages → `products/`
- RFDs → Notion database
- Meeting debriefs → Slack (after confirmation)

**Why it matters:** I always know where to find things. No ad hoc files scattered everywhere.

**Pattern to copy:** Define output locations in your skill files. "Save the analysis to `analyses/<name>.md`" ensures consistency.

## Environment-Aware Skills

Every skill documents what's available in Claude Code vs. Claude AI:
```
Claude Code: Google Drive MCP, Gmail MCP, Jira MCP, Slack MCP, Playwright...
Claude AI: Google Calendar (built-in), Email (built-in), Web search...
```

**Why it matters:** The same skills work in both environments. Claude gracefully degrades when a tool isn't available, following inline fallbacks.

**Pattern to copy:** If your skills need to work across environments, document what's available where and add fallback instructions.

## User Identity System

WorkOS detects who's using it (via `git config user.name`) and adapts:
- If the owner → use the ghostwriter voice for memos and posts
- If a team member → use professional prose, but can still invoke the ghostwriter to write *for* the owner

**Why it matters:** One skill set serves the entire team. No per-user configuration needed.

**Pattern to copy:** If multiple people share your CLAUDE.md, add identity detection. "Check `git config user.name` to determine the current user."

## Hook-Driven Self-Maintenance

The most durable environments don't need manual upkeep — the hooks keep them in sync. Three hooks run silently on every file edit:

- **`claude-context-updater.sh`** — when a skill, hook script, or MCP source file is modified, appends a timestamped note to `MEMORY.md` so the next session knows what changed
- **`test-suite-updater.sh`** — when a new skill or MCP source file is created, automatically inserts the corresponding `assert_file_exists` assertion into `run-tests.sh`, keeping test coverage current without manual edits
- **`remote-approver.sh`** — on any `PermissionRequest`, sends a push notification to phone via ntfy.sh with Approve/Deny action buttons; falls back to local prompt after 90 seconds

The result: add a new skill file → tests automatically cover it. Edit a hook → MEMORY.md logs it. Start a long autonomous task → approve permissions from your phone.

**Why it matters:** Maintenance work that requires developer attention compounds over time. Hooks that maintain the environment autonomously pay back immediately and permanently.

**Pattern to copy:** Think about what goes stale in your setup (tests, docs, logs) and write PostToolUse hooks that update them. Start with file existence tests — they're simple to auto-generate and prevent silent gaps.

---

## Key Sources

For full attribution, see [SOURCES.md](SOURCES.md).

- [Andrej Karpathy — LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — the pattern that inspired Part 3
- [Adventures in Claude](https://adventuresinclaude.ai/) — 35 posts on Claude Code workflows, learning loops, security patterns, and workflow state machines
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
   - Title as `### Pattern Name`
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
