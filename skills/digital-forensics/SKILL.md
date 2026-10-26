---
name: digital-forensics
description: Use for authorized digital forensics including memory dumps, disk timelines, PCAP investigation, artifact triage, and IR evidence preservation.
---

# Digital Forensics & IR Artifacts

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-pentest.md` or the organization's IR authorization statement
2. `NOW`: Confirm this is **forensics/traceback**, not offensive scanning
3. `NOW`: Create a case; prioritize read-only copies of evidence (write-protect original media)
4. `NEXT`: tool-index; Volatility, etc. are often manual
5. `ACT`: Preserve hashes → timeline → key artifacts

## Applicable Scenarios

- Memory dump analysis (Volatility 2/3)
- Disk/E01/landed file timelines
- PCAP traceback and protocol recovery (can combine with `protocol-reverse/`)
- Host artifacts: Prefetch, Shimcache, Event Log, browser history
- Incident response IOC extraction (combine with `malware-analysis/` / `threat-hunting/`)

## Workflow

### 1. Preservation

```text
□ Compute SHA256; record time zone and collection commands
□ Work on copies; originals are read-only
□ Write chain of custody notes into the timeline
```

### 2. Memory

```bash
vol -f mem.dmp windows.info
vol -f mem.dmp windows.pslist
vol -f mem.dmp windows.netscan
vol -f mem.dmp windows.cmdline
```

### 3. Host Artifacts

```text
□ Event logs: Security / PowerShell / Sysmon
□ Persistence: Run keys, services, scheduled tasks, WMI
□ Execution traces: Amcache, Prefetch, BAM
```

### 4. Network

```text
□ tshark session and DNS statistics
□ Export suspicious streams → protocol-reverse or malware C2 analysis
```

## Toolchain

| Tool | Purpose |
|------|------|
| Volatility 3 | Memory |
| Timeline Explorer / Plaso | Super timeline |
| tshark | PCAP |
| Eric Zimmerman toolset | Windows artifacts |
| Autopsy / FTK Imager | Disk |

## References

- `references/forensics-triage.md`
- `../malware-analysis/` `../threat-hunting/` `../protocol-reverse/`

## Routing Context

**Upstream**: MASTER R25
**Downstream**: Deep-dive malicious samples → malware-analysis; rules → threat-hunting

## Task Completion Self-Check

- [ ] Were hash preservation and copy strategy implemented?
- [ ] Is the timeline reviewable?
- [ ] Are IOCs sanitized and classified?
- [ ] Checklist?
