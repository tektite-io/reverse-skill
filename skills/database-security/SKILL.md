---
name: database-security
description: Use for authorized database security assessment covering PostgreSQL/MySQL/MSSQL/Mongo/Redis exposure, authz, UDF/command paths, and misconfiguration review.
---

# Database Security Assessment

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read precedent-pentest; **destructive statements are prohibited on production databases** unless explicitly permitted
2. `NOW`: In scope, clearly state the instance, account permissions, and whether writes/deletes are permitted
3. `NEXT`: Client tool paths
4. `ACT`: Exposure surface → authentication → authorization → configuration → exploitation chain verification (safe)

## Applicable Scenarios

- Unauthorized database access/weak passwords/incorrect binding to 0.0.0.0
- Excessive privileges, dangerous features (xp_cmdshell, COPY PROGRAM, UDF)
- Lateral movement: from application account to DBA
- NoSQL injection and Redis file writing, etc. (authorized environments)

## Workflow

```text
□ Network exposure and TLS
□ Account roles and grantees
□ Sensitive table access control
□ Dangerous configurations: file_priv, xp_cmdshell, load_file
□ Whether audit logging is enabled
□ Backup and snapshot permissions
```

## Toolchain

| Tool | Purpose |
|------|------|
| Official CLI | Connection and enumeration |
| sqlmap | Injection verification (authorized) |
| nuclei | Known exposure templates |
| Cloud RDS console auditing | Configuration |

## References

- `references/db-misconfig-checklist.md`
- `../pentest-tools/` `../cloud-k8s/`

## Routing Context

**Upstream**: MASTER R35
**Downstream**: Got OS commands → attack-chain; cloud-managed → cloud-k8s

## Task Completion Self-Check

- [ ] Were unauthorized writes/deletes avoided?
- [ ] Were configuration issues distinguished from exploitable chains?
- [ ] Checklist?
