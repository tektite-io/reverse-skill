---
name: ghidra-reverse
description: Use for free/open reverse engineering with Ghidra (headless or GUI), including decompile, cross-refs, and optional Ghidra MCP workflows when IDA is unavailable.
---

# Ghidra Reverse Engineering

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md`
2. `NOW`: Confirm that **Ghidra** is what you need (no IDA / prefer open source / batch headless)
3. `NEXT`: Read `../tool-index.md` to look up the ghidra / ghidra-mcp paths
4. `NEXT`: Missing tools → bootstrap `ghidra-mcp` (if the manifest supports it) or install Ghidra following the manual steps
5. `ACT`: Import the sample → auto-analyze → export decompilation of key functions

## Applicable Scenarios

- The primary reversing entry point when you have no IDA license
- Batch headless analysis / decompilation in CI
- Ghidra script automation (Java/Python Jython/PyGhidra)
- ghidriff integration with `binary-diff` / `patch-diff-exploit`

## Division of labor with IDA

| Need | Prefer |
|------|------|
| Deep analysis with an existing IDA MCP | `ida-reverse/` |
| Open source / batch / teaching | **this skill** |
| Quick CLI reconnaissance only | `radare2/` |

## Workflow

### 1. Project and auto-analysis

```text
□ New Project → Import file → Analyze (default analyzers)
□ Record the language/compiler identification result and base address
□ Mark the entry point, export table, and string xrefs
```

### 2. Key functions

```text
□ Pivot from strings / imported APIs
□ Recover the algorithm in the Decompile window
□ Rename functions/variables; write Plate comments
□ When dynamics are needed, hand off to Frida/GDB (dynamic chapter of reverse-engineering)
```

### 3. Headless (batch)

```bash
# Example: the analyzeHeadless path varies by installation; MUST take it from tool-index
analyzeHeadless /path/to/project Proj -import sample.bin -postScript ExportDecomp.py
```

### 4. MCP (if configured)

```text
□ Confirm the ghidra MCP port (commonly 8765; tool-index is authoritative)
□ Pull decompilation / xrefs with the MCP tools; never guess the port
```

## Toolchain

| Tool | Purpose | Bootstrap |
|------|------|------|
| Ghidra | Primary decompiler | Manual release / package manager |
| ghidra-mcp | AI bridge | Bootstrap capability name `ghidra-mcp` |
| ghidriff | Patch diffing | See `patch-diff-exploit` |

## References

- `references/ghidra-cheatsheet.md`
- `../ida-reverse/` `../radare2/` `../binary-diff/`

## Routing Context

**Upstream**: MASTER R22  
**Downstream**: Dynamic validation → Frida/GDB; exploitation → `pwn-chain`  
**Peers**: `ida-reverse` (commercial deep analysis)

## Task Completion Self-Check

- [ ] Did I use real Ghidra/tool-index paths?
- [ ] Did I annotate function addresses and renames?
- [ ] Are there reproducible steps?
- [ ] Checklist / journal?
