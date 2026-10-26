# Go Binary Reverse Engineering Guide

> Go-compiled binaries pose unique challenges: static linking makes them huge, function counts run into the tens of thousands, the string format is unusual, and symbol recovery after stripping is difficult.
> This document covers the toolchain, recovery techniques, and practical workflows.

---

## Identifying Go Binaries

Quickly determine whether a binary was compiled by Go:

```bash
# String characteristics
strings binary | grep -E "runtime\.|go\.buildid|GOROOT"

# rabin2 reconnaissance
rabin2 -z binary | grep -i "runtime"

# Abnormally large file size (statically linked runtime)
# Typical Hello World: C ~20KB, Go ~2MB
```

Common characteristics:
- A large number of functions with the `runtime.` prefix
- Contains a `go.buildid` section
- Contains `GOROOT`, `GOPATH` path strings
- Function count 5000-50000+ (includes the entire runtime and standard library)

---

## Core Toolchain

### Symbol Recovery

| Tool | Purpose | Link |
|------|------|------|
| **GoReSym** | By Mandiant; parses Go symbol information (pclntab/moduledata) | https://github.com/mandiant/GoReSym |
| **GoResolver** | By Volexity; automatically deobfuscates Garble binaries using CFG similarity | https://github.com/volexity/GoResolver |
| **redress** | Analyzes stripped Go binaries; recovers types/interfaces/package structure | https://github.com/goretk/redress |
| **GoStringUngarbler** | By Google; specifically recovers strings obfuscated by Garble | https://github.com/mandiant/GoStringUngarbler |

### IDA Plugins

| Tool | Purpose | Link |
|------|------|------|
| **go_parser** | IDA plugin; parses moduledata/pclntab/type information | https://github.com/0xjiayu/go_parser |
| **IDAGolangHelper** | IDA script collection; parses Go type information | https://github.com/sibears/IDAGolangHelper |
| **AlphaGolang** | SentinelLabs' IDAPython script collection | https://github.com/SentineLabs/AlphaGolang |
| **IDA 9.2+ native support** | Hex-Rays' official Go decompilation improvements | https://hex-rays.com/blog/stop-guessing-and-start-going |

### Ghidra Plugins

| Tool | Purpose | Link |
|------|------|------|
| **Ghidra + GoReSym output** | Export symbols with GoReSym, then import into Ghidra | Used together |
| **golang_loader_assist** | Ghidra Go loading assistant | Community script |

### Standalone Analysis Tools

| Tool | Purpose | Link |
|------|------|------|
| **gore** | Go reverse engineering library (the foundation of redress) | https://github.com/goretk/gore |
| **garble** | Go obfuscation tool (know it to defeat it) | https://github.com/burrowers/garble |

---

## Key Go Binary Structures

### pclntab (PC Line Table)

The most important structure in a Go binary; it contains:
- All function names and address mappings
- Source file paths
- Line number information
- Stack frame sizes

Even after symbols are stripped, pclntab usually remains (the Go runtime depends on it).

```text
Locating it:
1. Search for magic bytes: 0xFFFFFFF0 (Go 1.16+) or 0xFFFFFFFB (Go 1.18+)
2. Locate automatically with GoReSym
3. Parse automatically with the go_parser IDA plugin
```

### moduledata

Contains:
- pclntab pointer
- Type information table
- itab (interface table)
- Global variable information

### String Format

Go strings are not C-style null-terminated; they are `(pointer, length)` structures:

```text
C string:   "hello\0"
Go string:  struct { ptr *byte; len int } → ptr points to "hello" (no \0)
```

This causes IDA/Ghidra's default string detection to miss large numbers of Go strings.

**Solutions**:
- Use `go_parser` to automatically identify Go strings
- Export a string list with GoReSym
- Manually: find `runtime.stringtable` or locate via cross-references

---

## Practical Workflows

### Scenario 1: Unstripped Go binary

```text
1. GoReSym -t -d -p binary > symbols.json
   → Export all function names, types, source file paths
2. Load into IDA/Ghidra
3. Import GoReSym's symbol information
4. Filter out runtime.* and standard library functions; focus on user code
5. Begin analysis from main.main
```

### Scenario 2: Stripped Go binary

```text
1. GoReSym -t -d -p binary > symbols.json
   → Even after stripping, pclntab usually remains
2. If GoReSym fails → use redress
   redress -src binary    # Recover source file paths
   redress -pkg binary    # Recover package structure
   redress -type binary   # Recover type information
3. Load into IDA + go_parser plugin
4. Run go_parser to recover automatically
5. Start from the recovered main.main
```

### Scenario 3: Garble-obfuscated Go binary

```text
Garble will:
- Randomize function names (main.main → main.a3f2b1c)
- Encrypt strings
- Remove file path information
- Obfuscate package names

Countermeasures:
1. GoResolver (CFG signature matching)
   → Recover standard library function names via control-flow-graph similarity
2. GoStringUngarbler (string decryption)
   → Automatically identify Garble's string encryption scheme and decrypt it
3. Dynamic analysis (Frida/dlv)
   → Hook runtime functions to observe actual behavior
4. Comparative analysis
   → Compile a Hello World with the same Go version and binary-diff the runtime portion
```

### Scenario 4: CGo mixed compilation

```text
1. Identify the CGo boundary (_cgo_* functions)
2. Recover the Go portion with go_parser
3. Analyze the C portion with conventional IDA
4. Pay attention to bridge functions such as _cgo_topofstack, crosscall2
```

---

## Common Command Quick Reference

```bash
# GoReSym: export symbols
GoReSym -t -d -p binary > symbols.json
GoReSym -t -d -p binary -o ida_script.py  # Generate an IDA script

# redress: analyze stripped binaries
redress -src binary          # Source file paths
redress -pkg binary          # Package structure
redress -type binary         # Type information
redress -interface binary    # Interface information
redress -filepath binary     # Full file paths

# GoResolver: deobfuscate Garble
GoResolver -binary binary -output resolved.json

# GoStringUngarbler: decrypt Garble strings
GoStringUngarbler -i binary -o deobfuscated_binary

# Quickly determine the Go version
strings binary | grep "go1\."
GoReSym -p binary | grep "Version"
```

---

## Go Analysis Workflow in IDA

```text
1. Load the binary (choose the correct architecture)
2. Wait for automatic analysis to finish
3. Run the go_parser plugin:
   - File → Script File → go_parser.py
   - Or Edit → Plugins → Go Parser
4. The plugin will automatically:
   - Parse pclntab
   - Recover function names
   - Mark Go strings
   - Parse type information
5. Filter the view:
   - Hide runtime.* functions
   - Focus on main.* and third-party packages
6. Begin reversing from main.main
```

---

## Common Pitfalls

| Pitfall | Description | Solution |
|------|------|------|
| Too many functions to review | Go static linking results in 5000-50000 functions | Filter by package name; look only at main.* and business packages |
| Incomplete string detection | Go strings are not null-terminated | Recover with go_parser or GoReSym |
| Decompiled output hard to read | Go's defer/goroutine/interface make pseudocode complex | IDA 9.2+ has improvements, or use dynamic analysis to assist |
| Garble obfuscation | Function names/strings fully randomized | GoResolver + GoStringUngarbler |
| Version differences | The pclntab format differs across Go versions | GoReSym supports Go 1.2-1.23+ |
| CGo boundary | Go and C code are mixed | Identify _cgo_* functions as the dividing line |

---

## Coordination with Other Skills

| Need | Use |
|------|--------|
| Deep IDA analysis of Go binaries | `ida-reverse/` + go_parser plugin |
| Ghidra analysis (free) | Ghidra + GoReSym symbol import |
| Quick reconnaissance | `radare2/` — `rabin2 -z` to view strings |
| Dynamic hooking | Frida (hook runtime functions) or dlv (Go's native debugger) |
| Cross-version comparison | `binary-diff/` — migrate symbols from the old version to the new one |
| Garble deobfuscation | GoResolver + GoStringUngarbler |
