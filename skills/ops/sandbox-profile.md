# Optional Sandbox Tool Profile (Compared to bootstrap-manifest)

> Z3r0's default image has a comprehensive tool set; reverse-skill **does not bundle images**, and uses this table for "coverage comparison" and optional Docker recommendations.

## Capabilities reverse-skill Can Auto-Bootstrap

Source: `skills/scripts/bootstrap-manifest.json` (the file is authoritative):

| Capability | Typical Scenario |
|------|----------|
| jadx / apktool / adb / frida / frida-ps | Android |
| r2 / rabin2 | Binary CLI |
| idalib-mcp / idapro | IDA MCP |
| jeb-pro | Commercial Android / ARM decompiler (manual licensed installation) |
| jshookmcp / reqable-mcp / anything-analyzer / agent-browser | Web/JS/packet capture/browser |
| ghidra-mcp | Ghidra |
| nmap / seclists / proxycat / burpsuite-mcp / pentestswarm | Penetration testing |
| binwalk / pwntools / yara | Firmware/pwn/malware |

```powershell
powershell -File skills\scripts\bootstrap-reverse.ps1 -Capability @('jadx','nmap','yara') -StartServices
powershell -File skills\scripts\refresh-tool-index.ps1
```

## Common in Z3r0 Sandbox but Not Auto-Installed by This Package's Manifest

| Tool | reverse-skill Strategy |
|------|-------------------|
| subfinder / amass / httpx / ffuf / nuclei / sqlmap | Documented installation / Kali scripts / external MCP; **do not pretend bootstrap already has them** |
| Full Ghidra GUI | ghidra-mcp capability + manual plugin steps |
| gdb / pwndbg | Platform documentation manual; pwntools can be bootstrapped |
| hydra / hashcat | Manual or Kali |
| JEB Pro | Manual installation after the user holds a license; third-party MCP bridges must first complete supply chain review |
| Reqable desktop client | User manual installation; `reqable-mcp` only registers the official pinned version of the MCP runtime |
| SecLists | seclists capability |

## Recommended "Lightweight Docker Engagement" Profile (Optional, Not a Dependency)

Only when the user **themselves** has Docker and an authorized lab:

```text
Minimal: nmap + nuclei + sqlmap containers or pentestMCP-style images
Mobile: jadx + apktool + frida on the host
Reverse engineering: host IDA/r2 + tool-index
```

**MUST NOT** require users to install Z3r0 in order to use reverse-skill.

## network_profile Integration

Scanning inside the sandbox is still constrained by the case `scope.md`'s `network_profile`:

- `offline` → not recommended to start outbound scanning containers  
- `authorized_target_only` → containers can only attack in_scope  
