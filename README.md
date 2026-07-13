# Claude Code Pattern Library

**Clone this repo. Point Claude at it. Tell it to build you a plan.**

That's the whole idea. This is a field-tested collection of patterns, architecture decisions, and operational techniques for turning Claude Code into something that compounds — where every session makes the next one smarter. 161 techniques, all production-tested, organized so both humans and AI agents can consume them.

I built the system this grew out of to run my company. Meeting prep that pulls calendar, email, CRM, and LinkedIn data in 30 seconds. Skills that ghostwrite in my voice. A knowledge base that gets richer every session without me maintaining it. Hooks that enforce discipline I'd otherwise forget. The patterns here are the genericized versions — stripped of anything company-specific, structured so you can replicate them.

> **For AI agents:** This repo is designed to be consumed programmatically. Each part is self-contained with clear headings, structured examples, and implementation details. Point your agent at any part file and it has enough context to build an implementation plan.

---

## Get Started in 60 Seconds

```
git clone https://github.com/AaronRoeF/claude-code-patterns.git
cd claude-code-patterns
```

Then open Claude Code and say:

> "Read PART3-BUILD-A-KNOWLEDGE-BASE.md and build me a plan for setting this up with my stack."

Claude reads the patterns, asks what you're working with, and produces a step-by-step implementation plan. That's it.

**Already have a setup?** Point Claude at `PART2-TECHNIQUES.md` for 129 specific tips to sharpen what you've got. Or `PART1-CORE-ARCHITECTURE.md` to compare your architecture against 11 foundational patterns.

---

## The Architecture (How This Actually Works)

The system that produced these patterns runs three layers. You don't need all three to start — but understanding the shape helps you see where the patterns fit.

```
┌──────────────────────────────────────────────────────────┐
│                    CLAUDE.md (Schema)                    │
│         Identity · Routing · Rules · Guardrails          │
│                                                          │
│  "prep Sarah"    → loads meeting-prep skill              │
│  "scan email"    → loads email-triage skill              │
│  "draft a post"  → loads voice skill                     │
└────────────────────────────┬─────────────────────────────┘
                            │ dispatches to
            ┌───────────────┴────────────────┐
            ▼                ▼                 ▼
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│   WORK SKILLS    │ │ PERSONAL SKILLS  │ │  KNOWLEDGE BASE  │
│   (team repo)    │ │    (private)     │ │ (Obsidian vault) │
│                  │ │                  │ │                  │
│  Meeting prep    │ │  Health data     │ │  people/         │
│  PM workflows    │ │  Task mgmt       │ │  accounts/       │
│  CRM analytics   │ │  Msg analysis    │ │  projects/       │
│  Content review  │ │  Learning        │ │  observations/   │
│  Email triage    │ │  Vault ops       │ │  decisions/      │
└────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘
         └──────────┬─────────┘                    │
                    ▼                              │
┌─────────────────────────────────────────┐        │
│           MCP SERVERS (global)          │◄───────┘
│                                         │
│  Gmail · Calendar · Slack · Drive       │
│  Jira · Notion · Playwright · CRM       │
│  + custom servers for local data        │
└───────────────────┬─────────────────────┘
                    ▼
┌──────────────────────────────────────────────────────────┐
│                   HOOKS (Enforcement)                    │
│                                                          │
│  SessionStart:  project dashboard, context reload        │
│  PreToolUse:    focus gate, safety checks                │
│  PostToolUse:   audit log, test sync, learning capture   │
│  Notification:  desktop/mobile alerts                    │
│  Permission:    phone approval via push notification     │
└──────────────────────────────────────────────────────────┘
```

**The flywheel:** Skills pull live data from MCP servers → process and produce output → write enriched data to the knowledge base → next session starts with richer context. Meeting prep reads contact files that were updated by the last debrief. Every session compounds.

**Five architectural decisions that make it work:**

1. **Separation of concerns.** Work skills in one repo (distributable to teammates), personal skills in another (private), knowledge base separate from both. Each has its own focused CLAUDE.md.

2. **Progressive disclosure.** CLAUDE.md is the router, not the encyclopedia. Heavy reference data (personas, brand guides, API docs) loads only when a skill fires. Keeps baseline token cost low.

3. **Hooks for enforcement, CLAUDE.md for judgment.** CLAUDE.md rules degrade after `/compact`. Hooks fire mechanically regardless. Use hooks for anything that must never be skipped.

4. **Broad permissions, narrow gates.** Claude can read all email, access Slack, browse the web. Guardrails are in the skills, not the permissions. Draft-then-confirm at the point of consequence.

5. **The knowledge base compounds.** Every skill that touches external data writes enriched data back to the knowledge base. The 10th meeting prep for the same contact is dramatically better than the first.

---

## What's Inside

| Part | What You Get | Count |
|------|-------------|-------|
| **[Part 1: Core Architecture](PART1-CORE-ARCHITECTURE.md)** | Foundational patterns from a live production setup — the decisions that create leverage | 11 |
| **[Part 2: Techniques](PART2-TECHNIQUES.md)** | Field-tested tips in 16 categories, each rated Beginner / Intermediate / Advanced | 137 |
| **[Part 3: Build a Knowledge Base](PART3-BUILD-A-KNOWLEDGE-BASE.md)** | Step-by-step guide to building a persistent, compounding AI knowledge base (the Karpathy LLM Wiki pattern, production-grade) | 13 |
| **[Part 4: Quick Reference](PART4-QUICK-REFERENCE.md)** | Cheat sheets — keyboard shortcuts, slash commands, MCP starter kit, 5-minute setup | — |
| **[Part 5: Live Examples](PART5-LIVE-EXAMPLES.md)** | Hooks, test suites, and scripts actually running in production right now | — |

**Total: 161 field-tested techniques.** Not aspirational — deployed.

---

## Who This Is For

**Power users** who've been using Claude Code for weeks and want to go from productive to compounding. You're past "how do I set up CLAUDE.md" and into "how do I build a system that gets smarter every session."

**Business operators** who use Claude Code for more than coding — meeting prep, email triage, document generation, CRM analytics. The patterns here treat Claude as an operating system, not a code assistant.

**Teams** evaluating how to standardize Claude Code across an org. The architecture section shows how one skill set serves multiple users with identity-aware execution.

**AI agents** consuming this repo as reference material. Every part file is self-contained with enough context to generate implementation plans.

---

## Key Sources

For full attribution, see [SOURCES.md](SOURCES.md).

- [Andrej Karpathy — LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — the pattern that inspired Part 3
- [Adventures in Claude](https://adventuresinclaude.ai/) — 35 posts on Claude Code workflows and operational patterns
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
- [MCP Specification — Tools](https://modelcontextprotocol.io/specification/2025-11-25/server/tools.md)

---

## Contributing

This pattern library is a living document. If you've discovered a technique that makes Claude Code significantly more effective, we want it.

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
