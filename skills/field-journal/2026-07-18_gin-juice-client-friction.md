# Modern Web Lab Friction → Skill Hardening

> Date: 2026-07-18
> Scenario: Legal public labs (PortSwigger-style scanner-eval / OWASP Juice Shop demo)
> Sanitization: No real business-domain exploitation details

## Conclusion (for the Next Agent)

**Failing to break through ≠ the package is useless.** You must still deliver: surface map, sink list, latch reasons, Evidence(observed|validated).
Failures must be written into the timeline and fed back into the playbook.

## Pitfalls

| Pitfall | Symptom | Fix/Discipline |
|----|------|-----------|
| case-init authorization polluted | After `-AuthGranted` the status becomes a strange string | Only allow pending/granted/denied/unknown; use `PSBoundParameters` to check AuthStatus |
| lab_only not ready | When network=lab_only, ready_for_act is false | lab_only + granted + assets → ready |
| Windows curl `[]` | `bad range in position` | **Must** use `curl.exe --globoff` |
| append-evidence special characters | RawExcerpt containing quotes/XML errors out | block indentation + strip control characters |
| Public demo 503 | Juice Shop Heroku down | Switch to local Docker or another legal lab; don't keep hammering it |
| DOM XSS false positive | Reports validated just because an innerHTML sink exists | Exploit requires a 200 non-numeric body; otherwise observed |
| agent-browser ref stale | click fails | Re-snapshot after the page changes |

## Reusable Patterns

1. Surface → Sink → Chain (see `pentest-tools/references/client-side-lab-playbook.md`)
2. Inventory-style `innerHTML = fetchBody`: prove the sink first, then look for a 200 non-numeric
3. Static rg sink + agent-browser eval dual evidence

## Toolchain

- case-init / case-guard / append-evidence / smoke
- agent-browser (CDP)
- curl --globoff

## Environment

- Windows + PowerShell 5.1
- Docker Desktop daemon may not be ready
