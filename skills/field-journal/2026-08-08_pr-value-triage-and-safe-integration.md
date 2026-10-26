# 2026-08-08 Open PR Value Triage and Safe Integration

## Scenario Classification

Other / repository maintenance / contribution review

## Goal Overview

Sync upstream main while preserving uncommitted worktree content, review multiple open PRs, and safely integrate low-risk, high-reuse-value contributions into local main.

## Full Execution Chain

1. Check the remote, branch lag, and worktree changes.
2. Use stash to isolate user changes, fast-forward to latest main, then restore and verify.
3. Fetch open PR refs and compare commits, file scope, and three-way merge results.
4. Classify contributions containing only anonymized field-journal entries as low-risk candidates.
5. For core-script PRs, check conflicting files, change size, and duplicate implementations on main.
6. Merge 4 journal PRs, normalize the index consistently, and run smoke and routing coherence.

## Pitfalls

| Problem | Cause | Solution |
|---|---|---|
| Pulling main overwrites local index changes | Upstream and worktree both modified `_index.md` | Isolate with stash; restore after fast-forward |
| Old PR index statistics overwrite each other | Multiple PRs based on the same old baseline | Merge content files first, then recompute the index centrally |
| Large PR looks high-value but cannot be merged directly | Main had evolved and core scripts had content conflicts | Defer; require rebase and dedicated testing |

## Reusable Patterns

- Split by "documentation/executable code" first, then rank by reuse value, conflict surface, and test evidence.
- For journal-only PRs, handle content merging and index coordination separately.
- For core infrastructure PRs, conflicts are not merely textual; re-verify behavioral equivalence.

## Verification Results

- smoke: all passed.
- routing coherence: all passed.
- User worktree content: fully restored, no conflicts.

## Anonymization Review

Contains no credentials, private targets, user identities, or internal URLs.
