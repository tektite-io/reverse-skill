# 2026-09-03 Multi-Issue/PR Security Boundary Integration

## Scenario

Maintaining a public security-skill routing repository: the local primary worktree contains many user changes and is behind the remote; we need to simultaneously review multiple open PRs, resolve historical issues, add features, publish a security re-review, and ensure GitHub state and cross-platform CI close the loop.

## Reusable Patterns

1. **Dirty-worktree isolation:** fetch the remote first, then create an independent worktree from `origin/main`; all PR merges, conflict resolution, testing, and commits happen in the isolated directory.
2. **Preserve PR attribution:** merge the accepted PR head as a parent of the merge commit into the integration branch; after fast-forward pushing main, GitHub automatically marks the corresponding PR as merged/closed.
3. **State freeze:** record each PR's head SHA before merging; re-fetch before pushing, require the remote main to still equal the review baseline, and verify that all accepted PR heads are ancestors of the final HEAD.
4. **Review under AV isolation:** for payload documents that may be quarantined by Defender, do not rely on worktree files; use `git show :path` / Git index blobs for hashing, link, and content-boundary checks.
5. **Reference/executable layering:** passive Markdown/JSON payloads may be kept, but executable scripts must not reference them; CI pins the corpus hash, binary allowlist, symlinks, dangerous patterns, and GitHub Action full-SHA.
6. **Don't blind-merge feature PRs:** besides running the original PR's tests, also check cross-instance state, path/port isolation, and new mainline constraints. This time we found the IDA keepalive file was not isolated by port and fixed it in the merge commit.
7. **Issue closure must be justified:** give each Issue a traceable conclusion first, then close it as completed / duplicate / not_planned; do not omit the explanation on the grounds of "bulk cleanup."

## Pitfalls

| Problem | Cause | Handling |
|---|---|---|
| PR shows mergeable on GitHub, but merging into the latest mainline still has semantic conflicts | PR base is behind, and multiple PRs modify the same CI/routing files | Simulate the merge locally, resolve against the latest SSoT, then re-run the full test suite |
| AV deletes payload worktree files, causing normal scans to miss them | Files with a Markdown extension also match signature rules | Read from the Git index blob; forbid "skip if unreadable" |
| Binary Ninja MCP source easily mistaken for official | The MCP project is a community GPL plugin, not an official Vector 35 component | State the source clearly in the skill, review the commit, bridge version, and loopback binding |
| Git Bash cannot equivalently emulate a Linux Python→bash subprocess | Windows CreateProcess resolves the system `bash.exe`/WSL first | Run Bash syntax and direct contracts locally, but treat Ubuntu/macOS CI as authoritative |

## Verification

- Routing regression: 175/175
- Windows PowerShell 5.1 and PowerShell 7: P0, encoding, Evidence, IDA, smoke all pass
- Python: case-review, document links, repository security all pass
- Bash: syntax, case workflow, new Binary Ninja routing pass
- GitHub: Windows, Ubuntu, macOS, Gradle Wrapper Validation all pass
- Remote open Issues / PRs: 0

## Environment

- OS: Windows
- Git: isolated worktree + PR head ancestor verification
- CI: Windows, Ubuntu, macOS
- Data handling: public repository metadata and sanitized method notes only
