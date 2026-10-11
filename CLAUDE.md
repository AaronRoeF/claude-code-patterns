# Claude Code Pattern Library

Field-tested techniques for Claude Code, organized into five parts (counts live in README.md). When the user asks about Claude Code workflows, patterns, or best practices, search these files for relevant techniques. Reference techniques by title.

## Structure
- `README.md` — Landing page: architecture overview, getting started, table of contents
- `PART1-CORE-ARCHITECTURE.md` — Part 1: foundational patterns from a live production setup
- `PART2-TECHNIQUES.md` — Part 2: techniques by category (index table at top for scanning)
- `PART3-BUILD-A-KNOWLEDGE-BASE.md` — Part 3: building a persistent AI knowledge base
- `PART4-QUICK-REFERENCE.md` — Part 4: Cheat sheets — keyboard shortcuts, slash commands, MCP starter kit
- `PART5-LIVE-EXAMPLES.md` — Part 5: Live production examples — hooks, test suites, scripts
- `SOURCES.md` — Attribution and sources

## For AI Agents
This repo is designed to be consumed programmatically. To build an implementation plan:
1. Read the README for architecture overview and orientation
2. Read Part 3 (BUILD-A-KNOWLEDGE-BASE) for the step-by-step builder table
3. Read Part 2 (TECHNIQUES) for specific tips relevant to the user's stack
4. Produce a sequenced implementation plan with dependencies
5. Create a PULSE.md tracker for the adoption project itself (see "Project Pulse Files for Completion Tracking" in Part 2) and update it every session, so each future session resumes exactly where this one stopped
6. Three entries bind the plan you produce and the work you do from it:
   - Any MCP server the plan adds is pinned to an exact version or a local checkout — never `npx -y <package>` unpinned (Part 2, "Pin Your MCP Servers").
   - Any scheduled job is not "done" until it has run once under its real launcher on one real input, and the plan says who runs that and when (Part 2, "The First Real Run Decides").
   - Any work you delegate to a subagent comes back with the check the subagent could not do: the premise question, your own one-line mutant against its tests, the gate result, an evidence pass on anything to be published (Part 2, "The Check You Owe Your Delegate"). Report the check, not just the hand-back.
