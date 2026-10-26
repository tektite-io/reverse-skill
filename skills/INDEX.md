# reverse-skill Skill Navigation Index

> This file is generated automatically by `skills/scripts/extract-summaries.ps1`; **do not edit by hand**.
> To change a summary, edit the `description` frontmatter in the corresponding module's `SKILL.md`, then rerun the script.

## Module Overview

| Module | Summary |
|------|------|
| [api-security](api-security/SKILL.md) | Use for authorized security assessment of REST, GraphQL, WebSocket, or SOAP APIs, including discovery, authentication, authorization, rate-limit, and CI/CD t... |
| [apk-reverse](apk-reverse/SKILL.md) | Use when doing Android APK reverse engineering in a CLI environment. Applies to APK unpacking, Java decompilation, smali patching, repackaging, Frida dynamic hooking, and switching to so/native analysis as needed. Prefer the locally installed jadx, apktool, frida, adb, ida-reverse, radare2. |
| [attack-chain](attack-chain/SKILL.md) | Use for authorized multi-stage attack-path planning and orchestration when a task spans reconnaissance, initial access, privilege escalation, lateral movemen... |
| [binary-diff](binary-diff/SKILL.md) | Cross-version symbol migration and binary diffing. Use when you have old-version symbols/reverse engineering results and need to migrate them quickly to a new version. |
| [binary-ninja-reverse](binary-ninja-reverse/SKILL.md) | Use for authorized binary analysis in Binary Ninja, including HLIL/MLIL/LLIL inspection, strings/imports/exports, cross-references, types, patch review, Pyth... |
| [browser-automation](browser-automation/SKILL.md) | Unified automation entrypoint. Covers browser automation (Playwright) and Windows desktop application automation (OpenReverse). |
| [browser-extension-reverse](browser-extension-reverse/SKILL.md) | Use for authorized reverse engineering of browser extensions (Chrome/Firefox) including manifest analysis, background workers, and extension-based credential... |
| [case-review](case-review/SKILL.md) | Reviews a reverse-skill case package for scope readiness, Evidence to Finding to Path traceability, work item coverage, timeline references, and optional art... |
| [cloud-k8s](cloud-k8s/SKILL.md) | Use for authorized cloud, container, and Kubernetes security assessment including metadata SSRF, IAM misconfig, container escape paths, and cluster RBAC review. |
| [code-audit](code-audit/SKILL.md) | Use for authorized source-code security review and SAST workflows including Semgrep, CodeQL patterns, dangerous API hunting, and fix verification. |
| [ctf-sandbox](ctf-sandbox/SKILL.md) | Thin PRIMARY for CTF / AWD / cyber-range multi-type orchestration. Hands off to the sidecar CTF-Sandbox-Orchestrator. Use when the user says CTF, AWD, cyber range, or competition challenge and ... |
| [database-security](database-security/SKILL.md) | Use for authorized database security assessment covering PostgreSQL/MySQL/MSSQL/Mongo/Redis exposure, authz, UDF/command paths, and misconfiguration review. |
| [diagram-generator](diagram-generator/SKILL.md) | generate, refine, validate, and render diagrams from natural language, notes, code snippets, schemas, tables, or existing diagram source. use for flowcharts,... |
| [digital-forensics](digital-forensics/SKILL.md) | Use for authorized digital forensics including memory dumps, disk timelines, PCAP investigation, artifact triage, and IR evidence preservation. |
| [docs-generator](docs-generator/SKILL.md) | Creates task-oriented technical documentation with progressive disclosure. Use when writing READMEs, API docs, architecture docs, or markdown documentation. |
| [dotnet-reverse](dotnet-reverse/SKILL.md) | .NET / C# binary reverse engineering. Use when the target is a .NET assembly (PE header containing CLR, .exe/.dll managed programs), C# build output (including NativeAOT), red-team Sharp* tools (Rubeus / SharpHound / SharpHound, etc.), or .NET obfuscated programs (ConfuserEx / Sma... |
| [edr-bypass-re](edr-bypass-re/SKILL.md) | Reverse engineer the defensive implementation → targeted red-team bypass. First reverse engineer the EDR / Defender / AV hook table, ETW providers, and AMSI implementation, |
| [email-security](email-security/SKILL.md) | Use for authorized email security review including phishing analysis, header authentication (SPF/DKIM/DMARC), BEC patterns, and mailbox token abuse research. |
| [firmware-pentest](firmware-pentest/SKILL.md) | Firmware / IoT pentest chain. Starting from a lump of .bin / .img, complete the closed loop of reverse engineering → extraction → emulation → exploitation. |
| [ghidra-reverse](ghidra-reverse/SKILL.md) | Use for free/open reverse engineering with Ghidra (headless or GUI), including decompile, cross-refs, and optional Ghidra MCP workflows when IDA is unavailable. |
| [go-rust-reverse](go-rust-reverse/SKILL.md) | Use for reverse engineering stripped Go and Rust binaries including runtime recognition, pclntab/moduel data recovery, panic strings, and idiomatic decompila... |
| [hardware-security](hardware-security/SKILL.md) | Use for authorized hardware and embedded interface security research including UART/JTAG discovery, debug pad triage, secure boot overview, and offline firmw... |
| [ida-reverse](ida-reverse/SKILL.md) | IDA Pro reverse engineering analysis assistant skill. Always use this skill when the user mentions reverse engineering, decompilation, analyzing binaries/PE/ELF/APK/DLL/SO, cracking, finding passwords, vulnerability analysis, virus analysis, firmware analysis, or needs to analyze exe/dll/so/elf/macho/sys files. |
| [identity-federation](identity-federation/SKILL.md) | Use for authorized assessment of federated identity systems including SAML, OIDC, OAuth2 flows, SSO misconfiguration, and token confusion issues. |
| [js-reverse](js-reverse/SKILL.md) | Use when doing frontend JavaScript reverse engineering with js-reverse-mcp. Applies to locating signature chains, page observation and evidence collection, runtime sampling, local environment-patching reproduction, and evidence-grade output. Prefer the js-reverse_* tools in the current environment, and bring in jshookmcp when you need a stronger browser/CDP/Hook surface. |
| [llm-security](llm-security/SKILL.md) | Use for authorized security assessment of LLM applications and AI agents, including prompt injection, tool abuse, RAG exposure, memory poisoning, and model s... |
| [macos-reverse](macos-reverse/SKILL.md) | Use for authorized macOS and Mach-O reverse engineering including codesign, Objective-C/Swift recovery, endpoint security surfaces, and Apple platform malwar... |
| [malware-analysis](malware-analysis/SKILL.md) | Use when analyzing suspected malware through static, dynamic, and behavioral techniques, including IOC extraction, YARA or Sigma rules, sandboxing, and anti-... |
| [mobile-reverse](mobile-reverse/SKILL.md) | Use for authorized Android or iOS application reverse engineering and security testing, including APK or IPA analysis, runtime instrumentation, SSL pinning, ... |
| [ot-ics](ot-ics/SKILL.md) | Use for authorized OT/ICS security assessment covering Purdue model zoning, PLC/SCADA exposure, industrial protocol discovery, and safe passive-first evaluat... |
| [patch-diff-exploit](patch-diff-exploit/SKILL.md) | N-day patch diff to exploitation. Reverse the vulnerability out of a vendor-released patch, write a PoC, and turn it into a usable attack module. |
| [pentest-tools](pentest-tools/SKILL.md) | Active penetration testing toolchain. Covers information gathering, port scanning, vulnerability scanning, web pentesting, SQL injection, directory brute forcing, password cracking, and more. |
| [src-hunter](pentest-tools/src-hunter/SKILL.md) | Practical SRC / crowdtesting / Bug bounty vulnerability hunting workflow skill. Includes: a 5-phase methodology (intake → recon → enum → hunt → report), 19 attack playbooks (SQLi/XSS/RCE/SSRF/IDOR/CSRF/Path Traversal/File Upl... |
| [protocol-reverse](protocol-reverse/SKILL.md) | Use for authorized reverse engineering of custom binary protocols, Protobuf/gRPC, WebSocket frames, and PCAP-driven protocol recovery. |
| [pwn-chain](pwn-chain/SKILL.md) | Full-chain engineering methodology from reverse engineering to a working exploit. |
| [radare2](radare2/SKILL.md) | Use this skill whenever the user wants to analyze binaries with radare2/r2 from the command line, including reverse engineering, disassembly, function analys... |
| [radio-sdr](radio-sdr/SKILL.md) | Use for authorized RF/SDR security research including signal identification, replay feasibility study in shielded labs, and wireless protocol analysis outsid... |
| [dsl-vm-reverse](reverse-engineering/dsl-vm-reverse/SKILL.md) | Reverse JavaScript-based custom DSL/VM interpreters, non-standard WASM-like runtimes, and risk-control engines. Use when analyzing IIFE or switch-based opcod... |
| [reverse-engineering](reverse-engineering/SKILL.md) | Provides reverse engineering techniques. Use when the main job is to understand how a compiled, obfuscated, packed, or virtualized target works before exploi... |
| [supply-chain-security](supply-chain-security/SKILL.md) | Use for software supply-chain security assessment covering SBOM, SCA, CI/CD pipelines, container images, build integrity, dependency provenance, and vulnerab... |
| [thick-client](thick-client/SKILL.md) | Use for authorized security testing of desktop thick clients including local storage, update channels, IPC, traffic, and client-side trust boundaries. |
| [threat-hunting](threat-hunting/SKILL.md) | Use for blue-team threat hunting, detection engineering with Sigma/YARA, SIEM query design, and incident detection validation. |
| [threat-intelligence](threat-intelligence/SKILL.md) | Use for authorized OSINT and cyber threat intelligence that enriches IOCs, campaigns, impersonation, scams, or threat actors from public sources. Includes bo... |
| [wifi-wireless](wifi-wireless/SKILL.md) | Use for authorized wireless security assessment including Wi-Fi capture, WPA handshake analysis, rogue AP detection research, and lab-only deauth testing. |
| [windows-ad](windows-ad/SKILL.md) | Use for authorized Active Directory and Windows identity attacks including Kerberos, AD CS, BloodHound paths, NTLM relay, and domain privilege escalation res... |

## Directory Tree

```
skills/api-security/SKILL.md/
skills/apk-reverse/SKILL.md/
skills/attack-chain/SKILL.md/
skills/binary-diff/SKILL.md/
skills/binary-ninja-reverse/SKILL.md/
skills/browser-automation/SKILL.md/
skills/browser-extension-reverse/SKILL.md/
skills/case-review/SKILL.md/
skills/cloud-k8s/SKILL.md/
skills/code-audit/SKILL.md/
skills/ctf-sandbox/SKILL.md/
skills/database-security/SKILL.md/
skills/diagram-generator/SKILL.md/
skills/digital-forensics/SKILL.md/
skills/docs-generator/SKILL.md/
skills/dotnet-reverse/SKILL.md/
skills/edr-bypass-re/SKILL.md/
skills/email-security/SKILL.md/
skills/firmware-pentest/SKILL.md/
skills/ghidra-reverse/SKILL.md/
skills/go-rust-reverse/SKILL.md/
skills/hardware-security/SKILL.md/
skills/ida-reverse/SKILL.md/
skills/identity-federation/SKILL.md/
skills/js-reverse/SKILL.md/
skills/llm-security/SKILL.md/
skills/macos-reverse/SKILL.md/
skills/malware-analysis/SKILL.md/
skills/mobile-reverse/SKILL.md/
skills/ot-ics/SKILL.md/
skills/patch-diff-exploit/SKILL.md/
skills/pentest-tools/SKILL.md/
skills/pentest-tools/src-hunter/SKILL.md/
skills/protocol-reverse/SKILL.md/
skills/pwn-chain/SKILL.md/
skills/radare2/SKILL.md/
skills/radio-sdr/SKILL.md/
skills/reverse-engineering/dsl-vm-reverse/SKILL.md/
skills/reverse-engineering/SKILL.md/
skills/supply-chain-security/SKILL.md/
skills/thick-client/SKILL.md/
skills/threat-hunting/SKILL.md/
skills/threat-intelligence/SKILL.md/
skills/wifi-wireless/SKILL.md/
skills/windows-ad/SKILL.md/
```

## Routing

PRIMARY routing is driven by `skills/config/routing.json` (single source of truth); triage with `master-route.ps1 -Hint "<task>"`.
For ambiguous cases read the full matrix in `skills/routing.md`; multi-type CTF tasks go through `CTF-Sandbox-Orchestrator/`.
