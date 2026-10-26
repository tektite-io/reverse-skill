---
name: hardware-security
description: Use for authorized hardware and embedded interface security research including UART/JTAG discovery, debug pad triage, secure boot overview, and offline firmware extraction support.
---

# Hardware / Embedded Interface Security

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Confirm **physical-access authorization** and device ownership
2. `NOW`: ESD/power safety; probe read-only by default
3. `NEXT`: Coordinate with firmware-pentest for image analysis
4. `ACT`: Enclosure and debug interface identification → console access → extraction

## Applicable Scenarios

- UART / JTAG / SWD debug port discovery
- Boot logs, root shell, boot interruption
- Flash extraction in coordination with device teardown
- Feasibility assessment of secure boot/encrypted Flash (non-destructive first)

## Workflow

```text
□ Disassemble the authorized device; photograph and label test points
□ Use a multimeter to find GND/VCC/TX/RX; logic levels 1.8/3.3/5V
□ USB-TTL read-only log capture; record the baud rate
□ JTAG: enumerate IDCODE; assess whether it is locked
□ Extract the image → hand off to firmware-pentest / ghidra
```

## Toolchain

| Tool | Purpose |
|------|------|
| USB-TTL / logic analyzer | UART |
| J-Link / CMSIS-DAP | Debugging |
| Bus Pirate / Flipper (lab) | Multi-protocol |
| binwalk / flashrom | Extraction |

## References

- `references/debug-interface-triage.md`
- `../firmware-pentest/` `../ot-ics/`

## Routing Context

**Upstream**: MASTER R34  
**MUST NOT**: Disassemble or damage others' devices without authorization

## Task Completion Self-Check

- [ ] Did I record interface voltage levels and a pinout diagram?
- [ ] Is the image preserved with a hash?
- [ ] Checklist?
