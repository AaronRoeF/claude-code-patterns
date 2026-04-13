← [Back to README](README.md) | **Part 2: Pro-Tips** | [Part 3: AI Wiki](PART3-AI-WIKI.md) | [Part 4: Quick Reference](PART4-QUICK-REFERENCE.md) | [Part 5: Implemented Patterns](PART5-IMPLEMENTED-PATTERNS.md)

---

# Part 2: Pro-Tips by Category

97 researched techniques organized into 15 categories. Each rated:
- **Beginner** — anyone can do this today
- **Intermediate** — requires some setup or familiarity
- **Advanced** — power-user territory

---

## Writing Effective CLAUDE.md Files

### Keep It Under 300 Lines
Your CLAUDE.md is loaded into every conversation. Long instruction files cause Claude to miss critical rules — shorter files get better adherence. Ruthlessly prune instructions for things Claude already does correctly. Focus only on rules where Claude's default behavior diverges from what you want.

**Why it matters:** Long instruction files cause Claude to miss critical rules, so shorter files get measurably better adherence.

**Level:** Beginner
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

### Use Progressive Disclosure
Don't dump all information into CLAUDE.md. Tell Claude *how to find* information instead. Write `"For database schema details, read /docs/schema.md"` rather than pasting the entire schema.

**Why it matters:** Every line in CLAUDE.md consumes tokens on every conversation, so inlining large references wastes context that could hold actual working files.

**Level:** Intermediate
**Source:** [Builder.io Guide](https://www.builder.io/blog/claude-md-guide)

### Use Emphasis for Critical Rules
Add `IMPORTANT:` or `YOU MUST` before non-negotiable instructions. But don't overuse it — if everything is "IMPORTANT," nothing is.

**Why it matters:** Without emphasis markers, Claude treats all instructions with equal priority and may skip the ones that are actually non-negotiable.

**Level:** Beginner
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

### Use Multiple CLAUDE.md Files for Large Projects
Keep a general CLAUDE.md in your project root and add specific ones in sub-folders (`/frontend/CLAUDE.md`, `/api/CLAUDE.md`). Claude picks up the most relevant one based on which files it's working with.

**Why it matters:** A single CLAUDE.md for a large project either becomes too long or too generic, so scoped files let each subsystem carry its own conventions.

**Level:** Intermediate
**Source:** [Builder.io Guide](https://www.builder.io/blog/claude-md-guide)

### Structure as WHAT, WHY, HOW
Organize into three sections: WHAT (tech stack & project structure), WHY (project purpose), HOW (coding standards & conventions). Gives Claude a complete mental model.

**Why it matters:** Without the WHY section, Claude makes architectural decisions that are locally correct but misaligned with the project's actual purpose.

**Level:** Beginner
**Source:** [Arize Blog](https://arize.com/blog/claude-md-best-practices-learned-from-optimizing-claude-code-with-prompt-learning/)

### Check CLAUDE.md Into Git
Version-control your CLAUDE.md so your team can contribute. Treat it like code: review it when things go wrong, prune regularly, test whether changes actually shift behavior.

**Why it matters:** Unversioned CLAUDE.md files drift silently, so teammates get inconsistent behavior and nobody can trace when a rule was added or removed.

**Level:** Beginner
**Source:** [HumanLayer Blog](https://www.humanlayer.dev/blog/writing-a-good-claude-md)

### Failure-Mode Anchoring as a One-Line Append
Instead of rewriting CLAUDE.md rules, append a single italic `*Sign you...*` line to existing rules. The positive rule stays; the failure anchor gives Claude a self-diagnostic — a pattern it can recognize *before* it violates the rule, not after. Example: `*Sign you jumped too early: starting code or design, then asking "wait, do we need this?"*` One line per rule, no bloat, no compliance penalty.

**Why it matters:** Positive rules tell Claude what to do but not how to detect when it is about to violate them, so failure anchors close the self-monitoring gap.

**Level:** Intermediate

---

## Context Management

### Use /clear Between Unrelated Tasks
Wipe conversation history when switching topics. Claude re-reads your CLAUDE.md and retains file access. Prevents "kitchen sink" sessions where mixing tasks degrades quality.

**Why it matters:** Leftover context from a previous task biases Claude's responses and consumes tokens that the new task needs.

**Level:** Beginner

### Use /compact at 70% Capacity
Manually run `/compact` when your context window reaches ~70%, rather than waiting for auto-compaction at 95%. You can focus it: `/compact Focus on the API changes`.

**Why it matters:** Auto-compaction at 95% is an emergency measure that compresses under pressure, losing more useful context than a deliberate compaction at 70%.

**Level:** Intermediate
**Source:** [MCPcat Guide](https://mcpcat.io/guides/managing-claude-code-context/)

### Audit Context with /context
Run `/context` to see exactly how many tokens each component consumes — system prompt, MCP tools, memory, skills, conversation. MCP servers can consume 30%+ of your window before you type anything.

**Why it matters:** Without visibility into token allocation, you cannot diagnose why sessions feel sluggish or why Claude starts forgetting earlier instructions.

**Level:** Intermediate

### Target 3-5 Files, Not Your Entire Project
Never bulk-load your whole project. Three to five targeted files yield better results than fifty files loaded at once. Use @-mentions to reference specific files.

**Why it matters:** Bulk-loading files fills the context window with irrelevant code, leaving less room for the files Claude actually needs to reason about.

**Level:** Beginner

### Use Subagents to Preserve Main Context
Delegate exploration and research to subagents, which run in their own context windows. Keeps your main conversation clean and focused.

**Why it matters:** Research and exploration produce large volumes of intermediate output that pollute the main context and accelerate compaction.

**Level:** Advanced
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/sub-agents)

### Write Design Docs to Markdown Files
Instead of repeating complex instructions in conversation, write design docs and task lists to markdown files that Claude can reference on demand without consuming ongoing context.

**Why it matters:** Repeating complex instructions in conversation duplicates token cost every time you re-explain, while a file on disk costs tokens only when read.

**Level:** Intermediate

### Reduce Defensive Checkpointing as Context Grows
With 1M token context, most workflows complete without compaction. Audit and eliminate elaborate recovery mechanisms (state snapshots, breadcrumb trails, mid-session save points) that were built for smaller windows — they're now overhead that costs tokens and adds complexity.

**Why it matters:** Recovery mechanisms designed for 200K context windows consume tokens and add complexity that is unnecessary at 1M.

**Level:** Advanced
**Source:** [Adventures in Claude — One Million Tokens](https://adventuresinclaude.ai/posts/2026-03-14-one-million-tokens-and-four-commands-to-rewrite/)

### Audit Old Patterns When Constraints Change
Sequential workarounds persist from old constraints. When context size increases 5x or a new feature drops, audit the entire dependency chain — checkpoint frequency, recovery mechanisms, context splitting strategies — for optimization candidates. What was necessary at 200K may be waste at 1M.

**Why it matters:** Workarounds for old constraints accumulate silently and continue consuming tokens and complexity long after the constraint is removed.

**Level:** Intermediate
**Source:** [Adventures in Claude — One Million Tokens](https://adventuresinclaude.ai/posts/2026-03-14-one-million-tokens-and-four-commands-to-rewrite/)

### ASCII Progress Bars During Multi-Phase Plans
Add a CLAUDE.md rule to render progress bars after each phase transition in plans with 3+ phases. Format: `Phase 3/7: [name]` + filled/empty bar + percentage + one-line status row with checkmarks (done), arrow (active), circle (pending). Gives instant orientation without reading output walls. Each bar is a natural checkpoint where you can redirect or reprioritize mid-plan.

**Why it matters:** Without visual progress indicators, long multi-phase executions produce walls of text with no obvious place to intervene or redirect.

**Level:** Beginner

---

## Slash Commands & Built-in Features

### Plan Mode (Shift+Tab)
Press Shift+Tab twice to enter Plan Mode — Claude generates a plan without making changes. Review and approve before execution. Essential for multi-file or complex tasks.

**Why it matters:** Without a review step, Claude executes multi-file changes immediately, making mistakes harder to undo than to prevent.

**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/common-workflows)

### /resume to Pick Up Where You Left Off
Browse and restore previous conversations with `/resume`, or start from terminal with `claude --continue` to immediately continue your last session.

**Why it matters:** Without resume, closing a terminal or restarting means losing all conversation context and re-explaining the task from scratch.

**Level:** Beginner

### /simplify After Completing Features
Spawns three specialized review agents that check for reuse opportunities, quality issues, and efficiency improvements. An automated code review pipeline.

**Why it matters:** Post-implementation review catches dead code, missed abstractions, and performance issues that are easy to overlook while focused on making things work.

**Level:** Intermediate

### /batch for Parallel Worktree Operations
Spawns agents in isolated worktrees and creates PRs automatically. Good for parallelizing independent tasks.

**Why it matters:** Sequential execution of independent tasks wastes time that parallel worktree agents can reclaim by working simultaneously.

**Level:** Advanced

### /model to Switch Models Mid-Session
`/model haiku` for quick tasks (2x faster, 3x cheaper). `/model opus` for complex reasoning. `/model opusplan` uses Opus for planning and Sonnet for execution.

**Why it matters:** Using the same model for every task either overpays for simple work or under-performs on complex reasoning.

**Level:** Intermediate

### /cost to Track Token Spending
See detailed token usage, total cost, API duration, and code changes for your current session.

**Why it matters:** Without cost visibility, expensive sessions go unnoticed until the monthly bill arrives.

**Level:** Beginner

### /install-github-app for Automated PR Reviews
Set up Claude as an automated PR reviewer that launches 4 review agents in parallel, scores issues by confidence, and posts comments. Trigger with `@claude` on any PR.

**Why it matters:** Manual PR reviews create bottlenecks; automated first-pass review catches common issues before a human reviewer spends time on them.

**Level:** Intermediate
**Source:** [Claude Code GitHub Actions](https://code.claude.com/docs/en/github-actions)

---

## Hooks (Automated Triggers)

### Auto-Format Code After Every Edit
Set up a PostToolUse hook that runs your formatter (prettier, gofmt) automatically after every file write or edit. Run `/hooks` to set up.

**Why it matters:** Without auto-formatting, Claude's edits accumulate inconsistent style that requires a separate cleanup pass.

**Level:** Intermediate
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/hooks)

### Block Writes to Sensitive Files
PreToolUse hook that blocks writes to `.env`, production configs, or `.git`. Exits with code 2 to prevent the action — deterministic safety net.

**Why it matters:** CLAUDE.md instructions can be reasoned around, but a hook that exits with code 2 blocks the action deterministically regardless of context.

**Level:** Advanced

### Inject Context at Session Start
SessionStart hook that loads recent tickets, coding checklists, or project status into every new conversation automatically.

**Why it matters:** Without injected context, every new session starts cold and requires manual re-orientation before productive work can begin.

**Level:** Advanced

### Run Tests After Code Changes
PostToolUse hook that runs your test suite after every code edit. Catches regressions immediately.

**Why it matters:** Without immediate test feedback, Claude continues building on broken code and the fix cost compounds with each subsequent edit.

**Level:** Intermediate

### HTTP Hooks for External Integrations
POST JSON to a URL and receive JSON back — integrate with Slack notifications, logging platforms, or custom APIs.

**Why it matters:** Without HTTP hooks, integrating Claude Code with external services requires custom MCP servers or manual copy-paste workflows.

**Level:** Advanced

### MCP Audit Logging
PostToolUse hook on Gmail, Slack, and Google Drive that logs every external action with timestamp, tool name, and key parameters (to, subject, channel, fileId). Creates a paper trail at `~/.claude/mcp-audit.log` for accountability and debugging.

**Why it matters:** Without an audit log, there is no way to trace what external actions Claude took after the conversation is closed.

**Level:** Intermediate

### Post-Compact Context Reload
SessionStart hook with `compact` matcher that re-injects current git branch, recent commits, active projects, and context management rules after `/compact`. Prevents the "Claude forgets everything" problem that makes compaction feel lossy.

**Why it matters:** Compaction discards raw conversation history, so without re-injection, Claude loses awareness of the current branch, recent commits, and active projects.

**Level:** Intermediate

### Block Destructive Commands
PreToolUse hook on Bash that checks for `git push --force`, `git reset --hard`, `rm -rf`, and `DROP TABLE`. Exit code 2 blocks the action deterministically — can't be reasoned around like an instruction in CLAUDE.md.

**Why it matters:** A single destructive command can delete branches, drop databases, or wipe directories, and natural-language instructions alone cannot guarantee prevention.

**Level:** Advanced

### Auto-Update MEMORY.md on Structural Changes
PostToolUse hook (`Edit|Write`) that watches for edits to skills, hook scripts, MCP source files, and CLAUDE.md. When a match fires, it appends a timestamped entry to `MEMORY.md` — so the *next* session automatically knows what was recently modified without you having to remember to log it. Debounced to prevent duplicate entries for rapid edits.

**Why it matters:** Without automatic change logging, the next session has no record of what was modified and starts from a stale understanding of the codebase.

**Level:** Intermediate
**Script:** `~/.claude/hooks/claude-context-updater.sh`

### Mobile Permission Approvals via ntfy.sh
`PermissionRequest` hook that forwards every Claude permission prompt to your phone as a push notification via [ntfy.sh](https://ntfy.sh). The notification includes Approve/Deny action buttons — tapping one sends the decision back via ntfy's HTTP action API, which the hook polls every 3 seconds. Falls back to the local prompt after 90 seconds. Zero server required — ntfy.sh is the relay. Setup: install the ntfy.sh app and subscribe to a private topic.

**Why it matters:** Without remote approval, Claude blocks on permission prompts whenever you step away from your desk, halting all progress until you return.

**Level:** Advanced
**Script:** `~/.claude/hooks/remote-approver.sh`

### Auto-Sync Test Suite on Skill/MCP Changes
PostToolUse hook (`Edit|Write`) that detects new skill markdown files or MCP TypeScript source files. When a file is created that lacks test coverage, it automatically inserts the appropriate assertion into `run-tests.sh` — either into the `SKILLS=()` array or after the last `assert_file_exists` for that MCP server. Uses `awk` for atomic file writes. Idempotent — re-running for the same file is a no-op.

**Why it matters:** New files added without test coverage silently reduce the overall test suite's reach, and manual test registration is easy to forget.

**Level:** Advanced
**Script:** `~/.claude/hooks/test-suite-updater.sh`

### Circuit Breakers via Disk-Based State
Block irreversible actions (git push, email send) at the session-file level, not just via CLAUDE.md instructions. Write a state file (e.g., `.claude-session/TICKET-XXX.json`) that tracks whether the plan was approved. Even if context compaction causes amnesia, the disk-based gate still enforces the approval requirement. Instructions can be reasoned around; file checks cannot.

**Why it matters:** Context compaction can cause Claude to forget that a plan was not yet approved, so disk-based state persists the gate independent of memory.

**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Post-Commit TIL Capture Hook
A lighter counterpart to the session-end TIL hook. PostToolUse hook on Bash that detects `git commit` commands and nudges: "Anything surprising in this commit?" Only fires if fewer than 3 observations captured today (quality over quantity). The compact hook does the full scan; this one catches learnings while the commit context is still fresh.

**Why it matters:** Learnings are easiest to articulate at commit time when the context is fresh, but without a prompt they pass uncaptured.

**Level:** Intermediate
**Script:** `~/.claude/hooks/commit-til-capture.sh`

---

## Skills (Reusable Workflows)

### Create Skills for Repetitive Tasks
Build custom skills (`SKILL.md` files in `.claude/skills/`) for any task you do repeatedly. Markdown-based instructions with YAML frontmatter.

**Why it matters:** Without skills, you re-explain the same multi-step workflow every session, wasting tokens and risking inconsistent execution.

**Level:** Intermediate
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/skills)

### Use disable-model-invocation for Dangerous Skills
Set `disable-model-invocation: true` in skill frontmatter to prevent Claude from accidentally triggering destructive skills (deploy, send emails). Only explicit slash commands invoke these.

**Why it matters:** Without this flag, Claude can auto-invoke a deploy or email-send skill based on conversational context, triggering irreversible actions without explicit user intent.

**Level:** Intermediate

### Write Strong Trigger Descriptions
Claude uses LLM reasoning (not regex) to decide which skill to invoke. Write descriptions like "Create a deployment plan for staging or production" rather than "Deploy stuff."

**Why it matters:** Vague trigger descriptions cause Claude to invoke the wrong skill or fail to invoke the right one, since skill selection is LLM-based, not keyword-based.

**Level:** Intermediate

### Install Office Document Skills
Install skills for DOCX, PDF, PPTX, and XLSX to create professional documents through natural language. "Create a PowerPoint about Q1 results."

**Why it matters:** Without document skills, Claude Code can only output markdown and plain text, requiring manual conversion for any office-format deliverable.

**Level:** Beginner
**Source:** [GitHub - claude-office-skills](https://github.com/tfriedel/claude-office-skills)

### Build a Daily Briefing Skill
Pull from Calendar, Gmail, Slack, and Notion to generate a personalized morning briefing. Reduces 30 minutes of planning to 2 minutes.

**Why it matters:** Manually checking calendar, email, Slack, and project boards each morning takes 30+ minutes that a single skill invocation can replace.

**Level:** Advanced
**Source:** [Claude Resources](https://claude.com/resources/use-cases/build-a-daily-briefing-across-your-tools)

### Bootstrap Prompt Under 2,000 Tokens
A small bootstrap prompt that teaches Claude to search for and follow relevant skill files intercepts the impulse to jump straight to coding. The key behavior: brainstorming before implementation (Socratic design questions, architecture alternatives) and verification before handoff (run tests, confirm output). Keeps the always-loaded instruction budget tiny while the skills handle domain depth.

**Why it matters:** A small bootstrap prompt that dispatches to skill files keeps the always-loaded token cost under 2,000 while still covering unlimited domain depth.

**Level:** Advanced
**Source:** [Adventures in Claude — Two Thousand Tokens of Discipline](https://adventuresinclaude.ai/posts/two-thousand-tokens-of-discipline/)

### TDD Enforcement via Skill File
A skill that forces restart if implementation precedes test creation. Red-green-refactor without negotiation. The skill checks whether test files exist before allowing implementation code to be written. Unlike a CLAUDE.md instruction (which can be reasoned around), a skill with explicit step ordering is harder to skip.

**Why it matters:** Claude defaults to writing implementation first and tests second, which a CLAUDE.md instruction alone cannot reliably prevent.

**Level:** Advanced
**Source:** [Adventures in Claude — Two Thousand Tokens of Discipline](https://adventuresinclaude.ai/posts/two-thousand-tokens-of-discipline/)

### Parameterized Skills for Portability
Externalize hardcoded values (API keys, workspace IDs, brand voices, output paths) into configuration files rather than embedding them in skill markdown. The same skill then works across different companies, teams, or personal contexts. Claude Code's directory-scoped isolation means the config file naturally scopes which values get loaded.

**Why it matters:** Hardcoded values lock a skill to one environment, so sharing it with another team or project requires editing the skill source.

**Level:** Intermediate
**Source:** [Adventures in Claude — Treasure Troves and Portable Companies](https://adventuresinclaude.ai/posts/2026-02-22-dev-diary/)

### Domain-Portable Learning Loops
The 3-layer TIL architecture (capture → cluster → graduate) is a repeatable template for any domain that generates recurring insights. Layer 1: raw signal capture pages (high-volume, low-curation). Layer 2: periodic reviews that cluster signals across sessions and propose graduations. Layer 3: validated patterns applied to real operational artifacts (process docs, playbooks, personas, messaging). To add a learning loop for a new domain: clone an existing TIL skill, replace the signal taxonomy and categories, point graduation targets at the domain's artifacts, and wire auto-triggers from relevant meeting types. Structure is reusable; domain content is the only variable.

**Why it matters:** Without a structured capture-to-graduation pipeline, recurring insights from meetings and sessions evaporate between conversations.

**Level:** Advanced
**See also:** [Adventures in Claude — One Hundred Forty Observations and a Dog Name](https://adventuresinclaude.ai/posts/one-hundred-forty-observations-and-a-dog-name/)

### Extract Methodology, Keep Skill Files Thin
Skill files should be routers and dispatchers — they handle triggers, step ordering, and orchestration. Heavy methodology content (analytical frameworks, grading rubrics, multi-step templates over ~50 lines) should be extracted to referenced asset files. The split criterion: if content is filled in once and submitted, extract it to an asset. If it's built interactively across multiple steps with user input shaping each section, keep it inline with the orchestrator. This saves context tokens on every invocation (the framework only loads when the step that references it runs) and keeps skill files maintainable.

**Why it matters:** Inlining heavy methodology in skill files loads the full framework into context on every invocation, even when only one step needs it.

**Level:** Intermediate

### Seven-Section Skill Template
Structure each skill with seven sections: frontmatter (metadata), when to use (trigger definitions), context (what Claude needs to know), process (ordered steps), output format (where artifacts go), guardrails (what NOT to do), and standalone mode (fallback when MCP tools unavailable). Creates consistency across skills and makes Claude's execution reliable and predictable.

**Why it matters:** Inconsistent skill structure causes Claude to miss steps or misinterpret intent, since it has no predictable format to follow.

**Level:** Intermediate
**Source:** [Adventures in Claude — Running a Company on Markdown Files](https://adventuresinclaude.ai/posts/2026-02-21-running-a-company-on-markdown-files/)

---

## MCP (Model Context Protocol)

### Start with High-Value MCP Servers
For business users, prioritize: GitHub (issues/PRs), Slack (communication), Notion/Confluence (docs), Jira/Linear (project management). Use `claude mcp add` with appropriate auth.

**Why it matters:** Each MCP server consumes context tokens just by being registered, so installing low-value servers first wastes your token budget before you see meaningful results.

**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/mcp)

### Disable Unused MCP Servers Per Session
MCP tool definitions consume tokens just by being available. Run `/mcp` to see per-server token costs and disable servers you aren't using.

**Why it matters:** Idle MCP servers can consume 30%+ of your context window before you type a single prompt.

**Level:** Intermediate

### MCP Tool Search Loads Tools On-Demand
When you have many MCP servers, Claude Code automatically loads tools on-demand (via ToolSearch) instead of preloading all of them — reducing token overhead by ~85%. This activates automatically.

**Why it matters:** Without on-demand loading, 10+ MCP servers preload hundreds of tool definitions that fill your context window with schemas you never use.

**Level:** Intermediate

### Use Environment Variables for Tokens
Configure auth via environment variables rather than hardcoding in config files. Prevents accidental key exposure.

**Why it matters:** Hardcoded tokens in config files get committed to git and shared with anyone who clones the repo.

**Level:** Beginner

### The 3-Point MCP Debug Check
90% of MCP errors are resolved by checking: (1) the binary is accessible, (2) the token is valid, (3) the network port is open.

**Why it matters:** MCP server failures produce vague error messages, so without a systematic checklist you waste time debugging the wrong layer.

**Level:** Beginner

### Follow the MCP Spec for Tool Definitions
Every tool must include `name`, `title` (human-readable), `description`, and `inputSchema` (with `additionalProperties: false`). Add `outputSchema` for tools with structured responses. These aren't optional decorations — they're what the LLM reads to decide tool selection and validate responses. Early servers often ship without `title` and `outputSchema`. New servers should follow the spec from day one; existing servers should get a backfill pass.

**Why it matters:** Missing or vague tool descriptions cause Claude to select the wrong tool or pass invalid parameters, producing silent failures.

**Level:** Intermediate
**Source:** [MCP Specification — Tools](https://modelcontextprotocol.io/specification/2025-11-25/server/tools.md)

### SQLite for Reads, JXA Only for Writes
For macOS app MCP servers, default to reading the app's SQLite database directly (sub-ms, works when the app is closed, handles search well) and reserve JXA/AppleScript only for operations that require app interaction (creating items, marking complete). The URL scheme (`app:///verb?params`) is a reliable middle ground for creates/updates. This minimizes brittleness — JXA depends on the scripting bridge, which Apple doesn't actively maintain and can break across macOS versions.

**Why it matters:** JXA/AppleScript calls are 100-1000x slower than direct SQLite reads and break unpredictably across macOS versions.

**Level:** Advanced

### Register MCP Servers via CLI, Not Manual JSON Edits
Use `claude mcp add -s user` instead of hand-editing `~/.claude.json`. The CLI handles format validation, scope, and transport type. Manual edits risk malformed JSON that silently fails at session start.

**Why it matters:** Malformed JSON in `~/.claude.json` causes MCP servers to silently fail to load with no error message at session start.

**Level:** Beginner
**Source:** [Claude Code Docs — MCP](https://code.claude.com/docs/en/mcp)

---

## VS Code Integration

### @-Mentions with Line Ranges
Type `@file.ts#5-10` to reference specific line ranges. Press **Option+K** (Mac) to insert an @-mention from your current editor selection.

**Why it matters:** Without line-range references, Claude reads the entire file and may miss which section you are asking about.

**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/vs-code)

### Automatic Selection Detection
Select text in VS Code → Claude sees your highlighted code automatically. The prompt box footer shows how many lines are selected. No copy-paste needed.

**Why it matters:** Copy-pasting code into the prompt loses line numbers and surrounding context that Claude needs for accurate edits.

**Level:** Beginner

### Cmd+Esc to Toggle Focus
Toggle between your code editor and Claude's prompt box. Rapid back-and-forth without the mouse.

**Why it matters:** Reaching for the mouse to switch between editor and prompt breaks flow and adds seconds to every interaction.

**Level:** Beginner

### Sidebar vs. Panel Placement
Use Cmd+Shift+P → search "Claude Code" to move between sidebar (like file explorer) and panel (bottom). Sidebar enables side-by-side workflow.

**Why it matters:** The default bottom panel forces you to scroll between Claude's output and your code instead of viewing both simultaneously.

**Level:** Beginner

### Cmd+T for Extended Thinking
Toggle extended thinking for complex reasoning. Significantly improves quality for architectural decisions, debugging, and complex problems.

**Why it matters:** Without extended thinking, Claude skips intermediate reasoning steps on multi-file architectural decisions and produces shallow answers.

**Level:** Intermediate

### Customize Keyboard Shortcuts
Cmd+K, Cmd+S → search "Claude" to see all available commands and rebind them.

**Why it matters:** The default keybindings may conflict with your existing editor shortcuts or muscle memory from other tools.

**Level:** Beginner

---

## Permission Management & Security

### Create a Targeted Allowlist
Define specific allowed tools in `.claude/settings.json`. Pre-approve safe commands (`git log`, `npm test`, `git diff`) while keeping risky operations on "Ask."

**Why it matters:** Without an allowlist, Claude prompts for permission on every shell command, including read-only ones you would always approve.

**Level:** Intermediate
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/permissions)

### Use Deny Rules for Destructive Commands
Explicit deny for `rm -rf`, `git push --force`, `npm publish`. Deny always takes precedence over allow.

**Why it matters:** Allow rules alone cannot prevent accidental approval of destructive commands during fast-moving sessions.

**Level:** Intermediate

### Project-Level vs. Local Settings
`.claude/settings.json` (in git) for team-shared rules. `.claude/settings.local.json` (gitignored) for personal preferences.

**Why it matters:** Mixing team rules and personal preferences in one file means your personal overrides get pushed to every teammate on the next commit.

**Level:** Intermediate

### Sandbox Restrictions
Claude Code's built-in sandbox prevents Bash commands from reaching resources outside defined boundaries. For maximum isolation, run in Docker.

**Why it matters:** Without sandbox boundaries, a malformed command can read or modify files outside your project directory.

**Level:** Advanced

### Review Shell Commands Before Authorizing
Stay in Normal Mode for important work. Only use Auto-Accept for low-risk tasks on feature branches with recent commits.

**Why it matters:** Auto-accept mode removes the human review step that catches destructive commands before they execute.

**Level:** Beginner

### Approval Gates for Sensitive Content in Skills
In operational skills (meeting briefs, recaps, memos), add a guardrail that detects sensitive content before it reaches any output — HR/personnel matters, unannounced deals, confidential strategy — then stops, issues a named warning (`WARNING: You are about to include HR-related or sensitive information.`), lists each instance, and requires per-item approval. This prevents private information from leaking into Slack recaps, email drafts, or briefs without the user noticing. The gate fires on *detection*, not on a general "be careful" instruction — so it works even when context is rich and the model has plausible reasons to include the information. Add the rule to both your global CLAUDE.md (all skills) and the highest-risk individual skill (meeting-prep, memo-writer, etc.) for defense in depth.

**Why it matters:** Without an explicit detection gate, sensitive information (personnel changes, deal terms) gets included in shared outputs because the model treats it as relevant context.

**Level:** Advanced

### URL-Parser Validation Over String Checks
For redirect validation, login callbacks, and any user-controlled URL handling: use `new URL(path, "https://placeholder.invalid")` instead of string prefix checks like `startsWith("/")`. String checks miss backslash bypasses (`\evil.com`), protocol-relative tricks (`//evil.com`), and encoded characters. Build it once as a shared utility (`isSafeRelativeRedirect()`) at the platform level so every app uses the same defense.

**Why it matters:** String-based URL checks like `startsWith("/")` miss backslash bypasses and protocol-relative tricks that redirect users to attacker-controlled domains.

**Level:** Advanced
**Source:** [Adventures in Claude — Sixty Tickets and a Backslash](https://adventuresinclaude.ai/posts/sixty-tickets-and-a-backslash/)

### Error Message Sanitization for Auth Flows
Replace verbose error messages in redirect URLs with opaque codes. `?error=Token+has+expired` leaks implementation details via Referer headers to any downstream page. Use `?error=auth_error` instead — map codes to user-facing messages on the client side. Apply to every redirect that carries error state.

**Why it matters:** Verbose error strings in redirect URLs leak implementation details to any third-party page loaded afterward via the Referer header.

**Level:** Intermediate
**Source:** [Adventures in Claude — Friday Night Fun](https://adventuresinclaude.ai/posts/friday-night-fun/)

---

## Agent Orchestration & Parallel Work

### Git Worktrees for Parallel Sessions
Run multiple Claude sessions in parallel, each in its own git worktree with an isolated branch and filesystem. No branch-switching overhead.
**Level:** Advanced

### Agent Teams (3-5 Teammates)
Start with 3-5 teammates. Give each rich context about the project and their specific goal. Teammates can message each other (unlike subagents). Enable with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.
**Level:** Advanced
**Source:** [Addy Osmani](https://addyosmani.com/blog/claude-code-agent-teams/)

### Subagents for Quick, Focused Work
Use subagents (not agent teams) for quick tasks that complete and report back. Simpler, faster, fewer tokens than full agent teams.
**Level:** Intermediate

### Background Agents (Ctrl+B)
Move a running agent to the background and continue working. See status, token usage, and progress.
**Level:** Intermediate

### Give Each Agent a Narrow Scope
LLMs perform worse as context expands. Narrow scope + clean context = better reasoning, independent quality checks, and graceful degradation.
**Level:** Advanced

### Run Quality Gates Concurrently
Type-checking, linting, and tests are independent — run them in parallel rather than sequentially. Saves 20-30 seconds per commit cycle. Use explicit `--concurrency` flags or separate Bash calls. Apply the same principle to review agents: spawn them in parallel, merge findings.
**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### Three-Level Review Triage
Classify commits by risk to avoid wasteful reviews: **NONE** (docs, tests, config changes), **LIGHT** (under 10 files), **FULL** (10+ files or sensitive paths like auth, middleware, migrations). Path-based overrides force full review for security-critical files regardless of file count. Implement as a pre-commit skill or hook.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Simplify Before Review
Run a "simplify pass" (extract utilities, remove redundancy, clean up imports) *before* launching review agents. Review agents then see cleaner code and their findings don't reference already-refactored patterns. Order matters: simplify → review → commit.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Autonomous Ticket Chains
For batch refactoring work, run chains of independent tickets where each promotes app-specific code to shared platform libraries. Auto-approve plans and auto-commit between tickets. Works best when tickets are truly independent and the pattern is mechanical (e.g., extracting duplicated utilities).
**Level:** Advanced
**Source:** [Adventures in Claude — Forty-Three Tickets and a Cancer App](https://adventuresinclaude.ai/posts/2026-02-17-dev-diary/)

### Team Registry for Multi-Repo Routing
Create a YAML registry that maps ticket prefixes to repositories, enabling automatic project detection and directory switching. When tickets could route to multiple repos, implement an `ask_user` option that presents labeled choices rather than forcing a single default target.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Post-Switch Pre-flight Checks
After switching directories or projects, verify uncommitted changes exist, offer stashing, and confirm the repo is clean before proceeding. Prevents "committed to wrong branch" errors in multi-worktree setups.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Reopened Ticket Detection
Scan ticket comments for feedback signals ("bug", "doesn't work", "regression") to automatically identify when previously-shipped work needs revision-focused planning rather than greenfield implementation.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Change Relevance Detection
Compare staged changes against the ticket's stated purpose and flag unrelated files. Prevents mixed commits that pollute git history and make rollbacks dangerous.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Branch/Ticket Mismatch Safeguard
Cross-check session file ticket ID against current branch name before committing. Catches worktree switching mistakes before commits go to wrong branches.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Review Overrides File
Maintain a `.claude/review-overrides.json` to suppress known false positives from review agents without editing agent prompts. Reduces prompt bloat and review noise over time.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Inline Plans for Narrow Scope, Subagent for Complexity
For tickets scoping to 1-3 files with clear descriptions, generate plans directly in the main context rather than dispatching expensive subagents. Reserve subagent dispatch for ambiguous, multi-file, or reopened tickets. Saves 15-30 seconds and 10K+ tokens per simple ticket.
**Level:** Advanced
**Source:** [Adventures in Claude — Optimizing /start](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-start-the-fifteen-step-state-machine/)

### Reconstruct State from External Systems
Store session checkpoints only at irreversible decision points. Everything between checkpoints can be regenerated from git history, API state, and on-disk artifacts. Eliminates redundant writes and simplifies recovery logic.
**Level:** Advanced
**Source:** [Adventures in Claude — Optimizing /start](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-start-the-fifteen-step-state-machine/)

### Cache Computed Artifacts Across Pipeline Stages
Compute expensive outputs (git diffs, file lists) once early in the workflow and reuse cached results throughout downstream operations. Prevents re-running `git diff` 3-4 times in a single commit pipeline.
**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### Conditional Step Skipping Based on Content
Skip expensive processing steps when content patterns indicate they will yield no value (e.g., skip learning capture for documentation-only commits, skip security review for CSS-only changes). Pattern-match on file paths and change types.
**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### Monorepo Boundary Enforcement
Use Turborepo's `boundaries` feature (or equivalent) to prevent unintended cross-application imports within a monorepo. Enforces architectural separation that code review alone misses — catches violations at build time rather than during manual review.
**Level:** Advanced
**Source:** [Adventures in Claude — Friday Night Fun](https://adventuresinclaude.ai/posts/friday-night-fun/)

### Parallel Background Agents for Independent Builds
Spawn 6+ background agents simultaneously, each owning distinct output files. Use `run_in_background: true` on each Agent call. Agents notify on completion — don't poll. Real-world result: 6 agents (skills, audits, reconciliation) completed with zero conflicts in ~15 minutes vs 90+ minutes sequential. The key constraint: strict file ownership — two agents touching the same file causes overwrites.
**Level:** Advanced

---

## Memory & Persistence

### Auto Memory for Cross-Session Learning
Claude accumulates knowledge across sessions: build commands, debugging insights, architecture notes, code style, workflow habits. Verify with `/memory`.
**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/memory)

### Subagent MEMORY.md
Give subagents a memory directory. The first 200 lines of MEMORY.md are injected into the agent's system prompt on every run, building knowledge over time.
**Level:** Advanced

### --continue for Momentum
`claude --continue` picks up your last conversation with all context preserved. `claude --resume <session-id>` for a specific session.
**Level:** Beginner

### Project Plans in Your Knowledge Base, Not Hidden Dirs
Claude Code stores plans in `.claude/plans/` with auto-generated names like `peaceful-imagining-kite.md`. These are invisible in Finder and VS Code. Instead, store active project plans in a visible repo with lifecycle prefixes: `wip-installer-plan.md` while building, rename to `ref-` when done. Link from MEMORY.md so Claude finds them across sessions. The `.claude/` files still exist (Claude manages those), but your authoritative version lives where you can browse it.
**Level:** Intermediate

### Persist Workflow State to Disk
Store workflow progress in session state files (e.g., `.claude-session/TICKET-XXX.json`) tracking current step, status, target directory, and approval gates. The filesystem is reliable; context memory is not. After compaction, Claude can read the state file to resume exactly where it left off. Separate plan tracking (checkbox markdown) from session metadata (JSON).
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Symlink MEMORY.md Across Worktrees
When running parallel Claude sessions in git worktrees, symlink MEMORY.md so every session starts with identical institutional knowledge. Without this, worktree-specific MEMORY.md copies drift apart as different sessions learn different things.
**Level:** Intermediate
**Source:** [Adventures in Claude — Supermemory Evaluation](https://adventuresinclaude.ai/posts/2026-02-17-supermemory-evaluation/)

### Self-Improving Learning Loop (Capture → Graduate)

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

### Cross-Skill Gotchas Registry
Create a single `~/.claude/skill-gotchas.md` aggregating gotchas from all skills, organized by category (MCP/Auth, Data Sources, Output/Formatting, Process/Workflow) rather than by skill. Add a CLAUDE.md rule to read it at session start for skill-adjacent tasks. Common gotchas (token expiry, pagination limits, output format drift) stay in context even when the specific skill isn't invoked. Also: mark observations older than 30 days as `[STALE]` if they haven't clustered — and track graduation-to-observation ratio (healthy: 15-25%).
**Level:** Intermediate

---

## Prompt Engineering

### The 4-Block Prompt Pattern
Structure complex prompts: INSTRUCTIONS (what to do), CONTEXT (background), TASK (specific request), OUTPUT FORMAT (desired result shape). Reduces iterations by ~60%.
**Level:** Intermediate

### Be Explicit About Actions
"Change this function to improve performance" vs. "Can you suggest some changes?" — Claude is trained for precise instruction following.
**Level:** Beginner

### Specify Target Files and Constraints
"Fix the auth timeout bug in `/src/auth/login.ts` — we use JWT tokens with 24-hour expiry" beats "Fix the login bug."
**Level:** Beginner

### Iterate in 2-3 Cycles Maximum
The sweet spot is 2-3 feedback cycles. Beyond that, use `/clear` and restart with a refined prompt.
**Level:** Intermediate

### Start Simple, Add Complexity Only When Needed
Longer prompts are NOT always better. Start with one sentence and add constraints only when results need improvement.
**Level:** Beginner

### Explore → Plan → Implement
Follow Claude's natural three-phase workflow. Skipping exploration significantly increases the risk of undo. Start with "Explore this and tell me how it works" before asking for changes.
**Level:** Intermediate

### Markdown as State Machine for Workflows
Structure workflow instructions as numbered decision trees with explicit branching, not prose paragraphs. Step numbers provide unambiguous control flow: "Step 3: If ticket has comments containing 'bug' or 'regression', go to Step 3a. Otherwise, Step 4." Claude follows numbered steps more reliably than prose because the structure eliminates ambiguity about ordering and branching.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

---

## Business User Workflows

### Claude Cowork for Non-Technical Tasks
Claude Desktop's Cowork mode provides the same agent without requiring a terminal. Draft documents, analyze data, reorganize files, manage invoices. Available on all paid plans.
**Level:** Beginner
**Source:** [Claude Cowork](https://claude.com/product/cowork)

### Process Meeting Notes Automatically
Point Claude at meeting transcripts → get action-items organized by owner, priority, and due date. Reduces 15-30 minutes to 2 minutes.
**Level:** Intermediate

### Headless Mode for Automation
`claude -p "your prompt"` runs non-interactively as a Unix utility. Compatible with pipes: `cat data.csv | claude -p "Analyze trends" --output-format json`
**Level:** Advanced
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/headless)

### Content Creation Pipelines
Use skills and MCPs together: research topics → draft content → format for platforms → schedule distribution. Connect Notion (content DB), Google Drive (storage), Slack (distribution).
**Level:** Advanced

### Multi-Tool Research
Create a skill that combines web search, Playwright (for sites requiring browser automation), and Notion (for internal knowledge) to produce comprehensive research reports.
**Level:** Advanced

### Capture Edit Diffs for Voice Learning
At publish time, automatically diff Claude's draft against the human's final edited version. The edits reveal voice preferences, structural habits, and phrasing patterns that improve future drafts. Store diffs as training data for voice-matching skills. Over time, the gap between draft and final version should shrink.
**Level:** Advanced
**Source:** [Adventures in Claude — Voice Learning via Edit Diffs](https://adventuresinclaude.ai/posts/2026-02-17-dev-diary/)

---

## Cost Optimization

### The opusplan Model Alias
`/model opusplan` uses Opus for planning/reasoning and Sonnet for code execution. Opus-quality thinking at Sonnet execution costs.
**Level:** Intermediate

### Haiku for Quick Tasks
`/model haiku` for simple queries, boilerplate, and routine tasks. 90% of Sonnet capability at 2x speed and 3x cost savings.
**Level:** Beginner

### Refresh After Major Milestones
Use `/clear` after completing features or merging PRs. Long sessions accumulate context that makes everything slower and more expensive.
**Level:** Beginner

---

## Common Pitfalls

### Don't Trust Auto-Accept for Complex Tasks
Auto-accept bypasses human review. Use only on feature branches with recent commits, never on main/production.
**Level:** Beginner

### Always Verify Output
Claude may produce plausible-looking code that doesn't handle edge cases. Run tests, review diffs, and check edge cases before committing.
**Level:** Beginner

### Don't Skip the Explore Phase
Let Claude explore before it changes things. Exploration reveals patterns, dependencies, and constraints that affect implementation.
**Level:** Beginner

### Avoid "Kitchen Sink" Sessions
Starting with one task, asking something unrelated, then going back degrades quality for everything. Use `/clear` between topics.
**Level:** Beginner

### Don't Over-Specify CLAUDE.md
If Claude keeps ignoring a rule, the file is probably too long. The fix is pruning, not adding more emphasis. A bloated CLAUDE.md is worse than none.
**Level:** Intermediate

### Watch for Large Stdin Limitations
Headless mode may return empty output with ~7,000+ character stdin input. For large documents, use file-based input (@-mentions) instead.
**Level:** Intermediate

### Inspect Data Before Hypothesizing
For data-dependent bugs, examine actual data first — don't theorize about code paths. Claude defaults to reasoning about code rather than observing data flow. Explicitly instruct: "dump the field values at each pipeline stage before suggesting a fix." Add diagnostic logging early. Run with real data once. One production data inspection often solves bugs faster than 10 hours of code-path reasoning.
**Level:** Intermediate
**Source:** [Adventures in Claude — The Bug That Was Right in Front of Me](https://adventuresinclaude.ai/posts/the-bug-that-was-right-in-front-of-me/)

### Snapshot-Based Regression Testing for Data Pipelines
Take snapshots of algorithm outputs against production data and commit as baselines. Wire into pre-commit hooks to force review when outputs change. Catches silent behavioral regressions that unit tests miss — especially in ranking, scoring, or transformation logic where "correct" is defined by expected output, not by code structure.
**Level:** Advanced
**Source:** [Adventures in Claude — Snapshots and Dead Code](https://adventuresinclaude.ai/posts/2026-02-25-dev-diary/)

### Documentation Accuracy Audits
Periodically verify that docs match actual code behavior. Incorrect docs are worse than missing docs — they create false confidence that leads to security vulnerabilities and integration bugs. Build a skill or checklist that cross-references README claims, API docs, and inline comments against what the code actually does.
**Level:** Intermediate
**Source:** [Adventures in Claude — Sixty Tickets and a Backslash](https://adventuresinclaude.ai/posts/sixty-tickets-and-a-backslash/)

---

## Latest Features (2025-2026)

### Shared Configs Across Worktrees
Project configs and auto memory automatically share across git worktrees of the same repo. Consistent settings across parallel agents.
**Level:** Intermediate

### Custom Status Line
Install a custom status line showing current model, git branch, uncommitted file count, sync status, and a visual context usage progress bar.
**Level:** Advanced
**Source:** [ykdojo/claude-code-tips](https://github.com/ykdojo/claude-code-tips)

### Container Mode for Safe Experimentation
Run Claude Code in Docker with `--dangerously-skip-permissions` for fully autonomous experimentation in isolated environments. Never on your actual system.
**Level:** Advanced

### 200+ Environment Variables
Claude Code supports 200+ env vars (only ~50 documented). Control API endpoints, model selection, privacy, experimental features, and session parameters.
**Level:** Advanced
**Source:** [Eesel Blog](https://www.eesel.ai/blog/environment-variables-claude-code)

### /permissions to Audit Rules
List all permission rules and see which settings.json they're sourced from. Debug unexpected permission behavior.
**Level:** Intermediate

---

← [Back to README](README.md) | [Next: Part 3 — AI Wiki](PART3-AI-WIKI.md)
