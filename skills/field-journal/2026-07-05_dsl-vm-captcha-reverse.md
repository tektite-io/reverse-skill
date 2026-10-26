---
name: dsl-vm-captcha-reverse-2026-07-05
description: Full reverse engineering analysis of a CAPTCHA system — JS frontend modules + DSL VM risk-control engine
metadata:
  type: project
  tags: [captcha, reverse, dsl-vm, wasm, frontend]
  date: 2026-07-05
  status: completed
---

# Full Reverse Engineering Analysis of a CAPTCHA System

## Scenario
Target: reverse engineer a large CAPTCHA system to understand its complete working principle and verification flow.

## Target Entities
- **nc.js** (72KB) — Webpack-bundled slider core (9 modules)
- **fireyejs.js** (583KB) — DSL VM interpreter (26-opcode custom instruction set)
- **awsc.js** (9KB) — module loader
- **secaptcha.js** (72KB) — WASM C compilation output (emscripten)
- **et_f.js** (262KB) — another DSL VM-type file

## Verified Technical Approaches

### Approach A: Selenium + CDP drag (recommended)
Send native mouse events via CDP `Input.dispatchMouseEvent` to complete verification in a real browser.
- Success rate: high
- Dependencies: Chrome + Selenium/Playwright

### Approach B: Playwright headless browser runner
Load the DSL VM and module loader in Playwright and expose the token via an HTTP API.
- Success rate: medium (depends on the WASM initialization environment)

### Approach C: Pure requests protocol verification
Call API endpoints directly via HTTP requests for verification.
- Success rate: **extremely low** (the token is strongly bound to the browser's TLS/IP/fingerprint)
- Not recommended

## Key Findings

1. **The token cannot be used outside the browser** — when the DSL VM-generated token is submitted, the server validates context consistency (TLS JA3, IP, Cookie, Referer, etc.)

2. **fireyejs.js is not a WASM binary but a DSL VM** — a 583KB pure-JS custom virtual machine that executes encoded instructions through a 26-opcode interpreter loop

3. **nc.js's 9 modules are 100% reversed** — including API endpoints, slider UI, interaction logic, the ncSessionID algorithm, and multilanguage support

4. **The real WASM compilation output is secaptcha.js** — 72KB, using SharedArrayBuffer + Atomics, emscripten-compiled C code

## Pitfalls

1. A test appkey does not trigger real verification; you must use the appkey of a real page
2. Only a specific status code returned by `initialize` indicates slider mode; returning `success` is merely confirmation that the session was created
3. In the performance log, URL events for JSONP requests may be captured incompletely due to the script-tag injection method
4. Exported function names do not exist in the DSL VM file (they are VM-encoded); the real exports are exposed through the module registry

## Reusable Patterns

- **DSL VM reverse engineering pattern**: `case extraction → opcode classification → constant table analysis → function tracing → export extraction`
- **General CAPTCHA system architecture**: `entry JS → module loader (WASM/DSL) → API communication layer → frontend UI → server-side verification`
- **CDP native event bypass**: `Input.dispatchMouseEvent` bypasses detection and is independent of WebDriver

## Toolchain

- Selenium + CDP: browser automation + native mouse events
- Playwright: headless browser + route interception
- Python requests: pure API calls (verification failed)
- Node.js + Playwright: runner service

## File Structure

```
project root/
├── slider_v3.py                # improved CDP drag
├── protocol_v2.py               # pure protocol version (verification failed)
├── phase3_final.py              # full Playwright capture
├── monitor_inject.js            # page monitoring hook
├── runner/                      # Node.js runner
├── captured_js/                 # captured JS files
├── hook_data/                   # data captured by hooks
├── wasm_output/                 # WASM extraction output
└── COMPLETE_REVERSE_REPORT.md   # full reverse engineering report
```

## Reference Links

- [[dsl-vm-reverse]] — DSL VM reverse engineering skill documentation
