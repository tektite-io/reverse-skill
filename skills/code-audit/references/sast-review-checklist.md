# Code Audit Checklist (Condensed)

- [ ] List of all external input entry points
- [ ] Auth/authz middleware coverage
- [ ] Whether multi-tenant IDs are bound to the session
- [ ] Deserialization / pickle / YAML load
- [ ] SSRF egress and protocol restrictions
- [ ] Key and token storage
- [ ] File upload path and type
- [ ] Dangerous exec/system/Runtime
