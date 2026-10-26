# 2026-08-14 Windows PowerShell Native Command Exit Code PR Review

## Scenario Classification

Other (toolchain, supply-chain bootstrap script, open PR review)

## Goal Overview

Evaluate a bootstrap-script PR with a pinned source and commit, and verify whether it stays fail-closed under Windows PowerShell 5.1 without falsely rejecting a legitimate checkout.

## Scope Summary (Anonymized)

- auth_basis: repository maintainer authorized to review the public PR and submit a review
- network_profile: public code hosting platform; read-only during the forensic phase, review submitted after conclusions are confirmed
- asset_types: [public source code, CI results, Windows PowerShell bootstrap script]

## Roles

- lead_role: lead
- specialists: [supply-chain-reviewer, windows-compatibility-reviewer]

## Full Execution Chain

1. Pin the PR head commit and read the changes, discussion, CI, and target script, avoiding review of a moving target.
2. Break the security goal into six items: source pinning, commit pinning, atomic replacement, dirty-directory rejection, lockfile install, and platform compatibility.
3. Confirm the design direction of a single manifest source, staged checkout, dirty-tree fail-closed, and frozen lockfile is effective.
4. Locate the checkout verification function and run the native command and the `Select-Object` piped version separately in Windows PowerShell 5.1.
5. Observe that both executions return the same commit text, but the piped version reads `$LASTEXITCODE` as `-1`, causing a legitimate checkout to be falsely rejected.
6. Run the supply-chain test script and confirm the failure occurs before the expected dirty-tree assertion, ruling out a problem with the test fixture itself.
7. Submit a changes-requested review on the PR, requiring the native command exit code to be saved before processing output, and adding Windows PowerShell 5.1 verification.
8. Anonymize and write back the reproduction method and review criteria for reuse in future PowerShell bootstrap-script reviews.

## Evidence Chain Summary (Anonymized)

| E-id | severity | status | source_type | Reusable command pattern | Related Finding |
|------|----------|--------|-------------|----------------|--------------|
| E-001 | info | observed | command | `powershell.exe -NoProfile -Command "& git -C {install_dir} rev-parse HEAD; $LASTEXITCODE"` | F-001 |
| E-002 | medium | validated | command | `powershell.exe -NoProfile -Command "& git -C {install_dir} rev-parse HEAD \| Select-Object -First 1; $LASTEXITCODE"` | F-001 |
| E-003 | medium | validated | command | `powershell.exe -NoProfile -File skills/scripts/tests/test-bootstrap-supply-chain.ps1` | F-001 |

## Finding / Path Summary

- top_finding: in Windows PowerShell 5.1, reading `$LASTEXITCODE` after native command output enters the object pipeline may yield `-1`; even when the output commit exactly matches the pinned value, this triggers a false checkout verification failure.
- path_type: callflow
- path_one_liner: `git rev-parse` succeeds → output enters `Select-Object` → `$LASTEXITCODE` is overwritten → legitimate checkout falsely rejected by the fail-closed branch

## Pitfalls

| Problem | Cause | Solution | Time |
|------|------|---------|------|
| All existing CI passes but Windows still regresses | CI covered the newer PowerShell and Bash, not Windows PowerShell 5.1 native command pipeline semantics | Run the minimal reproduction and the full supply-chain test with `powershell.exe` | ~20 minutes |
| Commit text is identical but judged inconsistent | The verification logic depends on both the output and a deferred `$LASTEXITCODE` read | Save the exit code immediately after the native command returns, then normalize the output separately | ~10 minutes |
| PR showing clean is easily mistaken for directly mergeable | mergeable only indicates Git merge status, not target runtime compatibility | Make base freshness, platform matrix, and local reproduction independent gates | ~5 minutes |

## Toolchain Findings

- The GitHub API is good for pinning the PR head and reading CI and commit status; review records should bind to a verified commit.
- `powershell.exe` and `pwsh` are not interchangeable test entry points. Scripts targeting Windows PowerShell 5.1 must be tested by the corresponding host.
- `$LASTEXITCODE` is mutable session state; any subsequent pipeline or command can cause a deferred read to lose the native command semantics.

## Key Code/Commands

```powershell
# Capture the native command output first, and save the exit code immediately.
$output = & git -C $CheckoutPath rev-parse HEAD 2>$null
$gitExitCode = $LASTEXITCODE
$resolvedCommit = [string]($output | Select-Object -First 1)

if ($gitExitCode -ne 0 -or $resolvedCommit.Trim() -ne $PinnedCommit) {
    throw "Checkout verification failed"
}
```

## Suggestions for This Package

- Add a `powershell.exe` 5.1 test job for PRs that modify PowerShell bootstrap scripts, so coverage does not come only from `pwsh`.
- Add "is the native command exit code saved before the next command" to the supply-chain review checklist.
- Before merging, check the PR head, latest main diff, and target-platform tests together; do not substitute GitHub's clean status for runtime verification.

## Reusable Patterns/Script Fragments

Use a three-step treatment for all PowerShell native commands: execute and capture output, immediately save `$LASTEXITCODE`, and finally parse the output with a PowerShell pipeline. Error judgment may use only the saved exit code.

## Evolution Actions

- [ ] Updated the routing matrix
- [ ] Updated the tool-index
- [ ] Updated the bootstrap-manifest
- [ ] Updated sub-skill documentation
- [x] Added a pitfalls record
- [ ] No update needed

## Environment Information

- OS: Windows
- Tool versions: Windows PowerShell 5.1, Git 2.x
- Target platform/version: PowerShell-compatible bootstrap script, public PR head commit

## Anonymization Check

- [x] No real domains, IPs, credentials, tokens, cookies, or PII
- [x] Local install path replaced with `{install_dir}`
- [x] No user project files or private repository content attached

---
<!-- [Evolution stats] Cumulative completed items in this package: 18 | New patterns this time: 1 | Toolchain issues fixed this time: 0 -->
<!-- [Community contribution] The user has authorized writing back this anonymized experience via an independent PR. -->
