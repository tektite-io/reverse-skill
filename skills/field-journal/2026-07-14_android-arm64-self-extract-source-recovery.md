# 2026-07-14 Android ARM64 Self-Extracting Program Source Recovery

## Scenario Classification

Binary analysis / Android ARM64 / self-extracting shell / control-flow flattening

## Goal Overview

Perform read-only source recovery on a user-owned local `.sh` delivery package, peel apart multiple layers of compressed payloads, analyze the ARM64 main program and protection library, and recover business text and high-level pseudo-source without running the target.

## Full Execution Chain

1. Run a read-only inventory, size, magic, and SHA-256 triage on the input directory, without reading or recording credential plaintext.
2. Identify the first layer as a "shell preamble + bzip2 tail stream" and locate the exact offset via a `BZh` valid-stream test.
3. Save the preamble, compressed stream, and decompressed payload in a separate Chinese-artifact directory, without executing the payload.
4. Identify the second layer as a `__ARCHIVE_BELOW__` self-extracting script, safely expand the tar.gz, and reject absolute paths, `..`, links, and device nodes.
5. Obtain the Android AArch64 PIE main program and AArch64 shared library; use pyelftools/Capstone to generate ELF headers, sections, symbols, imports, strings, and entry disassembly.
6. The protection library retains readable C++ symbols; export pseudo-code function by function and confirm `/proc` scanning, `TracerPid`, three-level process termination, and background-thread behavior.
7. The symbol length of the main program's `main` is clearly larger than normal CFG recognition length, confirming indirect-jump control-flow flattening.
8. Statically solve the jump table: `target = table_entry + fixed_delta`, and enumerate all unique real basic blocks.
9. Scan for isomorphic string decryptors and identify the "first N bytes cyclic XOR key + following M bytes ciphertext" layout.
10. Perform AArch64 constant propagation on each real basic block, resolve the target of indirect decryptor calls and the `x1` data source, and batch-recover business text.
11. Deliver full disassembly, per-function pseudo-code, high-level semantic source, Mermaid flow diagrams, and a formal report.
12. Recompute the original input hash and confirm it is identical before and after analysis.

## Pitfalls

| Problem | Cause | Solution | Time |
|---|---|---|---|
| PowerShell blocks the bootstrap directly via execution policy | The system forbids scripts | Use a one-off `powershell.exe -ExecutionPolicy Bypass -File ...`, without changing the permanent policy | Low |
| radare2 bootstrap returns GitHub API 403 | API rate limiting/rejection, but the release page is accessible | Get official assets and page SHA-256 from the `releases/latest` 302 and `expanded_assets/<tag>`, verify, then extract | Medium |
| winget's Rizin silent/user-scope installs both fail to land | Installer scope mismatch | Stop retrying after two failures and switch back to the verified official radare2 ZIP | Low |
| `r2pm -U` hangs on git clone for a long time | Network speed/recursive repository | Abort the optional plugin route and continue with `pdc` + Capstone custom recovery | High |
| radare2 only recognizes the CFG before `main` | Indirect BR jump tables end conventional analysis at the dispatcher | Enumerate real blocks via the jump-table formula instead of relying on the default CFG | Medium |
| Direct string scanning shows only a few paths | Text uses a per-string cyclic XOR | Extract key/output lengths from the decryptor instructions and statically replay the algorithm | Medium |

## Toolchain Findings

- The Python 3.13 standard library is sufficient to safely handle bzip2 and tar.gz; `tarfile.extractall` is less safe than validating each member before writing.
- pyelftools can recover ELF/DYNSYM/RELA, and Capstone is good for ARM64 constant propagation and dedicated decryptor identification.
- radare2 6.1.8's `pdc` works on unobfuscated protection-library functions but only provides partial pseudo-code for the indirect-BR flattened main function.
- A GitHub API 403 does not mean the official release page assets are inaccessible; the release page can provide the tag, asset names, and SHA-256.

## Key Code/Commands

```python
# Generic cyclic XOR text layout
key = blob[:key_length]
encrypted = blob[key_length:key_length + output_length]
plain = bytes(value ^ key[index % key_length]
              for index, value in enumerate(encrypted))
```

```python
# Static indirect jump table solving
targets = {
    (entry + fixed_delta) & 0xFFFFFFFFFFFFFFFF
    for entry in jump_table_entries
}
```

```powershell
# Read-only fetch of the latest tag when the API returns 403
curl.exe -sS -I '<official-release-url>/radareorg/radare2/releases/latest'
```

## Suggestions for This Package

- Add a "`.sh` self-extracting disguised binary" target-type route to avoid misclassifying it as pure shell review.
- The Windows GitHub Release bootstrap should fall back to the release page/expanded_assets on API 403 and enforce SHA-256 verification.
- A generic "ARM64 jump table + cyclic XOR" recovery script template could be added as a low-dependency route when IDA is unavailable.
- When a tool call exceeds the foreground window, keep the session id and poll, to avoid losing still-running download or export tasks.

## Reusable Patterns/Script Fragments

1. Scan for valid compressed streams rather than only looking for magic numbers; test each candidate offset by fully decompressing in memory.
2. Always write self-extracting archives member by member safely; never execute them and never trust member paths.
3. When a symbol table declares a function length far larger than the CFG-recognized length, check for BR/BLR indirect tables first.
4. Isomorphic decryptors can be batch-identified by the instruction combination `add x16,x1,#key_len`, `cmp w16,#output_len`, `ldrb/eor/strb`.
5. Local constant propagation on flattened blocks is usually enough to recover indirect function targets and string source addresses without fully de-flattening first.

## Evolution Actions

- [x] Updated the routing matrix
- [x] Updated the tool-index
- [ ] Updated the bootstrap-manifest
- [ ] Updated sub-skill documentation
- [x] Added a pitfalls record
- [ ] No update needed

## Environment Information

- OS: Windows
- Tool versions: Python 3.13; radare2 6.1.8; pyelftools; Capstone
- Target platform/version: Android ARM64, NDK r17 / Clang 6.0.2

## Anonymization Check

- No software name, author name, real domain, real API endpoint, credential, fixed signature material, business package name, or local user path recorded.
- No sample files or sample hashes attached.
- Only public tool names, versions, and generic algorithm patterns retained.

## Index Sync

Added this record to the "binary / firmware / CTF" category in `_index.md` and updated the statistics.

---
<!-- [Community contribution] After completion, ask the user whether to PR to the main repository. See CONTRIBUTE-BACK.md for the flow. -->
