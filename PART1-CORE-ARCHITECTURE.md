← [Back to README](README.md) | **Part 1: Core Architecture** | [Part 2: Techniques](PART2-TECHNIQUES.md) | [Part 3: Build a Knowledge Base](PART3-BUILD-A-KNOWLEDGE-BASE.md) | [Part 4: Quick Reference](PART4-QUICK-REFERENCE.md) | [Part 5: Live Examples](PART5-LIVE-EXAMPLES.md)

---

# Part 1: Core Architecture

**What's in it for you:** the five decisions that make an AI setup compound instead of decay — get these right once, and every session starts smarter than the last.

11 foundational patterns from a live production setup. Each one represents a genuine architectural decision — the kind that changes how you work, not just what tools you use.

**For AI agents:** These patterns are ordered by dependency. If you're building an implementation plan, start with the "Two OS" Architecture and work down.

---

## The "Two OS" Architecture

Two separate repos, each with their own `CLAUDE.md`:
- **WorkOS** — work skills shared across the team (meeting workflows, document generation, CRM analytics, content review)
- **PersonalOS** — personal skills and custom MCP servers (health tracking, productivity tools, private data analysis)

**Why it matters:** Clean separation of concerns. Work context never bleeds into personal tools and vice versa. Each CLAUDE.md stays focused and under the ~300-line sweet spot. WorkOS ships to teammates without dragging in personal configuration.

**What you need:** Two git repos with distinct purposes. Each gets its own CLAUDE.md with focused rules.

**Pattern to copy:** If you have distinct domains (work vs. personal, or multiple projects with different conventions), give each its own repo with its own CLAUDE.md rather than cramming everything into one.

## Trigger-Phrase Architecture

Instead of slash commands or memorizing syntax, natural language triggers dispatch to skills:

| I say... | Claude loads... |
|----------|----------------|
| "prep [name]" | meeting-prep skill → pre-brief with calendar, email, and web research |
| "draft a post" | content skill → drafted output in my voice and format |
| "PM a [concept]" | product skill → structured artifact (brief, PRD, or spec) |
| "scan email" | email skill → inbox triage with batch actions |
| "health sleep" | health skill → biometric analysis from wearable data |

**Why it matters:** Zero friction. You don't think about *tools* — you think about *outcomes*. Claude matches intent to the right skill using LLM reasoning, not regex.

**What you need:** Skill files with clear `description` frontmatter that lists trigger phrases. CLAUDE.md routing table mapping triggers to skill file paths.

**Pattern to copy:** Write your skill descriptions as natural phrases people would actually say. "Create a deployment plan for staging or production" beats "Deploy stuff." The description controls discovery — if the description is vague, the skill won't fire.

## Skills as Markdown Files with Reference Data

Each skill is a directory with progressive disclosure:
```
skills/meeting-prep/
├── meeting-prep.md    ← the skill (triggers, workflows, guardrails)
└── ref-tools.md       ← reference material (API docs, tool catalog)
```

**Why it matters:** The skill file tells Claude *what to do*. The ref file gives it *what it needs to know*. Progressive disclosure — Claude loads ref data only when the skill is triggered, not on every conversation. A 2,000-line persona database only loads when someone says "ICP eval."

**What you need:** A `skills/` directory. One subdirectory per skill with a markdown file and optional reference files.

**Pattern to copy:** Don't paste your entire API reference into CLAUDE.md. Put it in a ref file and tell Claude where to find it. Your CLAUDE.md should be a router — trigger phrases and file paths, not methodology.

## MCP-First Data Gathering

Skills are designed to pull live data from every available source *before* producing output. A single meeting-prep skill:
- Pulls calendar events (Google Calendar MCP)
- Searches email threads (Gmail MCP)
- Researches attendees (Playwright MCP → LinkedIn)
- Pulls meeting transcripts (Granola MCP)
- Searches Notion for relevant docs
- Does web research on companies

**Why it matters:** The briefing is always richer than what you could assemble manually. Claude does in 30 seconds what would take 15-20 minutes. And the quality compounds — each source cross-references the others.

**What you need:** At least 2-3 MCP servers configured. Gmail + Calendar + one domain-specific server is the minimum viable set.

**Pattern to copy:** When building skills, list every data source Claude should pull from. Be explicit: "Search Gmail for threads with [attendee]. Search Notion for relevant docs. Web search [company] for recent news." If you don't specify the sources, Claude will use whatever is convenient rather than what is comprehensive.

## Global MCP Configuration

All MCP servers configured globally in `~/.claude.json`, not per-project. Available everywhere:

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

**Why it matters:** No configuration drift. Every session has the same capabilities. You never think "do I have access to X?" — the answer is always yes.

**What you need:** Run `claude mcp add` for each server you want globally available. Start with Gmail + Calendar + one more.

**Pattern to copy:** Use `claude mcp add` to configure servers globally. Reserve per-project MCP for project-specific servers only. Global servers are your infrastructure — they should be as reliable as your shell.

## Confirmation Gates on Destructive Actions

Skills explicitly do NOT send emails, push Slack messages, or make calendar changes without confirmation. Claude drafts, you confirm.

**Why it matters:** You can let Claude operate with broad access (push to git, read all email, access Slack) because the guardrails are in the *skills*, not the *permissions*. Trust the agent to gather information freely. Gate only the point of no return.

**What you need:** Explicit rules in each skill file that produces external side effects.

**Pattern to copy:** In your skill files, add explicit rules like: "Draft the Slack message and present it for approval. Do NOT send until the user confirms." This is more flexible than permission-level blocking because you can make exceptions per-skill.

## Pre-Approved Permissions for Speed

`settings.local.json` pre-approves dozens of safe commands:
- Safe git operations (log, status, diff, push to specific repos)
- npm/node commands for MCP servers
- Specific MCP tools (Jira search, iMessage read, Notion fetch)
- WebFetch for specific domains

**Why it matters:** Eliminates the "approve/deny" friction that makes Claude feel slow. Safe commands fly through instantly. Risky commands still prompt you.

**What you need:** A `settings.local.json` file (or `settings.json` for shared team settings) with an allowlist.

**Pattern to copy:** Start with a small allowlist and expand it over time. Pre-approve `git log`, `git status`, `git diff`, and your test runner first. Add more as you learn which commands are safe in your workflow. Use deny rules for anything that should never run (`rm -rf`, `git push --force`).

## Structured Output to Defined Locations

Every skill knows where its output goes:
- Analyses → `analyses/<name>.md`
- Documents → `docs/` or a Notion database
- Meeting outputs → team channels (after confirmation)
- Project artifacts → `projects/<name>/` with lifecycle prefixes (`wip-`, `ref-`, `out-`)

**Why it matters:** You always know where to find things. No ad hoc files scattered across directories. The knowledge base stays organized as it grows.

**What you need:** A directory structure with clear conventions. Lifecycle prefixes help: `wip-` for drafts, `ref-` for reference material, `out-` for finalized output.

**Pattern to copy:** Define output locations in your skill files. "Save the analysis to `analyses/<name>.md`" ensures consistency. Use a naming convention for file lifecycle so you can tell at a glance what stage something is in.

## Environment-Aware Skills

Every skill documents what's available in Claude Code vs. Claude AI:
```
Claude Code: Google Drive MCP, Gmail MCP, Jira MCP, Slack MCP, Playwright...
Claude AI: Google Calendar (built-in), Email (built-in), Web search...
```

**Why it matters:** The same skills work in both environments. Claude gracefully degrades when a tool isn't available, following inline fallbacks. You write skills once and they work everywhere.

**What you need:** An "Environment Awareness" section in your CLAUDE.md listing available tools per environment.

**Pattern to copy:** If your skills need to work across environments, document what's available where and add fallback instructions. "If Playwright is not available, ask the user to paste the LinkedIn profile URL."

## User Identity System

The system detects who's using it (via `git config user.name`) and adapts:
- If the owner → apply personal voice and default preferences
- If a team member → use standard professional tone, with option to invoke the owner's voice for content written on their behalf

**Why it matters:** One skill set serves the entire team. No per-user configuration needed. A teammate can say "draft a LinkedIn post for the CEO" and the system applies the right voice without switching repos.

**What you need:** Identity detection in your CLAUDE.md: "Check `git config user.name` to determine the current user."

**Pattern to copy:** If multiple people share your CLAUDE.md, add identity detection and document how behavior changes per user. Keep it simple — name-based routing covers most cases.

## Hook-Driven Self-Maintenance

The most durable setups don't need manual upkeep — hooks keep them in sync. Three hooks run silently on every relevant event:

- **Context updater** — when a skill, hook script, or MCP source file is modified, appends a timestamped note to MEMORY.md so the next session knows what changed
- **Test suite syncer** — when a new skill or MCP source file is created, automatically inserts the corresponding test assertion, keeping test coverage current without manual edits
- **Remote approver** — on any permission request, sends a push notification to your phone via ntfy.sh with Approve/Deny action buttons; falls back to local prompt after 90 seconds

**Why it matters:** Maintenance work that requires developer attention compounds over time. Hooks that maintain the environment autonomously pay back immediately and permanently. Add a new skill file → tests automatically cover it. Edit a hook → MEMORY.md logs it.

**What you need:** Hook scripts in `~/.claude/hooks/` and registration in `settings.json`. Start with the context updater — it's the simplest and highest-ROI.

**Pattern to copy:** Think about what goes stale in your setup (tests, docs, logs) and write PostToolUse hooks that update them. Start with file existence tests — they're simple to auto-generate and prevent silent gaps. The pattern is: detect the structural change, update the infrastructure, no human attention required.

---

← [Back to README](README.md) | [Next: Part 2 — Techniques](PART2-TECHNIQUES.md)
