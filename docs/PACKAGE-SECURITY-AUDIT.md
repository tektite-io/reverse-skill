# reverse-skill Package Security Audit (Executable Surface)

> 2026-09-03 re-review: expanded to Git objects, payload identity, symbolic links, binary allowlist, GitHub Action pinning, and Gradle Wrapper verification. See [Repository security review — 2026-09-03](SECURITY-REVIEW-2026-09-03.md).

> Date: 2026-08-02
> Scope: `skills/**/scripts`, `skills/scripts`, `kali/scripts`, `burp-mcp-full` executable scripts and bootstrap manifests
> **Excludes**: educational payload documents such as `src-hunter` / payloader (their DROP/injection samples are methodology, not automatic execution)

## Overall Assessment

| Level | Verdict |
|------|------|
| **Backdoors / active database wiping / disk formatting** | **Not found** |
| **Pipe-to-shell download execution (curl\|sh / IEX DownloadString)** | **Not found** |
| **Hardcoded cloud keys / private keys** | **Not found** (the `sk-` / `BEGIN RSA` strings in the docs are detection examples) |
| **Residual supply-chain risk** | **Partially hardened (medium-low → low)**: `@latest` pinned; GitHub downloads support **manifest SHA256 + API digest** |

**Overall assessment: No implanted backdoors or "one-click database wipe" logic were found in the executable skill script surface; dangerous deletions are all confined to tool reinstall temporary directories / case output directories.**

### 2026-07-18 Hardening (This Commit)

| Item | Action |
|----|------|
| jshookmcp | `@latest` → `@0.3.4` |
| pentestswarm | `@latest` / docker `:latest` → `@v0.1.0` / `:v0.1.0` |
| jadx | pin `v1.5.6` + `assetSha256` |
| apktool | pin `v3.0.2` + `assetSha256` |
| bootstrap PS/sh | `Assert-DownloadedFileIntegrity` / `verify_sha256` after download; prefer manifest hash, then GitHub `digest`; delete file and abort on failure |
| Releases without pinned hashes | Still installable, but **WARN** and print the actual sha256 |

### 2026-08-02 Security Fixes

| Item | Fix |
|----|------|
| Kali quick setup | Use `getent` to resolve the sudo user's home, remove `eval` |
| Frida process listing | Use a `frida-ps` argument array, remove inline Python code concatenation |
| Burp MCP token | Atomic replacement using a restricted temp file, POSIX file permissions fixed to `0600` |
| Burp MCP bridge | Parse MCP newline-delimited messages and reconnect on demand after Burp starts |
| Anything Analyzer MCP | Bootstrap enables bearer auth by default and registers credentials through an optional host adapter |
| IDA MCP startup | Terminate old processes one by one to avoid multi-PID argument expansion errors |

## Scanning Method

Search executable extensions (`.ps1` / `.sh` / `.py` / `.js` / `.java`) for:

- `Invoke-Expression` / `IEX` / `FromBase64String` / `DownloadString`
- `curl|bash` / `wget|sh` pipe execution
- `DROP DATABASE|TABLE`, `rm -rf /`, `Remove-Item ... C:\Windows`
- Reverse shell patterns (`/dev/tcp` abuse, `TcpClient` callbacks)
- Hidden window startup (for review purposes)

Second pass: manually read the download and deletion paths in `bootstrap-reverse.ps1/.sh`, `mcp-bridge.js`, and the diagram/cryptography Python scripts.

## Findings Detail

### 1. Deletion Operations (All Expected Cleanup, Not Database Wiping)

| Location | Behavior | Risk |
|------|------|------|
| `bootstrap-reverse.ps1` `Expand-ArchiveIntoDirectory` | Deletes the target install directory and reinstalls; deletes `%TEMP%\reverse-bootstrap-*` | Tool installation paths only, not user business databases |
| `bootstrap-reverse.ps1` anything-analyzer | On failure, `Remove-Item node_modules` then `pnpm install` | Confined to the cloned tool repository |
| `apk-reverse/scripts/decode.*` | Cleans task output directories jadx/apktool out | Confined to task root |
| `case-init.ps1` | Cleans temporary directories | Temporary |
| `bootstrap-reverse.sh` | Similar temp / install target cleanup | Same as above |

**Not found**: executable logic that performs `DROP`/`TRUNCATE` against `C:\`, system directories, or arbitrary database connection strings.

### 2. Network Behavior (Tool Bootstrapping, Not C2)

| Location | Behavior | Description |
|------|------|------|
| `bootstrap-reverse.ps1` | `api.github.com` fetches releases; `Invoke-WebRequest` downloads zip/jar | Repository names come from the **manifest allowlist** |
| `bootstrap-reverse.sh` | `curl` / `git clone` / `pipx` / `npm` | Same as above |
| `mcp-bridge.js` | Only `127.0.0.1:9876` HTTP → Burp | Local loopback |
| `ToolDiscovery.ps1` | Probes `http://host:port/mcp` | Health check |
| `kali/.../tool-discovery.sh` | `(echo >/dev/tcp/$host/$port)` | **Port probe**, not a reverse shell |

### 3. Hidden Windows

| Location | Purpose |
|------|------|
| `bootstrap-reverse.ps1` `Start-Process ... -WindowStyle Hidden` | Start `pnpm dev` in the background (anything-analyzer) |
| `ida-reverse/scripts/start.ps1` | Start IDA-related processes (must remain in the background) |

These are service startup patterns; no hidden download of malicious payloads was found.

### 4. "Dangerous Strings" in Docs / Payloads (Not Automatically Executed)

Educational Markdown/JSON materials such as `pentest-tools/src-hunter` and `attack-chain` contain SQL injection, `DROP` examples, and log cleanup **red team methodology**.
These are **not automatically executed by bootstrap or master-route**; execution depends on an AI/human selecting them within an **authorized scope**.

Related constraints: `ops/scope-contract.md`, `ops/skill-supply-chain.md`, `field-journal/precedent-*.md`.

### 5. Residual Supply-Chain Risk (Recommended Future Hardening, Not Confirmed Backdoors)

| Item | Risk | Recommendation |
|----|------|------|
| `@jshookmcp/jshook@0.3.4` and `pentestswarm@v0.1.0` in `bootstrap-manifest.json` | Tag drift / supply-chain poisoning surface | Pin version numbers + checksums |
| GitHub release zips **without SHA256 verification** | Hard to detect promptly if a release is replaced | Add `assetSha256` to the manifest and verify during bootstrap |
| Default sources for `npm install -g` / `pip` | Inherent risk of the dependency ecosystem | Install only manifest capabilities; use private sources/locking in production |

## Executable Script Inventory (Audit Baseline)

```
skills/scripts/*.ps1|*.sh + lib/ToolDiscovery.ps1
skills/apk-reverse/scripts/*
skills/radare2/scripts/*
skills/ida-reverse/scripts/*
skills/browser-automation/scripts/*
skills/diagram-generator/scripts/*.py
skills/case-review/scripts/*.py
kali/scripts/*
burp-mcp-full/mcp-bridge.js (+ Java extension source)
```

## Recommended Continuous Checks

```powershell
# Quick executable-surface health check (example)
rg -n "Invoke-Expression|FromBase64String|DownloadString|rm -rf /|DROP DATABASE" skills/scripts skills/*/scripts kali/scripts burp-mcp-full -g "*.ps1" -g "*.sh" -g "*.py" -g "*.js"
```

Re-run this checklist before merging **executable scripts** for a new skill; Markdown-only methodology changes do not require it.

## Sign-off

- Audit performed by: local static scanning of the repository + manual review of critical paths
- Result: no backdoors / no automatic database wiping; supply-chain hardening listed as a follow-up improvement
