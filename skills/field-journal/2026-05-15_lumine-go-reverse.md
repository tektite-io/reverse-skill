---
name: lumine-reverse-2026-05-15
description: Full reverse engineering and recovery of the Go 1.24.5 TLS fragmentation proxy lumine v0.9.1, including source reconstruction for 7 packages
metadata:
  type: project
---

# lumine v0.9.1 — Go TLS Fragmentation Proxy Reverse Engineering

**Date**: 2026-05-15
**Target**: `lumine_v0.9.1_windows_amd64.exe` (PE32+, Go 1.24.5, 11.6 MB)
**Original writeup**: `REVERSE_REPORT.md`

## Background

The user asked to recover the binary into readable Go source. The target is a TLS anti-DPI proxy tool whose technique derives from the Python project [TlsFragment](https://github.com/maoist2009/TlsFragment).

## Process

1. **Toolchain setup**: Python + capstone disassembly, GoReSym symbol table recovery (1944 Go functions, 269 from the project)
2. **Package structure identification**: inferred 12 packages from GoReSym's `package.function` naming
3. **Type recovery**: derived JSON deserialization types from `config.json` and recovered fields from function references
4. **Source reconstruction**: wrote readable Go code package by package, preserving logic rather than restoring line by line
5. **Subpackage completion**: dial (outbound binding), errors (error types), format (string utilities)

## Key Findings

- Core anti-DPI mechanism: TLS record fragmentation + noise injection + ACK waiting + OOB + Fake TTL
- Policy engine: domain Trie + IP Trie → Policy matching
- Depends on `go-freelru` (LRU cache) for DNS/TTL caching
- The source repository `github.com/moi-si/lumine` returns 404, so recovery had to rely entirely on the binary

## Tools

| Tool | Purpose | Version |
|---|---|---|
| GoReSym | Go symbol recovery | v1.7.1 (Mandiant) |
| Capstone | Disassembly engine | latest |
| pefile | PE structure parsing | latest |

## Pitfalls

1. **Python3 path issue**: the WindowsApps stub python3 does not support `pip install capstone`; use the full CPython path
2. **GoReSym subprocess path**: `~` is not expanded automatically; use `os.path.expanduser()`
3. **Mixed tabs/spaces**: auto-generated Python decompilation scripts mixed tabs and spaces, producing malformed Go source; v3 used spaces throughout
4. **Vendor-less GoReSym**: when the Go 1.24.5 binary carries no vendor symbols, GoReSym still extracts function names but cannot recover arguments or local variables
5. **String noise**: Go standard library string constants are heavily mixed in and must be filtered carefully at package level

## Artifacts

- `REVERSE_REPORT.md` — full reverse engineering report
- `reconstructed_src_v3/` — 7 Go source files, core engine + 3 subpackages
