---
name: code-audit
description: Use for authorized source-code security review and SAST workflows including Semgrep, CodeQL patterns, dangerous API hunting, and fix verification.
---

# Source Code Security Audit

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-pentest.md` or code audit authorization
2. `NOW`: Confirm there is **source code/repository access** (binaries without source → switch to RE skill)
3. `NOW`: Clarify the language stack and scope (directory/service/PR diff)
4. `NEXT`: tool-index; semgrep, etc.
5. `ACT`: Threat modeling sketch → automated scanning → manual verification

## Applicable Scenarios

- White-box auditing, PR/differential security review
- Semgrep / CodeQL / Bandit / gosec and other SAST
- Dangerous APIs, injection points, missing authorization, crypto misuse
- Division of labor with `supply-chain-security/`: This skill focuses on **own code logic**, while supply chain focuses on dependencies and pipelines

## Workflow

### 1. Scope and Threat Model

```text
□ Trust boundaries: user input, files, deserialization, SSRF, authorization middleware
□ High-value assets: authentication, payment, admin panels, key handling
```

### 2. Automated Scanning

```bash
semgrep --config auto .
# Or project ruleset
semgrep --config p/owasp-top-ten .
```

### 3. Manual Verification (MUST)

```text
□ For each SAST hit: reachability? exploitability? false positive?
□ Authorization: IDOR/privilege escalation, missing validation, incorrect multi-tenant isolation
□ Injection: SQL/command/template/LDAP
□ Cryptography: hardcoded keys, ECB, custom crypto
```

### 4. Output

```text
Finding: Location + data flow + PoC + remediation recommendations
Optional ATT&CK / CWE identifiers
```

## Toolchain

| Tool | Language/Scenario |
|------|-----------|
| Semgrep | Multi-language quick rules |
| CodeQL | Deep data flow (GitHub) |
| Bandit | Python |
| gosec / staticcheck | Go |
| SpotBugs / FindSecBugs | Java |

## References

- `references/sast-review-checklist.md`
- `../supply-chain-security/` `../api-security/` `../llm-security/` (Agent code)

## Routing Context

**Upstream**: MASTER R26
**Role**: `ops/role-map.md` cae
**Downstream**: Dependency vulnerabilities → supply-chain; runtime verification → pentest-tools

## Task Completion Self-Check

- [ ] Did I manually verify rather than only pasting scanner output?
- [ ] Does it include remediation recommendations?
- [ ] Was it limited to authorized repositories?
- [ ] Checklist?
