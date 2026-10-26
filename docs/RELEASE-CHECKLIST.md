# Release Checklist

> Check each item before every release. Source of truth for versions: the VERSION file must match the latest released version in CHANGELOG.md (the CI version-check job validates automatically and turns red on mismatch).

## Release Steps

1. [ ] Confirm the [Unreleased] section of CHANGELOG.md is complete (Keep a Changelog groups: Added / Fixed / Security / Removed)
2. [ ] Change ## [Unreleased] to ## [x.y.z] — YYYY-MM-DD, and update the comparison link from ...HEAD to the new tag
3. [ ] Update the VERSION file to x.y.z at the same time
4. [ ] For milestone versions (e.g., v1.0.0 / v1.1.0), also update docs/RELEASE_NOTES_v<x.y.z>.md
5. [ ] Tag the release: git tag v<x.y.z> + git push --tags
6. [ ] After pushing, confirm CI is all green (routing 173 baseline + coherence + pin gate + version-check)

## Metadata Sync (Convenient During Release)

- Adding/removing bootstrap capabilities → sync the capability list in RULES.md / RULES_zh.md / skills/SKILL.md (skills/scripts/bootstrap-manifest.json is the single source of truth; currently 25 items)
- Adding a field-journal entry → update three places in skills/field-journal/_index.md (scenario classification / high-frequency patterns / entity inverted index) and the statistics
- Routing rule changes → change only skills/config/routing.json (documentation is maintained by generation scripts or at least kept consistent)

> Note: the cumulative comment `<!-- [evolution statistics] -->` at the bottom of journal entries is no longer manually maintained (removed on 2026-08-10 because the numbers could not be reliably maintained); project counts follow _index.md.
