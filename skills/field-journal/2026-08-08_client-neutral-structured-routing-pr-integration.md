# 2026-08-08 Platform-Neutral Structured Routing PR Integration

## Scenario Classification

Code audit / toolchain maintenance / multi-platform routing

## Goal Overview

Perform incremental value review on several high-conflict PRs, then refactor the valuable parts into a platform-neutral core and integrate them.

## Scope Summary (Anonymized)

- auth_basis: repository_owner_authorized
- network_profile: authorized_upstream_only
- asset_types: [source_repository, pull_request_refs, local_tests]

## Roles

- lead_role: lead
- specialists: [cae, doc]

## Full Execution Chain

1. Fetch PR refs from the remote and compare each PR against current main in an isolated worktree.
2. Judge by incremental value first, then preserve provenance with merge parents and resolve conflicts semantically.
3. Decouple structured routing from client integration, using JSON as the shared source of truth for PowerShell/Bash.
4. For the large PR, take only the authorization gate and Bash parity, excluding client-specific and generated assets.
5. Run the full routing, structural gate, language unit tests, syntax, and manifest validation.

## Evidence Chain Summary (Anonymized)

| E-id | source_type | Reusable command pattern | Related Finding |
|------|-------------|----------------|--------------|
| E-001 | git diff | `git diff <main>...<pr-ref>` | F-001 |
| E-002 | regression | `test-routing.ps1` + coherence + smoke | F-001 |
| E-003 | unit tests | Python unittest + Node test + Bash parity | F-002 |

## Finding / Path Summary

- top_finding: client integration is not the core value of structured routing; a single source of truth and automated gates are.
- path_type: callflow
- path_one_liner: any host → optional adapter → routing.json → cross-platform router → unified regression gate

## Pitfalls

| Problem | Cause | Solution | Time |
|------|------|---------|------|
| Large PR mixes client manifests, GIFs, scripts, and documentation | Concerns were not separated | Merge only the minimal cross-platform subset | Medium |
| Bash router and PowerShell each hardcode their own logic | Two sources of truth inevitably drift | Bash reads the same JSON through Python | Medium |
| New pin gate fails the first time | Kali manifest retains floating sources | Pin the manifest and make the actual install command use the pin | Medium |
| Gradle wrapper download TLS interrupted | External network handshake anomaly | Record it and retry during final verification | Low |
| Bash CaseName can write outside the work root | Selective merge missed the path constraint already present in PowerShell | Add cross-platform equivalence checks and negative CI | Medium |
| Authorized URL marked as offline | Bash default not aligned with PowerShell | Default network targets to authorized_target_only; offline only for local samples | Low |
| INDEX passes on the dev machine but fails on a clean clone | The generator scanned ignored local private modules | Enumerate only Git-tracked SKILL.md files | Medium |

## Toolchain Findings

Git merge parents preserve PR provenance while still allowing semantic trimming inside the merge commit. A supply-chain gate is only effective when manifest metadata and the actual install command are pinned together.

## Key Code/Commands

```text
git merge --no-ff --no-commit <pr-ref>
powershell -File skills/scripts/test-routing.ps1
powershell -File skills/scripts/verify-routing-coherence.ps1
bash skills/scripts/master-route.sh --hint "case review evidence graph"
```

## Suggestions for This Package

Keep all client adapters at a separate boundary; forbid writing client configuration into core routing PRs. Large PRs must be split into core, adapters, demo assets, and documentation.

## Reusable Patterns/Script Fragments

Structured routing parity tests should cover at least ordinary routes, conflict-priority routes, and the newest added routes, to prevent any platform entry point from lagging.

Run an old/new A/B on the same 163-entry benchmark: the old hardcoded implementation scored 137/163 (84.05%), the structured implementation 163/163 (100%). Only this kind of same-input quantitative comparison can prove the refactor is a substantive improvement rather than growth in file count.

## Evolution Actions

- [x] Updated the routing matrix
- [ ] Updated the tool-index
- [x] Updated the bootstrap-manifest
- [x] Updated sub-skill documentation
- [x] Added a pitfalls record
- [ ] No update needed

## Environment Information

- OS: Windows (primary verification) + Linux CI definition
- Tool versions: Git / PowerShell / Python 3 / Node.js / Bash
- Target platform/version: client-neutral repository core

## Anonymization Requirements

This entry contains no real targets, credentials, internal addresses, or personal identity information.

---
<!-- [Community contribution] Prepared for push to main per the repository owner's instruction. -->
