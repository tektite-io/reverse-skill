# Expert Role → Skill Mapping (No Multi-Agent Server)

> Role codenames are inspired by the Z3r0 expert team; **the implementation** is reverse-skill routing and handoff protocols, not process orchestration.

## Role Table

| Code | Name (localizable) | Responsibility | PRIMARY / Tool Skill |
|------|------------------|------|----------------------|
| **lead** | Lead / Commander | Task breakdown, scope definition, phase gating, report aggregation | `attack-chain/` or current PRIMARY hub; finish → `docs-generator/` |
| **cie** | Intelligence Collection | Asset discovery, exposure surface, relationships | `pentest-tools/` (recon); browser → `browser-automation/`; cloud surface → `cloud-k8s/` |
| **cpe** | Penetration Validation | Scanning, exploit validation, impact confirmation | `pentest-tools/`; API → `api-security/`; AD → `windows-ad/`; wireless → `wifi-wireless/`; database → `database-security/`; SSO → `identity-federation/`; OT → `ot-ics/` |
| **cre** | Reverse Engineering Analysis | Binary/firmware/mobile/frontend logic | `ida-reverse/` `ghidra-reverse/` `binary-ninja-reverse/` `radare2/` `apk-reverse/` `mobile-reverse/` `macos-reverse/` `js-reverse/` `browser-extension-reverse/` `dotnet-reverse/` `go-rust-reverse/` `firmware-pentest/` `hardware-security/` `malware-analysis/` `protocol-reverse/` `thick-client/` `reverse-engineering/` |
| **cae** | Code Audit | Source code/dependencies/supply chain | `code-audit/` + `supply-chain-security/` |
| **cbe** | Blue Team/Forensics | Hunting, detection, IR artifacts | `threat-hunting/` `digital-forensics/` |
| **cce** | Cryptography | Algorithms/protocols/key misuse | `reverse-engineering` pattern documentation |
| **llm** | AI Security | Prompt/Agent | `llm-security/` |
| **doc** | Documentation Officer | Reports/writeups/diagrams | `docs-generator/` + `diagram-generator/` |

## Lead Mandatory Protocol

```text
1. Output PRIMARY (master-route) + lead_role=lead
2. Write scope.md (ops/scope-contract)
3. Assign specialist_roles[] and handoff conditions
4. At the end of each phase: update timeline + workitems; decide to continue/switch roles/produce report
5. Prohibit skipping scope and directly using cpe to scan production
```

## Handoff Rules

| From → To | Trigger | Deliverable |
|---------|------|--------|
| lead → cie | Need asset surface | scope + known domains/IPs |
| cie → cpe | Live surface/services found | assets list + ports/URLs |
| cpe → cre | Need reverse validation/client logic | sample path + suspicious points |
| cre → cpe | Recovered protocol/key/validation | algorithm description + reproduction commands |
| any → doc | Phase or task complete | Evidence/Finding/Path draft |
| any → lead | Blocked/out of scope/path change | timeline note + blocked reason |

## How a Single Agent Uses This (Feature)

No need to actually spin up 6 Agents:

```text
Within the same session:
  [lead] plan
  [cie] execute recon skill
  [cpe] switch to pentest-tools
  …
Use role prefix tags in output for easy timeline retrieval:
  [cpe] nuclei high findings → E-003
```

## Relationship with master-route

- `master-route` determines the **PRIMARY skill**  
- `role-map` determines **who is responsible in the current phase** (can be written in scope.md)  
- Multi-phase tasks usually have PRIMARY as `attack-chain/`, redistributed by lead  

## MUST NOT

- Do not assume a Z3r0 session API exists  
- Do not launch additional scans on unauthorized targets for roles  
