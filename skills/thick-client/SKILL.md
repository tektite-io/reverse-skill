---
name: thick-client
description: Use for authorized security testing of desktop thick clients including local storage, update channels, IPC, traffic, and client-side trust boundaries.
---

# Thick Client Security Testing

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-pentest.md`
2. `NOW`: Confirm the target is a **desktop thick client** (Win/macOS/Linux GUI or service companion), not pure web
3. `NOW`: case-init; record the installer source and test accounts in scope
4. `NEXT`: Tools (Burp upstream proxy, process monitoring, reverse-engineering tools)
5. `ACT`: Trust boundary map → local surface → network surface → update/supply chain

## Applicable Scenarios

- C/S architecture clients, Electron/Qt/.NET WinForms/WPF
- Local config/credential storage, IPC, named pipes
- Research on bypassing client-side enforcement (authorized)
- Auto-update channels and code-signing verification

## Workflow

### 1. Build the boundary

```text
□ Process tree, child processes, drivers/services
□ Listening ports and outbound domains
□ Local sensitive paths: %APPDATA%, Keychain, registry
```

### 2. Local attack surface

```text
□ Plaintext config, hardcoded keys, debug switches
□ DLL hijacking / search order (Windows)
□ Database files (SQLite) permissions and encryption
□ IPC: who can connect? Is it authenticated?
```

### 3. Network surface

```text
□ System proxy / application custom TLS
□ Certificate pinning → combine mobile/js methodology or Frida
□ API authorization flaws: admin interfaces hidden in the client
```

### 4. Reverse-engineering verification

```text
□ .NET → dotnet-reverse; native → ida/ghidra; Electron → asar + js-reverse
```

## Toolchain

| Tool | Purpose |
|------|------|
| Process Monitor / API Monitor | Behavior |
| Burp / mitmproxy | Traffic |
| dnSpy / IDA / Ghidra | Reverse engineering |
| Sysinternals | Windows surface |
| asar / nexe detection | Electron |

## References

- `references/thick-client-checklist.md`
- `../dotnet-reverse/` `../ida-reverse/` `../js-reverse/` `../api-security/`

## Routing Context

**Upstream**: MASTER R32  
**Downstream**: Pure protocol → `protocol-reverse`; supply-chain updates → `supply-chain-security`

## Task Completion Self-Check

- [ ] Is the trust boundary diagrammed?
- [ ] Are both local and network surfaces covered?
- [ ] Checklist reviewed?
