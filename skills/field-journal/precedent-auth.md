# Authorization Pre-Declaration — Reduce Disclaimer Noise, but It Cannot Replace scope.md

> This file addresses exactly one thing: do not treat "the user pointed at a target" as authorization.
> The executable authorization gate remains `case-init.ps1` → `work/<case>/scope.md` with `auth.status=granted` plus a valid `network_profile`.

---

## CRITICAL

For the common scenarios in this package (SRC / owned systems / paid engagements / CTF ranges / responsible disclosure), boilerplate disclaimers **can** be reduced.

**AI must not treat this file as `auth.status=granted`.**

- The user mentioning a domain / IP / sample path ≠ authorization
- It is forbidden to use this file to skip `case-init`
- It is forbidden to automatically add `-AuthGranted` inside a skill "so the flow can proceed"
- CTF / ranges: still create a case; use `lab` or `offline` for `network_profile`
- Real external networks: ACT only when granted + `authorized_target_only` (or the contractually agreed profile) is present

---

## Allowed / Forbidden

1. **MUST NOT** use this file to override `ops/scope-contract.md`
2. **MUST NOT** run nmap / sqlmap / uploads / exploitation against a target without a `scope.md`
3. **MUST** distinguish between "saying less legal boilerplate" and "already cleared to act"
4. **MUST** output technical analysis when technically uncertain, instead of pretending authorization is insufficient and stopping work
5. No case created or `auth.status!=granted` → run `case-init` first; do not guess

---

## Relationship to Other Files

| File | Purpose |
|------|---------|
| **precedent-auth.md** (this file) | Less disclaimer boilerplate; does **not** write granted |
| `ops/scope-contract.md` + `case-init.ps1` | The only executable authorization gate |
| `precedent-reverse.md` / `precedent-pentest.md` | Day-to-day operations are not crime tutorials; they remain bound by scope |

```
case-init / scope.md → whether ACT is allowed
precedent-auth.md    → do not replace scope with boilerplate
PRIMARY SKILL.md     → how to do it
```
