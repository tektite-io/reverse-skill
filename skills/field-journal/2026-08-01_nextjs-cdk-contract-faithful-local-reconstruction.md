# Contract-Faithful Local Reconstruction of a Next.js CDK Order Center

> Date: 2026-08-01
>
> Scenario: Web / API / JS reverse engineering and local reconstruction
>
> Anonymization: target domain and port use standard placeholders; credentials, CDKs, order identifiers, and private paths retain only their category, with original values not recorded

## Scenario Classification

Web / API / JS reverse engineering

## Goal Overview

Build a four-source evidence chain for a Next.js single-page order center — "entry snapshot, static bundle, runtime page, public OpenAPI" — and, without connecting to the real payment, worker, or check services, reconstruct a runnable local project with the same information architecture, the same browser request shape, the same response projection, and the same order-state semantics.

## Scope Summary (Anonymized)

- auth_basis: the user provided the entry and requested analysis plus a matching local implementation
- network_profile: read-only review of the public entry and public OpenAPI; builds and acceptance all point to loopback addresses
- asset_types: [web, frontend_js, public_openapi, screenshot, local_source]
- fixture_profile: synthetic CDK, synthetic credential, synthetic payment link, deterministic worker/check/payment adapters

## Roles

- lead_role: lead
- specialists: [cre, doc]

## Full Execution Chain

1. Freeze the entry HTML, response headers, public OpenAPI, and SHA-256, and reuse the existing static bundle and browser forensics.
2. Extract routes, request body fields, headers, Storage keys, polling intervals, conditional rendering, and the state vocabulary from the main page bundle.
3. Model the page-internal legacy API and the public v1 API separately, building a serializer for each to avoid field drift from a shared DTO.
4. Derive desktop geometry, mobile breakpoints, card hierarchy, control states, and copy baselines from runtime full-page screenshots, the DOM, and CSS.
5. Build a canonical domain model, a CDK ledger, and a deterministic state machine; external capabilities are handled by `CHECK_FN`, `PAYMENT_PROVIDER`, and `WORKER_GATEWAY` fixture adapters.
6. Reduce credentials and payment links to a digest, type, and safety hint immediately at request time; the persistence model has no slot for the original text.
7. Run contract tests for single, batch, detail, cancel, resubmit, pagination, dual authentication, and the OpenAPI document.
8. Verify visuals with desktop and mobile browser screenshots; form delivery evidence with a production build, interface smoke tests, secret scanning, and unpack-and-reverify.

## Evidence Chain Summary (Anonymized)

| E-id | source_type | Reusable command pattern | Related conclusion |
|------|-------------|----------------|----------|
| E-001 | network/file | `curl -D headers -o page https://{target_domain}/<entry>; shasum -a 256 page` | framework entry and timestamp baseline |
| E-002 | frontend_js/openapi | `rg 'sessionStorage|/api/|productType|customerToken' {formatted_chunk}`; `jq '{info,paths,securitySchemes}' openapi.json` | legacy requests, state, browser storage, and the v1 contract |
| E-003 | runtime_visual/local_qa | `chromium --headless ...; screenshot + DOMRect`; `npm test && npm run build && BASE_URL=... npm run smoke` | desktop/mobile geometry, conditional rendering, and the local contract loop |

## Finding / Path Summary

- top_finding: the page-internal legacy API and the public v1 API share business semantics, but their request fields, authentication entry, and response projection differ; reconstruction requires "one domain model, two boundary serializers".
- path_type: callflow
- path_one_liner: form input -> page field mapping -> legacy Route Handler -> canonical service -> fixture adapter/ledger -> legacy serializer -> polling render.

## Pitfalls

| Problem | Cause | Solution | Time |
|------|------|---------|------|
| Building interfaces by route name alone still leaves page fields blank | The legacy and v1 response fields are not the same DTO | Reverse the serializer from the property read points in the bundle, and run contract tests on each boundary | ~45 min |
| The page's initial form and its bound form are mixed together | Many cards, hints, buttons, and lists are conditionally rendered | Freeze the unbound baseline first, then build an interaction matrix by CDK/order state | ~30 min |
| The batch interface must express both partial success and ledger consistency | Promoting a single-item error to a whole-batch exception loses the original page's per-item result semantics | Parse item by item first, then produce created/duplicate/failed in order within a single store mutation, and finally validate the ledger uniformly and persist atomically | ~35 min |
| Ambiguity between the documented required fields and property names | OpenAPI and the page-internal call surface evolve independently | Keep the spec fields while recognizing compatible aliases at the boundary; list the adjudication basis separately in the report | ~15 min |
| Visually close but vertical error keeps accumulating | Small deviations in card padding, line-height, and gap compound | Constrain by full page height, main column width, and key DOMRects, and regress screenshots section by section | ~40 min |
| Fixture hint copy breaks the matching first screen | Implementation notes are mixed directly into the product UI | Keep the UI at the forensic baseline and put fixture notes in the README; inputs still use deterministic examples | ~15 min |

## Toolchain Findings

- A static bundle's property read points are better than the interface paths themselves for recovering the response DTO.
- Layering legacy/v1 serializers lets page compatibility and public API stability hold at the same time.
- `fullPage` screenshots must be combined with viewport width, total page height, and DOMRects; pure pixel similarity is amplified by font anti-aliasing.
- Batch orders should retain per-item created/duplicate/failed; deduplication, capacity deduction, and ledger validation go in the same mutation, with a single atomic file replacement at the end.
- Secret scanning should cover source code, the runtime store, test logs, and the final archive's extracted directory, not just the Git worktree.

## Key Code/Commands

```bash
# Static call surface and state fields
rg -n 'customerToken|productType|upiExpiresAt|customerResubmitCount|sessionStorage' {formatted_chunk}

# Public API structure
jq '{openapi,info,paths:(.paths|keys),security:.components.securitySchemes}' openapi.json

# Local quality gates
npm run lint
npm test
npx tsc --noEmit
npm run build
BASE_URL=http://127.0.0.1:{port} npm run smoke
```

## Suggestions for This Package

1. Add a "legacy UI API and public API dual serializer" checklist to `js-reverse`.
2. Add a "visual baseline geometry table" and an "initial/bound/order-state matrix" to the report template.
3. Add batch partial success and atomic persistence, dual-auth OR, OpenAPI schema/actual response consistency, and delivery-package extraction scanning to the QA template.

## Reusable Patterns/Script Fragments

1. **Four-source cross-check**: the entry snapshot locates the version, the static bundle recovers the call surface, runtime recovers conditional rendering, and OpenAPI recovers the public contract.
2. **One core, two projections**: the canonical domain keeps state and ledger unified, while legacy/public serializers keep boundary fidelity.
3. **Initial state first, then the state matrix**: lock the unbound first screen first, then verify bound, creating, in-progress, complete, cancelled, and resubmitted.
4. **Request-time reduction**: raw input is immediately converted into SHA-256, type, and mask once it enters the service; logs and the store receive only the reduced result.
5. **Delivery-package re-verification**: extract the archive to a new directory, reinstall, test, and build, to avoid leftover working-directory state masking problems.

## Evolution Actions

- [ ] Updated the routing matrix
- [ ] Updated the tool-index
- [ ] Updated the bootstrap-manifest
- [ ] Updated sub-skill documentation
- [x] Added a pitfalls record
- [ ] No update needed

## Environment Information

- OS: macOS
- Tool versions: Node.js 24, Next.js 16.2.12 App Router, React, TypeScript 5.9.3, Chrome/Playwright
- Target platform/version: Next.js App Router / React / OpenAPI 3.1

## Final Acceptance Record

- ESLint, TypeScript 5.9.3, Next.js 16.2.12 production build: passed.
- Node test: 8/8 passed.
- HTTP smoke: 15 contract groups passed.
- Playwright: 11 state/viewport screenshots and 10 assertion groups passed; browser console and page errors both empty.
- The 1440 px initial page and the baseline are both 1440×1294; RGB MAE 2.301148, with 0.945085 of pixels within the 5/channel threshold.

## Anonymization Review

- [x] Target domain replaced with `{target_domain}`
- [x] CDK, order number, Token, Cookie, JWT, and payment link originals not written
- [x] Real IPs, ports, and local private paths not written
- [x] Run commands use `{port}` and placeholders
- [x] Delivery lessons retain only methods, structure, and verification patterns

---
<!-- [Community contribution] After completion, ask the user whether to PR to the main repository. -->
