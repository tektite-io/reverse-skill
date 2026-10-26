---
name: binary-diff
description: |
  Cross-version symbol migration and binary diffing. Use when you have symbols/reverse engineering results from an old version and need to quickly migrate them to a new version.
  Applicable scenarios: deriving new-version symbols from old-version symbols when kernel PDB is missing, batch-migrating function names after a program update, quickly locating new offsets after an application update.
  Core method: Use an LLM for structured difference comparison, with programmatic input/output and extremely low cost (200 functions ~1 yuan).
  Trigger keywords: symbol migration, bindiff, cross-version, missing PDB, function offset migration, symbol migration, binary diff, version comparison.
---

# Cross-Version Symbol Migration (Binary Diff)

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md` — confirm that operations in this skill are authorized routine operations
2. `NOW`: Confirm whether the current task falls within the scope of this skill
3. `NEXT`: Read `../tool-index.md`, verify tool availability and actual paths
4. `NEXT`: Call bootstrap when tools are missing; do not guess paths
5. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation stage

## Scope of Application

Use this skill when the task falls into the following scenarios:

1. **Kernel/driver missing PDB** — You have symbols for an old version of ntoskrnl.exe, the new version's PDB has been delisted by Microsoft, and you need to derive new-version non-exported function addresses from the old-version symbols
2. **Symbol migration after program update** — You previously reverse-engineered a program, the program was updated, and you don't want to reverse it again from scratch; batch-migrate using the old-version results
3. **Protection mechanism update** — You have complete reverse engineering results for the old version and need to quickly locate the new offsets of the same functions in the new version
4. **Any binary comparison scenario with "old-version symbols + new-version symbols missing"**

### Division of Labor with Other Skills

| Scenario | What to use |
|------|--------|
| Reverse engineering a binary from scratch | `ida-reverse/` or `radare2/` |
| Have old-version results, migrate to new version | **This skill** |
| Compare two completely different binaries | BinDiff / Diaphora (traditional tools) |

### Core Advantages

Compared with traditional approaches:

| Approach | Cost for 200 functions | Time | Accuracy |
|------|--------------|------|--------|
| Manually open two IDA windows and compare | Free but soul-crushing | Several hours | High |
| BinDiff automatic matching | Free | Fast | Medium (fails when structural changes are large) |
| Fully delegate to an Agent (CC/Codex) | 50-100 yuan | Slow | High |
| **This skill (LLM batch comparison)** | **~1 yuan** | **~10 seconds/function** | **High** |

## Core Principle

```text
Old-version function (with symbols)          Same function in new version (without symbols)
    ↓                              ↓
Export disassembly + pseudocode          Export disassembly + pseudocode
    ↓                              ↓
    └──────── LLM structured comparison ────────┘
                    ↓
          Output YAML (symbol mapping table)
                    ↓
          Programmatic parsing → batch apply to new-version IDB
```

Key points:
- The prompt is a fixed template, filled programmatically
- Input/output formats are fixed and parsed programmatically
- The LLM is only responsible for the step of "looking at two code snippets and finding the correspondence"
- Time and token costs are extremely low

## Prompt Template

### Standard Comparison Prompt

```text
I have disassembly outputs and procedure code of the same function.

This is the function for reference:

**Disassembly for Reference**
```c
{disasm_for_reference}
```

**Procedure code for Reference**
```c
{procedure_for_reference}
```

This is the function you need to reverse-engineering:

**Disassembly to reverse-engineering**
```c
{disasm_code}
```

**Procedure code to reverse-engineering**
```c
{procedure}
```

What you need to do is to collect all references to "{symbol_name_list}" in the function you need to reverse-engineering and output those references as YAML.

Example:
```yaml
found_vcall: # This is for indirect call to virtual function or virtual function pointer fetching.
  - insn_va: '0x180777700' # Always be the instruction with displacement offset
    insn_disasm: call [rax+68h] # Always be the instruction with displacement offset
    vfunc_offset: '0x68'
    func_name: ILoopMode_OnLoopActivate
  - insn_va: '0x180777778' # Always be the instruction with displacement offset
    insn_disasm: mov rax, [rax+80h] # Always be the instruction with displacement offset
    vfunc_offset: '0x80'
    func_name: INetworkMessages_GetNetworkGroupCount

found_call: # This is for direct call to non-virtual regular function.
  - insn_va: '0x180888800'
    insn_disasm: call sub_180999900
    func_name: CLoopMode_RegisterEventMapInternal
  - insn_va: '0x180888880'
    insn_disasm: call sub_180555500
    func_name: CLoopMode_SetSystemState

found_funcptr: # This is for non-virtual regular function pointer.
  - insn_va: '0x180666600' # Must load/reference the function pointer target address
    insn_disasm: lea rdx, sub_15BC910 # Must load/reference the function pointer target address
    funcptr_name: CLoopMode_OnClientPollNetworking

found_gv: # This is for reference to global variable.
  - insn_va: '0x180444400'
    insn_disasm: mov rcx, cs:qword_180666600 # Must load/reference the global variable
    gv_name: g_pNetworkMessages
  - insn_va: '0x180333300'
    insn_disasm: lea rax, unk_180222200 # Must load/reference the global variable
    gv_name: s_EventManager

found_struct_offset: # This is for reference to struct offset. NOTE THAT virtual function pointer should not be here! virtual function pointer should ALWAYS be in found_vcall !
  - insn_va: '0x1801BA12A' # Always be the instruction with displacement offset
    insn_disasm: mov rcx, [r14+58h] # Always be the instruction with displacement offset
    offset: '0x58'
    size: 8
    struct_name: CResourceService
    member_name: m_pEntitySystem
```

If nothing found, output an empty YAML. DO NOT output anything other than the desired YAML. DO NOT collect unrelated symbols.
```

### Variable Descriptions

| Variable | Source | Description |
|------|------|------|
| `{disasm_for_reference}` | Old-version IDA export | Disassembly with symbols |
| `{procedure_for_reference}` | Old-version IDA export | Pseudocode with symbols |
| `{disasm_code}` | New-version IDA export | Disassembly without symbols |
| `{procedure}` | New-version IDA export | Pseudocode without symbols |
| `{symbol_name_list}` | Extracted from old version | List of symbols to locate in the new version |

## Workflow

### Complete Process

```text
Step 1: Prepare data
  - Load the old-version binary into IDA (with PDB/symbols)
  - Load the new-version binary into IDA (without symbols)
  - Find anchor functions that are identical in both versions (exported functions, string references, etc.)

Step 2: Batch export
  - Export from old version: disassembly + pseudocode of anchor functions (with symbol names)
  - Export from new version: disassembly + pseudocode of the same anchor functions (without symbol names)

Step 3: LLM comparison
  - Fill the prompt template with data
  - Call the LLM API (recommended: deepseek is cheap at scale; switch to gpt for very large functions)
  - Parse the returned YAML

Step 4: Apply results
  - Batch-apply the symbol mappings from the YAML to the new-version IDB
  - Batch-rename using idapro_rename or IDAPython scripts

Step 5: Iterate
  - Functions migrated in the first round become new anchors
  - Enter these functions and continue comparing internal calls
  - Repeat until all target functions are covered
```

### Anchor Selection Strategy

| Anchor Type | Reliability | Description |
|---------|--------|------|
| Exported functions | Highest | Names stay the same; addresses may change |
| String references | High | String content stays the same; reference locations may change |
| Constants/magic numbers | Medium | Characteristic values stay the same |
| Code patterns | Medium | Function structure is similar but addresses all change |

### Batch Processing Recommendations

- Compare 1 function at a time (avoid context explosion)
- Use deepseek for medium functions (<200 lines)
- Switch to gpt-4o or claude for very large functions (>500 lines)
- Use concurrent calls to improve speed (10-20 concurrent)
- Cache results to avoid repeated calls

## Output Format

### 5 Symbol Types in YAML Output

| Type | Meaning | Key Fields |
|------|------|---------|
| `found_vcall` | Virtual function call (indirect call) | `vfunc_offset`, `func_name` |
| `found_call` | Direct function call | `insn_va`, `func_name` |
| `found_funcptr` | Function pointer reference | `insn_va`, `funcptr_name` |
| `found_gv` | Global variable reference | `insn_va`, `gv_name` |
| `found_struct_offset` | Struct offset reference | `offset`, `struct_name`, `member_name` |

### Application Actions After Parsing

```text
found_call → idapro_rename(addr=call_target, name=func_name)
found_vcall → idapro_set_comments(addr=insn_va, comment="vcall: {func_name} @ +{offset}")
found_funcptr → idapro_rename(addr=funcptr_target, name=funcptr_name)
found_gv → idapro_rename(addr=gv_addr, name=gv_name)
found_struct_offset → idapro_set_comments(addr=insn_va, comment="{struct_name}.{member_name}")
```

## Typical Scenario Examples

### Scenario 1: ntoskrnl.exe missing PDB

```text
Have: ntoskrnl.exe 10.0.26100.2000 + complete PDB
Target: ntoskrnl.exe 10.0.26100.2605 (PDB delisted)
Need: Locate the new address of PspSetCreateProcessNotifyRoutine

Steps:
1. Load both versions into IDA
2. Find the exported function PsSetCreateProcessNotifyRoutine (present in both versions)
3. In the old version it calls PspSetCreateProcessNotifyRoutine (with symbols)
4. In the new version it calls sub_140822108 (without symbols)
5. The LLM immediately sees: sub_140822108 = PspSetCreateProcessNotifyRoutine
6. Batch apply
```

### Scenario 2: Migration after application update

```text
Have: complete reverse engineering results for target.exe v1.0 (200+ functions named)
Target: target.exe v1.1 (all symbols lost)
Need: Batch-migrate 200 function names

Steps:
1. Export disassembly + pseudocode of all named functions from the old version
2. Find corresponding anchors in the new version via exported functions/strings
3. Batch-call the LLM for comparison
4. Parse YAML and batch rename
5. Iterate deeper
```

## LLM Selection Recommendations

| Model | Suitable Scenario | Cost | Speed |
|------|---------|------|------|
| DeepSeek V3 | Small/medium functions (<200 lines), batch processing | Very low | Fast |
| GPT-4o | Very large functions, complex control flow | Medium | Fast |
| Claude Sonnet | Medium/large functions, requires reasoning | Medium | Fast |
| Claude Opus | Extremely complex functions, requires deep understanding | High | Slow |

Recommended strategy: Default to DeepSeek; automatically upgrade when context limits are exceeded or results are inaccurate.

## Notes

- **Do not throw the entire binary at the LLM** — Compare only one function at a time
- **Anchors must be reliable** — If the anchor itself is wrong, all subsequent work is wasted
- **Results need manual spot-checking** — The LLM is not 100% accurate; key symbols must be verified
- **Cache intermediate results** — Avoid wasting tokens on repeated calls
- **Mind context limits** — Very large functions (>1000 lines of disassembly) need to be split or handled with a large-context model

---

## On-Demand Bootstrap

### Tool Dependencies

| Tool | Purpose | Auto-installable |
|------|------|-----------|
| IDA Pro | Export disassembly/pseudocode | ✗ (commercial software) |
| Python | Script execution, API calls | ✓ |
| PyYAML | Parse YAML returned by the LLM | ✓ (pip install pyyaml) |
| LLM API | Perform comparison | Requires API key |

### Notes

The core of this skill does not depend on heavy tool installation; it mainly depends on:
- IDA Pro already available (managed with the `ida-reverse/` skill)
- Python + requests/httpx (to call the API)
- An LLM API endpoint

---

## Routing Context

**Upstream entry**: `skills/SKILL.md` (master control), `routing.md`
**Trigger condition**: Have old-version symbols/reverse engineering results and need to migrate to a new version
**Downstream exits**:
- Need to open the binary first → `ida-reverse/`
- Need quick reconnaissance to confirm version differences → `radare2/`

**Peer related module**: `ida-reverse/` (data export and symbol application both go through IDA)


## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I execute every step in the workflow (rather than just reading)?
- [ ] Did I use real tool paths based on `tool-index`?
- [ ] Did I produce reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Did I complete and write back the Checklist items required by RULES?
