# 2026-08-20 Flutter APK Server-Driven Ad Removal (Third-Party Counterfeit Package)

## Scenario Classification
APK reverse engineering / Flutter AOT patching

## Goal Overview
Remove server-driven banner/popup ads from a locally owned APK (`{target_app}` 1.0.8, third-party counterfeit package) and re-sign the output.

## Scope Summary (Anonymized)
- auth_basis: user-owned local file, modified for personal use
- network_profile: pure static analysis + local build, no ACT against external systems
- asset_types: [android_apk, flutter_aot_libapp.so]

## Roles
- lead_role: lead
- specialists: []

## Full Execution Chain

1. Target identification: `{target}.apk` — Flutter 3.4.4 (libapp.so 13MB) + 360 hardening shell (`com.frezrik.jiagu.StubApp`, real dex encrypted in the classes.dex tail payload, 2.58MB)
2. Static reconnaissance: apktool d / jadx → manifest has no third-party ad SDK; scanning libapp.so strings → found the server-driven ad system (`ad_slot_key`/`ad_show:`/`wcstream_*` slots, `system/banner/bannerListByMAcct` API)
3. Toolchain setup: gitee prebuilt blutter is ARM64-Linux (unusable) → download blutter-unmgr source → Windows MSVC build (VS2026 BuildTools + cmake + ninja) → compile dartvm3.4.4_android_arm64 static library (~15 min) → blutter.exe analyzes libapp.so → outputs pp.txt/objs.txt/asm/ + frida scripts
4. Ad system recovery: class `qya` (ad model, 11 fields), `pya` (banner list), `GBg` (Map<String,dynamic>→Map<String,List<qya>> parser), all slot keys and API endpoints
5. Patch design (v2 revision): **same-length string replacement** (31 ad strings × 2 ABIs): JSON keys→junk strings (parse null), slot keys→junk strings (lookup failure), reporting labels→junk strings. **API path strings are kept unreplaced** (the first version replaced them and the real device hung at startup with a 404; see the last pitfall row). Client remains self-consistent; the server contract breaks.
6. String table format adaptation: arm64 packed table `[0x80|(len<<1)][chars]`; armv7 object table `[len*2 u32le][chars]`. Prefix validation + longest-string-first to avoid substring overlap (welfare_ad_top/welfare_ad, ad_click:/ad_click).
7. Repackaging: Python zipfile copies 1010 entries (replace libapp.so×2, remove old signatures) → zipalign -p 4 → apksigner v1+v2+v3 (debug keystore)
8. Verification: Blutter re-analysis of the patched libapp.so passes (snapshot intact); apksigner verify passes; aapt badging consistent; zip diff only libapp.so + signatures; 0 ad strings remain in the APK
9. **Real-device runtime verification (supplementary)**: install on arm64 device → enters the main screen normally, ads gone; logcat confirms zero Flutter exceptions (see pitfalls)

## Evidence Chain Summary
| E-id | source_type | Reusable command pattern | Related Finding |
|------|-------------|----------------|--------------|
| E-001 | blutter_out/pp.txt | `[pp+0x210a8] String: "wcstream_banner_top"` | F-001 |
| E-002 | patch script | `work/patch_libapp.py` | F-001 |
| E-003 | Blutter re-analysis | `python blutter.py <patched_dir> <out>` exit 0 | F-002 |

## Finding / Path Summary
- top_finding: for a Flutter app with server-driven ads, removing ads requires no code-logic changes — same-length replacement of the JSON keys/slot keys in the string table suffices; the client stays internally consistent while the server contract fails; **but API path strings must not be replaced** (startup requests hit 404 → jsonDecode exception → startup hang)
- path_type: solve
- path_one_liner: locate string table → same-length replace ad JSON keys/slot keys (keep API paths) → repackage and sign → verify with real-device logcat

## Pitfalls

| Problem | Cause | Solution | Time |
|------|------|---------|------|
| 360 hardening: real Java dex is encrypted | jadx sees only shell classes (com.frezrik.jiagu + a.*) | Ad logic is in the Flutter Dart layer (libapp.so); no unpacking needed | 0.5h |
| gitee prebuilt blutter won't run | Binary is ARM64-Linux (for Termux) | Download blutter-unmgr source and build x64 yourself | 1h |
| Windows build: cmake cannot find cl | %PATH% expands at parse time in cmd and overrides the vcvars environment | `cmd /V:ON` + `set PATH=...;!PATH!` delayed expansion | 0.2h |
| `string(REPLACE "/EHsc" ...)` CMake error | REPLACE gets too few arguments when CMAKE_CXX_FLAGS is empty (newer CMake) | Patch with an `if(CMAKE_CXX_FLAGS)` guard (template + generated files) | 0.2h |
| Obfuscated app ad functions lack asm (size=-1) | Blutter fails to analyze obfuscated/complex functions | Abandon code-level patching; switch to string-table replacement | 0.5h |
| Manual pool-entry reference lookup fails | Snapshot pool entries use compressed pointer encoding with offsets relative to the pool base | Abandon manual encoding reverse engineering; use Blutter pp.txt to locate string objects | 1h |
| substring false match | "welfare_ad" hits inside "welfare_ad_top" | Longest-string-first replacement + prefix byte validation (arm64: 0x80\|len<<1; armv7: len*2) | 0.3h |
| ⚠️ **Real device hangs at the startup logo after replacing API paths** | The first version also replaced `system/banner/bannerListByMAcct` → the startup ad request hit a nonexistent endpoint → server 404 (error body is not valid JSON) → startup flow's `jsonDecode` threw `FormatException` (logcat `E flutter`) → the Future leading to the home page was interrupted and the UI stayed on the splash screen forever | **Do not replace API path/URL strings**; only replace JSON keys/slot keys/reporting labels. Isolate by variable (re-signed control APK only) + `adb logcat -d \| grep "E flutter"`; MIUI install interception requires `settings put global verifier_verify_adb_installs 0` | 1h |

## Toolchain Findings
- blutter-unmgr (gitee.com/fest_1/blutter-unmgr): the prebuilt package is ARM64-Linux; source includes `blutter.py` (auto-detects Dart version + builds + runs in one step)
- Blutter Windows build dependencies: VS BuildTools (with cl) + cmake (≥3.20) + ninja + ICU/capstone (auto-downloaded by init_env_win.py)
- CMakeLists REPLACE bug needs patching (see above)

## Reusable Patterns
**General server-driven ad removal flow** (Flutter or native):
1. Decompile and find ad API endpoints/model keys/slot key strings
2. Confirm the string table format (arm64 packed / armv7 object / generic length-prefixed)
3. Same-length ASCII replacement of **JSON keys/slot keys/reporting labels** (preserve offsets) → server contract breaks; **keep API paths**
4. Repackage + zipalign + apksigner (remember to remove the old signature first)
5. Install on a real device + verify with `adb logcat` (watch for uncaught `E flutter` exceptions and ensure the startup flow has no 404)
