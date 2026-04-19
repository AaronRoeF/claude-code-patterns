#!/usr/bin/env bash
# Pre-publish checks for claude-code-patterns
# Run: bash tests/publish-checks.sh
# Exit 0 = safe to publish, Exit 1 = issues found

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

# Expected file set
EXPECTED_FILES=(README.md PART1-CORE-ARCHITECTURE.md PART2-TECHNIQUES.md PART3-BUILD-A-KNOWLEDGE-BASE.md PART4-QUICK-REFERENCE.md PART5-LIVE-EXAMPLES.md)

# Counters
security_issues=0
privacy_issues=0
privacy_allowlisted=0
quality_issues=0
structure_issues=0

# Collectors
security_details=()
privacy_details=()
quality_details=()
structure_details=()

# ═══════════════════════════════════════════
# SECURITY CHECKS
# ═══════════════════════════════════════════

# Helper: grep wrapper that excludes meta-files (PUBLISH-CHECKS.md, tests/)
scan_grep() {
    grep "$@" | grep -v 'PUBLISH-CHECKS\.md' | grep -v '^\./tests/'
}

# API keys, tokens, passwords, secrets
while IFS= read -r line; do
    security_details+=("$line")
    ((security_issues++))
done < <(scan_grep -rn -i -E '(api[_-]?key|secret[_-]?key|password|passwd)\s*[:=]\s*["\x27]?[A-Za-z0-9]' --include='*.md' . 2>/dev/null || true)

while IFS= read -r line; do
    security_details+=("$line")
    ((security_issues++))
done < <(scan_grep -rn -E '(gho_|ghp_|sk-[a-zA-Z0-9]{20,}|xoxb-|xoxp-|AKIA[A-Z0-9]{16})' --include='*.md' . 2>/dev/null || true)

# Absolute file paths
while IFS= read -r line; do
    security_details+=("$line")
    ((security_issues++))
done < <(scan_grep -rn -E '(/Users/[a-zA-Z]|/home/[a-zA-Z]|~/Library/|iCloud~md~obsidian)' --include='*.md' . 2>/dev/null || true)

# .env file contents or credential file references
while IFS= read -r line; do
    security_details+=("$line")
    ((security_issues++))
done < <(scan_grep -rn -E '(\.env\b|credentials\.json|\.pem\b|\.key\b)' --include='*.md' . 2>/dev/null | grep -v -E '(\.env file|\.env example|example\.env|\.env\.local|\.env`|\.env\b.*\.sh|naming-conventions\.env)' || true)

# ═══════════════════════════════════════════
# PRIVACY CHECKS
# ═══════════════════════════════════════════

# Allowlist patterns (kept as extended regex)
ALLOWLIST='(opaque codes|Sarah Chen|James Park|Acme Corp)'

# Internal names
while IFS= read -r line; do
    if echo "$line" | grep -qiE "$ALLOWLIST"; then
        ((privacy_allowlisted++))
    else
        privacy_details+=("$line")
        ((privacy_issues++))
    fi
done < <(scan_grep -rn -i -E '\b(OPAQUE|CompanyOS|RoebotOS|afkb|ExecOS)\b' --include='*.md' . 2>/dev/null || true)

# Personal identifiers
while IFS= read -r line; do
    if echo "$line" | grep -qiE "$ALLOWLIST"; then
        ((privacy_allowlisted++))
    else
        privacy_details+=("$line")
        ((privacy_issues++))
    fi
done < <(scan_grep -rn -i -E '\b(aaron|fulkerson|roebot)\b|opaque\.co|aaronroe@gmail' --include='*.md' . 2>/dev/null || true)

# Internal URLs
while IFS= read -r line; do
    privacy_details+=("$line")
    ((privacy_issues++))
done < <(scan_grep -rn -E 'notion\.so/opaque-systems|[^/][0-9a-f]{32}[^/0-9a-f]' --include='*.md' . 2>/dev/null || true)

# ═══════════════════════════════════════════
# QUALITY CHECKS
# ═══════════════════════════════════════════

# Count techniques by heading type across files:
#   PART1: ## headings are techniques
#   PART2: ### headings are techniques (outside code blocks)
#   PART3: ### headings are techniques (outside code blocks)
part1_tips=$(grep -c '^## ' PART1-CORE-ARCHITECTURE.md 2>/dev/null || echo 0)
part2_tips=$(awk 'BEGIN{n=0;c=0} /^```/{c=!c;next} !c && /^### /{n++} END{print n}' PART2-TECHNIQUES.md 2>/dev/null || echo 0)
part3_tips=$(awk 'BEGIN{n=0;c=0} /^```/{c=!c;next} !c && /^### /{n++} END{print n}' PART3-BUILD-A-KNOWLEDGE-BASE.md 2>/dev/null || echo 0)
actual_count=$((part1_tips + part2_tips + part3_tips))

# Get claimed count from README header (e.g., "158 techniques")
claimed_count=$(grep -oE '[0-9]+ techniques' README.md 2>/dev/null | head -1 | grep -oE '[0-9]+' || echo "0")

if [[ "$actual_count" -ne "$claimed_count" ]]; then
    quality_details+=("Technique count mismatch: README claims $claimed_count, found $actual_count (PART1=$part1_tips, PART2=$part2_tips, PART3=$part3_tips)")
    ((quality_issues++))
fi

# Verify PART2 header count matches actual ### heading count
part2_claimed=$(grep -oE '[0-9]+ .*(technique|field-tested)' PART2-TECHNIQUES.md 2>/dev/null | head -1 | grep -oE '[0-9]+' || echo "0")
if [[ "$part2_tips" -ne "$part2_claimed" ]]; then
    quality_details+=("PART2 header mismatch: claims $part2_claimed techniques, found $part2_tips ### headings")
    ((quality_issues++))
fi

# Verify no numbered headings remain (regression check)
numbered=$( (grep -r -cE '^##+ [0-9]+\.' PART1-CORE-ARCHITECTURE.md PART2-TECHNIQUES.md PART3-BUILD-A-KNOWLEDGE-BASE.md 2>/dev/null || true) | awk -F: '{s+=$NF}END{print s+0}')
if [[ "$numbered" -gt 0 ]]; then
    quality_details+=("Found $numbered numbered tip headings — should be title-only")
    ((quality_issues++))
fi

# Verify every ### tip in PART2 has a "Why it matters" within the tip body
for file in PART2-TECHNIQUES.md; do
    [[ -f "$file" ]] || continue
    while IFS=: read -r lineno heading; do
        next_heading=$(awk "NR>$lineno && /^### /{print NR; exit}" "$file")
        end_line=${next_heading:-$(wc -l < "$file")}
        has_why=$(sed -n "$((lineno+1)),$((end_line))p" "$file" | grep -c '\*\*Why it matters' || true)
        if [[ "$has_why" -eq 0 ]]; then
            quality_details+=("Tip in $file:$lineno missing 'Why it matters' line: $heading")
            ((quality_issues++))
        fi
    done < <(grep -n '^### ' "$file" 2>/dev/null || true)
done

# Check every PART2 tip has **Level:** (PART2 uses Level consistently)
for file in PART2-TECHNIQUES.md; do
    [[ -f "$file" ]] || continue
    while IFS=: read -r lineno heading; do
        next_heading=$(awk "NR>$lineno && /^### /{print NR; exit}" "$file")
        end_line=${next_heading:-$(wc -l < "$file")}
        has_level=$(sed -n "$((lineno+1)),$((end_line))p" "$file" | grep -c '\*\*Level:\*\*' || true)
        if [[ "$has_level" -eq 0 ]]; then
            quality_details+=("Tip in $file:$lineno missing \"Level\" line: $heading")
            ((quality_issues++))
        fi
    done < <(grep -n '^### ' "$file" 2>/dev/null || true)
done

# Check every ### tip in PART3 has **Pattern to copy:**
for file in PART3-BUILD-A-KNOWLEDGE-BASE.md; do
    [[ -f "$file" ]] || continue
    while IFS=: read -r lineno end_line heading; do
        has_pattern=$(sed -n "$((lineno+1)),$((end_line))p" "$file" | grep -c '\*\*Pattern to copy:\*\*' || true)
        if [[ "$has_pattern" -eq 0 ]]; then
            quality_details+=("Tip in $file:$lineno missing \"Pattern to copy\" section: $heading")
            ((quality_issues++))
        fi
    done < <(awk '
        BEGIN { in_code=0; prev_line=0; prev_heading="" }
        /^```/ { in_code=!in_code; next }
        in_code { next }
        /^### / {
            if (prev_line > 0) print prev_line":"NR-1":"prev_heading
            prev_line = NR; prev_heading = $0; next
        }
        END { if (prev_line > 0) print prev_line":"NR":"prev_heading }
    ' "$file" 2>/dev/null || true)
done

# Check every ## tip in PART1 has **Pattern to copy:**
for file in PART1-CORE-ARCHITECTURE.md; do
    [[ -f "$file" ]] || continue
    while IFS=: read -r lineno heading; do
        next_heading=$(awk "NR>$lineno && /^## /{print NR; exit}" "$file")
        end_line=${next_heading:-$(wc -l < "$file")}
        has_pattern=$(sed -n "$((lineno+1)),$((end_line))p" "$file" | grep -c '\*\*Pattern to copy:\*\*' || true)
        if [[ "$has_pattern" -eq 0 ]]; then
            quality_details+=("Tip in $file:$lineno missing \"Pattern to copy\" section: $heading")
            ((quality_issues++))
        fi
    done < <(grep -n '^## ' "$file" 2>/dev/null || true)
done

# TODO/FIXME/TBD/[! markers
while IFS= read -r line; do
    quality_details+=("$line")
    ((quality_issues++))
done < <(scan_grep -rn -E '\b(TODO|FIXME|TBD)\b|\[!' --include='*.md' . 2>/dev/null || true)

# Empty sections (heading immediately followed by same-level or higher heading)
for file in README.md PART*.md; do
    [[ -f "$file" ]] || continue
    while IFS= read -r line; do
        quality_details+=("Empty section in $file: $line")
        ((quality_issues++))
    done < <(awk '
        /^```/ { in_code = !in_code; next }
        in_code { next }
        /^#/ {
            if (prev ~ /^#/) {
                # Allow ## followed by ### (category header followed by first tip)
                prev_level = length(gensub(/[^#].*/, "", "g", prev))
                curr_level = length(gensub(/[^#].*/, "", "g", $0))
                if (curr_level <= prev_level && prev !~ /^## Category/) {
                    print NR-1": "prev
                }
            }
            prev = $0; next
        }
        /^[[:space:]]*$/ { next }
        { prev = "" }
    ' "$file" 2>/dev/null || true)
done

# ═══════════════════════════════════════════
# STRUCTURE CHECKS
# ═══════════════════════════════════════════

# Check all expected files exist
for file in "${EXPECTED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        structure_details+=("Missing expected file: $file")
        ((structure_issues++))
    fi
done

# Check inter-file links resolve (exclude links inside code blocks)
for file in README.md PART*.md SOURCES.md CLAUDE.md; do
    [[ -f "$file" ]] || continue
    while IFS= read -r target; do
        # Strip anchor
        target_file="${target%%#*}"
        [[ -z "$target_file" ]] && continue
        if [[ ! -f "$target_file" ]]; then
            structure_details+=("Broken link in $file: $target_file not found")
            ((structure_issues++))
        fi
    done < <(awk '/^```/{c=!c;next} !c{print}' "$file" 2>/dev/null | grep -oE '\]\([A-Z0-9a-z_-]+\.md[^)]*\)' | sed 's/\](//;s/)//' || true)
done

# Verify nav bars at top and bottom of PART*.md files
for file in PART*.md; do
    [[ -f "$file" ]] || continue
    top_nav=$(head -3 "$file" | grep -c 'Back to README' || true)
    bottom_nav=$(tail -5 "$file" | grep -c 'Back to README' || true)
    if [[ "$top_nav" -eq 0 ]]; then
        structure_details+=("$file missing top nav bar")
        ((structure_issues++))
    fi
    if [[ "$bottom_nav" -eq 0 ]]; then
        structure_details+=("$file missing bottom nav bar")
        ((structure_issues++))
    fi
done

# Check README links to all PART*.md files
for file in PART*.md; do
    [[ -f "$file" ]] || continue
    if ! grep -q "$file" README.md 2>/dev/null; then
        structure_details+=("README.md does not link to $file")
        ((structure_issues++))
    fi
done

# Check that navigation links in each PART file reference valid filenames
for file in PART*.md; do
    [[ -f "$file" ]] || continue
    # Extract filenames from the top nav bar (line 1)
    while IFS= read -r linked_file; do
        if [[ ! -f "$linked_file" ]]; then
            structure_details+=("Nav bar in $file references non-existent file: $linked_file")
            ((structure_issues++))
        fi
    done < <(head -1 "$file" | grep -oE '\]\([A-Z0-9a-z_-]+\.md\)' | sed 's/\](//;s/)//' || true)
    # Extract filenames from the bottom nav bar (last 5 lines)
    while IFS= read -r linked_file; do
        if [[ ! -f "$linked_file" ]]; then
            structure_details+=("Bottom nav in $file references non-existent file: $linked_file")
            ((structure_issues++))
        fi
    done < <(tail -5 "$file" | grep -oE '\]\([A-Z0-9a-z_-]+\.md\)' | sed 's/\](//;s/)//' || true)
done

# ═══════════════════════════════════════════
# OUTPUT
# ═══════════════════════════════════════════

echo ""
echo "PUBLISH CHECKS — claude-code-patterns"
echo "═════════════════════════════════════"

total_issues=$((security_issues + privacy_issues + quality_issues + structure_issues))

# Security
if [[ $security_issues -eq 0 ]]; then
    echo "Security:   PASS (0 issues)"
else
    echo "Security:   FAIL ($security_issues issues)"
    for d in "${security_details[@]}"; do
        echo "  - $d"
    done
fi

# Privacy
if [[ $privacy_issues -eq 0 ]]; then
    echo "Privacy:    PASS (0 issues, $privacy_allowlisted allowlisted)"
else
    echo "Privacy:    FAIL ($privacy_issues issues, $privacy_allowlisted allowlisted)"
    for d in "${privacy_details[@]}"; do
        echo "  - $d"
    done
fi

# Quality
if [[ $quality_issues -eq 0 ]]; then
    echo "Quality:    PASS (0 issues)"
else
    echo "Quality:    FAIL ($quality_issues issues)"
    for d in "${quality_details[@]}"; do
        echo "  - $d"
    done
fi

# Structure
if [[ $structure_issues -eq 0 ]]; then
    echo "Structure:  PASS (0 issues)"
else
    echo "Structure:  FAIL ($structure_issues issues)"
    for d in "${structure_details[@]}"; do
        echo "  - $d"
    done
fi

echo ""
if [[ $total_issues -eq 0 ]]; then
    echo "RESULT: PASS — safe to publish"
    exit 0
else
    echo "RESULT: FAIL — fix $total_issues issues before publishing"
    exit 1
fi
