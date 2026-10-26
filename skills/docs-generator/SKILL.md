---
name: docs-generator
description: |
  Creates task-oriented technical documentation with progressive disclosure. Use when writing READMEs, API docs, architecture docs, or markdown documentation.
  Also use this skill at the END of any completed reverse engineering, penetration testing, CTF, or security analysis task to generate a formal report in the user's project directory.
  Trigger keywords: write report, write documentation, produce report, writeup, technical documentation, report, documentation.
---

# Technical Documentation

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Confirm whether the current task falls within the scope of this skill
2. `NOW`: Read `../tool-index.md`, verify tool availability and actual paths
3. `NEXT`: Call bootstrap when tools are missing; do not guess paths
4. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation stage

For writing style, tone, and voice guidance, use `Skill(ce:writer)` with **The Engineer** persona.

## Security/Reverse Engineering Task Documentation Output

When a reverse engineering/penetration testing/CTF/security analysis task is complete, this skill is responsible for generating formal technical documentation in the **user's project directory**.

### Trigger Timing

1. Reverse engineering task complete, with core conclusions produced (algorithm recovery, signature cracking, bypass solutions, etc.)
2. Penetration testing complete, with vulnerabilities discovered and verified
3. CTF challenge solved, flag obtained
4. The user explicitly requests "write a report/document/writeup"

### Template Selection

| Task Type | Template to Use |
|---------|---------|
| APK/binary/so reverse engineering | `references/security-report-templates.md` → Reverse engineering report |
| Penetration testing/vulnerability research | `references/security-report-templates.md` → Penetration testing report |
| CTF solving | `references/security-report-templates.md` → CTF Writeup |
| JS/Web signature reverse engineering | `references/security-report-templates.md` → Signature reverse engineering report |
| Malware / APT / virus analysis reports | `references/security-report-templates.md` + **`references/vendor-report-rules.md`** |
| General technical documentation | `references/templates.md` → README / API documentation |

### Vendor Report Structure (Issue #65)

Formal security reports **MUST** read `references/vendor-report-rules.md` (take only the structure, do not copy vendor text). Choose a vendor flavor only when task evidence or explicit user request supports it; ordinary reverse engineering and other tasks use `flavor = null`.

| Flavor / Overlay | When to Use | Primary Reference Skeleton |
|------------------|--------|------------|
| `malware` | Clear malicious samples, trojans, whitelist-bypass-blacklist, phishing poisoning | Huorong style: Overview → Flow → Sample Analysis → Incident Response → IOC |
| `apt` | APT/campaign/gang/multi-stage infection chain/industry targeting | Kaspersky Securelist style: Summary → Infection Chain → Investigation Narrative → Interesting findings → Technical Analysis → Detection & Mitigation → IOC |
| `flavor = null` | Ordinary APK/ELF/PE/Mach-O reverse engineering, algorithm/firmware analysis, penetration / CTF / JS signature | Original task template + Base generic elements; do not apply malware/APT-specific sections |
| thin `vuln` | User explicitly requests vulnerability/patch/CVE technical analysis | Overview → Impact/Reproduction → Crash and Patch Analysis → Protection Recommendations (layered on top of null; not a third default full-text flavor) |

Principle: **Templates should be refined rather than numerous** — only 2 full-text vendor flavors; `vuln` is only an optional thin overlay; do not create a third default full-text template.

Takes effect simultaneously with §0 Evidence→Finding→Path; in case of conflict, the Evidence contract takes precedence.

### Output Specification

- **Output location**: The user's current project directory (not the skill package directory)
- **Filename format**: `YYYY-MM-DD_[type]-[target abbreviation]-report.md`
- **If the project has a `docs/` directory**: Prefer placing it under `docs/`
- **Encoding**: UTF-8
- **Language**: Follow the user's conversation language (Chinese conversation → Chinese report; English conversation → English report)

### Quality Requirements

- All code blocks must be directly runnable or have clear context
- No placeholder/TODO
- Key findings must be supported by evidence
- Reproduction steps must allow a third party to reproduce independently
- Replace sensitive information (real tokens, passwords, internal URLs) with placeholders
- **MUST** include the Evidence → Finding → Path chain (see `../ops/evidence-finding-path.md` and template §0)
- **MUST** read `references/vendor-report-rules.md`: select `malware` / `apt` or `flavor = null` (vulnerability tasks may layer a thin `vuln`); when there is no flavor, output only the original task template and applicable Base elements, without forcing IOC/ATT&CK
- **SHOULD** reference the case's `scope.md` / `timeline.md` (`../scripts/case-init.ps1`)

### Diagram Integration

When generating reports, call the `diagram-generator` skill at appropriate points to generate visual diagrams:

| Report Type | Suggested Diagram | Diagram Type |
|---------|---------|---------|
| Reverse engineering report | Function call graph, data flow diagram | Mermaid flowchart / sequenceDiagram |
| Penetration testing report | Attack path diagram, network topology diagram | Mermaid flowchart / Graphviz |
| CTF Writeup | Solution approach flowchart | Mermaid flowchart |
| JS signature reverse engineering report | Request chain sequence diagram, algorithm flowchart | Mermaid sequenceDiagram / flowchart |

Embed diagrams as Mermaid code blocks in the report markdown to ensure they render directly on GitHub/GitLab.

---

## Core Principles

### 1. Progressive Disclosure

Reveal information in layers:

| Layer | Content | User Question |
|-------|---------|---------------|
| 1 | One-sentence description | What is it? |
| 2 | Quick start code block | How do I use it? |
| 3 | Full API reference | What are my options? |
| 4 | Architecture deep dive | How does it work? |

**Warnings, breaking changes, and prerequisites go at the TOP.**

### 2. Task-Oriented Writing

```markdown
<!-- Bad: Feature-oriented -->
## AuthService Class
The AuthService class provides authentication methods...

<!-- Good: Task-oriented -->
## Authenticating Users
To authenticate a user, call login() with credentials:
```

### 3. Show, Don't Tell

Every concept needs a concrete example.

## Formatting Standards

- **Sentence case headings**: "Getting started" not "Getting Started"
- **Max 3 heading levels**: Deeper means split the doc
- **Always specify language** in code blocks
- **Relative paths** for internal links
- **Tables** for structured data with 3+ attributes

## Quality Checklist

- [ ] Code examples tested and runnable
- [ ] No placeholder text or TODOs
- [ ] Matches actual code behavior
- [ ] Scannable without reading everything
- [ ] Reader knows what to do next

## Anti-Patterns

| Problem | Fix |
|---------|-----|
| Wall of text | Break up with headings, bullets, code, tables |
| Buried critical info | Warnings/breaking changes at TOP |
| Missing error docs | Always document what can go wrong |

## Templates

For README, API endpoint, and file organization templates, see [references/templates.md](references/templates.md).

## Related Skills

- `Skill(ce:writer)` - Writing style, tone, and voice (load The Engineer persona)
- `Skill(ce:visualizing-with-mermaid)` - Architecture and flow diagrams


---

## On-Demand Bootstrap

This skill does not depend on external tools and is pure text generation. No bootstrap is required.

If diagrams need to be rendered and embedded in reports, the `diagram-generator/` skill will be called.

---

## Routing Context

**Upstream entry**: All security/reverse engineering skills automatically call this skill after task completion
**Trigger methods**:
- Automatic: Executed as step 9 of the behavior chain after task completion
- Manual: The user says "write a report", "produce documentation", "writeup"

**Peer related modules**:
- `apk-reverse/` — Generate a reverse engineering report after APK reverse engineering is complete
- `ida-reverse/` — Generate a reverse engineering report after binary analysis is complete
- `radare2/` — Generate a reverse engineering report after CLI analysis is complete
- `js-reverse/` — Generate a signature report after JS signature reverse engineering is complete
- `reverse-engineering/` — Generate a reverse engineering report after general reverse engineering is complete
- `field-journal/` — Report content also serves as a data source for the evolution log

**Security report templates**: `references/security-report-templates.md`
**Vendor report rules**: `references/vendor-report-rules.md` (flavor: malware | apt | null; optional overlay: vuln)
**General documentation templates**: `references/templates.md`


## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Did I execute every step in the workflow (rather than just reading)?
- [ ] Did I use real tool paths based on `tool-index`?
- [ ] Did I produce reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Does the report include Evidence / Finding / Path (ops contract)?
- [ ] Did I complete and write back the Checklist items required by RULES?
