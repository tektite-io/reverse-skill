---
name: go-rust-reverse
description: Use for reverse engineering stripped Go and Rust binaries including runtime recognition, pclntab/module data recovery, panic strings, and idiomatic decompilation recovery.
---

# Go / Rust Binary Reverse Engineering

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md`
2. `NOW`: Confirm the sample is a Go/Rust build artifact (`file`/strings/runtime characteristics)
3. `NEXT`: Check whether GoReSym / the relevant plugins are available
4. `ACT`: Runtime identification → symbol/metadata recovery → business logic

## Applicable Scenarios

- Stripped Go malware/tools
- Rust release binaries and panic-string-driven analysis
- Language-specific methods that complement generic IDA/Ghidra work

## Workflow

### Go

```text
□ Identify go.buildid, residual runtime symbols, and pclntab
□ Recover function names with GoReSym / redress / the IDA Go plugin
□ Note how interfaces, slices, and strings appear in decompiled output
□ Network/crypto library paths: crypto/* net/http
```

### Rust

```text
□ Panic strings, rust_begin_unwind, and hints from crate paths
□ Code bloat from generic monomorphization; locate string xrefs first
□ Async/tokio state machines require cross-reference analysis
```

### Dynamic

```text
□ Frida still works; watch out for Go stacks and scheduling
□ Prefer log and configuration strings to drive breakpoints
```

## Toolchain

| Tool | Purpose |
|------|------|
| GoReSym | Go metadata |
| IDA/Ghidra + Go/Rust plugins | Decompilation |
| radare2 | Quick string triage |
| strings / rabin2 | Triage |

## References

- `references/go-rust-notes.md`
- `../reverse-engineering/go-reverse.md` `../ida-reverse/` `../ghidra-reverse/`
- seed: `field-journal/seed-002_go-malware-stripped.md`

## Routing Context

**Upstream**: MASTER R33  
**Downstream**: Malware sample flow `malware-analysis`; generic RE `reverse-engineering`

## Task Completion Self-Check

- [ ] Did I recover key function names or an equivalent mapping?
- [ ] Did I annotate the language runtime evidence?
- [ ] Checklist?
