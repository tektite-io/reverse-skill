# Community Evolution: Contributing Experience to the Main Repository

## Mechanism Description

Each time you complete a project and generate a field-journal entry, the AI will ask:

```
✅ Experience has been recorded in field-journal/

📤 Would you like to contribute this experience to the community main repository?
- Data has been anonymized per the template requirements (domains/IPs/tokens/PII have been replaced)
- Only new files under the field-journal/ directory will be submitted
- Your private files such as tool-index, scope, and findings will not be submitted
- After contributing, other users can also reuse your experience

Reply "yes" to submit, or "no" to skip.
```

## Contribution Workflow

```text
1. AI generates the field-journal entry (anonymized)
2. AI asks the user whether to contribute
3. User agrees → AI performs the following steps:
   a. Check whether anonymization is complete (double-confirm no real domains/IPs/tokens)
   b. Check whether it duplicates an existing entry in the main repository (read only _index.md, ~200 tokens)
   c. If not a duplicate → create a PR to the main repository
   d. PR title format: [field-journal] YYYY-MM-DD Scenario Type - Keywords
4. GitHub Actions automatic review:
   - ✓ Only modified field-journal/*.md
   - ✓ No prompt injection characteristics
   - ✓ No unanonymized API keys/tokens
   - ✓ No executable code
   - ✓ File size < 50KB
5. Review passes → auto-merge (no manual action needed from repository maintainers)
6. Review fails → automatically comment with the reason; the PR stays open awaiting fixes
```

### Security Safeguards

| Threat | Protection |
|--------|------------|
| Modifying non-journal files | Actions checks the changed-files whitelist |
| Prompt injection | Regex detection of characteristics such as "ignore previous" / "you are now" |
| Malicious code disguised | Detect `#!/`, `import`, `exec(`, `eval(` etc. |
| Unanonymized tokens | Regex detection of AWS key / npm token / GitHub token patterns |
| Junk data | 50KB per-file limit |
| Large volumes of junk PRs | GitHub's built-in rate limit + optional CODEOWNERS review |

## Technical Implementation

### Method 1: GitHub CLI (recommended)

```bash
# 1. Fork the main repository (if not already forked)
gh repo fork &lt;your-GitHub-username&gt;/&lt;repo-name&gt; --clone=false

# 2. Create a contribution branch locally
git checkout -b contribute/journal-YYYY-MM-DD-keyword

# 3. Add only field-journal files
git add skills/field-journal/YYYY-MM-DD_*.md
git add skills/field-journal/_index.md

# 4. Commit
git commit -m "[field-journal] Scenario Type: Keyword Summary"

# 5. Push to the fork
git push origin contribute/journal-YYYY-MM-DD-keyword

# 6. Create the PR
gh pr create --repo &lt;your-GitHub-username&gt;/&lt;repo-name&gt; \
  --title "[field-journal] YYYY-MM-DD Scenario Type - Keywords" \
  --body "## Contribution Content\n- Scenario: xxx\n- Keywords: xxx\n- Anonymization confirmed: ✓\n\n## Data Security Statement\nThis entry has been anonymized per the template requirements and contains no real target information."
```

### Method 2: Direct push (if the user has write access to the main repository)

```bash
git checkout -b contribute/journal-YYYY-MM-DD-keyword
git add skills/field-journal/YYYY-MM-DD_*.md
git add skills/field-journal/_index.md
git commit -m "[field-journal] Scenario Type: Keyword Summary"
git push origin contribute/journal-YYYY-MM-DD-keyword
gh pr create --repo &lt;your-GitHub-username&gt;/&lt;repo-name&gt; \
  --title "[field-journal] YYYY-MM-DD Scenario Type - Keywords" \
  --body "Anonymization confirmed: ✓"
```

## Deduplication Rules (low token consumption)

Before submitting, the AI **only needs to read the single file `_index.md`** for deduplication; it does not need to read the full content of each journal entry.

### Deduplication Workflow

```text
1. Read the main repository's field-journal/_index.md (usually only a few dozen lines)
2. Extract this entry's: scenario classification + keyword list
3. Search _index.md for existing entries in the same scenario category
4. Keyword matching:
   - ≥ 3 overlapping keywords → treat as duplicate; do not submit
   - 1–2 overlapping keywords → may be a variant; may submit
   - No overlap → entirely new scenario; submit directly
```

### Why This Is Sufficient

- The `_index.md` format is fixed: `- [Date] Short Name — Keywords: k1, k2, k3`
- Each entry is only one line; 100 experiences means only 100 lines.
- The AI only needs to do string matching; it does not need to understand the full content.
- Token consumption: reading _index.md ≈ 200–500 tokens (vs. reading all journals ≈ 10,000+ tokens)

### If _index.md Is Unavailable

If the main repository's _index.md cannot be fetched (network issues, etc.), submit directly and let the main repository maintainers deduplicate manually.

## Files Allowed for Submission

**Whitelist** (only these files may appear in a PR):
- `skills/field-journal/YYYY-MM-DD_*.md` (new experience entries)
- `skills/field-journal/_index.md` (index update)

**Blacklist** (must never appear in a PR):
- `tool-index.*` (contains the user's local paths)
- `pentest-tools/templates/scope.md` (contains target information)
- `pentest-tools/templates/findings.md` (contains vulnerability details)
- `pentest-tools/templates/progress.md` (contains operation records)
- `.claude/` (user configuration)
- `.kiro/` (user configuration)
- Any `.env`, `*.key`, or `*.pem` files

## Secondary Anonymization Check

Before submitting, the AI must scan the files to be submitted and confirm they do not contain:

- [ ] Real domains (not `example.com`/`target.example.com`)
- [ ] Real IPs (not `10.x.x.x`/`192.168.x.x`)
- [ ] Plaintext tokens/cookies/API keys
- [ ] Plaintext phone numbers/emails/usernames
- [ ] Company/product names (if it is an SRC target)

If any item is found unanonymized, stop the submission and prompt the user to fix it.

## Value to Users

- The experience you contribute helps other users avoid the same pitfalls.
- The richer the main repository's field-journal, the smarter every user's AI becomes.
- Your contribution will be retained in _index.md (anonymously; only scenario and keywords).
