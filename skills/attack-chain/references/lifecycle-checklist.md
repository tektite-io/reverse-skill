# Penetration/Attack Chain Lifecycle Checklist

> Aligned with community pentest skill packages (e.g., Orizon claude-code-pentest six stages) and integrated with this package's `attack-chain` + `ops`.
> Source inspiration: Public Claude pentest lifecycle skills (retrieved 2026-07); **commands and authorization are subject to this package's scope**.
> Date: 2026-07-17

## Before Use

- [ ] `case-init` completed, `auth.status=granted`
- [ ] `network_profile` ≠ misusing unrestricted to attack production
- [ ] `lead` has designated specialist_roles (`ops/role-map.md`)

## Stage Gates

| Stage | Role | This Package's Skill | Completion Criteria |
|------|------|------------|----------|
| 0 Scope | lead | ops/scope-contract | ready_for_act |
| 1 Recon | cie | pentest-tools | Asset list + timeline |
| 2 Enum/Vuln | cpe | pentest-tools / api-security | Candidate F-* drafts |
| 3 Validate | cpe | pentest-tools | E-* + validated Finding |
| 4 Post-ex (if authorized) | cpe/lead | attack-chain second half | Does not exceed out_of_scope |
| 5 RE Support | cre | ida/apk/js/… | Only when client/binary is needed |
| 6 Report | doc | docs-generator | Evidence→Finding→Path |
| 7 Journal | lead | field-journal | Redacted |

## Differences from "Fully Automated Domain-to-Compromise" Skills (Features)

| Common in External Automation Packages | reverse-skill |
|------------------|---------------|
| Defaults to aggressively scanning the domain | Must scope asset list |
| Writes reports directly from weak evidence | Enforces E/F/P chain |
| Single session without roles | role-map handoff |
| No tool index | tool-index + bootstrap |

## At Least One Timeline Entry Per Stage

See `ops/timeline-workitem.md` for the format.
