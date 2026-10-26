---
name: ida-reverse
description: |
  IDA Pro reverse engineering analysis assistant skill. Whenever the user mentions reverse engineering, decompilation, analyzing binaries/PE/ELF/APK/DLL/SO, cracking, finding passwords, vulnerability analysis, virus analysis, or firmware analysis, or needs to analyze exe/dll/so/elf/macho/sys files, be sure to use this skill.

  Ensure to use this skill when the user wants to analyze any binary file, regardless of whether they explicitly mention "IDA" or "reverse engineering". This includes requests like "看看这个exe", "分析这个dll", "帮我破解", "找一下密码", "这个软件怎么注册", etc.

  Use the bundled scripts (scripts/start.ps1, scripts/open.ps1) for deterministic server management and file opening — do NOT write ad-hoc PowerShell commands for these operations.
---

# IDA Pro Reverse Engineering Analysis Skill

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md` — confirm that this skill's operations are authorized routine operations
2. `NOW`: Confirm whether the current task falls within this skill's applicable scope
3. `NEXT`: Read `../tool-index.md`, verify tool availability and actual paths
4. `NEXT`: Call bootstrap when tools are missing; do not guess paths
5. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation state

## Known Issues and Lessons Learned (required reading)

### Pitfalls encountered

1. **Do not rely on some AI clients' MCP layer to call `idb_open` (formerly `idalib_open`) directly**
   - Some AI coding clients' MCP clients have a BUG validating the output schema of open-type tools
   - Error: `Structured content does not match the tool's output schema`
   - **Workaround**: Use the `scripts/open.ps1` script to call the HTTP API directly, bypassing the MCP validation layer
   - In ida-pro-mcp 2.x the tools are named `idb_open` / `idb_list` / `idb_save` (no longer `idalib_*`)
   - After a file is opened it returns a `session_id` (database); subsequent tool calls must carry that session

2. **No permission to open files under `C:\Windows\System32\`**
   - idalib cannot read files in the System32 directory directly
   - **Workaround**: `open.ps1` automatically detects this and copies the file to a temporary directory before opening it

3. **The server startup command blocks the conversation**
   - After `idalib-mcp` starts, it continuously writes INFO logs to the console
   - **Workaround**: Use `scripts/start.ps1` (starts silently in the background with `-WindowStyle Hidden`)
   - The script waits for the service to become ready and then exits automatically, without blocking the conversation

4. **MCP server names cannot contain hyphens**
   - Previously `ida-pro-mcp` was used as the server name, which may cause tool registration problems
   - **Current configuration**: server name `idapro`, tool prefix `idapro_*`

5. **Remote HTTP vs Local Stdio**
   - `type:"local"` (stdio) mode: `idalib_open` has the same schema validation problem
   - `type:"remote"` (HTTP) mode: you can open the file directly with a script first, then use the MCP tools
   - **Current approach**: Remote HTTP mode

6. **PR #389 fixed some of the schema issues**
   - After issue #388, the author mrexodia merged fixes via PR #389
   - It fixed the structuredContent schema in HTTP mode, but some validation on the AI client side still has problems
   - The latest `main` branch build is installed

7. **idalib timeouts leave orphaned worker processes holding lock files**
   - After the first `open.ps1` timeout, idalib's Python worker child process may become orphaned and keep holding `.id0`/`.id1`/`.nam`
   - Any subsequent tool or manual drag into the IDA GUI then reports "insufficient permissions"
   - **Do not** use `taskkill /F /T` to kill the process tree — `/T` also kills the GUI `ida.exe` child process
   - **Workaround**: `start.ps1` replaces the managed supervisor only when nothing is listening on the port, or when `tools/list` returns quickly but `py_eval` is missing (old supervisor); if RPC times out while 13337 is still listening, treat it as busy and do not kill. When opening a database, `open.ps1` writes `opening.lock`; the watchdog must not use `-Force`
   - **Deadlock exception**: only when `tools/list` **has failed continuously for more than 3 minutes** (based on the last-healthy timestamp, not process creation time), and there is no in-flight `opening.lock`, and the GUI does not hold the port, may you `-Force`-replace the supervisor; still do not kill `ida.exe`
   - **Last resort**: when `open.ps1` detects that an old database is locked, it automatically copies it to Temp and prefixes the name with a GUID

8. **Opening with auto-analysis looks like a hang**
   - `idalib_open(run_auto_analysis=true)` may not respond for a long time while the backend is in fact still opening and analyzing
   - Users previously saw "PowerShell produces no output", which is easy to misdiagnose as a stuck script
   - **Current workaround**: `open.ps1` adds `-TimeoutSeconds` and switches to a background request + foreground polling + periodic progress output
   - If polling finds the session ready, it returns `OK:filename:session_id` early; on timeout it returns `ERR:open_timeout_xxs`

9. **HTTP MCP silently exits after login**
   - Cursor/Claude's `type: http` does not spawn the process on its behalf; the old scheduled task only ran once at login
   - `pythonw` has no console, so when it crashes the Application log is empty too
   - **Workaround**: `start.ps1` reuses a healthy server by default; `watchdog.ps1` checks every minute; logs go to `%LOCALAPPDATA%\reverse-skill\ida-mcp\`
   - Install: `scripts/install-autostart.ps1`. If the port is not up yet when an HTTP client starts, you still need to refresh manually once in the MCP panel

10. **Streamable HTTP GET `/mcp` blocks the single-threaded supervisor**
    - Some HTTP MCP clients open a long-lived GET (SSE) to `/mcp`. The stock `idalib_supervisor` uses an `HTTPServer` with `background=False`, handling one request at a time
    - Result: `tools/list` times out and the client marks `idapro` as error
    - **Workaround**: `run-supervisor.py` switches HTTP to `ThreadingHTTPServer` and accepts GET `/mcp`; if the patch fails it is skipped and the supervisor still starts. When stuck, use `scripts/recover.ps1` (immediate `-Force`)

### Workflow principles

| Step | What to do | What to use |
|------|--------|--------|
| 1 | Make sure the HTTP server is running | `scripts/start.ps1` (no arguments) |
| 2 | Open the target binary | `scripts/open.ps1 -Path "xxx.exe"` |
| 3 | Use the MCP analysis tools | Call `idapro_*` / HTTP tools directly (about 65, depending on version) |
| 4 | Analysis complete | Tools become available automatically |

## Script Resources

### start.ps1 — Start the MCP HTTP server

Path: `scripts/start.ps1`

- Automatically resolves `IDADIR` (environment variable / portable edition desktop path / common install paths)
- Prefers IDA's bundled `Python314\python.exe -m ida_pro_mcp.idalib_supervisor`
- By default probes `http://127.0.0.1:13337/mcp` first; if healthy, outputs `OK:<n>:reuse` and exits
- 13337 is listening but `tools/list` times out → `WARN:busy` / `OK:busy:reuse`, **do not kill** (it cannot respond while opening a database or while the GUI holds the port)
- `tools/list` **has failed continuously for more than 3 minutes** (last-healthy timestamp) and there is no `opening.lock` → treat as deadlock, output `INFO:deadlock`, and `-Force`-replace the supervisor. In-progress `idb_open` and the GUI never take this path
- Replaces the managed supervisor only when nothing is listening on the port, when `py_eval` is missing, or in the deadlock case above; **never kill `ida.exe`, never use `taskkill /T`**
- When the GUI holds 13337, output `WARN:gui_busy` and exit without starting another supervisor
- On success outputs `OK:<tool count>` (currently about 66); on failure outputs `ERR:timeout`
- Supervisor log: `%LOCALAPPDATA%\reverse-skill\ida-mcp\supervisor.log`
- The server runs in the background and does not block the conversation

**Invocation**:
```
powershell -File "<skill-root>\ida-reverse\scripts\start.ps1"
```

### watchdog.ps1 / recover.ps1 / install-autostart.ps1 — Keep-alive

- `watchdog.ps1`: probes 13337; healthy → reuse (and refresh last-healthy); GUI / `open.ps1` database lock / busy with last-healthy under 3 minutes → reuse; only after `tools/list` has failed continuously for more than 3 minutes does it run `start.ps1 -Force`
- `recover.ps1`: immediately runs `start.ps1 -Force` (does not kill `ida.exe`). Use this when an HTTP client marks `idapro` as error
- `install-autostart.ps1`: registers the scheduled task `reverse-skill-ida-mcp` (at login + every minute)
- Log: `%LOCALAPPDATA%\reverse-skill\ida-mcp\watchdog.log`

### open.ps1 — Open a binary file

Path: `scripts/open.ps1`

- Calls `idb_open` directly through the HTTP API, bypassing MCP schema validation
- Automatically detects System32 paths and copies them to a temporary directory
- Automatically cleans up old database files with the same name (`.id0`/`.id1`/`.nam`/`.til`/`.i64`)
- When an old database is locked, automatically degrades: copies to Temp with a GUID prefix and opens it without reporting an error
- Runs the open request in the background to avoid the script becoming unresponsive from a long synchronous wait
- Supports `-TimeoutSeconds`; on timeout it returns `ERR:open_timeout_xxs` instead of hanging indefinitely
- Outputs `INFO:opening:elapsed/timeout seconds` every 10 seconds so you can tell analysis is still running
- On success outputs `OK:filename:session_id`; when degraded, appends a `(temp copy)` marker
- On failure, automatically retries with the Temp copy

**Invocation**:
```
powershell -File "<skill-root>\ida-reverse\scripts\open.ps1" -Path "C:\path\to\file.exe"
```

**Optional parameters**:
```
# Specify SessionId
powershell -File "scripts\open.ps1" -Path "file.exe" -SessionId "my_session"

# Skip auto-analysis (recommended for large files)
powershell -File "scripts\open.ps1" -Path "large.exe" -NoAutoAnalysis

# Set a timeout to avoid long periods without a response when auto-analysis is on
powershell -File "scripts\open.ps1" -Path "file.exe" -TimeoutSeconds 600
```

**Output conventions**:
```
# Analysis in progress (printed every 10 seconds)
INFO:opening:11/600s

# Opened successfully
OK:sample.exe:abcd1234

# Opened successfully, but degraded to a Temp copy due to a lock file
OK:1234abcd-sample.exe:abcd1234 (temp copy)

# Reached the timeout limit
ERR:open_timeout_600s
```

**Field notes**:
- `Snipaste.exe` with auto-analysis took about `324s` to return success in testing; that is "analysis is slow", not "the script deadlocked"
- Therefore, for GUI programs or more complex samples, prefer explicitly setting `-TimeoutSeconds 600`

## Core Tool List

### Survey analysis (first step)
- `idapro_survey_binary(detail_level="minimal")` — quick survey: function count, strings, segments, entry point, import classification (crypto/network/file IO)
- `idapro_list_funcs(queries)` — list functions (paginated, filter by name)
- `idapro_list_globals(queries)` — list global variables
- `idapro_entity_query(kind, filter)` — unified query: functions/globals/imports/strings/names

### Decompilation and disassembly
- `idapro_decompile(addr)` — decompile to pseudocode
- `idapro_disasm(addr, max_instructions=N)` — disassemble
- `idapro_analyze_function(addr, include_asm=false)` — combined analysis (pseudocode + strings + constants + callers + callees + blocks)
- `idapro_func_profile(queries)` — function summary metrics

### Cross-references and data flow
- `idapro_xrefs_to(addrs)` — find what references the target address
- `idapro_xref_query(addr, direction)` — advanced xref query (direction/type filtering)
- `idapro_callees(addrs)` — list callees
- `idapro_callgraph(roots, max_depth)` — call graph
- `idapro_trace_data_flow(addr, direction, max_depth)` — data-flow tracing (forward/backward)

### Search
- `idapro_find_regex(pattern, limit)` — regex string search
- `idapro_search_text(pattern)` — search text in the disassembly listing
- `idapro_find_bytes(patterns, limit)` — byte pattern search (supports ?? wildcards)
- `idapro_find(type, targets)` — advanced search (immediates/strings/references)

### Memory and data
- `idapro_get_bytes(addrs)` — read raw bytes
- `idapro_get_string(addrs)` — read a string
- `idapro_get_int(queries)` — read integer values
- `idapro_get_global_value(queries)` — read global variable values
- `idapro_read_struct(queries)` — read struct field values
- `idapro_search_structs(filter)` — search structs

### Modification operations
- `idapro_set_comments(items)` — add comments (two-way sync between disassembly and decompilation)
- `idapro_append_comments(items)` — append comments
- `idapro_rename(batch)` — batch rename (functions/globals/locals/stack variables)
- `idapro_patch_asm(items)` — patch assembly instructions
- `idapro_patch(patches)` — patch bytes
- `idapro_define_func(items)` — define a function
- `idapro_undefine(items)` — undefine
- `idapro_define_code(items)` — convert bytes to code

### Type system
- `idapro_declare_type(decls)` — declare C structs/enums/unions
- `idapro_set_type(edits)` — apply types to functions/globals/locals
- `idapro_infer_types(addrs)` — infer types
- `idapro_type_query(queries)` — query declared types
- `idapro_type_inspect(queries)` — inspect type details

### Stack frames
- `idapro_stack_frame(addrs)` — view stack frame variables
- `idapro_declare_stack(items)` — declare stack variables
- `idapro_delete_stack(items)` — delete stack variables

### Signatures
- `idapro_make_signature(addrs)` — generate a unique byte signature for an address
- `idapro_make_signature_for_function(addrs)` — generate a signature for a function
- `idapro_find_xref_signatures(addrs)` — generate signatures for code that references an address

### Debugger (requires ?ext=dbg)
- `idapro_open_file(file_path)` — open a file in a GUI IDA instance
- Debugger tools are hidden by default and can be enabled with the URL parameter `?ext=dbg`

### Session management (ida-pro-mcp 2.x)
- `idapro_idb_open` / HTTP `idb_open` — ⚠️ recommended to open via `open.ps1`
- `idapro_idb_list` / HTTP `idb_list` — list all sessions
- `idapro_idb_save` / HTTP `idb_save` — save the database
- Most analysis tools require a `database=<session_id>` parameter (the session output by open.ps1)

### Other
- `idapro_int_convert(inputs)` — base conversion (**you MUST use this; do not compute bases yourself!**)
- `idapro_export_funcs(addrs, format)` — export functions (json/c_header/prototypes)
- `idapro_py_eval(code)` — execute Python in the IDA context
- `idapro_server_health()` — server health check
- `idapro_server_warmup()` — warm up subsystems (string cache, Hex-Rays, etc.)

## Complete Reverse Engineering Workflow

### Step 1: Start the server

**Path A — Headless idalib (requires a valid license)**
```
powershell -File "scripts/start.ps1"
```
Outputting `OK:<tool count>` (currently about 65) means it is ready.

**Path B — GUI + plugin (when the idalib license fails or interactive analysis is needed)**
```
powershell -File "scripts/start-gui.ps1" -Path "C:\target.exe"
```
Or double-click the portable edition's `Launch-IDA-Pro.cmd` and open the sample in IDA.

Once the Output window shows `[MCP] ... port=13337`, the MCP tools are available.

See `LOCAL-SETUP.md` for the general integration steps.

### Step 2: Open the file

Headless:
```
powershell -File "scripts/open.ps1" -Path "C:\target.exe" -TimeoutSeconds 600
```
Outputting `OK:filename:session_id` means success (a trailing `(temp copy)` means it automatically degraded to a temporary copy).

If `ERR:idalib_license:...` appears, switch to Path B (GUI mode); do not repeatedly retry open.ps1.

GUI mode: just open the sample directly in IDA; open.ps1 is not needed.

### Step 3: Global survey (including the hard gate on the import table)
```
idapro_survey_binary(detail_level="minimal")
```
Pay attention to:
- Architecture (x86/x64/ARM)
- Entry point (main/WinMain/DllMain)
- Interesting strings (URLs, paths, error messages)
- **Import classification (MUST)**: crypto functions / network APIs / file operations / process injection / registry — must be recorded as Evidence (suggested id: `E-imports`); use `idapro_entity_query(kind="imports")` or the imports section of the survey output
- **DLL/SYS**: the export table sits alongside the import table (Evidence `E-exports`)
- **.NET**: when there is no traditional IAT, use the module/metadata/managed-reference summary as an equivalent anchor in the E-imports semantic slot
- **Clean import table**: note the suspicion of dynamic loading and push for dynamic API breakpoint validation
- Popular functions (functions with high xref counts are usually the key logic)

**Hard gate**: before the imports view/classification summary (or a legitimate equivalent anchor) is written into Evidence, you MUST NOT move on to deep-dive conclusions in Step 4, and MUST NOT claim the survey is complete. When the import table is empty or the query fails, you still MUST record the failure. When IAT repair on a packed binary fails, you MUST record `E-iat-repair-fail` and switch to dynamic debugging to capture APIs; do not keep grinding statically. When the user asks you to redo the import table/IAT check, you MUST redo the named step (feasibility latch when blocked: explain + confirm; if forced, mark quality=unreadable); do not substitute unrelated steps.

### Step 4: Deep-dive into key functions
```
idapro_analyze_function(addr="key_function_name")
```
Or:
```
idapro_decompile(addr="function_name")
idapro_disasm(addr="function_name", max_instructions=50)
```

### Step 5: Data flow and cross-references
```
idapro_xrefs_to(addrs="key_address/string")
idapro_callgraph(roots=["key_function"], max_depth=3)
idapro_trace_data_flow(addr="key_address", direction="backward", max_depth=5)
```

### Step 6: Annotate and refine
```
idapro_set_comments(items=[{"addr": "0x140001000", "comment": "your understanding"}])
idapro_rename(batch={"func": [{"addr": "function_address", "name": "meaningful_name"}]})
```

### Step 7: Produce the report
After analysis is complete, generate `report.md` documenting the findings and steps.

## Prompt Engineering Guidelines

1. **Do not compute bases by hand** — whenever you need to convert a number, use `idapro_int_convert`
2. **Survey first, then deep-dive** — look at the overview before targeted analysis
3. **Keep annotating and renaming** — continuously update function and variable names during analysis to improve the accuracy of later analysis
4. **Follow cross-references** — when you find interesting data/strings, use `xrefs_to` to see what references them
5. **When you hit obfuscated code** — first do preprocessing such as string decryption, import-hash removal, and control-flow-flattening removal
6. **C++ STL code** — identify library functions with FLIRT/Lumina first, then analyze the business logic
7. **Do not brute-force** — derive the solution from the disassembly and use simple Python to assist with calculations
8. **When you see "No database bound"** — no binary has been opened yet; run `open.ps1` first
9. **When you see "Failed to open database"** — an old database file may be locked; `open.ps1` automatically degrades to a Temp copy (the output contains a `(temp copy)` marker)
10. **When opening GUI/complex samples with auto-analysis** — add `-TimeoutSeconds 600` by default; do not mistake a long-running `INFO:opening:...` for a stuck script

---

## Routing Context

**Upstream entry points**: `skills/SKILL.md` (master control), `routing.md`
**Upstream alternatives**: `radare2/` (if you do not want to open IDA, you can do quick reconnaissance with r2 first)
**Downstream exits**:
- Need Frida dynamic validation → `reverse-engineering/tools-dynamic.md`
- Need symbolic execution/angr → `reverse-engineering/tools-dynamic.md`
- Need general reverse engineering methodology → `reverse-engineering/SKILL.md`

**Peer association modules**: `radare2/` (alternative when IDA is unavailable)

---

## On-Demand Bootstrap

This skill's entry scripts are already connected to the unified bootstrap system.

### Automation capability boundaries

| Tool | Auto-installable | Install method | Notes |
|------|-----------|---------|------|
| idalib-mcp | ✓ | pip install (from GitHub) | Automatically installed when `start.ps1` is missing |
| IDA Pro itself | ✗ | Commercial software; manual install required | Set the `IDADIR` environment variable to the install directory |

### Installation steps (verified)

```cmd
# 1. Set the IDA path (replace with your actual IDA install directory)
setx IDADIR "<your IDA install directory>"

# 2. Install ida-pro-mcp from GitHub (the ida-mcp on PyPI is a different project; do not install the wrong one!)
pip install git+https://github.com/mrexodia/ida-pro-mcp.git

# 3. Install the IDA plugin (choose Streamable HTTP + Global + select all clients)
ida-pro-mcp --install

# 4. Restart IDA Pro and open the target file
# The plugin automatically listens on 127.0.0.1:13337

# 5. Verify
ida-pro-mcp --config
```

> ⚠️ **Note**: the `ida-mcp` package on PyPI (by jtsylve) is a different project and is not the one we need.
> You must install `mrexodia/ida-pro-mcp` from GitHub.

### Bootstrap trigger points

- `scripts/start.ps1`: automatically calls `bootstrap-reverse.ps1` when `idalib-mcp` is missing
- MCP registration: bootstrap automatically writes `idapro` into the Claude MCP configuration

### Prerequisites

- IDA Pro is installed and the `IDADIR` environment variable is set (or the script's default path is correct)
- Recommended to use the `ida-pro-mcp` inside IDA's bundled Python314 (the portable edition includes it)
- Common local configuration:
  - User env `IDADIR` → IDA install directory (containing `ida.exe`)
  - Optional `~\Tools\bin\idalib-mcp.cmd` / `ida-pro-mcp.cmd` wrappers
  - Keep only `idapro` as the client MCP server name → `http://127.0.0.1:13337/mcp`


## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I execute every step in the workflow (rather than only reading it)?
- [ ] Have survey/imports been written into Evidence (E-imports or equivalent)? Does DLL/SYS include E-exports? Is an IAT failure recorded as E-iat-repair-fail?
- [ ] If the user asked to redo the import table/IAT, did I redo the same step?
- [ ] Did I use real tool paths based on `tool-index`?
- [ ] Did I produce reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Did I complete and write back the Checklist items required by RULES?
