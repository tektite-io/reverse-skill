---
name: browser-automation
description: |
  Unified automation entry point. Covers browser automation (Playwright) and Windows desktop application automation (OpenReverse).
  Browser scenarios: opening web pages, clicking, filling forms, crawling, screenshots, automated login, penetration page interaction.
  Desktop scenarios: operating GUI tools such as IDA/x64dbg, Windows UI Automation, vision-driven interaction, desktop application network capture.
  Trigger keywords: browser automation, desktop automation, open webpage, fill form, crawl, screenshot, automated login, Playwright, agent-browser, headless, OpenReverse, UIA, CUA, desktop operation, Windows automation.
---

# Automated Operations (Desktop & Browser Automation)

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Confirm whether the current task falls within the scope of this skill
2. `NOW`: Read `../tool-index.md`, verify tool availability and actual paths
3. `NEXT`: Call bootstrap when tools are missing; do not guess paths
4. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation stage

## Scope of Application

Use this skill when the task falls into the following scenarios:

### Browser Scenarios (Playwright / agent-browser)
- Open web pages and operate page elements (click, fill forms, submit)
- Crawl page content or take screenshots
- Automated login flows
- Interact with web pages during penetration testing (submit payloads, trigger XSS)
- Automated handling of CAPTCHA pages
- Batch form submission

### Desktop Application Scenarios (OpenReverse)
- Operate Windows desktop applications (IDA Pro, x64dbg, Wireshark, etc.)
- Require vision-driven interaction (CUA mode)
- Require structured UI operations (UIA mode)
- Observe desktop application network traffic (built-in mitmproxy)
- Automate GUI operations of reverse engineering tools
- Black-box test desktop software

### Division of Labor with Other Tools

| Scenario | What to use |
|------|--------|
| Operate web pages (in browser) | **Playwright / agent-browser** |
| Operate desktop applications (Windows GUI) | **OpenReverse** |
| Packet capture analysis, HTTP request capture | anything-analyzer or OpenReverse network lane |
| JS breakpoints, hooks, CDP debugging | jshookmcp |
| Locate signature algorithms, reimplement environment | js-reverse |

Simple decision:
- Target is a web page → Playwright
- Target is a Windows desktop application → OpenReverse
- Both are needed → Use in combination

---

## Part 1: Browser Automation (Playwright / agent-browser)

### Core Workflow

```bash
# 1. Open page
agent-browser open <url>

# 2. Get interactive elements (returns @e1, @e2... references)
agent-browser snapshot -i

# 3. Operate elements by reference
agent-browser click @e1
agent-browser fill @e2 "text"

# 4. Close when done
agent-browser close
```

### Command Reference

```bash
# Navigation
agent-browser open <url>
agent-browser close

# Page snapshot
agent-browser snapshot        # Full accessibility tree
agent-browser snapshot -i     # Interactive elements only (recommended)

# Interactions
agent-browser click @e1
agent-browser fill @e2 "text"
agent-browser type @e2 "text"
agent-browser press Enter
agent-browser scroll down 500

# Get information
agent-browser get text @e1
agent-browser get title
agent-browser get url

# Wait
agent-browser wait @e1
agent-browser wait 2000
agent-browser wait --load networkidle
```

### Notes
- Must execute `agent-browser close`, otherwise processes leak
- Take a snapshot before operating; do not guess element references
- After submitting a form, use `wait --load networkidle` to wait for page stability

---

## Part 2: Desktop Application Automation (OpenReverse)

### Overview

[OpenReverse](https://github.com/zhexulong/openreverse) is a desktop interaction and evidence collection framework for AI Agents, supporting:
- **UIA mode**: Windows UI Automation, structured desktop control operations
- **CUA mode**: Vision-driven interaction (Computer Use Agent), suitable for complex GUIs
- **Network observation**: Built-in mitmproxy proxy + local capture

### Interaction Mode Selection

| Mode | Suitable Scenario | Underlying Technology |
|------|---------|------|
| UIA | Target application has standard Windows controls (buttons, text boxes, lists) | Windows UI Automation API |
| CUA | Target application has complex or non-standard controls (IDA's disassembly view, custom-rendered interfaces) | Vision recognition + mouse/keyboard |

### Network Observation Modes

| Mode | Suitable Scenario |
|------|---------|
| Proxy Lane | Target application can be configured with a proxy (recommended) |
| Local Lane | Target application cannot use a proxy; local capture is required |

### Installation and Configuration

```bash
# 1. Clone the project
git clone https://github.com/zhexulong/openreverse.git
cd openreverse

# 2. Install dependencies
npm install

# 3. Connect to Agent host (Claude Code / Codex / Zed)
npm run init:agents -- --target=all /path/to/project

# 4. Install CUA runtime (if vision-driven mode is needed)
npm run install:cua-runtime
npm run doctor:cua-runtime

# 5. Install network observation dependencies (if packet capture is needed)
npm run install:mitmproxy
npm run doctor:network
```

### Common Combinations

| Need | Configuration |
|------|------|
| Operate desktop applications only | UIA or CUA, no network lane |
| Operate desktop applications + packet capture | UIA/CUA + proxy lane |
| Operate desktop applications + local capture | UIA/CUA + local lane |

### Reverse Engineering Scenario Examples

```text
Scenario: Automate IDA Pro for batch analysis

1. Open IDA Pro using OpenReverse CUA mode
2. Automatically load the target binary
3. Wait for analysis to complete
4. Export the function list via UI operations
5. Simultaneously use the network lane to observe IDA's network behavior (e.g., Lumina requests)
```

```text
Scenario: Automate x64dbg debugging

1. Start x64dbg using OpenReverse UIA mode
2. Load the target program
3. Set breakpoints
4. Run and observe register/memory changes
5. Take screenshots to preserve evidence
```

---

## On-Demand Bootstrap

### Automation Capability Boundaries

| Tool | Auto-installable | Installation Method | Notes |
|------|-----------|---------|------|
| Playwright | ✓ | npm + npx playwright install | Browser automation engine |
| agent-browser CLI | ✓ | npm install -g agent-browser | Browser operation CLI |
| Node.js | ✓ | winget | Prerequisite |
| OpenReverse | ✗ | Manual clone + npm install | Experimental stage, heavy dependencies |
| mitmproxy | ✗ | Manual installation | OpenReverse network observation dependency |

### Bootstrap Triggers

- Playwright missing for browser operations → automatic bootstrap
- OpenReverse needed for desktop operations → guide the user through manual installation (provide complete steps)

### OpenReverse Manual Installation Guide

If the AI detects that desktop application automation is needed but OpenReverse is not installed:

```markdown
⚠️ **OpenReverse is required for desktop application automation**

**Installation steps**:
1. `git clone https://github.com/zhexulong/openreverse.git`
2. `cd openreverse && npm install`
3. `npm run init:agents -- --target=all <your project path>`
4. If vision mode is needed: `npm run install:cua-runtime`
5. If network observation is needed: `npm run install:mitmproxy`

**Verification**: `npm run doctor:cua-runtime` and `npm run doctor:network`
```

---

## Routing Context

**Upstream entry**: `skills/SKILL.md` (master control), `routing.md`
**Applicable scenarios**: Any task requiring automated operation of browsers or desktop applications
**Downstream exits**:
- Captured requests need analysis → `anything-analyzer` or `js-reverse`
- Need JS debugging/hooking → `jshookmcp`
- Need to reconstruct signature algorithms → `js-reverse`
- The desktop application is a reverse engineering tool → `ida-reverse/`

**Peer related modules**: `js-reverse` (may need to analyze JS after browser operations), `ida-reverse` (OpenReverse can automate IDA GUI operations)


## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I execute every step in the workflow (rather than just reading)?
- [ ] Did I use real tool paths based on `tool-index`?
- [ ] Did I produce reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Did I complete and write back the Checklist items required by RULES?
