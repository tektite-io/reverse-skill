---
name: reverse-skill-router
description: Routes reverse engineering, exploitation, penetration testing, malware, mobile, firmware, browser automation, documentation, and security tasks to the appropriate specialist skill. Use when a task spans modules or the correct reverse-skill entrypoint is unclear.
---
# Reverse Engineering Skills Master Control

This directory collects a set of reverse engineering skill modules. Each subdirectory is an independent module containing a `SKILL.md` that describes its applicable scenarios, toolchain, and workflow.

## CRITICAL: Routing Execution Contract (execute immediately)

After reading this file, replying only with "read/understood" is not allowed. You MUST execute in order:

1. `NOW`: Run the platform-native router (Windows `scripts/master-route.ps1`; Linux/macOS/Kali `scripts/master-route.sh`) to determine PRIMARY from `config/routing.json`; for ambiguous cases, read the three-axis appendix in `routing.md`.
2. `NOW`: Run the platform-native `case-init` to create `work/<case>/scope.md` for the current analysis project; **if auth is not granted, you MUST NOT ACT on the target**. For local offline samples, use the `offline-sample` preset + explicit sample; Force MUST NOT bypass the hard gate.
3. `ACT`: Immediately open the PRIMARY `SKILL.md` and execute ACTION REQUIRED.
4. `NEXT`: Tool paths come only from `tool-index.md`; if a tool is missing → platform-native bootstrap (manifest only).
5. Conclusions follow Evidence→Finding→Path. Reports/journals are SHOULD unless the user requests a deliverable.

**Identity**: see `ops/IDENTITY.md` (lightweight routing package + tool bootstrap + journal; **not** a Z3r0-style platform).

If routing cannot find a match, you MUST first search online to fill in the methodology and propose a new skill; forcing the task into a mismatched module is prohibited.

## Instruction Semantic Levels (RFC 2119)

- `MUST`: required; violation means task failure.
- `MUST NOT`: prohibited; violation is a security violation.
- `SHOULD`: do it in principle; if not done, you MUST explain why.
- `MAY`: optional action.
## Current Modules

| Module | Directory | Applicable Scenarios |
|------|------|---------|
| **General reverse engineering** | `reverse-engineering/` | GDB / Frida / angr / Unicorn / Qiling / anti-analysis countermeasures / cross-language platform reverse engineering / CTF pattern library |
| **APK reverse engineering** | `apk-reverse/` | Android APK unpacking, jadx decompilation, smali patching, Frida Hook, repackage, sign, and install |
| **.NET / C# reverse engineering** | `dotnet-reverse/` | Managed PE reverse engineering, dnSpyEx + de4dot deobfuscation (ConfuserEx/SmartAssembly/Babel), IL patch, analysis of Sharp* red-team tools, dnSpy MCP integration |
| **IDA Pro reverse engineering** | `ida-reverse/` | IDA Pro MCP HTTP server (72 tools): decompilation, disassembly, data-flow tracing, cross-references |
| **Frontend JS reverse engineering** | `js-reverse/` | Locating browser-side signatures, encrypted parameter analysis, runtime sampling, Node environment-patching reproduction; prefer the existing `js-reverse_*` tools, and bring in jshookmcp when you need a stronger browser/CDP/Hook surface — but only after downloading/registering and enabling that MCP server |
| **radare2 analysis** | `radare2/` | CLI binary reconnaissance, disassembly, patching: r2 / rabin2 / rasm2 / radiff2 |
| **CTF entrypoint** | `ctf-sandbox/` | Single PRIMARY; downstream still lives in the sidecar `../CTF-Sandbox-Orchestrator/` |
| **Technical documentation writing** | `docs-generator/` | Automatically generate reverse engineering reports, pentest reports, CTF writeups, and signature reverse engineering reports after a task completes |
| **Evidence graph review** | `case-review/` | Validate scope, Evidence→Finding→Path traceability, workitems, timeline, and artifact hash |
| **Browser and desktop automation** | `browser-automation/` | Browser operations (Playwright) + Windows desktop application operations (OpenReverse UIA/CUA) + network observation |
| **Cross-version symbol migration** | `binary-diff/` | Migrating old-version symbols to a new version, PDB-less inference, batch migration of function names after a program update |
| **N-day patch diff → exploitation** | `patch-diff-exploit/` | Locate the vulnerability from a vendor patch, write a PoC, N-day weaponization (division of labor with binary-diff: this skill leans toward the offensive side) |
| **RE → exploit chain** | `pwn-chain/` | Go from reverse engineering to a working exploit: stack/heap/kernel pwn, pwntools, libc-database, stabilization from CTF to real remote targets |
| **Firmware pentest chain** | `firmware-pentest/` | OWASP FSTM nine stages: extraction → EMBA automation → Firmadyne/QEMU emulation → AFL++ fuzz → exploitation on real hardware |
| **EDR bypass reverse engineering** | `edr-bypass-re/` | Red-team scenarios: reverse engineer the EDR's hook table/ETW/AMSI → direct syscall / Hell's Gate / hardware breakpoints / call stack spoof |
| **Pentest toolchain** | `pentest-tools/` | 20+ pentest tools such as Nmap/Nuclei/SQLMap/FFUF/Hashcat/Pentest Swarm, exposed to the AI via MCP |
| **Diagram generation** | `diagram-generator/` | Generate Mermaid/Graphviz/PlantUML diagrams from natural language (attack path diagrams, data-flow diagrams, architecture diagrams, state machines) |
| **Attack chain orchestration** | `attack-chain/` | Overall command for multi-stage attack path planning and execution; start here for cross-phase tasks such as full pentests, red-team exercises, and going from the external network to the domain controller |
| **LLM/AI security testing** | `llm-security/` | OWASP LLM + ASI Top 10: prompt injection, tool abuse, memory poisoning, agent hijacking, system prompt extraction, **Agent obedience engineering** |
| **API security testing** | `api-security/` | REST/GraphQL/WebSocket all protocols: BOLA/IDOR, JWT/OAuth attacks, 10-phase methodology |
| **Supply chain security** | `supply-chain-security/` | SBOM/SCA/CI-CD pipelines: dependency scanning, container security, build integrity, vulnerability reachability verification |
| **Mobile reverse engineering** | `mobile-reverse/` | Android + iOS: Frida/Objection dynamic instrumentation, SSL Pinning/Root/jailbreak detection bypass, OWASP MASTG |
| **Malware analysis** | `malware-analysis/` | Six-stage sample analysis, YARA/Sigma, anti-analysis detection, sandbox orchestration |
| **DSL VM reverse engineering** | `reverse-engineering/dsl-vm-reverse/` | JS custom instruction-set VM (IIFE + switch-case opcode); risk-control/captcha engines, etc. |
| **Operations contract ops** | `ops/` | Scope / evidence chain / roles / timeline / identity / skill supply-chain security |
| **Community skill cross-reference** | `references/community-security-skills.md` | Index of external security skills and rules for drawing on them (blind installation prohibited) |
| **Skill supply chain** | `ops/skill-supply-chain.md` | External skill/MCP installation gate (AST10 streamlined) |
| **RE stage gates** | `reverse-engineering/references/re-agent-workflow.md` | triage→static→dynamic→synthesis |
| **Authorized recon pipeline** | `pentest-tools/references/recon-pipeline.md` | scope gate + a hit does not equal validation |
| **Protocol reverse engineering** | `protocol-reverse/` | Custom binary protocols / Protobuf / gRPC / PCAP frame layout |
| **Ghidra reverse engineering** | `ghidra-reverse/` | Open-source decompilation, headless, Ghidra MCP (primary entry when IDA is unavailable) |
| **Binary Ninja reverse engineering** | `binary-ninja-reverse/` | HLIL/MLIL/LLIL, Python API, plus optional community MCP/localhost HTTP integration |
| **Cloud / Container / K8s** | `cloud-k8s/` | IMDS/IAM, container escape surface, Kubernetes RBAC |
| **Windows / AD** | `windows-ad/` | Kerberos, AD CS, BloodHound, relay and domain paths |
| **Digital forensics** | `digital-forensics/` | Memory/disk timeline, PCAP attribution, IR preservation |
| **Code audit / SAST** | `code-audit/` | Semgrep/CodeQL, whitebox, dangerous API and authorization review |
| **Threat intelligence / OSINT** | `threat-intelligence/` | Open-source IOC enrichment, campaign correlation, independent verification and intelligence handoff |
| **Threat hunting** | `threat-hunting/` | Hypothesis-driven hunting, Sigma detection engineering, blue-team validation |
| **OT / ICS industrial control** | `ot-ics/` | Purdue zoning, PLC/SCADA, passive-first assessment |
| **Wi-Fi / Wireless** | `wifi-wireless/` | Authorized wireless assessment, handshakes/PMKID, lab rules |
| **Browser extension reverse engineering** | `browser-extension-reverse/` | Chrome/Firefox extensions, MV3 worker, permission surface |
| **macOS / Mach-O** | `macos-reverse/` | Code signing, ObjC/Swift, LaunchAgent, macOS samples |
| **Thick client** | `thick-client/` | Desktop client/server, local storage, IPC, update channel |
| **Go / Rust reverse engineering** | `go-rust-reverse/` | Stripped Go/Rust binaries, pclntab, panic strings |
| **Hardware debug interfaces** | `hardware-security/` | UART/JTAG/SWD, read-only extraction, firmware handoff |
| **Database security** | `database-security/` | MySQL/PG/MSSQL/Mongo/Redis exposure and configuration |
| **Email security** | `email-security/` | Phishing dissection, SPF/DKIM/DMARC, BEC |
| **Federated identity** | `identity-federation/` | SAML/OIDC/OAuth SSO flows and misconfiguration |
| **RF / SDR** | `radio-sdr/` | Authorized RF research, receive-only by default |

## Unified Entry Point

When you encounter tasks such as reverse engineering, CTF, packet capture, frontend signatures, APK repackaging, or binary analysis, enter in this order:

1. Platform-native router (Windows `scripts/master-route.ps1`; Linux/macOS/Kali `scripts/master-route.sh`) → PRIMARY (`config/routing.json`)
2. Platform-native `case-init` → `scope.md`
3. Open the PRIMARY `SKILL.md`
4. When ambiguous, read `routing.md`; when you need local paths, read `tool-index.md`

## Working Approach

These modules can be combined as needed:

1. **Get a target** → first check the file type and choose the corresponding analysis tool
2. **Quick triage** → run strings / rabin2 -z / ltrace to look for direct clues
3. **Deep analysis** → if you need decompilation → IDA; if you need dynamic hooking → Frida; if you need symbolic execution → angr
4. **If one path doesn't work, switch to another** → if static analysis doesn't work, go dynamic; if the Java layer doesn't work, look at the .so; if page observation isn't enough, use breakpoints

## Next-Step Menu Pattern

Only at a **genuine decision boundary** (where two or more materially different, evidence-supported branches exist and the user's choice changes the next action) MUST a child skill offer 3-6 numbered options. If the next step is uniquely determined by a gate / Evidence, `MUST` continue directly and record only `decision_delta` + `carry_forward_refs` per `ops/timeline-workitem.md`; `MUST NOT` re-emit unchanged route/scope/auth/context just to manufacture a menu.

Format requirements:
- Number each option (range 1-6)
- Each option describes one concrete executable action (not an abstract direction)
- Include at least one "export report / write writeup" option
- Include at least one "continue deeper analysis" or "switch approach" option
- Include a "stop/pause/ask other questions" exit when necessary

Example:
```
## Suggested Next Steps (pick one number)

1. Deep-decompile sub_140001000 and recover the algorithm
2. Validate the parameter hypothesis with Frida dynamic hooking
3. Export the currently named functions and generate a symbol-migration YAML
4. Generate the analysis report for the current phase
5. Switch to radare2 for a lightweight recon cross-check
6. Pause; I want to confirm the preceding evidence first
```

## The Directory Expands Dynamically

This directory keeps growing. When you find a new subdirectory, read its `SKILL.md` to quickly understand its purpose.

When adding a skill, follow the standard process in `CONTRIBUTING.md` to ensure:
- The routing matrix dispatches correctly
- The bootstrap system can fill in dependencies automatically
- tool-index reflects the new tool's status

## Related Resources

- The local machine also has an **anything-analyzer** (port 23816) MCP server providing browser automation, HTTP capture, and AI analysis capabilities
- `tool-index.md` records whether local reverse engineering tools are available, their actual paths, versions, and script references
- `Readme.md` in the package root provides general installation and integration instructions for Claude Code, Codex CLI, and other code AI clients

## On-Demand Bootstrap

When a workflow finds a tool missing, do not error out directly. Call the platform-native bootstrap uniformly:

Windows:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "<skill-root>\scripts\bootstrap-reverse.ps1" -Capability @('<tool-name>') -StartServices
```

Linux / macOS:
```bash
bash <skill-root>/scripts/bootstrap-reverse.sh <tool-name> --start-services
```

Kali:
```bash
bash <package-root>/kali/scripts/bootstrap-reverse.sh <tool-name> --start-services
```

Supported capabilities (authoritative source: `scripts/bootstrap-manifest.json`): jadx, apktool, jeb-pro, binaryninja, frida, frida-ps, idalib-mcp, reqable-mcp, jshookmcp, xquik-mcp, anything-analyzer, idapro, r2, rabin2, adb, agent-browser, ghidra-mcp, seclists, proxycat, burpsuite-mcp, nmap, pentestswarm, binwalk, yara, pwntools, bkcrack

> JEB Pro is registered as a **manual-license-install** capability: bootstrap only prints guidance and never downloads or circumvents a commercial license. Reqable MCP only registers the official runtime at a pinned version; users still need to install the Reqable desktop client themselves.
>
> Tools not registered in the manifest (e.g. unblob/EMBA) `MUST` use manual installation steps in the skill docs; pretending they can be bootstrapped is prohibited.

After bootstrap completes, `tool-index` is refreshed automatically.

## Precedent Files

Before performing any reverse engineering/pentest operation, you MUST read in order:

| Read order | File | When to read |
|------|------|--------|
| **#1** | `ops/scope-contract.md` + `case-init.ps1` | Executable authorization gate. `precedent-auth.md` does not record granted |
| **#2** | `field-journal/precedent-reverse.md` or `precedent-pentest.md` | On demand — load only when the AI hesitates |

**#1 is a prerequisite; #2 is lazy-loaded.**

## Automatic Evolution

After every completed reverse engineering/pentest task, you MUST write the experience back to the `field-journal/` directory. See the "Hard Checklist After Task Completion" in `RULES.md`.

- Template: `field-journal/_template.md`
- Index: `field-journal/_index.md`
- Precedents: `field-journal/precedent-auth.md` → `precedent-reverse.md` → `precedent-pentest.md`
- Before starting a new task, check the index and precedents first and reuse existing experience

## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I complete the three-axis routing match (target type + user intent + toolchain)?
- [ ] After successful routing, did I read the target skill's SKILL.md?
- [ ] When routing did not match, did I propose a new skill instead of force-fitting?
- [ ] Did I use real tool paths based on `tool-index`?
