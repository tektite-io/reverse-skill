---
name: threat-hunting
description: Use for blue-team threat hunting, detection engineering with Sigma/YARA, SIEM query design, and incident detection validation.
---

# Threat Hunting & Detection Engineering

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Confirm blue-team/hunting authorization and data-source scope (SIEM, EDR exports)
2. `NOW`: Define the hypothesis before querying data; avoid mindlessly triaging alerts
3. `NEXT`: Tooling and data-access method
4. `ACT`: Hypothesis → query → validation → rule development

## Applicable Scenarios

- Threat hunting (hypothesis-driven)
- Sigma / YARA detection engineering
- Alert tuning and false-positive analysis
- With `malware-analysis/`: sample-side IOCs → operational detections in this skill
- With `digital-forensics/`: case artifacts → lateral hunting

## Workflow

### 1. Build the hypothesis

```text
Example: an attacker uses living-off-the-land techniques for lateral movement
→ Data sources: Sysmon 1/3/10, Windows Security 4624/4648
→ Success criteria: anomalous parent processes or rare account log sources
```

### 2. Query and stack

```text
□ Baseline: normal administrator behavior by time window and host
□ Anomalies: new services, encoded PowerShell, anomalous outbound traffic
□ Correlation: same account logging into multiple hosts in a short period
```

### 3. Turn into rules

```yaml
# See malware-analysis for the Sigma skeleton; this skill emphasizes:
# - False-positive surface
# - Data-source field mapping
# - Response playbook links
```

### 4. Validate

```text
□ Atomic tests (Atomic Red Team) only in authorized labs
□ Replay historical logs to validate recall
```

## Toolchain

| Tool | Purpose |
|------|------|
| Sigma CLI / sigmac | Rule conversion |
| YARA | Files/memory |
| SIEM (ELK/Splunk, etc.) | Queries |
| osquery | Endpoint hunting |
| Atomic Red Team | Detection validation (lab) |

## References

- `references/hunting-loop.md`
- `../malware-analysis/references/yara-sigma-rules.md`
- `../digital-forensics/`

## Routing Context

**Upstream**: MASTER R27  
**Downstream**: Confirmed intrusion → forensics; malicious sample → malware-analysis  
**MUST NOT**: Run attack simulations in unauthorized production environments

## Task Completion Self-Check

- [ ] Is there an explicit hypothesis and conclusion?
- [ ] Do the rules note false positives and data sources?
- [ ] Checklist reviewed?
