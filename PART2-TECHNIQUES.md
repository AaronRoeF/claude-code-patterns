← [Back to README](README.md) | [Part 1: Core Architecture](PART1-CORE-ARCHITECTURE.md) | **Part 2: Techniques** | [Part 3: Build a Knowledge Base](PART3-BUILD-A-KNOWLEDGE-BASE.md) | [Part 4: Quick Reference](PART4-QUICK-REFERENCE.md) | [Part 5: Live Examples](PART5-LIVE-EXAMPLES.md)

---

# Part 2: Techniques

**What's in it for you:** 137 moves you can copy in under a minute each — every one deployed daily, rated by difficulty, indexed so you (or your agent) can jump straight to the problem you have right now.

137 field-tested techniques organized into 16 categories. Each rated:
- **Beginner** — anyone can do this today
- **Intermediate** — requires some setup or familiarity
- **Advanced** — power-user territory

## Index

| Technique | Category |
|-----------|----------|
| [Keep It Under 300 Lines](#keep-it-under-300-lines) | Writing CLAUDE.md |
| [Use Progressive Disclosure](#use-progressive-disclosure) | Writing CLAUDE.md |
| [Use Emphasis for Critical Rules](#use-emphasis-for-critical-rules) | Writing CLAUDE.md |
| [Use Multiple CLAUDE.md Files for Large Projects](#use-multiple-claudemd-files-for-large-projects) | Writing CLAUDE.md |
| [Structure as WHAT, WHY, HOW](#structure-as-what-why-how) | Writing CLAUDE.md |
| [Check CLAUDE.md Into Git](#check-claudemd-into-git) | Writing CLAUDE.md |
| [Failure-Mode Anchoring as a One-Line Append](#failure-mode-anchoring-as-a-one-line-append) | Writing CLAUDE.md |
| [Use /clear Between Unrelated Tasks](#use-clear-between-unrelated-tasks) | Context Management |
| [Use /compact at 78% Capacity](#use-compact-at-78-capacity) | Context Management |
| [Audit Context with /context](#audit-context-with-context) | Context Management |
| [Target 3-5 Files, Not Your Entire Project](#target-3-5-files-not-your-entire-project) | Context Management |
| [Use Subagents to Preserve Main Context](#use-subagents-to-preserve-main-context) | Context Management |
| [Write Design Docs to Markdown Files](#write-design-docs-to-markdown-files) | Context Management |
| [Reduce Defensive Checkpointing as Context Grows](#reduce-defensive-checkpointing-as-context-grows) | Context Management |
| [Audit Old Patterns When Constraints Change](#audit-old-patterns-when-constraints-change) | Context Management |
| [ASCII Progress Bars During Multi-Phase Plans](#ascii-progress-bars-during-multi-phase-plans) | Context Management |
| [Plan Mode (Shift+Tab)](#plan-mode-shifttab) | Slash Commands |
| [/resume to Pick Up Where You Left Off](#resume-to-pick-up-where-you-left-off) | Slash Commands |
| [/simplify After Completing Features](#simplify-after-completing-features) | Slash Commands |
| [/batch for Parallel Worktree Operations](#batch-for-parallel-worktree-operations) | Slash Commands |
| [/model to Switch Models Mid-Session](#model-to-switch-models-mid-session) | Slash Commands |
| [/cost to Track Token Spending](#cost-to-track-token-spending) | Slash Commands |
| [/install-github-app for Automated PR Reviews](#install-github-app-for-automated-pr-reviews) | Slash Commands |
| [/loop for Recurring Tasks](#loop-for-recurring-tasks) | Slash Commands |
| [Auto-Format Code After Every Edit](#auto-format-code-after-every-edit) | Hooks |
| [Inject Context at Session Start](#inject-context-at-session-start) | Hooks |
| [Run Tests After Code Changes](#run-tests-after-code-changes) | Hooks |
| [HTTP Hooks for External Integrations](#http-hooks-for-external-integrations) | Hooks |
| [MCP Audit Logging](#mcp-audit-logging) | Hooks |
| [Post-Compact Context Reload](#post-compact-context-reload) | Hooks |
| [Auto-Update MEMORY.md on Structural Changes](#auto-update-memorymd-on-structural-changes) | Hooks |
| [Mobile Permission Approvals via ntfy.sh](#mobile-permission-approvals-via-ntfysh) | Hooks |
| [Auto-Sync Test Suite on Skill/MCP Changes](#auto-sync-test-suite-on-skillmcp-changes) | Hooks |
| [Circuit Breakers via Disk-Based State](#circuit-breakers-via-disk-based-state) | Hooks |
| [Post-Commit TIL Capture Hook](#post-commit-til-capture-hook) | Hooks |
| [Create Skills for Repetitive Tasks](#create-skills-for-repetitive-tasks) | Skills |
| [Use disable-model-invocation for Dangerous Skills](#use-disable-model-invocation-for-dangerous-skills) | Skills |
| [Write Strong Trigger Descriptions](#write-strong-trigger-descriptions) | Skills |
| [Install Office Document Skills](#install-office-document-skills) | Skills |
| [Build a Daily Briefing Skill](#build-a-daily-briefing-skill) | Skills |
| [Bootstrap Prompt Under 2,000 Tokens](#bootstrap-prompt-under-2000-tokens) | Skills |
| [TDD Enforcement via Skill File](#tdd-enforcement-via-skill-file) | Skills |
| [Parameterized Skills for Portability](#parameterized-skills-for-portability) | Skills |
| [Domain-Portable Learning Loops](#domain-portable-learning-loops) | Skills |
| [Extract Methodology, Keep Skill Files Thin](#extract-methodology-keep-skill-files-thin) | Skills |
| [Seven-Section Skill Template](#seven-section-skill-template) | Skills |
| [Start with High-Value MCP Servers](#start-with-high-value-mcp-servers) | MCP |
| [Disable Unused MCP Servers Per Session](#disable-unused-mcp-servers-per-session) | MCP |
| [MCP Tool Search Loads Tools On-Demand](#mcp-tool-search-loads-tools-on-demand) | MCP |
| [Use Environment Variables for Tokens](#use-environment-variables-for-tokens) | MCP |
| [The 3-Point MCP Debug Check](#the-3-point-mcp-debug-check) | MCP |
| [Follow the MCP Spec for Tool Definitions](#follow-the-mcp-spec-for-tool-definitions) | MCP |
| [SQLite for Reads, JXA Only for Writes](#sqlite-for-reads-jxa-only-for-writes) | MCP |
| [Register MCP Servers via CLI, Not Manual JSON Edits](#register-mcp-servers-via-cli-not-manual-json-edits) | MCP |
| [@-Mentions with Line Ranges](#-mentions-with-line-ranges) | VS Code |
| [Automatic Selection Detection](#automatic-selection-detection) | VS Code |
| [Cmd+Esc to Toggle Focus](#cmdesc-to-toggle-focus) | VS Code |
| [Sidebar vs. Panel Placement](#sidebar-vs-panel-placement) | VS Code |
| [Cmd+T for Extended Thinking](#cmdt-for-extended-thinking) | VS Code |
| [Customize Keyboard Shortcuts](#customize-keyboard-shortcuts) | VS Code |
| [Create a Targeted Allowlist](#create-a-targeted-allowlist) | Permissions & Security |
| [Layered Safety: Deny Rules + Hooks](#layered-safety-deny-rules--hooks) | Permissions & Security |
| [Project-Level vs. Local Settings](#project-level-vs-local-settings) | Permissions & Security |
| [Sandbox Restrictions](#sandbox-restrictions) | Permissions & Security |
| [Review Shell Commands Before Authorizing](#review-shell-commands-before-authorizing) | Permissions & Security |
| [Approval Gates for Sensitive Content in Skills](#approval-gates-for-sensitive-content-in-skills) | Permissions & Security |
| [URL-Parser Validation Over String Checks](#url-parser-validation-over-string-checks) | Permissions & Security |
| [Error Message Sanitization for Auth Flows](#error-message-sanitization-for-auth-flows) | Permissions & Security |
| [Git Worktrees for Parallel Sessions](#git-worktrees-for-parallel-sessions) | Agent Orchestration — Fundamentals |
| [Agent Teams (3-5 Teammates)](#agent-teams-3-5-teammates) | Agent Orchestration — Fundamentals |
| [Subagents for Quick, Focused Work](#subagents-for-quick-focused-work) | Agent Orchestration — Fundamentals |
| [Background Agents (Ctrl+B)](#background-agents-ctrlb) | Agent Orchestration — Fundamentals |
| [Give Each Agent a Narrow Scope](#give-each-agent-a-narrow-scope) | Agent Orchestration — Fundamentals |
| [Run Quality Gates Concurrently](#run-quality-gates-concurrently) | Agent Orchestration — Fundamentals |
| [Three-Level Review Triage](#three-level-review-triage) | Agent Orchestration — Fundamentals |
| [Simplify Before Review](#simplify-before-review) | Agent Orchestration — Fundamentals |
| [Inline Plans for Narrow Scope, Subagent for Complexity](#inline-plans-for-narrow-scope-subagent-for-complexity) | Agent Orchestration — Fundamentals |
| [Autonomous Ticket Chains](#autonomous-ticket-chains) | Agent Orchestration — CI/CD Pipeline |
| [Team Registry for Multi-Repo Routing](#team-registry-for-multi-repo-routing) | Agent Orchestration — CI/CD Pipeline |
| [Post-Switch Pre-flight Checks](#post-switch-pre-flight-checks) | Agent Orchestration — CI/CD Pipeline |
| [Reopened Ticket Detection](#reopened-ticket-detection) | Agent Orchestration — CI/CD Pipeline |
| [Change Relevance Detection](#change-relevance-detection) | Agent Orchestration — CI/CD Pipeline |
| [Branch/Ticket Mismatch Safeguard](#branchticket-mismatch-safeguard) | Agent Orchestration — CI/CD Pipeline |
| [Review Overrides File](#review-overrides-file) | Agent Orchestration — CI/CD Pipeline |
| [Reconstruct State from External Systems](#reconstruct-state-from-external-systems) | Agent Orchestration — CI/CD Pipeline |
| [Cache Computed Artifacts Across Pipeline Stages](#cache-computed-artifacts-across-pipeline-stages) | Agent Orchestration — CI/CD Pipeline |
| [Conditional Step Skipping Based on Content](#conditional-step-skipping-based-on-content) | Agent Orchestration — CI/CD Pipeline |
| [Monorepo Boundary Enforcement](#monorepo-boundary-enforcement) | Agent Orchestration — CI/CD Pipeline |
| [Parallel Background Agents for Independent Builds](#parallel-background-agents-for-independent-builds) | Agent Orchestration — CI/CD Pipeline |
| [Auto Memory for Cross-Session Learning](#auto-memory-for-cross-session-learning) | Memory & Persistence |
| [Subagent MEMORY.md](#subagent-memorymd) | Memory & Persistence |
| [--continue for Momentum](#--continue-for-momentum) | Memory & Persistence |
| [Project Plans in Your Knowledge Base, Not Hidden Dirs](#project-plans-in-your-knowledge-base-not-hidden-dirs) | Memory & Persistence |
| [Persist Workflow State to Disk](#persist-workflow-state-to-disk) | Memory & Persistence |
| [Symlink MEMORY.md Across Worktrees](#symlink-memorymd-across-worktrees) | Memory & Persistence |
| [Sync ~/.claude/ Subpaths Across Machines via Cloud-Backed Symlinks](#sync-claude-subpaths-across-machines-via-cloud-backed-symlinks) | Memory & Persistence |
| [Self-Improving Learning Loop (Capture → Graduate)](#self-improving-learning-loop-capture--graduate) | Memory & Persistence |
| [Memory Consolidation Pass (Capture → Consolidate → Graduate)](#memory-consolidation-pass-capture--consolidate--graduate) | Memory & Persistence |
| [Cross-Skill Gotchas Registry](#cross-skill-gotchas-registry) | Memory & Persistence |
| [Cross-Linked Navigation Harness for Multi-File Docs](#cross-linked-navigation-harness-for-multi-file-docs) | Memory & Persistence |
| [Project Pulse Files for Completion Tracking](#project-pulse-files-for-completion-tracking) | Memory & Persistence |
| [Focus Lock with Context-Switch Detection](#focus-lock-with-context-switch-detection) | Memory & Persistence |
| [The 4-Block Prompt Pattern](#the-4-block-prompt-pattern) | Prompt Engineering |
| [Be Explicit About Actions](#be-explicit-about-actions) | Prompt Engineering |
| [Specify Target Files and Constraints](#specify-target-files-and-constraints) | Prompt Engineering |
| [Iterate in 2-3 Cycles Maximum](#iterate-in-2-3-cycles-maximum) | Prompt Engineering |
| [Start Simple, Add Complexity Only When Needed](#start-simple-add-complexity-only-when-needed) | Prompt Engineering |
| [Explore → Plan → Implement](#explore--plan--implement) | Prompt Engineering |
| [Markdown as State Machine for Workflows](#markdown-as-state-machine-for-workflows) | Prompt Engineering |
| [Claude Cowork for Non-Technical Tasks](#claude-cowork-for-non-technical-tasks) | Business Workflows |
| [Process Meeting Notes Automatically](#process-meeting-notes-automatically) | Business Workflows |
| [Headless Mode for Automation](#headless-mode-for-automation) | Business Workflows |
| [Content Creation Pipelines](#content-creation-pipelines) | Business Workflows |
| [Multi-Tool Research](#multi-tool-research) | Business Workflows |
| [Capture Edit Diffs for Voice Learning](#capture-edit-diffs-for-voice-learning) | Business Workflows |
| [Standalone HTML as the Deliverable (the Fungible Artifact)](#standalone-html-as-the-deliverable-the-fungible-artifact) | Business Workflows |
| [The opusplan Model Alias](#the-opusplan-model-alias) | Cost Optimization |
| [Haiku for Quick Tasks](#haiku-for-quick-tasks) | Cost Optimization |
| [Refresh After Major Milestones](#refresh-after-major-milestones) | Cost Optimization |
| [Design Around the Prompt Cache TTL](#design-around-the-prompt-cache-ttl) | Cost Optimization |
| [Don't Trust Auto-Accept for Complex Tasks](#dont-trust-auto-accept-for-complex-tasks) | Common Pitfalls |
| [Always Verify Output](#always-verify-output) | Common Pitfalls |
| [Avoid "Kitchen Sink" Sessions](#avoid-kitchen-sink-sessions) | Common Pitfalls |
| [Don't Over-Specify CLAUDE.md](#dont-over-specify-claudemd) | Common Pitfalls |
| [Watch for Large Stdin Limitations](#watch-for-large-stdin-limitations) | Common Pitfalls |
| [Inspect Data Before Hypothesizing](#inspect-data-before-hypothesizing) | Common Pitfalls |
| [Snapshot-Based Regression Testing for Data Pipelines](#snapshot-based-regression-testing-for-data-pipelines) | Common Pitfalls |
| [Documentation Accuracy Audits](#documentation-accuracy-audits) | Common Pitfalls |
| [MCP Server Won't Start or Silently Fails](#mcp-server-wont-start-or-silently-fails) | Troubleshooting |
| [Permission Denied Loops](#permission-denied-loops) | Troubleshooting |
| [Context Window Exhaustion Mid-Task](#context-window-exhaustion-mid-task) | Troubleshooting |
| [Hook Not Firing](#hook-not-firing) | Troubleshooting |
| [Shared Configs Across Worktrees](#shared-configs-across-worktrees) | Latest Features |
| [Custom Status Line](#custom-status-line) | Latest Features |
| [Container Mode for Safe Experimentation](#container-mode-for-safe-experimentation) | Latest Features |
| [200+ Environment Variables](#200-environment-variables) | Latest Features |
| [/permissions to Audit Rules](#permissions-to-audit-rules) | Latest Features |

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

### Use /compact at 78% Capacity
Manually run `/compact` when your context window reaches ~78%, rather than waiting for auto-compaction at 95%. You can focus it: `/compact Focus on the API changes`. The 78% number gives Claude room to do a thoughtful summary rather than an emergency compression.

**Why it matters:** Auto-compaction at 95% is an emergency measure that compresses under pressure, losing more useful context than a deliberate compaction at 78%. Manual compaction at 78% produces better summaries while preserving maximum useful context. *Sign you waited too long: repeated searches for things already discussed, slower reasoning, or auto-compact firing and compressing critical context into noise.*

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

### /loop for Recurring Tasks
Run a prompt or slash command on a recurring interval: `/loop 5m /run-tests` checks tests every 5 minutes. Omit the interval and Claude self-paces based on what it's waiting for. Use for polling build status, watching deployments, running periodic health checks, or any task that benefits from repetition.

**Why it matters:** Many operational tasks require periodic checking — build status, deployment health, test suites after refactors. Without `/loop`, you either poll manually or forget to check back. `/loop` with self-pacing is particularly powerful because Claude adjusts the interval based on what it observes (checking more frequently as a build nears completion, less frequently during idle periods).

**Level:** Intermediate

---

## Hooks (Automated Triggers)

### Auto-Format Code After Every Edit
Set up a PostToolUse hook that runs your formatter (prettier, gofmt) automatically after every file write or edit. Run `/hooks` to set up.

**Why it matters:** Without auto-formatting, Claude's edits accumulate inconsistent style that requires a separate cleanup pass.

**Level:** Intermediate
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/hooks)

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

**See also:** Part 1 Core Architecture for the foundational pattern.

**Why it matters:** Without an allowlist, Claude prompts for permission on every shell command, including read-only ones you would always approve.

**Level:** Intermediate
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/permissions)

### Layered Safety: Deny Rules + Hooks
Protect against destructive actions with three complementary layers, each catching what the others miss:

**Layer 1 — settings.json deny rules:** Explicit deny entries in `.claude/settings.json` for destructive commands: `rm -rf`, `git push --force`, `npm publish`, `DROP TABLE`. Deny always takes precedence over allow. This is your first line of defense — zero setup beyond editing a JSON file.

**Layer 2 — PreToolUse hooks for file protection:** A PreToolUse hook that matches on `Edit|Write` and checks whether the target file is `.env`, a production config, or anything in `.git/`. Exit code 2 blocks the action deterministically. Unlike a CLAUDE.md instruction (which Claude can reason around), a hook that exits with code 2 prevents the action regardless of context.

**Layer 3 — PreToolUse hooks for command blocking:** A PreToolUse hook that matches on `Bash` and scans the command string for `git push --force`, `git reset --hard`, `rm -rf`, `DROP TABLE`, and other destructive patterns. Same exit-code-2 enforcement. This catches destructive commands even if they are not in the deny list (e.g., constructed dynamically or piped through another command).

**Why three layers:** Deny rules are static and only match exact command prefixes. File-protection hooks cover write operations that deny rules don't see. Command-blocking hooks catch destructive shell commands that are constructed dynamically or embedded in scripts. Together, they form a defense-in-depth that no single mechanism provides alone. CLAUDE.md instructions ("never force-push") are the weakest layer — they can be reasoned around under pressure, after compaction, or when Claude believes it has good reason. Hooks and deny rules cannot.

**Why it matters:** A single destructive command can delete branches, drop databases, wipe directories, or expose secrets — and natural-language instructions alone cannot guarantee prevention.

**Level:** Intermediate (deny rules) / Advanced (hooks)

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

#### Agent Orchestration — Fundamentals

### Git Worktrees for Parallel Sessions
Run multiple Claude sessions in parallel, each in its own git worktree with an isolated branch and filesystem. No branch-switching overhead.

**Why it matters:** Running parallel Claude sessions on the same branch causes merge conflicts and file corruption when both sessions edit the same files.

**Level:** Advanced

### Agent Teams (3-5 Teammates)
Start with 3-5 teammates. Give each rich context about the project and their specific goal. Teammates can message each other (unlike subagents). Enable with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.

**Why it matters:** Subagents cannot communicate with each other, so tasks requiring coordination between agents (e.g., frontend + backend changes) fail without agent teams.

**Level:** Advanced
**Source:** [Addy Osmani](https://addyosmani.com/blog/claude-code-agent-teams/)

### Subagents for Quick, Focused Work
Use subagents (not agent teams) for quick tasks that complete and report back. Simpler, faster, fewer tokens than full agent teams.

**Why it matters:** Agent teams carry inter-agent messaging overhead that doubles token cost for tasks that only need a single worker reporting back.

**Level:** Intermediate

### Background Agents (Ctrl+B)
Move a running agent to the background and continue working. See status, token usage, and progress.

**Why it matters:** Long-running tasks (test suites, large refactors) block your terminal until they finish, preventing any other work.

**Level:** Intermediate

### Give Each Agent a Narrow Scope
LLMs perform worse as context expands. Narrow scope + clean context = better reasoning, independent quality checks, and graceful degradation.

**Why it matters:** Agents with broad scope accumulate irrelevant context that degrades reasoning quality and increases the chance of hallucinated changes.

**Level:** Advanced

### Run Quality Gates Concurrently
Type-checking, linting, and tests are independent — run them in parallel rather than sequentially. Saves 20-30 seconds per commit cycle. Use explicit `--concurrency` flags or separate Bash calls. Apply the same principle to review agents: spawn them in parallel, merge findings.

**Why it matters:** Running type-checking, linting, and tests sequentially wastes 20-30 seconds per commit cycle on tasks with no dependencies between them.

**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### Three-Level Review Triage
Classify commits by risk to avoid wasteful reviews: **NONE** (docs, tests, config changes), **LIGHT** (under 10 files), **FULL** (10+ files or sensitive paths like auth, middleware, migrations). Path-based overrides force full review for security-critical files regardless of file count. Implement as a pre-commit skill or hook.

**Why it matters:** Running full review agents on documentation-only commits wastes tokens and time without catching any real issues.

**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Simplify Before Review
Run a "simplify pass" (extract utilities, remove redundancy, clean up imports) *before* launching review agents. Review agents then see cleaner code and their findings don't reference already-refactored patterns. Order matters: simplify → review → commit.

**Why it matters:** Review agents that run before simplification produce findings about code patterns that are about to be refactored anyway.

**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Inline Plans for Narrow Scope, Subagent for Complexity
For tickets scoping to 1-3 files with clear descriptions, generate plans directly in the main context rather than dispatching expensive subagents. Reserve subagent dispatch for ambiguous, multi-file, or reopened tickets. Saves 15-30 seconds and 10K+ tokens per simple ticket.

**Why it matters:** Dispatching a subagent for a 3-line change in one file burns 10K+ tokens and 15-30 seconds of latency for no quality gain.

**Level:** Advanced
**Source:** [Adventures in Claude — Optimizing /start](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-start-the-fifteen-step-state-machine/)

#### Agent Orchestration — CI/CD Pipeline Patterns

### Autonomous Ticket Chains
For batch refactoring work, run chains of independent tickets where each promotes app-specific code to shared platform libraries. Auto-approve plans and auto-commit between tickets. Works best when tickets are truly independent and the pattern is mechanical (e.g., extracting duplicated utilities).

**Why it matters:** Manually approving each step of a 40+ ticket mechanical refactoring turns a 2-hour batch job into a full-day supervised task.

**Level:** Advanced
**Source:** [Adventures in Claude — Forty-Three Tickets and a Cancer App](https://adventuresinclaude.ai/posts/2026-02-17-dev-diary/)

### Team Registry for Multi-Repo Routing
Create a YAML registry that maps ticket prefixes to repositories, enabling automatic project detection and directory switching. When tickets could route to multiple repos, implement an `ask_user` option that presents labeled choices rather than forcing a single default target.

**Why it matters:** Without a registry, agents working across multiple repos guess the wrong target directory and apply changes to the wrong codebase.

**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Post-Switch Pre-flight Checks
After switching directories or projects, verify uncommitted changes exist, offer stashing, and confirm the repo is clean before proceeding. Prevents "committed to wrong branch" errors in multi-worktree setups.

**Why it matters:** Skipping repo-state verification after a directory switch leads to commits landing on the wrong branch in multi-worktree setups.

**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Reopened Ticket Detection
Scan ticket comments for feedback signals ("bug", "doesn't work", "regression") to automatically identify when previously-shipped work needs revision-focused planning rather than greenfield implementation.

**Why it matters:** Treating a reopened ticket as greenfield causes Claude to rewrite working code instead of targeting the specific regression.

**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Change Relevance Detection
Compare staged changes against the ticket's stated purpose and flag unrelated files. Prevents mixed commits that pollute git history and make rollbacks dangerous.

**Why it matters:** Mixed commits that bundle unrelated changes make targeted rollbacks impossible without reverting intended work.

**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Branch/Ticket Mismatch Safeguard
Cross-check session file ticket ID against current branch name before committing. Catches worktree switching mistakes before commits go to wrong branches.

**Why it matters:** In multi-worktree setups, committing to the wrong branch is a common mistake that requires force-push or cherry-pick to fix.

**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Review Overrides File
Maintain a `.claude/review-overrides.json` to suppress known false positives from review agents without editing agent prompts. Reduces prompt bloat and review noise over time.

**Why it matters:** Without a suppression list, the same false positives appear on every commit, training you to ignore all review findings.

**Level:** Intermediate
**Source:** [Adventures in Claude — Exploring /commit](https://adventuresinclaude.ai/posts/2026-03-11-exploring-commit-how-my-code-reviews-itself-before-i-push/)

### Reconstruct State from External Systems
Store session checkpoints only at irreversible decision points. Everything between checkpoints can be regenerated from git history, API state, and on-disk artifacts. Eliminates redundant writes and simplifies recovery logic.

**Why it matters:** Checkpointing every intermediate step creates stale state files that cause resume logic to conflict with actual git history.

**Level:** Advanced
**Source:** [Adventures in Claude — Optimizing /start](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-start-the-fifteen-step-state-machine/)

### Cache Computed Artifacts Across Pipeline Stages
Compute expensive outputs (git diffs, file lists) once early in the workflow and reuse cached results throughout downstream operations. Prevents re-running `git diff` 3-4 times in a single commit pipeline.

**Why it matters:** Re-computing git diffs at each pipeline stage wastes tokens on identical output and adds cumulative latency.

**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### Conditional Step Skipping Based on Content
Skip expensive processing steps when content patterns indicate they will yield no value (e.g., skip learning capture for documentation-only commits, skip security review for CSS-only changes). Pattern-match on file paths and change types.

**Why it matters:** Running every pipeline step on every commit regardless of content wastes tokens and time on steps that will produce empty results.

**Level:** Intermediate
**Source:** [Adventures in Claude — Optimizing /commit](https://adventuresinclaude.ai/posts/2026-03-15-optimizing-commit-for-one-million-tokens/)

### Monorepo Boundary Enforcement
Use Turborepo's `boundaries` feature (or equivalent) to prevent unintended cross-application imports within a monorepo. Enforces architectural separation that code review alone misses — catches violations at build time rather than during manual review.

**Why it matters:** Without build-time import boundaries, Claude freely imports across application boundaries, creating coupling that is only caught during manual review.

**Level:** Advanced
**Source:** [Adventures in Claude — Friday Night Fun](https://adventuresinclaude.ai/posts/friday-night-fun/)

### Parallel Background Agents for Independent Builds
Spawn 6+ background agents simultaneously, each owning distinct output files. Use `run_in_background: true` on each Agent call. Agents notify on completion — don't poll. Real-world result: 6 agents (skills, audits, reconciliation) completed with zero conflicts in ~15 minutes vs 90+ minutes sequential. The key constraint: strict file ownership — two agents touching the same file causes overwrites.

**Why it matters:** Running 6 independent build tasks sequentially takes 90+ minutes; parallel background agents with strict file ownership complete the same work in ~15 minutes.

**Level:** Advanced

---

## Memory & Persistence

### Auto Memory for Cross-Session Learning
Claude accumulates knowledge across sessions: build commands, debugging insights, architecture notes, code style, workflow habits. Verify with `/memory`.

**Why it matters:** Without persistent memory, Claude re-learns your project's build commands, naming conventions, and architecture decisions at the start of every session.

**Level:** Beginner
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/memory)

### Subagent MEMORY.md
Give subagents a memory directory. The first 200 lines of MEMORY.md are injected into the agent's system prompt on every run, building knowledge over time.

**Why it matters:** Subagents without shared memory repeat the same mistakes across invocations because each run starts with zero project knowledge.

**Level:** Advanced

### --continue for Momentum
`claude --continue` picks up your last conversation with all context preserved. `claude --resume <session-id>` for a specific session.

**Why it matters:** Starting a fresh session after an accidental terminal close loses all accumulated context from the prior conversation.

**Level:** Beginner

### Project Plans in Your Knowledge Base, Not Hidden Dirs
Claude Code stores plans in `.claude/plans/` with auto-generated names like `peaceful-imagining-kite.md`. These are invisible in Finder and VS Code. Instead, store active project plans in a visible repo with lifecycle prefixes: `wip-installer-plan.md` while building, rename to `ref-` when done. Link from MEMORY.md so Claude finds them across sessions. The `.claude/` files still exist (Claude manages those), but your authoritative version lives where you can browse it.

**Why it matters:** Plans stored in `.claude/plans/` with auto-generated names are invisible in Finder and VS Code, so you cannot browse, search, or reference them.

**Level:** Intermediate

### Persist Workflow State to Disk
Store workflow progress in session state files (e.g., `.claude-session/TICKET-XXX.json`) tracking current step, status, target directory, and approval gates. The filesystem is reliable; context memory is not. After compaction, Claude can read the state file to resume exactly where it left off. Separate plan tracking (checkbox markdown) from session metadata (JSON).

**Why it matters:** Context compaction can erase workflow progress from memory, causing Claude to restart multi-step tasks from the beginning.

**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

### Symlink MEMORY.md Across Worktrees
When running parallel Claude sessions in git worktrees, symlink MEMORY.md so every session starts with identical institutional knowledge. Without this, worktree-specific MEMORY.md copies drift apart as different sessions learn different things.

**Why it matters:** Independent MEMORY.md copies in each worktree drift apart as different sessions learn different things, creating inconsistent behavior.

**Level:** Intermediate
**Source:** [Adventures in Claude — Supermemory Evaluation](https://adventuresinclaude.ai/posts/2026-02-17-supermemory-evaluation/)

### Sync ~/.claude/ Subpaths Across Machines via Cloud-Backed Symlinks

If you use Claude Code on more than one machine, the parts of `~/.claude/` that hold learned state (auto-memory, cross-skill gotchas, your global CLAUDE.md) diverge silently. Each machine builds its own picture; consolidation passes (see *Memory Consolidation Pass*) see only the local fragment. Fix by symlinking the *shared* subpaths into a cloud-synced or git-synced directory you control, leaving the rest of `~/.claude/` per-machine.

**Shared (symlink these):**

| Source in `~/.claude/` | Why share |
|---|---|
| `~/.claude/projects/<hash>/memory/` | Auto-memory store — learned facts about the user/project |
| `~/.claude/skill-gotchas.md` | Cross-skill gotchas registry |
| `~/.claude/CLAUDE.md` | Your global private CLAUDE.md |
| `~/.claude/commands/*.md` (optional) | Slash commands you want machine-global |

**Per-machine (do NOT share):** `settings.local.json`, `hooks/*`, plugin caches, session transcripts, OAuth tokens, any project memory dir that isn't a working directory you share across machines.

**Bootstrap script (idempotent, safe-renames originals — no deletion):**

```bash
set -e
SHARED_DIR="$HOME/your-shared-repo/_claude_local"   # this dir lives in iCloud / Dropbox / private git
CC_PROJECT_HASH="<the hash dir Claude Code generates for your shared working dir>"
TAG="before-sync-$(date +%Y-%m-%d)"

# memory dir
if [ ! -L "$HOME/.claude/projects/$CC_PROJECT_HASH/memory" ]; then
  mv "$HOME/.claude/projects/$CC_PROJECT_HASH/memory" \
     "$HOME/.claude/projects/$CC_PROJECT_HASH/memory.$TAG" 2>/dev/null || true
  ln -s "$SHARED_DIR/memory" "$HOME/.claude/projects/$CC_PROJECT_HASH/memory"
fi

# skill-gotchas + global CLAUDE.md
for f in skill-gotchas.md CLAUDE.md; do
  if [ ! -L "$HOME/.claude/$f" ]; then
    mv "$HOME/.claude/$f" "$HOME/.claude/$f.$TAG" 2>/dev/null || true
    ln -s "$SHARED_DIR/$f" "$HOME/.claude/$f"
  fi
done
```

Run once on each machine after the shared directory is populated. Skips if already symlinked (idempotent). Originals are renamed `*.before-sync-YYYY-MM-DD` — keep them as a rollback safety net for a week before deleting.

**Caveats:**

- **Concurrent writes.** Cloud-sync backends (iCloud, Dropbox) use last-writer-wins with conflict copies. If both machines run Claude Code simultaneously and both write to memory, you'll see suffixed conflict files. Avoid concurrent sessions or stagger work.
- **Sync backend + git.** If the shared directory is *also* a git repo (auto-memory commits build up over time), occasional contention between the sync backend's filesystem watcher and `.git/objects` locks can appear. Wait a minute and retry.
- **The hash directory.** Claude Code generates a per-working-directory hash under `~/.claude/projects/`. The same shared working directory produces the *same* hash on both machines — that's the directory whose `memory/` you symlink. Other working directories have their own hashes and stay per-machine. If you don't know the hash, open Claude Code once in the shared working dir; the hash dir will be created.

**Why it matters:** Without shared state, each machine's auto-memory, gotchas registry, and global rules drift independently — and any consolidation pass that reads memory sees only half the corpus on whichever machine you run it from.

**Level:** Intermediate

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

**Why it matters:** Auto memory captures individual facts but cannot detect recurring patterns across sessions, so the same mistakes repeat indefinitely without a structured graduation pipeline.

**Level:** Advanced
**Source:** [Adventures in Claude](https://adventuresinclaude.ai/posts/one-hundred-forty-observations-and-a-dog-name/)

### Memory Consolidation Pass (Capture → Consolidate → Graduate)

Capture and Graduate alone leave a cadence gap: capture happens daily, manual graduation review happens every few weeks, and useful patterns sit unpromoted in observation files for weeks while the next sessions keep tripping on rules nobody surfaced yet. Add a third process — a **scheduled consolidation pass** that reads the whole memory corpus at once, surfaces cross-source patterns, and proposes promotions. Anthropic shipped this pattern for Claude Managed Agents in May 2026 under the name "dreaming"; the same shape works locally for any stack with persistent memory.

**Signs you need this:** (1) Your daily capture file has "graduation candidate" flags that haven't been promoted in 7+ days. (2) You can name patterns you've noticed multiple times but haven't written down as rules. (3) Different projects show the same blocker shape and you only see it when you happen to look at both PULSE files in one sitting.

**Three things make it different from in-session reasoning:**

| | Reflex (in-session) | Consolidation (scheduled) |
|---|---|---|
| **Posture** | Apply rules, catch drift now | Patient, global, no single goal |
| **Cadence** | Every session | Weekly / on-demand |
| **Reading** | One file at a time | Whole corpus as one thing |

**What it reads (one canonical set):**

- The capture corpus (daily observation files within a window — 14 days is a good default)
- The persistent memory store (typed `feedback_*.md` / `user_*.md` / `project_*.md` files)
- The graduation review log (for collision-checking — see below)
- Cross-cutting state files (project trackers / `PULSE.md` files, decision logs, skill gotchas)
- NOT raw session transcripts in v1 — distilled artifacts only. Transcripts are the highest-priority v2 addition.

**What it produces:** one dated report with three sections that earn their place — patterns surfaced (with frequency + exemplar quotes), curation proposals for the memory store (merges, archives, retires), and cross-source patterns visible across project trackers. Every proposed change has an `[ ] approve` checkbox. A separate apply command reads the checked items and makes the edits.

**Three design choices that matter more than they look:**

1. **Cap the proposals.** Without a cap, consolidation over-produces — your first run will find more than seven things worth promoting, and the wall of proposals defeats human approval. Hard caps (e.g., 7 graduations + 7 memory curation items + 3 cross-source patterns per pass) force ranking and push deferred items into a watch list where they age.
2. **Collide-check against the graduation log.** The most embarrassing failure is re-proposing a rule already promoted. Before surfacing each candidate, grep the graduation log; mark collisions `[ALREADY GRADUATED]` and skip. Without this guard, the first run will re-propose rules already in force.
3. **Sample if oversized.** Token budget for a single consolidation pass is bounded. If the corpus exceeds it, sample the most recent half and note the truncation in metadata. Do not silently truncate — the failure mode of "consolidation quietly stopped working at scale" is the worst kind of decay in a system whose value compounds with the corpus.

**Skeleton consolidation report (lift this structure):**

```markdown
---
type: dream-report
date: YYYY-MM-DD
window: <human-readable>
inputs: { observations: N, memory_files: N, pulse_files: N }
truncated: false
---

# Consolidation — YYYY-MM-DD

## tl;dr — Top 3 by impact
1. <rule | finding | recommendation> → <target | action>
2. ...
3. ...

## Patterns surfaced
### Pattern 1 — <theme>  [GRADUATION_CANDIDATE | WATCH | INSIGHT]
- Frequency: N occurrences across M days
- Exemplars: "<quote>" — obs/YYYY-MM-DD.md
- Note: <one-sentence interpretation>

## Graduation proposals (capped at 7)
### Graduation 1 — <one-line rule>
Rule: <full rule text as it should appear in the target file>
Target: <CLAUDE.md section | memory/file.md | skill file>
Suggested edit: <diff block>
[ ] approve  [ ] reject  [ ] defer

## Memory curation proposals (capped at 7)
### Memory 1 — Merge near-duplicates
Files: <a.md + b.md>  Keeper: <a.md>
[ ] approve  [ ] reject

## Cross-source patterns (capped at 3)
### Cross-source 1 — <theme>
Sources: <which project trackers / memory files>
Signal: <one-line interpretation>

## Watch list growth
<patterns with only 2 occurrences — aged here for next pass>
```

**Auto-apply vs human-gated:** auto-apply only safe housekeeping (byte-identical duplicates, archived to a folder you can restore from — never deleted). Everything else proposes; the human ticks `[x] approve`; a separate apply command makes the edits.

**Why it matters:** Capture-to-promotion cadence gap means useful patterns sit unpromoted in daily files for weeks, and cross-source patterns (the same blocker across multiple projects, a memory rule contradicting itself) are invisible to any single-session view.

**Level:** Advanced
**Source:** field report: [The Half of Dreaming We Were Missing](https://aaronfulkerson.com/2026/05/13/what-the-dream-found/) (May 2026); survival doctrine from a real 31-day outage: [exo hardening doctrine](https://github.com/AaronRoeF/exo/blob/main/docs/hardening-doctrine.md)
**Pattern to copy:** Build one slash command (e.g., `/dream`, `/consolidate`) that reads the corpus, writes a report following the skeleton above, and a sibling `/apply` command that processes the checkboxes. Run it weekly. Cap, collide-check, and sample-if-oversized are required from day one — they get harder to add later.

### Cross-Skill Gotchas Registry
Create a single `~/.claude/skill-gotchas.md` aggregating gotchas from all skills, organized by category (MCP/Auth, Data Sources, Output/Formatting, Process/Workflow) rather than by skill. Add a CLAUDE.md rule to read it at session start for skill-adjacent tasks. Common gotchas (token expiry, pagination limits, output format drift) stay in context even when the specific skill isn't invoked. Also: mark observations older than 30 days as `[STALE]` if they haven't clustered — and track graduation-to-observation ratio (healthy: 15-25%).

**Why it matters:** Gotchas discovered in one skill (token expiry, pagination limits) reappear in other skills because they are buried in per-skill context instead of a shared registry.

**Level:** Intermediate

### Cross-Linked Navigation Harness for Multi-File Docs

When splitting a document across multiple files (a pattern library, a spec set, a knowledge base), add a consistent navigation bar at the top and bottom of every file. Each bar links to all siblings, the parent, and the index. The current file is bold (not a link); every other file is clickable. No dead-ends — the reader can always jump forward, backward, or up to the table of contents.

```
← [Back to README](README.md) | [Part 2](PART2.md) | **Part 3** | [Part 4](PART4.md)
```

For automated enforcement: add a pre-publish check that verifies every file in a document set has header and footer nav bars. A vault lint skill can detect orphaned docs missing nav harnesses.

**Why it matters:** Multi-file repos on GitHub have no built-in table of contents or sidebar navigation, so without explicit nav bars readers hit dead-ends and leave.

**Level:** Beginner
**Pattern to copy:** For any repo with 3+ related markdown files, add a one-line nav bar (pipe-separated links) to the first and last lines of every file. Bold the current file. Link everything else. Add a structure check to your CI or pre-publish script.

### Project Pulse Files for Completion Tracking

Give every project a `PULSE.md` file that tracks status, completion %, last stop, next actions, and what "finished" looks like. The PULSE is the authoritative source for project state — not your memory, not a task list, not a Jira board.

The minimum viable PULSE:

```yaml
---
project: Feature X
status: active     # idea | active | blocked | done | archived
health: green      # green | yellow | red
completion: 45
priority: p1       # p0 | p1 | p2 | p3
last_touched: 2026-04-19
---
```

Plus three sections: **Last Stop** (where you left off — enough detail that a cold resume works), **Next Actions** (concrete tasks, not vague goals), and **What Finishing Looks Like** (the exit criteria that prevent scope creep).

**Why it matters:** Without explicit project state, every session starts with "where were we?" and loses 10-15 minutes of context reconstruction. The PULSE file eliminates this entirely — Claude reads it and resumes at exactly the right point. More importantly, the "What Finishing Looks Like" section prevents the natural drift from "ship this feature" to "also refactor that module."

**Level:** Intermediate

### Focus Lock with Context-Switch Detection

Use a PreToolUse hook to detect when Claude is about to edit files in a different project directory than the declared focus project. When a switch is detected, the hook injects a warning that forces Claude to update the departing project's PULSE before proceeding.

The pattern:
1. At session start, declare a focus project (write to `~/.claude/current-focus.txt`)
2. A PreToolUse hook on Edit/Write checks if the target file is in a different project directory
3. If it is: inject a "CONTEXT SWITCH DETECTED" warning that halts work until the departing project's PULSE is updated

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{ "type": "command", "command": "~/.claude/hooks/focus-gate.sh" }]
    }]
  }
}
```

**Why it matters:** Context switching without bookmarking is how projects stall at 80%. The focus gate makes switching conscious — you can still switch, but you have to close the loop on what you're leaving. This is mechanical enforcement against wandering, which CLAUDE.md rules alone cannot provide because they degrade after compaction.

**Level:** Advanced

---

## Prompt Engineering

### The 4-Block Prompt Pattern
Structure complex prompts: INSTRUCTIONS (what to do), CONTEXT (background), TASK (specific request), OUTPUT FORMAT (desired result shape). Reduces iterations by ~60%.

**Why it matters:** Without explicit structure, Claude guesses at your output format and context boundaries, causing 2-3 extra back-and-forth cycles per task.

**Level:** Intermediate

### Be Explicit About Actions
"Change this function to improve performance" vs. "Can you suggest some changes?" — Claude is trained for precise instruction following.

**Why it matters:** Vague prompts produce suggestions and commentary instead of working code changes, forcing you to re-prompt with the same intent.

**Level:** Beginner

### Specify Target Files and Constraints
"Fix the auth timeout bug in `/src/auth/login.ts` — we use JWT tokens with 24-hour expiry" beats "Fix the login bug."

**Why it matters:** Without file paths and constraints, Claude spends tokens searching the codebase and may fix the wrong file or introduce incompatible patterns.

**Level:** Beginner

### Iterate in 2-3 Cycles Maximum
The sweet spot is 2-3 feedback cycles. Beyond that, restart with a refined prompt rather than continuing to iterate on a failing approach.

**Why it matters:** After 3+ iterations on the same problem, accumulated context makes Claude anchor on its earlier (wrong) approach rather than reconsidering from scratch.

**Level:** Intermediate

### Start Simple, Add Complexity Only When Needed
Longer prompts are NOT always better. Start with one sentence and add constraints only when results need improvement.

**Why it matters:** Over-specified prompts confuse priority ordering — Claude cannot tell which constraints are essential vs. nice-to-have, so it satisfies none well.

**Level:** Beginner

### Explore → Plan → Implement
Follow Claude's natural three-phase workflow. Skipping exploration significantly increases the risk of undo. Start with "Explore this and tell me how it works" before asking for changes.

**The three phases in practice:**
1. **Explore:** "Read the auth module and tell me how sessions work." Claude reads files, traces call paths, discovers patterns, dependencies, and constraints. This is where Claude finds the existing helper it should reuse instead of writing a duplicate, or the config flag that changes behavior.
2. **Plan:** "Now propose a plan to add session refresh." Claude outlines what to change, in what order, considering what it learned during exploration. Review the plan before proceeding — this is your cheapest intervention point.
3. **Implement:** "Go ahead." Claude executes the approved plan with full awareness of the codebase.

**Common failure mode:** Jumping straight to "add session refresh to the auth module" without exploration. Claude modifies code based on assumptions, misses existing patterns, produces changes that conflict with the rest of the codebase, then discovers constraints mid-implementation and must undo work. The undo itself introduces partial rewrites that leave the codebase in a worse state than before. *Sign you skipped this: Claude starts implementing, then says "wait, I see there's already a..." or "I need to undo what I just did because..."*

**Why it matters:** Skipping exploration means Claude discovers constraints mid-implementation and must undo work, wasting tokens and introducing partial rewrites.

**Level:** Intermediate

### Markdown as State Machine for Workflows
Structure workflow instructions as numbered decision trees with explicit branching, not prose paragraphs. Step numbers provide unambiguous control flow: "Step 3: If ticket has comments containing 'bug' or 'regression', go to Step 3a. Otherwise, Step 4." Claude follows numbered steps more reliably than prose because the structure eliminates ambiguity about ordering and branching.

**Why it matters:** Prose instructions let Claude skip steps or choose its own ordering, while numbered decision trees enforce the exact sequence and branching you intended.

**Level:** Advanced
**Source:** [Adventures in Claude — Exploring /start](https://adventuresinclaude.ai/posts/2026-03-10-exploring-start-how-a-markdown-file-runs-my-development-workflow/)

---

## Business User Workflows

### Claude Cowork for Non-Technical Tasks
Claude Desktop's Cowork mode provides the same agent without requiring a terminal. Draft documents, analyze data, reorganize files, manage invoices. Available on all paid plans.

**Why it matters:** Non-technical users get the same agentic capabilities (file manipulation, multi-step workflows) without needing to install or learn a CLI.

**Level:** Beginner
**Source:** [Claude Cowork](https://claude.com/product/cowork)

### Process Meeting Notes Automatically
Point Claude at meeting transcripts → get action-items organized by owner, priority, and due date. Reduces 15-30 minutes to 2 minutes.

**Why it matters:** Unprocessed meeting notes decay in value within 24 hours — automating extraction ensures action items are captured before context fades.

**Level:** Intermediate

### Headless Mode for Automation
`claude -p "your prompt"` runs non-interactively as a Unix utility. Compatible with pipes: `cat data.csv | claude -p "Analyze trends" --output-format json`

**Why it matters:** Headless mode lets you embed Claude into shell scripts, cron jobs, and CI pipelines where no human is present to interact with a session.

**Level:** Advanced
**Source:** [Claude Code Docs](https://code.claude.com/docs/en/headless)

### Content Creation Pipelines
Use skills and MCPs together: research topics → draft content → format for platforms → schedule distribution. Connect Notion (content DB), Google Drive (storage), Slack (distribution).

**Why it matters:** Manual content pipelines have 3-5 handoff points where work stalls; automating the chain means one prompt produces a published artifact.

**Level:** Advanced

### Multi-Tool Research
Create a skill that combines web search, Playwright (for sites requiring browser automation), and Notion (for internal knowledge) to produce comprehensive research reports.

**Why it matters:** Single-source research misses context that lives in other systems — combining public web, authenticated sites, and internal wikis produces reports with fewer blind spots.

**Level:** Advanced

### Capture Edit Diffs for Voice Learning
At publish time, automatically diff Claude's draft against the human's final edited version. The edits reveal voice preferences, structural habits, and phrasing patterns that improve future drafts. Store diffs as training data for voice-matching skills. Over time, the gap between draft and final version should shrink.

**Why it matters:** Without capturing what humans change, voice-matching skills repeat the same mistakes draft after draft because they have no feedback signal.

**Level:** Advanced
**Source:** [Adventures in Claude — Voice Learning via Edit Diffs](https://adventuresinclaude.ai/posts/2026-02-17-dev-diary/)

---

### Standalone HTML as the Deliverable (the Fungible Artifact)

**WIIFM:** Your reports, plans, and trackers become single files that open perfectly for anyone — your exec team, your phone, another AI agent — with no portal, no permissions, and no formatting roulette.

For anything a human will *read* — a research report, a project plan, a decision brief, a tracker — ask Claude for **one self-contained `.html` file** instead of markdown. Self-contained means everything (styling, any interactivity) lives inside the one file: no internet needed, nothing external to break. The browser is the one runtime everyone already has: the file mails, Slacks, and opens on a phone with perfect formatting, needs no portal or permissions, and — because HTML is still plain text — any agent can re-ingest and edit it later. It's a *fungible* artifact: the same single file moves between human readers, review passes, and Claude sessions without conversion.

The trick that turns format into workflow is **the markup loop**: reviewers drop comments directly into the file — visible callout spans, or invisible `<!-- [reviewer] change this -->` comments — then hand the file back to Claude: *"process every comment, apply the edits, strip the markup."* One artifact carries the draft, the review, and the revision.

**Prompt to copy:** "Produce this as ONE self-contained HTML file — all CSS and JS inline, no external requests, no CDN fonts — styled for reading (max-width column, print-friendly). Include an inline comment convention I can use for review markup."

Field-tested twice over: a ~40-page internal research report shipped company-wide as a single HTML file — no wiki, no access requests, renders identically everywhere; review rounds ran through the comment loop. And OPAQUE's brand design system ships the same way — one standalone HTML file that designers read as the styleguide and agents ingest to apply the brand mechanically. One artifact, both audiences, zero drift between "the doc" and "the spec." Markdown stays for repo docs; HTML is for deliverables.

**Why it matters:** Distribution beats format purity. A deliverable that renders perfectly for a non-technical reader *and* stays machine-editable ends the export-to-PDF / paste-into-docs / lose-the-source cycle — one file is the source, the deliverable, and the review surface.

**Level:** Beginner
**Source:** Thariq Shihipar (Anthropic, Claude Code) — ["HTML is the new markdown"](https://x.com/trq212/status/2052809885763747935) ([long-form in Lenny's Newsletter](https://www.lennysnewsletter.com/p/html-is-the-new-markdown-how-anthropic)). Credited by this repo's author as the inspiration for the practice.

## Cost Optimization

### The opusplan Model Alias
`/model opusplan` uses Opus for planning/reasoning and Sonnet for code execution. Opus-quality thinking at Sonnet execution costs.

**Why it matters:** Most token spend is in code execution (not planning), so routing execution to Sonnet cuts costs ~60% while preserving Opus-level architectural decisions.

**Level:** Intermediate

### Haiku for Quick Tasks
`/model haiku` for simple queries, boilerplate, and routine tasks. 90% of Sonnet capability at 2x speed and 3x cost savings.

**Why it matters:** Using Sonnet or Opus for tasks like "rename this variable" or "add a docstring" burns 3-10x more tokens than necessary for identical output.

**Level:** Beginner

### Refresh After Major Milestones
After completing features or merging PRs, start a fresh session. Long sessions accumulate stale context that makes everything slower and more expensive.

**Why it matters:** Stale context from a completed task causes Claude to reference old code states, producing diffs against files that have already changed.

**Level:** Beginner

### Design Around the Prompt Cache TTL

The Anthropic prompt cache has a 5-minute TTL. When Claude Code sleeps past 300 seconds between actions, the next turn reads your full conversation context uncached — slower and more expensive. Design your workflows around cache windows:

- **Under 270 seconds:** Cache stays warm. Right for active work — checking builds, polling status, iterating on code.
- **Over 300 seconds:** Cache miss. Right when there's genuinely no point checking sooner — waiting on deployments, long builds.
- **Avoid exactly 300 seconds.** It's the worst of both: you pay the cache miss without amortizing it over a meaningfully longer wait.

For `/loop` iterations, pace them to stay inside cache windows when possible. A build that takes 8 minutes? Sleep ~270 seconds twice rather than sleeping 60 seconds eight times (8 cache misses vs. 0).

**Why it matters:** Cache misses multiply your cost per turn by 2-3x with no benefit to output quality. In long autonomous sessions with dozens of iterations, cache-aware pacing can cut total cost by 40-60%.

**Level:** Advanced

---

## Common Pitfalls

### Don't Trust Auto-Accept for Complex Tasks
Auto-accept bypasses human review. Use only on feature branches with recent commits, never on main/production.

**Why it matters:** Auto-accepted changes to main/production cannot be easily reverted once deployed, and Claude may introduce subtle logic errors that pass linting but break behavior.

**Level:** Beginner

### Always Verify Output
Claude may produce plausible-looking code that doesn't handle edge cases. Run tests, review diffs, and check edge cases before committing.

**Why it matters:** Plausible-looking code that passes a quick read can introduce null-pointer errors, off-by-one bugs, or missing error handling that only surfaces in production.

**Level:** Beginner

### Avoid "Kitchen Sink" Sessions
Starting with one task, asking something unrelated, then going back degrades quality for everything. Keep sessions focused on a single topic or task.

**Why it matters:** Mixed-topic context causes Claude to cross-contaminate — referencing variable names from task A while working on task B, or applying the wrong coding style.

**Level:** Beginner

### Don't Over-Specify CLAUDE.md
If Claude keeps ignoring a rule, the file is probably too long. The fix is pruning, not adding more emphasis. A bloated CLAUDE.md is worse than none.

**Why it matters:** Each additional rule dilutes attention on all other rules, so adding "IMPORTANT" markers to fix non-compliance actually makes the problem worse.

**Level:** Intermediate

### Watch for Large Stdin Limitations
Headless mode may return empty output with ~7,000+ character stdin input. For large documents, use file-based input (@-mentions) instead.

**Why it matters:** Silent empty output from large stdin means your CI pipeline or script appears to succeed while producing no actual result.

**Level:** Intermediate

### Inspect Data Before Hypothesizing
For data-dependent bugs, examine actual data first — don't theorize about code paths. Claude defaults to reasoning about code rather than observing data flow. Explicitly instruct: "dump the field values at each pipeline stage before suggesting a fix." Add diagnostic logging early. Run with real data once. One production data inspection often solves bugs faster than 10 hours of code-path reasoning.

**Why it matters:** Claude defaults to reasoning about code paths instead of observing actual data, so it proposes fixes for bugs that do not exist while missing the real cause.

**Level:** Intermediate
**Source:** [Adventures in Claude — The Bug That Was Right in Front of Me](https://adventuresinclaude.ai/posts/the-bug-that-was-right-in-front-of-me/)

### Snapshot-Based Regression Testing for Data Pipelines
Take snapshots of algorithm outputs against production data and commit as baselines. Wire into pre-commit hooks to force review when outputs change. Catches silent behavioral regressions that unit tests miss — especially in ranking, scoring, or transformation logic where "correct" is defined by expected output, not by code structure.

**Why it matters:** Unit tests verify code structure but miss behavioral regressions in ranking/scoring logic where a refactor silently changes output ordering or values.

**Level:** Advanced
**Source:** [Adventures in Claude — Snapshots and Dead Code](https://adventuresinclaude.ai/posts/2026-02-25-dev-diary/)

### Documentation Accuracy Audits
Periodically verify that docs match actual code behavior. Incorrect docs are worse than missing docs — they create false confidence that leads to security vulnerabilities and integration bugs. Build a skill or checklist that cross-references README claims, API docs, and inline comments against what the code actually does.

**Why it matters:** Incorrect docs create false confidence — developers trust documented behavior, skip testing it, and ship integrations that break against actual code.

**Level:** Intermediate
**Source:** [Adventures in Claude — Sixty Tickets and a Backslash](https://adventuresinclaude.ai/posts/sixty-tickets-and-a-backslash/)

---

## Troubleshooting

### MCP Server Won't Start or Silently Fails

**Symptom:** Tools from an MCP server don't appear in the deferred tool set, or calls return connection errors.

**Diagnosis:** Run `claude mcp list` to see server status. Check if the server process is running (`ps aux | grep mcp`). For hosted servers (Notion, etc.), they fail silently at session init — you won't get an error, the tools just won't be available.

**Common fixes:**
- **Auth expired:** Re-run `claude mcp add` to refresh OAuth tokens. Google OAuth tokens expire and need periodic refresh.
- **npm not found:** MCP servers need `npm`/`node` on the PATH. Check that your shell profile loads nvm/fnm.
- **Port conflict:** If using stdio-based servers, check for zombie processes holding the port.
- **Scopes insufficient:** A 403 from a tool usually means the app's OAuth scopes need updating (e.g., HubSpot Private App scopes), not a code fix.

**Why it matters:** Silent MCP failures are the worst kind — skills run without their data sources and produce thin output, and you don't realize the server was down until you notice the briefing is missing email context or CRM data.

**Level:** Intermediate

### Permission Denied Loops

**Symptom:** Claude keeps asking for permission on the same command, even after you approve it.

**Diagnosis:** Check `~/.claude/settings.json` and `.claude/settings.json` — permissions cascade from enterprise → user → project → local. A deny rule at a higher level overrides your allow.

**Common fixes:**
- Run `/permissions` to see all active rules and their sources
- Check for deny rules that match too broadly (e.g., `Bash(*)` denying everything)
- Ensure your allow rules are in the right settings file — project-level rules don't apply in other projects

**Why it matters:** Permission loops kill flow state. Each approve/deny prompt breaks your concentration, and if the same command keeps prompting, it usually means a deny rule is overriding your allow at a higher cascade level.

**Level:** Beginner

### Context Window Exhaustion Mid-Task

**Symptom:** Claude starts losing track of earlier decisions, searching for files it already read, or producing inconsistent output partway through a task.

**Diagnosis:** Run `/context` to check token usage. If you're above 80%, the context is getting crowded. Run `/cost` to see where tokens are being spent.

**Common fixes:**
- Run `/compact` with a focus topic: `/compact Focus on the database migration changes`
- Delegate research to subagents to keep the main context clean
- Use `@file` mentions instead of pasting file contents into the conversation
- If you have 10+ MCP servers, unused tool definitions consume tokens on every turn — disable servers you don't need for this task with `--disable-mcp`

**Why it matters:** Context exhaustion degrades gradually — you don't get an error, you get worse output. Claude starts repeating searches, losing track of decisions, and producing inconsistent code. By the time you notice, you've wasted significant tokens and time.

**Level:** Intermediate

### Hook Not Firing

**Symptom:** A hook you configured doesn't seem to execute.

**Diagnosis:** Check the event type and matcher pattern. Hooks only fire for their registered event (`SessionStart`, `PreToolUse`, `PostToolUse`, `Notification`, `PermissionRequest`). The matcher pattern must match the tool name or subtype.

**Common fixes:**
- Verify the hook is in the right settings file (user vs. project)
- Check that the script is executable (`chmod +x`)
- Test the script independently: `echo '{}' | /path/to/hook.sh`
- Exit code matters: 0 = allow (stdout injected), 2 = block (stderr as feedback), other = allow + log
- Matcher uses glob patterns, not regex — `Edit|Write` matches either tool name

**Why it matters:** Hooks are the enforcement layer — if they're not firing, your CLAUDE.md rules are running unsupported. A non-firing hook is invisible until the behavior it was supposed to enforce fails silently.

**Level:** Intermediate

---

## Latest Features (2025-2026)

### Shared Configs Across Worktrees
Project configs and auto memory automatically share across git worktrees of the same repo. Consistent settings across parallel agents.

**Why it matters:** Without shared configs, each worktree agent diverges in behavior — one follows your CLAUDE.md rules while others use defaults, producing inconsistent output.

**Level:** Intermediate

### Custom Status Line
Install a custom status line showing current model, git branch, uncommitted file count, sync status, and a visual context usage progress bar.

**Why it matters:** Without visible context usage, you cannot tell when you are approaching the compaction threshold until Claude starts forgetting earlier instructions.

**Level:** Advanced
**Source:** [ykdojo/claude-code-tips](https://github.com/ykdojo/claude-code-tips)

### Container Mode for Safe Experimentation
Run Claude Code in Docker with `--dangerously-skip-permissions` for fully autonomous experimentation in isolated environments. Never on your actual system.

**Why it matters:** Full autonomy on your host machine risks destructive file operations or unreviewed network calls, but inside a disposable container the blast radius is zero.

**Level:** Advanced

### 200+ Environment Variables
Claude Code supports 200+ env vars (only ~50 documented). Control API endpoints, model selection, privacy, experimental features, and session parameters.

**Why it matters:** Undocumented env vars control behaviors like telemetry, model routing, and experimental features that cannot be configured any other way.

**Level:** Advanced
**Source:** [Eesel Blog](https://www.eesel.ai/blog/environment-variables-claude-code)

### /permissions to Audit Rules
List all permission rules and see which settings.json they're sourced from. Debug unexpected permission behavior.

**Why it matters:** Permission rules cascade from multiple settings files (user, project, enterprise), and conflicts between them cause unexplained allow/deny behavior.

**Level:** Intermediate

---

← [Back to README](README.md) | [Part 1: Core Architecture](PART1-CORE-ARCHITECTURE.md) | **Part 2: Techniques** | [Part 3: Build a Knowledge Base](PART3-BUILD-A-KNOWLEDGE-BASE.md) | [Part 4: Quick Reference](PART4-QUICK-REFERENCE.md) | [Part 5: Live Examples](PART5-LIVE-EXAMPLES.md)
