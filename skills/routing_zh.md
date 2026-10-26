# Reverse Engineering Skill Routing Matrix

Route tasks to the most appropriate skill module by target type, user intent, and toolchain. This matrix is enforced by default; it is not an advisory suggestion.

## CRITICAL: Routing Decision Execution Protocol

1. `MUST` complete routing before executing; "do first, patch the routing later" is not allowed.
2. `SHOULD` first read `MASTER-ROUTING.md` or run `scripts/master-route.ps1` to determine PRIMARY; this table is for filling in ambiguous cases.
3. `MUST` output your routing rationale (at least one of target type/intent/toolchain must match).
4. `MUST` complete `case-init` / `scope.md` (`ops/scope-contract.md`) before ACTing on the target: `auth.status=granted` + `network_profile`.
5. `MUST NOT` stuff a task into a mismatched skill because it "looks about right".
6. `MUST` search online to fill in the methodology when routing does not match, and propose a new skill.
7. `MUST NOT` reply only with "please give me a specific task"; first start deterministic steps based on the existing input.
8. Operations contract: `ops/` (evidence chain / roles / timeline / IDENTITY).
## By Target Type

| Target Type | Recommended Entry | Alternative |
|---------|---------|---------|
| APK / Android app | `mobile-reverse/SKILL.md` — Frida/Objection/MobSF cross-platform mobile reverse engineering | `apk-reverse/` — static analysis, jadx decompilation; optional licensed JEB Pro cross-check |
| iOS / IPA app | `mobile-reverse/SKILL.md` — iOS reverse engineering + Frida/Objection | `mobile-reverse/references/ios-reverse-guide.md` — iOS specialty |
| Binary exe/dll/so/elf | `ida-reverse/` — IDA Pro decompilation | `radare2/` — CLI analysis, or `reverse-engineering/tools.md` — GDB/Unicorn |
| JavaScript / Web frontend | `js-reverse/` — 5-phase workflow | anything-analyzer MCP browser tools, or jshookmcp's browser/CDP/Hook capabilities |
| HTTP capture / browser sampling / request replay | anything-analyzer MCP (23816) | Reqable MCP, `js-reverse/`, jshookmcp, or `competition-web-runtime/` |
| Firmware / IoT | `firmware-pentest/` — OWASP FSTM full chain: extraction→emulation→fuzz→exploitation | `reverse-engineering/platforms.md` — static RE only / `reverse-engineering/tools.md` — Ghidra headless |
| Binary Ninja / Binja | `binary-ninja-reverse/` — HLIL/MLIL/LLIL + Python API | explicitly enable the community MCP/local HTTP adapter |
| WASM / Python bytecode / .NET | `reverse-engineering/languages.md` | look up the corresponding chapter by language |
| macOS / iOS | `reverse-engineering/platforms.md` — Mach-O/ObjC/Swift | — |
| Memory dump / PCAP | `reverse-engineering/platforms.md` | `reverse-engineering/patterns*.md` |
| Existing case / evidence handoff review | `case-review/SKILL.md`: Evidence graph and fixity validation | `docs-generator/`: final report |
| Cryptography / encryption algorithms | `reverse-engineering/patterns*.md` — crypto patterns | `js-reverse/` (if frontend encryption) |
| Protocol reverse / custom protocol | `reverse-engineering/platforms.md` — network protocols | `js-reverse/` (if WebSocket/HTTP) |
| Go / Rust binary | `reverse-engineering/languages-compiled.md` + `go-reverse.md` | `ida-reverse/` or `radare2/` |
| **CTF competition full stack** | `../CTF-Sandbox-Orchestrator/ctf-sandbox-orchestrator/SKILL.md` — master control entry | route to 40+ sub-skills by evidence surface |
| **CTF ZIP / PKZIP archive challenge** | `../CTF-Sandbox-Orchestrator/competition-zip-archive/SKILL.md` — legacy ZipCrypto + `bkcrack` known-plaintext attack | prefer over password brute force |
| Web runtime / API | `../CTF-Sandbox-Orchestrator/competition-web-runtime/SKILL.md` | — |
| Cloud / container / K8s | `../CTF-Sandbox-Orchestrator/competition-agent-cloud/SKILL.md` | — |
| Windows / AD / identity | `../CTF-Sandbox-Orchestrator/competition-identity-windows/SKILL.md` | — |
| Forensics / PCAP / steganography | `../CTF-Sandbox-Orchestrator/competition-forensic-timeline/SKILL.md` | — |
| Prompt injection / Agent | `../CTF-Sandbox-Orchestrator/competition-prompt-injection/SKILL.md` | — |
| Mobile (Android/iOS) | `../CTF-Sandbox-Orchestrator/competition-android-hooking/SKILL.md` | — |
| Firmware / malware sample | `../CTF-Sandbox-Orchestrator/competition-firmware-layout/SKILL.md` | — |
| **LLM application / AI Agent** | `llm-security/SKILL.md` — OWASP LLM + ASI Top 10 | `../CTF-Sandbox-Orchestrator/competition-prompt-injection/SKILL.md` — CTF scenarios |
| **REST / GraphQL / WebSocket API** | `api-security/SKILL.md` — 10-phase methodology | `pentest-tools/SKILL.md` — basic web pentesting |
| **Software supply chain / SBOM / SCA** | `supply-chain-security/SKILL.md` — six-layer governance framework | `pentest-tools/SKILL.md` — dependency scanning tools |
| **Malware / virus samples** | `malware-analysis/SKILL.md` — six-stage analysis + YARA/Sigma | `reverse-engineering/SKILL.md` — general RE only / `ida-reverse/` deep analysis |
| **Public-source threat intelligence / OSINT** | `threat-intelligence/SKILL.md` — IOC enrichment and campaign correlation | public X/Twitter posts must be verified by independent sources |

## By User Intent

| User Says | You Can Refer To |
|--------|---------|
| "decompile / take a look with IDA" | `ida-reverse/SKILL.md` — IDA MCP workflow |
| "recover the source / recover to assembly / reverse the code" | `reverse-engineering/SKILL.md` — general RE + `ida-reverse/` or capstone static disassembly |
| "Frida hook it / dynamic injection" | `reverse-engineering/tools-dynamic.md` — Frida chapter |
| "radare2 / r2 analysis" | `radare2/SKILL.md` — CLI workflow |
| "find the frontend signature / encrypted parameters" | `js-reverse/SKILL.md` — Observe→Capture→Rebuild |
| "jshookmcp / JS hook / CDP debugging" | `js-reverse/SKILL.md` — still goes through the same JS/Web reverse engineering chain; before calling, confirm the MCP server is downloaded, registered with the client, and enabled |
| "Reqable / Reqable MCP / packet capture and replay" | `pentest-tools/SKILL.md` — authorized local packet capture and API workflow |
| "JEB / JEB Pro" | `apk-reverse/SKILL.md` — licensed Android / ARM cross-check; confirm the local install first |
| "APK unpacking/repacking/smali modification" | `apk-reverse/SKILL.md` — decode→rebuild-sign-install |
| "bypass anti-debugging/anti-detection" | `reverse-engineering/anti-analysis.md` |
| "what obfuscation/VM is this" | `reverse-engineering/patterns*.md` — look up by pattern |
| "Go/Rust/Swift reverse engineering" | `reverse-engineering/languages-compiled.md` + `reverse-engineering/go-reverse.md` (Go specialty) |
| "kernel driver/Rootkit/LKM" | `reverse-engineering/kernel-driver-reverse.md` — kernel driver reverse engineering |
| "C++ vtable / virtual functions / class recovery" | `reverse-engineering/kernel-driver-reverse.md` — C/C++ pattern recognition |
| "IOCTL/DeviceIoControl" | `reverse-engineering/kernel-driver-reverse.md` — Windows driver analysis |
| "Python bytecode/pyc" | `reverse-engineering/languages.md` — Python chapter |
| "symbolic execution/angr" | `reverse-engineering/tools-dynamic.md` — angr chapter |
| "emulation/Unicorn" | `reverse-engineering/tools.md` — Unicorn chapter |
| "environment patching / Node reproduction" | `js-reverse/references/env-patching.md` |
| "CTF challenge / competition reverse engineering" | `reverse-engineering/patterns-ctf*.md` |
| "CTF ZIP/PKZIP/bkcrack/archive known-plaintext attack" | `../CTF-Sandbox-Orchestrator/competition-zip-archive/SKILL.md` |
| "write a report / write documentation / produce a report" | `docs-generator/` — technical documentation writing |
| "review a case / evidence chain / traceability" | `case-review/SKILL.md`: read-only Evidence graph review |
| "write a writeup" | `docs-generator/` — CTF writeup template |
| "open a webpage / browser automation / fill a form" | `browser-automation/SKILL.md` — Playwright browser operations |
| "crawl pages / screenshots / automated login" | `browser-automation/SKILL.md` — browser automation |
| "Playwright / headless" | `browser-automation/SKILL.md` — browser automation |
| "operate desktop apps / Windows automation" | `browser-automation/SKILL.md` — OpenReverse desktop automation |
| "UIA/CUA / desktop GUI operations" | `browser-automation/SKILL.md` — OpenReverse (UIA/CUA mode) |
| "OpenReverse" | `browser-automation/SKILL.md` — desktop interaction + network observation |
| "symbol migration / cross-version comparison" | `binary-diff/SKILL.md` — LLM batch symbol migration |
| "missing PDB / inferring new-version symbols from old-version ones" | `binary-diff/SKILL.md` — cross-version symbol migration |
| "bindiff / function offset migration" | `binary-diff/SKILL.md` — binary diffing |
| "N-day / patch diff / CVE reproduction / 1day weaponization" | `patch-diff-exploit/SKILL.md` — patch → PoC → hit hosts before the patch |
| "Patch Tuesday/MSRC/Microsoft Update Catalog" | `patch-diff-exploit/references/patch-tuesday-workflow.md` |
| "ghidriff/Diaphora/DeepDiff (offensive side)" | `patch-diff-exploit/references/diff-tools-comparison.md` |
| "pwn / stack overflow / ROP / ret2libc / write an exploit" | `pwn-chain/SKILL.md` — full RE→exploit pipeline |
| "heap exploitation / tcache / fastbin / unsorted bin" | `pwn-chain/references/heap-pwn.md` |
| "kernel pwn / kernel privilege escalation / modprobe_path / commit_creds" | `pwn-chain/references/kernel-pwn.md` |
| "pwntools/GEF/pwndbg/one_gadget/libc-database" | `pwn-chain/SKILL.md` |
| "firmware pentest / router firmware / IoT exploitation" | `firmware-pentest/SKILL.md` — from extraction to hitting real hardware |
| "binwalk/unblob/SquashFS/UBI/JFFS2" | `firmware-pentest/references/extraction-methodology.md` |
| "EMBA / automated firmware auditing / cve-bin-tool" | `firmware-pentest/references/emba-automated-analysis.md` |
| "Firmadyne/FAT/QEMU full-system emulation/AFL++ fuzz" | `firmware-pentest/references/emulation-and-fuzz.md` |
| "EDR bypass / AV bypass / AV evasion / red-team delivery" | `edr-bypass-re/SKILL.md` — reverse the defensive side → targeted bypass |
| "direct syscall/indirect syscall/Hell's Gate/SysWhispers" | `edr-bypass-re/references/unhook-techniques.md` |
| "ETW patch/AMSI patch/telemetry blinding" | `edr-bypass-re/references/telemetry-blinding.md` |
| "ntdll hook/pe-sieve/EDR hook table" | `edr-bypass-re/references/hook-survey.md` |
| "port scanning/Nmap" | `pentest-tools/SKILL.md` — information gathering |
| "vulnerability scanning/Nuclei" | `pentest-tools/SKILL.md` — vulnerability detection |
| "SQL injection/SQLMap" | `pentest-tools/SKILL.md` — web pentesting |
| "directory brute force/FFUF/Gobuster" | `pentest-tools/SKILL.md` — web pentesting |
| "password cracking/Hashcat" | `pentest-tools/SKILL.md` — password cracking |
| "penetration testing / active scanning" | `pentest-tools/SKILL.md` — pentest toolchain |
| "SRC bug hunting / Bug Bounty / crowdtesting" | `pentest-tools/src-hunter/SKILL.md` — 19 playbooks + H1 cases |
| "WAF bypass" | `pentest-tools/src-hunter/references/payloader/` — 263 bypass steps |
| "draw a diagram / flowchart / architecture diagram / attack path diagram" | `diagram-generator/SKILL.md` — diagram generation |
| "sequence diagram / state diagram / ER diagram / data-flow diagram" | `diagram-generator/SKILL.md` — Mermaid/Graphviz/PlantUML |
| "Mermaid/Graphviz/PlantUML" | `diagram-generator/SKILL.md` — diagram generation |
| "malware / virus analysis / sample analysis" | `malware-analysis/SKILL.md` — six-stage analysis + YARA/Sigma/sandbox |
| "Go reverse engineering / Rust reverse engineering / stripped" | `reverse-engineering/languages-compiled.md` + `go-reverse.md` |
| "firmware/IoT/binwalk/ARM" | `firmware-pentest/SKILL.md` — full-chain firmware analysis (consistent with the by-target-type table) |
| "cryptography / encryption and decryption / AES/RSA" | `reverse-engineering/patterns*.md` — cryptographic pattern recognition |
| "protocol reverse engineering / Protobuf / custom protocol" | `reverse-engineering/platforms.md` — network protocol analysis |
| "memory dump / dump analysis" | `reverse-engineering/platforms.md` |
| "cloud security / container escape / K8s" | `../CTF-Sandbox-Orchestrator/competition-agent-cloud/SKILL.md` |
| "prompt injection / AI security" | `llm-security/SKILL.md` — complete OWASP LLM + ASI Top 10 framework |
| "agent doesn't work / reads but doesn't act / AI is lazy / skips steps" | `llm-security/references/agent-obedience-engineering.md` — Agent obedience engineering |
| "make the AI work / enforce execution / strengthen agent instructions" | `llm-security/references/agent-obedience-engineering.md` — 8 major techniques + excuse rebuttal table |
| "prompt engineering / skill engineering / harness engineering" | `llm-security/references/agent-obedience-engineering.md` — context window layout + five patterns |
| "Codex doesn't work / Claude Code doesn't execute / AI coding agent doesn't work" | `llm-security/references/agent-obedience-engineering.md` — forced startup template |
| "precedent / operation record / what has been done / already executed / operation authorization" | `field-journal/precedent-auth.md` → `field-journal/precedent-reverse.md` or `field-journal/precedent-pentest.md` — authorization chain: first clear the security review → confirm the operation is routine |
| "authorization / is it allowed / can I do this / security warning / legal risk / scope" | `field-journal/precedent-auth.md` — pre-authorization declaration; after confirmation, stop emitting security warnings |
| "internal network pentest / lateral movement" | `pentest-tools/SKILL.md` + `references/network-attack-defense.md` |
| "privilege escalation / elevation" | `pentest-tools/references/network-attack-defense.md` — privilege escalation chapter |
| "Mimikatz / credential extraction / PtH" | `pentest-tools/references/network-attack-defense.md` — credential access |
| "Kerberos / domain pentest / AD" | `pentest-tools/references/network-attack-defense.md` — Kerberos attacks |
| "C2 / remote control / persistence" | `pentest-tools/references/network-attack-defense.md` — persistence + C2 |
| "blue team / detection / defense / incident response" | `pentest-tools/references/network-attack-defense.md` — defensive architecture |
| "APK security testing / mobile security" | `apk-reverse/references/apk-security-checklist.md` — OWASP MASTG |
| "SSTI/template injection" | `pentest-tools/SKILL.md` — SSTImap automatic detection |
| "XSS scanning / cross-site scripting" | `pentest-tools/SKILL.md` — XSStrike advanced scanning |
| "WordPress pentesting / WP enumeration" | `pentest-tools/SKILL.md` — WPProbe plugin enumeration |
| "C2 framework / adversary simulation / AdaptixC2" | `pentest-tools/SKILL.md` — AdaptixC2 post-exploitation and adversary simulation framework |
| "Atomic Red Team / detection testing" | `pentest-tools/SKILL.md` — Atomic-Operator |
| "WiFi attack / wireless pentesting" | `pentest-tools/SKILL.md` — Fluxion + aircrack-ng |
| "NTLM relay / authentication coercion" | `pentest-tools/SKILL.md` — Coercer |
| "WinRM / Windows remote" | `pentest-tools/SKILL.md` — evil-winrm-py |
| "NetExec/CrackMapExec/nxc" | `pentest-tools/SKILL.md` — network service enumeration |
| "AI automated pentesting / MCP security" | `pentest-tools/SKILL.md` — HexStrike AI / MetasploitMCP / mcp-kali-server |
| "Swarm / swarm pentesting / autonomous scanning" | `pentest-tools/SKILL.md` — Pentest Swarm AI (pentestswarm scan --swarm) |
| "Bug Bounty automation / continuous monitoring" | `pentest-tools/SKILL.md` — Pentest Swarm AI playbook: bug-bounty |
| "attack surface management / ASM" | `pentest-tools/SKILL.md` — Pentest Swarm AI playbook: external-asm |
| "red team / red-blue exercises / HW" | `attack-chain/SKILL.md` — full attack chain orchestration (information gathering→breach→privilege escalation→lateral movement→persistence) |
| "gaining a foothold / initial breach / boundary breach" | `attack-chain/SKILL.md` — boundary breach phase |
| "close-range pentesting / BadUSB / WiFi phishing" | `attack-chain/SKILL.md` — close-range pentesting section |
| "delivery AV evasion / real-world EDR bypass / shellcode loader" | `attack-chain/SKILL.md` — EDR/AV bypass within the attack chain (real-world delivery phase) |
| "phishing / social engineering / email phishing" | `attack-chain/SKILL.md` — phishing attack section |
| "supply chain attack" | `attack-chain/SKILL.md` — supply chain attack section |
| "trace cleanup / anti-forensics" | `attack-chain/SKILL.md` — trace cleanup section |
| "full penetration test / end-to-end" | `attack-chain/SKILL.md` — full-chain planning |
| "from the external network to the domain controller / internal network" | `attack-chain/SKILL.md` — cross-phase path orchestration |
| "attack surface assessment / attack path planning" | `attack-chain/SKILL.md` — path planning decision tree |
| "got a shell, what next / post-exploitation" | `attack-chain/SKILL.md` — plan next steps from the current foothold |
| "internal network pentest end-to-end" | `attack-chain/SKILL.md` — lateral movement + privilege escalation + domain attacks |
| "msfconsole hangs / orphan processes / MSF invocation conventions" | `pentest-tools/references/msf-protocol.md` — three correct MSF modes + six major mistakes |
| "redaction / placeholders / sharing payloads / redact before writing a writeup" | `field-journal/anonymization.md` — redaction placeholder conventions |
| "Hydra / online brute force / SSH brute force" | `pentest-tools/SKILL.md` — online password brute force |
| "Nikto / web server scanning" | `pentest-tools/SKILL.md` — web vulnerability scanning |
| "Metasploit/msfconsole/exploit" | `pentest-tools/SKILL.md` — exploitation framework |
| "Wireshark / packet capture analysis / PCAP" | `digital-forensics/` or `protocol-reverse/` |
| "protocol reverse engineering / Protobuf / custom protocol" | `protocol-reverse/SKILL.md` |
| "Ghidra / no IDA" | `ghidra-reverse/SKILL.md` |
| "Binary Ninja/Binja/HLIL/MLIL/Binary Ninja MCP" | `binary-ninja-reverse/SKILL.md` |
| "K8s / container escape / cloud security" | `cloud-k8s/SKILL.md` |
| "domain pentest / BloodHound / Certipy / Kerberoast" | `windows-ad/SKILL.md` |
| "forensics / Volatility / memory dump" | `digital-forensics/SKILL.md` |
| "code audit / SAST / Semgrep" | `code-audit/SKILL.md` |
| "OSINT / threat intelligence / public X IOC enrichment" | `threat-intelligence/SKILL.md` — public posts serve only as leads pending verification |
| "threat hunting / blue team / detection engineering" | `threat-hunting/SKILL.md` |
| "game reverse engineering / IL2CPP / Unity" | `reverse-engineering/SKILL.md` + seed-014 |
| "WiFi / wireless pentesting / aircrack" | `wifi-wireless/SKILL.md` |
| "browser extension / Chrome extension / crx" | `browser-extension-reverse/SKILL.md` |
| "industrial control / OT/ICS/SCADA/PLC" | `ot-ics/SKILL.md` |
| "macOS reverse engineering / Mach-O" | `macos-reverse/SKILL.md` |
| "thick client / desktop client" | `thick-client/SKILL.md` |
| "Go reverse engineering / Rust reverse engineering" | `go-rust-reverse/SKILL.md` |
| "UART/JTAG/hardware debugging" | `hardware-security/SKILL.md` |
| "database security / Redis / Mongo" | `database-security/SKILL.md` |
| "phishing email / SPF/DKIM/DMARC" | `email-security/SKILL.md` |
| "SAML/OIDC/SSO federation" | `identity-federation/SKILL.md` |
| "SDR / RF / HackRF" | `radio-sdr/SKILL.md` |
| "BurpSuite / web proxy / interception" | `pentest-tools/SKILL.md` — web proxy |
| "Responder / LLMNR poisoning / NBT-NS" | `pentest-tools/SKILL.md` — internal network poisoning |
| "BloodHound / AD paths / attack graph" | `pentest-tools/SKILL.md` — AD attack path visualization |
| "Certipy / AD CS / certificate attacks" | `pentest-tools/SKILL.md` — AD certificate services attacks |
| "wfuzz / parameter fuzzing / web fuzz" | `pentest-tools/SKILL.md` — web fuzzing |
| "GDB/GEF/debugging/breakpoints" | `reverse-engineering/tools.md` — dynamic debugging |
| "objdump / disassembly / ELF analysis" | `reverse-engineering/SKILL.md` — static analysis |
| "strings / string extraction" | `reverse-engineering/SKILL.md` — quick reconnaissance |
| "ProxyCat / proxy pool / IP rotation" | `pentest-tools/SKILL.md` — proxy management |
| "LLM security / AI security testing / prompt injection testing" | `llm-security/SKILL.md` — complete OWASP LLM + ASI Top 10 framework |
| "LLM jailbreak / jailbreak / system prompt extraction" | `llm-security/references/prompt-injection-methodology.md` — five-level progressive injection |
| "agent security / tool abuse / memory poisoning / goal hijacking" | `llm-security/references/agent-security-testing.md` — seven-phase agent testing |
| "garak/PyRIT/AI red team" | `llm-security/SKILL.md` — LLM security toolchain |
| "API security testing / API pentesting" | `api-security/SKILL.md` — 10-phase API testing methodology |
| "GraphQL security / introspection attacks / batch query bypass" | `api-security/references/rest-graphql-testing.md` — GraphQL specialty |
| "JWT attacks / OAuth bypass / alg:none" | `api-security/references/jwt-oauth-testing.md` — JWT + OAuth testing |
| "BOLA/IDOR/BFLA / object-level authorization bypass" | `api-security/SKILL.md` — Phase 3 authorization testing |
| "supply chain security / SBOM / SCA / dependency scanning" | `supply-chain-security/SKILL.md` — six-layer supply chain governance |
| "CI/CD security / pipeline auditing / build integrity" | `supply-chain-security/references/cicd-pipeline-security.md` — pipeline security |
| "container security / image scanning / Trivy / Cosign" | `supply-chain-security/SKILL.md` — container security chapter |
| "gitleaks / secret scanning / credential leakage" | `supply-chain-security/SKILL.md` — CI/CD pipeline security |
| "iOS reverse engineering / IPA / Objective-C / Swift / Mach-O" | `mobile-reverse/SKILL.md` — iOS reverse engineering + Frida/Objection |
| "Frida/Objection/dynamic instrumentation/SSL Unpinning" | `mobile-reverse/references/frida-objection-deep.md` — in-depth Frida usage |
| "root detection bypass / jailbreak detection bypass / mobile anti-debugging" | `mobile-reverse/references/anti-detection-bypass.md` — multi-layer bypass |
| "mobile security testing / MSTG / OWASP Mobile" | `mobile-reverse/SKILL.md` — OWASP MASTG methodology |
| "YARA rules / Sigma rules / behavioral detection rules" | `malware-analysis/references/yara-sigma-rules.md` — rule authoring methodology |
| "sandbox analysis / CAPE / Joe Sandbox / malware sandbox" | `malware-analysis/references/sandbox-orchestration.md` — sandbox orchestration |
| "anti-analysis / anti-sandbox / anti-debugging / VM detection" | `malware-analysis/references/anti-analysis-techniques.md` — 94 techniques |
| "IOC extraction / threat intelligence / malware analysis" | `malware-analysis/SKILL.md` — six-stage analysis workflow |
| "AI decompilation / LLM reverse engineering / neural decompilation" | `reverse-engineering/references/ai-assisted-re.md` — AI-assisted reverse engineering |

| Tool | Related Module |
|------|---------|
| IDA Pro (idapro_*) | `ida-reverse/` — MCP HTTP server + 72 tools |
| radare2 (r2/rabin2/rasm2) | `radare2/` — CLI + recon.ps1 |
| jadx / apktool | `apk-reverse/` — decode.ps1 / manifest-summary.ps1 |
| Frida | `reverse-engineering/tools-dynamic.md` |
| GDB / rr (general debugging) | `reverse-engineering/tools.md` |
| Ghidra (headless) | `reverse-engineering/tools.md` + Ghidra MCP (free IDA alternative, can be auto-registered via bootstrap) |
| Binary Ninja / binary-ninja-mcp | `binary-ninja-reverse/` — commercial GUI/API + explicitly enabled community MCP loopback bridge |
| Python 3 standard library | `case-review/`: read-only case Evidence graph review |
| angr / Qiling / Unicorn | `reverse-engineering/tools-dynamic.md` |
| BinDiff / Diaphora | `reverse-engineering/tools-advanced.md` |
| anything-analyzer MCP | MCP server on port 23816 (browser + HTTP capture + AI analysis) |
| jshookmcp | `js-reverse/`'s supplementary MCP surface, suited to browser/CDP/Hook/Network/SourceMap/AST scenarios; it must first be downloaded and enabled in the MCP client |
| agent-browser / Playwright | `browser-automation/` — browser automation (open, click, fill forms, crawl, screenshot) |
| OpenReverse (UIA/CUA) | `browser-automation/` — Windows desktop application automation + network observation (mitmproxy) |
| LLM symbol migration / BinDiff alternative | `binary-diff/` — cross-version batch symbol migration (DeepSeek/GPT) |
| BinDiff / Diaphora / ghidriff / DeepDiff (offensive side) | `patch-diff-exploit/` — locate the vulnerability from a patch → weaponize |
| binwalk v3 / unblob / EMBA / Firmadyne / FAT | `firmware-pentest/` — firmware extraction / automated auditing / emulation |
| pwntools / GEF / pwndbg / ROPgadget / Ropper / one_gadget / libc-database | `pwn-chain/` — RE → working exploit |
| SysWhispers3 / Hell's Gate / pe-sieve / API Monitor | `edr-bypass-re/` — EDR bypass research and implementation |
| Nmap / Masscan | `pentest-tools/` — port scanning, service identification |
| Nuclei / ZAP / Nikto | `pentest-tools/` — vulnerability scanning |
| SQLMap / FFUF / Gobuster | `pentest-tools/` — web pentesting (injection/brute force) |
| SSTImap | `pentest-tools/` — SSTI automatic detection and exploitation (Kali 2026.1: `apt install sstimap`) |
| XSStrike | `pentest-tools/` — advanced XSS scanning (Kali 2026.1: `apt install xsstrike`) |
| WPProbe | `pentest-tools/` — WordPress plugin enumeration (Kali 2026.1: `apt install wpprobe`) |
| Hashcat / John / Hydra | `pentest-tools/` — password cracking |
| Metasploit / Impacket | `pentest-tools/` — exploitation framework |
| MetasploitMCP | `pentest-tools/` — Metasploit MCP interface (Kali 2026.1: `apt install metasploitmcp`) |
| mcp-kali-server | `pentest-tools/` — Kali's official MCP; the AI calls terminal tools directly (`apt install mcp-kali-server`) |
| HexStrike AI | `pentest-tools/` — 150+ security tool MCP automation (Kali 2025.4: `apt install hexstrike-ai`) |
| Pentest Swarm AI | `pentest-tools/` — swarm-intelligence autonomous pentest framework; stigmergic blackboard coordinates multiple agents (`go install` or Docker) |
| AdaptixC2 | `pentest-tools/` — post-exploitation and adversary simulation framework (Kali 2026.1: `apt install adaptixc2`) |
| Atomic-Operator | `pentest-tools/` — Atomic Red Team test execution (Kali 2026.1) |
| Coercer | `pentest-tools/` — Windows authentication coercion/NTLM relay (`apt install coercer`) |
| NetExec (nxc) | `pentest-tools/` — network service enumeration and exploitation; CrackMapExec successor (preinstalled on Kali) |
| evil-winrm-py | `pentest-tools/` — Python WinRM remote execution (Kali 2025.4) |
| Fluxion / aircrack-ng | `pentest-tools/` — WiFi security auditing and cracking (aircrack-ng preinstalled on Kali; fluxion added in 2026.1) |
| Responder | `pentest-tools/` — LLMNR/NBT-NS/MDNS poisoning (preinstalled on Kali) |
| BloodHound | `pentest-tools/` — AD attack path visualization (`apt install bloodhound`) |
| Certipy | `pentest-tools/` — AD certificate services attacks (`apt install certipy-ad`) |
| CrackMapExec / NetExec | `pentest-tools/` — network service enumeration (nxc is the CME successor; preinstalled on Kali) |
| wfuzz | `pentest-tools/` — web parameter fuzzing (preinstalled on Kali) |
| Wireshark / tshark | `pentest-tools/` — network protocol analysis and PCAP parsing (preinstalled on Kali) |
| BurpSuite | `pentest-tools/` — web proxy, interception, vulnerability scanning (Community edition preinstalled on Kali) |
| BurpSuite MCP | `pentest-tools/` — 63-tool full AI control (proxy history/Intruder/Repeater/Scanner/Collaborator), see `references/burpsuite-mcp-guide.md` |
| ProxyCat | `pentest-tools/` — proxy pool management and IP rotation |
| objdump / strings / file | `reverse-engineering/` — basic static analysis (preinstalled on Kali) |
| Cobalt Strike / Sliver / Havoc / Mythic | `pentest-tools/` — C2 framework tools (same module as AdaptixC2) |
| Rubber Ducky / WiFi Pineapple / Proxmark3 | `attack-chain/` — close-range pentest hardware |
| pentestMCP (Docker) | `pentest-tools/` — 20+ tools in one MCP |
| Mermaid / Graphviz / PlantUML | `diagram-generator/` — diagram generation (flowchart/sequence diagram/architecture diagram/attack path) |
| garak / PyRIT / promptfoo | `llm-security/` — LLM security testing (100+ injection probes/multi-turn orchestration) |
| Vespasian / Entropy / api.sh | `api-security/` — API discovery and attack scenario generation |
| jwt_tool | `api-security/` — comprehensive JWT testing (alg:none/key confusion/kid injection) |
| FireTail / Escape DAST | `api-security/` — GraphQL specialty + business logic security |
| OSV-Scanner / Trivy / Syft | `supply-chain-security/` — SBOM generation + SCA scanning |
| OWASP Dependency-Track | `supply-chain-security/` — enterprise-grade continuous SCA monitoring |
| Gitleaks / truffleHog | `supply-chain-security/` — secret/credential scanning |
| Cosign / SLSA | `supply-chain-security/` — build signing and provenance |
| Frida / Objection | `mobile-reverse/` — dynamic instrumentation + Frida Gadget injection |
| JADX / apktool / MobSF | `mobile-reverse/` — Android static analysis |
| class-dump / jtool2 / Hopper | `mobile-reverse/` — iOS static analysis |
| CAPE Sandbox / ASD Azul | `malware-analysis/` — sandbox automation orchestration |
| YARA / FLOSS | `malware-analysis/` — pattern matching + string deobfuscation |
| Sigma / Sigma CLI | `malware-analysis/` — SIEM behavioral detection rules |
| pe-sieve / Detect It Easy | `malware-analysis/` — process scanning + packer detection |
| LLM4Decompile / Glaurung | `reverse-engineering/` — AI-assisted decompilation |

When you need to confirm whether a local tool is available, where its path is, or which script calls it, always check `tool-index.md`; do not guess paths on the fly.

---

## Handling When Routing Does Not Match

If the current task cannot be matched in any of the tables above, **do not force-fit it into an existing skill**; handle it as follows:

1. First confirm whether it is an edge case of an existing skill (existing skill coverage can be extended)
2. If it really is a brand-new type, proactively propose a new skill to the user:
   - State the suggested skill name and the scenarios it covers
   - State the required toolchain
   - State the relationship to existing skills
3. After the user confirms, execute the addition per the `CONTRIBUTING.md` process
4. After adding it, update this routing matrix

**The AI does not need to wait for the user to discover the gap. Routing failure itself is the signal to add a new skill.**

## Path Crossing (Cross-Module Scenarios)

Some tasks span multiple modules. The following are common path crossings:

```
APK Reverse Path:
  apk-reverse/scripts/decode.ps1 → Java layer analysis
  ↓ If the core is in .so
  ida-reverse/ or radare2/ → .so analysis
  ↓ If dynamic verification is needed
  apk-reverse/scripts/frida-run.ps1 → Frida Hook

Frontend JS Reverse Path:
  js-reverse/Observe → locate target request
  ↓ Need a stronger browser/CDP/Hook/Network surface
  jshookmcp → runtime page sampling, breakpoints, interception, SourceMap/AST assistance
  ↓ After confirming the entry function
  js-reverse/Rebuild → Node local reproduction
  ↓ Need environment patching
  js-reverse/references/env-patching.md

Binary Reverse Path:
  radare2/scripts/recon.ps1 → quick reconnaissance
  ↓ Deep analysis
  ida-reverse/ → IDA decompilation
  ↓ Dynamic validation
  reverse-engineering/tools-dynamic.md → Frida/GDB

CTF Competition Path (via CTF-Sandbox-Orchestrator):
  ctf-sandbox-orchestrator/SKILL.md → build sandbox model
  ↓ Route by dominant evidence surface
  competition-web-runtime/ or competition-reverse-pwn/ or competition-identity-windows/
  ↓ Return to the master controller when blocked
  ctf-sandbox-orchestrator → re-route

Cookie HMAC key reuse → backend authentication bypass:
  competition-web-runtime/references/cookie-hmac-key-reuse-auth-bypass.md
  ↓ Applicable scenarios
  URL contains an access token, signed cookies, and backend admin_session all share the same key

Firmware Pentest Path:
  firmware-pentest/references/extraction-methodology.md → extract the filesystem
  ↓ Obtain binaries
  firmware-pentest/references/emba-automated-analysis.md → EMBA automated auditing to find known CVEs
  ↓ Known CVEs are not enough / want to find a 0-day
  firmware-pentest/references/emulation-and-fuzz.md → Firmadyne emulation + AFL++ fuzz
  ↓ Crash found
  pwn-chain/references/stack-pwn.md or heap-pwn.md → write an exploit
  ↓ Hit real hardware
  attack-chain/SKILL.md → integrate into the attack chain

N-day Weaponization Path:
  patch-diff-exploit/references/patch-tuesday-workflow.md → obtain pre-patch and post-patch binaries
  ↓ Align symbols
  patch-diff-exploit/references/diff-tools-comparison.md → BinDiff/ghidriff/Diaphora tool selection
  ↓ Locate the change
  patch-diff-exploit/references/root-cause-and-poc.md → LLM-assisted root cause + write a PoC
  ↓ Weaponize
  pwn-chain/SKILL.md (build a stable exploit) + pentest-tools/references/msf-protocol.md (Metasploit modularization)

Red-Team Delivery Path:
  attack-chain/SKILL.md → choose phase
  ↓ Need to bypass EDR
  edr-bypass-re/references/hook-survey.md → identify the target EDR's hooks
  ↓ Choose a bypass technique
  edr-bypass-re/references/unhook-techniques.md → direct syscall / Hell's Gate
  edr-bypass-re/references/telemetry-blinding.md → ETW patch / AMSI patch
  ↓ Local validation
  pe-sieve / API Monitor → confirm the unhook is clean
  ↓ Deliver
  return to attack-chain's post-exploitation phase
```
