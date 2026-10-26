# [Seed] APK Frida Bypass of OkHttp SSL Pinning

## Scenario Classification
APK Reverse Engineering / Mobile Security Testing

## Goal Overview
For an Android app using OkHttp + a custom CertificatePinner, dynamically bypass certificate validation with Frida so Burp can capture plaintext traffic.

## Complete Execution Chain

1. Install Frida + frida-server, launch the target app, and confirm the process name.
   ```bash
   adb shell "ps -A | grep com.target.app"
   frida-ps -U | grep target
   ```
2. Attempt to capture traffic with Burp → get a certificate error, indicating that pinning is enabled.
3. Open the APK in jadx to decompile → search for `CertificatePinner` or `checkServerTrusted`.
4. Determine whether it uses OkHttp's built-in `CertificatePinner` or a custom `X509TrustManager`.
5. Write a Frida script to hook the key validation points.
6. Start Frida injection: `frida -U -f com.target.app -l bypass.js --no-pause`.
7. Capture traffic again → Burp can see plaintext HTTPS.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Frida startup error `unable to connect to remote frida-server` | Server not started or port already in use | `adb forward tcp:27042 tcp:27042` + start the server | 10min |
| Hook does not take effect | App starts too fast; Frida injection is too late | Use `-f` spawn mode together with `--no-pause` | 15min |
| Some requests still have SSL errors after hooking | App uses both OkHttp and native HttpsURLConnection | Add hooks for `X509TrustManager.checkServerTrusted` and `HostnameVerifier.verify` | 20min |
| Anti-detection: app exits after detecting Frida | App self-checks the frida-server port / `/data/local/tmp/re.frida.server` | Switch to frida-gadget (inject a .so into the APK) or magisk + zygisk-frida | 30min+ |
| Class names not found after ProGuard obfuscation | Class names are shortened to `a.b.c` | In jadx, use `Find Usages` to trace who instantiates OkHttpClient.Builder | 25min |

## Toolchain Findings

- **objection** has a built-in `android sslpinning disable` command that handles 80% of cases without writing your own Frida script.
- **frida-multiple-unpinning** (GitHub: WithSecureLabs) covers OkHttp 3/4, Retrofit, HttpsURLConnection, Conscrypt, and Cordova — a universal script.
- The **MEDUSA** framework includes various Android bypass modules and is faster to get started with than raw Frida.

## Key Code/Commands

Minimal working OkHttp pinning bypass script:

```javascript
Java.perform(function () {
    // 1. OkHttp 3/4 built-in CertificatePinner
    try {
        var CertificatePinner = Java.use('okhttp3.CertificatePinner');
        CertificatePinner.check.overload('java.lang.String', 'java.util.List').implementation = function (host, peers) {
            console.log('[+] OkHttp CertificatePinner.check bypassed: ' + host);
            return;
        };
    } catch (e) {}

    // 2. Custom X509TrustManager.checkServerTrusted
    try {
        var TrustManagerImpl = Java.use('com.android.org.conscrypt.TrustManagerImpl');
        TrustManagerImpl.verifyChain.implementation = function (untrusted, holdHost, host, clientAuth, ocspData, tlsSctData) {
            console.log('[+] TrustManagerImpl.verifyChain bypassed: ' + host);
            return untrusted;
        };
    } catch (e) {}

    // 3. HostnameVerifier pass-through
    var HostnameVerifier = Java.use('javax.net.ssl.HostnameVerifier');
    // Complete using objection's built-in template...
});
```

One-command approach (recommended):

```bash
objection --gadget com.target.app explore -s "android sslpinning disable"
```

## Suggestions for This Package

- `apk-reverse/references/` should have a dedicated `ssl-pinning-bypass.md` that consolidates the four mainstream cases — OkHttp 3/4, Conscrypt, custom TrustManager, and Flutter (BoringSSL) — into a quick reference.
- Add `objection` (pip package) to the bootstrap manifest.

## Reusable Patterns/Script Snippets

**Universal bypass workflow**:

```text
1. Capture traffic → identify the error type (CertPin / Hostname / TrustManager)
2. Search for key classes in jadx (CertificatePinner / X509TrustManager / HostnameVerifier)
3. Try objection's one-command first → then frida-multiple-unpinning → then write your own
4. If anti-Frida detection exists → switch to frida-gadget or zygisk
5. Handle Flutter apps separately (hook libflutter.so's ssl_verify_peer_cert)
```

## Evolution Actions
- [x] Routing matrix already covers this (apk-reverse + Frida)
- [x] Frida status in tool-index has been checked
- [ ] Suggest adding ssl-pinning-bypass.md quick reference

## Environment Information
- Kali / Windows + adb + frida-tools 16.x
- Target Android: 8–14 (the TrustManagerImpl path differs by version)
- Injection method: USB debugging + frida-server / or zygisk-frida for hiding

## Anonymization Requirements
This entry is seed data, written based on public technical patterns, and does not involve real targets. The package name `com.target.app` is a placeholder.
