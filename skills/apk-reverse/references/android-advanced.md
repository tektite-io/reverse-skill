# Android Advanced Reverse Engineering Reference

> Covers Native SO analysis, advanced Frida usage, SSL Pinning bypass, Root detection countermeasures, packer unpacking, and Flutter/React Native reverse engineering.

---

## Native SO Reverse Engineering

### Analysis Workflow

```text
1. Extract .so files from the APK
   unzip app.apk lib/arm64-v8a/*.so -d extracted/

2. Confirm architecture and basic information
   file libxxx.so
   rabin2 -I libxxx.so

3. Find JNI entry points
   - Search for JNI_OnLoad (dynamic registration)
   - Search for Java_com_xxx_yyy (static registration)
   - nm -D libxxx.so | grep -i java

4. Load and analyze in IDA/Ghidra
   - Import JNI headers (jni.h types)
   - Annotate JNIEnv* parameters
   - Find RegisterNatives calls (dynamically registered function table)

5. Locate critical logic
   - Trace from Java-layer native method names
   - Cross-reference from strings (keys, URLs, error messages)
   - Trace from crypto library function (AES/MD5/SHA) calls
```

### JNI Function Registration

```c
// Static registration: function name = Java_packageName_className_methodName
JNIEXPORT jstring JNICALL Java_com_example_app_Security_getSign(
    JNIEnv *env, jobject thiz, jstring input) { ... }

// Dynamic registration: call RegisterNatives in JNI_OnLoad
static JNINativeMethod methods[] = {
    {"getSign", "(Ljava/lang/String;)Ljava/lang/String;", (void*)native_getSign},
};

JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *reserved) {
    JNIEnv *env;
    vm->GetEnv((void**)&env, JNI_VERSION_1_6);
    jclass clazz = env->FindClass("com/example/app/Security");
    env->RegisterNatives(clazz, methods, sizeof(methods)/sizeof(methods[0]));
    return JNI_VERSION_1_6;
}
```

### Tips for Analyzing JNI in IDA

```text
1. Import JNI type library
   File → Load File → Parse C Header → jni.h

2. Annotate the first parameter as JNIEnv*
   Right-click parameter → Set type → JNIEnv*
   This way calls like env->FindClass / env->GetMethodID are automatically recognized

3. Find RegisterNatives
   Search for calls to JNIEnv vtable offset 0x35C (ARM64)
   → The third parameter is the JNINativeMethod array
   → Extract all native function addresses from the array
```

---

## Advanced Frida Usage

### Hook Native Functions

```javascript
// Hook libc functions
Interceptor.attach(Module.findExportByName("libc.so", "open"), {
    onEnter: function(args) {
        this.path = args[0].readUtf8String();
        console.log("[open] " + this.path);
    },
    onLeave: function(retval) {
        if (this.path.includes("su") || this.path.includes("magisk")) {
            console.log("[open] Blocked root check: " + this.path);
            retval.replace(-1);  // Return failure
        }
    }
});

// Hook functions in custom SO
var base = Module.findBaseAddress("libsecurity.so");
var targetFunc = base.add(0x1234);  // Offset address
Interceptor.attach(targetFunc, {
    onEnter: function(args) {
        console.log("arg0: " + args[0].readUtf8String());
    },
    onLeave: function(retval) {
        console.log("return: " + retval.readUtf8String());
    }
});
```

### Hook Java Methods

```javascript
Java.perform(function() {
    // Hook instance methods
    var Security = Java.use("com.example.app.Security");
    Security.getSign.implementation = function(input) {
        console.log("[getSign] input: " + input);
        var result = this.getSign(input);  // Call original method
        console.log("[getSign] output: " + result);
        return result;
    };

    // Hook constructors
    Security.$init.overload('java.lang.String').implementation = function(key) {
        console.log("[Security.<init>] key: " + key);
        this.$init(key);
    };

    // Hook overloaded methods
    Security.encrypt.overload('java.lang.String', 'int').implementation = function(data, mode) {
        console.log("[encrypt] data=" + data + " mode=" + mode);
        return this.encrypt(data, mode);
    };
});
```

### Memory Search and Modification

```javascript
// Search for strings in memory
Process.enumerateModules().forEach(function(module) {
    if (module.name === "libtarget.so") {
        Memory.scan(module.base, module.size, "48 65 6C 6C 6F", {  // "Hello"
            onMatch: function(address, size) {
                console.log("Found at: " + address);
            }
        });
    }
});

// Modify memory (patch instruction)
var addr = Module.findBaseAddress("libsecurity.so").add(0x5678);
Memory.patchCode(addr, 4, function(code) {
    var writer = new Arm64Writer(code, {pc: addr});
    writer.putNop();  // Replace with NOP
    writer.flush();
});
```

---

## SSL Pinning Bypass

### General Solution (Recommended)

```javascript
// Frida general SSL Pinning bypass
// Source: https://github.com/0xCD4/SSL-bypass
Java.perform(function() {
    // 1. TrustManager bypass
    var TrustManager = Java.registerClass({
        name: 'com.custom.TrustManager',
        implements: [Java.use('javax.net.ssl.X509TrustManager')],
        methods: {
            checkClientTrusted: function(chain, authType) {},
            checkServerTrusted: function(chain, authType) {},
            getAcceptedIssuers: function() { return []; }
        }
    });

    // 2. SSLContext replacement
    var SSLContext = Java.use('javax.net.ssl.SSLContext');
    var sslContext = SSLContext.getInstance("TLS");
    sslContext.init(null, [TrustManager.$new()], null);

    // 3. OkHttp CertificatePinner bypass
    try {
        var CertificatePinner = Java.use('okhttp3.CertificatePinner');
        CertificatePinner.check.overload('java.lang.String', 'java.util.List').implementation = function() {};
    } catch(e) {}
});
```

### Bypass by Framework

| Framework | Bypass Method |
|------|---------|
| OkHttp3 | Hook `CertificatePinner.check` to return empty |
| Retrofit | Same as OkHttp (uses OkHttp underneath) |
| Volley | Hook `HurlStack`'s SSL factory |
| Flutter | Hook `dart:io`'s `SecurityContext` (requires special script) |
| React Native | Hook `OkHttpClientProvider` |
| WebView | Hook `WebViewClient.onReceivedSslError` |

### Flutter Specifics

```javascript
// Flutter SSL Pinning bypass (requires finding the ssl_verify_peer_cert function)
var flutter_lib = Module.findBaseAddress("libflutter.so");
// Search for ssl_verify_peer_cert's signature
var pattern = "FF 03 05 D1 FD 7B 0F A9";  // ARM64 signature
Memory.scan(flutter_lib, Module.findModuleByName("libflutter.so").size, pattern, {
    onMatch: function(address) {
        Interceptor.replace(address, new NativeCallback(function() {
            return 0;  // Return success
        }, 'int', []));
    }
});
```

---

## Root Detection Bypass

### Common Detection Methods

| Detection Method | Bypass Method |
|---------|---------|
| Check for `/system/app/Superuser.apk` | Hook `File.exists()` to return false |
| Check for `su` command | Hook `Runtime.exec()` to intercept su calls |
| Check `/proc/self/mounts` | Hook file reads, filter magisk-related |
| SafetyNet/Play Integrity | Magisk Hide / Zygisk + Shamiko |
| Check Magisk package name | Randomize Magisk package name |
| Check `/data/adb/` | Hook `opendir`/`access` |

### Frida General Root Bypass

```javascript
Java.perform(function() {
    // Hook File.exists
    var File = Java.use("java.io.File");
    File.exists.implementation = function() {
        var path = this.getAbsolutePath();
        var blacklist = ["su", "Superuser", "magisk", "busybox", "xposed"];
        for (var i = 0; i < blacklist.length; i++) {
            if (path.toLowerCase().includes(blacklist[i])) {
                return false;
            }
        }
        return this.exists();
    };

    // Hook System.getProperty
    var System = Java.use("java.lang.System");
    System.getProperty.overload('java.lang.String').implementation = function(key) {
        if (key === "ro.debuggable" || key === "ro.secure") {
            return "1";
        }
        return this.getProperty(key);
    };
});
```

---

## Packer/Shell Identification and Unpacking

### Common Packer Vendors

| Packer | Identification Feature | Unpacking Method |
|------|---------|---------|
| 360 Packer | `libjiagu.so`, `com.stub.StubApp` | FART / Frida dump dex |
| Tencent Legu | `libshell*.so`, `com.tencent.StubShell` | FART / BlackDex |
| Bangcle | `libDexHelper.so`, `com.secneo.apkwrapper` | FART |
| Ijiami | `libexec.so`, `s.h.e.l.l` | Frida dump |
| NetEase Yidun | `libnesec.so` | Frida dump |
| Naga | `libnaga.so` | Frida dump |

### General Unpacking Methods

```text
Method 1: FART (ART Environment Unpacking)
- Flash FART ROM or use Frida version of FART
- Automatically dump all dex files loaded by ClassLoader

Method 2: Frida DEX Dump
- frida -U -f com.target.app -l dex_dump.js
- Hook at DexFile::OpenMemory, dump dex from memory

Method 3: BlackDex
- Root-free unpacking tool
- Install BlackDex APK directly, select target app to unpack

Method 4: Manual dump
- Use Frida to enumerate all ClassLoaders
- Find the app's ClassLoader → Obtain DexFile object
- Read dex memory region and save
```

### Frida DEX Dump Script

```javascript
Java.perform(function() {
    Java.enumerateClassLoaders({
        onMatch: function(loader) {
            try {
                var dexFiles = loader.getDexFileList();
                console.log("ClassLoader: " + loader);
                console.log("  DEX files: " + dexFiles);
            } catch(e) {}
        },
        onComplete: function() {}
    });
});
```

---

## React Native / Flutter Reverse Engineering

### React Native

```text
1. Extract APK → assets/index.android.bundle (JS code)
2. Format JS → Search for API addresses, keys, signing logic
3. If Hermes bytecode (.hbc file) is present → Decompile with hermes-dec
4. Hook: Use Frida to hook the Java-layer ReactBridge
```

### Flutter

```text
1. Flutter code is compiled into libapp.so (Dart AOT)
2. Cannot be directly decompiled into Dart source code
3. Analysis methods:
   - reFlutter tool: patch libflutter.so to obtain snapshot
   - Doldrums: Parse Dart snapshot to recover class/function information
   - Frida hook key functions in libflutter.so
4. Network analysis: Flutter does not use system proxy, requires special SSL handling
```

---

## Tool Quick Reference

| Tool | Purpose | Installation |
|------|------|------|
| jadx | Java decompilation | Already in bootstrap |
| apktool | Unpack/Repack | Already in bootstrap |
| Frida | Dynamic Hook | `pip install frida-tools` |
| Objection | Frida wrapper (more user-friendly) | `pip install objection` |
| MobSF | Automated mobile security analysis | Docker deployment |
| BlackDex | Root-free unpacking | APK installation |
| FART | ART unpacking | Flash ROM or Frida version |
| hermes-dec | Hermes bytecode decompilation | npm installation |
| reFlutter | Flutter reverse engineering aid | pip installation |
| Magisk + Shamiko | Root hiding | Flash |

---

## Reference Resources

| Resource | Description | Link |
|------|------|------|
| OWASP MASTG | Mobile Security Testing Guide | https://mas.owasp.org/ |
| FridaBypassKit | General bypass framework | https://github.com/okankurtuluss/FridaBypassKit |
| SSL-bypass | General SSL Pinning bypass | https://github.com/0xCD4/SSL-bypass |
| awesome-frida | Frida resource collection | https://github.com/dweinstein/awesome-frida |
| Android Security Awesome | Android security resources | https://github.com/ashishb/android-security-awesome |
