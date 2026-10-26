# APK Security Testing Quick Reference

> Based on OWASP MASTG (Mobile Application Security Testing Guide).
> Covers six dimensions: static analysis, dynamic analysis, network communication, data storage, authentication and authorization, and code protection.

---

## Static Analysis Checklist

### Manifest Audit

```text
□ android:debuggable="true" → Debuggable (should not appear in production)
□ android:allowBackup="true" → Data can be backed up and extracted
□ Components with android:exported="true" → Exposed Activity/Service/Receiver/Provider
□ Custom permission protectionLevel → Is it normal (should be signature)
□ Scheme in intent-filter → Can custom deeplink be hijacked
□ android:usesCleartextTraffic="true" → Allows cleartext HTTP
□ minSdkVersion too low → May lack security features
```

### Key Points for Code Audit

```text
□ Hardcoded keys/Tokens (search for "key", "secret", "password", "api_key")
□ Insecure random numbers (java.util.Random instead of SecureRandom)
□ Insecure encryption (ECB mode, DES, MD5 used for passwords)
□ WebView configuration (setJavaScriptEnabled + addJavascriptInterface = RCE risk)
□ SQL injection (rawQuery concatenating user input)
□ Path traversal (ContentProvider's openFile does not validate path)
□ Log leakage (Log.d/Log.i outputting sensitive information)
□ Clipboard leakage (ClipboardManager storing sensitive data)
□ Implicit Intent leakage (sendBroadcast without specifying package name)
```

### Third-Party Library Audit

```text
□ Outdated OkHttp/Retrofit versions (known vulnerabilities)
□ Outdated WebView kernel
□ SDKs with known vulnerabilities (check CVEs)
□ Advertising SDK data collection scope
□ Push SDK configuration (whether token is leaked)
```

---

## Dynamic Analysis Checklist

### Frida Hook Priority Targets

| Target | Hook Point | Purpose |
|------|---------|------|
| Login Authentication | `LoginActivity.login()` | Observe credential handling |
| Signature Generation | `*Sign*`, `*sign*`, `*encrypt*` | Recover signing algorithm |
| SSL Pinning | `CertificatePinner.check` | Bypass packet capture |
| Root Detection | `*root*`, `*su*`, `*magisk*` | Bypass detection |
| Encryption Operations | `javax.crypto.Cipher` | Extract key/IV |
| Token Storage | `SharedPreferences.getString` | Observe token read/write |
| Network Requests | `OkHttpClient.newCall` | Observe request construction |

### Common Frida One-Liners

```bash
# Trace all encryption operations
frida-trace -U -f com.target.app -j '*Cipher*!*'

# Trace all HTTP requests
frida-trace -U -f com.target.app -j '*OkHttp*!*'

# Trace SharedPreferences read/write
frida-trace -U -f com.target.app -j '*SharedPreferences*!*'

# Trace all native function calls
frida-trace -U -f com.target.app -i 'Java_*'
```

### Objection Quick Commands

```bash
# Connect
objection -g com.target.app explore

# Common commands
android hooking list activities
android hooking list services
android sslpinning disable
android root disable
android clipboard monitor
env                              # View app directory
sqlite connect <db_path>         # Connect to database
```

---

## Network Communication Security

### Packet Capture Configuration

```text
Method 1: System proxy + Burp/mitmproxy
- Set WiFi proxy → Burp listener address
- Install CA certificate on device
- Android 7+ requires network_security_config or Frida bypass

Method 2: VPN mode (recommended)
- Use HttpCanary / Packet Capture
- No root required, no proxy configuration needed
- But cannot decrypt SSL Pinning traffic

Method 3: Frida + r2frida
- Intercept network calls directly within the process
- Not limited by proxy/VPN
```

### Check Items

```text
□ Is HTTPS used (all API calls)
□ Is SSL Pinning used (certificate pinning)
□ Is certificate validation correct (does not accept self-signed)
□ Is Certificate Transparency (CT) checked
□ Are API keys transmitted in cleartext in requests
□ Does Token have an expiration mechanism
□ Is there request signing to prevent tampering
□ Is there replay attack protection (nonce/timestamp)
□ Is WebSocket encrypted
□ Is there sensitive data in URL parameters (will be logged)
```

---

## Data Storage Security

### Check Locations

| Location | Risk | Check Command |
|------|------|---------|
| SharedPreferences | Cleartext storage of token/password | `adb shell cat /data/data/pkg/shared_prefs/*.xml` |
| SQLite Database | Unencrypted sensitive data | `adb pull /data/data/pkg/databases/` |
| External Storage | Readable by any app | `adb shell ls /sdcard/Android/data/pkg/` |
| Application Logs | Leaks debugging information | `adb logcat \| grep pkg` |
| Backup Files | allowBackup=true | `adb backup -f backup.ab pkg` |
| Keyboard Cache | Input history | Check if `inputType` is `textPassword` |
| Screenshot Protection | Sensitive pages can be screenshotted | Check `FLAG_SECURE` |

### Comparison of Encrypted Storage Solutions

| Solution | Security | Description |
|------|--------|------|
| SharedPreferences Cleartext | ❌ | Read directly after root |
| EncryptedSharedPreferences | ✓ | AndroidX Security library |
| SQLCipher | ✓ | Encrypted SQLite |
| Android Keystore | ✓✓ | Hardware-level key protection |
| Custom AES Encryption | ⚠️ | Depends on key management |

---

## Authentication and Authorization

### Common Vulnerabilities

| Vulnerability | Testing Method |
|------|---------|
| Weak Password Policy | Try 123456, password, etc. |
| No Lockout Mechanism | Brute-force login interface |
| Token Does Not Expire | Replay old token after logout |
| Unauthorized Access | Modify user_id in request |
| SMS Verification Code Brute-forceable | 4/6 digits without rate limiting |
| OAuth Misconfiguration | redirect_uri can be tampered with |
| Biometric Authentication Bypass | Hook BiometricPrompt |
| Device Binding Bypass | Modify device_id |

### Test Payload

```bash
# Unauthorized access test
curl -H "Authorization: Bearer USER_A_TOKEN" \
     "https://api.target.com/users/USER_B_ID/profile"

# Token replay
# 1. Normal login to obtain token
# 2. Logout
# 3. Request with old token → should return 401

# SMS verification code brute-force
for code in $(seq 0000 9999); do
    curl -X POST "https://api.target.com/verify" \
         -d "phone=13800138000&code=$code"
done
```

---

## Code Protection Assessment

| Protection Measure | Detection Method | Bypass Difficulty |
|---------|---------|---------|
| ProGuard Obfuscation | Use jadx to check if class names are a/b/c | Low (just renaming) |
| String Encryption | Search for decryption function, Hook to get cleartext | Medium |
| Anti-Debugging | Try attaching debugger | Medium (Frida can bypass) |
| Root Detection | Run on rooted device | Medium (general scripts bypass) |
| Emulator Detection | Run on emulator | Low-Medium |
| Integrity Check | Modify APK then install | Medium (patch check function) |
| Packer/Shell | View entry class and .so | Medium-High (requires unpacking) |
| Native Protection | Core logic in .so | High (requires IDA analysis) |
| VMP Virtualization | Code is virtualized for execution | Extremely High |

---

## Quick Testing Workflow (30 Minutes)

```text
1. [5min] Unpack + Manifest Audit
   apktool d app.apk
   Check debuggable/allowBackup/exported/cleartext

2. [10min] Quick Code Audit
   jadx -d out app.apk
   Search: password, key, secret, token, http://

3. [5min] Network Testing
   Configure proxy → Operate APP → Check for cleartext/weak encryption

4. [5min] Storage Check
   adb shell → Check shared_prefs and databases

5. [5min] Dynamic Verification
   Frida hook key functions → Confirm findings
```
