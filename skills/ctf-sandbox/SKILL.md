---
name: ctf-sandbox
description: Thin PRIMARY for CTF / AWD / cyber range multi-type orchestration. Hands off to the sidecar CTF-Sandbox-Orchestrator. Use when the user says CTF, AWD, cyber range, or competition challenge and no more specific pwn/APK/IDA route already won.
---

# CTF sandbox entry (sidecar, not a second router)

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Run `../scripts/case-init.ps1`; do not ACT against the real external network before `auth.status=granted`. For competitions/cyber ranges, use `-NetworkProfile lab` or `offline`.
2. `NOW`: Open `../../CTF-Sandbox-Orchestrator/ctf-sandbox-orchestrator/SKILL.md` at the package root and continue according to its sandbox assumptions.
3. `MUST NOT` write 40+ `competition-*` sub-skills into `routing.json`. This entry is only a PRIMARY gate.
4. `ACT`: Let the orchestrator select one downstream `competition-*`. When the specific challenge type is already clear (pwn/ROP, APK, IDA), it should already be won by an earlier rule in `routing.json`; do not compete for it.

## Why a Separate Layer

`CTF-Sandbox-Orchestrator/` is a **GPL sidecar package**, whose authorization defaults to inside the sandbox. The core routing package remains MIT + `scope.md` gate. This skill only serves as a keyword entry and does not merge the competition tree into the core.

## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I run case-init / scope first, rather than treating "the user said CTF" as authorized external network access?
- [ ] Did I open the sidecar orchestrator, rather than treating the 40 sub-skills as PRIMARY?
- [ ] If the task is actually pwn/APK/IDA, did I let the more specific PRIMARY take over?
