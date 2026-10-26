---
name: ot-ics
description: Use for authorized OT/ICS security assessment covering Purdue model zoning, PLC/SCADA exposure, industrial protocol discovery, and safe passive-first evaluation.
---

# OT / ICS Security

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-pentest.md` — **Misoperations in industrial control environments can cause physical harm**
2. `NOW`: Written authorization must clearly state: site, network segment, whether active scanning/register writing is allowed
3. `NOW`: case-init; default **passive-first**; no PLC write operations before `ready_for_act`
4. `NEXT`: tool-index; most industrial control tools require manual setup and isolated lab networks
5. `ACT`: Asset and zoning identification → exposure surface → read-only verification

## Applicable Scenarios

- Industrial control/SCADA/DCS security assessment (authorized)
- Purdue model zoning and cross-zone channels
- Modbus/DNP3/S7/EtherNet/IP and other protocol exposure
- Engineering workstations, HMI, historians, jump hosts
- IT/OT convergence boundaries (firewall rules, one-way gateways)

## Safety Iron Rules (MUST)

```text
MUST NOT when not explicitly permitted:
- Write coils/registers to PLCs
- High-rate scanning of production OT across the entire network
- Interrupt safety instrumented system (SIS)-related paths
Prioritize: read-only identification, traffic mirroring, offline firmware/configuration analysis
```

## Workflow

### Phase 1 — Zoning and Assets

```text
□ Purdue L0–L5 sketch: field devices → control → supervision → site DMZ → enterprise
□ Asset inventory: PLC/RTU/HMI/engineering workstation/historian/jump host
□ Protocol and port baseline (authorized network segments only)
```

### Phase 2 — Passive and Read-Only

```text
□ SPAN/mirror PCAP → protocol-reverse / Wireshark industrial protocol dissectors
□ Offline audit of configurations and engineering files (TIA/RSLogix exports, etc.)
□ Default credentials and plaintext protocols (Modbus without authentication) recorded as Findings; do not write to disk or change values
```

### Phase 3 — Restricted Active (authorized only)

```text
□ Low-speed identification, maintenance window
□ Read-only function codes preferred
□ Evidence for each step; stop immediately and notify on anomalies
```

### Phase 4 — Firmware/Patch Surface

```text
□ Controller firmware version → CVE mapping (do not blindly flash firmware)
□ Coordinate with firmware-pentest for offline image analysis
```

## Toolchain

| Tool | Purpose | Notes |
|------|------|------|
| Wireshark industrial protocol dissectors | Passive parsing | Mirrored traffic |
| Nmap NSE (restricted) | Identification | Rate and time window |
| Claroty/Nozomi etc. | Asset discovery | Commercial/on-site |
| PLC vendor engineering software | Configuration audit | Offline first |
| binwalk / Ghidra | Firmware | Offline |

## References

- `references/ot-safe-assessment.md`
- `../firmware-pentest/` `../protocol-reverse/` `../network` via pentest-tools

## Routing Context

**Upstream**: MASTER R28  
**Downstream**: Firmware deep dive `firmware-pentest`; protocols `protocol-reverse`; IT lateral movement `windows-ad`/`attack-chain`  
**Peer**: Do not use ordinary Web scanning default parameters against OT

## Task Completion Self-Check

- [ ] Is passive/read-only the default with authorization boundaries recorded?
- [ ] Are write operations to control loops avoided (unless explicitly permitted)?
- [ ] Do Findings include physical/process impact descriptions?
- [ ] Checklist / journal?
