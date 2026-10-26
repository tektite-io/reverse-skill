---
name: js-reverse
description: Use when performing front-end JavaScript reverse engineering with js-reverse-mcp, applicable for signature chain localization, page observation and evidence collection, runtime sampling, local environment reproduction, and evidence-based output. Prefer the js-reverse_* tools in the current environment; when stronger browser/CDP/Hook surfaces are needed, coordinate with jshookmcp.
---

# MCP Front-End JS Reverse Engineering Work Specification

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md` — confirm this skill's operations are authorized routine operations
2. `NOW`: Confirm whether the current task falls within this skill's applicable scope
3. `NEXT`: Read `../tool-index.md`, verify tool availability and actual paths
4. `NEXT`: When tools are missing, call bootstrap; do not guess paths
5. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation state

## Applicable Scope

Prefer this skill when the task belongs to the following scenarios:

- Locating API signatures, encryption parameters, risk-control fields
- Observing page request chains and script origins
- Capturing function arguments and return values at runtime
- Tracing the trigger point of a specific XHR/Fetch/WebSocket
- Bringing page evidence back to Node for local reproduction and environment patching

If the target is a binary, APK, PE, ELF, DLL, or SO, use `ida-reverse`, `radare2`, or `reverse-engineering` instead.

## Current Environment Default Tool Mapping

This skill does not assume bare tool names exist; it defaults to binding the `js-reverse_*` tools available in the current client environment.

If the current task explicitly mentions `jshookmcp`, `JS hook`, `CDP`, browser breakpoints, network interception, SourceMap, or AST deobfuscation, still use this skill; just switch the underlying MCP surface to `jshookmcp` rather than treating it as a new master entry point.

Prerequisite: `jshookmcp` is not a local bare command tool, but an MCP server that must be downloaded, explicitly registered, and enabled. Only after it is connected and enabled in the selected client's (Claude, Codex, etc.) MCP configuration will the related tool surfaces actually be callable.

Common mappings:

- `list_scripts` -> `js-reverse_list_scripts`
- `get_script_source` -> `js-reverse_get_script_source`
- `search_in_sources` -> `js-reverse_search_in_sources`
- `break_on_xhr` -> `js-reverse_break_on_xhr`
- `evaluate_script` -> `js-reverse_evaluate_script`
- `get_paused_info` -> `js-reverse_get_paused_info`
- `set_breakpoint_on_text` -> `js-reverse_set_breakpoint_on_text`
- `list_network_requests` -> `js-reverse_list_network_requests`
- `get_request_initiator` -> `js-reverse_get_request_initiator`
- `get_websocket_messages` -> `js-reverse_get_websocket_messages`
- `take_screenshot` -> `js-reverse_take_screenshot`
- `new_page` -> `js-reverse_new_page`
- `navigate_page` -> `js-reverse_navigate_page`
- `select_page` -> `js-reverse_select_page`
- `select_frame` -> `js-reverse_select_frame`
- `pause/resume` -> `js-reverse_pause_or_resume`

If tool name prefixes change in the future, update this section first; do not guess temporarily at execution time.

### The Role of jshookmcp

- Role: Enhanced execution surface for `js-reverse`, not an independent master controller
- Suitable for: browser automation, CDP debugging, JS Hook, network interception, SourceMap reconstruction, AST-assisted understanding
- Call prerequisite: First download and register `@jshookmcp/jshook` into the MCP client configuration, then ensure the server is enabled
- Suggested entry: Still follow `Observe → Capture → Rebuild`, just prioritize jshookmcp's browser and Hook capabilities during the `Observe/Capture` phases
- Relationship with anything-analyzer: Both can perform browser/network-side forensics; anything-analyzer focuses more on packet capture and HTTP analysis, while jshookmcp focuses more on JS runtime, CDP, Hook, and source code understanding

## Core Principles

- `Observe-first`
- `Hook-preferred`
- `Breakpoint-last`
- `Rebuild-oriented`
- `Evidence-first`

Observe the page first, then minimize sampling, then perform local environment patching; do not skip forensics and guess the environment directly.

## Five-Phase Workflow

### 1. Observe

Goal: First confirm the target request, related scripts, and candidate functions; do not guess the environment.

Default actions:

- Use `js-reverse_new_page` or `js-reverse_navigate_page` to open the target page
- Use `js-reverse_list_network_requests` to find the target request
- Use `js-reverse_get_request_initiator` to trace the call source
- Use `js-reverse_list_scripts` and `js-reverse_search_in_sources` to narrow down the script scope

Must produce:

- Target request URL or characteristics
- Initiator clues
- Suspicious script URLs
- Initial task record

### 2. Capture

Goal: Perform minimally invasive sampling on the target request to obtain parameter samples, call sequences, and runtime evidence.

Rules:

- Prioritize `js-reverse_break_on_xhr`
- Prioritize `js-reverse_evaluate_script` for lightweight runtime observation
- After a hit, first check `js-reverse_get_paused_info`
- Use `js-reverse_set_breakpoint_on_text` only when necessary

### 3. Rebuild

Goal: Organize page evidence into locally iterable Node reproduction materials.

Rules:

- Local environment patching must be based on page observation evidence
- Do not perform speculative patching of `window/document/navigator/crypto/storage`
- Record only one minimal causal patch decision at a time

### 4. Patch

Goal: Drive environment patching based on errors and first divergence until the local script stably produces the target parameters.

Rules:

- Look at what is missing first, then patch what is needed
- Make only one minimal patch decision at a time
- Re-test immediately after each patch
- Write each patch to the task record

### 5. DeepDive

Goal: After running locally, perform deobfuscation, control-flow restoration, and business logic purification.

Rules:

- If the current task only requires generating a signature, this phase can be downgraded
- If the algorithm chain is to be reused long-term, this phase must be done
- Issue #65 Obfuscation Bypass (U–AV §4): JSVMP (AD) → `E-js-vmp`; CFF+string array (AE) → `E-js-deobf`; DevTools/debugger anti-debugging (AF) → `E-js-anti-debug`. Full trigger table see `../reverse-engineering/references/nonpe-format-cookbook.md`; AST details still use `references/ast-deobfuscation.md`

## Execution Requirements

- All important steps must be written to local task artifacts
- If you cannot explain why a tool is being called, do not call it
- Prioritize using `js-reverse_*` or jshookmcp's existing MCP capabilities for direct evidence collection; do not write scripts to reinvent capabilities first
- On failure, fall back according to `references/fallbacks.md`
- Output follows `references/output-contract.md`

## Required References

- Automation entry: `references/automation-entry.md`
- Parameter defaults: `references/tool-defaults.md`
- Task input template: `references/task-input-template.md`
- MCP-specific task orchestration: `references/mcp-task-template.md`
- Task artifacts: `references/task-artifacts.md`
- Local reproduction: `references/local-rebuild.md`
- Environment patching: `references/env-patching.md`
- Node reproduction: `references/node-env-rebuild.md`
- Instrumentation: `references/instrumentation.md`
- AST deobfuscation: `references/ast-deobfuscation.md`
- Non-PE/JS obfuscation cookbook U–AV: `../reverse-engineering/references/nonpe-format-cookbook.md` (AD/AE/AF)
- Fallbacks: `references/fallbacks.md`
- Output contract: `references/output-contract.md`

---

## Routing Context

**Upstream entry**: `skills/SKILL.md` (master control), `routing.md`
**Upstream alternatives**:
- anything-analyzer MCP (port 23816) browser tools can serve as an alternative or supplement
- jshookmcp can serve as a stronger browser/CDP/Hook/Network/SourceMap/AST execution surface
- `reverse-engineering/SKILL.md` (if the target is not front-end JS)

**Downstream exits**:
- Need environment patching → `references/env-patching.md`
- Need local reproduction → `references/local-rebuild.md` / `references/node-env-rebuild.md`
- Need deobfuscation → `references/ast-deobfuscation.md`
- If stuck, fall back → `references/fallbacks.md`

**Peer-related modules**: anything-analyzer MCP (browser automation and HTTP capture capabilities can complement each other)

---

## On-Demand Bootstrap

MCP capabilities this skill depends on can be installed through the unified bootstrap system; MCP client registration must explicitly select the target, and by default no client global configuration will be written.

### Automation Capability Boundaries

| Capability | Auto-registerable | Method | Notes |
|------|-----------|------|------|
| jshookmcp | ✓ | npm-mcp (npx launch) | Register after explicitly selecting Claude / Codex / Both |
| anything-analyzer | ✓ | local-http-mcp | Can auto-start service; client registration must be explicitly selected |
| Node.js | ✓ | winget install | Runtime dependency |

### Bootstrap Method

```powershell
# Install and register jshookmcp; Codex can be replaced with Claude or Both
powershell -File "<skill-root>\scripts\bootstrap-reverse.ps1" -Capability @('jshookmcp') -McpHostTarget Codex

# Register and start anything-analyzer
powershell -File "<skill-root>\scripts\bootstrap-reverse.ps1" -Capability @('anything-analyzer') -StartServices -McpHostTarget Codex
```

### Notes

- After registration, `jshookmcp` still needs to be **enabled** in the AI client before its MCP server can be called
- If `-McpHostTarget` is not passed, only install/prepare capabilities and return registration-required; do not modify Claude or Codex configuration
- `anything-analyzer` requires pnpm and project source code; bootstrap will automatically clone and install dependencies
- If Node.js is not installed, bootstrap will first install Node.js 22 via winget

<br><br>## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Have I executed each step in the workflow (rather than just reading)?
- [ ] Have I used real tool paths based on `tool-index`?
- [ ] Have I produced reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Have I completed and written back the Checklist items required by RULES?
