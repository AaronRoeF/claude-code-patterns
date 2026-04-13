← [Back to README](README.md) | [Part 2: Pro-Tips](PART2-PRO-TIPS.md) | **Part 3: AI Wiki** | [Part 4: Quick Reference](PART4-QUICK-REFERENCE.md) | [Part 5: Implemented Patterns](PART5-IMPLEMENTED-PATTERNS.md)

---

# Part 3: The AI Wiki Pattern

Building a persistent, compounding knowledge base that an LLM maintains for you — not just retrieves from.

Andrej Karpathy [codified this pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) as the "LLM Wiki" — three layers (raw sources, wiki, schema) where the LLM incrementally builds and maintains a structured knowledge base rather than rediscovering knowledge from scratch on every query. Brad Feld's [Adventures in Claude](https://adventuresinclaude.ai/) demonstrated what's possible when you push Claude Code beyond coding into full operational workflows.

What follows is the production implementation: skills, MCP servers, hook scripts, and an Obsidian vault as the persistent wiki layer. Each tip is detailed enough for your Claude agent to implement.

## Build Your Own: Start Here

**Point your Claude agent at this section and tell it to build a plan.** The tips below are ordered by dependency — build in this sequence:

| Step | What to Build | Read Tip | Why First |
|------|--------------|----------|-----------|
| 1 | Three-layer directory structure | The Three-Layer Architecture | Foundation — everything else builds on this |
| 2 | Obsidian vault + MCP server | Obsidian as the Wiki Layer | Your wiki layer needs to exist before you can write to it |
| 3 | YAML frontmatter conventions | YAML Frontmatter as the Metadata Contract | Metadata contract must be set before creating files |
| 4 | INDEX.md + LOG.md | The Index File, The Activity Log | Navigation infrastructure — saves tokens from day one |
| 5 | Source provenance tracking | Source Provenance Tracking | Add `origin:` field convention before files accumulate |
| 6 | First skill (meeting prep with auto-enrichment) | Auto-Enrichment | Highest-ROI skill — proves the system compounds |
| 7 | Learning loop (capture → review → graduate) | Learning Loops | The pattern that makes the system self-improving |
| 8 | Hooks (post-compact reload, then others) | Hooks as Behavioral Enforcement | Behavioral enforcement — instructions suggest, hooks enforce |
| 9 | Vault lint | Vault Lint | Health checks keep the wiki honest as it grows |
| 10 | Dual identity (optional) | Dual Identity | Only if you plan to distribute skills to a team |
| 11 | Parallel publishing to Notion (optional) | Parallel Publishing | Only if your team uses Notion |
| 12 | Context hygiene rules | Context Hygiene as Infrastructure | Add to CLAUDE.md after you've used the system for a week |

**Minimum viable system:** Steps 1-6 give you a working knowledge base with one skill. Steps 7-8 make it self-improving. Steps 9-12 are refinements you add as the system grows.

---

### The Three-Layer Architecture (Sources → Wiki → Schema)

The core architecture has three layers, each with a distinct role:

**Layer 1 — Sources (MCP servers).** Live data feeds, not static file drops. Gmail MCP pulls real email. HubSpot MCP queries live deal data. Calendar MCP reads today's schedule. Granola MCP fetches meeting transcripts. The key insight: MCP servers give Claude real-time access to your operational data without you copying anything into files. Static file drops go stale the moment you save them; MCP feeds are always current.

**Layer 2 — Wiki (Obsidian vault).** The persistent knowledge base Claude writes to and reads from. Structured markdown files with YAML frontmatter: one file per person, per account, per project, per decision. Claude synthesizes data from Layer 1 into durable knowledge artifacts here. This is where knowledge compounds — meeting prep reads a person file, meeting debrief updates it, and the next meeting prep is richer.

**Layer 3 — Schema (CLAUDE.md).** The instructions that tell Claude how to read, write, and maintain the wiki. Trigger phrases, file naming conventions, output locations, metadata contracts, quality rules. Without the schema layer, Claude would write to the wiki inconsistently. CLAUDE.md is the governance layer.

```
your-system/
├── CLAUDE.md                    ← Layer 3: Schema (governance + routing)
├── skills/                      ← Skill definitions (what to do when triggered)
│   ├── meeting-prep.md
│   ├── memo-writer.md
│   └── learning-loop.md
├── mcp/                         ← Layer 1: Source servers (live data feeds)
│   ├── health-api/
│   └── custom-server/
└── ~/.claude.json               ← MCP server registration (global)

knowledge-base/                  ← Layer 2: Wiki (Obsidian vault)
├── people/                      ← One file per key contact
├── accounts/                    ← One file per company/prospect
├── projects/                    ← Working project directories
├── decisions/                   ← RFDs, ADRs, decision log
├── intel/                       ← Competitive, market, signal captures
├── observations/                ← Raw learning captures (TILs)
├── analyses/                    ← Generated analysis artifacts
├── INDEX.md                     ← Content catalog (LLM reads first)
└── LOG.md                       ← Chronological activity record
```

Why live MCP feeds beat static file drops: a person file written six months ago says "VP of Engineering." The LinkedIn MCP (or a Playwright scrape) says "CTO as of last month." Static files are a snapshot; MCP feeds are a live stream. The wiki layer sits between them — durable enough to accumulate knowledge, but updatable when fresh data arrives.

**Level:** Intermediate
**Pattern to copy:** Create a `knowledge-base/` directory (or Obsidian vault) separate from your code repo. Register at least 2-3 MCP servers as live sources. Write CLAUDE.md rules that tell Claude where to read from and write to. Start with `people/` and `projects/` directories — those compound fastest.

---

### Obsidian as the Wiki Layer

Obsidian is not just a markdown editor — it's the ideal wiki layer because of four features that directly serve LLM workflows:

**Wikilinks** (`[[Person Name]]`) create typed relationships between files. When Claude writes a meeting debrief and mentions `[[Sarah Chen]]`, that automatically creates a navigable link. No manual cross-referencing needed. Claude can write wikilinks naturally, and Obsidian resolves them.

**Backlinks** surface implicit connections. Open any person file and the backlinks pane shows every document that references them — meeting notes, project files, decision records. This is discovery infrastructure that requires zero maintenance.

**Graph view** visualizes your entire knowledge base as a network. Clusters reveal which topics are well-connected and which are orphaned. Hub nodes (people or projects with many connections) are visible at a glance. This is a health check you can run by opening a tab.

**YAML frontmatter** provides structured metadata that both Obsidian plugins (Dataview) and Claude can query. Every file gets a typed header with `name`, `type`, `origin`, `last_updated`, and domain-specific fields. Dataview queries can build dynamic tables — "show all people files updated in the last 30 days" — without Claude running anything.

To connect Claude Code to your Obsidian vault, install the Obsidian MCP server:

```json
// In ~/.claude.json
{
  "mcpServers": {
    "obsidian": {
      "command": "npx",
      "args": ["-y", "obsidian-mcp"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/path/to/your/vault"
      }
    }
  }
}
```

This gives Claude tools like `obsidian_search`, `obsidian_read`, `obsidian_create`, `obsidian_append`, `obsidian_backlinks`, `obsidian_tags`, and `obsidian_orphans`. Claude can search for content, read files, create new pages, and navigate the graph — all without you opening Obsidian.

**Level:** Intermediate
**Pattern to copy:** Create an Obsidian vault for your knowledge base. Install Obsidian MCP. Add a CLAUDE.md rule: "When referencing a person, account, or project that has a wiki page, use a wikilink: `[[Name]]`." Start writing files with YAML frontmatter from day one — retrofitting metadata is painful.

---

### Parallel Publishing: Obsidian + Notion

Your personal knowledge graph lives in Obsidian. Your team reads Notion. The parallel publishing pattern keeps both in sync without manual duplication.

The workflow: Claude writes content locally in Obsidian (your source of truth). When you say "publish this to Notion," Claude creates the Notion page via the Notion MCP, then updates the local file's YAML frontmatter with the Notion URL, page ID, and sync timestamp. The frontmatter becomes the link between both systems:

```yaml
---
name: "Q2 Pipeline Health Assessment"
type: analysis
origin: llm-synthesized
notion_url: "https://www.notion.so/your-workspace/Q2-Pipeline-abc123"
page_id: "abc12345-6789-0def-ghij-klmnopqrstuv"
db: "Reports"
asset_type: report
last_synced: 2026-04-12
---
```

Rules for parallel publishing:
1. **Obsidian is always source of truth.** Edits happen locally first, then sync to Notion.
2. **Never edit Notion directly** for content that has a local mirror. If someone comments on the Notion page, incorporate the feedback locally and re-publish.
3. **Track sync state in frontmatter.** `last_synced` tells you (and Claude) when the Notion version was last updated. If local `last_updated` is newer than `last_synced`, the Notion page is stale.
4. **Use `notion_url` for cross-references.** When one Notion page references another, use the actual Notion URL — not the local file path. Local wikilinks are for Obsidian; Notion URLs are for team-facing content.

Add this CLAUDE.md rule: "When publishing to Notion, always update the local file's YAML frontmatter with `notion_url`, `page_id`, `db`, `asset_type`, and `last_synced`. When updating a previously published page, read the frontmatter first to get the `page_id`."

**Level:** Advanced
**Pattern to copy:** Pick one content type to start (meeting notes or decision records). Publish it to Notion after local creation. Build the habit of checking `last_synced` dates. Expand to more content types as the workflow solidifies.

---

### YAML Frontmatter as the Metadata Contract

Every wiki page gets structured YAML frontmatter. This is not decoration — it is the API contract between Claude, Obsidian, and any downstream tools. Without it, Claude must read entire files to understand what they are. With it, Claude can route, filter, and update files by metadata alone.

The universal fields every file gets:

```yaml
---
name: "Display Name"
type: person | account | project | decision | analysis | intel | observation
origin: human | llm-generated | llm-synthesized | mcp-ingested
created: 2026-04-12
last_updated: 2026-04-12
---
```

**Person file** — a key contact in your network:
```yaml
---
name: "Sarah Chen"
type: person
origin: human
company: "Acme Corp"
role: "VP of Engineering"
relationship: prospect | customer | partner | colleague | investor
last_meeting: 2026-04-10
last_updated: 2026-04-10
tags: [enterprise, infrastructure, decision-maker]
---
```

**Account file** — a company or prospect:
```yaml
---
name: "Acme Corp"
type: account
origin: llm-synthesized
industry: financial-services
stage: evaluation | poc | negotiation | customer | churned
deal_size: "$150K ACV"
key_contacts: ["[[Sarah Chen]]", "[[James Park]]"]
last_updated: 2026-04-08
tags: [enterprise, fsi, q2-pipeline]
---
```

**Analysis file** — a generated artifact:
```yaml
---
name: "Q2 Pipeline Health Assessment"
type: analysis
origin: llm-synthesized
source_skill: metrics-dashboard
inputs: [hubspot-deals, hubspot-contacts]
confidence: high | medium | low
last_updated: 2026-04-12
related: ["[[Q1 Pipeline Review]]", "[[2026 Revenue Targets]]"]
---
```

Dataview queries in Obsidian can then surface tables like:

```dataview
TABLE role, company, last_meeting
FROM "people"
WHERE last_meeting < date(today) - dur(30 days)
SORT last_meeting ASC
```

This query shows contacts you have not met with in 30+ days — no Claude involvement needed, just metadata doing its job.

**Level:** Intermediate
**Pattern to copy:** Define your frontmatter schema before creating files. Add a CLAUDE.md rule: "Every new file in the knowledge base MUST include YAML frontmatter with at minimum: `name`, `type`, `origin`, `created`, `last_updated`." Enforce domain-specific fields per type. The upfront cost is small; the queryability payoff is permanent.

---

### Learning Loops: Capture → Review → Graduate

This is the pattern that turns a knowledge base into a flywheel. Without it, your wiki is a filing cabinet — useful but static. With it, the system gets smarter from your daily work.

**Layer 1: Capture.** Raw signals from daily work — observations, meeting takeaways, market signals, execution insights. Low friction, low ceremony. A single line or short paragraph. Stored in dated files:

```
observations/
├── 2026-04-10.md      ← 3 observations from today
├── 2026-04-11.md      ← 2 observations
├── 2026-04-12.md      ← 4 observations
└── REVIEW-LOG.md      ← tracks review dates and graduation decisions
```

Each observation is a single block:

```markdown
### OBS-2026-04-12-001
**Signal:** Prospect asked about audit logs three times during demo
**Category:** product-gap | buyer-signal | process-insight | tool-learning
**Source:** Demo call with Acme Corp
**Confidence:** high
```

Capture triggers fire naturally: end-of-day wrap-up, post-meeting debrief, git commit hook, or explicit "TIL: [observation]" trigger phrase.

**Layer 2: Review.** Periodic (weekly or when 30+ observations accumulate) scan across all captures. Claude reads all unreviewed observations, clusters them by theme, identifies patterns that appear 3+ times, and proposes graduations. The review is machine-assisted but human-approved — Claude proposes, you decide.

```markdown
## Review: 2026-04-12
**Observations reviewed:** 36 (from 2026-03-28 to 2026-04-12)

### Theme: Buyers consistently ask about audit logging
- OBS-2026-04-01-003, OBS-2026-04-05-001, OBS-2026-04-10-002, OBS-2026-04-12-001
- **Pattern strength:** 4 independent instances across 3 accounts
- **Proposed graduation:** Add "audit logging" to product gap tracker; update sales FAQ

### Theme: Claude loses context when switching between research and writing
- OBS-2026-03-30-002, OBS-2026-04-03-001, OBS-2026-04-09-003
- **Pattern strength:** 3 instances
- **Proposed graduation:** Add CLAUDE.md rule — "/clear between research and writing phases"
```

**Layer 3: Graduate.** Validated patterns get applied to real operational artifacts. A product gap observation graduates into a roadmap item. A process insight graduates into a CLAUDE.md rule. A buyer signal graduates into updated sales messaging. Graduation is the act of turning raw signal into durable system improvement.

The file structure for the full loop:

```
knowledge-base/
├── observations/               ← Layer 1: raw captures
│   ├── YYYY-MM-DD.md
│   └── REVIEW-LOG.md          ← tracks reviews and decisions
├── CLAUDE.md rules             ← Layer 3 target: graduated process rules
├── skills/                     ← Layer 3 target: graduated skill improvements
└── people/ accounts/ intel/    ← Layer 3 target: graduated knowledge updates
```

**Level:** Advanced
**Pattern to copy:** Start with capture only. Add a CLAUDE.md rule: "When I say 'TIL: [text]', append an observation to `observations/YYYY-MM-DD.md` with the standard format." Run your first review after 30 observations accumulate. Graduate one pattern into a real artifact. The loop will feel valuable immediately, and it compounds over time.

---

### The Index File: Content Catalog the LLM Reads First

At moderate scale (100-500 wiki pages), an LLM cannot efficiently search everything. Embedding-based RAG is one solution, but a simpler one works for most personal knowledge bases: a maintained INDEX.md that catalogs everything by type.

Claude reads INDEX.md first, before searching. It acts as a table of contents for the entire vault. Each entry is one line: a relative link and a one-line description.

```markdown
# INDEX.md — Knowledge Base Catalog
Last updated: 2026-04-12 | Total pages: 247

## People (43 files)
- [[Sarah Chen]] — VP Eng at Acme Corp, primary technical evaluator
- [[James Park]] — CISO at Acme Corp, security sign-off authority
- [[Maria Santos]] — CTO at Beacon Health, champion for Q2 deal
...

## Accounts (28 files)
- [[Acme Corp]] — Enterprise FSI, evaluation stage, $150K ACV
- [[Beacon Health]] — Healthcare, POC active, $200K ACV
...

## Projects (12 files)
- [[Q2 Launch]] — Product launch targeting June 15
- [[API Redesign]] — Architecture overhaul, ADR pending
...

## Decisions (18 files)
- [[RFD-042 Pricing Model]] — Approved 2026-03-15, usage-based pricing
- [[ADR-007 Auth Architecture]] — Approved 2026-04-01, OAuth2 + PKCE
...

## Intel (15 files)
- [[Competitor X Q2 Moves]] — New product launch, pricing shift
...

## Observations (131 entries across 34 daily files)
- Latest: 2026-04-12 | Unreviewed: 28 | Last review: 2026-04-05
```

Add this CLAUDE.md rule: "Before searching the vault for a topic, read `INDEX.md` first. If the topic matches an index entry, read that file directly instead of running a broad search. When creating or deleting wiki pages, update INDEX.md."

At this scale, INDEX.md eliminates the need for vector embeddings, semantic search infrastructure, or RAG pipelines. The LLM can reason about the catalog directly.

**Level:** Intermediate
**Pattern to copy:** Create INDEX.md with sections matching your vault's directory structure. Add entries as you create files. Add a CLAUDE.md rule requiring Claude to read INDEX.md before vault searches and to update it on file creation. Review and prune quarterly.

---

### The Activity Log: Chronological Record of Knowledge Evolution

INDEX.md tells Claude what exists. LOG.md tells Claude what happened, and when. It is an append-only chronological record of significant wiki operations.

```markdown
# LOG.md — Knowledge Base Activity Log

## [2026-04-12] create | [[Q2 Pipeline Health Assessment]]
Source: metrics skill, HubSpot data pull. 47 deals analyzed.

## [2026-04-12] update | [[Sarah Chen]]
Added notes from April 10 meeting. Updated role to CTO (promoted).

## [2026-04-11] graduate | CLAUDE.md rule #14
Pattern: "Claude loses context switching research → writing." 3 observations.
Graduated to: "/clear between research and writing phases" rule.

## [2026-04-11] ingest | [[Acme Corp]]
MCP source: HubSpot deal update. Stage moved to negotiation.

## [2026-04-10] review | observations
36 observations reviewed. 2 graduated, 5 on watch list. See REVIEW-LOG.md.

## [2026-04-09] archive | [[Q1 Pipeline Review]]
Superseded by Q2 assessment. Moved to archive/.
```

Verbs: `create`, `update`, `ingest`, `graduate`, `review`, `archive`, `lint`. Each entry is one heading line (grep-parseable) plus an optional one-line description.

To query recent activity: `grep "^## \[" LOG.md | tail -20` shows the last 20 operations. To find all graduations: `grep "graduate" LOG.md`. To see what changed this week: `grep "2026-04-0[7-9]\|2026-04-1[0-2]" LOG.md`.

Add this CLAUDE.md rule: "After any create, update, delete, graduate, or review operation on a wiki file, append a LOG.md entry with the format: `## [YYYY-MM-DD] verb | [[Page Name]]` followed by a one-line description."

**Level:** Intermediate
**Pattern to copy:** Create LOG.md in your vault root. Add the CLAUDE.md append rule. Skills that produce output should include a LOG.md append step. Review the log monthly to understand your wiki's evolution patterns.

---

### Source Provenance Tracking

When a knowledge base mixes human-written, LLM-generated, and MCP-ingested content, knowing the origin of each file becomes critical. The `origin` field in YAML frontmatter tracks this:

- **`human`** — Written by a person. Ground truth. Highest trust.
- **`llm-generated`** — Claude produced this from a prompt (e.g., a drafted memo, a PR/FAQ). Creative output. Should be reviewed before relying on it as fact.
- **`llm-synthesized`** — Claude assembled this from multiple sources (e.g., a meeting prep that combines calendar data, email threads, and person files). Derivative work. Quality depends on source quality.
- **`mcp-ingested`** — Pulled directly from an MCP source (e.g., HubSpot deal data, calendar events). Machine-to-machine. Accurate at time of ingestion but may go stale.

Why this matters: a vault lint (see Vault Lint below) can flag files where `origin: llm-generated` and `last_updated` is 90+ days old — likely stale creative output that should be reviewed or archived. It can also distinguish source material from derived content when checking for broken references.

Provenance also affects how Claude should treat content. Add this CLAUDE.md rule: "When citing information from a wiki page, note its origin. Treat `human` and `mcp-ingested` as factual. Treat `llm-generated` and `llm-synthesized` as provisional — verify against live sources when accuracy matters."

**Level:** Intermediate
**Pattern to copy:** Add `origin:` to your frontmatter schema. Set it when files are created — do not try to retroactively classify existing files (just mark them `human` and move on). Let the provenance data accumulate naturally.

---

### Hooks as Behavioral Enforcement

CLAUDE.md instructions are probabilistic — Claude follows them most of the time, but can reason around them under pressure or in long contexts. Hooks are deterministic — they execute code on specific events, and exit code 2 blocks the action entirely.

The most impactful hook pattern is the **safety gate**: a hook that intercepts a dangerous action and requires explicit confirmation before proceeding.

Example — email send gate:

```bash
#!/bin/bash
# ~/.claude/hooks/email-safety-gate.sh
# Fires on: PreToolUse → gmail_send_email, send_email

# Extract the recipient from the tool input (passed as JSON on stdin)
INPUT=$(cat)
TO=$(echo "$INPUT" | jq -r '.input.to // .input.recipient // "unknown"')
SUBJECT=$(echo "$INPUT" | jq -r '.input.subject // "no subject"')

# Always block and require confirmation
echo "SAFETY GATE: About to send email" >&2
echo "  To: $TO" >&2
echo "  Subject: $SUBJECT" >&2
echo "  Say 'approve' to send, or 'deny' to cancel." >&2
exit 2
```

Configure in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "gmail_send_email|send_email",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/email-safety-gate.sh"
          }
        ]
      }
    ]
  }
}
```

Other high-value hook patterns:
- **TIL capture on commit** (`PostToolUse` on git commit) — prompts for observations after every commit
- **MCP audit log** (`PostToolUse` on gmail/slack/drive) — appends timestamp + tool + params to an audit file
- **Context reload after compaction** (`SessionStart` with compact subtype) — re-injects critical state that compaction might lose
- **Auto-test on file changes** (`PostToolUse` on Edit/Write for test files) — runs the test suite when test files change

The key insight: instructions in CLAUDE.md say "you should." Hooks say "you must" — and enforce it with exit codes, not compliance.

**Level:** Advanced
**Pattern to copy:** Start with one safety gate hook on your most dangerous MCP action (email send, Slack post, or git push). Use `exit 2` to block and surface confirmation. Expand to audit logging and capture triggers once the pattern is proven.

---

### Dual Identity: Personal vs. Distributable

If you build a system useful enough for yourself, colleagues will want it. The dual identity pattern separates personal capabilities from distributable ones, so you can share the work layer without exposing the personal layer.

```
personal-system/                 ← Your private repo (never shared)
├── CLAUDE.md                    ← Personal routing, identity, preferences
├── skills/
│   ├── health.md                ← Wearable data analysis (personal)
│   ├── productivity.md          ← Personal workflow tools (personal)
│   └── research.md              ← Private data analysis (personal)
├── mcp/
│   ├── health-api/              ← Wearable data server (personal)
│   └── custom-server/           ← Custom data source (personal)
└── knowledge-base/              ← Personal vault (never shared)

work-system/                     ← Distributable repo (shared with team)
├── CLAUDE.md                    ← Work triggers, team skills, shared context
├── skills/
│   ├── meeting-prep.md          ← Meeting workflows (distributable)
│   ├── doc-generator.md         ← Structured documents (distributable)
│   ├── project-mgmt.md          ← Project planning (distributable)
│   └── decision-records.md      ← Decision documentation (distributable)
├── installer.md                 ← Setup instructions for new users
└── refs/                        ← Shared reference material
```

The critical rule: **the distributable layer has zero imports, file references, symlinks, or `../` paths pointing to the personal layer.** If a colleague clones the work system and it fails because it cannot find `../personal-system/health.md`, the isolation is broken.

Test the isolation: clone the work system into an empty directory and run every skill. If anything fails with a file-not-found error, you have a dependency leak.

The work layer isn't theoretical. I package it independently and distribute it to every member of my team. They clone the repo, run the installer, and get the full skill set configured for their own identity. When they say "prep [name]" it uses their calendar, their email, their CRM access. Same skills, different data. The personal layer stays on my machine. The work layer runs across the entire company.

Identity detection makes the shared system adaptive. Add a user identity check at the top of CLAUDE.md: "Check `git config user.name` to determine who is using this. Adapt voice, defaults, and author fields accordingly." The system owner gets their personal voice applied; everyone else gets clean professional prose.

**Level:** Advanced
**Pattern to copy:** If you are building skills others might use, create a separate repo for the distributable layer from day one. Add an isolation rule to CLAUDE.md: "This repo MUST function with zero dependencies on external repos." Test by cloning into `/tmp` and running skills.

---

### Context Hygiene as Infrastructure

Context management is not a technique you apply occasionally — it is infrastructure you build once and enforce always. Without it, long sessions degrade: Claude forgets earlier decisions, searches for things already discussed, mixes context between unrelated tasks, and hits auto-compaction at 95% where critical information gets compressed into noise.

The top 5 rules to implement first:

**1. Compact at 78%, not 95%.** Add this CLAUDE.md rule: "Use /compact proactively when context reaches ~78% capacity. Do not wait for the automatic 95% threshold. Manual compaction produces better summaries while preserving maximum useful context." The 78% number gives Claude room to do a thoughtful summary rather than an emergency compression.

**2. /clear between unrelated tasks.** If you switch from researching a deal to writing a blog post, context from the research contaminates the writing. Add: "If the user switches between completely different topics, suggest a /clear first."

**3. Target 3-5 files per task.** Never bulk-load your project. Add: "Focus on the 3-5 most relevant files. Do not load entire project trees into context. Let search tools find what you need." Sign you are over-loading: searching within your own context instead of using grep/glob.

**4. Delegate exploration to subagents.** Research, codebase analysis, and multi-file search generate volumes of intermediate output that pollute the main context. Add: "For research or exploration tasks, prefer subagents. Each subagent gets its own context window." The main thread stays clean for decision-making.

**5. 2-3 iteration max per failing approach.** If something is not working after 2-3 attempts, the approach is wrong — not the execution. Add: "If something is not working after 2-3 attempts, stop. Reassess the approach, propose a different strategy, or suggest /clear to start fresh."

Failure-mode anchors make these rules self-diagnosing. Append to each rule: `*Sign you violated this: [observable symptom].*` Examples: "Sign you waited too long to compact: repeated searches for things already discussed." "Sign of context bleed: accidentally referencing deal names in a blog post draft."

**Level:** Intermediate
**Pattern to copy:** Add all 5 rules to your CLAUDE.md. Include the failure-mode anchors. These rules pay back immediately — the first time Claude suggests `/clear` before you notice context degradation, the system has justified itself.

---

### Auto-Enrichment: Side-Effect Knowledge Accumulation

The most effective knowledge bases are not maintained in dedicated sessions — they accumulate knowledge as a side effect of normal work. Every skill that reads from the wiki should also write back to it.

The pattern:

| Skill | Reads | Writes (side effect) |
|-------|-------|---------------------|
| Meeting prep | Person file, account file, recent emails | (nothing yet — prep is read-only) |
| Meeting debrief | Meeting notes, person file | Updates person file with new context, updates account file with deal status |
| Email triage | Inbox, person files | Updates person file with "last contacted" date, flags account status changes |
| Deal review | CRM data, account file | Updates account file with current stage, key contacts, blockers |
| Competitive intel | Web search, intel files | Updates or creates competitor file with new findings |

The CLAUDE.md rules that enable this:

```markdown
## Auto-Enrichment Rules

- When a meeting debrief mentions a person who has a wiki page, update their
  `last_meeting` date and append key context under a `## Meeting Notes` section.
- When email triage surfaces a reply from a key contact, update their person
  file's `last_contacted` field.
- When a deal moves stages in your CRM, update the corresponding account file's
  `stage` field.
- All enrichment updates must also update the `last_updated` frontmatter field
  and append a LOG.md entry.
```

The key constraint: **each directory has clear ownership.** Person files are updated by meeting-related and email-related skills. Account files are updated by deal-related skills. Intel files are updated by research skills. No file should be written to by every skill — that creates merge conflicts and inconsistent formatting.

```markdown
## Directory Ownership

- people/     → meeting prep, meeting debrief, email triage
- accounts/   → deal review, meeting debrief, competitive intel
- intel/      → competitive intel, market research
- decisions/  → decision record skill only
- observations/ → learning loop capture only
```

Over time, person files that started as a name and title accumulate meeting context, communication patterns, deal involvement, and relationship history — all without a single dedicated "update this person file" session.

**Level:** Advanced
**Pattern to copy:** Pick your most-used skill (likely meeting prep/debrief). Add one write-back rule: "After a meeting debrief, update the person file with `last_meeting` and key takeaways." Run it for two weeks. The compounding effect will motivate adding more auto-enrichment rules.

---

### Vault Lint: Periodic Health Checks

A knowledge base without maintenance degrades. Files go stale, links break, metadata drifts, and orphan pages accumulate. A vault lint skill runs periodic health checks and produces a report card — but makes no changes without human approval.

The checks:

1. **Orphan pages** — files with zero inbound wikilinks. They exist but nothing points to them. Likely forgotten or mis-named.
2. **Broken wikilinks** — `[[Page Name]]` references where no matching file exists. Indicates deleted or renamed pages.
3. **Stale files** — `last_updated` older than 90 days. Content may be outdated.
4. **Under-linked hubs** — files of type `account` or `project` with fewer than 3 inbound links. Hub pages should be well-connected.
5. **Missing provenance** — files without an `origin` field in frontmatter. Cannot assess trustworthiness.
6. **Unreviewed observations** — observation count since last review. Triggers a review recommendation at 30+.

The report card format:

```markdown
# Vault Health Report — 2026-04-12

## Summary
- Total pages: 247
- Health score: 72/100

## Issues Found

### Critical (fix soon)
- 3 broken wikilinks: [[Jon Smith]] (did you mean [[John Smith]]?),
  [[Q1 Review]] (archived — update reference), [[Pricing V2]] (not found)
- 12 files missing `origin` in frontmatter

### Warning (review when convenient)
- 8 orphan pages (no inbound links) — see list below
- 15 stale files (90+ days since last update)
- 34 unreviewed observations (last review: 2026-03-27)

### Info
- 4 under-linked hub pages: [[Acme Corp]] (1 link), [[Q3 Roadmap]] (2 links)

## Orphan Pages
1. people/old-contact.md — created 2025-11-03, never linked
2. intel/competitor-y-old.md — superseded by competitor-y.md
...

## Recommended Actions
- [ ] Fix 3 broken wikilinks
- [ ] Add `origin` to 12 files (batch: mark as `human` if manually created)
- [ ] Review or archive 8 orphan pages
- [ ] Run `learn review` for 34 unreviewed observations
```

The lint skill is read-only. It identifies problems and recommends fixes. All changes require explicit human approval. This is important — automated cleanup of a knowledge base risks deleting context that looks stale but is actually important.

Add a CLAUDE.md trigger: "When I say 'vault lint' or 'vault health', run the health check and produce the report card. Do not make any changes — only report findings and recommend actions."

**Level:** Advanced
**Pattern to copy:** Create a lint skill that checks for orphan pages, broken wikilinks, and stale files. Start with just those three checks — they catch 80% of vault degradation. Run monthly. Expand checks as your vault grows.

---

← [Part 2: Pro-Tips](PART2-PRO-TIPS.md) | [Next: Part 4 — Quick Reference](PART4-QUICK-REFERENCE.md) | [Back to README](README.md)
