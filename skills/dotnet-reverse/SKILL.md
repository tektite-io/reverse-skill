---
name: dotnet-reverse
description: .NET / C# binary reverse engineering. Use when the target is a .NET assembly (PE header contains CLR, .exe/.dll managed program), C# compilation output (including NativeAOT), red team Sharp* tools (Rubeus / SharpHound / SharpHound, etc.), .NET obfuscated programs (ConfuserEx / SmartAssembly / Babel / Eazfuscator), or .NET loader / info-stealer / packed malware. Prefer dnSpyEx + de4dot; link with dnSpy MCP when AI direct operation is needed. Not for pure native binaries (use reverse-engineering / ida-reverse).
license: MIT
compatibility: Requires a filesystem-based code agent or CLI with shell access, Windows host preferred (dnSpyEx is a Windows GUI); Linux/macOS can use ILSpy/de4dot CLI + mono/dotnet runtime.
allowed-tools: Bash Read Write Edit Glob Grep Task WebFetch WebSearch
metadata:
  user-invocable: "false"
---

# .NET / C# Reverse Engineering Work Specification

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Use DIE/`file`/CLR header to confirm the target is .NET managed (otherwise SWITCH to `ida-reverse/` / `reverse-engineering/`)
2. `NOW`: If obfuscation is suspected → run `de4dot` first to unpack, producing `*-clean.exe`, and keep the original sample
3. `NEXT`: dnSpyEx (or dnSpy MCP / `ilspycmd`) static analysis: C# browsing + **IL view** for key decisions
4. `ACT`: Dynamic debugging when plaintext/C2 is needed; when changing logic, prefer **IL patch** over C# recompilation
5. At the end of the phase, give the user a 3–6 item next-step menu (including exporting reports)

## Applicable Scenarios

Prefer this skill when the task falls into the following scenarios:

- Identify and reverse engineer .NET / C# compilation output (managed PE / .exe / .dll)
- Analyze red team Sharp* toolchains (Rubeus, SharpHound, SharpShell, etc.)
- Unpack obfuscators such as ConfuserEx / SmartAssembly / Babel / Eazfuscator / .NET Reactor
- Reverse engineer the decryption and C2 logic of .NET loaders / info-stealers / RATs
- Patch C# programs (change decisions, change constants, keygen)
- Analyze the Mono/Unity managed layer before IL2CPP (note: IL2CPP compiles to native; use `reverse-engineering/` + seed-014)

If the target is a pure native binary (compiled from C/C++/Go/Rust without CLR), use `reverse-engineering/`, `ida-reverse/`, or `radare2/` instead.

## Core Principles

- **Identify before acting**: First confirm it is a .NET managed program (PE header CLR + `#~` / `#Strings` streams + mscoree `_CorExeMain`), then decide to use dnSpy rather than IDA
- **IL over C#**: dnSpyEx's C# decompiler loses/distorts information (compiler-generated state machines, async/await, yield); key decisions and patches must switch to the **IL editor**, while the C# view is only for quick browsing
- **de4dot first**: When encountering an obfuscator, run `de4dot` once before static analysis; otherwise strings/control flow will be a mess
- **MCP integration**: If dnSpy MCP (`dnspy_*` tools) is registered in the environment, prefer the MCP interface for decompile / IL inspection to avoid switching back and forth in the GUI
- **Evidence-based output**: Unpacked artifacts, extracted configurations/C2/keys, and patch diffs must all be written to disk

## Toolchain Mapping

| Capability | Preferred | Notes |
|------|------|------|
| Decompile + debug + patch | **dnSpyEx** | Ace, the only GUI with an IL editor; old dnSpy is no longer maintained, use the Ex branch |
| Lightweight CLI / headless decompilation | **ILSpy** (`ilspycmd`) | Suitable for batch, scripting, Linux/macOS |
| Deobfuscation | **de4dot** | Default solution for mainstream shells such as the ConfuserEx family and SmartAssembly |
| Obfuscator identification | **Detect It Easy (DIE)** / **file** | Determine the shell type first, then decide de4dot parameters |
| Programmatic IL manipulation | **dnlib** | Write C# scripts to batch-modify metadata / string decryptors |
| AI direct operation | **dnSpy MCP** | Tool surfaces such as `dnspy_decompile` / `dnspy_inspect_il` |

> Prerequisites: Install dnSpyEx + de4dot on a Windows host (choco or release); use `ilspycmd` + `dotnet runtime` on Linux/macOS. See the installation matrix in `references/sharp-tools.md`.

## Six-Phase Workflow

### 1. Identify (.NET Identification)

Confirm the target is a managed program; do not analyze a native PE as .NET:

```powershell
# Windows
file target.exe                       # "PE32 executable ... for MS Windows" is not enough
# Key: check whether there is a CLR
powershell -c "[System.Reflection.AssemblyName]::GetAssemblyName('target.exe')"
# Or
dnSpyEx drag-and-drop — if it opens, it is managed

# Generic
strings target.exe | grep -iE "mscoree|_CorExeMain|mscorlib|System\\."
```

**.NET Identification Markers:**
- PE header `Data Directory[14]` (CLR Runtime Header) is nonzero
- `mscoree.dll` import / `_CorExeMain` entry
- `#~`, `#Strings`, `#US`, `#GUID`, `#Blob` metadata streams
- `mscorlib` / `System.Private.CoreLib` strings

**NativeAOT exception:** Compiled to native, no CLR header, but contains `System.Private.CoreLib` strings and reconstructed type metadata — route these to `reverse-engineering/` (IDA/r2); this skill only provides identification hints.

### 2. Detect (Obfuscator Detection)

```powershell
# DIE quick identification
diec target.exe                        # Detect It Easy CLI
# Or drag it into dnSpyEx to see if there are many garbled class names / control flow distortion
```

Common obfuscators → unpacking strategies (see `references/obfuscators.md` for details):

| Obfuscator | Characteristics | de4dot Handling |
|--------|------|------------|
| ConfuserEx (1.0.0 / 2.x) | `<module>` anti-tamper, control flow distortion, string encryption | `de4dot target.exe` usually auto-detects |
| SmartAssembly | `circular`/`string encoding`, resource compression | `de4dot target.exe` |
| Babel.NET | Method body encryption, control flow | `de4dot target.exe` |
| Eazfuscator.NET | String/resource encryption | `de4dot`; some versions require manual work |
| .NET Reactor | anti-tamper + necrobit | `de4dot`; newer versions may fail and require manual work |

### 3. Deobfuscate

```powershell
# de4dot auto-detects most shells by default
de4dot target.exe -o target-clean.exe

# Specify type (when auto-detection fails)
de4dot --type cfze target.exe          # ConfuserEx
de4dot --type sa target.exe            # SmartAssembly

# Multi-layer obfuscation / de4dot reports unknown
de4dot --detect target.exe             # See what it identifies as
# May need to patch anti-tamper first, then run de4dot (see references/obfuscators.md)
```

Output: `target-clean.exe`; use it for subsequent analysis. **Keep the original sample** for comparison.

### 4. Static Analyze

Load the unpacked sample in dnSpyEx:

- **C# view**: Quickly browse class structure, method signatures, and strings (for locating)
- **IL view**: Key decisions, encryption logic, and state machines must be examined in IL (right-click → Edit IL or IL view)
- Find the entry: `Main` / `Startup` / module initializer (`Module .cctor`)
- Find key logic: search for `flag`, `password`, `verify`, `check`, `encrypt`, `http`, `Config`

```text
Locate string → cross-reference → find the method that uses it → view decision logic in IL view
```

### 5. Dynamic

dnSpyEx debugger: Attach to process / start debugging, set breakpoints on key methods, and observe at runtime:
- Decrypted plaintext strings (many obfuscators only decrypt strings at runtime)
- C2 addresses and configuration decryption results
- Exception-driven control flow (anti-debug commonly uses `try/catch` to hide the real path)

> .NET dynamic debugging is much friendlier than native — you can directly see object values and string contents. Prefer dynamic over stubbornly sticking to static.

### 6. Patch (Modify as Needed)

```text
dnSpyEx → Right-click method → Edit Method (C#) or Edit IL
  - Change decision: ldc.i4.0 → ldc.i4.1 (false→true)
  - Change constants: Directly edit strings/numbers
  - Remove validation: NOP out the entire block
File → Save Module → Replace the original file
```

**IL patch reliability > C# patch**: C# recompilation may fail (missing references, syntax errors), while IL editing almost never distorts. See `references/common-workflow.md` for details.

## Trigger Scenario Routing

Enter this skill when the user says:
- ".NET / C# binary reverse engineering" / "C# program decompilation"
- "dnSpy analysis" / "dnSpyEx patch"
- "ConfuserEx / SmartAssembly / Babel deobfuscation / unpacking"
- "Sharp* tool analysis" (Rubeus / SharpHound / SharpShell)
- ".NET malware / loader / info-stealer reverse engineering"
- "C# program patch / keygen / modify decisions"

## When to Switch Out

- Unity games compiled with IL2CPP → `reverse-engineering/` + `seed-014_unity-il2cpp-reverse.md` (IL2CPP is native; do not use dnSpy)
- NativeAOT output → `reverse-engineering/` (same as above, native)
- Pure native PE (no CLR) → `reverse-engineering/` / `ida-reverse/`
- Need to batch-migrate symbols/functions to another version → `binary-diff/`
- Need to draw attack paths / call chain diagrams → `diagram-generator/`

## Routing Context

**Upstream entry**: `skills/SKILL.md` (master control), `routing.md`
**Downstream exits**:
- IL2CPP / NativeAOT (native) → `reverse-engineering/`
- Deep native .so/.dll section analysis → `ida-reverse/` / `radare2/`
- Need AI to directly operate dnSpy → register and link dnSpy MCP (see `references/sharp-tools.md`)

**Peer related modules**:
- `reverse-engineering/languages-compiled.md` (.NET introduction points to this module)
- `apk-reverse/` (Xamarin/MAUI Android reverse engineering can switch back to this module for the C# layer)

## Reference Documentation

- [references/obfuscators.md](references/obfuscators.md) — Detailed ConfuserEx / SmartAssembly / Babel / Eazfuscator / .NET Reactor deobfuscation + anti-tamper bypass
- [references/common-workflow.md](references/common-workflow.md) — Complete workflow, IL patch reliability, string decryptor extraction, state machine identification
- [references/sharp-tools.md](references/sharp-tools.md) — Red team Sharp* tool analysis, tool installation matrix, dnSpy MCP integration, community resource index

## Task Completion Self-Check

- [ ] Did I confirm the CLR / managed identity (or switch out of this skill)?
- [ ] Was the obfuscated sample first de4dot/equivalently unpacked before deep analysis?
- [ ] Was key logic verified with the IL view (rather than only reading C# pseudocode)?
- [ ] Were artifacts (clean sample / configuration / patch diff) written to disk and reproducible?
- [ ] Did I provide a next-step menu or report exit?
