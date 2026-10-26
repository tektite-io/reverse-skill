---
name: edr-bypass-re
description: |
  Reverse the defender's implementation → targeted red-team bypass. First reverse the EDR / Defender / AV hook tables, ETW providers, and AMSI implementations, then write targeted unhook / indirect syscall / ETW patch / call stack spoof techniques. Aligned with MITRE ATT&CK T1562 (Defense Evasion).
  Trigger keywords: EDR bypass, AV bypass, antivirus evasion, unhook, direct syscall, indirect syscall, Hell's Gate, Halo's Gate,
  Tartarus Gate, ETW patch, AMSI patch, call stack spoofing, hardware breakpoint Blindside, MITRE T1562,
  ntdll unhook, kernel callback, CrowdStrike bypass, Defender bypass, SentinelOne bypass, Elastic Defend,
  Sysmon evasion, PPID spoof, sleep mask, Process Hollowing, Reflective DLL.
---

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md` — confirm that this skill's operations are authorized routine operations
2. `NOW`: Confirm whether the current task falls within this skill's applicable scope
3. `NEXT`: Read `../tool-index.md`, verify tool availability and actual paths
4. `NEXT`: Call bootstrap when tools are missing; do not guess paths
5. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation state

# EDR Bypass: From Reversing the Defender's Implementation to Red-Team Bypass

> Authorized red team / adversary emulation / testing of your own products only. Prohibited against unauthorized targets.

## Applicable Scenarios

Use this skill when a red team or adversary simulation needs to deliver an implant to an authorized target host while evading modern EDR.

1. **Red team / Purple team / adversary emulation** — the client wants to assess the real detection capability of their SOC and EDR
2. **In-house implant / C2 framework development** — building payloads for testing your own products that must bypass your own or the target's EDR
3. **EDR product evaluation** — objectively assessing a given EDR's detection coverage once compliance boundaries are confirmed
4. **CTF / red-team exercise Windows-side breakout** — the competition requires stable execution on a hardened host

**Out of scope:**

- An antivirus vendor performing full RE on its own product to deliver a commercial assessment report to a customer (seek a formal vendor partnership)
- Antivirus evasion against unauthorized targets (illegal)
- Evasion for ordinary viruses and trojans (this skill focuses on red-team OPSEC, not on how to write malicious code)

### Division of labor with other skills

| Scenario | Use |
|------|--------|
| Full-chain offense (from the internet to the domain controller) | `attack-chain/` |
| Internal lateral movement / AD attacks | `pentest-tools/network-attack-defense.md` |
| Delivering an implant past EDR on one specific host | **this skill** |
| Pure static evasion (obfuscation / packing) | `malware-analysis/` (defender's perspective) |

`attack-chain` covers the complete kill chain; this skill focuses only on the internal mechanics of **EDR as a single adversary** and the targeted ways to bypass them.

## Core Principles

```text
EDR's four main monitoring surfaces          Red-team countermeasures
─────────────────────              ─────────────────────
User-mode ntdll hooks       ◄──►   unhook (Peruns Fart / fresh ntdll)
                                   indirect syscall / Hell's Gate
                                   hardware breakpoint Blindside

kernel callbacks            ◄──►   call stack spoof
(Ps/Cm/Ob family)                  use legitimate trigger chains (don't bypass directly; pair with upstream stealth)

ETW telemetry               ◄──►   EtwEventWrite patch
(Microsoft-Windows-Threat-          disable the provider via NtTraceControl
 Intelligence, etc.)                handle AmsiContext in sync

AMSI scanning               ◄──►   AmsiScanBuffer patch (mov eax,0x80070057; ret)
(amsi.dll)                         hardware breakpoint bypass
                                   reflectively load a copy of amsi.dll
```

Key insights:

- **EDR is not a black box** — the key hooks / callbacks / providers can all be reversed with IDA + WinDbg
- **Bypass techniques must be combined** — an unhook alone does not stop ETW alerts, and an AMSI patch alone does not stop syscall hooks
- **Order matters** — ETW patch first → then AMSI patch → then unhook; get the order wrong and the EDR receives the unhook alert first
- **Modern EDR has made ETW + kernel callbacks the main battlefield**; user-mode unhooking alone has long been insufficient

## Workflow

### Step 1: Identify the target host's EDR

```powershell
# List common EDR / AV drivers
Get-Service | Where-Object {$_.Name -match 'CSAgent|SentinelAgent|elasticendpoint|esets|ekrn|MsMpEng|wdsvc|cyserver|sysmon|aswbidsagent'}

# List loaded minifilters
fltmc filters

# List registered kernel callbacks (requires WinDbg + kernel debugging / or use PChunter / DRVHV)
# !object \Callback
# !pnpcallback / Process / Thread / Image
```

See the top of `references/hook-survey.md` for the EDR fingerprint table.

### Step 2: Extract the hook table from the EDR DLL

1. Attach to a process that has an EDR user-mode component injected (any already-running process)
2. Dump the current `ntdll.dll` `.text` section in WinDbg
3. Diff it against the clean `C:\Windows\System32\ntdll.dll` on disk
4. Wherever they differ is a hook point

Or use `pe-sieve` directly:

```powershell
pe-sieve64.exe /pid 1234 /shellc 3 /modules 3 /dir hooks_dump
```

See `references/hook-survey.md` for the detailed method.

### Step 3: Choose a bypass technique combination

| Defense point | Recommended bypass |
|--------|---------|
| ntdll inline hook | indirect syscall + dynamic SSN (Halo's Gate) |
| ETW-TI provider | EtwEventWrite head patch |
| AMSI (PowerShell / .NET) | AmsiScanBuffer patch or HWBP |
| kernel callback | call stack spoof + route through a legitimate gadget |
| Sysmon ProcessCreate | PPID spoof + unbacked memory |

### Step 4: Implement in the implant

See `references/unhook-techniques.md` and `references/telemetry-blinding.md` for code skeletons.

### Step 5: Validate in a local sandbox

```powershell
# Deploy a trial version of the target EDR in an isolated environment (Defender's defaults are enough to start)
# Enable Sysmon + olaf-config
sysmon64.exe -i sysmonconfig.xml

# Run the implant and see whether it triggers these alert sources:
#   - Defender AMSI
#   - ETW-TI
#   - Sysmon Event ID 1/7/8/10
#   - EDR console
```

### Step 6: Delivery

- Use legitimate software directories for on-disk paths
- PPID-spoof to explorer.exe
- Pair with the initial access section in `attack-chain`

## Typical Scenarios

### Scenario 1: Deliver a Cobalt-Strike-like beacon past Defender + Sysmon

```text
Target: Windows 11 Enterprise + Defender (cloud-delivered protection on) + Sysmon (olaf config)
Requirement: the beacon must call back after landing without triggering any alerts

Combination:
  1. Store shellcode encrypted; decrypt at runtime
  2. AMSI patch (if delivering via PowerShell)
  3. EtwEventWrite patch (eliminate ETW-TI)
  4. Indirect syscall + Halo's Gate (eliminate ntdll hook alerts)
  5. PPID-spoof to explorer.exe
  6. During sleep, use Ekko / Foliage to encrypt its own memory
```

### Scenario 2: Apply an EDR sleep mask on an already-landed low-privilege shell

```text
Prerequisite: a medium-IL shell obtained via phishing; EDR is monitoring
Risk: long-term residency is easily caught by memory scans matching beacon signatures

Solution:
  1. Stop requesting new RWX memory
  2. During sleep, use Ekko:
       - WaitForSingleObjectEx + CreateTimerQueueTimer
       - Inside the timer, encrypt its own .text + zero out the stack
  3. On wake, restore via ROP
  4. Pair with call stack spoof so RtlCaptureStackBackTrace cannot see the beacon's addresses
```

## On-Demand Bootstrap

### Tool dependencies

| Tool | Purpose | Auto-installable |
|------|------|-----------|
| pe-sieve | Detect hooks / injection in processes | ✓ |
| API Monitor v2 | Dynamically observe API calls and hooks | Semi-automatic (manual download) |
| SysWhispers3 | Generate direct / indirect syscall stubs | ✓ (git clone + python) |
| Hell's Gate POC | Reference implementation for dynamic SSN resolution | ✓ (git clone) |
| WinDbg + IDA | Static reversing of EDR DLLs / kernel callbacks | ✗ (install yourself) |
| Sysmon + olaf config | Local validation environment | ✓ |

### Bootstrap command

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "&lt;SKILL_ROOT&gt;\skills\scripts\bootstrap-reverse.ps1" -Capability @('pe-sieve','syswhispers3','sysmon') -StartServices
```

## Routing Context

**Upstream entry points**:

- `reverse-engineering/` — you need to understand the EDR DLL / driver implementation first
- `attack-chain/` — decides at which stage of the kill chain to bring in this skill

**Peer associations**:

- `pentest-tools/network-attack-defense.md` — how to coordinate with this skill during internal lateral movement
- `malware-analysis/` — the defender's perspective; how detection teams write rules
- `field-journal/` — write back lessons after each engagement

**Downstream deliverables**:

- When producing reports, cite MITRE ATT&CK **T1562 (Impair Defenses)**, T1562.001 (Disable or Modify Tools), T1562.006 (Indicator Blocking), T1055 (Process Injection), T1027 (Obfuscated Files or Information)

## Legal Boundary Statement

- Authorized red team / adversary emulation / testing of your own products only
- Written authorization must be obtained before operations (SoW / testing contract / SRC scope statement)
- Must not be used against unauthorized targets or exceed the authorized scope
- Report high-risk findings to the client immediately and follow responsible disclosure
- Real target information in all reports must be redacted (IP / hostname / domain / credential placeholders)

## References

- Detailed hook survey: `references/hook-survey.md`
- Unhook / syscall techniques: `references/unhook-techniques.md`
- ETW / AMSI / anti-forensics: `references/telemetry-blinding.md`
- MITRE ATT&CK T1562: <https://attack.mitre.org/techniques/T1562/>


## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I execute every step in the workflow (rather than only reading it)?
- [ ] Did I use real tool paths based on `tool-index`?
- [ ] Did I produce reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Did I complete and write back the Checklist items required by RULES?
