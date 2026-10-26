# [Date] [Project Short Name]

## Scenario Classification
<!-- APK Reverse Engineering / JS Signature / Binary Analysis / Penetration Testing / CTF / Packet Capture Analysis / Other -->

## Goal Overview
<!-- One sentence describing what you are doing -->

## Scope Summary (Anonymized)
<!-- auth.basis / network_profile.mode / in_scope types (do not write real domains/IPs) -->
- auth_basis:
- network_profile:
- asset_types: []

## Roles
<!-- lead / cie / cpe / cre / ... see skills/ops/role-map.md -->
- lead_role: lead
- specialists: []

## Complete Execution Chain
<!-- Complete steps from receiving the target to producing results, including dead ends -->

1. ...
2. ...
3. ...

## Evidence Chain Summary (Anonymized)
<!-- At most 3 entries: E-id + command pattern + conclusion type; full evidence stays in the user's project -->
<!-- Fields align with the skills/case-review/scripts/review_case.py contract (see notes below) -->
| E-id | severity | status | source_type | Reusable command pattern | Linked Finding |
|------|----------|--------|-------------|--------------------------|----------------|
| E-001 | info | observed | command | `checksec --file=./pwn1` | F-001 |
| E-002 | high | validated | command | `python3 exploit.py REMOTE` | F-001 |

> **Contract alignment (review_case.py)**: If this case produced a separate evidence directory (`evidence/E-xxx.md`),
> each evidence entry must satisfy the field contract of `skills/case-review/scripts/review_case.py`; otherwise the `--strict` check will FAIL:
>
> - Title: `### E-xxx` (must match the filename, e.g., `E-001.md` → `### E-001`)
> - `- severity:` ∈ critical / high / medium / low / info / n/a
> - `- status:` ∈ observed / candidate / validated / false_positive / accepted_risk
> - `- repro_command:` required (for offline scenarios, note offline in notes to be exempt)
> - `- content_hash:` sha256 or n/a; when sha256 is provided, include `- artifact_path:` (relative path within the case)
> - `- linked_workitem:` optional; WI-xxx must actually exist
>
> Self-check: `python skills/case-review/scripts/review_case.py <case_root> --verify-hashes --strict`

## Finding / Path Summary
- top_finding:
- path_type: attack | callflow | solve
- path_one_liner:

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| ... | ... | ... | ... |

## Toolchain Findings
<!-- Which tools were used, which worked well, which had pitfalls, version compatibility issues -->

## Key Code/Commands

```
<!-- Paste the key commands, hook scripts, and decryption logic actually used -->
```

## Suggestions for This Package
<!-- Is routing accurate? Is bootstrap missing anything? Do docs need supplements? Do new tools need to be added to the manifest? -->

## Reusable Patterns/Script Snippets
<!-- If reusable hook scripts, decryption logic, or bypass solutions were produced, paste them here -->

## Evolution Actions
<!-- Which updates were actually performed after this write-back -->
- [ ] Updated the routing matrix
- [ ] Updated tool-index
- [ ] Updated bootstrap-manifest
- [ ] Updated sub-skill documentation
- [ ] Added pitfall records
- [ ] No update needed

## Environment Information
<!-- Record the key environment at the time -->
- OS:
- Tool versions:
- Target platform/version:

## Anonymization Requirements

> **This file may be synced to a remote repository with the repo and must be anonymized. See [anonymization.md](anonymization.md) for the full specification (placeholder master table + automated detection script).**

- Target domain/IP: replace with `{target_domain}` / `{target_ip}` (see `anonymization.md` for details)
- Real URL paths: keep the structure, replace the domain
- Token/Cookie/password/JWT/API key: use `{token}` / `{password}` / `{api_key}` as placeholders
- Username/phone number/email: use `{username}` / `{phone}` / `{user_email}` as placeholders
- Internal IP/port: keep the first two octets of internal IP ranges (`10.0.x.x`)
- Vulnerability payloads: technical content may be kept, but replace target-specific parameters (e.g., `?id={user_id}`)

Before committing, run a regex scan against the **Field-Journal required-items checklist** at the end of `anonymization.md`.

If this is a private repository and you are certain it will not be made public, these restrictions may be relaxed, but anonymization is still recommended.

## Index Synchronization (final step before committing)

After writing this log, you must synchronize `_index.md`:

1. Add a line to the corresponding subsection under "By Scenario Category" (including date and keywords).
2. Append this filename under the corresponding technology in "High-Frequency Success Patterns (by Technology)".
3. Append this filename under the corresponding entity in "Entity Inverted Index (by Target Characteristics)".
4. Update the total count in "Cumulative Statistics" and the "Last updated" date.

---
<!-- [Evolution Stats] Cumulative completed projects in this package: N | New patterns added this time: X | Toolchain issues fixed this time: Y -->
<!-- [Community Contribution] After completion, ask the user whether to PR to the main repository. See CONTRIBUTE-BACK.md for the process. -->
