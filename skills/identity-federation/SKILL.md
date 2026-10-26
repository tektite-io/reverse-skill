---
name: identity-federation
description: Use for authorized assessment of federated identity systems including SAML, OIDC, OAuth2 flows, SSO misconfiguration, and token confusion issues.
---

# Identity Federation (SAML / OIDC / OAuth)

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read precedent-pentest; add SSO test accounts and IdP/SP scope to scope
2. `NOW`: Prohibit brute-force attempts that lock real user accounts
3. `NEXT`: Capture tools and documentation (metadata URL)
4. `ACT`: Map protocol flow → common misconfigurations → verify

## Applicable Scenarios

- SAML Response signature/assertion tampering surfaces (classic defect patterns)
- OIDC implicit/authorization code + missing PKCE
- redirect_uri / state / nonce issues
- IdP and SP metadata, multi-tenant issuer confusion
- Complements `api-security` JWT attacks (this skill focuses on federation and SSO flows)

## Workflow

```text
□ Map: User → SP → IdP → Token → SP
□ Collect: /.well-known/openid-configuration, SAML metadata
□ Check: redirect_uri exact match, state binding, PKCE
□ Check: SAML signature coverage, algorithm downgrade
□ Session fixation and logout invalidation
```

## Toolchain

| Tool | Purpose |
|------|------|
| Burp + SAML Raider etc. | Assertion editing (authorized) |
| jwt_tool | JWT segments |
| Browser DevTools | Redirect chains |
| IdP management logs | Auditing |

## References

- `references/sso-flow-checklist.md`
- `../api-security/` `../windows-ad/` (enterprise IdP)

## Routing Context

**Upstream**: MASTER R37  
**Downstream**: Pure API JWT → api-security; Cloud IdP → cloud-k8s

## Task Completion Self-Check

- [ ] Have I mapped the complete SSO flow?
- [ ] Does each Finding have reproduction and impact?
- [ ] Checklist?
