# 2026-08-06 Cortex-M Virtual-Disk Upgrade Firmware's Self-Keyed Rotate/XOR Wrapper

## Scenario Classification

Binary / firmware reverse engineering

## Goal Overview

Analyze a Cortex-M debug-tool upgrade package, identify its custom wrapper algorithm, and distinguish the application image inside the upgrade package from the USB Mass Storage bootloader resident on the device.

## Scope Summary (Anonymized)

- auth_basis: own_system
- network_profile: authorized_target_only (actually a local offline sample)
- asset_types: [firmware_container, cortex_m_application, usb_msc_updater]

## Roles

- lead_role: lead
- specialists: [cre, cce, doc]

## Full Execution Chain

1. Run length, entropy, tail-period, and block statistics on the original package; find that the file size is an integer multiple of 1 KiB and the tail has a 7-byte period.
2. Starting from the Cortex-M vector table constraint, enumerate single-byte rotate/XOR relationships and recover the first block first.
3. Find that each 1 KiB block resets the rotation phase, and the first ciphertext byte of a block can serve directly as that block's XOR mask.
4. Decode each block with `P[i] = ROR8(C[i], (3*i) mod 7) XOR C[0]` and reconstruct the original package byte by byte with the inverse transform.
5. Cross-validate with a second official firmware from the same series: the same format recovers a valid vector table, version string, and readable code; all block-first plaintext bytes are zero.
6. Derive the application base address from vector target addresses and file offsets, confirming the upgrade package does not include a leading bootloader.
7. Combining the official "enter bootloader / emulate USB drive" instructions, reconstruct the external flow of copying an MSC file to Flash, and mark the bootloader's internal details as inferred.
8. Test the tail 32-bit field against common CRC, STM32 hardware CRC, Adler, and checksum; none match, so keep it as an unresolved integrity field.

## Evidence Chain Summary (Anonymized)

| E-id | source_type | Reusable command pattern | Related Finding |
|---|---|---|---|
| E-001 | local_binary | block entropy, periodic tail, vector constraint | F-001 |
| E-002 | derived_algorithm | block-first mask + ROR/XOR + round-trip | F-001 |
| E-003 | static_analysis | vectors, strings, Thumb disassembly | F-002 |

## Finding / Path Summary

- top_finding: some high-entropy firmware packages are merely self-keyed ROR/XOR obfuscation reset every 1 KiB, and should not be prematurely classified as standard encryption.
- path_type: solve/callflow
- path_one_liner: period and block structure → vector table crib → first block recovery → block-boundary reset → second-firmware cross-validation → application/bootloader boundary → MSC upgrade external flow.

## Pitfalls

| Problem | Cause | Solution | Time |
|---|---|---|---|
| First used each block's "de-rotated modal byte" as the mask; a few blocks still had garbage | The most common plaintext byte in text-dense blocks is not necessarily zero | Compare the block-first-byte model; garbage disappears and reproduces on the second firmware | Medium |
| A single whole-file XOR/rotate only works at the start | The rotation phase and mask reset every 1 KiB | Explicitly split by `0x400` | Low |
| IDA and radare2 fail to start | No IDA path on this machine; the r2 bootstrap installer is abnormal | Use Python + Capstone to verify the Cortex-M entry | Medium |
| Assumed the tail is a standard CRC32 upon seeing `firmware_crc32` | The string is a metadata key and cannot prove the tail parameters or coverage | Systematically rule out common families, then leave it unknown rather than force a name | Low |

## Toolchain Findings

- Python is well suited to bitwise transform enumeration, round-trip, and cross-sample invariant verification.
- Capstone is sufficient to verify the Cortex-M vector entry and local control flow when IDA/Ghidra/radare2 are unavailable.
- String recovery quality is a strong signal for comparing candidate mask models, but must be combined with absolute pointers and disassembly to avoid judging by "looks readable" alone.

## Key Algorithm

```text
block_size = 0x400
mask = packed_block[0]
rotation(i) = (3 * i) mod 7
plain[i] = ROR8(packed[i], rotation(i)) XOR mask
```

The inverse transform uses `ROL8`; the validation criterion is that the encoded result is byte-for-byte identical to the original package.

## Suggestions for This Package

- Add a "does the block boundary reset the period" check to the firmware-pentest container identification phase.
- When a heuristic zero-byte crib fails on a few blocks, test block-first/block-last self-describing masks first.
- For cases where "the upgrade package contains only the application", the report must label bootloader internal behavior and protocol-layer necessary behavior separately.

## Reusable Patterns

1. First check whether the period resets at common Flash/transport block sizes (256, 512, 1024, 2048, 4096).
2. Use the Cortex-M SRAM stack pointer and Thumb Reset Vector as strong cribs.
3. Run three validations on each candidate model: whole-file round-trip, second-sample reproduction, and absolute-address reference consistency.
4. When a tail field matches no common checksum, do not treat variable names or strings as algorithm evidence.

## Evolution Actions

- [x] Added a field-journal record
- [x] Updated the field-journal index
- [ ] Updated the routing matrix
- [ ] Updated the tool-index
- [ ] Updated the bootstrap-manifest
- [ ] Updated sub-skill documentation

## Environment Information

- OS: Windows
- Tool versions: Python 3.12, Capstone 5.0.6
- Target platform/version: Cortex-M3 / F1-compatible MCU, application-area firmware

## Anonymization Check

- [x] No real domains, IPs, credentials, tokens, PII
- [x] No local absolute paths
- [x] No sample file bodies or sample hashes
- [x] Vendor, product, and version information generalized
