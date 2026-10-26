# 2026-07-20 Full Windows Reverse Engineering Toolchain Bootstrap

## Scenario Classification

Other / toolchain and environment

## Goal Overview

Install and verify a reverse engineering toolchain on a Windows 24H2 host, covering native, managed, Android, firmware, protocol, forensics, browser, and MCP tooling.

## Full Execution Chain

1. Read the shared tool-index and reuse already-installed tools first.
2. Run the generic PATH probe and fill gaps with static, dynamic, firmware, and protocol tools.
3. For large files, extract URLs and SHA-256 from a trusted manifest and download directly with IPv6-disabled aria2.
4. Set up a unified entry point at `{user_profile}\Tools\reverse-bin` for portable tools.
5. Build and register Ghidra, IDA, JS, browser traffic, and Burp MCP.
6. Verify tools with real PE/APK/.NET/PYC/WASM/firmware fixtures, not just version commands.
7. Refresh the shared tool-index and output a formal installation report and flow diagram.

## Pitfalls

| Problem | Cause | Solution | Time |
|---|---|---|---|
| winget large-file download makes no progress for a long time | Delivery Optimization and the default IPv6 path are unstable | Take the official URL/hash from winget metadata and use `aria2c --disable-ipv6=true` | High |
| anything-analyzer SQLite ABI mismatch | A plain `pnpm rebuild better-sqlite3` builds for the Node ABI, but Electron needs the Electron ABI | Use the project's `pnpm run postinstall` | Medium |
| WSL service 1053, system feature does not exist | The Windows image stripped the WSL, VirtualMachinePlatform, and Hyper-V feature packages | Keep the real Linux command gaps and switch to Windows-native tools and QEMU full-system | Medium |
| Dr. Memory version is fine but injection crashes | Windows 11 24H2 build 26100 compatibility issue | Record the upstream issue and use AppVerifier/PageHeap/UMDH/CDB/Frida | Medium |
| Codex TOML fails to load | Garbled historical project paths caused missing quotes, invalid escapes, and duplicate keys | Fix only the table-header syntax and validate with `codex mcp list` | Low |
| Burp MCP has no tools after registration | The Burp GUI has not loaded the extension yet and 9876 is not listening | Build a fixed JAR and document the GUI loading conditions | Low |

## Toolchain Findings

- The generic probe ended at 57/64; all 7 gaps are Linux user-space or kernel capabilities.
- Windows SDK Debugging Tools are an important supplement when Dr. Memory is incompatible: CDB, GFlags, UMDH, NTSD, KD.
- MCP should be verified separately for "stdio/HTTP initialization" and "GUI backend online"; successful registration does not mean the tool is callable.
- IDA Free works for local interactive analysis but cannot replace the idalib/Hex-Rays MCP backend of a legitimate IDA Pro.

## Key Code/Commands

```powershell
python "{skill_root}\scripts\toolchain_probe.py" --format markdown
aria2c --disable-ipv6=true --max-connection-per-server=16 --split=16 "{official_url}"
powershell -NoProfile -ExecutionPolicy Bypass -File "{package_root}\skills\scripts\refresh-tool-index.ps1"
codex mcp list
cdb -g -G C:\Windows\System32\where.exe cmd
```

## Suggestions for This Package

- Add Dr. Memory, CDB, GFlags, UMDH, DTC, SquashFS, flashrom, and Frida Trace to the Windows tool-index catalog.
- Capability status should distinguish `installed`, `bridge-ready`, `backend-online`, and `runtime-verified`.
- Add explicit Linux-only gap notes for trimmed Windows images instead of generating same-named fake wrappers.

## Reusable Patterns/Script Fragments

Fixed pattern for large-file downloads: first verify the version, URL, and SHA-256 against the official package metadata, then download with IPv6 disabled via aria2; after download, verify both the hash and Authenticode (if applicable).

## Evolution Actions

- [ ] Updated the routing matrix
- [x] Updated the tool-index
- [ ] Updated the bootstrap-manifest
- [ ] Updated sub-skill documentation
- [x] Added a pitfalls record
- [ ] No update needed

## Environment Information

- OS: Windows NT build 26100.4946, 24H2, x64
- Tool versions: see the local formal installation report and tool-index
- Target platform/version: Windows-native toolchain, also covering Android, Linux/ELF static analysis, and full-system emulation

## Anonymization Requirements

This record contains no real targets, credentials, tokens, internal URLs, or usernames; all paths use placeholders.

## Index Sync

Updated the statistics and "toolchain and environment" category in `_index.md`.

---
<!-- [Community contribution] Local record complete. -->
