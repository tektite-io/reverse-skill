# reverse-skill PRIMARY Fast Path

> `scripts/master-route.ps1` and `scripts/master-route.sh` must maintain the same routing contract; the platform only changes the execution entry point, not the routing semantics.

## Execution Contract

```text
1. Route before acting
2. Output PRIMARY path + one-sentence rationale
3. case-init / scope.md (ops/scope-contract) — ACT on the target is prohibited unless auth is granted
4. Assign lead + specialist roles (ops/role-map)
5. Immediately open the PRIMARY SKILL.md → ACTION REQUIRED
6. Tool paths must come from tool-index only; if missing, bootstrap (manifest capabilities only)
7. Append timeline / workitems during the process; conclusions follow Evidence→Finding→Path
8. No match → read the full routing.md table or propose a new skill
```

### Windows

```powershell
powershell -File skills\scripts\master-route.ps1 -Hint "<user task>"
# By default, writes work/master-route-<ts>/route-scope.md in the current project; when invoked from another directory, explicitly specify the project root
powershell -File skills\scripts\master-route.ps1 -Hint "<user task>" -ProjectRoot "C:\path\to\analysis-project"
powershell -File skills\scripts\case-init.ps1 -Hint "<user task>" -CaseName "my-case"
# By default, case writes to work/<case>/ in the current project; -PackageRoot remains compatible, -ProjectRoot takes precedence
powershell -File skills\scripts\case-init.ps1 -Hint "<user task>" -CaseName "my-case" -ProjectRoot "C:\path\to\analysis-project"
# One-shot setup ready for ACT (authorization + target + network profile):
powershell -File skills\scripts\case-init.ps1 -Hint "<task>" -CaseName "my-case" -AuthGranted -TargetUrl "https://target/" -NetworkProfile authorized_target_only
# Local offline sample:
powershell -File skills\scripts\case-init.ps1 -Hint "offline apk" -CaseName "my-sample" -Preset offline-sample -Sample ".\app.apk"
# Smoke test: verify + script parsing + routing matrix (including Chinese hints)
powershell -File skills\scripts\smoke.ps1
# Lightweight scope gate before ACT (exit 2 if not ready; -Force is a compatibility parameter and cannot bypass the hard gate)
powershell -File skills\scripts\case-guard.ps1 -CaseRoot work\my-case
# Append Evidence
powershell -File skills\scripts\append-evidence.ps1 -CaseRoot work\my-case -Id E-001 -Title "..." -ReproCommand "..."
python3 skills/case-review/scripts/review_case.py work/<case> --verify-hashes --strict
```

### Linux / macOS / Kali

PowerShell is not required for the core route/case workflow:

```bash
bash skills/scripts/master-route.sh --hint "<user task>"
bash skills/scripts/master-route.sh --hint "<user task>" --project-root "/path/to/analysis-project"
bash skills/scripts/case-init.sh --hint "<user task>" --case-name "my-case"
bash skills/scripts/case-init.sh --hint "<user task>" --case-name "my-case" --project-root "/path/to/analysis-project"
# Local offline sample:
bash skills/scripts/case-init.sh --hint "offline apk" --case-name "my-sample" --preset offline-sample --sample ./app.apk
# Lightweight scope gate before ACT (--force is a compatibility parameter and cannot bypass the hard gate):
bash skills/scripts/case-guard.sh --case-root work/my-sample
# Routing parity:
bash skills/scripts/test-routing.sh
bash skills/scripts/test-bootstrap-manifest.sh
python3 skills/case-review/scripts/review_case.py work/<case> --verify-hashes --strict
```

## Engagement Contract (ops)

| Document | Purpose |
|------|------|
| `ops/IDENTITY.md` | We are a routing package, not the Z3r0 platform |
| `ops/scope-contract.md` | Startup gate |
| `ops/evidence-finding-path.md` | Evidence chain |
| `case-review/SKILL.md` | Evidence graph review and report handoff |
| `ops/role-map.md` | Role → skill |
| `ops/timeline-workitem.md` | Timeline and coverage |
| `ops/sandbox-profile.md` | Tool comparison |
| `ops/skill-supply-chain.md` | Security latch for installing external skill/MCP |
| `references/community-security-skills.md` | Community skill ecosystem (borrow without merging repositories) |
| `reverse-engineering/references/re-agent-workflow.md` | RE: triage→static→dynamic→synthesis |
| `pentest-tools/references/recon-pipeline.md` | Authorized reconnaissance pipeline + evidence gate |

## Priority (high → low)

> The order must match the `priority` array in `config/routing.json`. To change routing, change only the JSON, then update this table. `verify-routing-coherence.ps1` parses this table.

| ID | Condition | PRIMARY |
|----|------|---------|
| **R4** | DSL VM / fireye / custom opcode VM | `reverse-engineering/dsl-vm-reverse/` |
| **R1** | APK / smali / jadx / apktool | `apk-reverse/` |
| **R2** | IPA / iOS / Objection / MobSF / mobile | `mobile-reverse/` |
| **R3** | JS signature / frontend encryption / jshook / CDP | `js-reverse/` |
| **R30** | Browser extension reverse engineering | `browser-extension-reverse/` |
| **R31** | macOS / Mach-O | `macos-reverse/` |
| **R33** | Go / Rust binaries | `go-rust-reverse/` |
| **R5** | .NET / dnSpy / de4dot / ConfuserEx | `dotnet-reverse/` |
| **R9** | Malware samples / YARA / sandbox | `malware-analysis/` |
| **R21** | Protocol / Protobuf / PCAP protocols | `protocol-reverse/` |
| **R22** | Ghidra / open-source decompilation | `ghidra-reverse/` |
| **R45** | Binary Ninja / Binja / HLIL / MLIL / Binary Ninja MCP | `binary-ninja-reverse/` |
| **R6** | IDA / decompilation / deep disassembly | `ida-reverse/` |
| **R7** | radare2 / r2 | `radare2/` |
| **R8** | Firmware / binwalk / IoT / EMBA | `firmware-pentest/` |
| **R34** | Hardware debug ports / UART/JTAG | `hardware-security/` |
| **R28** | OT / ICS / industrial control | `ot-ics/` |
| **R17** | pwn / ROP / stack exploitation | `pwn-chain/` |
| **R16** | N-day / patch diffing | `patch-diff-exploit/` |
| **R18** | EDR / evasion / syscall | `edr-bypass-re/` |
| **R24** | Windows / AD / Kerberos / AD CS | `windows-ad/` |
| **R37** | Federated identity SAML/OIDC | `identity-federation/` |
| **R23** | Cloud / containers / K8s | `cloud-k8s/` |
| **R35** | Database security | `database-security/` |
| **R25** | Forensics / memory dumps / timeline | `digital-forensics/` |
| **R44** | OSINT / threat intelligence / public X IOC enrichment | `threat-intelligence/` |
| **R36** | Email / phishing analysis | `email-security/` |
| **R29** | Wi-Fi / wireless penetration | `wifi-wireless/` |
| **R38** | RF / SDR research | `radio-sdr/` |
| **R32** | Thick client security | `thick-client/` |
| **R26** | Code audit / SAST / Semgrep | `code-audit/` |
| **R27** | Threat hunting / detection engineering / blue team | `threat-hunting/` |
| **R10** | Attack chain / red team / lateral movement / full penetration | `attack-chain/` |
| **R11** | Nmap / Nuclei / SQLMap / SRC / penetration tools | `pentest-tools/` |
| **R12** | API / GraphQL / BOLA / JWT attacks | `api-security/` |
| **R13** | SBOM / Trivy / supply chain | `supply-chain-security/` |
| **R14** | LLM / Prompt injection / Agent security | `llm-security/` |
| **R15** | bindiff / symbol migration / PDB | `binary-diff/` |
| **R19** | Browser/desktop automation | `browser-automation/` |
| **R40** | Case / Evidence graph review | `case-review/` |
| **R20** | Reports / writeups | `docs-generator/` |
| **R39** | Diagrams / Mermaid / Graphviz / PlantUML / architecture diagrams | `diagram-generator/` |
| **R41** | CTF / AWD / cyber ranges (single entry, do not expand the 40 sub-skills) | `ctf-sandbox/` |
| **R0** | General reverse engineering / anti-debugging / OLLVM / unknown binaries | `reverse-engineering/` |

No strong keyword match → PRIMARY=`R0`, and prompt to open `routing.md` (ambiguity appendix, not a second router).

## Boundaries

| Task | Handling |
|------|------|
| Pure CTF multi-type orchestration | PRIMARY `ctf-sandbox/` → sidecar `../CTF-Sandbox-Orchestrator/` |

## Reading Order

```text
RULES.md → MASTER-ROUTING.md → PRIMARY SKILL.md
  → (optional) routing.md three axes / field-journal
  → tool-index.md → bootstrap → ACT
```
