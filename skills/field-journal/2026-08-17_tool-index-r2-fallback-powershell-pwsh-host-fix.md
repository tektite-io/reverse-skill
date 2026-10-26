# 2026-08-17 reverse-skill

## Scenario Classification
Toolchain and environment (bootstrap-phase defect fixes)

## Goal Overview
Fix three layers of mutually masking defects in the local bootstrap process: the tool-index misreporting the radare2 main analyzer `r2` as no; multiple test scripts hardcoding `powershell` subprocess calls that fail on a machine with only PowerShell 7+ installed; and a pin gate StrictMode property-access bug masked by that failure.

## Scope Summary (Anonymized)
- auth_basis: own_system (this repository itself)
- network_profile: offline / no external-target ACT
- asset_types: [local scripts and tool index]

## Roles
- lead_role: lead
- specialists: [bootstrap, test-infra]

## Full Execution Chain

1. Run the bootstrap per section 0 of `README_AI.md`: `refresh-tool-index.ps1` generates tool-index.md (37 tools).
2. Read `tool-index.md` and find an anomaly: `r2` (the radare2 main analyzer) = no, but `rabin2/rasm2/radiff2/rahash2/rax2/r2pm` in the same directory are all = yes.
3. List `C:\Users\{username}\Tools\radare2\bin` and confirm: `r2.bat` exists (21 bytes, content `@"%~dp0\radare2" %*`) along with `radare2.exe`, but there is **no `r2.exe`**.
4. Read `lib/ToolDiscovery.ps1:131-141`; `r2`'s Fallbacks only look for `r2.exe`, missing `r2.bat`/`radare2.exe`. By contrast, `jadx`/`apktool`/`analyzeHeadless` all have fallbacks configured for `.bat` tools.
5. Fix: add `r2.bat` and `radare2.exe` paths to `r2`'s Fallbacks (covering three locations: `%USERPROFILE%\Tools\radare2\bin`, the root directory, and `C:\Tools\`), keeping the original `r2.exe` fallback for other machines.
6. Rerun `refresh-tool-index.ps1`; `r2` turns yes, path `r2.bat`, version `radare2 6.2.0`, source `FallbackPath`.
7. Run `smoke.ps1` and it still FAILs: `verify-routing-coherence exit 1`. Run verify directly to see the error and locate `verify-routing-coherence.ps1:257` hardcoding `& powershell`; this machine has no `powershell` (only `pwsh` 7.6.4).
8. grep all repo `.ps1` files for `powershell\s(-NoProfile|-ExecutionPolicy|-File|-Command)` and find 5 scripts with 20+ hardcoded `& powershell` subprocess calls (verify 7, test-p0-friction 18, test-routing 1, case-init 1; the rest are comment examples).
9. Find that `smoke.ps1:31-46` already correctly uses `$SmokeHostExe` (current process path first → pwsh → Windows PowerShell path as a fallback). Extract that verified logic into a shared function `Resolve-ReverseHostExe`, creating `lib/HostRuntime.ps1`, with resolution order: current process → `pwsh` → `powershell` → `%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe`.
10. The 4 sub-scripts dot-source `HostRuntime.ps1` and define `$HostExe`; `replaceAll` changes `& powershell -NoProfile -ExecutionPolicy Bypass -File` → `& $HostExe -NoProfile -ExecutionPolicy Bypass -File`; the `cmd /c "powershell ..."` at `test-p0-friction.ps1:244` is changed separately to `cmd /c "`"$HostExe`" ..."` (the path may contain spaces and needs quoting).
11. Rerun smoke; verify passes 257 but exposes `verify-routing-coherence.ps1:414`, where the pin gate errors under `Set-StrictMode -Version Latest` when accessing nonexistent properties like `$cap.pinnedVersion` — a pre-existing bug masked until now by the powershell bug.
12. Fix 414: convert `$cap` to a hashtable (`$capMap`); index access to a nonexistent key returns `$null` without erroring, and the pin gate semantics are unchanged.
13. Rerun smoke → ALL PASS (VERIFY_EXIT=0 / PARSE 11/11 / ROUTE 9/9).
14. Run `test-routing.ps1` → 166/166 ALL PASS.
15. Run `test-p0-friction.ps1` → mostly passes, but `:343` and `:364` again hit `Start-Process -FilePath 'powershell.exe'` (the earlier grep pattern `powershell\s+(-NoProfile...)` missed the `powershell.exe` literal).
16. grep `powershell\.exe` and confirm only test-p0-friction's 343/364 are hardcoded Start-Process (the rest are compatibility lookups or fallback paths); `replaceAll` changes them to `Start-Process -FilePath $HostExe`.
17. Rerun `test-p0-friction.ps1` → ALL PASS (FAIL_COUNT=0). All three suites green.

## Evidence Chain Summary (Anonymized)
> This was a bootstrap fix for the repository itself, with no external-target ACT, so no evidence files are produced under a case directory. The following are reproducible verification commands (equivalent Evidence).

| E-id | severity | status | source_type | Reusable command pattern | Related Finding |
|------|----------|--------|-------------|----------------|--------------|
| E-r2 | info | validated | command | after `pwsh -File skills/scripts/refresh-tool-index.ps1`, the `r2` row in tool-index.md = yes | F-r2 |
| E-smoke | info | validated | command | `pwsh -File skills/scripts/smoke.ps1` → `OVERALL: ALL PASS` | F-host |
| E-route | info | validated | command | `pwsh -File skills/scripts/test-routing.ps1` → `166/166 ALL PASS` | F-host |
| E-p0 | info | validated | command | `pwsh -File skills/scripts/test-p0-friction.ps1` → `OVERALL: ALL PASS` | F-host |

## Finding / Path Summary
- top_finding: three layers of mutually masking defects — `r2` fallback missing the `.bat` entry → `verify` hardcoded `powershell` failing and aborting → masking the pin gate StrictMode property-access bug; and the grep compatibility scan missed the `powershell.exe` literal.
- path_type: solve
- path_one_liner: use a shared `Resolve-ReverseHostExe` (current process first) to unify subprocess entry points, add `.bat`/`radare2.exe` fallbacks for `r2`, and use a hashtable to safely access optional PSCustomObject properties.

## Pitfalls

| Problem | Cause | Solution | Time |
|------|------|---------|------|
| tool-index marks `r2` no, but other r2* tools in the same directory are yes | `ToolDiscovery.ps1`'s `r2` Fallbacks only look for `r2.exe`, while the radare2 Windows distribution wraps `radare2.exe` with `r2.bat` and has no `r2.exe` | Add `r2.bat` and `radare2.exe` path fallbacks | Short |
| smoke still FAILs: verify exit 1 | verify internally hardcodes `& powershell`, and this machine has only pwsh 7+ and no `powershell` | Create `Resolve-ReverseHostExe` in `lib/HostRuntime.ps1` and replace 4 scripts with `& $HostExe` | Medium |
| After fixing powershell, verify fails again at 414 | A pre-existing bug masked by the 257 powershell bug: under StrictMode, accessing nonexistent properties like `$cap.pinnedVersion` errors | Convert `$cap` to a hashtable `$capMap`; index access does not error | Short |
| test-p0-friction fails again at 343/364 | `Start-Process -FilePath 'powershell.exe'` is hardcoded; the earlier grep pattern `powershell\s+(-NoProfile...)` missed the `powershell.exe` literal | grep `powershell\.exe` to complete the scan and switch to `$HostExe` | Short |
| test-p0-friction outputs many `Exception: case-init.ps1:54` | Test 14b intentionally uses an invalid CaseName to trigger a case-init exception; this is expected | No action needed; FAIL_COUNT=0 at the end means it passes | — |

## Toolchain Findings
- **radare2 Windows distribution structure**: the main program is `radare2.exe`, and `r2.bat` (`@"%~dp0\radare2" %*`) is its batch wrapper; there is **no `r2.exe`**. Any tool scan probing for `r2.exe` will misreport. `rabin2.exe`/`rasm2.exe` etc. in the same directory are standalone `.exe` files and probe normally.
- **PowerShell 7+ only environment**: this machine has `pwsh` 7.6.4 (path `C:\Program Files\WindowsApps\Microsoft.PowerShell_7.6.4.0_x64__8wekyb3d8bbwe\pwsh.exe`) and **no `powershell` / `powershell.exe`**. All `& powershell ...` subprocess calls fail directly in this environment.
- **StrictMode property access**: under `Set-StrictMode -Version Latest`, accessing a nonexistent property of a `PSCustomObject` throws; using hashtable index access to a nonexistent key returns `$null`, which is the safe pattern for "many optional properties" scenarios like the pin gate.
- **grep compatibility scan blind spot**: using `powershell\s+(-NoProfile...)` only catches the `& powershell -File` form, missing `Start-Process -FilePath 'powershell.exe'` and `cmd /c "powershell ..."`. A compatibility scan should cover both `powershell\s` and `powershell\.exe`.

## Key Code/Commands

```powershell
# lib/HostRuntime.ps1 —— unified subprocess PowerShell entry (current process first)
function Resolve-ReverseHostExe {
    [CmdletBinding()] [OutputType([string])] param()
    $hostExe = $null
    try { $p = (Get-Process -Id $PID -ErrorAction Stop).Path; if ($p -and (Test-Path -LiteralPath $p)) { $hostExe = $p } } catch { }
    if (-not $hostExe) { $c = Get-Command pwsh -ErrorAction SilentlyContinue; if ($c -and $c.Source) { $hostExe = $c.Source } }
    if (-not $hostExe) { $c = Get-Command powershell -ErrorAction SilentlyContinue; if ($c -and $c.Source) { $hostExe = $c.Source } }
    if (-not $hostExe -and $env:SystemRoot) { $f = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'; if (Test-Path -LiteralPath $f) { $hostExe = $f } }
    if (-not $hostExe) { throw 'No usable PowerShell host executable found.' }
    return $hostExe
}

# ToolDiscovery.ps1 r2 Fallbacks —— add .bat/.exe entries
Fallbacks = @(
    @{ Type = 'command'; Value = 'r2' },
    @{ Type = 'command'; Value = 'radare2' },
    @{ Type = 'path'; Value = (Join-Path $userProfile 'Tools\radare2\bin\r2.bat') },
    @{ Type = 'path'; Value = (Join-Path $userProfile 'Tools\radare2\bin\radare2.exe') },
    @{ Type = 'path'; Value = (Join-Path $userProfile 'Tools\radare2\bin\r2.exe') }
    # ... root directory and C:\Tools mirrors
)

# verify-routing-coherence.ps1:412 —— pin gate safe property access
foreach ($cap in $mc.capabilities) {
    $capMap = @{}
    foreach ($prop in $cap.PSObject.Properties) { $capMap[$prop.Name] = $prop.Value }
    if (-not $capMap['canAutoInstall']) { continue }
    $hasPin = ($capMap['pinnedVersion'] -or $capMap['pinnedCommit'] -or $capMap['pinPolicy'])
    # ... switch ($capMap['bootstrapKind']) ...
}
```

## Suggestions for This Package
- **Script the compatibility scan**: in `verify-routing-coherence.ps1` or a standalone lint, scan all `.ps1` subprocess calls and forbid bare `powershell` / `powershell.exe`, requiring `Resolve-ReverseHostExe` uniformly. This time it was done by hand grep and was easy to miss (the `powershell.exe` blind spot was hit).
- **`.bat` convention for the tool catalog**: on Windows, `jadx`/`apktool`/`r2`/`analyzeHeadless` all wrap `.exe` with `.bat`; the catalog should configure both a `.bat` and the corresponding `.exe` fallback for each such tool, to avoid hitting pitfalls one by one.
- **CI should include a "pwsh-only" matrix**: on GitHub Actions' `windows-latest`, if Windows PowerShell 5.1 is not preinstalled, this class of bug is exposed. `smoke.ps1` currently does it right with `$SmokeHostExe`, but the sub-scripts do not reuse it.
- **Iterating PSCustomObject under StrictMode**: for checks with a loose object schema like the pin gate, uniformly use hashtable conversion for access, or provide a `Get-SafeProp` helper.

## Reusable Patterns/Script Fragments
- `Resolve-ReverseHostExe`: whenever a script needs to launch a child PowerShell process, dot-source `lib/HostRuntime.ps1` and use `& $HostExe -NoProfile -ExecutionPolicy Bypass -File <script> ...`, compatible with pwsh-only / powershell-only / mixed environments.
- `$capMap` conversion: iterate a `PSCustomObject`'s properties into a hashtable, then index-access, avoiding StrictMode nonexistent-property exceptions.
- `r2.bat` → `radare2.exe` pass-through: version detection `r2.bat -v` correctly returns `radare2 6.2.0`, proving the `.bat` wrapper passes arguments through and can safely be used as a catalog entry.

## Evolution Actions
- [x] Updated the tool-index (r2 turned yes, path r2.bat)
- [x] Added `skills/scripts/lib/HostRuntime.ps1`
- [x] Fixed `ToolDiscovery.ps1` r2 Fallbacks
- [x] Fixed `verify-routing-coherence.ps1` powershell hardcoding + pin gate StrictMode
- [x] Fixed `case-init.ps1` / `test-routing.ps1` / `test-p0-friction.ps1` powershell hardcoding
- [ ] Updated the routing matrix (none)
- [ ] Updated the bootstrap-manifest (none)
- [ ] Added a pitfalls record (this entry)

## Environment Information
- OS: Windows (win32)
- Shell/Host: pwsh 7.6.4 (`C:\Program Files\WindowsApps\Microsoft.PowerShell_7.6.4.0_x64__8wekyb3d8bbwe\pwsh.exe`); this machine has no `powershell` / `powershell.exe`
- radare2: 6.2.0 +1 abi:132 @ windows-x86_64 (installed at `C:\Users\{username}\Tools\radare2\bin\`)
- Repository root: `D:\Sources\reverse-skill`

## Anonymization Requirements
This was a script fix for the repository itself, with no real target domains/IPs/credentials; no anonymization needed.

## Index Sync (final step before commit)

After writing this log, update `_index.md` in sync:
1. Add a row to the "toolchain and environment" subsection ✓
2. Append this file name to "high-frequency success patterns" (unified PowerShell subprocess entry) ✓
3. Append this file name to the "entity inverted index" (reverse-skill bootstrap scripts) ✓
4. Update the "statistics" total and the last-updated date ✓

---
<!-- [Evolution stats] Cumulative completed items in this package: 19 | New patterns this time: 1 (Resolve-ReverseHostExe unified subprocess entry) | Toolchain issues fixed this time: 3 (r2 fallback / powershell hardcoding / pin gate StrictMode) -->
<!-- [Community contribution] This fix addresses the repository's own bootstrap defects and fits the fix-type PR in CONTRIBUTING.md; after completion, ask the user whether to submit. -->
