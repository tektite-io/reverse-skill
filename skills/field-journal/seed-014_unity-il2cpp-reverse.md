# [Seed] Unity IL2CPP Game Reverse Engineering → Recover Metadata + Modify Logic

## Scenario Classification
Game Security / Mobile Reverse Engineering

## Goal Overview
A Unity-built Android game (IL2CPP mode): in-game purchases or core algorithms are written in C# but compiled to native code. Recover method names, locate key logic, and modify the implementation via patching or hooking.

## Complete Execution Chain

1. Unpack the APK and confirm it is IL2CPP.
   ```bash
   unzip target.apk -d apk
   ls apk/lib/arm64-v8a/        # seeing libil2cpp.so means IL2CPP
   ls apk/assets/bin/Data/Managed/Metadata/
   # Key file: global-metadata.dat
   ```
2. Use **Il2CppDumper** to recover metadata.
   ```bash
   Il2CppDumper libil2cpp.so global-metadata.dat output/
   # Outputs: DummyDll/ + script.json + il2cpp.h + dump.cs
   ```
3. Run IDA's IL2CPP script (`ida_with_struct.py`).
   - Load libil2cpp.so → File → Script File → select ida_with_struct.py → select script.json
   - IDA can now show C# method names, signatures, and strings.
4. Search dump.cs for business keywords (`AddCoin` / `OnPurchase` / `Verify` / `IsVip` / `CheckSign`).
5. Get the offset of the key method → jump to it in IDA to view disassembly / decompilation.
6. Choose a modification method:
   - **Static patch**: directly change the check in IDA to `mov w0, #1; ret`.
   - **Dynamic hook**: hook il2cpp methods with Frida (using Frida-Il2CppBridge).
7. Repackage to verify / inject to verify.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Il2CppDumper reports unsupported metadata version | Newer Unity changed the metadata format | Upgrade Il2CppDumper to the latest / use Il2CppInspectorRedux instead | 30min |
| global-metadata.dat is encrypted | Uses AntiCheatToolkit / custom encryption | Find the decryption function during game initialization (usually around il2cpp_init) → dump with Frida after mmap | 2h |
| Method names visible in dump.cs but not matched in IDA | script.json does not match the .so | Must use artifacts from the same dump; clear the cache when switching IDA versions | 20min |
| Frida hooking an IL2CPP method errors out | IL2CPP methods are not standard Java/ObjC; you must compute the method offset | Use the frida-il2cpp-bridge library; do not hardcode Interceptor.attach | 1h |
| Game crashes after patching | File hash verification or anti-tamper | Find and patch the hash verification logic too, or use a hook without modifying files | 2h |
| Crashes on launch after repackaging | apksigner v2 signatures cannot be modified after signing | Delete META-INF + apktool b + apksigner sign in one go | 30min |

## Toolchain Findings

- **Il2CppDumper** is a veteran tool but still the default choice.
- **Il2CppInspectorRedux** is more modern, supports newer Unity, and can output plugin scripts for IDA / Ghidra / Binary Ninja.
- **frida-il2cpp-bridge** is the de facto standard for hooking IL2CPP, N times more powerful than raw Frida.
- **DnSpy** / **dnSpyEx** are used to inspect DummyDll (the pseudo .NET assembly produced by the dump).
- **UnityCheat** series auxiliary tools (GameGuardian lineage is not covered here).

## Key Code/Commands

frida-il2cpp-bridge hook example:

```typescript
// hook.ts
import "frida-il2cpp-bridge";

Il2Cpp.perform(() => {
    const Assembly = Il2Cpp.domain.assembly("Assembly-CSharp").image;

    // hook static method
    const PlayerData = Assembly.class("PlayerData");
    PlayerData.method("AddCoin").implementation = function (n: number) {
        console.log("[+] AddCoin called with:", n);
        return this.method("AddCoin").invoke(99999); // change to 99999
    };

    // hook instance method
    const Purchase = Assembly.class("Purchase");
    Purchase.method("VerifyReceipt").implementation = function () {
        console.log("[+] VerifyReceipt → always true");
        return true;
    };
});
```

```bash
# Compile + inject
npm install frida-il2cpp-bridge
frida-compile hook.ts -o hook.js
frida -U -f com.target.game -l hook.js --no-pause
```

IDA static patch:

```text
1. Open libil2cpp.so and run il2cpp_load_metadata.py
2. Jump to the offset corresponding to IsPurchaseValid in dump.cs
3. Change the function prologue to MOV W0, #1; RET (ARM64)
4. Apply Patches → Save → replace back into the APK → re-sign
```

## Suggestions for This Package

- `reverse-engineering/SKILL.md` already covers Unity, but lacks a complete IL2CPP workflow case.
- Make `reverse-engineering/references/il2cpp-cheatsheet.md` a standalone document: comparison of dump tools, frida-bridge templates, and handling encrypted metadata.
- Add frida-il2cpp-bridge to the bootstrap manifest.

## Reusable Patterns/Script Snippets

**Standard IL2CPP workflow**:

```text
1. Confirm IL2CPP (check whether libil2cpp.so exists under lib/abi)
2. Locate metadata (assets/bin/Data/Managed/Metadata/global-metadata.dat, or it is encrypted)
3. Recover with Il2CppDumper / Inspector
4. IDA + script to bring back metadata info
5. Search dump.cs for business keywords
6. Choose patch or hook
7. Verify (launch + real scenario)
```

**Handling encrypted metadata**:

```text
1. Hook fopen/open-family calls with Frida to see who reads global-metadata.dat
2. After mmap/read, dump the decrypted metadata from memory
3. Feed the dumped memory to Il2CppDumper as metadata
```

## Evolution Actions
- [ ] Add a complete il2cpp chapter to reverse-engineering/references
- [ ] Add frida-il2cpp-bridge / Il2CppInspectorRedux to bootstrap-manifest
- [x] Routing matrix already includes Unity / IL2CPP

## Environment Information
- Windows / macOS (for running Il2CppDumper), target device Android arm64
- IDA Pro 7.7+ or Ghidra 11+
- frida-tools 16.x, frida-il2cpp-bridge 0.9+
- Unity version: 2019.x - 2022.x (metadata format differs slightly across versions)

## Anonymization Requirements
This entry is seed data, written based on public technical patterns, and does not involve any real games. The package name `com.target.game` is a placeholder.
