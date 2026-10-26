# [Seed] iOS Jailbreak Detection Bypass + Traffic Capture

## Scenario Classification
iOS Reverse Engineering / Mobile Security Testing

## Goal Overview
An iOS app crashes immediately on launch on a jailbroken device or displays "environment anomaly". Jailbreak detection must be bypassed to analyze its HTTP requests further.

## Complete Execution Chain

1. Prepare a jailbroken device (Dopamine / palera1n / unc0ver) → install frida-server (Cydia repo `build.frida.re`).
2. Drag the IPA onto the device and install it with AppSync Unified signing → launch and confirm `frida-ps -U` works.
3. Launch the app → it crashes or shows "environment anomaly".
4. Use `frida-trace -U -i 'open' -i 'stat' -i 'access' -i 'fork' com.target.app` to observe detection calls.
5. Common hits: probing `/Applications/Cydia.app`, `/private/var/lib/apt`, `/usr/sbin/sshd`, whether `fork()` succeeds, `/etc/apt`.
6. Bypass with a single objection command: `objection --gadget com.target.app explore -s "ios jailbreak disable"`.
7. After successful launch, hook NSURLSession with Frida to capture traffic, or configure mitmproxy and install a system certificate.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Still crashes after objection bypass | App uses both SSL Pinning and jailbreak detection | Enable both `ios sslpinning disable` and `ios jailbreak disable` | 15min |
| App detects before hooking takes effect | Jailbreak detection is in `+load` or `__attribute__((constructor))` | Use `-f` spawn mode + `frida-trace --aux 'spawn=1'` | 20min |
| App hangs after hooking stat | Hooking stat affects some system calls as well | Only hook stat triggered by code inside the app bundle (filter by caller) | 30min |
| App still detects Frida after frida-server starts | App checks port 27042 and Frida strings | Rename `frida-server` + change the default port (`-l 0.0.0.0:1234`), connect the client with `-H ip:1234` | 25min |
| SSL error remains after installing mitmproxy certificate | On iOS 14+, system certificates require an additional toggle under "General → About → Certificate Trust Settings" | After installing the certificate, enable it in trust settings | 10min |

## Toolchain Findings

- **objection** is the Swiss Army knife of iOS security testing; it includes jailbreak / sslpin / clipboard / keychain dump modules.
- **r2frida** connects radare2 to Frida, enabling runtime disassembly and register modification — far more powerful than plain Frida.
- **Hopper / IDA** decompile iOS binaries (IDA 7+ or Ghidra both work for iOS Mach-O).
- **dumpdecrypted** is obsolete; use **frida-ios-dump** for unpacking now.

## Key Code/Commands

Generic jailbreak detection hook template:

```javascript
// Intercept NSFileManager fileExistsAtPath to detect jailbreak directories
var NSFileManager = ObjC.classes.NSFileManager;
Interceptor.attach(NSFileManager['- fileExistsAtPath:'].implementation, {
    onEnter: function (args) {
        var path = ObjC.Object(args[2]).toString();
        var jbPaths = [
            '/Applications/Cydia.app',
            '/Library/MobileSubstrate/MobileSubstrate.dylib',
            '/bin/bash', '/usr/sbin/sshd',
            '/etc/apt', '/private/var/lib/apt/'
        ];
        if (jbPaths.indexOf(path) !== -1) {
            this.shouldFake = true;
            console.log('[+] Hide JB path: ' + path);
        }
    },
    onLeave: function (retval) {
        if (this.shouldFake) retval.replace(0);
    }
});

// Intercept fork() — jailbroken devices can fork, non-jailbroken return -1
var fork = Module.findExportByName(null, 'fork');
Interceptor.replace(fork, new NativeCallback(function () {
    return -1;
}, 'int', []));
```

One-command unpacking (for uploading to jadx or similar for decompilation):

```bash
frida-ios-dump -l com.target.app
# Outputs Payload/TargetApp.app + an unpacked Mach-O
```

## Suggestions for This Package

- Add a new sub-skill `ios-reverse/` (parallel to `apk-reverse/`) covering: unpacking, jailbreak detection bypass, SSL Pinning, Keychain dump, frida-ios-dump, and `+load` timing.
- The existing `apk-reverse/` should not carry iOS content, to avoid confusion.

## Reusable Patterns/Script Snippets

**iOS security testing quick reference**:

```text
1. Prepare jailbreak environment (Dopamine 16.x / older palera1n)
2. Unpack with frida-ios-dump
3. Inspect class hierarchy with otool / class-dump
4. Start the objection console
5. ios jailbreak disable
6. ios sslpinning disable
7. Capture traffic with mitmproxy (system certificate + trust settings both enabled)
8. After locating key logic, perform static deep-dive with IDA / Hopper
```

## Evolution Actions
- [ ] **Suggest adding an ios-reverse skill** (the current routing matrix sends iOS through reverse-engineering/platforms.md, which is not granular enough)
- [ ] Add frida-ios-dump to the bootstrap manifest
- [ ] Add an "iOS Security Testing Checklist" to references/

## Environment Information
- Jailbroken device: iPhone X (iOS 16.5) + Dopamine 1.1.7
- Host: macOS 13+ / Kali (mitmproxy + frida-tools)
- frida-server-ios: 16.x

## Anonymization Requirements
This entry is seed data, written based on public technical patterns, and does not involve real targets. The Bundle ID `com.target.app` is a placeholder.
