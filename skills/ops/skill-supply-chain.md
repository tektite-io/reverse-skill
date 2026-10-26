# Agent Skill Supply Chain Security (This Package's Feature)

> Sources combined: OWASP Agentic Skills Top 10 (AST10), Anthropic Agent Skills security recommendations, public poisoning incidents (e.g. ClawHavoc, see AST10 timeline)  
> Retrieval date: 2026-07-17  
> Applicable: when installing/writing/merging **any** skill, MCP, or bootstrap script

This package's **executable script surface** static audit (backdoors / database deletion / pipe execution): [`docs/PACKAGE-SECURITY-AUDIT.md`](../../docs/PACKAGE-SECURITY-AUDIT.md).

## 1. Why reverse-skill Must Manage This Separately

This package will:

- Instruct AI to **execute commands and bootstrap downloads**
- Contact local and network via MCP  
- Write to field-journal / reports  

Malicious skills can cause: credential theft, persistent prompts, supply chain backdoors.  
We use **documentation latches + tool truth sources**, not another skill app store.

## 2. Threat Comparison (Condensed AST10 Thinking)

| Risk Category | Manifestation | This Package's Control |
|--------|------|----------|
| Malicious/poisoned skill | Induces exfil, writes memory/backdoors | Trust only this repository + externally sourced with written user authorization; manually read SKILL.md and scripts for external sources first |
| Excessive permissions | Indiscriminate `curl \| bash`, full-disk reads | Bootstrap only manifest capabilities; scope `network_profile` |
| Dependency poisoning | Malicious pip/npm packages | Prefer official releases; record versions in tool-index |
| Blind trust in MCP | Unaudited MCP servers | tool-index registration status + port probing; do not trust remote MCP by default |
| MCP/CLI auto-execution poisoning | Repo `.env` changes to `CODEX_HOME` etc. causing malicious MCP execution at startup (HackTricks / CVE-style cases) | Do not trust default MCP configs in repositories; check env and MCP lists before starting Agent |
| Prompt injection into skill | Hidden instructions in SKILL body | Review diffs; prohibit "execution instructions hidden in HTML comments" without user knowledge |
| Scope drift | Skill induces expanded scanning / "fully automate one domain end-to-end" | ops/scope-contract: out_of_scope + auth; prohibit wild scanning without in_scope |
| Skill stacking overload | Mounting too many skills at once causes missed findings (public evaluation observation) | Load only PRIMARY + necessary secondary (MASTER-ROUTING) |

## 3. MUST Checklist for Installing External Skills

```text
□ Source: official org / audited list (e.g. ToB curated) / user-owned
□ Read all SKILL.md + scripts/* + package dependencies
□ No mysterious outbound connections, no default steps reading ~/.ssh / browser databases
□ When conflicting with this package's routing: this package's MASTER-ROUTING + scope takes precedence
□ Do not copy into monorepo unless following CONTRIBUTING and anonymization
□ Update skills/references/community-security-skills.md to record source date
```

## 4. Boundaries with bootstrap / MCP

| Action | Allowed | Prohibited |
|------|------|------|
| `bootstrap-reverse.ps1 -Capability X` | X ∈ bootstrap-manifest.json | Arbitrary new name without modifying manifest |
| Register MCP | User confirmation + tool-index refresh | Silently write global MCP pointing to unknown URL |
| Run community Python one-click pentest | Authorized lab + after reading source code | Directly against production targets + unknown scripts |

## 5. This Package's Authors/Contributors

- New skill: CONTRIBUTING + ACTION REQUIRED + completion self-check  
- Citing community content: annotate URL + date (this file / community-security-skills.md)  
- Discover suspicious behavior: stop execution, inform the user, do not automatically "try to bypass"

## 6. Quick Self-Check (Before Merging External Material Each Time)

```powershell
# List script extensions to be introduced
Get-ChildItem -Recurse -Include *.ps1,*.sh,*.py,*.js | Select-Object FullName
# Rough search for dangerous patterns (manual review, not exhaustive)
# Execute in external directory: Select-String -Pattern 'Invoke-WebRequest|curl .\||wget .\||~/.ssh|exfil'
```

## 7. Related

- Identity: `IDENTITY.md`  
- External directory: `../references/community-security-skills.md`  
- Authorization: `scope-contract.md` + `field-journal/precedent-auth.md`  
