# AI Agent Obedience Engineering — Making AI Actually Work After Reading the Workflow

> Source: 2026 multi-source synthesis (Anthropic Skill Engineering, Microsoft Code Words, Strands Steering Hooks, Gradient Flow Harness Engineering)
> Applicable scenarios: AI coding agents (Claude Code / Codex / Cursor / Cline / Windsurf / Kiro, etc.) that read README/RULES.md but only confirm without executing, skip steps, or arbitrarily omit critical operations.

---

## Core Problem Diagnosis

The root cause of AI Agents "reading the workflow but not working" is not insufficient model capability, but rather **semantic escape space in natural language instructions**:

| Root Cause | Explanation |
|------|------|
| **Context Attention Decay** | Content in the middle of long documents is down-weighted by LLM attention mechanisms; the Agent effectively only "sees" the beginning and end |
| **Semantic Override** | When optimizing for "helpfulness," models creatively reinterpret explicit instructions (e.g., interpreting MUST DO X as "suggest doing X") |
| **Passive Language Treated as Optional** | "Ready for next step → invoke X" is treated as a suggestion rather than an instruction |
| **Stateless Enforcement** | Lack of an external state machine to verify workflow order; Agents can skip steps without being detected |
| **Silent State Corruption** | Agents produce structurally correct but semantically wrong results; errors accumulate silently |

---

## Technique 1: Critical-First Pattern

**Put "what to do next" first, and context after.**

```
WRONG (Agent ignores):
  [70 lines of project background and tool list]
  → "Next step: Run bootstrap to install missing tools"

CORRECT (Agent executes):
  "## Execute Immediately: Run `bootstrap-reverse.ps1` to check and install missing tools
   → After completion, read routing.md to determine which skill to enter"
  [Then project background and tool list]
```

**Principle**: LLMs assign the highest attention weight to the beginning and end of prompts. Middle content may be completely ignored.

**Application to this project**:
- The "Routing Entry" section of RULES.md should come after the trigger keywords and before the execution principles.
- The first section of every SKILL.md should be "Execute Immediately" rather than "Applicable Scenarios".

---

## Technique 2: Directive Over Suggestive

Replace all "suggestive" language with RFC 2119-level directive language:

| Weak Language (Agent may skip) | Strong Language (Agent must enforce) |
|---|---|
| "You could try..." | **MUST**: You must execute... |
| "Ready for next step → invoke X" | **NOW**: Call X immediately; do not wait for confirmation |
| "It is recommended to read routing.md first" | **REQUIRED**: You must finish reading routing.md before entering any sub-module |
| "If tools are missing, you can bootstrap" | **NO EXCUSE**: When tools are missing, the only correct action is to call bootstrap; manual installation by guessing is forbidden |
| "Remember to update field-journal" | **CHECKLIST ENFORCED**: After completing a task, tick off each Checklist item; you may not claim the task is finished until all are complete |
| "Should..." | **MUST** / **MUST NOT** |

**Key patterns**:
```
MUST — violation = task failure
MUST NOT — violation = security violation
SHOULD — not doing it requires justification
MAY — truly optional
```

---

## Technique 3: Excuse Rebuttal Table

**This is the most critical patch for this project.** When encountering resistance, AI Agents automatically generate "reasonable excuses" to skip steps. Pre-list common excuses and rebut each one:

| Common Agent Excuse | Rebuttal (Enforced) |
|---|---|
| "This step can be omitted; I'll just..." | **Skipping is forbidden.** Every step in the behavior chain is required. If you believe it can be skipped, first output the specific reason and let the user decide. |
| "Based on my judgment, this is not necessary" | **Your judgment does not apply here.** List the specific criteria you used to judge and explain why this criterion allows skipping an explicitly written step. |
| "The user probably doesn't need this" | **Never make decisions for the user.** Present all options to the user, mark recommendations but do not hide alternatives. |
| "I already know how to do it; I don't need to read X" | **Read X before acting.** Even if you are sure you know how to do it, X may contain constraints specific to this task. Reading it only takes 2 seconds. |
| "To save time, I can skip in parallel..." | **The correct way to save time is to execute independent steps in parallel, not to skip steps.** If two steps are independent, do them in parallel; if they are dependent, do them sequentially. |
| "I've used this tool before; I know the path" | **Guessing paths is forbidden.** You must obtain the actual path from tool-index; installation locations differ across machines. |
| "The task is basically complete; no checklist needed" | **The only definition of task completion is that all Checklist items are ticked.** A task without a completed Checklist is not complete. |
| "I didn't find tool-index, so I'll just guess the path" | **A missing file is 100 times safer than a guessed path.** When tool-index is missing, run refresh-tool-index.ps1 to generate it first. |
| "The user didn't explicitly say to report, so I won't write one" | **Reporting is default behavior, not optional.** Security tasks must generate a report upon completion unless the user explicitly says "do not report." |
| "This is too simple; no need to record a journal" | **Even simple tasks have value in documenting pitfalls.** At minimum record: target type + what was used + any surprises; one line is fine. |
| "The user told me to redo the import table / a certain step, but I did another more useful step instead" | **Redo = redo the same named step** (or a legitimate prerequisite path confirmed by the user). MUST update the corresponding Evidence; posing unrelated steps as substitutes is forbidden, and silent skipping is forbidden. Unpacking is a **prerequisite** for a readable IAT, not a **substitute** for import table Evidence. |
| "The user said for packed samples, don't unpack first—look at the import table; I'll just submit the obfuscated table and call it done" | **Feasibility gate:** When X is blocked, MUST explain the blockage, give the recommended order, and **ask the user to confirm**. If the user insists, execute and mark `quality=unreadable/packed`; using the obfuscated table to draw negative conclusions about capabilities is forbidden. |
| "It crashes after unpacking; I'll keep stubbornly modifying files on disk" | **Patch 6:** Record E-self-check-crash / E-iat-repair-fail, switch to dynamic (bp CreateFile/GetFileSize). Infinite static file modification is forbidden. |
| "I can't fix the IAT; I'll try a few more static packer tools to stall for time" | **IAT repair iron rule:** Prioritize automatic/semi-automatic repair; if tools error out or the repaired binary cannot run → immediately stop static IAT work, record E-iat-repair-fail, switch to dynamic API breakpoint capture. Infinite static struggle is forbidden. |
| ".NET / no import table, the hard gate doesn't apply, I'll skip" | **Equivalent anchors are still MUST:** For .NET, use dnSpy/IL/metadata summaries to write into the E-imports semantic slot; for DLL/SYS, E-exports must be listed in parallel. Empty passes are forbidden. |


**Usage**: Place this table near the end of RULES.md or other instruction files (high-attention area). The Agent sees the rebuttal before making excuses.

---

## Technique 4: Five Skill Engineering Patterns (Official Anthropic 2026)

| Pattern | Applicable Scenarios | Key Techniques |
|---|---|---|
| **Linear Flow** | Processes with clear steps (deployment, installation) | Provide safe defaults, use negative instructions ("MUST NOT use --force") |
| **Decision Tree** | Platform navigation, troubleshooting | Tree navigation + `references/` progressive loading |
| **Iterative Loop** | TDD, review-fix loops | Hard rules upfront + **excuse rebuttal table** to block shortcuts |
| **Baton Loop** | Multi-session, multi-Agent collaboration | Externalize state to `next-prompt.md` (MUST write before exiting) |
| **Multi-Phase + Checkpoints** | Multi-day complex workflows | Orchestrator "parent" skill + human Go/No-Go checkpoints, annotate time cost |

**Correspondence in this project**:
- Complete behavior chain = Linear Flow (15 sequential steps)
- Routing matrix = Decision Tree (three-dimensional matching)
- Checklist = Multi-Phase Checkpoint (each step must be ticked)
- Field Journal = Baton Loop (cross-session state externalization)

---

## Technique 5: In-Band Enforcement (Steering Hooks Concept)

Do not rely on AI "self-awareness"; instead, embed self-verification instructions in the prompt:

```
Before claiming "task complete" each time, MUST first self-check:
1. Did I skip any step in the behavior chain? Which step?
2. Did I guess any tool paths? If so, what is the actual tool-index path?
3. Are all Checklist items ticked? Why are the unticked ones not ticked?
4. If the answer to any of the above is "yes" / "not ticked", then the task is not complete;
   return to the corresponding step and execute again; do not declare completion.
```

This method makes the Agent self-audit before saying "done," which is more immediate than external validation.

---

## Technique 6: Opaque Identifiers (Code Words) — For API/Tool Parameters

Microsoft 2026 research found that semantic parameter names trigger models' tendency to "helpfully optimize."

```
WRONG: { "query": "...", "top": 9 }        → 68.4% parameter compliance rate
CORRECT: { "query": "...", "code": "alpha" } → 100% parameter compliance rate
```

**Application scenarios**:
- When precise configuration needs to be passed in bootstrap scripts, use short codes instead of semantic parameters.
- For parameters requiring strong guarantees in tool calls, use code word mapping.

---

## Technique 7: Dual AI Validation Loop

```
AI A (Executor) writes output
  ↓
AI B (Reviewer) checks against rules
  ↓ Pass
Output to user
  ↓ Fail
Return to AI A for correction with specific violation citations
```

**Application in this project**:
- Embed a "self-review" step in RULES.md: before outputting the report, the Agent uses its own capabilities to check each Checklist item.
- If any item is found incomplete, return to the corresponding step and complete it.

---

## Technique 8: Context Window Layout Optimization

LLM attention distribution (high → low):
```
[Beginning 10%] ████████████ ← Highest attention; put "immediate action" instructions here
[Middle 80%]    ████░░░░░░░░ ← Attention declines; put reference material here
[End 10%]       ████████████ ← Attention rises; put "do not skip" and Checklist here
```

**Specific applications**:
1. **Beginning 10%**: Execute-immediately instructions + trigger keywords
2. **Middle 80%**: Detailed workflow, reference links, tool list
3. **End 10%**: Excuse rebuttal table + hard Checklist + prohibited behavior list

---

## Practical Prompt Templates

### Template A: Mandatory Startup Template (Embed at the Beginning of RULES.md)

```markdown
## CRITICAL: After reading this document, you must immediately execute the following operations (do not just confirm; actually execute)

1. **NOW**: Detect the directory containing this file → this is the package root directory
2. **NOW**: If this is first use, write these rules into the global configuration (see the global injection section)
3. **NEXT**: Read `skills/SKILL.md` → `skills/routing.md` → determine which sub-skill to enter
4. **NEXT**: Read `skills/tool-index.md` to confirm tool status
5. **THEN**: Begin executing the actual task; do not remain in the "read" state

If you only reply "read", "done", or "I understand" without actually executing the above steps,
you have failed. What the user needs is for tools to be installed, code to be analyzed, and vulnerabilities to be verified,
not a confirmation message.
```

### Template B: Sub-module Entry Template (Embed at the Beginning of Each SKILL.md)

```markdown
## ACTION REQUIRED (Execute immediately after reading; do not wait)

After reading this file:
1. Confirm you understand the applicable scenarios of this skill
2. Check whether the required tools exist on this machine (read `../tool-index.md`)
3. If tools are missing → call bootstrap
4. If tools exist → begin the first step of the workflow
5. If you are unsure → list the specific questions; do not remain silent
```

### Template C: Task Completion Self-Check Template (Embed at the End of Each SKILL.md)

```markdown
## Task Completion Self-Check (MUST confirm each item before claiming completion)

□ I actually executed every step in the behavior chain (no skipping)
□ I did not guess any tool paths (all came from tool-index.md)
□ I produced reproducible commands/scripts/reports (not just descriptions of steps)
□ I updated the field-journal (if there were pitfalls)
□ I executed the post-completion Checklist (report + diagrams + lessons written back)
```

---

## Prohibited Behaviors (Supplemented from the Perspective of Agent Obedience)

- Forbidden to only reply "Understood, please tell me the specific task" after reading RULES.md
  → Correct approach: Execute global injection → read SKILL.md → read routing.md → determine entry point
- Forbidden to say "Steps 1-4 are complete" when in fact you only read through them once
  → Correct approach: Distinguish between "documents read" and "operations executed"; the latter produces actual side effects
- Forbidden to say "task complete" without executing the Checklist
  → The Checklist is the only definition of task completion
- Forbidden to use "based on experience" as a substitute for reading tool-index
  → Paths differ across machines; consulting tool-index is the only way to locate them

---

## Summary: If You Can Only Change One Thing

**Add a paragraph of "immediate action" instructions at the very beginning of RULES.md**, using bold, CRITICAL, NOW, and other strong directive words.

This is the modification with the highest return on investment. Most Agents' "not working" behavior comes from automatically entering "wait for user instructions" mode after reading a file. A mandatory "immediate action" instruction can break this pattern.

If you can change a second thing: **add an excuse rebuttal table**. Agents stop and make excuses at the first sign of resistance; block these excuses in advance.
