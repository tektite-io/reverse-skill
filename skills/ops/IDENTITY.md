# reverse-skill Identity Manifesto (relative to Z3r0)

> This document fixes **who we are**. It absorbs Z3r0's ideas on evidence/scope/division of labor/timeline, but **does not** become a Z3r0 platform.

## What We Are

| Dimension | reverse-skill |
|------|----------------|
| Form | **Skill routing package** — methodology + tool bootstrapping for any AI client (Claude/Cursor/Codex…) |
| Entry | `RULES.md` → `MASTER-ROUTING` / `master-route.ps1` → sub-skill |
| Tool truth | `tool-index.md` + `bootstrap-manifest.json` (local paths, no guessing) |
| Evolution | `field-journal/` anonymized experience write-back |
| Artifacts | Markdown reports + `work/<case>/` local engagement directory (gitignore) |
| Deployment | Just `git clone`; no mandatory PG/UI/Docker pool |

## What We Are Not

| Z3r0 has | reverse-skill **deliberately does not do** |
|---------|---------------------------|
| React engagement console | ❌ |
| FastAPI control plane + WebSocket sessions | ❌ |
| PostgreSQL evidence database | ❌ |
| LightRAG service | ❌ |
| Docker host pool / noVNC control proxy | ❌ (**documentation** may recommend an optional sandbox profile) |
| Multi-Agent process runtime | ❌ (only **role→skill mapping + handoff protocol**) |

## What We Learn from Z3r0 (Downscoped Implementation)

| Idea | reverse-skill Form |
|------|-------------------|
| Authorization and project boundaries | `ops/scope-contract.md` → per-case `scope.md` |
| Evidence→Finding→Path | `ops/evidence-finding-path.md` + report templates |
| Expert division of labor | `ops/role-map.md` (Lead/cie/cpe/cre…→ skill) |
| Replayability | `work/<case>/timeline.md` append-only |
| WorkItem/Coverage | `workitems.md` + coverage checkboxes |
| Sandbox tool completeness | `ops/sandbox-profile.md` vs bootstrap-manifest |
| Outbound control | `network_profile` field (offline/lab/authorized) |

## Distinguishing Features (Must Be Preserved)

1. **Three-axis routing + PRIMARY fast path** (target type / intent / toolchain)  
2. **Bootstrap installs tools on demand**, cross-platform Windows/Kali/Linux/macOS  
3. **MCP-friendly** (IDA/Burp/jshook/anything-analyzer)  
4. **field-journal anonymized evolution**  
5. **Compliance engineering**: ACTION REQUIRED / completion self-check / no fake stops  

## Healthy Relationship with Z3r0

```text
Z3r0 = red team operating system / team collaboration platform
reverse-skill = Agent's security engagement router + manual

Optional future: mount this package's skill content into Z3r0 sandbox-local skills
Current: zero-dependency on Z3r0 installation for full functionality
```

## Relationship with "800+ Community Micro-Skills"

- **Do not** submodule a giant skill library (poisoning surface and maintenance cost, see `skill-supply-chain.md`)  
- **Do** maintain `references/community-security-skills.md` as an index and borrowing rules  
- **Do** use `domain-coverage-map.md` to prove: deep skills + routing > fragmented skill stacking  
- External skill installation: AST10 thinking + trust only curated sources (e.g. Trail of Bits curated)  
