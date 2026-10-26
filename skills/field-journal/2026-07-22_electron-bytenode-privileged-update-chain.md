# 2026-07-22 Electron Bytenode Privileged Update Chain Analysis

## Scenario Classification

Binary analysis / Electron / Bytenode / update-chain security audit

## Goal Overview

Complete a cross-layer reverse engineering pass on a Windows x86 Electron desktop application — from the NSIS installer, ASAR, and Bytenode JSC to the native game SDK and remote-rendered pages — to confirm the privilege boundary, IPC capabilities, and update-package trust model.

## Full Execution Chain

1. Run SHA-256, Authenticode, manifest, section, overlay, and mitigation checks on the outer PE of `{electron_app}` to confirm the installer type and privilege level.
2. Read-only expand the NSIS with 7-Zip, locate the inner archive, and rebuild the file inventory; continue to extract the original `app.asar`, preserving logical offsets, sizes, and per-file hashes.
3. Identify Electron 22.0.0, Node 16.17.1, and Bytenode 1.5.7 from `package.json`, runtime resources, and JSC strings; distinguish the original extraction directory from the pre-modified directory.
4. Use the sample's bundled Electron in `ELECTRON_RUN_AS_NODE=1` mode to load `main.jsc` and `preload.jsc`, resolving host Node/V8 ABI incompatibility.
5. In the probe, mock Electron, networking, file writes, archiving, FFI, subprocesses, and exit; record window options, 21 main-process IPC handlers, 29 preload bridge members, and lifecycle callbacks.
6. Freeze a static-resource snapshot of `{remote_ui_domain}` and trace how the `updateUrl` returned by `https://{update_api_domain}/api/user/v1/check_ver` enters the local `checkUpdates`.
7. Drive the update handler with a loopback HTTP fixture to confirm the URL-receiving, download, extraction, and detached-updater launch sequence; record the absent allowlist, hash, package signature, and Authenticode checks each as "not observed in the controlled path".
8. Statically re-review the exports, imports, strings, PE protections, signatures, and key addresses of `{native_game_sdk}`, distinguishing ABI forwarding, callback FIFO, state watchdog, and third-party platform installation branches.
9. Use "conditional capability" wording for service, driver, hosts, root certificate, proxy, and platform registry operations; describe a capability only when there is call-chain evidence, and do not infer that this run already executed it.
10. Output a formal report, three data-flow diagrams, structured IOCs, reproduction commands, and an evidence index, and separate high-confidence static facts, controlled dynamic facts, and remote-snapshot freshness boundaries in the conclusion.

## Pitfalls

| Problem | Cause | Solution | Time |
|---|---|---|---|
| Host Node fails to load JSC directly | Bytenode bytecode is bound to a specific V8/Node ABI | Execute using the sample Electron's RunAsNode mode | Medium |
| Timers and exit logic interfere after launching the probe | The main process contains lifecycle callbacks, a watchdog, and `process.exit` | Add `--run-timeouts` and mock timers, exit, and the four app callbacks | Medium |
| The update handler needs to trigger network, disk write, and subprocess paths at once | Merely enumerating handlers proves registration, not data flow | Add a `--update-url` fixture and record parameters and side effects across the whole chain | Medium |
| The analysis directory contains pre-existing modified artifacts | Modified ASAR/JSC pollutes the original conclusions | Use only `{sample_dir}` and `{extracted_original_dir}` as original evidence sources | Low |
| Dual-signed DLL status is easy to misjudge | Each signature's certificate, timestamp, and current validation state may differ | Check each signature with `signtool verify /pa /all /v` | Low |
| Native strings suggest high-privilege system capabilities | Strings and imports do not mean the current path executed them | Combine xref/call chain and label them "conditional capability" | Medium |
| The remote UI keeps changing | The current chunk and API behavior are not permanent fixed assets | Save dated resource snapshots, hashes, and capture times | Low |

## Toolchain Findings

- The sample's bundled Electron is the most stable ABI container for executing Bytenode JSC; `ELECTRON_RUN_AS_NODE=1` runs the probe without starting the business GUI.
- Electron module mocks must cover `app.whenReady/on/quit`, `BrowserWindow`, `ipcMain.handle/on`, `shell`, `session`, and `webContents`, or you only get an incomplete registration surface.
- Update-chain verification should record the input URL, request library, target file, extraction directory, and final `spawn` parameters together, to establish an evidence loop from renderer to updater.
- PE signature audits should describe "certificate present", "certificate within validity", "trusted timestamp present", and "current chain validation succeeds" separately.
- For large third-party DLLs, partition capabilities by imports/exports and strings first, then do address-level review of high-risk branches such as service, network, certificate, and process creation.

## Key Code/Commands

```powershell
$env:ELECTRON_RUN_AS_NODE = '1'
$env:__COMPAT_LAYER = 'RunAsInvoker'

& '{electron_exe}' '{probe_script}' '{main_jsc}' `
  --execute --exercise=all --run-timeouts --quiet `
  --out='{main_probe_json}'

& '{electron_exe}' '{probe_script}' '{main_jsc}' `
  --execute --exercise=all --run-timeouts `
  --update-url='http://127.0.0.1:{port}/update.zip' --quiet `
  --out='{update_probe_json}'

& '{electron_exe}' '{probe_script}' '{preload_jsc}' `
  --execute --exercise=bridge --quiet `
  --out='{preload_probe_json}'

signtool verify /pa /all /v '{native_game_sdk}'
```

## Suggestions for This Package

1. Add a Bytenode ABI decision tree to the Electron/JS reverse engineering route: after host Node fails, prefer the target Electron's RunAsNode mode.
2. Add a generic Electron mock coverage matrix and an IPC registration/invocation consistency check script.
3. In the updater audit template, fix checks for URL constraints, transport protocol, manifest signature, package hash, signature chain, extraction traversal, and final execution parameters.
4. Add mandatory "conditional capability" and "observed behavior" columns to the report template to reduce the risk of over-inferring from imports/strings.

## Reusable Patterns/Script Fragments

1. **Three-layer trust boundary**: original installer -> original ASAR/JSC -> remote page snapshot, with a hash and timestamp established for each layer.
2. **Separate registration surface from execution surface**: enumerate IPC/preload APIs first, then invoke high-risk handlers with mock fixtures and capture side effects.
3. **Update chain five-tuple**: `source URL -> downloader -> archive path -> extractor -> executable`, saving evidence at every node.
4. **Native capability grading**: imports/strings are clues, xref/call chains are capability evidence, and only real dynamic events count as executed facts.
5. **Signature four-state model**: report signature existence, certificate validity, timestamp, and current trust validation separately.

## Evolution Actions

- [x] Added a pitfalls record
- [x] Updated the experience index
- [ ] Updated the routing matrix
- [ ] Updated the tool-index
- [ ] Updated the bootstrap-manifest
- [ ] Updated sub-skill documentation

## Environment Information

- OS: Windows 11 x64
- Tool versions: Electron 22.0.0, Node 16.17.1, Bytenode 1.5.7, Python 3.12
- Target platform/version: Windows x86 / Electron desktop app

## Anonymization Requirements

This document retains only generic versions, API path structure, order of magnitude, and analysis methods. Sample names, publishers, real domains, case directories, hashes, configuration keys, tokens, and user identifiers have all been replaced or omitted; no sample files are attached.

---
<!-- [Community contribution] After completion, ask the user whether to PR to the main repository. See CONTRIBUTE-BACK.md for the flow. -->
