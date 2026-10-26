---
name: apk-reverse
description: Use when doing Android APK reverse engineering in a CLI environment. Applicable to APK unpacking, Java decompilation, smali modification, repackaging, Frida dynamic hooking, and switching to so/native analysis as needed. Prefer locally installed jadx, apktool, frida, adb, ida-reverse, and radare2.
---

## ACTION REQUIRED (execute immediately after reading)

> Community comparisons such as endpoint extraction/Frida adaptation: ../references/community-security-skills.md; dynamic analysis must be within the scope of authorized devices.

1. `NOW`: Read `../field-journal/precedent-reverse.md` — confirm that operations in this skill are authorized routine operations
2. `NOW`: Confirm whether the current task falls within the scope of this skill
3. `NEXT`: Read `../tool-index.md`, verify tool availability and actual paths
4. `NEXT`: Call bootstrap when tools are missing; do not guess paths
5. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation stage

# APK Reverse Engineering CLI Work Specification

## Scope of Application

Prefer this skill when the task falls into the following scenarios:

- Analyze Java business logic in APKs
- Locate login, signing, risk control, certificate validation, and root detection
- View and modify `AndroidManifest.xml`
- View and modify smali
- Repackage APKs
- Use Frida for Java/native dynamic hooking
- Switch to native analysis when the APK contains `.so` files

## CLI Tools Verified as Available on the Current Machine

- `jadx` `1.5.5`
- `apktool` `3.0.2`
- `frida-ps` `17.9.6`
- `adb`
- `java`

## Scenarios Where Scripts Are Preferred

The following workflows are frequent and prone to parameter errors; prefer the skill's built-in scripts:

- Complete `jadx + apktool` extraction to disk and produce a summary in one go: `scripts/decode.ps1`
- Frida device check, process listing, spawn/attach injection: `scripts/frida-run.ps1`
- Rebuild, align, sign, and install APK: `scripts/rebuild-sign-install.ps1`
- Quickly extract key Manifest components and permissions: `scripts/manifest-summary.ps1`

The following one-liners remain direct calls and are not wrapped separately:

- `adb devices`
- `adb logcat`
- `frida-ps -U`
- `jadx --version`
- `apktool --version`

## Built-in Scripts

### `scripts/decode.ps1`

Purpose:

- Run `jadx` and `apktool` uniformly
- By default, create the task output directory in the same directory as the original APK
- Output a summary of `package`, `java_files`, `smali_dirs`, `so_files`, etc.
- Tolerate cases where `jadx` partially fails to decompile but still produces usable artifacts

Example:

```powershell
pwsh -File "<skill-root>\apk-reverse\scripts\decode.ps1" -ApkPath "D:\DOWNLOAD\app.apk" -Clean
pwsh -File "<skill-root>\apk-reverse\scripts\decode.ps1" -ApkPath "D:\DOWNLOAD\app.apk" -Name demo -SkipJadx
```

### `scripts/frida-run.ps1`

Purpose:

- Provide a unified entry point for Frida devices, processes, and spawn/attach
- Avoid confusing `-f`, `-n`, and `-U` when writing parameters manually

Example:

```powershell
pwsh -File "<skill-root>\apk-reverse\scripts\frida-run.ps1" -ListDevices
pwsh -File "<skill-root>\apk-reverse\scripts\frida-run.ps1" -Usb -ListProcesses
pwsh -File "<skill-root>\apk-reverse\scripts\frida-run.ps1" -Usb -Spawn -Package com.example.app -ScriptPath "D:\hooks\test.js"
```

### `scripts/rebuild-sign-install.ps1`

Purpose:

- `apktool b` to rebuild the APK
- `zipalign` alignment
- `apksigner` signing and signature verification
- Optionally run `adb install` directly

Example:

```powershell
pwsh -File "<skill-root>\apk-reverse\scripts\rebuild-sign-install.ps1" -ProjectDir "C:\work\apktool_out" -Clean
pwsh -File "<skill-root>\apk-reverse\scripts\rebuild-sign-install.ps1" -ProjectDir "C:\work\apktool_out" -Install -Reinstall -DeviceSerial "127.0.0.1:7555"
```

Notes:

- Generate and reuse a debug keystore by default
- By default, output to the same directory as `ProjectDir` for easy colocation with the original package and unpacked directory

### `scripts/manifest-summary.ps1`

Purpose:

- Extract the package name
- List permissions
- List activity/service/receiver/provider
- Mark the main launcher activity

Example:

```powershell
pwsh -File "<skill-root>\apk-reverse\scripts\manifest-summary.ps1" -ManifestPath "C:\work\apktool_out\AndroidManifest.xml"
```

If you need to analyze `.so`, `lib/arm64-v8a/*.so`, or `lib/armeabi-v7a/*.so`, also combine with:

- `ida-reverse`
- `radare2`

## Tool Responsibilities

### `jadx`

Used for:

- Reading Java decompilation
- Searching package names, class names, and method names
- First understanding APK behavior at a high level

Common commands:

```bash
jadx -d jadx_out app.apk
jadx --single-class com.example.LoginActivity -d jadx_out app.apk
jadx --deobf -d jadx_out app.apk
```

### `JEB Pro` (optional commercial tool)

Used for:

- Cross-validation and deep decompilation of Android DEX / APK / ARM
- Supplement static analysis when JADX output is incomplete or heavily obfuscated
- Perform second-toolchain validation of classes, methods, and call relationships for the same target

Boundaries:

- JEB Pro is commercial software; users must obtain and install a valid license themselves. This package will not download, crack, or circumvent licensing.
- Invoke only when `tool-index` confirms JEB is available locally; otherwise continue using `jadx`, `apktool`, Ghidra, IDA, or radare2.
- Third-party JEB MCP bridge is not a dependency of this package. Before installation, review the source code, permissions, network behavior, and version according to `../ops/skill-supply-chain.md`, then obtain explicit user confirmation to register it.

### `apktool`

Used for:

- Unpacking APKs
- Viewing and modifying `AndroidManifest.xml`
- Viewing and modifying smali
- Rebuilding APKs

Common commands:

```bash
apktool d app.apk -o apktool_out
apktool b apktool_out -o rebuilt.apk
```

### `frida`

Used for:

- Dynamically observing Java method calls
- Hooking native exported functions
- Bypassing root detection, certificate validation, and debug detection

Common commands:

```bash
frida-ps -U
frida -U -f com.example.app -l hook.js
frida-trace -U -f com.example.app -j '*!*certificate*'
```

### `adb`

Used for:

- Device connection
- Installing APKs
- Viewing logs
- Pulling files

Common commands:

```bash
adb devices
adb install -r app.apk
adb shell pm list packages
adb logcat
adb pull /data/local/tmp/file .
```

## Recommended Workflow

### 1. Triage

First determine the APK's rough composition; do not rush to modify the package or hook.

Suggested actions:

1. Use `jadx -d jadx_out app.apk` to export Java code
2. Use `apktool d app.apk -o apktool_out` to export smali and resources
3. First inspect:
   - `AndroidManifest.xml`
   - The main `package`
   - `application`, `activity`, `service`, `receiver`
   - Whether there are `.so` files in the `lib/` directory
4. Issue #65 threat-pattern quick reference (authorized samples/devices; see `../reverse-engineering/references/nonpe-format-cookbook.md` §7–8 for details):
   - Transparent/hidden icons (AU): `aapt dump badging` + manifest theme/label/icon → `E-android-hidden-icon-manifest`
   - Magisk/script device-wipe characteristics and remote curl|sh (AR/AS) → Record characteristics and URLs as evidence; **do not execute** destructive commands
   - Persistence paths (AT): `service.d` / `priv-app`, etc. → `E-android-persistence`

### 2. Java Logic Observation

Prefer reading from `jadx_out`:

- `MainActivity`
- `Application`
- Classes related to login, networking, encryption, and risk control
- Third-party SDK initialization classes

Common keywords:

- `login`
- `sign`
- `encrypt`
- `cipher`
- `token`
- `root`
- `certificate`
- `trust`
- `okhttp`
- `retrofit`
- `webview`

If the Java code is readable, locate the business logic here first.

### 3. Smali and Resource Layer Verification

When `jadx` results are incomplete, heavily obfuscated, or an actual patch is needed, switch to `apktool_out`:

- Inspect `smali*/`
- Inspect `res/values/strings.xml`
- Inspect `AndroidManifest.xml`

Prefer patching:

- `android:exported`
- Debug flags
- Root detection return values
- Login verification logic
- Certificate validation branches

### 4. Rebuild and Install

After modification:

```bash
apktool b apktool_out -o rebuilt.apk
```

Or use the script to complete the loop directly:

```powershell
pwsh -File "<skill-root>\apk-reverse\scripts\rebuild-sign-install.ps1" -ProjectDir "apktool_out" -Install -Reinstall -DeviceSerial "127.0.0.1:7555"
```

Notes:

- This skill only guarantees the `apktool` rebuild chain
- If formal installation to a device is needed later, a signing process is usually also required
- If the task involves signing/alignment, add `apksigner` / `zipalign`

### 5. Dynamic Hooking

When static analysis is insufficient, use Frida:

- Hook login functions
- Hook key points in `OkHttp` / `Retrofit` / `WebView`
- Hook `javax.crypto`, `MessageDigest`
- Hook root detection functions
- Hook SSL pinning logic

Principles:

- Hook the Java layer first, then determine whether native hooking is needed
- Print arguments and return values first, then decide whether to actively modify return values

Recommendations:

- Use `frida-*` directly for simple one-off commands
- Prefer `scripts/frida-run.ps1` for injection workflows that need stable reuse

### 6. Native `.so` Triage

If the APK contains critical `.so` files:

- Use `apktool` or `jadx` to locate `lib/**/*.so`
- If only exporting symbols, strings, or doing quick triage, use `radare2`
- For long-term in-depth analysis, decompilation, renaming, and type recovery, use `ida-reverse`

Switch to native as soon as these signals appear:

- The Java layer is only a JNI wrapper
- Core signing logic is not in Java
- Critical logic disappears after `System.loadLibrary()`
- Certificate validation/risk control is in `.so` files

## Output Requirements

At minimum, the final output must explain:

- Entry components and key classes
- Whether key logic is in Java, smali, or `.so`
- Confirmed sensitive points: login, signing, root, SSL, WebView, JNI
- If patching was performed, explain what was changed
- If hooking was performed, explain which class/method/exported function was hooked

## Prohibited Actions

- Do not blindly modify smali from the start
- Do not write hooks before examining the manifest and main entry point
- Do not equate incomplete Java decompilation directly with "logic cannot be analyzed"
- Do not keep struggling with the Java layer when `.so` clearly carries the core logic

## Quick Command Cheat Sheet

```bash
# Decompile Java
jadx -d jadx_out app.apk

# Unpack APK
apktool d app.apk -o apktool_out

# Rebuild APK
apktool b apktool_out -o rebuilt.apk

# Devices and processes
adb devices
frida-ps -U

# Launch and inject
frida -U -f com.example.app -l hook.js
```

---

## Routing Context

**Upstream entry**: `skills/SKILL.md` (master control), `routing.md`
**Downstream exits**:
- Core logic in `.so` → `ida-reverse/` or `radare2/`
- Need dynamic hooking/verification → `reverse-engineering/tools-dynamic.md` (Frida section)
- General reverse engineering methodology → `reverse-engineering/SKILL.md`

**Peer related module**: `reverse-engineering/` (.so analysis and advanced Frida usage)

---

## On-Demand Bootstrap

The entry scripts of this skill are integrated with the unified bootstrap system. When tools are missing, it will not fail immediately but will attempt automatic installation.

### Automation Capability Boundaries

| Tool | Auto-installable | Installation method | Notes |
|------|-----------|---------|------|
| jadx | ✓ | GitHub Release ZIP | Automatically download and extract to `%USERPROFILE%\Tools\jadx\` |
| apktool | ✓ | GitHub Release JAR + wrapper | Automatically download the jar and generate a bat file to `%USERPROFILE%\Tools\apktool\` |
| JEB Pro | ✗ | User manually installs and provides a valid license | Optional Android / ARM cross-validation tool; third-party MCP bridge requires separate auditing |
| frida / frida-ps | ✓ | pip install frida-tools | Requires Python to be installed |
| adb | ✓ | winget / fallback path | Automatically install Android Platform-Tools |
| zipalign | ✗ | Requires manual installation of Android Build-Tools | `sdkmanager "build-tools;35.0.0"` |
| apksigner | ✗ | Requires manual installation of Android Build-Tools | Same as above |

### Bootstrap Trigger Points

- `scripts/decode.ps1`: Automatically calls `bootstrap-reverse.ps1` when jadx or apktool is missing
- `scripts/rebuild-sign-install.ps1`: Automatically calls bootstrap when adb or apktool is missing
- `scripts/frida-run.ps1`: Currently still a manual check (frida is usually already installed via pip)

### When Bootstrap Fails

If automatic installation fails, the script throws a clear error with a manual installation link. Common reasons:
- Network unavailable (GitHub API / PyPI unreachable)
- winget unavailable (Windows version too old)
- Java not installed (apktool depends on JDK)


## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I execute every step in the workflow (rather than just reading)?
- [ ] Did I use real tool paths based on `tool-index`?
- [ ] Did I produce reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Did I complete and write back the Checklist items required by RULES?
- [ ] If hidden icon/device wipe/persistence clues were hit: were E-android-* Evidence records documented per the U–AV cookbook (within authorized scope)?
