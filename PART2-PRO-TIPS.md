← [Back to README](README.md) | **Part 2: Pro-Tips** | [Part 3: AI Wiki](PART3-AI-WIKI.md) | [Part 4: Quick Reference](PART4-QUICK-REFERENCE.md) | [Part 5: Implemented Patterns](PART5-IMPLEMENTED-PATTERNS.md)

---

# Part 2: Pro-Tips by Category

97 researched techniques organized into 15 categories. Each rated:
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

### 122. Failure-Mode Anchoring as a One-Line Append
Instead of rewriting CLAUDE.md rules, append a single italic `*Sign you...*` line to existing rules. The positive rule stays; the failure anchor gives Claude a self-diagnostic — a pattern it can recognize *before* it violates the rule, not after. Example: `*Sign you jumped too early: starting code or design, then asking "wait, do we need this?"*` One line per rule, no bloat, no compliance penalty.
**Level:** Intermediate

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

### 123. ASCII Progress Bars During Multi-Phase Plans
Add a CLAUDE.md rule to render progress bars after each phase transition in plans with 3+ phases. Format: `Phase 3/7: [name]` + filled/empty bar + percentage + one-line status row with checkmarks (done), arrow (active), circle (pending). Gives instant orientation without reading output walls. Each bar is a natural checkpoint where you can redirect or reprioritize mid-plan.
**Level:** Beginner

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

### 107. Domain-Portable Learning Loops
The 3-layer TIL architecture (capture → cluster → graduate) is a repeatable template for any domain that generates recurring insights. Layer 1: raw signal capture pages (high-volume, low-curation). Layer 2: periodic reviews that cluster signals across sessions and propose graduations. Layer 3: validated patterns applied to real operational artifacts (process docs, playbooks, personas, messaging). To add a learning loop for a new domain: clone an existing TIL skill, replace the signal taxonomy and categories, point graduation targets at the domain's artifacts, and wire auto-triggers from relevant meeting types. Structure is reusable; domain content is the only variable.
**Level:** Advanced
**See also:** [Adventures in Claude — One Hundred Forty Observations and a Dog Name](https://adventuresinclaude.ai/posts/one-hundred-forty-observations-and-a-dog-name/)

### 108. Extract Methodology, Keep Skill Files Thin
Skill files should be routers and dispatchers — they handle triggers, step ordering, and orchestration. Heavy methodology content (analytical frameworks, grading rubrics, multi-step templates over ~50 lines) should be extracted to referenced asset files. The split criterion: if content is filled in once and submitted, extract it to an asset. If it's built interactively across multiple steps with user input shaping each section, keep it inline with the orchestrator. This saves context tokens on every invocation (the framework only loads when the step that references it runs) and keeps skill files maintainable.
**Level:** Intermediate

### 109. Seven-Section Skill Template
Structure each skill with seven sections: frontmatter (metadata), when to use (trigger definitions), context (what Claude needs to know), process (ordered steps), output format (where artifacts go), guardrails (what NOT to do), and standalone mode (fallback when MCP tools unavailable). Creates consistency across skills and makes Claude's execution reliable and predictable.
**Level:** Intermediate
**Source:** [Adventures in Claude — Running a Company on Markdown Files](https://adventuresinclaude.ai/posts/2026-02-21-running-a-company-on-markdown-files/)

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

### 110. Team Registry for Multi-Repo Routing
Create a YAML registry that maps ticket prefixes to repositories, enabling automatic project detection and directory switching. When tickets could route to multiple repos, implement an `ask_user` option that presents labeled choices rather than forcing a single default target.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### 111. Post-Switch Pre-flight Checks
After switching directories or projects, verify uncommitted changes exist, offer stashing, and confirm the repo is clean before proceeding. Prevents "committed to wrong branch" errors in multi-worktree setups.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### 112. Reopened Ticket Detection
Scan ticket comments for feedback signals ("bug", "doesn't work", "regression") to automatically identify when previously-shipped work needs revision-focused planning rather than greenfield implementation.
**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### 113. Change Relevance Detection
Compare staged changes against the ticket's stated purpose and flag unrelated files. Prevents mixed commits that pollute git history and make rollbacks dangerous.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### 114. Branch/Ticket Mismatch Safeguard
Cross-check session file ticket ID against current branch name before committing. Catches worktree switching mistakes before commits go to wrong branches.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### 115. Review Overrides File
Maintain a `.claude/review-overrides.json` to suppress known false positives from review agents without editing agent prompts. Reduces prompt bloat and review noise over time.
**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### 116. Inline Plans for Narrow Scope, Subagent for Complexity
For tickets scoping to 1-3 files with clear descriptions, generate plans directly in the main context rather than dispatching expensive subagents. Reserve subagent dispatch for ambiguous, multi-file, or reopened tickets. Saves 15-30 seconds and 10K+ tokens per simple ticket.
**Level:** Advanced
**Source:** [Adventures in Claude — Optimizing /start](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-start-the-fifteen-step-state-machine/)

### 117. Reconstruct State from External Systems
Store session checkpoints only at irreversible decision points. Everything between checkpoints can be regenerated from git history, API state, and on-disk artifacts. Eliminates redundant writes and simplifies recovery logic.
**Level:** Advanced
**Source:** [Adventures in Claude — Optimizing /start](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-start-the-fifteen-step-state-machine/)

### 118. Cache Computed Artifacts Across Pipeline Stages
Compute expensive outputs (git diffs, file lists) once early in the workflow and reuse cached results throughout downstream operations. Prevents re-running `git diff` 3-4 times in a single commit pipeline.
**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### 119. Conditional Step Skipping Based on Content
Skip expensive processing steps when content patterns indicate they will yield no value (e.g., skip learning capture for documentation-only commits, skip security review for CSS-only changes). Pattern-match on file paths and change types.
**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### 120. Monorepo Boundary Enforcement
Use Turborepo's `boundaries` feature (or equivalent) to prevent unintended cross-application imports within a monorepo. Enforces architectural separation that code review alone misses — catches violations at build time rather than during manual review.
**Level:** Advanced
**Source:** [Adventures in Claude — Friday Night Fun](https://adventuresinclaude.ai/posts/friday-night-fun/)

### 121. Parallel Background Agents for Independent Builds
Spawn 6+ background agents simultaneously, each owning distinct output files. Use `run_in_background: true` on each Agent call. Agents notify on completion — don't poll. Real-world result: 6 agents (skills, audits, reconciliation) completed with zero conflicts in ~15 minutes vs 90+ minutes sequential. The key constraint: strict file ownership — two agents touching the same file causes overwrites.
**Level:** Advanced

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

### 124. Cross-Skill Gotchas Registry
Create a single `~/.claude/skill-gotchas.md` aggregating gotchas from all skills, organized by category (MCP/Auth, Data Sources, Output/Formatting, Process/Workflow) rather than by skill. Add a CLAUDE.md rule to read it at session start for skill-adjacent tasks. Common gotchas (token expiry, pagination limits, output format drift) stay in context even when the specific skill isn't invoked. Also: mark observations older than 30 days as `[STALE]` if they haven't clustered — and track graduation-to-observation ratio (healthy: 15-25%).
**Level:** Intermediate

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

← [Back to README](README.md) | [Next: Part 3 — AI Wiki](PART3-AI-WIKI.md)
