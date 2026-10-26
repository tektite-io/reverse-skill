---
name: email-security
description: Use for authorized email security review including phishing analysis, header authentication (SPF/DKIM/DMARC), BEC patterns, and mailbox token abuse research.
---

# Email Security & Phishing Analysis

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Confirm authorization (analyzing sample emails / reviewing tenant configuration)
2. `NOW`: Do not re-deliver malicious samples to real users
3. `ACT`: Header authentication → content/URL → attachment sandbox → tenant control-plane recommendations

## Applicable Scenarios

- Phishing email triage and IOC extraction
- SPF/DKIM/DMARC configuration assessment
- BEC (business email compromise) patterns
- OAuth app phishing / mailbox token abuse (combined with llm/cloud identity)
- Security awareness exercise design (authorized)

## Workflow

```text
□ Full raw headers: Received chain, From/Return-Path consistency
□ SPF/DKIM/DMARC alignment results
□ URL sandbox and attachment static analysis (combined with malware-analysis)
□ Brand impersonation and reply-to address discrepancies
□ Tenant: anti-phishing policies, external tagging, MFA, OAuth app consent
```

## Toolchain

| Tool | Purpose |
|------|------|
| Email client "View source" | Headers |
| dig/nslookup | SPF/DMARC records |
| urlscan / sandbox | Links and attachments |
| Tenant admin center | Policies |

## References

- `references/email-auth-checklist.md`
- `../malware-analysis/` `../attack-chain/` (phishing stage) `../windows-ad/` (tokens)

## Routing Context

**Upstream**: MASTER R36  
**MUST NOT**: Send bulk test phishing to third-party domains without authorization

## Task Completion Self-Check

- [ ] Are the header authentication conclusions complete?
- [ ] Are the IOCs detectable (combined with threat-hunting)?
- [ ] Checklist?
