# Cybersecurity Skills Router — Kali Linux Special Edition

> This directory is a Kali Linux 2026.1 optimization adaptation layer. It is specifically optimized based on Kali 2026.1 (kernel 6.18), released in March 2026.
> The core knowledge base (skills/, CTF-Sandbox-Orchestrator/) is shared with the Windows version; the Kali-specific README and Bash entry points need to cover the Windows core capability names while additionally providing Kali-native tool/MCP capabilities.
> The [README-kali.md](../README-kali.md) in the root directory is only a short redirect; **this file is authoritative**.

---

## AI: Execute Immediately After Reading

```text
1. Detect the package root (the repository root containing skills/ and kali/)
2. Read kali/RULES-kali.md → global injection and tool scanning
3. bash kali/scripts/refresh-tool-index.sh
4. Share the operational chain with the main package:
   - skills/MASTER-ROUTING.md (or pwsh skills/scripts/master-route.ps1)
   - skills/scripts/case-init.ps1 → work/<case>/scope.md
   - ACT against the target only after auth.status=granted + network_profile
   - skills/ops/ (evidence chain / roles / timeline / IDENTITY)
5. Report configuration results to the user
```

For general Agent guidance, see the repository root [README_AI.md](../README_AI.md) (read this file only after Kali is detected).

---

## 0. Relationship with the Windows Version (Capability Name Alignment)

```text
Project root/
├── skills/                    # Shared: SKILL, routing, MASTER-ROUTING, ops, scripts, field-journal
├── CTF-Sandbox-Orchestrator/  # Shared: 40+ CTF sub-skills
├── kali/                      # ← You are here
│   ├── scripts/
│   │   ├── bootstrap-reverse.sh
│   │   ├── refresh-tool-index.sh
│   │   ├── bootstrap-manifest.json
│   │   └── lib/
│   │       └── tool-discovery.sh
│   ├── RULES-kali.md
│   └── README-kali.md
├── RULES.md                   # Windows version rules
└── Readme.md                  # Windows version documentation
```


### 0.1 Alignment Principles

The Kali-specific entry point is not a simple copy of the Windows README, but **the same set of core capability names + additional Kali capabilities**:

- Windows: `skills/scripts/bootstrap-reverse.ps1`
- Kali: `kali/scripts/bootstrap-reverse.sh`
- Regular Linux/macOS: `skills/scripts/bootstrap-reverse.sh`

JEB Pro is a commercial tool that users license and install themselves; Reqable MCP uses the official pinned version of `reqable-mcp-server`, but still requires a separate installation of the Reqable desktop client.

Kali scripts should cover the core capability names in the Windows manifest, such as `jadx`, `apktool`, `frida`, `jshookmcp`, `xquik-mcp`, `anything-analyzer`, `idapro`, `r2`, `adb`, `ghidra-mcp`, `seclists`, `burpsuite-mcp`, `nmap`, and `pentestswarm`; they can additionally support Kali-native tools such as `mcp-kali-server`, `metasploitmcp`, `hexstrike-ai`, `sstimap`, `xsstrike`, `netexec`, and others.

**Shared parts** (no changes needed):
- All `SKILL.md`, `routing.md`, `MASTER-ROUTING.md`
- `skills/ops/` operational contracts (scope / evidence chain / roles / timeline)
- All `references/` knowledge bases
- `field-journal/` self-evolution mechanism
- All of `CTF-Sandbox-Orchestrator/`
- `docs-generator/`, `diagram-generator/`
- `skills/scripts/case-init.ps1`, `master-route.ps1` (can be invoked with pwsh)

**Kali-specific parts**:
- All scripts are bash (`.sh`)
- Package management uses `apt`
- Path conventions are Linux-style (`/opt/`, `~/tools/`, `/usr/bin/`)
- Many tools are pre-installed on Kali, greatly simplifying the bootstrap logic

---

## 1. Kali's Natural Advantages

The following tools are **ready out of the box** in Kali 2026.1 (no bootstrap needed):

### Classic Pre-installed Tools

| Tool | Kali Package Name | Status |
|------|----------|------|
| nmap | nmap | Pre-installed |
| sqlmap | sqlmap | Pre-installed |
| hashcat | hashcat | Pre-installed |
| john | john | Pre-installed |
| hydra | hydra | Pre-installed |
| metasploit | metasploit-framework | Pre-installed |
| gobuster | gobuster | Pre-installed |
| ffuf | ffuf | Pre-installed |
| radare2 | radare2 | Pre-installed |
| binwalk | binwalk | Pre-installed |
| frida | python3-frida-tools | Pre-installed or via pip |
| burpsuite | burpsuite | Pre-installed |
| wireshark | wireshark | Pre-installed |
| nikto | nikto | Pre-installed |
| wfuzz | wfuzz | Pre-installed |
| impacket | impacket-scripts | Pre-installed |
| netexec | netexec | Pre-installed |
| responder | responder | Pre-installed |
| aircrack-ng | aircrack-ng | Pre-installed |
| bloodhound | bloodhound | Installable via apt |
| ghidra | ghidra | Installable via apt |

### New Tools in Kali 2026.1 (March 2026)

| Tool | Package Name | Purpose |
|------|------|------|
| AdaptixC2 | adaptixc2 | Post-exploitation and adversary simulation framework |
| Atomic-Operator | atomic-operator | Cross-platform Atomic Red Team test execution |
| Fluxion | fluxion | WiFi security auditing and social engineering |
| GEF | gef | Modern enhanced debugging framework for GDB |
| MetasploitMCP | metasploitmcp | MCP Server interface for Metasploit |
| SSTImap | sstimap | Automated detection and exploitation of server-side template injection |
| WPProbe | wpprobe | Fast WordPress plugin enumeration |
| XSStrike | xsstrike | Advanced XSS scanner |

### New Tools in Kali 2025.4 (December 2025)

| Tool | Package Name | Purpose |
|------|------|------|
| evil-winrm-py | evil-winrm-py | Python-based WinRM remote command execution |
| hexstrike-ai | hexstrike-ai | AI MCP security automation platform (150+ tools) |
| bpf-linker | bpf-linker | BPF static linker |

### Kali-Native MCP Tools (Key Optimization)

| Tool | Package Name | Purpose | Installation |
|------|------|------|------|
| mcp-kali-server | mcp-kali-server | Kali official MCP, AI directly invokes terminal tools | `apt install mcp-kali-server` |
| MetasploitMCP | metasploitmcp | Metasploit MCP interface | `apt install metasploitmcp` |
| HexStrike AI | hexstrike-ai | 150+ security tool MCP automation | `apt install hexstrike-ai` |

> **This is the biggest advantage of the Kali version over the Windows version**: the three MCP tools install directly via apt, with no manual GitHub/npm/Docker configuration.

This means the workload for `bootstrap-reverse.sh` on Kali is much smaller than on the Windows version.

---

## 2. Quick Start

### 2.0 One-Click Initialization (Recommended for New Systems)

```bash
# One-click configuration for a fresh Kali 2026.1 system (requires root)
sudo bash kali/scripts/quick-setup.sh

# Skip system updates (when the network is slow)
sudo bash kali/scripts/quick-setup.sh --skip-update

# Minimal installation (do not install AD/internal network tools)
sudo bash kali/scripts/quick-setup.sh --minimal
```

This script automatically completes: system update → install 2026.1 new tools → configure native MCP → install reverse engineering tools → refresh index → output report.

### 2.1 First-Time Configuration

```bash
# 1. Enter the project root directory
cd /path/to/cybersecurity-skills-router

# 2. Make the scripts executable
chmod +x kali/scripts/*.sh kali/scripts/lib/*.sh

# 3. Refresh the tool index (detect local tool status)
bash kali/scripts/refresh-tool-index.sh

# 4. View the results
cat skills/tool-index.md
```

### 2.2 One-Click Setup of Kali-Native MCP (Strongly Recommended)

```bash
# Install the Kali official MCP trio
bash kali/scripts/bootstrap-reverse.sh mcp-kali-server metasploitmcp hexstrike-ai

# After installation, MCP configuration is automatically written to ~/.claude/mcp.json
# If using Kiro, manually copy to ~/.kiro/settings/mcp.json
```

### 2.3 Install New 2026.1 Tools

```bash
# One-click install all new tools
bash kali/scripts/bootstrap-reverse.sh adaptixc2 atomic-operator sstimap xsstrike wpprobe fluxion gef

# AD/internal network penetration suite
bash kali/scripts/bootstrap-reverse.sh coercer evil-winrm-py netexec responder bloodhound certipy
```

### 2.4 Install Missing Tools

```bash
# Install a single tool
bash kali/scripts/bootstrap-reverse.sh jadx

# Install multiple tools
bash kali/scripts/bootstrap-reverse.sh jadx apktool frida jshookmcp

# Install and start services
bash kali/scripts/bootstrap-reverse.sh idapro --start-services
```

### 2.5 Let the AI Client Auto-Route

Tell your AI client to read `kali/RULES-kali.md`, and it will automatically complete global injection.

---

## 3. Path Conventions

| Purpose | Kali Path |
|------|----------|
| Tool installation directory | `~/tools/` or `/opt/` |
| jadx | `/opt/jadx/` or `~/tools/jadx/` |
| apktool | `/usr/local/bin/apktool` (apt) or `~/tools/apktool/` |
| Ghidra | `/opt/ghidra/` or `~/tools/ghidra/` |
| IDA Pro | `/opt/idapro/` (if a Linux version is available) |
| Android SDK | `~/Android/Sdk/` |
| SecLists | `/usr/share/seclists/` (apt) or `~/tools/SecLists/` |
| Node.js | `/usr/bin/node` (apt/nvm) |
| Python | `/usr/bin/python3` (bundled with the system) |
| MCP configuration | `~/.claude/mcp.json` or `~/.kiro/settings/mcp.json` |

---

## 4. Summary of Differences from the Windows Version

| Dimension | Windows Version | Kali Version |
|------|-----------|---------|
| Script language | PowerShell (.ps1) | Bash (.sh) |
| Package management | winget / GitHub Release ZIP | apt / pip / npm / GitHub Release tar.gz |
| Path separator | `\` | `/` |
| Environment variables | `%USERPROFILE%` | `$HOME` |
| Pre-installed tools | Almost none | Many security tools pre-installed |
| IDA startup | `start.ps1` | Manually start the Linux version of IDA; the script only registers/checks MCP unless a launcher has been added locally |
| MCP configuration path | `%USERPROFILE%\.claude\mcp.json` | `~/.claude/mcp.json` |
| Port detection | `TcpClient` | `nc -z` or `ss` |

---

## 5. Verification Checklist

```bash
# ─── Basic commands ───
java -version
python3 --version
pip3 --version
node -v
npx -v

# ─── Reverse engineering tools ───
jadx --version
apktool --version
adb version
frida --version
r2 -v
gdb --version          # GEF auto-loads

# ─── Penetration tools (pre-installed on Kali) ───
nmap --version
sqlmap --version
hashcat --version
hydra -h | head -1
msfconsole --version
gobuster version
ffuf -V
nuclei -version

# ─── New tools in Kali 2026.1 ───
sstimap -h 2>&1 | head -3
xsstrike -h 2>&1 | head -3
wpprobe --help 2>&1 | head -3
coercer -h 2>&1 | head -3
evil-winrm-py -h 2>&1 | head -3

# ─── AD/internal network tools ───
netexec --help 2>&1 | head -3
responder -h 2>&1 | head -3
certipy --version 2>&1 | head -1

# ─── Kali-native MCP ───
which kali-server-mcp && echo "mcp-kali-server OK"
which metasploitmcp && echo "metasploitmcp OK"
which hexstrike-ai && echo "hexstrike-ai OK"

# ─── Refresh tool index ───
bash kali/scripts/refresh-tool-index.sh

# ─── Check MCP services (if configured) ───
nc -z 127.0.0.1 5000 && echo "mcp-kali-server OK" || echo "mcp-kali-server offline"
nc -z 127.0.0.1 8085 && echo "metasploitmcp OK" || echo "metasploitmcp offline"
nc -z 127.0.0.1 13337 && echo "IDA MCP OK" || echo "IDA MCP offline"
nc -z 127.0.0.1 23816 && echo "anything-analyzer OK" || echo "anything-analyzer offline"
```

---

## 6. FAQ

### Q: What if the bundled radare2 on Kali is too old?

```bash
# Install the latest version from the official source
bash kali/scripts/bootstrap-reverse.sh r2
# The Kali version prefers apt installation/completion of radare2 by default; if you need the latest version, switch to GitHub/source per the platform documentation
```

### Q: I use Parrot OS / BlackArch; can I use this?

Yes. The scripts detect whether commands exist and are not tied to a specific distribution. Only the `apt`-related automatic installation may need to be changed to `pacman` (BlackArch).

### Q: How do I configure the Linux version of IDA Pro?

Install IDA to `/opt/idapro/`, then modify the `startScript` path for `idapro` in `kali/scripts/bootstrap-manifest.json`.

### Q: I want to use this system on both Windows and Kali

No problem. The `skills/` directory is synchronized via Git, and the experience in `field-journal/` is shared across both. The only difference is that when executing scripts, Windows uses `skills/scripts/*.ps1` and Kali uses `kali/scripts/*.sh`.
