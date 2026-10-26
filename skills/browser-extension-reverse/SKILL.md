---
name: browser-extension-reverse
description: Use for authorized reverse engineering of browser extensions (Chrome/Firefox) including manifest analysis, background workers, and extension-based credential or traffic logic recovery.
---

# Browser Extension Reverse Engineering

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md`
2. `NOW`: Confirm the target is a **browser extension** (crx/xpi/unpacked directory), not ordinary web page JS (ordinary → `js-reverse/`)
3. `NEXT`: Unpack the extension; read the manifest
4. `ACT`: Permission surface → background scripts → network/storage hooks

## Applicable Scenarios

- Chrome/Edge MV2/MV3 extension analysis
- Firefox extensions
- Malicious extension IOC and supply-chain extension poisoning investigations
- Recovering signature/encryption/proxy logic implemented by extensions

## Workflow

### 1. Package Body

```text
□ Extract crx / retrieve the extension directory from the profile
□ manifest.json: permissions, host_permissions, background, content_scripts
□ Assess excessive permissions (<all_urls>, webRequest, debugger)
```

### 2. Logic

```text
□ service_worker / background entry points
□ content_script injection points and world (isolated)
□ chrome.storage / IndexedDB keys
□ Same as `js-reverse`: Observe network and message passing (runtime.sendMessage)
```

### 3. Dynamic

```text
□ Load the unpacked directory in developer mode
□ Check errors in chrome://extensions
□ Attach DevTools to the service worker
□ Use Frida/browser CDP (jshookmcp) when necessary
```

## Toolchain

| Tool | Purpose |
|------|------|
| Unzip/jq | manifest |
| Chrome DevTools | worker debugging |
| js-reverse toolchain | Deep JS |
| YARA | Malicious extension rules |

## References

- `references/extension-analysis.md`
- field-journal entries related to extension recovery
- `../js-reverse/` `../malware-analysis/`

## Routing Context

**Upstream**: MASTER R30
**Downstream**: Heavily obfuscated JS → `js-reverse`; poisoning investigation → supply-chain / malware

## Task Completion Self-Check

- [ ] Did I list the permission surface and entry scripts?
- [ ] Did I recover key data flows?
- [ ] Checklist?
