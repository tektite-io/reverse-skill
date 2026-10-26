---
name: radio-sdr
description: Use for authorized RF/SDR security research including signal identification, replay feasibility study in shielded labs, and wireless protocol analysis outside classic Wi-Fi.
---

# RF / SDR Security Research

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: **Spectrum and transmission are strictly regulated by law**; authorized bands/shielded rooms/test targets only
2. `NOW`: Scope must state the device, band, and whether transmission is allowed (default: receive only)
3. `ACT`: Receive-only identification → demodulation analysis → lab reproduction assessment

## Applicable Scenarios

- Non-Wi-Fi RF such as wireless remotes/sensors (authorized)
- Protocol research such as ADS-B/remote control (lawful reception)
- Division of labor with wifi-wireless: this skill focuses on **general SDR RF**; Wi-Fi attack/defense goes to R29

## Workflow

```text
□ Confirm regulations and licensing
□ Receive only: identify center frequency and modulation
□ GNU Radio / URH analysis
□ Replay only in a shielded room with written permission
□ Conclusion focus: whether unauthorized control is possible / hardening recommendations
```

## Toolchain

| Tool | Purpose |
|------|------|
| RTL-SDR / HackRF (compliant) | Transmit/receive hardware |
| URH / GNU Radio | Analysis |
| Inspectrum | Signals |

## References

- `references/sdr-lab-rules.md`
- `../wifi-wireless/` `../ot-ics/` `../hardware-security/`

## Routing Context

**Upstream**: MASTER R38  
**MUST NOT**: Interfere with public communications or transmit without authorization

## Task Completion Self-Check

- [ ] Is receive-only the default with regulatory boundaries recorded?
- [ ] Checklist?
