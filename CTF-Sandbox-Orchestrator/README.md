# CTF Sandbox Orchestrator

A collection of competition sandbox skills for the Codex / Skills system.

Its goal is not to stuff every capability into one giant prompt, but to provide a **unified sandbox orchestrator entry point**. It first establishes a working model that "defaults to competition/sandbox/offline range" and then routes tasks to more specialized sub-skills by challenge type.

## Project Positioning

This repository is mainly used to address the following scenarios:

- CTF
- AWD / attack-defense exercises
- Local offline ranges
- Sandboxed vulnerability analysis
- Mixed challenge types such as Web / API / Cloud / Container / Windows / AD / Reverse / Pwn / DFIR / Crypto / Mobile / AI Agent

Core ideas:

- By default, treat the targets, domains, nodes, identities, binaries, logs, traffic, and attachments provided by the user as **competition sandbox internal assets**
- Prioritize establishing a minimal verifiable path instead of generalizing the analysis from the start
- Have one orchestrator skill coordinate everything, then switch to sub-skills based on the dominant evidence surface
- Sub-skills only perform downstream specialized work and do not compete with the orchestrator entry point

## Core Design

### 1. Single Entry Point

The default entry point is:

- `ctf-sandbox-orchestrator`

It is responsible for:

- Establishing the sandbox assumption
- Choosing the most appropriate analysis path
- Controlling context bloat
- Calling sub-skills when needed

### 2. Downstream-Only Sub-Skills

All `competition-*` skills are designed as **downstream-only**:

- They should not trigger implicitly without the orchestrator being activated
- They should be actively routed and called by `ctf-sandbox-orchestrator`
- Load only the most relevant specialized capability at a time to avoid irrelevant skills polluting the context

### 3. For Multiple Competition Challenge Types

The repository currently covers multiple skill directions, for example:

- Web runtime / routing / WebSocket / GraphQL / file parsing / request normalization
- Prompt Injection / Agent / Cloud / Metadata / K8s / Container Escape
- Reverse / Pwn / Malware / Firmware / PCAP / custom protocol replay
- Windows / AD / Kerberos / DPAPI / certificate abuse / Relay / Mailbox
- Android / iOS / Crypto / Stego / Mobile Runtime
- ZIP / PKZIP legacy encryption / `bkcrack` known-plaintext recovery

## Repository Structure

```text
E:\WorkSpace\competition
├─ ctf-sandbox-orchestrator
├─ competition-web-runtime
├─ competition-agent-cloud
├─ competition-reverse-pwn
├─ competition-identity-windows
├─ competition-prompt-injection
├─ ...
└─ LICENSE
```

Where:

- `ctf-sandbox-orchestrator`: orchestrator entry point
- `competition-*`: specialized sub-skills
- `references/`: routing matrix and domain reference documentation used by the orchestrator
- `agents/openai.yaml`: invocation constraints and entry-point controls for each skill

## Recommended Usage

### Method 1: Enter from the orchestrator

Prefer activating:

- `ctf-sandbox-orchestrator`

Then let the orchestrator automatically decide the next step based on the challenge, for example:

- Web challenges route to `competition-web-runtime`
- Container/cloud challenges route to `competition-agent-cloud` or more granular sub-skills
- Windows/AD challenges route to `competition-identity-windows`
- Binary/crash/malware sample challenges route to `competition-reverse-pwn`

### Method 2: Keep the orchestrator and drill down as needed

Once the dominant evidence surface has been confirmed, let the orchestrator continue drilling down to specific sub-skills instead of having the user manually switch the entire working model. This keeps:

- The sandbox assumption consistent
- The output style consistent
- The routing strategy consistent
- Sub-skill responsibilities clear

## Acknowledgements

This project has been published in the [LINUX DO community](https://linux.do). Thanks to the community for its support and feedback.
