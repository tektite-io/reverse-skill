# Universal Scope Contract (Hard Gate for Task Startup)

> **MUST**: Any security/reverse engineering/penetration task **MUST** land `scope.md` in the current user's analysis project under `work/<case>/` **before ACT**.
> No scope → only reading docs/routing is allowed; **prohibited** from actively scanning, hooking, or exploiting the target.
> The template is copyable; field names remain English keys for script validation.

## How to Initialize

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File skills\scripts\case-init.ps1 -Hint "<one-sentence task>" -CaseName "my-case"
# Default output: work/<case>/scope.md etc. in the current analysis project
# When calling the skill from another directory, specify explicitly: -ProjectRoot "C:\path\to\analysis-project"

# Legitimate local offline sample: auth granted + offline + explicit sample → ready_for_act=true
powershell -NoProfile -ExecutionPolicy Bypass -File skills\scripts\case-init.ps1 `
  -Hint "offline apk" -CaseName "my-sample" -Preset offline-sample -Sample ".\app.apk"
```

Linux / macOS / Kali:

```bash
bash skills/scripts/case-init.sh --hint "<one-sentence task>" --case-name "my-case"
# Default output: work/<case>/scope.md etc. in the caller's current analysis project
# When calling from another directory, specify explicitly: --project-root "/path/to/analysis-project"

# Legitimate local offline sample
bash skills/scripts/case-init.sh \
  --hint "offline apk" --case-name "my-sample" \
  --preset offline-sample --sample ./app.apk
```

`-PackageRoot` / `--package-root` is retained as a compatibility parameter; new workflows should use `ProjectRoot` / `--project-root` to indicate the project to which case artifacts belong.

## Complete scope.md Template

```markdown
# Case Scope

## meta
- case_id: {YYYYMMDD-short}
- created: {ISO-8601}
- operator: {name or local}
- project_root: {caller analysis project}
- primary_skill: {from master-route}
- lead_role: lead   # see ops/role-map.md
- specialist_roles: []  # e.g. cie, cpe, cre

## auth
- status: granted | pending | denied
- basis: written_contract | bug_bounty_scope | ctf_public | own_system | lab_only
- evidence_of_auth: {ticket/path or "CTF public" or "owner-operated"}
- MUST NOT proceed if status != granted

## in_scope
- assets: []          # hosts, domains, APK paths, binaries, URLs
- surfaces: []        # web, mobile, binary, network, api
- activities: []      # recon, reverse, exploit_validate, report

## out_of_scope
- assets: []
- activities: []      # e.g. DoS, phishing real users, data exfil

## network_profile
- mode: offline | lab_only | authorized_target_only | unrestricted_lab
- notes: |
    offline = no external packets (pure static/local samples)
    lab_only = lab/VM IPs only
    authorized_target_only = in_scope assets only
- MUST NOT use unrestricted against production without written auth

## deliverables
- report: true
- field_journal: true
- diagrams: true
- timeline: true

## constraints
- timebox: {}
- stealth: low | medium | high
- data_handling: anonymize | no_user_pii

## signoff
- ready_for_act: false
- checklist:
  - [ ] auth.status = granted
  - [ ] in_scope.assets non-empty OR offline sample path set
  - [ ] network_profile.mode chosen
  - [ ] out_of_scope reviewed
```

## Routing Hook (AI Must Execute)

```text
RULES / MASTER-ROUTING / SKILL:
  1) master-route → PRIMARY
  2) platform-native case-init or hand-write scope.md
  3) auth not granted → STOP, only allowed to supplement authorization materials
  4) ready_for_act = true → open PRIMARY SKILL.md → ACT
```

`case-guard -Force` / `case-guard --force` is a compatibility parameter and **must not** bypass `auth.status`, legitimate scope, network profile, or the `ready_for_act` hard gate.

## network_profile Quick Reference

| mode | Allowed | Prohibited |
|------|------|------|
| `offline` | Static analysis, local files, emulation | Any external connection, public network RPC |
| `lab_only` | Lab/CTF target network segments | Production/unauthorized IPs |
| `authorized_target_only` | in_scope list | Assets outside the list |
| `unrestricted_lab` | Isolated lab network (written) | Internet production |

## Features

- Pure Markdown, **no database**  
- Orthogonal to `tool-index` / bootstrap: scope governs "whether you can attack", tool-index governs "what to attack with"
