---
name: api-security
description: Use for authorized security assessment of REST, GraphQL, WebSocket, or SOAP APIs, including discovery, authentication, authorization, rate-limit, and CI/CD testing.
---
# API Security Testing

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-pentest.md` — confirm that operations in this skill are authorized routine operations
2. `NOW`: Confirm whether the current task falls within the scope of this skill
3. `NEXT`: Read `../tool-index.md`, verify tool availability and actual paths
4. `NEXT`: Call bootstrap when tools are missing; do not guess paths
5. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation stage

> Covers all protocols: REST / GraphQL / WebSocket / SOAP
> 10-phase methodology, from discovery to CI/CD integration

## Applicable Scenarios

- REST API security testing (OpenAPI/Swagger-driven or blind testing)
- GraphQL security auditing (introspection, batch queries, alias overloading)
- WebSocket security testing
- JWT / OAuth 2.0 authentication testing
- BOLA/IDOR/BFLA authorization vulnerability detection
- API rate-limit bypass and DoS testing

## 10-Phase Testing Process

### Phase 1: API Discovery and Reconnaissance

```text
Active discovery:
□ Vespasian: Headless browser crawling → automatically generate OpenAPI 3.0 / GraphQL SDL specifications
□ Entropy --discover: Extract endpoints from robots.txt + JS files
□ Kiterunner / ffuf: Brute-force undocumented endpoint paths
□ Check common paths: /swagger.json, /openapi.json, /graphql, /api-docs

GraphQL introspection (three-level attempts):
  1. Standard introspection query
  2. Reduced query (bypass full WAF blocking)
  3. Query only __schema { types { name } } (minimal probe)
```

### Phase 2: Authentication Testing

```text
JWT analysis (jwt_tool / Burp):
□ alg:none attack: Change header to "alg":"none", clear signature
□ Key confusion: RS256 public key → HS256 symmetric key
□ Weak HMAC key brute-force: jwt_tool -C -d wordlist.txt
□ Expiration/claim tampering: Modify exp/iat/sub/role claims
□ kid injection: ../../etc/passwd → HMAC signature bypass

OAuth 2.0:
□ redirect_uri manipulation → authorization code leakage
□ CSRF via missing state parameter
□ Token leakage in Referer header
□ PKCE missing detection

GraphQL authentication:
□ Mutation via GET request bypasses authentication (CSRF)
□ Batch query authentication bypass
```

### Phase 3: Authorization Testing (BOLA/IDOR/BFLA)

```text
BOLA (Broken Object Level Authorization):
□ Enumerate numeric IDs: /user/1 → /user/2 → /user/3
□ Enumerate UUIDs
□ Enumerate usernames/emails
□ Burp Autorize: Dual-session replay comparison

BFLA (Broken Function Level Authorization):
□ Regular user executes admin API
□ HTTP method switching: GET → PUT → PATCH → DELETE
□ API version downgrade: /v2/admin → /v1/admin
□ Batch operation injection: {"users": [1,2,3]} → {"users": [1,2,3,admin_id]}

Tools: Burp Autorize, AuthMatrix, Entropy (malicious_insider persona)
```

### Phase 4: GraphQL Specialized Testing

```text
Introspection leakage → Information exposure detection
Alias overloading → 100+ aliases DoS
Batch queries → 10+ simultaneous queries DoS
Field duplication → __typename × 500
Directive overloading → Recursive @skip/@include
Circular queries → Deeply nested introspection recursion
Field suggestions → Error message information leakage
GraphiQL/Playground exposure → Public IDE risk
GET mutations → CSRF risk
Tracing/debug mode → Metadata leakage

Tools: FireTail, Escape DAST, api.sh (Phases 1-3)
```

### Phase 5: REST Input Validation

```text
□ HTTP method switching: GET→POST→PUT→DELETE→OPTIONS→PATCH
□ Content-Type tampering: JSON→XML→multipart
□ NoSQL injection: {"username": {"$gt": ""}}
□ SSRF via URL parameters: webhook URL/avatar URL/import URL
□ XXE in XML endpoints
□ Parameter pollution: /api?role=user&role=admin
□ Mass assignment: Add is_admin: true to request body
```

### Phase 6: Business Logic and Differential Testing

```text
□ Entropy compare: diff v1 vs v2 API → status code changes/field deletions/latency regression
□ Multi-role workflow testing: admin/user/readonly permission matrix
□ Coupon/points/price manipulation
□ Race conditions: Concurrent request testing TOCTOU
```

### Phase 7: WebSocket Testing

```text
□ Endpoint discovery
□ Message injection (inject payload, prototype pollution)
□ Oversized message handling
□ Type confusion
□ Cross-Site WebSocket Hijacking (CSWH)
```

### Phase 8: Rate Limiting and DoS

```text
□ Rate-limit bypass via headers: X-Forwarded-For, X-Real-IP
□ Path variants: /api/ → /api → /Api/ → /API/
□ GraphQL batch query deeply nested DoS
□ IP rotation testing (ProxyCat proxy pool)
```

### Phase 9: Data Exposure

```text
□ Excessive response exposure: Compare API return vs UI display
□ Pagination enumeration: ?page=1&limit=10000
□ Error message information leakage: stack traces/internal paths/SQL errors
□ GraphQL nested traversal accessing unauthorized data
□ OpenAPI specification exposes sensitive endpoints
```

### Phase 10: CI/CD Integration

```text
□ Entropy --ci --watch: Automatically re-run when spec changes
□ Escape DAST: Automatically block builds based on severity threshold
□ Persist findings as regression tests
□ StackHawk (developer-first, ZAP engine)
```

## Toolchain

| Tool | Purpose | Source |
|------|---------|--------|
| Vespasian | Traffic → OpenAPI/GraphQL specifications | GitHub: praetorian-inc/vespasian |
| Entropy | LLM-generated attack scenarios, 5 personas | GitHub: arjinexe/entropy-chaos |
| Escape DAST | Business logic security testing | escape.tech |
| api.sh | 8-phase all-protocol attack pipeline | GitHub: Sharon-Needles/api |
| FireTail | GraphQL 12 specialized tests | firetail.ai |
| jwt_tool | Comprehensive JWT testing | GitHub: ticarpi/jwt_tool |
| Burp Autorize | Dual-session authorization comparison | Burp BApp Store |

## References

- `references/rest-graphql-testing.md` — REST + GraphQL deep testing
- `references/jwt-oauth-testing.md` — JWT + OAuth security testing


## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I execute every step in the workflow (rather than just reading)?
- [ ] Did I use real tool paths based on `tool-index`?
- [ ] Did I produce reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Did I complete and write back the Checklist items required by RULES?
