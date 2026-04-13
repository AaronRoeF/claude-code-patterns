# Pre-Publish Checks

Run before every publish to GitHub. The script validates security, privacy, quality, and structure. Exit 0 means safe to publish. Exit 1 means problems were found.

## Usage

```bash
bash tests/publish-checks.sh
```

## What It Checks

### Security
- Leaked credentials: API keys, tokens (gho_, ghp_, sk-, xoxb-), passwords, secrets
- Absolute file paths: /Users/, /home/, ~/Library/, iCloud~md~obsidian
- Credential file references: .env contents, .pem, .key, credentials.json

### Privacy
- Internal org names: OPAQUE, CompanyOS, RoebotOS, afkb, ExecOS (case insensitive)
- Personal identifiers: aaron, fulkerson, roebot, opaque.co, aaronroe@gmail
- Internal URLs: notion.so/opaque-systems, Notion page IDs (32-char hex)
- **Allowlisted:** "opaque codes" (generic security term), fictional example names (Sarah Chen, James Park, Acme Corp)

### Quality
- Tip count: verifies actual tip headings match the count claimed in README.md
- Every tip has a `**Level:**` line
- Every tip has a `**Pattern to copy:**` section
- No TODO, FIXME, TBD, or `[!` markers left in text
- No empty sections (heading followed immediately by another heading)

### Structure
- All inter-file markdown links resolve to existing files
- Every PART*.md has nav bars at top and bottom
- README.md links to every PART*.md file that exists
