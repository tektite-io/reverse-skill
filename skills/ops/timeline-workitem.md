# Timeline + WorkItem / Coverage

> Replayable engagement record (Z3r0 timeline idea) + coverage checkboxes (WorkItem idea).  
> Everything lands in **`work/<case>/`** (repository gitignore), not in the skill package body.

## Directory Conventions

```text
work/<case>/
  scope.md           # contract (ops/scope-contract.md)
  timeline.md        # append-only, prohibited from modifying historical entries
  workitems.md       # work items and coverage
  evidence/          # raw artifacts (screenshots, pcaps, logs)
  notes/
  report/            # final report draft or copy
```

Initialize:

```powershell
powershell -File skills\scripts\case-init.ps1 -Hint "full pentest" -CaseName "acme-2026"
```

## timeline.md Format

Each record is **append-only**:

```markdown
## {ISO-8601} | {role} | {phase}
- action:
- command_or_ref:
- result_summary:
- artifacts: []      # relative paths under this case
- evidence_ids: []   # E-xxx when promoted
- decision_delta: [] # only decisions changed since the previous transition
- carry_forward_refs: [scope.md] # unchanged authoritative state is referenced, not re-serialized
- next:
```

**MUST NOT** delete or rewrite existing `##` time blocks (for corrections, use a new entry + `corrects: {timestamp}`).

### Decision delta boundary

`scope.md`, `workitems.md`, and existing Evidence are the current authoritative state. `timeline.md` records transitions and does not copy complete snapshots.

- Every real stage/turn transition **MUST** write `decision_delta`; list only decisions that actually changed from the previous state to the current state and will affect subsequent actions. Write `[]` when there is no change.
- Unchanged route, auth, scope, network profile, tool capability, and existing hypothesis/Evidence **MUST NOT** be re-expanded for handoff; reference authoritative files or entries in `carry_forward_refs`.
- The consumer **MUST** first parse `carry_forward_refs`, then overlay `decision_delta` onto the working context; the delta must not be treated as the complete state.
- It is a genuine decision boundary only when there are two or more materially different, evidence-supported branches and the user's choice would change the next action; deterministic transitions continue directly, without restating context to manufacture a menu.

Representative transition: if auth/scope/route remain unchanged during `Triage -> Static`, record only `decision_delta: [phase=triage->static]` and inherit the rest of the state with `carry_forward_refs: [scope.md, evidence/E-triage.md]`.

## workitems.md Template

```markdown
# Work Items

| ID | title | role | targets | surface | status | evidence | notes |
|----|-------|------|---------|---------|--------|----------|-------|
| WI-001 | Port scan edge | cie | {ip} | network | done | E-001 | |
| WI-002 | Auth bypass check | cpe | /api/login | web | blocked | | need creds |

status: pending | in_progress | blocked | done | cancelled

## Coverage
- [ ] Recon complete for in_scope assets
- [ ] Critical/High candidates triaged
- [ ] Validated findings have Evidence
- [ ] Path documented (attack/call/solve)
- [ ] Timeline continuous (no silent gaps >1 major phase)
- [ ] Report exported via docs-generator
- [ ] field-journal written (anonymized)
```

## attack-chain / pentest Hook

| Skill | MUST |
|-------|------|
| `attack-chain/` | Multi-phase tasks create a case directory; update workitems + timeline at the end of each phase |
| `pentest-tools/` | At least 1 timeline entry after each tool batch; findings → Evidence draft |
| Other RE skills | Recommend timeline; at least complete the Evidence chain before producing the report |

## Features

- Agent-friendly plain text, diff/review friendly  
- Cross-referencable with tool-index command paths  
- No dependency on WebSocket live streaming; paste the timeline into the report when needed  
