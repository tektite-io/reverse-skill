# Frida Bypass Kit — Android Universal Security Bypass Framework

> Source: [FridaBypassKit](https://github.com/okankurtuluss/FridaBypassKit) (2025)
> Use cases: Bypassing root detection, SSL pinning, emulator detection, and anti-debugging during APK dynamic analysis

## Overview

FridaBypassKit is a Frida script that integrates four major bypass capabilities. It requires no customization for specific apps and works out of the box.

## Four Major Bypass Capabilities

### 1. Root Detection Bypass

- Hook `File.exists()` to hide su binaries
- Intercept root check calls in `Runtime.exec()`
- Hide root-related packages (Magisk, SuperSU, etc.) from PackageManager
- Modify system properties to make the device appear unrooted

### 2. SSL Pinning Bypass

- Hook `TrustManagerImpl.verifyChain()`
- Hook `TrustManagerImpl.checkTrustedRecursive()`
- Bypass certificate chain validation
- Return an empty certificate chain to avoid validation
- Compatible with OkHttp, Retrofit, and custom implementations

### 3. Emulator Detection Bypass

- Spoof TelephonyManager return values
- Return fake phone numbers and carrier names
- Modify Build properties

### 4. Anti-Debugging Bypass

- Hook `Debug.isDebuggerConnected()`
- Prevent debugger detection
- Bypass anti-debugging checks

## Usage

```bash
# Prerequisites
pip install frida-tools
adb push frida-server /data/local/tmp/
adb shell chmod 755 /data/local/tmp/frida-server
adb shell su -c /data/local/tmp/frida-server &

# Inject into target APP
frida -U -f com.example.app -l FridaBypassKit.js
```

## Other Recommended Frida Bypass Scripts

| Project | Features | Link |
|------|------|------|
| httptoolkit/frida-interception-and-unpinning | Directly MitM all HTTPS traffic | [GitHub](https://github.com/httptoolkit/frida-interception-and-unpinning) |
| 0xCD4/SSL-bypass | General non-customized SSL bypass | [GitHub](https://github.com/0xCD4/SSL-bypass) |
| incogbyte/ssl-bypass gist | Bypass common SSL pinning methods | [Gist](https://gist.github.com/incogbyte/1e0e2f38b5602e72b1380f21ba04b15e) |
| Zero3141/Frida-OkHttp-Bypass | Specifically for OkHttp CertificatePinner | [GitHub](https://github.com/Zero3141/Frida-OkHttp-Bypass) |

## Integration with This Package

In the `apk-reverse` workflow, use it in the following situations:

1. APP detects root and refuses to run → Enable Root Detection Bypass
2. HTTPS requests are not visible in cleartext during packet capture → Enable SSL Pinning Bypass
3. APP detects emulator and refuses to run → Enable Emulator Detection Bypass
4. APP crashes after attaching Frida → Enable Debug Detection Bypass

Recommended to use in combination: First run the complete FridaBypassKit, then make targeted adjustments.
