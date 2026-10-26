# Automatic Routing Rules for Reverse Engineering / Penetration Testing / Security Tasks (Kali Linux Edition)

> **This file is the Kali path adaptation layer, not a second behavior chain.** Behavior and authorization follow the repository root `RULES.md`.
> The core knowledge base (`skills/config/routing.json`, SKILL.md, references) is shared with the Windows version.
> **Do not** write this file into `~/.claude/CLAUDE.md` or other client-global configurations. Core scripts must not write client-global files.

Hot path (same as `RULES.md`): `skills/scripts/master-route.sh` → `case-init.sh` (ACT against the target is prohibited before `auth.status=granted`) → PRIMARY `SKILL.md`. Identity: `skills/ops/IDENTITY.md`. Scripts use this directory's `kali/scripts/*.sh`.

---

## Trigger Keywords (Fully Consistent with the Windows Version)

- APK, Android reverse engineering, decompilation, smali, jadx, apktool, Frida, Hook
- Binary analysis, IDA, radare2, r2, disassembly, reverse engineering, RE, source recovery, source code recovery, reverse restoration
- Front-end signature, encryption parameters, JS reverse engineering, jshookmcp, CDP, SourceMap
- Packet capture, HTTP capture, request replay, anything-analyzer
- CTF, Pwn, Web penetration, exploit, privilege escalation
- MCP reverse engineering tools, idalib-mcp
- Repackaging, signing, certificate verification, root detection, anti-debugging
- .so analysis, native hook, JNI
- Penetration testing, red team, security assessment, blue team, incident response
- Writing reports, writing documentation, producing reports, writeup, technical documentation, penetration report, reverse engineering report
- Browser automation, opening web pages, form filling, crawling, screenshots, automated login, Playwright, agent-browser, headless
- Symbol migration, bindiff, cross-version, missing PDB, function offset migration, symbol migration, version comparison, old-version symbols
- N-day, Nday, patch diffing, patch diff, patch tuesday, 1day, CVE reproduction, vulnerability restoration, ghidriff, Diaphora, DeepDiff, patch analysis
- pwn, stack overflow, heap overflow, ROP, ret2libc, ret2csu, one_gadget, libc-database, tcache, fastbin, kernel pwn, SMEP, SMAP, KASLR, modprobe_path, commit_creds, pwntools, GEF, pwndbg
- Firmware, IoT, binwalk, unblob, squashfs, UBI, JFFS2, Firmadyne, FAT, QEMU full-system emulation, EMBA, firmware penetration, router firmware, embedded exploit development, AFL++, boofuzz, UART, JTAG
- BurpSuite, Burp MCP, Intruder, Repeater, Collaborator, proxy history analysis
- LLM security, AI security testing, Prompt injection, jailbreak, Agent security, garak, PyRIT
- API security testing, GraphQL security, JWT attacks, supply chain security, SBOM, Trivy
- iOS reverse engineering, Objection, YARA, malware analysis, AI decompilation, LLM4Decompile
- Agent not working, AI laziness, skipping steps, Prompt engineering, Agent compliance
- EDR bypass, AV bypass, evasion, unhook, direct syscall, indirect syscall, Hell's Gate, SysWhispers, ETW patch, AMSI patch, call stack spoofing, MITRE T1562, CrowdStrike bypass, Defender bypass, SentinelOne bypass, pe-sieve
- Port scanning, Nmap, vulnerability scanning, Nuclei, SQL injection, SQLMap, directory brute-forcing, FFUF, password cracking, Hashcat, Hydra, Metasploit, Impacket, pentestMCP
- SRC, Bug Bounty, crowdtesting, bug bounty, HackerOne, WAF bypass, bypass WAF, IDOR, privilege escalation, arbitrary account
- Drawing diagrams, flowchart, architecture diagram, attack path diagram, sequence diagram, state diagram, data flow diagram, Mermaid, Graphviz, PlantUML, diagram
- Malware analysis, virus analysis, sample analysis, sandbox, YARA, IOC
- Kernel driver, Rootkit, LKM, IOCTL, DeviceIoControl
- Cryptography, encryption/decryption, AES, RSA, hash collision, signature verification
- Protocol reverse engineering, custom protocol, Protobuf, serialization
- Firmware reverse engineering, IoT, binwalk, ARM, MIPS, embedded
- WASM, WebAssembly, Python bytecode, pyc, .NET, dnSpy, IL
- macOS, iOS, Mach-O, ObjC, Swift, Frida iOS
- Go reverse engineering, Rust reverse engineering, stripped binary, GoReSym
- Memory dump, forensics, steganography
- Cloud security, container escape, K8s, Docker, AWS, Azure
- Prompt injection, AI security, Agent security, LLM attacks
- Internal network penetration, lateral movement, Pass-the-Hash, domain penetration, AD attacks, BloodHound
- Privilege escalation, SUID, Potato, UAC bypass
- Credential extraction, Mimikatz, Kerberoasting, DCSync, LSASS
- C2, remote control, persistence, backdoor, Cobalt Strike, reverse shell
- Blue team, detection, defense, incident response, SIEM, EDR, threat hunting, IOC
- Mobile security testing, OWASP MASTG, app security, unpacking, hardening analysis
- SSTI, template injection, SSTImap, XSS, XSStrike, cross-site scripting
- WordPress, WPScan, WPProbe, CMS penetration
- AdaptixC2, C2 framework, adversary simulation, red team simulation, Atomic Red Team
- WiFi attacks, wireless penetration, Fluxion, aircrack-ng, deauth
- NTLM relay, Coercer, authentication coercion, PetitPotam
- WinRM, evil-winrm, Windows remote execution
- NetExec, nxc, CrackMapExec, SMB enumeration
- AI automated penetration, HexStrike, MetasploitMCP, mcp-kali-server
- Pentest Swarm, pentestswarm, swarm penetration, Swarm AI, autonomous scanning, stigmergy
- Bug Bounty automation, attack surface management, ASM, continuous monitoring
- GEF, GDB enhancement, debugging framework
- Wireshark, tshark, PCAP analysis, packet capture analysis
- BurpSuite, Web proxy, request interception, Intruder
- Responder, LLMNR poisoning, NBT-NS, MDNS
- BloodHound, AD paths, attack graph, SharpHound
- Certipy, AD CS, certificate attacks, ESC1, ESC8
- wfuzz, parameter fuzzing, Web Fuzz
- objdump, strings, file, static analysis
- ProxyCat, proxy pool, IP rotation
- Red team, HW, attack-defense exercises, foothold, initial access, perimeter breach
- Full penetration, end-to-end penetration, from external network to internal network, from external to domain controller
- Attack surface assessment, attack path planning, attack chain, kill chain
- Next steps after getting a shell, post-exploitation, foothold expansion, deep penetration
- Proximity penetration, BadUSB, Rubber Ducky, WiFi Pineapple, Proxmark3, RFID cloning
- EDR bypass, evasion, AV bypass, Shellcode loader, fileless attack
- Phishing emails, social engineering, OAuth phishing, HTML smuggling
- Supply chain attacks, component poisoning, third-party penetration
- Trace cleanup, anti-forensics, log clearing, timestamp modification
- Cobalt Strike, Sliver, Havoc, Mythic, C2 framework

---

## Routing Entry Point

> **Detection method**: The parent directory of the directory containing this file (`RULES-kali.md`) is the package root directory.

Hot path (same as `RULES.md` / `routing.json`):

1. `skills/scripts/master-route.sh -Hint "<task>"` — PRIMARY
2. `skills/scripts/case-init.sh` — `scope.md`; ACT against the target is prohibited before `auth.status=granted`
3. PRIMARY `SKILL.md` ACTION REQUIRED
4. `skills/tool-index.md` — real paths; if missing, use `kali/scripts/bootstrap-reverse.sh`

---

## Execution Principles (Consistent with the Windows Version, Only Commands Differ)

### Tool Usage
- **Never guess tool paths**; read `tool-index.md` first
- When a tool is missing, call `bootstrap-reverse.sh` to install it automatically
- Kali has many pre-installed tools, so the probability of bootstrap failure is much lower than on Windows
- After automatic installation of the same tool fails twice, stop retrying and output manual steps
- When the MCP service port does not match, ask the user for the actual port and help update the configuration

### Routing Decisions
- When routing does not match, **do not force the task into an existing skill**; proactively propose a new one
- If one approach does not work, try another: if static analysis fails, switch to dynamic; if the Java layer does not work, look at .so; if IDA does not work, switch to r2
- For cross-module tasks, combine multiple skills according to the "path crossing" section in `routing.md`

### Experience Reuse
- **Always check** `field-journal/_index.md` before entering routing
- If similar experience exists, read the corresponding log first and reuse the verified solution
- If the historical solution is not applicable, explain why in the new log

### Security Boundaries
- All operations must be within the user's authorized scope
- Penetration testing must confirm that the user has legal authorization (SRC/Bug Bounty/own system/CTF)
- Do not proactively expand the attack surface or exceed the target scope specified by the user
- Immediately inform the user when a high-risk vulnerability is found, and wait for instructions before continuing
- Do not retain unsanitized sensitive information in reports or logs

### Output Quality
- Key operations must provide reproducible commands (do not just describe steps)
- Reverse engineering analysis must annotate addresses/offsets/function names (do not just say "some function")
- Penetration testing must provide a complete PoC (curl command/script/screenshot path)
- Uncertain conclusions must be annotated with confidence levels

---

## Complete Behavior Chain

```
1. Identify that the task belongs to the security/reverse engineering category
2. Package root = the parent directory of this file
3. master-route.sh → PRIMARY (routing.json)
4. case-init.sh / scope.md — ACT against the target is prohibited before auth.status=granted
5. Open the PRIMARY SKILL.md
6. Missing tool → kali/scripts/bootstrap-reverse.sh
7. Do not write client-global configuration
```

---

## Bootstrap Commands (Kali Edition)

```bash
bash "<this package root>/kali/scripts/bootstrap-reverse.sh" <capability1> [capability2] ... [--start-services]
```

### Common Combinations

```bash
# One-click setup of Kali-native MCP (recommended for first use)
bash kali/scripts/bootstrap-reverse.sh mcp-kali-server metasploitmcp hexstrike-ai

# Install all new 2026.1 tools
bash kali/scripts/bootstrap-reverse.sh adaptixc2 atomic-operator sstimap xsstrike wpprobe fluxion gef

# AD/internal network penetration toolchain
bash kali/scripts/bootstrap-reverse.sh coercer evil-winrm-py netexec responder bloodhound certipy

# Reverse engineering analysis toolchain
bash kali/scripts/bootstrap-reverse.sh jadx frida gef ghidra-mcp

# Web penetration toolchain
bash kali/scripts/bootstrap-reverse.sh sstimap xsstrike wpprobe nuclei
```

All supported capability names: jadx, apktool, frida, idalib-mcp, jshookmcp, xquik-mcp, anything-analyzer, idapro, r2, rabin2, adb, agent-browser, ghidra-mcp, nmap, sqlmap, hashcat, hydra, gobuster, ffuf, msfconsole, nuclei, seclists, proxycat, mcp-kali-server, metasploitmcp, hexstrike-ai, pentestswarm, adaptixc2, atomic-operator, sstimap, xsstrike, wpprobe, fluxion, gef, evil-winrm-py, coercer, netexec, responder, crackmapexec, bloodhound, certipy, wfuzz, aircrack-ng

## Refresh Tool Index

```bash
bash "<this package root>/kali/scripts/refresh-tool-index.sh"
```

---

## MCP Service Management

### Kali-Native MCP (Direct apt Install, No Extra Configuration)

| Service | Package Name | Port | Purpose | Startup Method |
|------|------|------|------|---------|
| mcp-kali-server | mcp-kali-server | 5000 | Kali official MCP, AI directly invokes terminal tools | `kali-server-mcp --port 5000` |
| MetasploitMCP | metasploitmcp | 8085/stdio | Metasploit Framework MCP interface | `metasploitmcp --transport stdio` |
| HexStrike AI | hexstrike-ai | — | 150+ security tool MCP automation platform | `hexstrike-ai` |

### Third-Party MCP Services

| Service | Port | Purpose | Startup Method |
|------|------|------|---------|
| Pentest Swarm AI | stdio | Swarm-intelligence autonomous penetration (recon→classify→exploit→report) | `pentestswarm mcp serve` |
| idapro | 13337-13350 | IDA Pro reverse engineering tool | `bash kali/scripts/ida-start.sh` |
| anything-analyzer | 23816 | Browser automation + HTTP capture | `cd ~/tools/anything-analyzer && pnpm dev` |
| jshookmcp | — | JS Hook/CDP/Network/AST | `npx -y @jshookmcp/jshook@0.3.4` (stdio) |
| ghidra | 8765 | Ghidra free decompilation | Automatically listens after the Ghidra GUI starts |
| burpsuite | 9876 | BurpSuite Web proxy | Started by the BurpSuite extension |

### MCP Priority Recommendations (Kali 2026.1)

For penetration testing scenarios, the recommended MCP usage priority is:

1. **pentestswarm** — Fully automated swarm penetration, suitable for large-scale targets (1000+ subdomains) and continuous Bug Bounty monitoring
2. **mcp-kali-server** — Most general-purpose; can invoke any terminal tool on Kali
3. **metasploitmcp** — Metasploit-specific; exploit/payload/session management
4. **hexstrike-ai** — Automated orchestration, suitable for multi-tool coordination scenarios
5. **jshookmcp** — Web/JS reverse engineering-specific

One-click setup of all penetration MCPs:
```bash
bash kali/scripts/bootstrap-reverse.sh mcp-kali-server metasploitmcp hexstrike-ai pentestswarm
```

---

## Error Handling Strategy

| Scenario | What the AI Should Do |
|------|-------------|
| bootstrap success | Continue the task |
| apt install failure | Check network/sources, run `apt update`, then retry once |
| pip install failure | Try adding `--break-system-packages`, or recommend using venv |
| GitHub download failure | Check network/proxy and provide a manual download link |
| Service port mismatch | Ask for the actual port and help the user update the MCP configuration |
| Same tool fails twice | Provide complete manual steps and stop retrying |

---

## Kali-Specific Advantage Notes

AI should know the following in a Kali 2026.1 environment:

1. **Many pre-installed tools** — nmap/sqlmap/hashcat/hydra/metasploit/gobuster/ffuf/radare2/binwalk/burpsuite/wireshark/nikto/impacket/netexec/responder/bloodhound etc. require no installation
2. **Native MCP support** — the three MCP tools `mcp-kali-server`, `metasploitmcp`, and `hexstrike-ai` are in the official Kali repositories; just `apt install` them
3. **New tools in 2026.1** — AdaptixC2 (C2 framework), Atomic-Operator (red team testing), SSTImap (SSTI detection), XSStrike (XSS scanning), WPProbe (WP enumeration), Fluxion (WiFi social engineering), GEF (GDB enhancement)
4. **New tools in 2025.4** — evil-winrm-py (WinRM remote execution), hexstrike-ai (AI security automation), bpf-linker
5. **Kernel 6.18** — Supports the latest hardware; NetHunter wireless injection patch (QCACLD-3.0)
6. **Full Wayland support** — GNOME 49 + KDE Plasma 6.5; Wayland is also supported in VMs
7. **Rich apt sources** — `apt install ghidra`, `apt install seclists`, `apt install coercer`, etc. in one line
8. **Complete Python environment** — python3/pip3 pre-installed; frida-tools can be installed directly with pip
9. **No permission restrictions** — root by default or passwordless sudo
10. **Complete network tools** — nc/curl/wget/socat/proxychains/chisel etc. pre-installed
11. **SecLists path** — after apt installation, it is in `/usr/share/seclists/`
12. **Wordlists** — common dictionaries such as rockyou are in `/usr/share/wordlists/`
13. **LLM integration** — the official Kali blog has a local LLM integration tutorial for Claude Desktop + Ollama + 5ire
14. **BackTrack mode** — `kali-undercover --backtrack` switches to the classic BackTrack 5 appearance (for social engineering scenarios)

---

## Prohibited Actions (Consistent with the Windows Version)

- ❌ Do not start reverse engineering/penetration operations without reading routing.md first
- ❌ Do not guess tool paths; always obtain them from tool-index
- ❌ Do not skip the field-journal query and start the task directly
- ❌ Do not skip the Checklist after completing the task
- ❌ Do not retain unsanitized real target information in reports
- ❌ Do not expand the penetration scope without user authorization
- ❌ Do not repeatedly retry automatic installation that has already failed twice
- ❌ Do not stay silent — immediately inform the user when problems arise
- ❌ Do not fabricate tool version numbers or feature descriptions

---

## Mandatory Checklist After Task Completion (Cannot Be Skipped)

After the task is complete (vulnerability verified / reverse engineering finished / flag obtained), the AI **must** execute each item:

```text
□ 1. Generate a formal report (docs-generator skill)
     - Use the appropriate template (reverse engineering report/penetration report/CTF writeup/signature report)
     - Must include: target overview, complete steps, key evidence, reproduction commands
     - Output to the user's project directory (not inside the skill package)

□ 2. Generate diagrams (diagram-generator skill)
     - At least one flowchart embedded in the report
     - Type selection: penetration → attack path diagram / reverse engineering → call relationship diagram / JS → sequence diagram / CTF → solution flow

□ 3. Write back to field-journal (sanitized)
     - Follow the field-journal/_template.md format
     - Must include: pitfall records, reusable patterns, toolchain discoveries, environment information
     - Sanitization check: no real domain names/IPs/tokens/usernames

□ 4. Accumulate knowledge found through search (if online searches were performed during this task)
     - Write valuable content found through search into the corresponding skill's references/
     - Annotate the source URL and date
     - If a new tool is discovered → update bootstrap-manifest.json
     - If a new scenario is discovered → update routing.md + RULES-kali.md keywords

□ 5. Ask about community contribution
     - "Would you like to contribute this experience to the community main repository? The data has been sanitized; only field-journal files will be submitted."
     - If the user agrees → create a PR following the CONTRIBUTE-BACK.md process
     - If the user declines → skip

□ 6. Update system indexes
     - Update field-journal/_index.md (new entries)
     - Check whether updates are needed: routing.md / bootstrap-manifest / tool-index
     - If a new tool or scenario is discovered → perform the corresponding updates
```

If the AI does not execute the above checklist after completing the task, the user can remind it: "You forgot to write the report and write back your experience," and the AI must immediately make up for it.

---

## Multi-Task and Interruption Handling

- If the user switches topics during task execution, first save the current progress to field-journal (marked as "incomplete")
- When the user returns to continue, restore context from field-journal
- If the user provides multiple security tasks at once, execute them one by one by priority; do not run them in parallel (to avoid tool conflicts)
- For long-running tasks (such as large-file IDA analysis), report progress periodically so the user does not think it is stuck

---

## Online Knowledge Supplementation (Mandatory When Search Capability Is Available)

When the AI has internet search capability, it **must proactively search in the following scenarios**:

| Scenario | What to Search | What to Do After Searching |
|------|---------|-------------|
| Encountering an unknown packer/protection/obfuscation | Search for unpacking methods and tools for that packer | Write the method into the corresponding skill's references/ |
| Encountering an unknown framework/protocol | Search for methods to reverse engineer/penetrate that framework | Write to references/ or propose a new skill |
| Tool errors/incompatibility | Search for the error message + version compatibility | Write to field-journal pitfall records |
| Discovering a new CVE/vulnerability | Search for PoC and exploitation methods | Write to pentest-tools/references/ |
| Routing does not match (entirely new scenario) | Search for methodology and tools in that domain | Propose a new skill and attach the found materials |
| Need a specific Frida script | Search GitHub/CodeShare for ready-made scripts | Write to apk-reverse/references/ or use directly |
| Need a specific payload | Search PayloadsAllTheThings/HackTricks | Write to pentest-tools/payloads/ |
| Tool version too old | Search for the latest version and breaking changes | Update bootstrap-manifest and documentation |

### Knowledge Accumulation Process After Searching

```text
1. Search to obtain information
2. Verify information reliability (prioritize official documentation > GitHub > blogs > forums)
3. Extract actionable content (commands/scripts/configuration/steps)
4. Write to the corresponding location in this package:
   - General methodology → corresponding skill's references/*.md
   - Specific tool usage → corresponding skill's references/ or SKILL.md
   - Pitfall experience → field-journal/
   - New tool discovery → kali/scripts/bootstrap-manifest.json + tool-discovery.sh
   - New scenario discovery → routing.md + RULES-kali.md keywords
5. Annotate the source (URL + date) to facilitate later verification of timeliness
6. If the amount of information is large enough (new domain), propose a new independent skill
```

### Search Quality Requirements

- **Do not just give the user a link after searching** — you must extract the key content and write it into this package
- **Do not blindly trust search results** — verify against official documentation and annotate confidence
- **Prioritize Chinese resources** (if the user communicates in Chinese) — but technical details should follow official English documentation
- **Annotate timeliness** — the security field changes quickly; annotate the search date and mark outdated content as `[possibly outdated]`

---

## Adding a New Skill

When the routing matrix cannot cover the current task type, add a skill following the `CONTRIBUTING.md` process.

Path: `<this package root>/skills/CONTRIBUTING.md`

After adding, you must synchronously update: routing.md, kali/scripts/bootstrap-manifest.json, kali/scripts/lib/tool-discovery.sh, kali/scripts/refresh-tool-index.sh.
