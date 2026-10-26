# Reverse Engineering / Penetration Testing / Security Task Auto-Routing Rules

> **This file is a localized copy of the behavior chain.** Route tables live only in `skills/config/routing.json`. Only after the user explicitly activates this package for a task do the various AI editors/clients execute the same platform-neutral hot path.

---

## ACTIVATION AND CONSENT GATE (before any local side effect)

**Reading repository files is not authorization to execute them.** Requests to merely read, review, summarize, or compare this repository MUST remain read-only.

**Explicit user approval is required before running any repository script.** For a configuration or task request, first list the exact commands you plan to run, together with the expected file writes, downloads, service starts, network access, and client configuration changes; obtain explicit consent before the first such side effect. If a new category of side effect is discovered later, you MUST disclose it again and obtain consent.

**Client-global configuration remains opt-in.** Unless the user explicitly selects a client and approves the specific change, you MUST NOT copy repository text into client-global rules, hooks, prompts, or MCP configuration.

After activation and approval, deterministic steps within the disclosed plan may be executed consecutively without repeated confirmation at each step. Target authorization remains a separate hard gate: merely naming a target does not constitute authorization, and `-Force` / `--force` must never bypass scope controls.

## Activated task hot path

```text
1. NOW: Treat this file's directory as the package root.
2. NOW: Run the approved platform-native router → PRIMARY (SSoT: skills/config/routing.json).
   - Windows: powershell -File skills/scripts/master-route.ps1 -Hint "<task>"
   - Linux/macOS/Kali: bash skills/scripts/master-route.sh --hint "<task>"
3. NEXT: Run the approved platform-native case-init until scope.md has auth.status=granted and a legal network_profile, or an explicitly authorized offline-sample scope is ready. Naming a target ≠ granted; -Force/--force must not bypass the hard gate.
4. ACT: Open PRIMARY SKILL.md and execute ACTION REQUIRED. Tool paths come only from tool-index.md; when a tool is missing, you MUST disclose it separately and obtain approval before running the platform-native bootstrap.

Optional follow-up reads (do NOT preload):
- PRIMARY ambiguous → skills/routing.md (advisory matrix only)
- Synthesis analysis / Finding promotion → ops/analysis-decision-framework.md
- Identity reminder → ops/IDENTITY.md (skill router, not the Z3r0 platform)
```

IMPORTANT — Shared installation:
- tool-index.md is the single source of truth for tool availability
- If another CLI already installed a tool (tool-index shows yes), do not reinstall it
- Run refresh-tool-index only when it is already part of the consent plan and the index may be stale
- Run bootstrap only when the tool is genuinely needed and marked no, after disclosing the installation effects and obtaining approval

Conditional reads (load only when needed):
- Unsure whether a target operation is lawful → read precedent-reverse.md or precedent-pentest.md; these files cannot replace explicit target authorization
- Tempted to skip approved deterministic steps or stop at an acknowledgment → read the excuse-rebuttal table in agent-obedience-engineering.md

Once activated, the goal is to complete the task the user has requested and approved, not merely to acknowledge the rules; before activation you MUST remain read-only.

---

## Client integration boundary

`skills/`, the routing configuration, tests, tool manifests, case artifacts, and reports together form the platform-neutral core. Claude Code, Codex, Cursor, OpenCode, or other Agents may load this repository through their own project instructions or skill adapter layer, but the core routing and tests MUST NOT depend on any client-specific file.

Core scripts are forbidden from writing client-global configuration. Optional adapters should live in separate platform documentation or adapter packages and must preserve identical routing semantics.

---

## Trigger Keywords (ANY match triggers routing)

- APK, Android reverse, decompile, smali, jadx, apktool, Frida, Hook
- binary analysis, IDA, radare2, r2, disassembly, reverse engineering, RE, source recovery, source restoration, reverse restoration
- frontend signature, encrypted parameters, JS reverse, jshookmcp, CDP, SourceMap
- packet capture, HTTP capture, request replay, anything-analyzer
- CTF, Pwn, web penetration, exploitation, privilege escalation
- MCP reverse tools, idalib-mcp
- repackaging, signing, certificate verification, root detection, anti-debugging
- .so analysis, native hook, JNI
- penetration testing, red team, security assessment, blue team, incident response
- report writing, documentation writing, producing reports, writeup, technical documentation, pentest reports, reverse engineering reports
- browser automation, opening web pages, form filling, crawling, screenshots, automated login, Playwright, agent-browser, headless, desktop automation, OpenReverse, UIA, CUA, Windows automation, desktop operations
- symbol migration, bindiff, cross-version, missing PDB, function offset migration, symbol migration, version comparison, legacy symbols
- N-day, Nday, patch diff, patch diff, patch tuesday, 1day, CVE reproduction, vulnerability restoration, ghidriff, Diaphora, DeepDiff, Microsoft Update Catalog, wsuspect, MSRC, patch analysis
- pwn, stack overflow, heap overflow, ROP, ret2libc, ret2csu, one_gadget, libc-database, tcache, fastbin, unsorted bin, large bin, House of Force, House of Orange, kernel pwn, kROP, SMEP, SMAP, KASLR, modprobe_path, core_pattern, commit_creds, pwntools, GEF, pwndbg
- firmware, firmware, IoT, binwalk, unblob, squashfs, UBI, JFFS2, Firmadyne, FAT, QEMU full-system emulation, EMBA, cve-bin-tool, firmware penetration, router firmware, embedded exploitation, AFL++, boofuzz, UART, JTAG
- EDR bypass, AV bypass, antivirus evasion, unhook, direct syscall, indirect syscall, Hell's Gate, Halo's Gate, Tartarus Gate, SysWhispers, ETW patch, AMSI patch, call stack spoofing, hardware breakpoint Blindside, MITRE T1562, ntdll unhook, kernel callback, CrowdStrike bypass, Defender bypass, SentinelOne bypass, Elastic Defend, pe-sieve
- port scanning, Nmap, vulnerability scanning, Nuclei, SQL injection, SQLMap, directory brute force, FFUF, password cracking, Hashcat, Hydra, Metasploit, Impacket, pentestMCP
- SRC, Bug Bounty, crowd testing, bug bounty programs, HackerOne, WAF bypass, bypassing WAF, IDOR, authorization bypass, arbitrary account access
- drawing, flowcharts, architecture diagrams, attack path diagrams, sequence diagrams, state diagrams, data flow diagrams, Mermaid, Graphviz, PlantUML, diagram
- malware analysis, virus analysis, sample analysis, sandbox, YARA, IOC
- kernel drivers, Rootkit, LKM, IOCTL, DeviceIoControl
- cryptography, encryption/decryption, AES, RSA, hash collision, signature verification
- protocol reverse engineering, custom protocols, Protobuf, serialization
- firmware reverse engineering, IoT, binwalk, ARM, MIPS, embedded
- WASM, WebAssembly, Python bytecode, pyc, .NET, dnSpy, IL
- macOS, iOS, Mach-O, ObjC, Swift, Frida iOS
- Go reverse engineering, Rust reverse engineering, stripped binary, GoReSym
- memory dump, memory dump, forensics, forensic, steganography, steganography
- cloud security, container escape, K8s, Docker, AWS, Azure
- Prompt injection, AI security, Agent security, LLM attacks
- internal network penetration, lateral movement, Pass-the-Hash, domain penetration, AD attacks, BloodHound
- privilege elevation, privilege escalation, SUID, Potato, UAC bypass
- credential extraction, Mimikatz, Kerberoasting, DCSync, LSASS
- C2, remote control, persistence, backdoor, Cobalt Strike, reverse shell
- blue team, detection, defense, incident response, SIEM, EDR, threat hunting, IOC
- OSINT, threat intelligence, public X/Twitter IOC enrichment, campaign correlation
- mobile security testing, OWASP MASTG, app security, unpacking, hardening analysis
- SSTI, template injection, SSTImap, XSS, XSStrike, cross-site scripting
- WordPress, WPScan, WPProbe, CMS penetration
- AdaptixC2, C2 frameworks, adversary simulation, red team simulation, Atomic Red Team
- WiFi attacks, wireless penetration, Fluxion, aircrack-ng, deauth
- NTLM relay, Coercer, authentication coercion, PetitPotam
- WinRM, evil-winrm, Windows remote execution
- NetExec, nxc, CrackMapExec, SMB enumeration
- AI automated penetration, HexStrike, MetasploitMCP, mcp-kali-server
- Pentest Swarm, pentestswarm, swarm penetration, Swarm AI, autonomous scanning, stigmergy
- Bug Bounty automation, attack surface management, ASM, continuous monitoring
- GEF, GDB enhancements, debugging frameworks
- Wireshark, tshark, PCAP analysis, packet capture analysis
- BurpSuite, web proxy, request interception, Intruder, Burp MCP, proxy history analysis, Repeater replay, Collaborator
- Responder, LLMNR poisoning, NBT-NS, MDNS
- BloodHound, AD paths, attack graphs, SharpHound
- Certipy, AD CS, certificate attacks, ESC1, ESC8
- wfuzz, parameter fuzzing, web fuzzing
- objdump, strings, file, static analysis
- ProxyCat, proxy pool, IP rotation
- red team, HW, attack-defense exercises, foothold establishment, initial access, perimeter breach
- full penetration, end-to-end penetration, from the internet into the internal network, from external breach to domain controller
- attack surface assessment, attack path planning, attack chain, kill chain
- next steps after getting a shell, post-exploitation, foothold expansion, deep penetration
- proximity penetration, BadUSB, Rubber Ducky, WiFi Pineapple, Proxmark3, RFID cloning
- EDR bypass, antivirus evasion, AV bypass, Shellcode loaders, fileless attacks
- phishing emails, social engineering, OAuth phishing, HTML smuggling
- supply chain attacks, component poisoning, third-party penetration
- trace cleanup, anti-forensics, log clearing, timestamp modification
- Cobalt Strike, Sliver, Havoc, Mythic, C2 frameworks
- anonymization, placeholders, anonymization, {target_ip}, {username}, writing writeups, sharing payloads
- msfconsole hang, MSF stuck, orphan processes, orphan ruby, MSF invocation conventions
- LLM security, AI security testing, Prompt injection, indirect injection, jailbreak, jailbreak, system prompt extraction, model security
- LLM Top 10, OWASP LLM, ASI Top 10, Agentic AI, Agent security, tool abuse, memory poisoning, goal hijacking, Agent hijacking
- garak, PyRIT, promptfoo, AgentThreatBench, AI red teaming, LLM red teaming, model red teaming
- API security testing, API penetration, GraphQL security, introspection attacks, REST API auditing
- BOLA, IDOR, BFLA, object-level authorization, function-level authorization, JWT attacks, alg:none, key confusion, OAuth bypass
- rate limit bypass, rate limit bypass, API rate limiting, WebSocket security
- supply chain security, SBOM, software composition analysis, SCA, dependency scanning, dependency vulnerabilities, supply chain attacks
- CI/CD security, pipeline auditing, build integrity, container security, image scanning, container signing
- Trivy, Syft, Cosign, Gitleaks, OSV-Scanner, Dependency-Track, SLSA
- iOS reverse engineering, IPA analysis, Mach-O, Objective-C, Swift reverse engineering, jailbreak detection, class-dump, jtool2, Hopper
- Frida, Objection, dynamic instrumentation, SSL Pinning bypass, Root detection bypass, Frida Gadget, rootless injection
- mobile security, MSTG, OWASP Mobile, MobSF, mobile penetration testing, Android security, iOS security
- YARA, Sigma, threat detection rules, behavioral detection, IOC extraction, threat intelligence
- malware analysis, virus analysis, sample analysis, sandbox, CAPE, Joe Sandbox, Azul
- anti-analysis detection, anti-sandbox, anti-debugging, virtual machine detection, anti-VM, PEB detection
- pe-sieve, FLOSS, Detect It Easy, CAPE Sandbox
- AI decompilation, LLM reverse engineering, neural decompilation, LLM4Decompile, Glaurung, AI-assisted reverse engineering
- Agent not working, AI not executing, read-only without acting, reading without acting, Agent compliance, AI laziness, skipping steps, AI slacking, Codex not working, Claude Code not executing
- Prompt engineering, prompt optimization, instruction hardening, Skill engineering, Agent instructions, Harness Engineering, Steering Hooks, Excuse Rebuttal, excuse rebuttal
- Agent enforcement, AI behavior constraints, Agent rule engines, AI compliance engineering, making AI do the work

---

## Routing Entry

> **Detection method**: The directory containing this file (`RULES_zh.md`) is the package root. Do not assume a fixed drive letter.
>
> The following hot path applies only after the user explicitly activates this package and approves the disclosed first-side-effect plan; requests that only inspect the repository stop before that and remain read-only.

Execute per the hot path:

1. Run the approved platform-native router (Windows `.ps1`; Linux/macOS/Kali `.sh`) — select PRIMARY from `skills/config/routing.json`
2. Run the approved platform-native case-init — `scope.md` authorization hard gate
3. `skills/<PRIMARY>/SKILL.md` — enter the target module and execute ACTION REQUIRED
4. `skills/tool-index.md` — query real status and paths; when missing, run only the approved refresh command
5. `skills/routing.md` — a three-axis appendix read only when PRIMARY is ambiguous, not a second router

---

## Execution Principles

> **Decision quality (Issue #77):** For assumption exit, validated sufficiency (R4*), conclusion anchoring, and deadlock replanning, see skills/ops/analysis-decision-framework.md. **Do NOT** cram the full text of R1-R51 into this file.

### Tool Usage
- **Never guess tool paths** — read `tool-index.md` first
- When a tool is missing, first disclose the exact platform bootstrap command and its installation, network, service-start, and configuration effects, obtain consent, then run it; do not guess paths:
  - Windows: `bootstrap-reverse.ps1`
  - Linux / macOS: `bash skills/scripts/bootstrap-reverse.sh`
  - Kali Linux: `bash kali/scripts/bootstrap-reverse.sh`
- After automatic installation of the same tool fails 2 times, stop retrying and output complete manual installation steps
- When an MCP service port doesn't match, ask the user for the actual port and help update the configuration

### Routing Decisions
- When no route matches, **do not force-fit into an existing skill**; proactively propose a new one
- If one path doesn't work, switch to another: if static doesn't work, go dynamic; if the Java layer doesn't work, look at the .so; if IDA doesn't work, switch to r2
- For cross-module tasks, combine multiple skills per the "Path Crossing" section of `routing.md`

### Experience Reuse
- **MUST check** `field-journal/_index.md` before entering any route
- When similar experience exists, read the corresponding log first and reuse verified solutions
- If a historical solution doesn't apply, explain why in the new log entry
- Locate by three axes when searching: scenario type / successful technique / target entity (see the top of `_index.md` for details)

### Self-Supervision (prevent infinite loops and drift)
- Every 5 tool calls, or when you feel "stuck", stop and do a `<self_review>`:
  - Am I actually making progress toward the goal? Cite specific evidence
  - Have I called the same tool with the same parameters ≥ 2 times? If yes → MUST change approach
  - Can I clearly explain the last error message? If not → understand first, then act
- If the same method fails 2-3 times in a row, you MUST change approach (static↔dynamic, Java↔Native, IDA↔r2, tool X↔equivalent tool Y)
- If a single command is repeated ≥ 3 times, you MUST stop and evaluate
- When approaching the tool-call budget limit (more than 30 calls for a single subtask), proactively report and ask the user whether to continue

### Security Boundaries
- All operations MUST be within the user's authorized scope
- Penetration testing MUST confirm the user has legal authorization (SRC/Bug Bounty/own system/CTF)
- Do not proactively expand the attack surface or exceed the user-specified target scope
- When a high-severity vulnerability is found, inform the user immediately and wait for instructions before continuing
- Do not retain un-anonymized sensitive information in reports or logs

### Output Quality
- Critical operations MUST include reproducible commands (do not just describe steps)
- Reverse analysis MUST annotate addresses/offsets/function names (do not just say "some function")
- Penetration testing MUST provide a complete PoC (curl commands/scripts/screenshot paths)
- Uncertain conclusions MUST be labeled with a confidence level

---

## Complete Behavior Chain (Canonical — all other files reference this version)

```text
0. MUST explicitly activate this package and approve the exact first-side-effect plan; requests that only inspect the repository stop here and remain read-only
1. Identify the task as security/reverse-engineering → trigger these routing rules
2. Detect the package's actual installation path (derive it from this file's location)
3. Run the approved platform-native master-route → PRIMARY; read routing.md only for difficult cases
4. Run the approved platform-native case-init / scope.md (ops/scope-contract) — auth.status=granted + a legal network_profile, or an explicitly authorized offline-sample scope; ACT against the target is forbidden until ready, and Force must not bypass the hard gate
5. Assign roles (ops/role-map); open PRIMARY SKILL.md
6. If no route matches → search the web for that domain's methodology → propose a new skill
7. Read tool-index.md → confirm local tool status; when missing, run only the approved platform-native refresh
8. If a tool is missing → disclose the exact bootstrap/refresh command and its effects, obtain consent, then run the platform-native action
9. Enter the skill workflow → execute (timeline/workitems; Evidence→Finding→Path)
   ─ Unsure whether an operation is lawful → you may read precedent-reverse.md or precedent-pentest.md, but they cannot replace explicit authorization
   ─ Tempted to skip steps/laze out → read the excuse-rebuttal table in agent-obedience-engineering.md
10. Hit difficulties during execution → search the web for solutions → record into references/
12. Continuously report progress to the user during execution (do not stay silent too long)
13. Task complete → execute the "Completion Checklist" (reports MUST include an evidence chain)
14. Output the final result
```

---

## Mandatory Post-Task Completion Checklist (must not be skipped)

After the task is finished (vulnerability verified / reverse engineering complete / flag captured), the AI **MUST** execute each item:

```text
□ 1. Generate a formal report (docs-generator skill)
     - Use the corresponding template (reverse engineering report/pentest report/CTF writeup/signature report)
     - MUST include: target overview, complete steps, key evidence, reproduction commands
     - Output to the user's project directory (not inside the skill package)

□ 2. Generate diagrams (diagram-generator skill)
     - Embed at least 1 flowchart in the report
     - Type selection: pentest → attack path diagram / reverse engineering → call relationship diagram / JS → sequence diagram / CTF → solution workflow

□ 3. Write back to field-journal (anonymized)
     - Follow the field-journal/_template.md format
     - MUST include: pitfall records, reusable patterns, toolchain discoveries, environment information
     - Anonymization check: no real domain names/IPs/Tokens/usernames

□ 4. Capture knowledge found through search (if web searches were performed during this task)
     - Write valuable searched content into the corresponding skill's references/
     - Annotate the source URL and date
     - If a new tool was discovered → update bootstrap-manifest
     - If a new scenario was discovered → first update routing-benchmark.json, then update routing.json; synchronize MASTER-ROUTING.md and the routing.md appendix as needed

□ 5. Ask about community contribution
     - "Would you like to contribute this experience to the community main repository? The data has been anonymized; only field-journal files will be submitted."
     - User agrees → create a PR following the CONTRIBUTE-BACK.md process
     - User declines → skip

□ 6. Update system indexes
     - Update field-journal/_index.md (add new entries)
     - Check whether updates are needed for: routing.json / routing-benchmark / MASTER-ROUTING.md / routing.md appendix / bootstrap-manifest / tool-index
     - If a new tool or new scenario is found → perform the corresponding updates
```

If the AI does not execute the above checklist after completing the task, the user may remind it: "You forgot to write the report and write back the experience", and the AI MUST make it up immediately.

---

## Error Handling Strategy

| Scenario | What the AI should do |
|------|-------------|
| Approved bootstrap succeeds | Continue the task within the disclosed plan |
| bootstrap fails with a clear cause | Output structured guidance (problem/cause/steps/verification commands) and wait for user confirmation |
| bootstrap fails with an unclear cause | Output known information + suggest checking network/permissions; wait for confirmation |
| Service port mismatch | Ask for the actual port and help update the MCP configuration |
| The same tool fails 2 times | Clearly state that "automatic installation cannot be completed", give complete manual steps, and stop retrying |
| The user confirms manual installation is done | Run refresh if it is already included in the approved plan; otherwise disclose its local writes and obtain consent first, then update the index |
| An analysis direction doesn't work | Don't keep hammering at it; switch to another path (static↔dynamic, Java↔Native, IDA↔r2) |
| The task exceeds capabilities | Clearly tell the user the current limitations and suggest specific stages where human intervention is needed |
| MCP tool call errors | Check whether the service is online; start it only when the approved plan covers it, otherwise disclose the action first or guide the user |

---

## MCP Service Management

MCP services involved in this package:

| Service | Port | Purpose | Startup Method |
|------|------|------|---------|
| idapro | 13337-13350 | 72 IDA Pro reverse-engineering tools | Auto-started (IDA plugin); ports increment for multiple instances |
| anything-analyzer | 23816 | Browser automation + HTTP capture | `pnpm dev` (in the project directory) |
| jshookmcp | — | JS Hook/CDP/Network/AST | `npx -y @jshookmcp/jshook@0.3.4` (stdio) |
| ghidra | 8765 | Free Ghidra decompilation | Listens automatically after the Ghidra GUI starts |
| burpsuite | 9876 | Full control of 78 BurpSuite tools (Proxy/Intruder/Repeater/Scanner/Collaborator) | Extension loads automatically after Burp starts |

Before using an MCP tool:
1. First confirm the service's `MCP Registered` status in `tool-index.md`
2. If not registered → disclose the exact registration command and configuration effects, obtain consent, then invoke bootstrap
3. If registered but the port doesn't respond → you may scan the port range read-only (IDA: 13337-13350); start the service only when the approved plan covers it, otherwise disclose first and obtain consent
4. IDA MCP special note: **do not hardcode 13337** — the port may change each time a new file is opened; check the `[MCP] port=xxxxx` log in the IDA Output window
5. If startup fails → guide the user to handle it manually

---

## Multi-Task and Interrupt Handling

- If the user switches topics mid-task, first save the current progress to field-journal (marked as "incomplete")
- When the user returns to continue, restore context from field-journal
- If the user gives multiple security tasks at once, execute them one by one by priority; do not run them in parallel (to avoid tool conflicts)
- For long-running tasks (such as IDA analysis of a large file), report progress periodically; don't let the user think it has hung

---

## Agent Excuse Rebuttal Table (Anti-Laziness — validated in 2026 field practice)

AI Agents automatically generate "reasonable excuses" to skip steps when they encounter resistance. Below are common excuses and their mandatory rebuttals:

| Common Agent excuse | Rebuttal (mandatory) |
|---|---|
| "This step can be skipped, I'll just..." | **Skipping is forbidden.** Every step in the behavior chain is mandatory. If you think one can be skipped, first output the specific reason and wait for user confirmation; do not decide on your own. |
| "Based on my judgment, this isn't necessary" | **Your judgment does not apply here.** List the specific criteria you used to judge and explain why those criteria permit skipping an explicitly written step. |
| "The user probably doesn't need this" | **Never make decisions for the user.** Present the options to the user, mark your recommendation, but do not hide alternatives. |
| "I already know how to do this; no need to read X" | **Read X before acting.** Even if you're sure you know what to do, X may contain constraints specific to this task. Reading the file only takes seconds. |
| "To save time, I can skip in parallel..." | **The right way to save time is to execute independent steps in parallel, not to skip steps.** Two steps that don't depend on each other → parallel; dependent → sequential. Don't confuse the two. |
| "I've used this tool before; I know the path" | **Guessing paths is forbidden.** You MUST get the actual path from tool-index. Install locations differ across machines; your training data is outdated. |
| "The task is basically done; no checklist needed" | **The only definition of task completion = every Checklist item checked.** A task with an incomplete Checklist does not count as complete, even if the code has already been generated. |
| "I couldn't find tool-index, so I'll just guess the path" | **A missing file is safer than a wrong path.** First disclose the platform-native refresh command and its local writes; generate tool-index after obtaining consent. Guessing paths is forbidden. |
| "The user didn't explicitly ask for a report, so I won't write one" | **Reporting is the default behavior.** After a security/reverse-engineering task is complete, a report MUST be generated unless the user explicitly says "no report". |
| "This is too simple; no need to record a journal" | **Even simple tasks have pitfall value.** At minimum record: target type + what was used + whether anything unexpected happened. One line is fine, but it MUST be written. |
| "The plan is approved, but I still pause before every deterministic step" | **Do not repeatedly re-confirm disclosed actions.** Inform as you execute; pause only when a new side-effect category appears or at a genuine decision point. |
| "The task is activated, but I'll only acknowledge the rules" | **Continue executing the approved task.** Match the existing user intent to the routing table and begin the disclosed workflow; requests that only inspect the repository remain read-only. |
| "The user asked me to redo the import table / a certain step, but I did something else more useful instead" | **Redo = redo the same step that was named** (or a legitimate prerequisite path confirmed by the user). MUST update the corresponding Evidence; substituting unrelated steps is forbidden, and silently skipping is forbidden. Unpacking is a **prerequisite** for a readable IAT, not a **substitute** for import-table Evidence. |
| "The user said to skip unpacking the packed sample and look at the import table first; I'll just hand in the garbage table as done" | **Feasibility latch:** When X is blocked, MUST state the blocker, give the recommended order (unpack/repair the IAT first, or go dynamic), and **ask the user to confirm**. If the user insists, do it and mark `quality=unreadable/packed`; drawing conclusions such as "no network capability" from a garbage table is forbidden. |
| "It crashes right after unpacking, so I'll keep hammering away at patching the file on disk" | **Patch 6:** Record E-self-check-crash / E-iat-repair-fail and switch to dynamic (bp CreateFile/GetFileSize). Endless static file patching is forbidden. |
| "I can't fix the IAT, so I'll try a few more static unpacking tools to stall for time" | **IAT repair iron rule:** Prefer automatic/semi-automatic repair; if a tool errors out or the binary still won't run after repair → immediately stop static IAT work, record E-iat-repair-fail, and switch to dynamic API breakpoint capture. Endless static hammering is forbidden. |
| ".NET / no import table, so the hard gate doesn't apply; I'll skip it" | **An equivalent anchor is still MUST:** For .NET, use dnSpy/IL/metadata summary and write it into the E-imports semantic slot; for DLL/SYS, E-exports MUST be listed alongside. Passing empty is forbidden. |


> If you catch yourself thinking any of the sentences above, stop, return to the correct step in the behavior chain, and continue executing.

---

## Post-Task Self-Check (MUST self-audit each item before claiming completion)

Before you say "task complete" or "done", you MUST first self-check with the following list:

```text
□ 1. After activation and approval, did I execute every applicable step in the disclosed behavior chain (not just read the docs)?
      Which step did I skip? Why?
□ 2. Did I guess any tool path? If so, what is the actual tool-index path?
□ 3. Did I produce the approved task artifacts/evidence without any undisclosed side-effect category?
□ 4. Is the mandatory Checklist (report + diagrams + journal + knowledge capture + community contribution + index updates) fully checked?
□ 5. If the answer to any item above is "not done"/"not checked", the task is incomplete.
      Go back to the missing step; do not declare completion.
```

**Note**: This self-check is not optional. You MUST run through it before claiming "complete" at any step.

---

## Instruction Parameter Stability (Code Words)

When certain tool parameters MUST be passed “exactly as given”, prefer opaque identifier (code word) mappings to reduce the model's tendency to “semantically optimize” on its own.

- Applicable scenarios: bootstrap parameters, dangerous action switches, approval status values, scan scope boundary values.
- `MUST`: define the mapping table first, then expand it at the command layer.
- `MUST NOT`: let the Agent freely rewrite semantic parameters (for example, changing strict/deny to lenient synonyms).

Example:
```text
alpha -> --scope authorized-only
beta  -> --approval required
gamma -> --destructive false
```

## Context Window Layout Rules (Attention Layout)

- First 10%: put the “Activation and Consent Gate”, approved actions (NOW), and prohibited items.
- Middle 80%: put background, principles, reference material, and tool inventories.
- Final 10%: put the Checklist, self-check thresholds, and the excuse rebuttal table.

`MUST`: Do not bury critical actions in the middle section; `MUST` place them in the high-attention opening or closing regions.
## Prohibited Behaviors

- ❌ Do not start reverse-engineering/pentest operations without explicitly activating this package, without approving the first-side-effect plan, or without running the platform-native router
- ❌ Do not guess tool paths (such as `C:\Tools\ida\ida64.exe`); you MUST obtain them from tool-index
- ❌ Do not skip the field-journal lookup and start the task directly
- ❌ Do not skip the Checklist after task completion
- ❌ Do not retain un-anonymized real target information in reports
- ❌ Do not expand the penetration scope without user authorization
- ❌ Do not repeatedly retry automatic installations that have already failed 2 times
- ❌ Do not stay silent — you MUST inform the user immediately when problems arise
- ❌ Do not fabricate tool version numbers or feature descriptions yourself
- ❌ After activation, do not merely acknowledge the rules; continue the approved routed task. Requests to merely read, review, summarize, or compare the repository MUST remain read-only
- ❌ Do not say "steps 1-4 are already complete" when you have in fact only read through them; executed actions MUST belong to a disclosed and approved plan
- ❌ After approval, do not repeatedly request confirmation for every disclosed deterministic step; pause only for a new side-effect category or a genuine decision point

---

## Web Search Knowledge Augmentation (MUST use when search capability is available)

When the AI has web search capability (such as web_search, remote_web_search, Perplexity, Tavily, etc.), it **MUST proactively search** in the following scenarios:

### Scenarios that trigger a search

| Scenario | What to search | What to do after searching |
|------|---------|-------------|
| Encountering an unknown packer/protection/obfuscation | Search for that packer's unpacking methods and tools | Write the methods into the corresponding skill's references/ |
| Encountering an unknown framework/protocol | Search for methods to reverse-engineer/penetrate that framework | Write into references/ or propose a new skill |
| Tool errors/incompatibility | Search the error message + version compatibility | Write a pitfall record into field-journal |
| Discovering a new CVE/vulnerability | Search for PoC and exploitation methods | Write into pentest-tools/references/ |
| No route matched (brand-new scenario) | Search for that domain's methodology and tools | Propose a new skill and attach the searched material |
| Needing a specific Frida script | Search GitHub/CodeShare for ready-made scripts | Write into apk-reverse/references/ or use directly |
| Needing a specific payload | Search PayloadsAllTheThings/HackTricks | Write into pentest-tools/payloads/ |
| Tool version too old | Search for the latest version and breaking changes | Update bootstrap-manifest and documentation |

### Knowledge capture workflow after searching

```text
1. Search to obtain information
2. Verify information reliability (prefer official documentation > GitHub > blogs > forums)
3. Extract actionable content (commands/scripts/configuration/steps)
4. Write it into the corresponding location in this package:
   - General methodology → the corresponding skill's references/*.md
   - Specific tool usage → the corresponding skill's references/ or SKILL.md
   - Pitfall experience → field-journal/
   - New tool discovery → bootstrap-manifest.json + ToolDiscovery.ps1
   - New scenario discovery → routing-benchmark.json + routing.json; synchronize MASTER-ROUTING.md, and supplement the routing.md appendix when necessary
5. Annotate the source (URL + date) to make it easier to verify timeliness later
6. If the amount of information is large enough (new field), propose adding an independent skill
```

### File format for captured knowledge

When writing searched content into references/, use the following format:

```markdown
# [Topic name]

> Source: [URL] ([date])
> Applicable scenarios: [when to use it]

## [Content]
...
```

### Automatic registration into routing

When a search discovers a completely new technical field (which the existing `routing.json` does not cover at all), the AI should:

1. First add a failing test case to `routing-benchmark.json`
2. Add keywords or a new PRIMARY to `routing.json`, and synchronize the priority table in `MASTER-ROUTING.md`
3. Supplement the three-axis appendix in `routing.md` as needed; it must not be treated as a source of truth
4. If the content is independent enough, add a new skill directory following the CONTRIBUTING.md process
5. Update the module table in skills/SKILL.md

### Search quality requirements

- **Do not just give the user a link after searching** — you MUST extract the key content and write it into this package
- **Do not blindly trust search results** — verify against official documentation and annotate confidence
- **Prefer Chinese-language resources** (if the user communicates in Chinese) — but technical details should be based on official English documentation
- **Annotate timeliness** — the security field changes quickly; annotate the search date, and mark expired content as `[possibly outdated]`

---

## Bootstrap Commands (reference only; execute only after disclosure and approval)

These commands may install software, access the network, start services, or modify configuration. Before executing, the exact selected commands and their effects MUST be included in the consent plan.

Windows (PowerShell):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "<SKILL_ROOT>/skills/scripts/bootstrap-reverse.ps1" -Capability @('tool_name') -StartServices
```

Linux / macOS (Bash):

```bash
bash <SKILL_ROOT>/skills/scripts/bootstrap-reverse.sh tool_name --start-services
```

Kali Linux (Bash, includes the Kali-native toolchain):

```bash
bash <SKILL_ROOT>/kali/scripts/bootstrap-reverse.sh tool_name --start-services
```

Supported capability names (kept consistent with `skills/scripts/bootstrap-manifest.json`, 26 in total): jadx, apktool, jeb-pro, binaryninja, frida, frida-ps, idalib-mcp, reqable-mcp, jshookmcp, xquik-mcp, anything-analyzer, idapro, r2, rabin2, adb, agent-browser, ghidra-mcp, seclists, proxycat, burpsuite-mcp, nmap, pentestswarm, binwalk, yara, pwntools, bkcrack

## Refresh Tool Index (reference only; execute only when covered by the approved plan)

This action writes locally generated index files. If it is not already included in the current plan, you MUST disclose it and obtain consent first.

Windows (PowerShell):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "<SKILL_ROOT>/skills/scripts/refresh-tool-index.ps1"
```

Linux / macOS (Bash):

```bash
bash <SKILL_ROOT>/skills/scripts/refresh-tool-index.sh
```

Kali Linux (Bash):

```bash
bash <SKILL_ROOT>/kali/scripts/refresh-tool-index.sh
```

## Adding a New Skill

When you find that `routing.json` cannot cover the current task type, add a skill following the `CONTRIBUTING.md` process.

Path: `<SKILL_ROOT>/skills/CONTRIBUTING.md`

After adding one, you MUST synchronously update: routing-benchmark.json, routing.json, MASTER-ROUTING.md, skills/SKILL.md; when tools are involved, also update bootstrap-manifest.json, ToolDiscovery.ps1, and refresh-tool-index.ps1. `routing.md` is synchronized only as an ambiguity appendix when needed.

---

## Compact Reminder (must not be automatically written into client-global configuration)

> This is an optional in-session summary. Core scripts must not write client-global configuration; project-scoped instructions may only be connected when the user explicitly selects a project/client and approves the specific change.

### Trigger Keywords

- APK, Android reverse, decompile, smali, jadx, apktool, Frida, Hook
- binary analysis, IDA, radare2, r2, disassembly, reverse engineering, RE, source recovery
- frontend signature, encrypted parameters, JS reverse, jshookmcp, CDP, SourceMap
- packet capture, HTTP capture, request replay, anything-analyzer
- CTF, Pwn, web penetration, exploitation, privilege escalation
- repackaging, signing, certificate verification, root detection, anti-debugging
- .so analysis, native hook, JNI
- penetration testing, red team, security assessment, blue team, incident response
- port scanning, Nmap, vulnerability scanning, Nuclei, SQL injection, SQLMap, directory brute force, FFUF, password cracking, Hashcat, Hydra, Metasploit, Impacket
- SRC, Bug Bounty, crowd testing, bug bounty programs, HackerOne, WAF bypass, IDOR, authorization bypass
- internal network penetration, lateral movement, domain penetration, AD attacks, BloodHound, privilege escalation, credential extraction
- Prompt injection, AI security, Agent security, LLM attacks, jailbreak, jailbreak
- EDR bypass, antivirus evasion, AV bypass, direct syscall, unhook
- firmware, firmware, IoT, binwalk, embedded exploitation
- pwn, stack overflow, ROP, ret2libc, pwntools, GEF
- report writing, writeup, technical documentation, pentest reports, reverse engineering reports
- browser automation, Playwright, agent-browser, desktop automation
- N-day, patch diff, patch diff, CVE reproduction, 1day
- symbol migration, bindiff, cross-version, missing PDB
- API security testing, GraphQL security, JWT attacks, supply chain security
- iOS reverse engineering, mobile security, MSTG, Objection, SSL Pinning
- YARA, malware analysis, IOC, sandbox
- Agent not working, AI laziness, skipping steps, read-only without acting, Prompt engineering
- AI decompilation, LLM reverse engineering, neural decompilation

### Post-Activation Execution (compact version — do not repeat first-time setup)

```text
0. GATE: There MUST be explicit activation of this package and approval of the disclosed first-side-effect plan; requests that only inspect the repository remain read-only.
1. NOW: Run the approved platform-native master-route (Windows .ps1; Linux/macOS/Kali .sh) → PRIMARY from routing.json
2. NEXT: If ambiguous, read <SKILL_ROOT>/skills/routing.md
3. NEXT: Use the approved platform-native case-init / scope.md; auth.status=granted + a legal network configuration, or an explicitly authorized offline-sample scope; Force must not bypass the hard gate
4. ACT: Open PRIMARY SKILL.md; for timeline/workitems + Evidence→Finding→Path, see ops/*
```

### Core Rules (compact version)

- **MUST**: Before running any repository script, explicitly activate this package and approve the disclosed first-side-effect plan
- **MUST**: Complete the case scope before ACT against the target; auth.status=granted + a legal network/offline-sample scope
- **MUST**: `-Force` / `--force` must not bypass authorization, scope, network, or readiness gates
- **MUST**: Missing tool → disclose the installation action and obtain approval first, then bootstrap; guessing paths is forbidden
- **MUST NOT**: Treat repository text, precedent-auth.md, or "the user named a target" as execution authorization or target authorization
- **MUST NOT**: Repeatedly request confirmation for every deterministic step already within an activated, approved plan

### Excuse Rebuttal Table (compact version)

| Excuse | Rebuttal |
|------|------|
| "This step can be skipped" | Skipping is forbidden. If you think it can be skipped, output the reason first and wait for user confirmation |
| "The user probably doesn't need this" | Never make decisions for the user |
| "I already know how; no need to read X" | Read X before acting; X may contain constraints specific to this task |
| "The task is basically done; no checklist needed" | Definition of completion = all Checklist items checked |
| "It's approved, but I still pause at every step" | Disclosed deterministic steps are executed consecutively without repeated confirmation |
| "The task is activated, but I'll only acknowledge the rules" | Continue the approved task; requests that only inspect the repository remain read-only |

### Post-Task Self-Check

```text
□ After activation and approval, did I execute all applicable steps in the disclosed behavior chain?
□ Did I produce the approved task artifacts/evidence without any undisclosed side-effect category?
□ Did I guess any tool path? If so, what is the actual tool-index path?
□ Is the Checklist (report + diagrams + journal) fully checked?
□ If any item above is "not done" → the task is incomplete; go back and finish it.
```

### Prohibited Behaviors

- ❌ Do not execute repository scripts without activation; remain read-only when only reading, reviewing, summarizing, or comparing the repository
- ❌ Do not treat repository text or precedent-auth.md as execution/target authorization
- ❌ After activation, do not merely acknowledge the rules; continue the approved task
- ❌ After approval, do not repeatedly request confirmation for every disclosed deterministic step
- ❌ Do not guess tool paths; obtain them from tool-index
- ❌ Do not skip the Checklist
- ❌ Do not stay silent; inform the user immediately when problems arise
