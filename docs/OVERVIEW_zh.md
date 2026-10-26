# Cybersecurity Skills Router Overview

> A security task routing and tool orchestration system for code agents: first determine the task, then select the skill, and finally call real tools for execution.

If this is your first time seeing this repository, read this document first. `README_AI.md` is the entry point for AI Agents to perform bootstrap.

## What This Project Is

Cybersecurity Skills Router is a **Skill Router + Tool Orchestration** system for code agents such as Claude Code, Codex CLI, Cursor, Cline, Windsurf, etc.

It enables agents to handle complex tasks such as APK, binary, front-end JS, HTTP packet capture, CTF, firmware, and security testing without guessing commands directly, but instead:

1. First complete routing based on target type and user intent;
2. Then enter the methodology and workflow of the corresponding skill;
3. Check local tools, MCP services, and script entry points;
4. Call real tools to execute analysis;
5. Generate a report after the task ends and accumulate reusable experience back into the field journal.

In short:

> This is not a single-tool installation package, but a workflow operating system that enables AI Agents to reliably execute security/reverse-engineering tasks.

## Why It Is Needed

Ordinary code agents easily go out of control in security and reverse-engineering tasks:

- They do not know which analysis chain to follow when encountering APK, ELF, JS, PCAP, or CTF;
- They do not know when to use jadx, apktool, Frida, IDA, radare2, or BurpSuite;
- Tool paths, MCP services, and script entry points are scattered across different machines, making migration difficult;
- They repeatedly fall into the same pitfalls for similar problems, and experience cannot be reused;
- They output large amounts of explanation but do not truly enter tool execution.

The goal of this project is to converge these problems into a clear execution chain:

```text
User task
  ↓
RULES.md
  ↓
Skill Router
  ↓
Target scenario skill
  ↓
Tools / MCP / Scripts
  ↓
Report + field journal
```

## Core Capabilities

| Capability | Description |
|---|---|
| Skill Router | Dispatches tasks to the corresponding skill based on target type, user intent, and toolchain requirements. |
| Tool Orchestration | Integrates execution surfaces such as jadx, apktool, Frida, radare2, IDA, BurpSuite, and browser tools. |
| MCP Integration | Exposes capabilities such as BurpSuite, IDA, and browser analysis to Agents via MCP or local bridging. |
| Bootstrap Scripts | Detect local tool status and provide automated installation or manual remediation paths when necessary. |
| Field Journal | Accumulates completed tasks, pitfalls, commands, and patterns into reusable experience. |
| Report Generation | Generates analysis reports, attack path diagrams, flowcharts, or CTF writeups after task completion. |

## Platform Support

| Platform | Status | Entry point |
|---|---|---|
| Windows | Full mainline | `README.md`, PowerShell scripts |
| Kali Linux | Specialized adaptation | `kali/README-kali.md` |
| Ubuntu / Debian Linux | General adaptation | `platforms/linux.md`, `skills/scripts/bootstrap-reverse.sh`, `skills/scripts/refresh-tool-index.sh` |
| macOS | General adaptation | `platforms/macos.md`, `skills/scripts/bootstrap-reverse.sh`, `skills/scripts/refresh-tool-index.sh` |

See [PLATFORMS.md](PLATFORMS.md) for a platform overview. Regular Linux/macOS users are advised to first check the capability list:

```bash
bash skills/scripts/bootstrap-reverse.sh --list
```

To only refresh the tool index, run:

```bash
bash skills/scripts/refresh-tool-index.sh
```

## Supported Agent Clients

- Claude Code
- Codex CLI
- Cursor
- Cline
- Windsurf
- Kiro
- Other code agents that support project rules, system prompts, MCP, or external tool invocation

This project is not bound to any single client. Its core assets are `RULES.md`, `skills/SKILL.md`, `skills/routing.md`, the tool index, sub-skills, and MCP/script entry points.

## Supported Scenarios

| Scenario | Main entry point |
|---|---|
| APK / Android analysis | `skills/apk-reverse/`, `skills/mobile-reverse/` |
| Binary reverse engineering | `skills/ida-reverse/`, `skills/radare2/`, `skills/reverse-engineering/` |
| JS parameter / front-end signature analysis | `skills/js-reverse/` |
| HTTP packet capture / request replay | BurpSuite MCP, anything-analyzer, browser automation |
| CTF / Security competitions | `CTF-Sandbox-Orchestrator/` |
| Firmware / IoT analysis | `skills/firmware-pentest/` |
| Patch diffing / N-day analysis | `skills/patch-diff-exploit/` |
| Security testing toolchain | `skills/pentest-tools/` |
| LLM / Agent security | `skills/llm-security/` |
| Reports and diagrams | `skills/docs-generator/`, `skills/diagram-generator/` |

## Example Workflow

User input:

```text
Help me analyze the signature verification logic of this APK.
```

Expected Agent behavior:

1. Identify the task type: APK / Android / signature verification;
2. Route to `apk-reverse`, and triage to Frida or native `.so` analysis if necessary;
3. Check whether jadx, apktool, adb, and Frida are available;
4. Unpack the APK, extracting the Manifest, Java-layer logic, and native libraries;
5. Determine whether static analysis is sufficient and generate a dynamic hook plan if necessary;
6. Output the signature verification location, key call chain, bypass approach, and verification steps;
7. Generate a report after task completion and write reusable experience into the field journal.

## Repository Structure

```text
.
├── README.md                    # Main entry point (English)
├── README_zh.md                 # Main entry point (Chinese)
├── README_AI.md                 # AI Agent bootstrap entry point (English)
├── RULES.md                     # Global routing and execution rules
├── docs/OVERVIEW.md              # Detailed overview (English)
├── docs/OVERVIEW_zh.md           # Detailed overview (Chinese)
├── docs/ARCHITECTURE.md          # Architecture description
├── docs/PLATFORMS.md             # Platform support overview
├── skills/                      # Main skill directory
│   ├── SKILL.md                 # Master control entry
│   ├── routing.md               # Routing matrix
│   ├── field-journal/           # Experience accumulation
│   ├── apk-reverse/
│   ├── js-reverse/
│   ├── reverse-engineering/
│   ├── ida-reverse/
│   ├── radare2/
│   └── ...
├── CTF-Sandbox-Orchestrator/    # CTF scenario sub-skill library
├── burp-mcp-full/               # BurpSuite MCP control module
└── kali/                        # Kali environment auxiliary scripts
```

## Quick Start

### Human Users

1. Read this document first to understand the project positioning;
2. Then read `README.md` to have the AI Agent perform bootstrap;
3. Configure MCP, rules, or project-level instructions according to your client;
4. Verify whether routing works using a real task.

### AI Agent

If you are an AI Agent, do not stop at the overview. Proceed to the execution entry point:

1. Read `README_AI.md`;
2. Execute Section 0 within it;
3. Read `RULES.md`;
4. Load `skills/SKILL.md` and `skills/routing.md`;
5. Route first, then execute.

## How It Differs from Ordinary Prompt Packages

Ordinary prompt packages usually just give the model a piece of advice. This project emphasizes executable structure:

- Clear entry points: `RULES.md`, `SKILL.md`, `routing.md`;
- Scenario triage: different targets enter different skills;
- Tool execution surfaces: MCP, scripts, local toolchains;
- Experience write-back: accumulate reusable experience after task completion;
- Migration mechanism: rescan the tool index after switching machines to restore execution capability.

It is not about making the Agent "know more", but about making the Agent "guess less, skip fewer steps, and actually execute".

## Security and Usage Boundaries

This project is intended for security research, reverse engineering, CTF, educational experiments, internal security testing, and defense validation in authorized environments. Please ensure you have legal authorization for the target system.

The security-related rules in the main README are intended to reduce repeated confirmations and process spinning in authorized experimental environments; they do not represent encouragement of unauthorized access, destructive operations, or attacks on real targets.

## Project Positioning

If you need to explain this project to someone, you can summarize it as follows:

> Independently designed and open-sourced a security task Skill Router for code agents, decomposing complex tasks such as reverse engineering, security testing, and CTF into routable, executable, and accumulable workflows, and integrating local toolchains into Agents via MCP and scripts.

Keywords: AI Agent, Skill Router, Tool Orchestration, MCP, Workflow Automation, Security Analysis, Field Journal.

## Related Documents

- [README.md](../README.md): Main entry point (Chinese)
- [README_AI.md](../README_AI.md): AI bootstrap entry point (English)
- [PLATFORMS.md](PLATFORMS.md): Platform support overview
- [platforms/linux.md](platforms/linux.md): General Linux adaptation
- [platforms/macos.md](platforms/macos.md): macOS adaptation
- [RULES.md](../RULES.md): Global execution rules
- [ARCHITECTURE.md](ARCHITECTURE.md): Architecture description
- [skills/routing.md](../skills/routing.md): Routing matrix
- [burp-mcp-full/README.md](../burp-mcp-full/README.md): BurpSuite MCP module

## License

MIT License. See [LICENSE](../LICENSE).
