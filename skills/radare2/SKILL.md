---
name: radare2
description: |
  Use this skill whenever the user wants to analyze binaries with radare2/r2 from the command line, including reverse engineering, disassembly, function analysis, strings/import inspection, patching, binary diffing, hex inspection, or r2 scripting. Also use it when the user mentions PE/ELF/Mach-O/DEX/WASM files together with CLI analysis, `rabin2`, `rasm2`, `radiff2`, `r2pipe`, or asks for radare2 command help on Windows/Linux/macOS.
---

# radare2

A binary analysis skill oriented toward the `radare2` CLI. The focus is on using the command line directly to complete reconnaissance, analysis, locating, exporting, and lightweight modification without relying on a GUI.

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md` — confirm this skill's operations are authorized routine operations
2. `NOW`: Confirm whether the current task falls within this skill's applicable scope
3. `NEXT`: Read `../tool-index.md`, verify tool availability and actual paths
4. `NEXT`: When tools are missing, call bootstrap; do not guess paths
5. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation state

## Applicable Scope

Prefer this skill when the user has these intentions:

- Wants to use `r2` / `radare2` to analyze `exe`, `dll`, `so`, `elf`, `apk`, `dex`, `wasm`, etc.
- Asks how to use `rabin2`, `rasm2`, `radiff2`, `rahash2`, `rax2`
- Needs command-line disassembly, viewing functions, viewing strings, viewing imports/exports, cross-reference lookup, or patching
- Needs to write `radare2` batch commands, `-c` automation commands, or `r2pipe` scripts

If the user explicitly wants GUI reverse engineering, Hex-Rays-style pseudocode, or an IDA workflow, prefer `ida-reverse`. If it is web JS reverse engineering, prefer `reverse-engineering`.

## First Confirm the Environment

Do not assume `r2` is available. Check first:

```powershell
r2 -v
rabin2 -v
```

If not installed, check common installation locations or prompt for installation.

Common Windows executables:

- `radare2.exe`
- `rabin2.exe`
- `rasm2.exe`
- `radiff2.exe`
- `rahash2.exe`
- `rax2.exe`
- `r2pm.exe`

## Built-in Resources

This skill ships with two resources; reuse them first rather than assembling a duplicate set of commands each time.

### `scripts/recon.ps1`

Standard reconnaissance script, suitable for a first-round overview. It outputs:

- Basic information
- Sections
- Imports
- Exports
- Strings
- Optional `r2 -A` automatic analysis summary

Invocation:

```powershell
powershell -File "<skill-root>\radare2\scripts\recon.ps1" -TargetPath "C:\path\to\sample.exe"
```

If you need to include `r2` automatic analysis:

```powershell
powershell -File "<skill-root>\radare2\scripts\recon.ps1" -TargetPath "C:\path\to\sample.exe" -RunAnalysis
```

### `references/cheatsheet.md`

When you need more command details, common scenario templates, or a quick syntax refresher, read this cheatsheet instead of guessing from memory.

## Known Phenomena

### Occasional `.sdb` Missing Warning on Windows

Some PE files may produce a warning like the following during `rabin2` reconnaissance:

```text
ERROR: Cannot find ...\share\format\dll\*.sdb
```

If the main output still returns normally, this usually does not affect basic reconnaissance conclusions; continue analyzing. Do not directly conclude that analysis failed because of this incidental warning.

## Basic Principles

### 1. Reconnaissance First, Deep Dive Later

Do not start with full automatic analysis. First use lightweight commands to confirm file type, architecture, entry point, strings, and import table, then decide whether to run `aaa`, `aaaa`, or targeted analysis.

### 2. Prefer the Minimal Sufficient Command

`radare2` has many commands; users usually only need the shortest path:

- View file information: `rabin2 -I`
- View strings: `rabin2 -z`
- View imports/exports: `rabin2 -i` / `rabin2 -E`
- Interactive analysis: `r2 <file>` then execute local commands

### 3. Be Cautious Before Modification

If the user wants to patch a binary:

- Open read-only by default: `r2 <file>`
- Use write mode only when modification is explicitly needed: `r2 -w <file>` or `oo+` in the session
- Explain the risk before modifying to avoid accidentally overwriting the original file

## Common Workflows

## Workflow 1: Quick Reconnaissance

Suitable when you have just received a binary file.

### Hard Gate (MUST — prohibited from entering Workflow 2 and beyond if not satisfied)

For PE/ELF/Mach-O and other binaries containing an import table, **MUST** complete the import table check and record it as Evidence before entering function-level analysis or dynamic steps:

1. Execute `rabin2 -i <sample>` (or the imports section in `recon.ps1` output); for DLL/SYS also MUST `rabin2 -E` and record `E-exports`
2. Write the complete/classified import table result to Evidence (suggested id: `E-imports` or `E-triage-imports`), containing at least:
   - Reproduction command (`repro_command`)
   - Key import classification summary: network / file / crypto / process injection / registry / other suspicious APIs
   - If the import table is empty, parsing fails, or the tool errors: still MUST record the failure symptom and raw output as Evidence; **do not silently skip**
   - Import table "too clean" (only basic DLLs): MUST note suspected dynamic loading; SHOULD switch to dynamic API capture
3. .NET and other formats without a traditional IAT: MUST use equivalent anchors (dnSpy/IL/metadata summary) written into the same Evidence semantic slot; do not leave it empty
4. IAT repair for packed samples: x86 uses ImportREC (or equivalent), x64 uses Scylla (or equivalent). If repair fails, MUST record `E-iat-repair-fail` then switch to dynamic API breakpoints; **do not** endlessly struggle with static IAT (see `reverse-engineering/references/re-agent-workflow.md` §1.2)
5. When the user explicitly requests "redo import table check / recheck import table / redo IAT": MUST redo the named step itself (when blocked, first use the feasibility gate: explain prerequisites + ask for confirmation; if forced, mark quality=unreadable); **do not substitute an unrelated step and pretend it is complete**

Before import table Evidence (or a legitimate equivalent anchor / IAT failure bypass) is recorded: MUST NOT claim "basic reconnaissance complete," and MUST NOT enter deep-dive conclusions in Workflow 2+.

Prefer running the built-in script directly:

```powershell
powershell -File "<skill-root>\radare2\scripts\recon.ps1" -TargetPath "sample.exe"
```

If you only need the minimal manual commands, use:

```powershell
rabin2 -I sample.exe
rabin2 -z sample.exe
rabin2 -i sample.exe
rabin2 -E sample.exe
```

Focus points:

- File format, bitness, architecture, platform
- Entry point address
- Suspicious strings: URLs, paths, error messages, registry, command-line arguments
- Imported functions: network, file, crypto, process injection, registry operations (**MUST record Evidence, see the hard gate above**)

## Workflow 2: Interactive Function Analysis

```powershell
r2 sample.exe
```

Common commands after entering:

```text
aaa          # Standard automatic analysis
afl          # List functions
iz           # List strings
iS           # List sections
is           # List symbols
s entry0     # Jump to entry point
pdf          # Disassemble the current function
VV           # Enter visual mode (if the terminal supports it)
q            # Quit
```

Notes:

- Prefer `aaa` by default; do not start with the heavier `aaaa`
- If the sample is large or analysis is slow, analyze only near the entry point first, then expand manually

## Workflow 3: Locate main / Key Logic

```text
afl~main
afl~sym.
iz~http
iz~error
axt <addr>
```

Approach:

- Start from `main`, the entry point, and string references
- Use `axt` to find who references a string or address
- After finding the reference point, use `s <addr>` and `pdf`

## Workflow 4: Hex and Memory Viewing

```text
px 64        # 64 bytes of hex from the current address
pd 20        # Disassemble 20 instructions
psz          # Read the string at the current address
pxa          # Friendlier hex view
```

## Workflow 5: Binary Patching

Use only when the user explicitly requests file modification:

```powershell
r2 -w sample.exe
```

After entering, for example:

```text
s 0x401000
wa nop
wa jmp 0x401050
wq
```

Common write operations:

- `wa <asm>`: write assembly
- `wx <hex>`: write raw bytes
- `wq`: write and quit

Back up the original file before modifying. If the user did not mention a backup, remind them at least once.

## Workflow 6: Non-Interactive Automation

Suitable for one-shot output:

```powershell
r2 -A -q -c "afl;iz;ii;q" sample.exe
```

Common parameters:

- `-A`: automatic analysis at startup
- `-q`: quiet mode
- `-c`: execute a command string

If there are many commands, organize them into a readable order rather than cramming them into an unmaintainable ultra-long string.

It is more recommended to start with the built-in reconnaissance script, then decide whether to add custom commands.

## Common Sub-Tools

### `rabin2`

Suitable for static information extraction:

```powershell
rabin2 -I sample.exe   # Basic information
rabin2 -S sample.exe   # Sections
rabin2 -s sample.exe   # Symbols
rabin2 -i sample.exe   # Imports
rabin2 -E sample.exe   # Exports
rabin2 -z sample.exe   # Strings
rabin2 -zz sample.exe  # More detailed strings
```

### `rasm2`

Suitable for quick assembly/disassembly:

```powershell
rasm2 -d "9090"
rasm2 -a x86 -b 64 "xor eax, eax"
```

### `radiff2`

Suitable for comparing two binaries:

```powershell
radiff2 old.exe new.exe
radiff2 -C old.exe new.exe
```

### `rahash2`

Suitable for computing hashes:

```powershell
rahash2 -a md5 sample.exe
rahash2 -a sha256 sample.exe
```

### `rax2`

Suitable for base and encoding conversion:

```powershell
rax2 0x401000
rax2 4198400
rax2 -s hello
```

## Recommended Analysis Order

When encountering an unknown sample, follow this order:

1. `rabin2 -I` to view format, architecture, entry point
2. `rabin2 -z` to view strings
3. `rabin2 -i` to view imported functions — **MUST + Evidence (hard gate, see Workflow 1)**
4. If interactive analysis is needed, then enter `r2` (only after the Evidence from step 3 is on disk)
5. First `aaa`, then `afl` / `iz` / `pdf`
6. Gradually locate key functions through string references, import calls, and the entry flow

The advantage of this order is low noise and quickly building a sense of direction. Step 3 is not an optional optimization; it is the hard gate before deep diving.

## Windows Notes

- When paths contain spaces, commands must be quoted correctly
- If the current terminal cannot find `r2`, `PATH` may have just been updated; open a new terminal and try again
- Some samples require administrator privileges to read, but by default do not proactively elevate privileges unless the user explicitly needs it
- Before dynamically debugging a suspicious sample, confirm the user's intent to avoid misoperation

## Output Style

When the user does not just want commands but wants you to actually analyze the file:

- First give a reconnaissance result summary
- Then list key evidence: strings, imports, functions, addresses
- Finally give next-step recommendations or continue deeper analysis

Do not just list commands without explaining why you are doing so.

## Typical Request Examples

### Example 1: Analyze an exe

User: `Help me see what this exe does; radare2 is fine`

Approach:

1. First use `rabin2 -I/-z/-i`
2. Determine whether to enter `r2`
3. Use `aaa`, `afl`, `pdf` to deep dive into the entry point and key string references

### Example 2: Find where a string is called

User: `In which function is this error string triggered?`

Approach:

1. Use `iz~keyword` to find the string address
2. Use `axt <addr>` to find references
3. Jump to the reference point with `s <addr>` then `pdf`

### Example 3: Change a jump

User: `Change this jne to je`

Approach:

1. First confirm the target address
2. Clearly state that write mode will be entered
3. Use `wa je <target>` or directly `wx`
4. Disassemble again to verify after modification

## Practices to Avoid

- Do not treat `radare2` as a tool with only the `aaa` command
- Do not open user files in write mode without explaining the risk
- Do not draw conclusions before basic reconnaissance
- **Prohibited from skipping the import table check** (`rabin2 -i` / recon imports): do not proceed to the next step without writing Evidence; when the user requests redoing the import table, do not switch to another step
- **Prohibited from static stubbornness after IAT repair failure**: record `E-iat-repair-fail` then switch to dynamic; do not use ImportREC only for 64-bit samples
- Do not misroute web JS reverse engineering to this skill; that is the scope of `reverse-engineering`

## Reference Materials

- Command cheatsheet: `references/cheatsheet.md`
- Standard reconnaissance script: `scripts/recon.ps1`

## radare2-skills Ecosystem

The radare2-skills project (radareorg/radare2-skills) provides a more complete ecosystem of tools and workflows:

- **r2xsql**: SQL queries on binary imports / strings / functions
- **r2mcp / r2http**: MCP tools and HTTP stateful command channels
- **radius2**: Symbolic execution, symbolic dynamic analysis
- **r2pm**: Plugin management, extensions
- **decompiler plugins**: radare2 plugin mechanism

**Usage strategy**:
- When the user mentions `r2xsql`, `r2mcp`, `r2http`, `radius2`, `r2pm`, `rabin2`, `rasm2`, `radiff2`, `rahash2`, `rax2`, prioritize routing to this skill (radare2/SKILL.md)
- These tools are only ecosystem accelerators; they **cannot bypass**: authorization gates, `tool-index` validation, Evidence imports, write mode confirmation
- Give minimal reproducible command examples:
  - `r2xsql -s <file> -q "SELECT ..."`
  - `curl.exe -sS --data-binary 'aaa' http://127.0.0.1:9393/cmd`
  - `radius2 -p <binary> ...`
  - `r2pm -ci <plugin>`

This skill maintains the original hard gates and evidence chain integrity; skipping any authorization or Evidence step is not allowed.

---

## Routing Context

**Upstream entry**: `skills/SKILL.md` (master control), `routing.md`
**Upstream alternatives**: `ida-reverse/` (upgrade to IDA when decompilation/pseudocode is needed)
**Downstream exits**:
- Need dynamic analysis → `reverse-engineering/tools-dynamic.md` (Frida/GDB)
- Need deep decompilation → `ida-reverse/`
- After PAT finds interesting strings and needs cross-references → `ida-reverse/` (IDA's xref is more powerful)

**Peer-related modules**: `ida-reverse/` (complementary: r2 reconnaissance is fast, IDA decompilation is deep)

## On-Demand Bootstrap

This skill's entry script is connected to the unified bootstrap system. When radare2 is missing, it will not directly error but will automatically attempt installation.

### Automation Capability Boundaries

| Tool | Auto-installable | Installation Method | Notes |
|------|-----------|---------|------|
| r2 | ✓ | GitHub Release ZIP (w64) | Automatically download and extract to `%USERPROFILE%\Tools\radare2\` |
| rabin2 | ✓ | Same as above (included in the radare2 distribution) | — |
| rasm2 | ✓ | Same as above | — |
| radiff2 | ✓ | Same as above | — |
| rahash2 | ✓ | Same as above | — |
| rax2 | ✓ | Same as above | — |

### Bootstrap Trigger Points

- `scripts/recon.ps1`: automatically calls `bootstrap-reverse.ps1` when `rabin2` or `r2` is missing

### When Bootstrap Fails

If automatic installation fails (network unavailable, GitHub API rate limiting, etc.), the script throws a clear error with a manual installation link.

Manual installation: Download `radare2-*-w64.zip` from https://github.com/radareorg/radare2/releases, extract to `%USERPROFILE%\Tools\radare2\`, and ensure the `bin\` directory is in PATH.


## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Have I executed each step in the workflow (rather than just reading)?
- [ ] Has the import table check been executed and written to Evidence (E-imports / E-triage-imports or .NET equivalent)? Do DLL/SYS include E-exports?
- [ ] If IAT repair failed, was E-iat-repair-fail recorded and switched to dynamic? Does a redo request return to the same step?
- [ ] Have I used real tool paths based on `tool-index`?
- [ ] Have I produced reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Have I completed and written back the Checklist items required by RULES?
