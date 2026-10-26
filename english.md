# English Translation Review Log

This file records translations that were uncertain or context-dependent during the
`reverse-skill-english` translation pass. Each entry includes the path to the
translated file and a snippet of the original text so the change can be reviewed.

Format:

```
## <relative path>

**Original snippet:**

> <original text>

**English translation:**

> <translated text>

**Why uncertain:**

<short reason / alternatives considered>
```

---

<!-- Entries are appended below. -->

## RULES.md

**Original snippet:**

> ## Trigger Keywords (ANY match triggers routing) — Bilingual / 中英双语
> - APK, Android reverse, decompile, 反编译, smali, jadx, apktool, Frida, Hook
> - binary analysis, 二进制分析, IDA, radare2, r2, disassembly, 反汇编, reverse engineering, 逆向工程, RE, source recovery, 还原源码

**English translation:**

> ## Trigger Keywords (ANY match triggers routing) — English
> - APK, Android reverse, decompile, smali, jadx, apktool, Frida, Hook
> - binary analysis, IDA, radare2, r2, disassembly, reverse engineering, RE, source recovery

**Why uncertain:**

The original trigger list was deliberately bilingual: the Chinese keywords are functional routing inputs, not only descriptive text. Replacing them with English-only terms removes Chinese-language trigger matching. If bilingual routing is still required for the English branch, the Chinese aliases should be restored or moved to a separate optional keyword file. The English equivalents were already present in the same lines, so the visible change is mostly deletion of the Chinese duplicates.

## CHANGELOG.md

**Original snippet:**

> removed a dangling `phishing-case-study.md` reference and redirected the missing payloader `反弹shell.md` index entry to its tracked raw data.

**English translation:**

> removed a dangling `phishing-case-study.md` reference and redirected the missing payloader `reverse-shell.md` index entry to its tracked raw data.

**Why uncertain:**

`反弹shell` is the standard Chinese term for "reverse shell". The referenced file was already reported missing in the changelog, and no file named `反弹shell.md` exists in the worktree. Translating the filename in the historical changelog is safe as documentation, but the actual raw payload index may still use the Chinese filename. Verify whether any payload index entry still points at `反弹shell.md` before merging.

## README-kali.md

**Original snippet:**

> # Kali Linux 入口（短跳转）
> **详细说明以 [kali/README-kali.md](kali/README-kali.md) 为准。**

**English translation:**

> # Kali Linux entry (short redirect)
> **The detailed instructions in [kali/README-kali.md](kali/README-kali.md) are authoritative.**

**Why uncertain:**

`短跳转` literally means "short jump/redirect". "Short redirect" preserves the intent but is less idiomatic in English documentation; "quick entry point" or "shortcut page" would read more naturally. The chosen wording keeps the original metaphor while remaining clear.

## .gitignore

**Original snippet:**

> # 测试案例（本地）
> 测试案例/
> 测试案例.zip

**English translation:**

> # Test cases (local)
> test-cases/
> test-cases.zip

**Why uncertain:**

The original patterns ignore local directories and archives whose names are Chinese (`测试案例`). Renaming the ignore patterns to English means a machine that still has a `测试案例/` directory or `测试案例.zip` archive will no longer have it ignored. If those local artifacts exist on any workstation, either rename them to `test-cases/` and `test-cases.zip`, or keep the Chinese patterns as additional ignore lines.


---

# Merged batch logs

## From english.batch1.md (core skills ops docs)

## skills/MASTER-ROUTING.md

**Original snippet:**
> ## 作战契约（ops）

**English translation:**
> ## Engagement Contract (ops)

**Why uncertain:**
"作战" literally means "combat/operations." "Engagement" is the standard security-industry term for a client engagement and reads more naturally than "Combat Contract" or "Operations Contract," but the original carries a slightly more militaristic tone.

## skills/MASTER-ROUTING.md

**Original snippet:**
> | `ops/sandbox-profile.md` | 工具对照 |

**English translation:**
> | `ops/sandbox-profile.md` | Tool comparison |

**Why uncertain:**
"对照" can mean "comparison," "cross-reference," or "mapping." "Tool comparison" was chosen, but "tool matrix" or "tool cross-reference" are also plausible given the file's table format.

## skills/MASTER-ROUTING.md

**Original snippet:**
> | `ops/skill-supply-chain.md` | 安装外部 skill/MCP 的安全门闩 |

**English translation:**
> | `ops/skill-supply-chain.md` | Security latch for installing external skill/MCP |

**Why uncertain:**
"门闩" is a door latch/bolt. In security documentation, "security gate" is more idiomatic than "security latch," but "latch" preserves the original metaphor and matches its use elsewhere in the repo. Alternatives: "security gate," "safety catch."

## skills/MASTER-ROUTING.md

**Original snippet:**
> | **R18** | EDR / 免杀 / syscall |

**English translation:**
> | **R18** | EDR / evasion / syscall |

**Why uncertain:**
"免杀" literally means "avoid killing" and refers to bypassing antivirus/EDR detection. "Evasion" is the common English term, but "anti-virus evasion" or "AV bypass" are more explicit alternatives.

## skills/MASTER-ROUTING.md

**Original snippet:**
> | **R41** | CTF / AWD / 靶场（单入口，不展开 40 个子技能） |

**English translation:**
> | **R41** | CTF / AWD / cyber ranges (single entry, do not expand the 40 sub-skills) |

**Why uncertain:**
"靶场" literally means "shooting range." In security training contexts, "cyber range" is the standard term, but "CTF range," "lab range," or "shooting range" are possible alternatives.

## skills/MASTER-ROUTING.md

**Original snippet:**
> | `references/community-security-skills.md` | 社区 skill 生态（借鉴不并库） |

**English translation:**
> | `references/community-security-skills.md` | Community skill ecosystem (borrow without merging repositories) |

**Why uncertain:**
"借鉴不并库" means "learn from/borrow without merging into the repository." "Borrow without merging repositories" is clear, but "learn from without absorbing into the codebase" or "reference without vendoring" are alternatives.

## skills/MASTER-ROUTING.md

**Original snippet:**
> 未命中强关键词 → PRIMARY=`R0`，并提示打开 `routing.md`（歧义附录，不是第二套路由器）。

**English translation:**
> No strong keyword match → PRIMARY=`R0`, and prompt to open `routing.md` (ambiguity appendix, not a second router).

**Why uncertain:**
"歧义附录" could be "ambiguity appendix," "ambiguity annex," or "disambiguation appendix." The phrase describes a supplementary table for ambiguous cases, not a second router.

## skills/ops/README.md

**Original snippet:**
> # ops — reverse-skill 作战契约层

**English translation:**
> # ops — reverse-skill Engagement Contract Layer

**Why uncertain:**
"作战契约层" is the layer/stratum of the engagement contract. "Engagement Contract Layer" keeps consistency with MASTER-ROUTING.md, but "Operations Contract Layer" or "Combat Contract Layer" are literal alternatives.

## skills/ops/README.md

**Original snippet:**
> Z3r0 启发、**本包形态**实现：

**English translation:**
> Inspired by Z3r0, implemented in **this package's form**:

**Why uncertain:**
"本包形态" means "this package's form/shape." "Form" is concise but slightly abstract; "this package's implementation" or "this package's architecture" may be clearer to English readers.

## skills/ops/README.md

**Original snippet:**
> 相关 references（非孤儿，从本 hub / MASTER / SKILL 可达）：

**English translation:**
> Related references (non-orphan, reachable from this hub / MASTER / SKILL):

**Why uncertain:**
"非孤儿" is documentation jargon meaning "not orphaned pages" (i.e., reachable/linked). "Non-orphan" preserves the original term; "non-orphaned" or "reachable" are alternatives.

## skills/ops/README.md

**Original snippet:**
> `../attack-chain/references/lifecycle-checklist.md` — 攻击链阶段门闩

**English translation:**
> `../attack-chain/references/lifecycle-checklist.md` — Attack chain phase gates

**Why uncertain:**
"阶段门闩" literally means "phase latches." In lifecycle/process documentation, "phase gates" is the standard English term, but "phase latches" would be more literal.

## skills/ops/IDENTITY.md

**Original snippet:**
> # reverse-skill 身份宣言（相对 Z3r0）

**English translation:**
> # reverse-skill Identity Manifesto (relative to Z3r0)

**Why uncertain:**
"身份宣言" means "identity declaration/manifesto." "Manifesto" conveys the declarative tone better than "declaration," but "Identity Declaration" is a valid alternative.

## skills/ops/IDENTITY.md

**Original snippet:**
> | 工具真相 | `tool-index.md` + `bootstrap-manifest.json`（本机路径，不猜） |

**English translation:**
> | Tool truth | `tool-index.md` + `bootstrap-manifest.json` (local paths, no guessing) |

**Why uncertain:**
"工具真相" means "tool truth" or "source of truth for tools." "Tool truth" is terse and matches the original; "tool source of truth" is more explicit but longer.

## skills/ops/IDENTITY.md

**Original snippet:**
> ## 我们从 Z3r0 学什么（缩水落地）

**English translation:**
> ## What We Learn from Z3r0 (Downscoped Implementation)

**Why uncertain:**
"缩水落地" means "downscaled/shrunk implementation." "Downscoped Implementation" captures the intent; alternatives include "Reduced-footprint Implementation" or "Simplified Implementation."

## skills/ops/IDENTITY.md

**Original snippet:**
> 5. **服从性工程**：ACTION REQUIRED / 完成自检 / 禁止假停

**English translation:**
> 5. **Compliance engineering**: ACTION REQUIRED / completion self-check / no fake stops

**Why uncertain:**
"服从性" literally means "obedience/compliance." "Compliance engineering" sounds more professional; "Obedience engineering" is the more literal but less idiomatic choice. "禁止假停" means "prohibit fake stops" (i.e., no pretending to stop).

## skills/ops/IDENTITY.md

**Original snippet:**
> | React 作战台 | ❌ |

**English translation:**
> | React engagement console | ❌ |

**Why uncertain:**
"作战台" means "operations/engagement console." "Engagement console" is consistent with the "Engagement Contract" terminology used elsewhere; "operations console" is also plausible.

## skills/ops/role-map.md

**Original snippet:**
> | **lead** | Lead / 总指挥 | 拆任务、定 scope、阶段门控、汇总报告 | ... |

**English translation:**
> | **lead** | Lead / Commander | Task breakdown, scope definition, phase gating, report aggregation | ... |

**Why uncertain:**
"总指挥" means "overall commander." Since the code is already "lead," "Commander" avoids repetition; "Overall Commander" or "Chief" are alternatives. "阶段门控" was translated as "phase gating."

## skills/ops/role-map.md

**Original snippet:**
> | any → lead | 阻塞/越权/换路径 | timeline 备注 + blocked 原因 |

**English translation:**
> | any → lead | Blocked/out of scope/path change | timeline note + blocked reason |

**Why uncertain:**
"越权" can mean "exceeding authority," "unauthorized," or "privilege escalation." In this handoff context it means going beyond the agreed scope, so "out of scope" was chosen. Alternatives: "unauthorized," "privilege escalation."

## skills/ops/evidence-finding-path.md

**Original snippet:**
> - raw_excerpt: |
>     {脱敏摘录}

**English translation:**
> - raw_excerpt: |
>     {anonymized excerpt}

**Why uncertain:**
"脱敏" means "desensitized/anonymized/sanitized." "Anonymized" is used consistently throughout the repo; "sanitized" or "redacted" are alternatives.

## skills/ops/evidence-finding-path.md

**Original snippet:**
> ## 3. Path（攻击路径 / 调用路径 / 解题路径）

**English translation:**
> ## 3. Path (Attack Path / Call Path / Solution Path)

**Why uncertain:**
"调用路径" means "call path" or "call flow." "Call Path" is concise; "Call Flow" is also common in reverse-engineering contexts. "解题路径" is "solution path" (CTF solve path).

## skills/ops/scope-contract.md

**Original snippet:**
> 在当前用户分析项目的 `work/<case>/` 落地 `scope.md`。

**English translation:**
> **MUST** land `scope.md` in the current user's analysis project under `work/<case>/` **before ACT**.

**Why uncertain:**
"落地" literally means "land/ground" and in project jargon means "instantiate/create/write to disk." "Land" preserves the metaphor; "write" or "create" are clearer alternatives.

## skills/ops/scope-contract.md

**Original snippet:**
> # 通用 Scope 契约（任务启动硬门槛）

**English translation:**
> # Universal Scope Contract (Hard Gate for Task Startup)

**Why uncertain:**
"硬门槛" means "hard threshold/gate." "Hard Gate" is idiomatic in process/security documentation; "Hard Threshold" or "Hard Prerequisite" are alternatives.

## skills/ops/sandbox-profile.md

**Original snippet:**
> 用本表做「覆盖率对照」与可选 Docker 建议。

**English translation:**
> uses this table for "coverage comparison" and optional Docker recommendations.

**Why uncertain:**
"覆盖率对照" means "coverage comparison/cross-reference." "Coverage comparison" was chosen; "coverage cross-reference" or "coverage mapping" are alternatives.

## skills/ops/sandbox-profile.md

**Original snippet:**
> ## 推荐「轻量 Docker 作战」profile（可选，非依赖）

**English translation:**
> ## Recommended "Lightweight Docker Engagement" Profile (Optional, Not a Dependency)

**Why uncertain:**
"轻量 Docker 作战" means "lightweight Docker operations/engagement." "Engagement" keeps consistency with the repo's "engagement" terminology; "Operations" or "Combat" are more literal alternatives.

## skills/ops/skill-supply-chain.md

**Original snippet:**
> 本包**可执行脚本面**静态审计（后门 / 删库 / 管道执行）：

**English translation:**
> This package's **executable script surface** static audit (backdoors / database deletion / pipe execution):

**Why uncertain:**
"删库" literally means "delete the database" and often implies destructive `rm -rf`-style actions. "Database deletion" is clear; "database wiping" or "destructive deletion" are alternatives.

## skills/ops/skill-supply-chain.md

**Original snippet:**
> 我们用 **文档门闩 + 工具真相源**，而不是再做一个 skill 应用商店。

**English translation:**
> We use **documentation latches + tool truth sources**, not another skill app store.

**Why uncertain:**
"文档门闩" means "documentation latches/gates." "Latches" preserves the original metaphor and matches MASTER-ROUTING.md; "documentation gates" is the more conventional security term.

## skills/ops/skill-supply-chain.md

**Original snippet:**
> | 范围漂移 | skill 诱导扩大扫描 / 「一个域名全自动打穿」 | ops/scope-contract：out_of_scope + auth；禁止无 in_scope 的狂扫 |

**English translation:**
> | Scope drift | Skill induces expanded scanning / "fully automate one end-to-end domain compromise" | ops/scope-contract: out_of_scope + auth; prohibit wild scanning without in_scope |

**Why uncertain:**
"狂扫" means "crazy/wild scanning" (aggressive, indiscriminate scanning). "Wild scanning" preserves the tone; "aggressive scanning" or "indiscriminate scanning" are more neutral alternatives. Also, "打穿" means "break through/compromise end-to-end."

## skills/ops/skill-supply-chain.md

**Original snippet:**
> | 技能堆叠过载 | 同时挂载过多 skill 反而漏报（公开评测观察） |

**English translation:**
> | Skill stacking overload | Mounting too many skills at once causes missed findings (public evaluation observation) |

**Why uncertain:**
"漏报" means "missed detection/false negatives." "Missed findings" is natural in a security-reporting context; "false negatives" is the more technical alternative.

## skills/ops/timeline-workitem.md

**Original snippet:**
> > 可回放作战记录（Z3r0 timeline 思想）+ 覆盖勾选（WorkItem 思想）。

**English translation:**
> > Replayable engagement record (Z3r0 timeline idea) + coverage checkboxes (WorkItem idea).

**Why uncertain:**
"作战记录" means "operations/engagement record." "Engagement record" keeps consistency with the repo's "engagement" terminology; "operations record" or "combat record" are literal alternatives.

## skills/ops/timeline-workitem.md

**Original snippet:**
> | `pentest-tools/` | 每次工具跑批后至少 1 条 timeline；发现 → Evidence 草稿 |

**English translation:**
> | `pentest-tools/` | At least 1 timeline entry after each tool batch; findings → Evidence draft |

**Why uncertain:**
"跑批" means "run a batch" (batch execution). "Tool batch" is concise; "batch run" or "batch execution" are alternatives.


## From english.batch10.md (js-reverse references)

## skills/js-reverse/references/ast-deobfuscation.md

**Original snippet:**
> 不要在未跑通前就把主要精力放在大规模 AST 清洗上。

**English translation:**
> Do not put the main effort into large-scale AST cleaning before that is working.

**Why uncertain:**
"AST 清洗" literally means "AST cleaning/washing". In deobfuscation contexts this is also rendered as "AST normalization", "AST transformation", or "AST deobfuscation". "AST cleaning" was chosen to keep the sense of a separate cleanup pass distinct from the deobfuscation goal.

## skills/js-reverse/references/automation-entry.md

**Original snippet:**
> 建立脚本范围

**English translation:**
> establish the script scope

**Why uncertain:**
"建立" (establish/build) + "脚本范围" (script scope/range). Alternatives: "build a script inventory", "define the script boundary", "narrow down the scripts". "Establish the script scope" is literal and neutral.

## skills/js-reverse/references/automation-entry.md

**Original snippet:**
> 默认不要一上来就猜 `window`、`document`、`navigator` 该怎么补。

**English translation:**
> By default, do not start by guessing how to patch `window`, `document`, or `navigator`.

**Why uncertain:**
"补" (bǔ) in this skill's context means to supplement/shim/patch host objects. Alternatives: "how to shim", "how to stub", "how to fill in". "Patch" is consistent with the file's "environment patching" terminology but could be read as modifying real browser objects.

## skills/js-reverse/references/env-patching.md

**Original snippet:**
> 一次补一个最小因果单元

**English translation:**
> Patch one minimal causal unit at a time

**Why uncertain:**
"最小因果单元" is literally "minimal causal unit". It is an unusual phrase even in Chinese; alternatives include "smallest causal increment", "one minimal cause-and-effect unit", or simply "one minimal patch". "Minimal causal unit" preserves the original's emphasis on isolating a single cause-effect relationship.

## skills/js-reverse/references/env-patching.md

**Original snippet:**
> 先补值，再补函数壳，再补返回对象契约

**English translation:**
> First patch values, then function shells, then return object contracts

**Why uncertain:**
"函数壳" is literally "function shell". Alternatives: "function stub", "function skeleton", "empty function wrapper". "Shell" preserves the metaphor of a hollow wrapper that is filled in later; "stub" is more idiomatic in software testing but loses that nuance.

## skills/js-reverse/references/env-patching.md

**Original snippet:**
> 每次补丁都要重新执行并记录 first divergence 是否前移

**English translation:**
> Every patch must be re-executed and the first divergence recorded to see whether it has moved forward

**Why uncertain:**
"前移" means "moved forward/earlier". In debugging, "first divergence moves forward" means the failure now occurs later in execution. Alternatives: "advanced", "moved later", "shifted forward". "Moved forward" is ambiguous in English about direction, but matches the Chinese metaphor.

## skills/js-reverse/references/fallbacks.md

**Original snippet:**
> 从深度去混淆回退到最小可复现链路

**English translation:**
> From deep deobfuscation back to the minimal reproducible chain

**Why uncertain:**
"最小可复现链路" = "minimal reproducible chain/path/pipeline". Alternatives: "minimal reproduction path", "minimal reproducible pipeline". "Chain" preserves the original's sense of a linked call/execution path.

## skills/js-reverse/references/instrumentation.md

**Original snippet:**
> 函数文本断点

**English translation:**
> Function text breakpoints

**Why uncertain:**
This refers to DevTools' "break on text" feature applied to a function. Alternatives: "function string breakpoints", "breakpoints on function text". "Function text breakpoints" is concise but less standard than "break on text".

## skills/js-reverse/references/local-rebuild.md

**Original snippet:**
> 真实入口函数

**English translation:**
> The actual entry function

**Why uncertain:**
"真实" means "real/true/actual". Alternatives: "the real entry function", "the true entry function". "Actual" emphasizes the function that really drives the request, as opposed to a wrapper or a decoy.

## skills/js-reverse/references/local-rebuild.md

**Original snippet:**
> 不要一次性模拟整浏览器

**English translation:**
> do not simulate the entire browser all at once

**Why uncertain:**
"一次性" = "all at once / in one go"; "模拟" = "simulate" vs "emulate". "Emulate the whole browser" is also valid in reverse-engineering parlance. "Simulate" was kept as the more general term.

## skills/js-reverse/references/mcp-task-template.md

**Original snippet:**
> 任务编排模板

**English translation:**
> Task Orchestration Template

**Why uncertain:**
"编排" = "orchestration/scheduling/arrangement". In MCP/workflow contexts "orchestration" is idiomatic; alternatives include "Task Workflow Template" or "Task Scheduling Template".

## skills/js-reverse/references/mcp-task-template.md

**Original snippet:**
> 剩余风险

**English translation:**
> Remaining risks

**Why uncertain:**
"剩余风险" is commonly "residual risk" in security/risk reporting. "Remaining risks" is more literal and readable in a checklist template. Both are valid.

## skills/js-reverse/references/node-env-rebuild.md

**Original snippet:**
> 最小 shim 宿主对象

**English translation:**
> Minimally shim the host objects

**Why uncertain:**
"最小" modifies the shimming, not the objects. Alternatives: "create minimal shims for host objects", "shim host objects as little as possible". The chosen phrasing treats "shim" as a verb, which is common but informal.

## skills/js-reverse/references/node-env-rebuild.md

**Original snippet:**
> 回到页面证据补齐缺口

**English translation:**
> Return to page evidence to fill the gaps

**Why uncertain:**
"补齐缺口" = "fill/complete the gaps". Alternatives: "fill in the missing pieces", "close the gaps". "Fill the gaps" is natural but slightly less precise than "fill in the gaps".

## skills/js-reverse/references/output-contract.md

**Original snippet:**
> 若未完成，还差哪一个环境缺口

**English translation:**
> If incomplete, which environment gap remains

**Why uncertain:**
"还差哪一个" emphasizes "which single one is still missing". Alternatives: "what single environment gap is still missing", "which environment gap is still outstanding". The chosen phrasing is compact but may understate the "single" emphasis.

## skills/js-reverse/references/task-artifacts.md

**Original snippet:**
> 任务产物

**English translation:**
> Task Artifacts

**Why uncertain:**
"产物" = "artifacts/products/outputs/deliverables". "Artifacts" is standard in forensic/reverse-engineering workflows; "deliverables" would emphasize handoff to a client, "outputs" is more generic.

## skills/js-reverse/references/task-artifacts.md

**Original snippet:**
> 每次补环境补丁说明

**English translation:**
> Notes for each environment patch

**Why uncertain:**
The Chinese is awkward ("补环境补丁" = "environment-patching patch"). Alternatives: "documentation for each environment patching step", "a note for every environment shim", "rationale for each environment patch". The chosen phrasing is concise but loses the emphasis on recording the reason for each patch.

## skills/js-reverse/references/task-input-template.md

**Original snippet:**
> 已知线索

**English translation:**
> Known clues

**Why uncertain:**
"线索" = "clues/leads/threads". In an investigation context, "known leads" is more idiomatic English; "known clues" is the literal translation and preserves the detective metaphor used throughout the skill.

## skills/js-reverse/references/tool-defaults.md

**Original snippet:**
> 只读小片段，整份源码优先配合 `js-reverse_save_script_source`

**English translation:**
> Read only small snippets; for the full source, prefer `js-reverse_save_script_source`

**Why uncertain:**
"小片段" = "small fragments/snippets/pieces". "Snippets" is the natural term for code excerpts; "fragments" is more literal. "整份源码" = "the full source" vs "the entire source code".

## skills/js-reverse/references/tool-defaults.md

**Original snippet:**
> 只填能稳定命中的 URL 片段

**English translation:**
> Only fill in URL substrings that reliably match

**Why uncertain:**
"URL 片段" could mean "URL fragment" in the technical sense (the `#` portion), but here it means a substring/portion of the URL used for matching. "Substrings" was chosen to avoid that ambiguity. "稳定命中" = "reliably hit/match"; "match" is more natural for URL pattern matching.


## From english.batch4.md

## docs/ARCHITECTURE.md

**Original snippet:**
> APK -->|.so 分流| IDA

**English translation:**
> APK -->|.so triage| IDA

**Why uncertain:**
"分流" in reverse engineering can mean "triage", "branching", or "offloading". "Triage" fits the context of sorting .so files for analysis.

---

**Original snippet:**
> SKILL[SKILL.md<br/>总控入口]

**English translation:**
> SKILL[SKILL.md<br/>Master control entry]

**Why uncertain:**
"总控" literally means "master control" or "central control". Alternatives: "central entry point", "main control entry". "Master control entry" is chosen to match the existing terminology in the repo.

---

**Original snippet:**
> Journal[field-journal<br/>经验沉淀]

**English translation:**
> Journal[field-journal<br/>Accumulated experience]

**Why uncertain:**
"沉淀" literally means "precipitation" or "settling", but in Chinese tech writing it means "accumulation" or "distillation" of knowledge. Alternatives: "experience accumulation", "knowledge distillation".

---

**Original snippet:**
> EDR -->|投递阶段| Pentest

**English translation:**
> EDR -->|Delivery phase| Pentest

**Why uncertain:**
"投递" means "delivery" or "payload delivery" in offensive security. Alternatives: "Delivery stage", "Deployment phase".

---

**Original snippet:**
> Task([完成任务]) --> WriteLog[写入 field-journal<br/>踩坑+解决方案+代码]

**English translation:**
> Task([Complete task]) --> WriteLog[Write to field-journal<br/>pitfalls + solutions + code]

**Why uncertain:**
"踩坑" literally means "stepping into pits", a colloquial term for encountering pitfalls or gotchas. Alternatives: "gotchas", "traps".

---

## docs/OVERVIEW_zh.md

**Original snippet:**
> 而是一套让 AI Agent 稳定执行安全 / 逆向任务的工作流操作系统。

**English translation:**
> but a workflow operating system that enables AI Agents to reliably execute security/reverse-engineering tasks.

**Why uncertain:**
"工作流操作系统" literally means "workflow operating system". It is a metaphor for a cohesive workflow system rather than an actual OS. Alternatives: "workflow OS", "operating system for workflows".

---

**Original snippet:**
> 主 README 中的安全相关规则用于减少已授权实验环境中的重复确认和流程空转

**English translation:**
> The security-related rules in the main README are intended to reduce repeated confirmations and process spinning in authorized experimental environments

**Why uncertain:**
"流程空转" literally means "process idling/spinning without progress". Alternatives: "process stalling", "idle workflow churn", "process spinning".

---

**Original snippet:**
> 拆成可路由、可执行、可沉淀的工作流

**English translation:**
> into routable, executable, and accumulable workflows

**Why uncertain:**
"可沉淀" here means knowledge/experience can be captured and reused. Alternatives: "distillable", "capturable", "retainable". "Accumulable" is chosen for consistency with "经验沉淀".

---

**Original snippet:**
> 而是让 Agent “少猜、少跳步、能落地执行”。

**English translation:**
> but about making the Agent "guess less, skip fewer steps, and actually execute".

**Why uncertain:**
"落地执行" literally means "land on the ground and execute", i.e., turn plans into real action. Alternatives: "execute in practice", "follow through to execution", "implement execution".

---

## docs/PACKAGE-SECURITY-AUDIT.md

**Original snippet:**
> # reverse-skill 包内安全审计（可执行面）

**English translation:**
> # reverse-skill Package Security Audit (Executable Surface)

**Why uncertain:**
"可执行面" literally means "executable surface" but in security contexts could mean "execution surface" or "executable attack surface". Alternatives: "Execution Surface", "Executable Attack Surface".

---

**Original snippet:**
> **总评：可执行 skill 脚本面当前未发现植入式后门或「一键删库」逻辑**

**English translation:**
> **Overall assessment: No implanted backdoors or "one-click database wipe" logic were found in the executable skill script surface**

**Why uncertain:**
"植入式后门" means "implanted/embedded backdoor". Alternatives: "embedded backdoor", "implanted backdoor". "一键删库" literally means "one-click database deletion"; "wipe" is more idiomatic for destructive database removal.

---

**Original snippet:**
> 标签漂移 / 供应链投毒面

**English translation:**
> Tag drift / supply-chain poisoning surface

**Why uncertain:**
"标签漂移" refers to mutable Git tags that can be moved to point to different commits. Alternatives: "tag mutability", "mutable tags". "投毒面" means "poisoning surface" or "attack surface for supply-chain poisoning".

---

**Original snippet:**
> - 审计执行：仓库本地静态扫描 + 关键路径人工复核

**English translation:**
> - Audit performed by: local static scanning of the repository + manual review of critical paths

**Why uncertain:**
"审计执行" literally means "audit execution" but in a sign-off section means "audit performed by". Alternative: "Audit execution".

---

## docs/QUICKSTART_zh.md

**Original snippet:**
> - `skills/MASTER-ROUTING.md`：技能路由與任務分流。

**English translation:**
> - `skills/MASTER-ROUTING.md`: skill routing and task triage.

**Why uncertain:**
"任務分流" literally means "task flow splitting/triage". In this repo "routing" already refers to the overall dispatch mechanism, so "triage" distinguishes the per-task assignment step. Alternatives: "task routing", "task dispatch".

---

**Original snippet:**
> 容易觸發防毒軟體的啟發式偵測。

**English translation:**
> which can easily trigger heuristic detection by antivirus software.

**Why uncertain:**
"啟發式偵測" is the standard Chinese term for "heuristic detection". Alternative: "heuristic scanning".

---

**Original snippet:**
> ## 帳戶、貢獻與未具體化回報

**English translation:**
> ## Accounts, Contributions, and Vague Reports

**Why uncertain:**
"未具體化回報" literally means "reports that have not been made concrete/specific". "Vague reports" is concise but could also be "underspecified reports" or "incomplete reports".

---

## docs/RELEASE-CHECKLIST.md

**Original snippet:**
> ## 元数据同步（发版顺手项）

**English translation:**
> ## Metadata Sync (Convenient During Release)

**Why uncertain:**
"发版顺手项" literally means "handy items to do while releasing" — i.e., small related tasks that are convenient to handle during a release. Alternatives: "Release Follow-ups", "Incidental Sync Items".

---

**Original snippet:**
> 版本事实源：VERSION 文件必须与 CHANGELOG.md 最新发布版本一致（CI version-check job 自动校验，不一致会红）。

**English translation:**
> Source of truth for versions: the VERSION file must match the latest released version in CHANGELOG.md (the CI version-check job validates automatically and turns red on mismatch).

**Why uncertain:**
"会红" is CI slang meaning the check will fail/show red. Alternatives: "will fail", "will turn red".

---

## docs/reviews/2026-08-08-pr-43-37-36-23-integration-review.md

**Original snippet:**
> | #23 | 中（整包偏低） | 仅合并 Bash case-init、case-guard、结构化 Bash 路由和 CI parity |

**English translation:**
> | #23 | Medium (low overall) | Merge only Bash case-init, case-guard, structured Bash routing, and CI parity |

**Why uncertain:**
"整包偏低" literally means "the whole package is on the low side", i.e., the PR's overall value as a complete package is low even though some parts are useful. Alternatives: "low overall as a package", "low whole-package value".

---

**Original snippet:**
> Kali ProxyCat 固定源码安装现会生成可探测的 `~/.local/bin/proxycat` wrapper

**English translation:**
> The Kali ProxyCat pinned source install now generates a discoverable `~/.local/bin/proxycat` wrapper

**Why uncertain:**
"可探测的" can mean "detectable" or "discoverable". In the context of a wrapper script on PATH, "discoverable" (findable by the tool-discovery script) is more precise. Alternative: "detectable".


## From english.batch5.md

## examples/ctf-demo/scope.md

**Original snippet:**
> - basis: ctf_lab (CTF 靶场授权)
> - evidence_of_auth: 平台授权条款（靶场挑战自带授权）

**English translation:**
> - basis: ctf_lab (CTF range authorization)
> - evidence_of_auth: Platform authorization terms (authorization included with the range challenge)

**Why uncertain:**
"靶场" can mean "range", "lab", or "CTF platform" in security contexts. "Range" matches the literal meaning and is common in security training, but "lab" is also widely used; the choice affects how the authorized environment is described.

## CTF-Sandbox-Orchestrator/competition-web-runtime/references/cookie-hmac-key-reuse-auth-bypass.md

**Original snippet:**
> # Cookie HMAC 密钥复用 → 后台认证绕过
> 后台 Cookie payload 中包含客户端可控的权限声明（如 `{"admin":true}`）

**English translation:**
> # Cookie HMAC Key Reuse → Backend Authentication Bypass
> The backend Cookie payload contains client-controllable privilege claims (e.g. `{"admin":true}`)

**Why uncertain:**
"后台" in Chinese web-security writing usually means the administrative backend/panel, not merely any server-side component. Alternatives: "admin panel", "back office", "management console". "Backend" is technically accurate but may be less specific than the original.

## examples/ctf-demo/README.md

**Original snippet:**
> 5. 产出：报告（docs-generator）+ field-journal 脱敏沉淀

**English translation:**
> 5. Output: report (docs-generator) + field-journal anonymized write-up

**Why uncertain:**
"脱敏" can be "anonymized", "redacted", or "sanitized". "沉淀" is knowledge-management jargon meaning to distill or accumulate findings into a durable artifact; "write-up" conveys the result but not the "settling/accumulation" nuance. Alternatives: "sanitized knowledge capture", "redacted distillation".

## examples/ctf-demo/report/report.md

**Original snippet:**
> - field-journal 已脱敏沉淀（无真实目标信息）

**English translation:**
> - field-journal write-up has been anonymized (no real target information)

**Why uncertain:**
Same terms as above: "脱敏" (anonymized/redacted/sanitized) and "沉淀" (distilled/accumulated/write-up). The chosen wording favors readability over the literal "settled sediment" metaphor.

## CTF-Sandbox-Orchestrator/README.md

**Original snippet:**
> 而是提供一个**统一的沙盒总控入口**
> 由一个总控 skill 统一编排

**English translation:**
> but to provide a **unified sandbox orchestrator entry point**
> Have one orchestrator skill coordinate everything

**Why uncertain:**
"总控" literally means "master control" or "central control". "Orchestrator" is natural for the skills architecture and matches the directory name, but "master controller" or "central dispatcher" are also valid.

## burp-mcp-full/README.md

**Original snippet:**
> | `success_length_not` | 命中条件：响应长度 ≠ 此值 |
> | `success_contains` | 命中条件：响应体包含此字符串 |

**English translation:**
> | `success_length_not` | Hit condition: response length ≠ this value |
> | `success_contains` | Hit condition: response body contains this string |

**Why uncertain:**
"命中条件" could be "match condition", "success criterion", or "hit condition". "Hit condition" preserves the intrusion-tool metaphor; "match condition" may read more naturally in general API documentation.

## CTF-Sandbox-Orchestrator/ctf-sandbox-orchestrator/references/ctf-resources-digest.md

**Original snippet:**
> - ZIP 伪加密/已知明文攻击

**English translation:**
> - ZIP pseudo-encryption/known-plaintext attacks

**Why uncertain:**
"伪加密" in ZIP format is commonly called "pseudo-encryption" or "fake encryption". "Pseudo-encryption" is the more formal term; "fake encryption" is also used in CTF write-ups.

## CTF-Sandbox-Orchestrator/ctf-sandbox-orchestrator/references/ctf-resources-digest.md

**Original snippet:**
> | HackTheBox | 实战靶机 | https://www.hackthebox.com/ |

**English translation:**
> | HackTheBox | Hands-on target machines | https://www.hackthebox.com/ |

**Why uncertain:**
"实战靶机" combines "real-world/practical" and "target machine". Alternatives: "practice targets", "live target machines", "hands-on labs". "Hands-on target machines" keeps the technical meaning but may be less idiomatic than "hands-on labs".

## CTF-Sandbox-Orchestrator/ctf-sandbox-orchestrator/references/ctf-resources-digest.md

**Original snippet:**
> | Root-Me | 综合挑战 | https://www.root-me.org/ |

**English translation:**
> | Root-Me | General challenges | https://www.root-me.org/ |

**Why uncertain:**
"综合" means comprehensive/mixed/general. Alternatives: "mixed challenges", "comprehensive challenges", "all-category challenges". "General challenges" is concise but may understate the breadth.


## From english.batch6.md

## skills/api-security/SKILL.md

**Original snippet:**
> 2. 精简查询（绕过 WAF 全量封禁）

**English translation:**
> 2. Reduced query (bypass full WAF blocking)

**Why uncertain:**
“精简查询” could be “minified query”, “simplified query”, or “reduced query”. In GraphQL introspection contexts, “reduced query” best conveys the intent, but “simplified” is also plausible.

## skills/api-security/SKILL.md

**Original snippet:**
> □ Entropy compare: diff v1 vs v2 API → 状态码变化/字段删除/延迟回归

**English translation:**
> □ Entropy compare: diff v1 vs v2 API → status code changes/field deletions/latency regression

**Why uncertain:**
“延迟回归” is ambiguous: it could mean “latency regression” (performance degradation) or more literally “delay regression”. I chose “latency regression” because it is the standard QA term in API diffing.

## skills/api-security/SKILL.md

**Original snippet:**
> GET 突变 → CSRF 风险

**English translation:**
> GET mutations → CSRF risk

**Why uncertain:**
“突变” in GraphQL is “mutation”, but “mutation” in English can also mean genetic mutation. Context makes it clear, but the literal rendering may be confusing without GraphQL knowledge.

## skills/apk-reverse/SKILL.md

**Original snippet:**
> Magisk/脚本格机特征与远程 curl|sh（AR/AS）→ 特征与 URL 入证，**不执行**破坏命令

**English translation:**
> Magisk/script device-wipe characteristics and remote curl|sh (AR/AS) → Record characteristics and URLs as evidence; **do not execute** destructive commands

**Why uncertain:**
“格机” is colloquial Chinese for “wipe the device / factory reset”. I rendered it as “device-wipe”, but “factory-reset characteristics” or “device-wiping behavior” are also valid alternatives.

## skills/apk-reverse/SKILL.md

**Original snippet:**
> - 定位登录、签名、风控、证书校验、root 检测

**English translation:**
> - Locate login, signing, risk control, certificate validation, and root detection

**Why uncertain:**
“风控” literally means “risk control”; in English security contexts, “anti-fraud”, “fraud prevention”, or “risk management” are often more natural. I kept “risk control” to preserve the original terminology.

## skills/apk-reverse/SKILL.md

**Original snippet:**
> - 一次性完成 `jadx + apktool` 落盘并产出摘要：`scripts/decode.ps1`

**English translation:**
> - Complete `jadx + apktool` extraction to disk and produce a summary in one go: `scripts/decode.ps1`

**Why uncertain:**
“落盘” literally means “land on disk” (i.e., write output to disk). I used “extraction to disk”, but “dump to disk”, “write to disk”, or “save output” are also plausible.

## skills/apk-reverse/SKILL.md

**Original snippet:**
> - 不要在 `.so` 明显承载核心逻辑时继续死磕 Java 层

**English translation:**
> - Do not keep struggling with the Java layer when `.so` clearly carries the core logic

**Why uncertain:**
“死磕” is colloquial for stubbornly persisting with something. “keep struggling with” captures the tone, but “keep hammering at”, “keep grinding on”, or “insist on” are alternatives.

## skills/apk-reverse/SKILL.md

**Original snippet:**
> ### 6. Native `.so` 分流

**English translation:**
> ### 6. Native `.so` Triage

**Why uncertain:**
“分流” literally means “split flow” or “branch off”. In this context it means routing/triaging to native analysis. “Triage” is natural for security workflows, but “Branching”, “Routing”, or “Splitting” could also fit.

## skills/attack-chain/SKILL.md

**Original snippet:**
> | "HW 攻防演练" | 需要完整攻击链 + 隐蔽性 + 痕迹清理 |

**English translation:**
> | "HW attack-defense exercise" | Requires a complete attack chain + stealth + trace cleanup |

**Why uncertain:**
“HW” is likely an abbreviation of “护网” (HuWang), China’s national cybersecurity drill. I kept “HW” to preserve the proper name, but “HuWang attack-defense exercise” or “national cyber defense drill” could be clearer to non-Chinese readers.

## skills/attack-chain/SKILL.md

**Original snippet:**
> | "近源渗透方案" | 物理接入 + 内网渗透组合 |

**English translation:**
> | "Proximity penetration plan" | Combination of physical access + internal network penetration |

**Why uncertain:**
“近源渗透” literally means “near-source penetration”. Common English alternatives include “close-access penetration”, “physical proximity penetration”, or “proximity attack”. I chose “proximity penetration” for conciseness.

## skills/attack-chain/SKILL.md

**Original snippet:**
> # 修改 pam_unix.so 添加万能密码

**English translation:**
> # Modify pam_unix.so to add a universal password

**Why uncertain:**
“万能密码” literally means “universal password”. In security terminology, alternatives include “master password”, “magic password”, or “skeleton key”. “Universal password” is a direct translation but may be less recognizable.

## skills/attack-chain/SKILL.md

**Original snippet:**
> ## 红队行动铁律

**English translation:**
> ## Iron Rules for Red Team Operations

**Why uncertain:**
“铁律” literally means “iron law/rule”. I rendered it as “Iron Rules”, but “cardinal rules”, “strict rules”, or “unbreakable rules” may read more naturally in English.


## From english.batch8.md

# Uncertain translations — batch 8 (skills/field-journal/)

## skills/field-journal/seed-001_elf-packed-loader.md

**Original snippet:**
> ## 踩坑记录

**English translation:**
> ## Pitfalls

**Why uncertain:**
"踩坑记录" literally means "record of stepping into pits". Valid alternatives: "Troubleshooting Log", "Lessons Learned", "Gotchas". Chose "Pitfalls" because it is concise and matches the table-of-issue/root-cause/fix structure; "Lessons Learned" is the closest idiomatic alternative.

## skills/field-journal/seed-001_elf-packed-loader.md

**Original snippet:**
> ## 脱敏要求
> 本条目为种子数据，基于公开技术模式编写，不涉及真实目标。

**English translation:**
> ## Anonymization Requirements
> This entry is seed data, written based on public technical patterns, and does not involve real targets.

**Why uncertain:**
"脱敏" (desensitization/data masking) has several valid renderings in security documentation: "Anonymization", "Redaction", "Data Masking". "Anonymization" was chosen because the note concerns removing identifying details from field notes; "Redaction Requirements" is an equally valid alternative.

## skills/field-journal/seed-001_elf-packed-loader.md

**Original snippet:**
> ## 进化动作

**English translation:**
> ## Evolution Actions

**Why uncertain:**
"进化动作" is project-specific jargon meaning "actions taken to evolve the skill package". Alternatives: "Improvement Actions", "Follow-up Actions", "Evolution Steps". Kept "Evolution Actions" to preserve the repository's terminology, but a native-English reader might prefer "Follow-up Actions".

## skills/field-journal/seed-002_go-malware-stripped.md

**Original snippet:**
> 反编译结果中 interface 调用看不懂

**English translation:**
> Interface calls in decompilation results are incomprehensible

**Why uncertain:**
"看不懂" is colloquial ("can't make sense of"). Alternatives: "are hard to follow", "are unintelligible", "cannot be understood". "Incomprehensible" is slightly stronger than the original tone but fits a technical post-mortem.

## skills/field-journal/seed-003_web-api-auth-bypass.md

**Original snippet:**
> 5. 测试 IDOR：用账号 A 的 token 访问账号 B 的资源 → 成功（水平越权）

**English translation:**
> 5. Test IDOR: Use account A's token to access account B's resources → success (horizontal privilege escalation).

**Why uncertain:**
"水平越权" is commonly rendered either as "horizontal privilege escalation" or "horizontal authorization bypass" (IDOR is technically an authorization flaw, not an escalation of role). Chose "horizontal privilege escalation" as the more widely recognized term in Chinese pentest write-ups; "horizontal authorization bypass" is arguably more precise.

## skills/field-journal/seed-003_web-api-auth-bypass.md

**Original snippet:**
> | 报告被 SRC 拒绝 | 只提交了截图没有完整复现步骤 | 补充 curl 命令 + 完整请求/响应 | 20min |

**English translation:**
> | Report rejected by SRC | Only submitted screenshots without complete reproduction steps | Add curl commands + full request/response | 20min |

**Why uncertain:**
"SRC" in Chinese security circles is the abbreviation for "Security Response Center" (安全响应中心), the vulnerability-reporting channel of a company. Kept the acronym "SRC" rather than expanding it, since it functions as a proper noun in the original; "vulnerability reporting platform" would lose that reference.

## skills/field-journal/seed-004_js-sign-webpack.md

**Original snippet:**
> ## 场景分类
> JS 签名

**English translation:**
> ## Scenario Classification
> JS Signature

**Why uncertain:**
"JS 签名" could mean "JS signature" (the artifact) or "JS signing" (the process). Chose "JS Signature" to match the noun-phrase style of the other scenario classifications; "JS Signing" is a valid alternative.

## skills/field-journal/seed-005_ad-certipy-esc1.md

**Original snippet:**
> # AD CS 快速检测一条龙

**English translation:**
> # One-stop AD CS quick detection

**Why uncertain:**
"一条龙" (literally "one dragon") is a Chinese idiom for a continuous, end-to-end service/process. Alternatives: "all-in-one", "end-to-end", "one-shot". "One-stop" conveys the convenience connotation; "end-to-end" is more literal about the pipeline nature.


## From english.batch9.md



---

## From english.batch2.md

## README_zh.md

**Original snippet:**
> <p align="center"><em style="font-family: 'KaiTi', 'STKaiti', 'SimSun', serif; font-size: 1.3em; color: #999;">破暗而行，逆水为舟</em></p>

**English translation:**
> <p align="center"><em style="font-family: 'KaiTi', 'STKaiti', 'SimSun', serif; font-size: 1.3em; color: #999;">Break through the darkness; row against the stream.</em></p>

**Why uncertain:**
Literary/poetic motto with no single standard rendering. `破暗` = "break through the dark"; `逆水为舟` literally "make a boat of the upstream current" (sail/row upstream). Alternatives considered: "Navigate the dark waters, sail against the stream" (the wording already used in README.md), "Walk through darkness, row against the current", "Against the current, be the boat". The README.md wording was not reused verbatim because it is a looser adaptation; the chosen line keeps the two-clause parallelism. Note the HTML `style` attribute (Chinese font stack KaiTi/STKaiti/SimSun) was preserved unchanged per the "preserve HTML formatting" instruction, even though the text is now English.

## README_zh.md

**Original snippet:**
> <a href="skills/ops/">作战契约</a>

**English translation:**
> <a href="skills/ops/">Ops Contracts</a>

**Why uncertain:**
`作战` means "combat/operational" and `契约` means "contract/covenant". "Ops Contracts" matches the existing English README.md (`<a href="skills/ops/">Ops contracts</a>`) and keeps consistency across the repo. Alternatives: "Engagement Contracts" (closest security-industry term, cf. "rules of engagement"), "Operations Covenant", "Battle Contracts". "Engagement Contracts" is arguably more idiomatic for pentest scoping documents, but it diverges from the term already used in README.md and skills/ops documentation.

## README_zh.md

**Original snippet:**
> | [skills/references/community-security-skills.md](skills/references/community-security-skills.md) | 社区安全 skill 生态对照（借鉴不并库） |

**English translation:**
> | [skills/references/community-security-skills.md](skills/references/community-security-skills.md) | Community security skill ecosystem comparison (borrow, do not merge into the repo) |

**Why uncertain:**
`借鉴不并库` is a compact idiom-like phrase: `借鉴` = "draw on / learn from / reference", `不并库` = "do not merge into the (skill) library/repository". Alternatives: "reference only, do not merge", "borrow without absorbing into the library", "learn from, but do not vendor". The chosen wording spells out the intent but loses the four-character compactness; "do not merge into the repo" may also understate that it refers specifically to the skill library rather than the git repository.

## README_zh.md

**Original snippet:**
> | DSL VM / 风控自定义 VM | `skills/reverse-engineering/dsl-vm-reverse/` |

**English translation:**
> | DSL VM / Custom risk-control VM | `skills/reverse-engineering/dsl-vm-reverse/` |

**Why uncertain:**
`风控` is short for `风险控制` ("risk control"), used chiefly in fintech/anti-fraud contexts to mean fraud-risk-control systems. Alternatives: "fraud risk-control VM", "anti-fraud custom VM", "risk-management VM". "Risk-control" is the most literal and is widely understood in Chinese-security writing translated to English, but a native English security reader might expect "anti-fraud" or "bot-detection" instead. The term describes the business domain of the custom VM being reversed, not a security technique.

## README_zh.md

**Original snippet:**
> | [skills/scripts/master-route.ps1](skills/scripts/master-route.ps1) | 一键分诊 |

**English translation:**
> | [skills/scripts/master-route.ps1](skills/scripts/master-route.ps1) | One-click triage |

**Why uncertain:**
`分诊` is the medical term for "triage", here applied to routing/classifying an incoming task to the right skill. "One-click triage" is idiomatic and matches the script's purpose, but "one-click task routing" or "one-shot classification" would describe the actual function more plainly. The medical metaphor may be opaque to some readers.

## README_zh.md

**Original snippet:**
> <strong>星图 AstraFlow</strong>
> ...
> <strong><a href="https://www.ucloud.cn/site/active/astraflow?ytag=geo_waituo_reverse">UCloud 优刻得星图 AstraFlow 大模型</a></strong>

**English translation:**
> <strong>AstraFlow</strong>
> ...
> <strong><a href="https://www.ucloud.cn/site/active/astraflow?ytag=geo_waituo_reverse">UCloud AstraFlow large models</a></strong>

**Why uncertain:**
The Chinese text carries localized brand names: `优刻得` is UCloud's Chinese registered name and `星图` is the Chinese product name for AstraFlow. The instruction says to keep brand/product names such as UCloud and AstraFlow as-is, so the localized Chinese names were dropped rather than transliterated ("Youked" / "StarMap"). Alternative: keep the bilingual form "UCloud (优刻得) AstraFlow (星图)" to preserve searchability for Chinese users. Note `alt="UCloud 优刻得星图 AstraFlow"` was likewise shortened to `alt="UCloud AstraFlow"`, matching README.md.

## README_zh.md

**Original snippet:**
> <a href="#关于项目">关于</a> ·
> ...
> <a id="关于项目"></a>

**English translation:**
> <a href="#关于项目">About</a> ·
> ...
> <a id="关于项目"></a>

**Why uncertain:**
The instruction was to preserve URLs and technical identifiers, so the in-page anchor IDs/fragments were left in Chinese while only the visible link text was translated. This keeps existing external links such as `README_zh.md#关于项目` working. Alternative: translate the anchors too (`#about`, `#getting-started`, `#usage`, `#sponsors`, `#contributing`, `#license`, `#acknowledgments`) to match README.md — cleaner for an all-English document but breaks any links that point at the Chinese fragments. If this file is meant to replace README.md as the primary English README, the anchors should be renamed to the English set and all in-file `href` values updated together.

## README_zh.md

**Original snippet:**
> 請參閱[安全政策](SECURITY.md)、[安裝與下載安全指引](docs/UV-AND-DOWNLOAD-SECURITY_zh.md)與[2026-09-03 倉庫安全復審](docs/SECURITY-REVIEW-2026-09-03.md)。

**English translation:**
> See the [Security Policy](SECURITY.md), [Installation and Download Security Guidance](docs/UV-AND-DOWNLOAD-SECURITY_zh.md), and the [2026-09-03 repository security review](docs/SECURITY-REVIEW-2026-09-03.md).

**Why uncertain:**
The link targets include `_zh` document variants, which remain Chinese-language files. Per the instruction to preserve file paths, the targets were not switched to the English variants (`docs/UV-AND-DOWNLOAD-SECURITY.md`). Consequence: this now-English page points at Chinese guidance documents. Alternative: repoint to the English docs, or keep `_zh` targets until the referenced docs are translated. Same applies to `docs/QUICKSTART_zh.md` in the following section.

## README_zh.md

**Original snippet:**
> ## 安裝與下載安全
> ...
> ## 社群問題、快速開始與分類

**English translation:**
> ## Installation and Download Security
> ...
> ## Community Issues, Quick Start, and Triage

**Why uncertain:**
These final sections are written in Traditional Chinese while the rest of the file is Simplified Chinese, and the headings are anchor-less (no `<a id=...>`), so translating them creates no broken links. `分類` here means "classification/triage" of community issues, not "classification" in a taxonomy sense; "Triage" was chosen to match `docs/COMMUNITY-ISSUE-TRIAGE.md`. Alternative: "Community Questions, Quick Start, and Classification".

## RULES_zh.md

**Original snippet:**
> > **本文件是行为链中文副本。** 路由表只在 `skills/config/routing.json`。

**English translation:**
> > **This file is a localized copy of the behavior chain.** Route tables live only in `skills/config/routing.json`.

**Why uncertain:**
`中文副本` literally means "Chinese-language copy/duplicate". Once translated, "Chinese-language copy" would be self-contradictory in an English file, so it was rendered as "localized copy". Alternatives: "Chinese-language copy" (faithful but wrong after translation), "duplicate of the behavior chain", "translated copy of the behavior chain". Note RULES.md calls itself "the behavior-chain source of truth", so this file's self-description as a *copy* is a real semantic difference worth reviewing — if `RULES_zh.md` is meant to become the English source of truth, this sentence should be reworded or dropped.

## RULES_zh.md

**Original snippet:**
> - APK、Android 逆向、反编译、smali、jadx、apktool、Frida、Hook
> - N-day、Nday、补丁差分、patch diff、patch tuesday、1day、CVE 复现、漏洞还原、ghidriff、Diaphora、DeepDiff、Microsoft Update Catalog、wsuspect、MSRC、补丁分析

**English translation:**
> - APK, Android reverse, decompile, smali, jadx, apktool, Frida, Hook
> - N-day, Nday, patch diff, patch diff, patch tuesday, 1day, CVE reproduction, vulnerability restoration, ghidriff, Diaphora, DeepDiff, Microsoft Update Catalog, wsuspect, MSRC, patch analysis

**Why uncertain:**
These bullet lists are **functional routing inputs**, not prose. The Chinese tokens (e.g. `逆向`, `反编译`, `补丁差分`) are matched against user prompts, so replacing them with English removes Chinese-language trigger matching for this file. This is the same concern already logged for RULES.md in `english.md`. Alternative: keep the Chinese aliases as additional keywords (bilingual list) so Chinese prompts still route. If this file is intended for an English-only branch, the loss may be acceptable; if not, restore the Chinese aliases.

## RULES_zh.md

**Original snippet:**
> - N-day、Nday、补丁差分、patch diff、patch tuesday、1day、CVE 复现、漏洞还原、ghidriff、Diaphora、DeepDiff、Microsoft Update Catalog、wsuspect、MSRC、补丁分析
> - 固件、firmware、IoT、binwalk、unblob、squashfs、UBI、JFFS2、Firmadyne、FAT、QEMU 全系统仿真、EMBA、cve-bin-tool、固件渗透、路由器固件、嵌入式漏洞利用、AFL++、boofuzz、UART、JTAG
> - 内存转储、memory dump、取证、forensic、隐写、steganography
> - LLM 安全、AI 安全测试、Prompt 注入、间接注入、jailbreak、越狱、系统提示词提取、模型安全

**English translation:**
> - N-day, Nday, patch diff, patch diff, patch tuesday, 1day, CVE reproduction, vulnerability restoration, ghidriff, Diaphora, DeepDiff, Microsoft Update Catalog, wsuspect, MSRC, patch analysis
> - firmware, firmware, IoT, binwalk, unblob, squashfs, UBI, JFFS2, Firmadyne, FAT, QEMU full-system emulation, EMBA, cve-bin-tool, firmware penetration, router firmware, embedded exploitation, AFL++, boofuzz, UART, JTAG
> - memory dump, memory dump, forensics, forensic, steganography, steganography
> - LLM security, AI security testing, Prompt injection, indirect injection, jailbreak, jailbreak, system prompt extraction, model security

**Why uncertain:**
The original lists deliberately pair a Chinese term with its English equivalent (e.g. `补丁差分、patch diff`, `固件、firmware`, `内存转储、memory dump`, `jailbreak、越狱`). After translation the pairs collapse into identical duplicates ("patch diff, patch diff"). The duplicates were kept so the token count and ordering stay faithful to the original, but they read as sloppy and are functionally redundant. Alternative: de-duplicate the lists, which is cleaner English but silently drops entries and changes line content; if de-duplicating, verify that no downstream test or doc depends on the exact keyword count.

## RULES_zh.md

**Original snippet:**
> | "用户说加壳样本先别脱壳先看导入表；我直接交花表算完成" | ... |

**English translation:**
> | "The user said to skip unpacking the packed sample and look at the import table first; I'll just hand in the garbage table as done" | ... |

**Why uncertain:**
`花表` is reverse-engineering slang for a corrupted/garbage import table produced when the import directory cannot be parsed (also `花指令` for junk instructions). Alternatives: "garbage import table", "garbled IAT", "scrambled import table", "flower table" (literal, meaningless in English). "Garbage table" keeps the slang flavor but may be vague out of context; "garbled IAT" is more precise for English reverse engineers but narrower. The same phrase recurs in `禁止用花表下「无网络能力」等结论`.

## RULES_zh.md

**Original snippet:**
> **可行性门闩：** X 被阻塞时 MUST 说明阻塞、给推荐顺序（先脱壳/修 IAT 或转动态）、**请用户确认**。

**English translation:**
> **Feasibility latch:** When X is blocked, MUST state the blocker, give the recommended order (unpack/repair the IAT first, or go dynamic), and **ask the user to confirm**.

**Why uncertain:**
`门闩` is literally a door bolt/latch; here it is used figuratively for a gating mechanism that blocks a shortcut. Alternatives: "feasibility gate" (consistent with `硬门`/"hard gate" used elsewhere), "feasibility latch", "feasibility interlock". "Gate" is already used for `硬门`/`readiness gate`, so "latch" was chosen to distinguish the two; if the repo prefers uniform "gate" terminology, switch to "feasibility gate".

## RULES_zh.md

**Original snippet:**
> - 红队、HW、攻防演练、打点、初始突破、边界突破

**English translation:**
> - red team, HW, attack-defense exercises, foothold establishment, initial access, perimeter breach

**Why uncertain:**
`打点` is Chinese red-team slang meaning "to establish an initial foothold / land a first access point" (literally "place a dot"). Alternatives: "foothold establishment", "initial foothold", "landing a point", "gaining a beachhead". "Foothold establishment" is clear to English red-teamers. Separately, `HW` is left untranslated because it is the well-known abbreviation for `护网` (a Chinese national cyber-defense exercise); expanding it to "GuardNet" or "Cyber Defense Drill" would lose the term's recognizability in the Chinese security community.

## RULES_zh.md

**Original snippet:**
> - 近源渗透、BadUSB、Rubber Ducky、WiFi Pineapple、Proxmark3、RFID 克隆

**English translation:**
> - proximity penetration, BadUSB, Rubber Ducky, WiFi Pineapple, Proxmark3, RFID cloning

**Why uncertain:**
`近源` means "near-source", i.e. attacks launched from physical or network proximity to the target (close-access operations). Alternatives: "proximity penetration", "close-access attack", "near-source penetration", "physical proximity penetration". "Proximity penetration" is concise but not an established English term; "close-access operations" is the more standard red-team phrase. The Chinese term also implies being physically near the site, which "proximity" only partly conveys.

## RULES_zh.md

**Original snippet:**
> - SRC、Bug Bounty、众测、漏洞赏金、HackerOne、WAF bypass、绕过 WAF、IDOR、越权、任意账号

**English translation:**
> - SRC, Bug Bounty, crowd testing, bug bounty programs, HackerOne, WAF bypass, bypassing WAF, IDOR, authorization bypass, arbitrary account access

**Why uncertain:**
`越权` is a core Chinese web-security term for accessing resources or functions beyond one's authorization (both horizontal and vertical). Alternatives: "authorization bypass", "privilege escalation" (conflicts with `提权`, which is also present elsewhere in the same list), "broken access control", "IDOR-style overreach". "Authorization bypass" was chosen to avoid colliding with `提权`/privilege escalation. Also `众测` (crowdsourced testing / bug-bounty platforms) was rendered "crowd testing", an uncommon English phrasing; "crowdsourced security testing" or "bug bounty platforms" would read better but duplicates the adjacent `漏洞赏金`.

## RULES_zh.md

**Original snippet:**
> - EDR 绕过、AV bypass、免杀、unhook、direct syscall、indirect syscall、...

**English translation:**
> - EDR bypass, AV bypass, antivirus evasion, unhook, direct syscall, indirect syscall, ...

**Why uncertain:**
`免杀` (literally "exempt from killing") is the Chinese term for making malware evade antivirus detection. Alternatives: "antivirus evasion", "AV evasion", "bypassing AV detection", "FUD (fully undetectable)". "Antivirus evasion" is standard and neutral; "FUD" is jargon but matches how practitioners speak. Note the line already contains `AV bypass`, so "antivirus evasion" creates a near-duplicate pair, mirroring the bilingual redundancy pattern noted above.

## RULES_zh.md

**Original snippet:**
> - 使用对应模板（逆向报告/渗透报告/CTF writeup/签名报告）

**English translation:**
> - Use the corresponding template (reverse engineering report/pentest report/CTF writeup/signature report)

**Why uncertain:**
`签名报告` is ambiguous in this context: it could mean a report about **signature analysis** (e.g. reversing a JS/API signing algorithm) or a **signing report** (APK/package signing). Given the repo has `skills/js-reverse/` for "前端 JS 签名" and an `ollvm-deobfuscation` reference, "signature report" (signature-algorithm analysis) is the more likely intent. Alternatives: "signing report", "signature analysis report". Verify against the actual template list in `skills/docs-generator/` before finalizing.

## RULES_zh.md

**Original snippet:**
> > **决策质量（Issue #77）：** 假设退出、validated 充分性（R4*）、结论锚定与死锁重规划见 skills/ops/analysis-decision-framework.md。

**English translation:**
> > **Decision quality (Issue #77):** For assumption exit, validated sufficiency (R4*), conclusion anchoring, and deadlock replanning, see skills/ops/analysis-decision-framework.md.

**Why uncertain:**
`假设退出` is repo-specific jargon (likely "exiting an assumption" / "assumption retirement") and `结论锚定` ("conclusion anchoring") is a cognitive-bias term. Alternatives: "assumption exit" (chosen), "assumption retraction", "retiring assumptions"; "conclusion anchoring" (chosen), "anchoring on conclusions". These map to section headings inside `skills/ops/analysis-decision-framework.md`; the translated terms should be checked against that file's own English wording so cross-references stay searchable.

## RULES_zh.md

**Original snippet:**
> powershell -NoProfile -ExecutionPolicy Bypass -File "<本包根目录>/skills/scripts/bootstrap-reverse.ps1" -Capability @('工具名') -StartServices

**English translation:**
> powershell -NoProfile -ExecutionPolicy Bypass -File "<SKILL_ROOT>/skills/scripts/bootstrap-reverse.ps1" -Capability @('tool_name') -StartServices

**Why uncertain:**
The command contains Chinese placeholders: `本包根目录` ("this package's root directory") and `工具名` ("tool name"). These are placeholders rather than literal paths, so leaving Chinese inside a command would be unusable in an English doc. They were mapped to `<SKILL_ROOT>` and `tool_name` to match the existing English RULES.md and this file's own later usage of `<SKILL_ROOT>` (in the compact reminder section). Alternatives: `<package_root>` / `<tool-name>`. This changes tokens inside fenced commands, which the "preserve commands" instruction would otherwise forbid — review whether downstream docs/scripts parse these strings. The same substitution was applied to the `.sh` and Kali variants and to `<本包根目录>/skills/CONTRIBUTING.md`.

## RULES_zh.md

**Original snippet:**
> Windows（PowerShell）：
> ...
> Linux / macOS（Bash）：

**English translation:**
> Windows (PowerShell):
> ...
> Linux / macOS (Bash):

**Why uncertain:**
The original uses full-width CJK parentheses `（）` and colon `：` even on otherwise all-English lines. All full-width punctuation in the file (325 lines originally affected) was normalized to ASCII `(` `)` `:` and `、` → `, `. This is required for natural English typography but does mean ~12 lines that contained no Han characters were still modified. Alternatives: keep full-width punctuation for byte-level fidelity. Note related formatting decisions: corner brackets `「」` were converted to straight double quotes, while the curly quotes `“ ”` in the Code Words and Attention Layout sections were deliberately kept as-is (legitimate English typography).

## RULES_zh.md

**Original snippet:**
> | OLLVM 脱密 | `skills/reverse-engineering/references/ollvm-deobfuscation.md` |

**English translation:**
> | OLLVM deobfuscation | `skills/reverse-engineering/references/ollvm-deobfuscation.md` |

**Why uncertain:**
`脱密` is unusual phrasing; in reverse engineering the common terms are `脱壳` (unpack) and `反混淆` (deobfuscate). Here it clearly maps to the referenced file `ollvm-deobfuscation.md`, so "deobfuscation" is correct. Alternatives: "OLLVM unpacking", "OLLVM de-obfuscation". Kept as "deobfuscation" to match the filename identifier and README.md's existing wording. Same term recurs in `特别感谢 OLLVM 脱密生态的贡献者` → "contributors of the OLLVM deobfuscation ecosystem".

## README_zh.md

**Original snippet:**
>   → MASTER-ROUTING / master-route.ps1（PRIMARY）
>   → case-init / scope.md（授权 + network_profile；未就绪禁止对目标 ACT）

**English translation:**
>   → MASTER-ROUTING / master-route.ps1 (PRIMARY)
>   → case-init / scope.md (authorization + network_profile; no ACT against the target until ready)

**Why uncertain:**
Full-width CJK punctuation (`，` `。` `：` `；` `（` `）` `、`) was normalized to ASCII (`,` `.` `:` `;` `(` `)` `, `) throughout README_zh.md (138 full-width punctuation characters originally, 0 remaining). This is required for natural English typography but means lines that contained no Han characters were still modified. Alternatives: keep full-width punctuation for byte-level fidelity. The same normalization was applied to RULES_zh.md (1214 → 6); the 6 remaining full-width characters there are the curly quotes `“ ”` in the Code Words and Attention Layout sections, deliberately kept as legitimate English typography.


---

## From english.batch3.md

## skills/config/routing.json

**Original snippet:**

> { "must": "越狱", "exclude": "模型|提示词|llm|prompt|jailbreak|garak|红队.?ai|ai.?红队", "note": "越狱 裸词分给 iOS 侧；LLM/模型上下文归 R14" },
> { "must": "jailbreak", "mustAll": ["ios|iphone|ipad|mobile|objection|ipa"], "note": "jailbreak 仅当带 iOS 语境才归移动端" }

**English translation:**

> { "must": "jailbreak", "exclude": "model|prompt|llm|garak|red.?team.?ai|ai.?red.?team", "note": "the bare term 'jailbreak' routes to the iOS side; LLM/model contexts route to R14" },
> { "must": "jailbreak", "mustAll": ["ios|iphone|ipad|mobile|objection|ipa"], "note": "jailbreak routes to mobile only when iOS context is present" }

**Why uncertain:**

Translating the Chinese routing keyword `越狱` (iOS "jailbreak") to `jailbreak` collapses it onto the English keyword already used by the following rule. The two rules previously matched different inputs: the Chinese term matched bare `越狱`, while `jailbreak` matched only with iOS context via `mustAll`. After translation, both rules match the literal `jailbreak`; the first rule now fires on any non-LLM "jailbreak" mention (including Android or non-iOS contexts), which broadens R2's match set and makes rule ordering matter. A safer option is to keep `越狱` as an additional alternative in the same regex (`jailbreak|越狱`) so Chinese-language routing still works. The same functional loss applies to all other Chinese keywords in this file (`安卓`, `反编译`, `固件`, `勒索`, `越权`, etc.): they were replaced by English equivalents, so Chinese-speaking users' original keywords no longer trigger the routes.

## skills/CONTRIBUTING.md

**Original snippet:**

> | 中文 | English |
> |------|---------|
> | 当前阶段 | Current phase |
> | 已验证事实 | Verified facts |
> | 关键证据 | Key evidence |
> | 推断与置信度 | Inference and confidence |
> | 风险/漏洞候选 | Risk or vulnerability candidates |
> | 建议下一步 | Suggested next steps |

**English translation:**

> | Chinese | English |
> |------|---------|
> | 当前阶段 | Current phase |
> | 已验证事实 | Verified facts |
> | 关键证据 | Key evidence |
> | 推断与置信度 | Inference and confidence |
> | 风险/漏洞候选 | Risk or vulnerability candidates |
> | 建议下一步 | Suggested next steps |

**Why uncertain:**

This table is a glossary of literal label strings that the Language Behavior Contract mandates for user-visible output. The surrounding prose was translated, but the left column was left in Chinese because translating those six cells to English would produce two identical columns (`Current phase | Current phase`) and destroy the table's purpose as a Chinese-to-English label mapping. Alternatives: (a) keep the table as-is, as a bilingual glossary (current choice); (b) translate the left column and retitle the table "Label | Notes," accepting the loss of the Chinese label reference; (c) remove the table and keep only the format rule. If the English branch intends English-only user-visible output, the contract text at lines 135-136 ("use Chinese") must also change — that is a behavioral change beyond translation and was not made.

## skills/routing_zh.md

**Original snippet:**

> # 逆向技能路由矩阵
>
> 按目标类型、用户意图和工具链，将任务路由到最合适的技能模块。此矩阵默认强制执行，不是参考建议。

**English translation:**

> # Reverse Engineering Skill Routing Matrix
>
> Route tasks to the most appropriate skill module by target type, user intent, and toolchain. This matrix is enforced by default; it is not an advisory suggestion.

**Why uncertain:**

The `_zh` suffix marks this file as the Chinese-language version of the routing matrix. Translating its body to English leaves an English document under a Chinese-suffixed filename and duplicates `skills/routing.md` in intent (the two files still differ in structure and wording). `CHANGELOG.md` still references `routing_zh.md` as one of the Chinese docs (and `RULES_zh` alongside it). Alternatives: (a) keep the translated body and accept the misleading filename (current choice, because renaming was out of scope); (b) leave `routing_zh.md` in Chinese as the localized mirror and translate only `routing.md`; (c) rename it to `routing.en.md` or similar in a follow-up that also updates the CHANGELOG references.


---

## From english.batch22.md

## skills/pentest-tools/references/msf-protocol.md

**Original snippet:**
> 让 AI 自动化调用 MSF 时不会变成"无脑挂死的怪物"。

**English translation:**
> so AI-driven automated calls to MSF do not turn into a "mindlessly hung monster."

**Why uncertain:**
Chinese security slang. "无脑" = brainless/mindless, "挂死" = hang/deadlock. Alternatives considered: "brain-dead hanging monster", "unresponsive zombie process", "runaway hung process". Kept the vivid metaphor but "monster" is a literal rendering of 怪物.

## skills/pentest-tools/references/msf-protocol.md

**Original snippet:**
> - 关键参数：LHOST / LPORT / PAYLOAD 的最终值（脱敏）

**English translation:**
> - Key parameters: final values of LHOST / LPORT / PAYLOAD (redacted)

**Why uncertain:**
"脱敏" is a common security term with several valid renderings: "redacted", "masked", "sanitized", "anonymized". "Redacted" was chosen as the most idiomatic for hiding sensitive values in a report.

## skills/pentest-tools/references/network-attack-defense.md

**Original snippet:**
> ## 凭证获取

**English translation:**
> ## Credential Acquisition

**Why uncertain:**
The MITRE ATT&CK tactic name is "Credential Access", but the section also covers dumping/extracting credentials, so "Acquisition" was chosen to avoid implying read-only access. Alternative: "Credential Access" (ATT&CK-aligned).

## skills/pentest-tools/references/network-attack-defense.md

**Original snippet:**
> | CrackMapExec | 内网瑞士军刀 | https://github.com/byt3bl33d3r/CrackMapExec |

**English translation:**
> | CrackMapExec | Internal network Swiss Army knife | https://github.com/byt3bl33d3r/CrackMapExec |

**Why uncertain:**
"瑞士军刀" (Swiss Army knife) is an idiom for a versatile multi-tool. Alternatives: "all-in-one toolkit", "versatile multi-tool". Kept the literal idiom since it is widely understood in English security writing.

## skills/pentest-tools/references/pentest-ai-agents-matrix.md

**Original snippet:**
> | 自动进化（field-journal） | 他们没有经验沉淀 |

**English translation:**
> | Self-evolution (field-journal) | They have no experience accumulation |

**Why uncertain:**
"沉淀" literally means "precipitation/sedimentation" and is business slang for accumulated institutional knowledge. Alternatives: "accumulated experience", "institutional knowledge", "lessons-learned capture". "Experience accumulation" is a literal but slightly awkward rendering.

## skills/pentest-tools/references/pentest-ai-agents-matrix.md

**Original snippet:**
> | 按需自举（bootstrap） | 他们需要手动装工具 |

**English translation:**
> | On-demand bootstrap | They require manual tool installation |

**Why uncertain:**
"自举" is the standard Chinese translation of "bootstrap". Alternatives: "on-demand self-bootstrapping", "self-provisioning". "On-demand bootstrap" was chosen for brevity and because the parenthetical already says "bootstrap".

## skills/pentest-tools/references/pentest-loop.md

**Original snippet:**
> 压缩不是简单摘要，而是为了让下一轮渗透测试能够安全、连续、可复盘地进行。

**English translation:**
> Compression is not a simple summary; it exists so the next penetration testing round can proceed safely, continuously, and in an auditable way.

**Why uncertain:**
"复盘" is borrowed from Go/chess and means to replay and review a game afterward. Alternatives: "reviewable", "reproducible", "debriefable", "retrospectable". "Auditable" captures the intent but loses the "replay" nuance.

## skills/pentest-tools/references/pentest-loop.md

**Original snippet:**
> - **严重风险**：破坏性操作、大流量、超出范围、数据外渗、拒绝服务、持久化、横向移动

**English translation:**
> - **Critical risk**: destructive operations, high traffic volume, out of scope, data exfiltration, denial of service, persistence, lateral movement

**Why uncertain:**
"严重风险" could be "Severe risk" or "Critical risk". "Critical" was chosen to fit the four-level ladder (low/medium/high/critical) used elsewhere in the document. Alternative: "Severe risk".

## skills/pentest-tools/references/recon-pipeline.md

**Original snippet:**
> ## 0. 门闩

**English translation:**
> ## 0. Gates

**Why uncertain:**
"门闩" literally means "door bolt/latch" and is used here figuratively for a precondition/checkpoint. Alternatives: "Gate", "Latch", "Preconditions", "Guard Rails". "Gates" matches the "门禁/门" language used later in the same file.

## skills/pentest-tools/references/recon-pipeline.md

**Original snippet:**
> □ 在 Cloudflare challenge 上硬刚爆破打崩边缘

**English translation:**
> □ Hammering Cloudflare challenges with brute force until the edge collapses

**Why uncertain:**
"打崩" is Chinese slang meaning to overwhelm/knock out a service. Alternatives: "crash the edge", "overwhelm the edge", "take the edge down". "Until the edge collapses" preserves the destructive connotation.

## skills/pentest-tools/references/recon-pipeline.md

**Original snippet:**
> **MUST** 先满足 `ops/scope-contract.md`；禁止「只给一个域名就全网狂扫」

**English translation:**
> > **MUST** satisfy `ops/scope-contract.md` first; "hand over a single domain and blast the whole internet" is prohibited

**Why uncertain:**
"全网狂扫" is slang for aggressive indiscriminate scanning of the entire internet. Alternatives: "indiscriminately sweep the entire internet", "wildly scan everything". "Blast the whole internet" keeps the colloquial tone of the original.

## skills/pentest-tools/references/recon-pipeline.md

**Original snippet:**
> □ 每条候选：复现命令 + 响应摘录（脱敏）→ E-id

**English translation:**
> □ Every candidate: reproduction command + response excerpt (redacted) → E-id

**Why uncertain:**
Same term "脱敏" as in msf-protocol.md; logged separately because it appears in a different file. Alternatives: "masked", "sanitized", "anonymized".

## skills/pentest-tools/references/web-attack-cheatsheet.md

**Original snippet:**
> <!-- 图片马 -->

**English translation:**
> <!-- Image webshell -->

**Why uncertain:**
"图片马" is Chinese security slang: "马" (horse) is short for "木马" (Trojan), so "图片马" is a webshell embedded in an image file. Alternatives: "image-based webshell", "picture webshell", "image Trojan". "Image webshell" is the most precise for the payload shown.


---

## From english.batch7.md

## skills/thick-client/SKILL.md

**Original snippet:**
> - [ ] Checklist？

**English translation:**
> - [ ] Checklist reviewed?

**Why uncertain:**
The original is an elliptical shorthand ("Checklist?") referring to the referenced checklist file. "Checklist reviewed?" makes the implied action explicit; "Checklist completed?" is also plausible.

## skills/threat-hunting/SKILL.md

**Original snippet:**
> 1. `NOW`: 明确假说（hypothesis）再查数，避免无脑刷告警

**English translation:**
> 1. `NOW`: Define the hypothesis before querying data; avoid mindlessly triaging alerts

**Why uncertain:**
"无脑刷告警" is colloquial, literally "brainlessly swiping through alerts." "Mindlessly triaging alerts" conveys the intent but loses the informal tone; "alert fatigue grinding" is an alternative.

## skills/threat-intelligence/SKILL.md

**Original snippet:**
> - 证据状态使用 `线索 / lead`、`已佐证 / corroborated`、`已确认 / confirmed`。

**English translation:**
> - Evidence states use `lead`, `corroborated`, `confirmed`.

**Why uncertain:**
The original deliberately pairs Chinese and English evidence-state labels. Since this is the English edition, the Chinese labels were dropped, but the section's policy still says user-facing conclusions default to Chinese; retaining the bilingual labels may be preferable for fidelity.

## skills/wifi-wireless/SKILL.md

**Original snippet:**
> - 流氓 AP / 钓鱼热点检测研究

**English translation:**
> - Rogue AP / evil-twin hotspot detection research

**Why uncertain:**
"钓鱼热点" literally means "phishing hotspot"; "evil-twin hotspot" is the common wireless-security term for a phishing AP, but "phishing hotspot" is the more literal rendering.

## skills/wifi-wireless/SKILL.md

**Original snippet:**
> - `../pentest-tools/` `../attack-chain/`（近源章节）

**English translation:**
> - `../pentest-tools/` `../attack-chain/` (proximity sections)

**Why uncertain:**
"近源" literally means "near-source" and in security usage refers to operations close to the target (physical/radio proximity). "Proximity sections" is concise but may read oddly; "close-access sections" or "physical/radio proximity sections" are alternatives.

## skills/windows-ad/SKILL.md

**Original snippet:**
> ### 2. 常见路径（先图后枪）

**English translation:**
> ### 2. Common paths (graph first, exploit second)

**Why uncertain:**
"先图后枪" is an idiom meaning "map the graph before firing" (recon before exploitation). The literal "graph first, gun second" sounds odd in English; "graph first, exploit second" preserves the intent but not the metaphor.

## skills/windows-ad/SKILL.md

**Original snippet:**
> - 本地提权到域路径（Potato 等作为跳板）

**English translation:**
> - Local privilege escalation to domain paths (Potato, etc. as a pivot)

**Why uncertain:**
"跳板" means "springboard/stepping stone." "Pivot" is the standard security term, but "stepping stone" or "foothold" could also fit.

## skills/supply-chain-security/SKILL.md

**Original snippet:**
> > 法规驱动：美国行政令 SBOM、中国国标、EU CRA

**English translation:**
> > Regulation-driven: US executive order SBOM, China national standards, EU CRA

**Why uncertain:**
"中国国标" means "Chinese national standards" generically; the original does not name a specific standard number (e.g., GB/T). "China national standards" is accurate but vague, matching the source.

## skills/reverse-engineering/SKILL.md

**Original snippet:**
> > 阶段门闩：`references/re-agent-workflow.md`（triage→static→dynamic→synthesis）。社区 RE skill 对照：`../references/community-security-skills.md`。

**English translation:**
> > Stage gate: `references/re-agent-workflow.md` (triage→static→dynamic→synthesis). Community RE skill comparison: `../references/community-security-skills.md`.

**Why uncertain:**
"门闩" is a door latch/bolt; "gate" is the idiomatic security term and matches the repo's use of "gate" elsewhere. "Stage latch" would preserve the metaphor but read less naturally.

## skills/ot-ics/SKILL.md

**Original snippet:**
> - 工程师站、HMI、历史库、跳板主机

**English translation:**
> - Engineering workstations, HMI, historians, jump hosts

**Why uncertain:**
"跳板主机" literally means "springboard host"; "jump host" is the conventional IT/OT term. "Pivot host" is also used in offensive-security contexts.

## skills/ot-ics/SKILL.md

**Original snippet:**
> □ 控制器固件版本 → CVE 映射（不盲刷固件）

**English translation:**
> □ Controller firmware version → CVE mapping (do not blindly flash firmware)

**Why uncertain:**
"盲刷" literally means "blindly flash/burn." "Do not blindly flash firmware" keeps the literal image; "do not flash firmware without verification" is a more formal paraphrase.

## skills/patch-diff-exploit/SKILL.md

**Original snippet:**
> | 删除 / 收紧 `IOCTL` code | 暴露面收敛（看老接口怎么打） |

**English translation:**
> | Removed / tightened `IOCTL` code | Exposure surface reduction (look at how the old interface is attacked) |

**Why uncertain:**
"暴露面收敛" is jargon meaning "reduce/narrow the exposed attack surface." "Exposure surface reduction" is literal; "attack-surface reduction" is the more standard English security term. "看老接口怎么打" means "see how the old interface is exploited."

## skills/pentest-tools/SKILL.md

**Original snippet:**
> 7. `ACT`: 现代 Web/靶场客户端面（DOM XSS / 原型污染 / agent-browser）→ `references/client-side-lab-playbook.md`；未打穿也要写 observed Evidence + 失败门闩

**English translation:**
> 7. `ACT`: Modern Web/lab client-side surfaces (DOM XSS / prototype pollution / agent-browser) → `references/client-side-lab-playbook.md`; even if not exploited, write observed Evidence + failure gates

**Why uncertain:**
"靶场" means "shooting range," i.e., a practice lab. "lab" was used to keep it short. "未打穿" means "not fully breached/exploited"; "even if not exploited" is a paraphrase. "失败门闩" = "failure gate/latch."

## skills/pwn-chain/SKILL.md

**Original snippet:**
> 强调"CTF 本地通 → 真实远程稳定打通"的工程差距

**English translation:**
> Emphasizes the engineering gap between "CTF local success → real remote stable success"

**Why uncertain:**
"打通" literally means "open through / get working end-to-end." "Stable success" conveys reliability but not the "end-to-end breakthrough" nuance; "stable end-to-end exploitation" is an alternative.

## skills/pentest-tools/src-hunter/SKILL.md

**Original snippet:**
> 把白盒方法论翻译为黑盒探测

**English translation:**
> Translates white-box methodology into black-box probing

**Why uncertain:**
"翻译为" literally means "translate into"; here it means "adapt/convert." "Translates ... into" preserves the metaphor but may sound odd; "adapts white-box methodology for black-box probing" is clearer.


---

## From english.batch11.md

## skills/scripts/bootstrap-manifest.json

**Original snippet:**
> 动态校验

**English translation:**
> verify dynamically

**Why uncertain:**
"动态校验" can be rendered as "dynamic verification", "runtime verification", or "verify dynamically". The context is a manifest note describing hash verification against a GitHub API digest, so "verify dynamically" reads naturally, but "dynamic verification" is equally valid.

---

## skills/scripts/bootstrap-manifest.json

**Original snippet:**
> 群体智能渗透框架

**English translation:**
> Swarm-intelligence penetration framework

**Why uncertain:**
"群体智能" is usually "swarm intelligence" in AI contexts, but "collective intelligence" is also a valid translation. The product name (Pentest-Swarm-AI) suggests "swarm", so "swarm-intelligence" was chosen.

---

## skills/scripts/extract-summaries.ps1

**Original snippet:**
> 分诊

**English translation:**
> triage

**Why uncertain:**
In routing contexts "分诊" can mean "triage", "dispatch", or "routing". "Triage" fits the medical/routing metaphor used elsewhere in the repo, but "dispatch" would also be defensible.

---

## skills/scripts/extract-summaries.ps1

**Original snippet:**
> 行尾免疫

**English translation:**
> Line-ending tolerance

**Why uncertain:**
"行尾免疫" literally means "line-ending immunity". The comment explains that CRLF worktrees are normalized before comparison, so "tolerance" conveys the intent better than the literal "immunity". Alternatives: "line-ending immunity", "line-ending robustness".

---

## skills/scripts/master-route.ps1

**Original snippet:**
> 防误伤

**English translation:**
> prevents false positives

**Why uncertain:**
"防误伤" literally means "prevent accidental injury" and in this context means avoiding collateral/false matches. "Prevents false positives" is the clearest technical rendering; "avoids collateral hits" is a more literal alternative.

---

## skills/scripts/master-route.ps1

**Original snippet:**
> 复用当前主线的项目工作根解析

**English translation:**
> Reuse the current mainline's project work-root resolution

**Why uncertain:**
"主线" can mean "mainline", "main branch", or "primary line". Here it refers to the main workflow/project line rather than a git branch, so "mainline" was chosen. Alternatives: "main branch", "primary line".

---

## skills/scripts/lib/ToolDiscovery.ps1

**Original snippet:**
> 辅助脚本执行

**English translation:**
> Auxiliary script execution

**Why uncertain:**
"辅助" can be "auxiliary", "helper", or "supporting". "Auxiliary script execution" is faithful; "helper script execution" is more colloquial.

---

## skills/scripts/lib/ToolDiscovery.ps1

**Original snippet:**
> 运行 Node 侧 JS 复现与 MCP 客户端

**English translation:**
> Run Node-side JS reproduction and MCP client

**Why uncertain:**
"复现" means "reproduce/reproduction", but in reverse-engineering context it can mean reproducing a vulnerability or signature. "JS reproduction" is ambiguous in English; alternatives include "JS repro" or "JS reverse-engineering reproduction".

---

## skills/scripts/lib/ToolDiscovery.ps1

**Original snippet:**
> 哈希与校验

**English translation:**
> Hashing and verification

**Why uncertain:**
"校验" can mean "verification", "checksum", or "validation". For the `rahash2` tool, "hashing and verification" is natural, but "hashing and checksums" is also valid.

---

## skills/scripts/lib/ToolDiscovery.ps1

**Original snippet:**
> 进制与位运算转换

**English translation:**
> Radix and bitwise conversion

**Why uncertain:**
"进制" means "numeral base/radix". "Radix and bitwise conversion" is precise; "base and bitwise conversion" is the more common colloquial alternative.

---

## skills/scripts/lib/ToolDiscovery.ps1

**Original snippet:**
> 二进制差分

**English translation:**
> Binary diffing

**Why uncertain:**
"差分" is "diff/differencing". "Binary diffing" is the standard security-tool phrasing; "binary differential analysis" is a more formal alternative.

---

## skills/scripts/lib/ToolDiscovery.ps1

**Original snippet:**
> 汇编/反汇编

**English translation:**
> Assembly/Disassembly

**Why uncertain:**
For the `rasm2` tool, the action is assemble/disassemble, so "Assembler/Disassembler" is arguably more accurate than "Assembly/Disassembly". Both are used in tool descriptions.

---

## skills/scripts/lib/ToolDiscovery.ps1

**Original snippet:**
> 二进制侦察

**English translation:**
> Binary reconnaissance

**Why uncertain:**
"侦察" is "reconnaissance". In security tooling, the shorthand "binary recon" is very common; the full form was chosen for readability.

---

## skills/scripts/lib/ToolDiscovery.ps1

**Original snippet:**
> 插件管理

**English translation:**
> plugin management

**Why uncertain:**
For a tool (`r2pm`) the natural English is "plugin manager", but the Chinese is a noun phrase meaning "plugin management". "Plugin management" was kept literal; "plugin manager" is the more idiomatic tool description.

---

## skills/scripts/refresh-tool-index.ps1

**Original snippet:**
> 能力状态视图

**English translation:**
> Capability Status View

**Why uncertain:**
"视图" is "view". Since the original was bilingual ("能力状态视图 (Capability Status)"), the parenthetical already supplies "Capability Status". "Capability Status View" preserves "view"; "Capability Status" alone would be cleaner.

---

## skills/scripts/refresh-tool-index.ps1

**Original snippet:**
> 可自动安装

**English translation:**
> Auto-installable

**Why uncertain:**
"可自动安装" literally means "can be auto-installed". "Auto-installable" is concise and fits a table column; "Can auto-install" is a valid alternative.

---

## skills/scripts/refresh-tool-index.ps1

**Original snippet:**
> 归属 skill

**English translation:**
> Owning skill

**Why uncertain:**
"归属" means "belonging/attribution". "Owning skill" is natural for a table column; "Associated skill" or "Belongs to skill" are also valid.

---

## skills/scripts/refresh-tool-index.ps1

**Original snippet:**
> 脚本引用

**English translation:**
> Script reference

**Why uncertain:**
"引用" can be "reference", "citation", or "usage". For a table column listing scripts that use the tool, "Script reference" is clear; "Script references" (plural) is also possible.

---

## skills/scripts/refresh-tool-index.ps1

**Original snippet:**
> 不适用或未检测

**English translation:**
> Not applicable or not detected

**Why uncertain:**
"不适用" is "not applicable" and "未检测" is "not detected/undetected". "Not applicable or not detected" is faithful; "N/A or undetected" is a more compact alternative.

---

## skills/scripts/refresh-tool-index.sh

**Original snippet:**
> 不适用或未检测

**English translation:**
> Not applicable or not detected

**Why uncertain:**
Same term as in `refresh-tool-index.ps1`. "Not applicable or not detected" is faithful; "N/A or undetected" is a more compact alternative.


---

## From english.batch12.md

## skills/pentest-tools/references/ai-pentest-agents.md

**Original snippet:**
> 渗透全家桶

**English translation:**
> Penetration testing suite

**Why uncertain:**
"全家桶" is a culturally specific Chinese term (literally "family bucket," originally from KFC) used in tech slang to mean an all-in-one toolkit or comprehensive suite. Alternatives considered: "all-in-one toolkit," "suite," "bundle."

## skills/pentest-tools/references/ai-pentest-agents.md

**Original snippet:**
> 在 HackTheBox/TryHackMe 做 5 个 Easy 靶机

**English translation:**
> Complete 5 Easy machines on HackTheBox/TryHackMe

**Why uncertain:**
"靶机" literally means "target machine" or "shooting range target." In the HackTheBox/TryHackMe context, the standard English term is "machine" or "box." Alternatives considered: "target VM," "target machine," "box."

## skills/pentest-tools/references/awesome-pentest-digest.md

**Original snippet:**
> 内网渗透瑞士军刀

**English translation:**
> Internal network penetration testing Swiss Army knife

**Why uncertain:**
"瑞士军刀" (Swiss Army knife) is an idiom for a versatile multi-tool. It is widely understood in English technical writing, but alternatives include "multi-tool" or "versatile toolkit."

## skills/pentest-tools/references/awesome-pentest-digest.md

**Original snippet:**
> ## 靶场练习

**English translation:**
> ## Lab Practice

**Why uncertain:**
"靶场" literally means "shooting range" and is used in Chinese security communities to mean practice labs or vulnerable target environments. Alternatives: "Practice Range," "Target Range," "Lab Environments."

## skills/pentest-tools/references/client-side-lab-playbook.md

**Original snippet:**
> **门闩：**

**English translation:**
> **Gates:**

**Why uncertain:**
"门闩" literally means "door latch" and is used metaphorically to mean conditions, guard clauses, or gating requirements. Alternatives: "Conditions," "Guard Clauses," "Gating Criteria."

## skills/pentest-tools/references/client-side-lab-playbook.md

**Original snippet:**
> 命中≠打穿

**English translation:**
> a hit ≠ a compromise

**Why uncertain:**
"打穿" is penetration testing slang meaning to successfully compromise or break through a target. Alternatives: "break through," "pwn," "fully compromise."

## skills/pentest-tools/references/client-side-lab-playbook.md

**Original snippet:**
> XXE 回显

**English translation:**
> XXE reflection

**Why uncertain:**
"回显" in the XXE context means reflected output or echo of data. Alternatives: "XXE echo," "XXE reflected output," "XXE data reflection."

## skills/pentest-tools/references/client-side-lab-playbook.md

**Original snippet:**
> 库存类 `innerHTML = fetchBody` 模式

**English translation:**
> Inventory-style `innerHTML = fetchBody` pattern

**Why uncertain:**
"库存类" literally means "inventory category/type" and refers to a stock-checking feature in the lab application. Alternatives: "stock-type," "inventory-type," "stock-checking pattern."

## skills/pentest-tools/references/client-side-lab-playbook.md

**Original snippet:**
> true => sink 实锤

**English translation:**
> true => sink confirmed

**Why uncertain:**
"实锤" is Chinese internet slang meaning "definitively proven" or "smoking gun." Alternatives: "definitively proven," "smoking gun," "ironclad confirmation."

## skills/pentest-tools/references/client-side-lab-playbook.md

**Original snippet:**
> **禁止**引导破解包 / 汉化一键启动版

**English translation:**
> **Do not** direct users to cracked packages / Chinese-localized one-click launchers

**Why uncertain:**
"汉化" means Chinese localization. "一键启动版" means one-click launcher/startup version. Alternatives: "localized one-click launcher," "Chinese-translated one-click installer."

## skills/pentest-tools/references/client-side-lab-playbook.md

**Original snippet:**
> 注意不要打崩目标

**English translation:**
> Be careful not to crash the target

**Why uncertain:**
"打崩" is slang meaning to crash, bring down, or overload a target. Alternatives: "bring down," "overload," "take down."

## skills/pentest-tools/references/msf-protocol.md

**Original snippet:**
> 让 AI 自动化调用 MSF 时不会变成"无脑挂死的怪物"

**English translation:**
> so that AI automated invocation of MSF doesn't turn into a "mindless hanging monster"

**Why uncertain:**
"无脑挂死的怪物" is a colorful metaphor meaning a brainless process that hangs/deadlocks. Alternatives: "brainless deadlocked monster," "mindless hanging beast."

## skills/pentest-tools/references/msf-protocol.md

**Original snippet:**
> # Metasploit 调用陷阱与正确姿势

**English translation:**
> # Metasploit Invocation Pitfalls and Correct Practices

**Why uncertain:**
"正确姿势" is Chinese tech slang meaning "the correct way to do something" (literally "correct posture"). Alternatives: "Correct Posture," "Proper Way," "Best Practices."

## skills/pentest-tools/references/msf-protocol.md

**Original snippet:**
> 关键参数：LHOST / LPORT / PAYLOAD 的最终值（脱敏）

**English translation:**
> Key parameters: final values of LHOST / LPORT / PAYLOAD (redacted)

**Why uncertain:**
"脱敏" in security contexts means redacted, sanitized, or anonymized. Alternatives: "sanitized," "anonymized," "masked."

## skills/pentest-tools/references/nuclei-guide-2026.md

**Original snippet:**
> # Nuclei 实战指南（2026 版）

**English translation:**
> # Nuclei Practical Guide (2026 Edition)

**Why uncertain:**
"实战指南" means practical/hands-on guide. Alternatives: "Hands-on Guide," "Field Guide," "Combat Guide."

## skills/pentest-tools/references/pentest-loop.md

**Original snippet:**
> 压缩不是简单摘要，而是为了让下一轮渗透测试能够安全、连续、可复盘地进行。

**English translation:**
> Compression is not a simple summary; it is to enable the next round of penetration testing to proceed safely, continuously, and in a reviewable manner.

**Why uncertain:**
"可复盘" means reviewable, auditable, or suitable for retrospective analysis. Alternatives: "retrospective," "post-mortem review," "auditable."

## skills/pentest-tools/references/recon-pipeline.md

**Original snippet:**
> □ 在 Cloudflare challenge 上硬刚爆破打崩边缘

**English translation:**
> □ Force brute-forcing against a Cloudflare challenge and crash the edge

**Why uncertain:**
"硬刚" is slang meaning to confront head-on or force directly. "打崩" means crash/bring down. Alternatives: "head-on brute-force and crash the edge," "force brute-forcing and overload the edge."

## skills/pentest-tools/references/recon-pipeline.md

**Original snippet:**
> ## 2. Evidence 门（降误报 — 本包特色）

**English translation:**
> ## 2. Evidence Gate (Reducing False Positives — A Feature of This Package)

**Why uncertain:**
"降误报" means reducing false positives. Alternatives: "False Positive Reduction," "Reducing False Positives."

## skills/pentest-tools/references/recon-pipeline.md

**Original snippet:**
> ### 2.1 追加 Evidence（固定结构，禁止自创目录）

**English translation:**
> ### 2.1 Append Evidence (Fixed Structure; Do Not Create Custom Directories)

**Why uncertain:**
"自创目录" means creating your own directory structure or inventing custom directories. Alternatives: "invent your own directory structure," "create ad-hoc directories."

## skills/pentest-tools/references/recon-pipeline.md

**Original snippet:**
> □ 裸 curl 403 + JSON access-policy / CF-RAY → 换浏览器 UA + Origin/Referer 重试

**English translation:**
> □ Bare curl 403 + JSON access-policy / CF-RAY → Switch to browser UA + Origin/Referer and retry

**Why uncertain:**
"裸 curl" means bare/plain curl without browser-like headers. Alternatives: "plain curl," "raw curl."

## skills/pentest-tools/references/web-attack-cheatsheet.md

**Original snippet:**
> <!-- 图片马 -->

**English translation:**
> <!-- Polyglot image -->

**Why uncertain:**
"图片马" is Chinese security slang (literally "picture horse") for a polyglot image file that contains a webshell. The standard English term is "polyglot image" or "image polyglot." Alternatives: "Picture horse," "Image webshell," "Polyglot file."

## skills/pentest-tools/references/web-attack-cheatsheet.md

**Original snippet:**
> # 水平越权

**English translation:**
> # Horizontal privilege escalation

**Why uncertain:**
"水平越权" is standard Chinese security terminology for horizontal privilege escalation or horizontal authorization bypass. Alternatives: "Horizontal authorization bypass," "Horizontal access control bypass."

## skills/pentest-tools/references/web-attack-cheatsheet.md

**Original snippet:**
> # 垂直越权

**English translation:**
> # Vertical privilege escalation

**Why uncertain:**
"垂直越权" is standard Chinese security terminology for vertical privilege escalation or vertical authorization bypass. Alternatives: "Vertical authorization bypass," "Vertical access control bypass."

## skills/pentest-tools/references/web-attack-cheatsheet.md

**Original snippet:**
> # 参数篡改

**English translation:**
> # Parameter tampering

**Why uncertain:**
"参数篡改" means parameter tampering or parameter manipulation. Both are valid; "tampering" is more common in security contexts. Alternatives: "Parameter manipulation," "Parameter modification."

## skills/pentest-tools/references/burpsuite-mcp-guide.md

**Original snippet:**
> **禁止**引导破解包 / 汉化一键启动版

**English translation:**
> **Do not** direct users to cracked packages / Chinese-localized one-click launchers

**Why uncertain:**
"汉化" means Chinese localization. "一键启动版" means one-click launcher/startup version. Alternatives: "localized one-click launcher," "Chinese-translated one-click installer."

## skills/pentest-tools/references/burpsuite-mcp-guide.md

**Original snippet:**
> 注意不要打崩目标。

**English translation:**
> Be careful not to crash the target.

**Why uncertain:**
"打崩" is slang meaning to crash, bring down, or overload a target. Alternatives: "bring down," "overload," "take down."


---

## From english.batch13.md

## skills/pentest-tools/src-hunter/references/playbooks/00-index.md

**Original snippet:**
> 开局送的 P0

**English translation:**
> easy P0s at the start

**Why uncertain:**
"开局送的" is gaming slang meaning "given away at the start" (freebie/starting bonus). Alternatives: "freebie P0s", "initial free P0s", "easy P0s handed to you from the start".

## skills/pentest-tools/src-hunter/references/playbooks/00-index.md

**Original snippet:**
> 易出货

**English translation:**
> ease of submission

**Why uncertain:**
"出货" in SRC/bug-bounty slang means "to yield a valid report" or "to get accepted". Alternatives: "ease of exploitation", "ease of getting a bounty", "high acceptance rate".

## skills/pentest-tools/src-hunter/references/playbooks/00-index.md

**Original snippet:**
> 越权

**English translation:**
> privilege escalation

**Why uncertain:**
"越权" is a standard Chinese web-security term for exceeding authority. It can mean horizontal or vertical privilege escalation, or authorization bypass. Alternatives: "authorization bypass", "unauthorized access".

## skills/pentest-tools/src-hunter/references/playbooks/00-index.md

**Original snippet:**
> 余额超扣

**English translation:**
> balance over-deduction

**Why uncertain:**
"超扣" means over-deduction/over-drafting. Alternatives: "balance overdraft", "over-deduction of balance".


---

## From english.batch15.md

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> 这是一个给 SRC、众测和 Bug bounty 用的 Claude Code skill。

**English translation:**
> This is a Claude Code skill for SRC (Security Response Center), crowdtesting, and bug bounty programs.

**Why uncertain:**
"众测" (crowdtesting) is a Chinese-specific term for crowd-sourced security testing platforms. Alternatives considered: "crowd-sourced security testing," "crowd testing." "Crowdtesting" is concise but may not be immediately clear to non-Chinese audiences.

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> - bug bounty、HackerOne、SRC 挖洞、漏洞赏金、众测

**English translation:**
> - bug bounty, HackerOne, SRC bug hunting, vulnerability bounty, crowdtesting

**Why uncertain:**
"SRC 挖洞" literally means "SRC hole digging." Alternatives considered: "SRC vulnerability hunting," "SRC bug hunting," "SRC bug digging." "SRC bug hunting" is natural but loses the colloquial flavor of the original.

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> - 常见国产组件指纹和默认凭据

**English translation:**
> - Fingerprints and default credentials for common Chinese-made components

**Why uncertain:**
"国产组件" means "domestically produced components" (Chinese-made). Alternatives considered: "domestic components," "Chinese-made components," "domestically produced components." "Chinese-made" is clear but may be too specific; "domestic" is ambiguous without context.

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> - WooYun 历史案例统计残余

**English translation:**
> - Statistical residue from historical WooYun cases

**Why uncertain:**
"统计残余" literally means "statistical residue/remnants." Alternatives considered: "statistical remnants," "aggregated statistics," "residual statistics." "Statistical residue" is literal but may sound awkward in English.

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> ## 红线

**English translation:**
> ## Red Lines

**Why uncertain:**
"红线" (red lines) is a common Chinese metaphor for hard boundaries. Alternatives considered: "Hard Boundaries," "Bottom Lines," "Red Lines." "Red Lines" is widely understood in English but may carry political connotations.

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> - **不留物**：webshell、heapdump、备份、dump 出来的源码——本地保存，报告后立即删除，不要 push 到 GitHub / 第三方网盘。

**English translation:**
> - **Leave no artifacts**: Webshells, heapdumps, backups, and dumped source code—save them locally, delete them immediately after reporting, and do not push them to GitHub / third-party cloud storage.

**Why uncertain:**
"不留物" literally means "leave no objects/things." Alternatives considered: "Do not leave traces," "Leave no artifacts," "Clean up after yourself." "Leave no artifacts" is concise but may not convey the full meaning of avoiding detection/forensic traces.

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> - **测试账号自演**：越权、密码重置、JWT 伪造、redirect_uri、XSS 盲打全部用自己注册的两个号互测，**不要碰陌生人的账号**——即使能。

**English translation:**
> - **Self-testing with test accounts**: For privilege escalation, password reset, JWT forgery, redirect_uri, and blind XSS, use two accounts you registered yourself to test against each other. **Do not touch strangers' accounts**—even if you can.

**Why uncertain:**
"自演" literally means "self-acting" or "self-performing." Alternatives considered: "Self-testing," "Using your own accounts," "Internal testing." "Self-testing" captures the essence but may not emphasize the "using only your own accounts" aspect.

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> - **速查**：...

**English translation:**
> - **Quick reference**: ...

**Why uncertain:**
"速查" means "quick lookup/check." Alternatives considered: "Quick reference," "Cheat sheet," "Quick lookup." "Quick reference" is formal and clear.

## skills/pentest-tools/src-hunter/README.md

**Original snippet:**
> ## 友情链接

**English translation:**
> ## Friendly Links

**Why uncertain:**
"友情链接" is a Chinese web convention meaning "friendly links" or "partner links." Alternatives considered: "Links," "Related Links," "Partner Links." "Friendly Links" is a literal translation but may sound unnatural in English.

## skills/pentest-tools/src-hunter/references/industry/telecom-isp.md

**Original snippet:**
> - **工号制后台**：内部系统 + 工号制后台 + 老旧厂商设备。

**English translation:**
> - **Employee-ID-based backends**: internal systems + employee-ID-based backends + legacy vendor equipment.

**Why uncertain:**
"工号制" means "employee number system" or "staff ID system." Alternatives considered: "Employee ID system," "Staff number system," "Employee-ID-based." "Employee-ID-based" is descriptive but may be overly literal.

## skills/pentest-tools/src-hunter/references/industry/telecom-isp.md

**Original snippet:**
> **金矿点**：省分公司、SP/CP 第三方接入平台、物联网卡管理平台。

**English translation:**
> **Gold mines**: provincial branches, SP/CP third-party access platforms, IoT card management platforms.

**Why uncertain:**
"金矿点" literally means "gold mine points." Alternatives considered: "Gold mines," "High-value targets," "Rich veins." "Gold mines" is metaphorical and may be unclear; "High-value targets" is more direct but less vivid.

## skills/pentest-tools/src-hunter/references/industry/telecom-isp.md

**Original snippet:**
> | 某社交平台核心机房漫游 wooyun-2015-095043 | OTNM2000 网管 8089 | 配置不当 |

**English translation:**
> | A social platform core data center roaming wooyun-2015-095043 | OTNM2000 network management port 8089 | Misconfiguration |

**Why uncertain:**
"漫游" (roaming) in this context likely means "lateral movement" within the core data center, not "roaming" in the telecom sense. Alternatives considered: "Lateral movement," "Roaming," "Pivoting." "Roaming" is the literal translation but "Lateral movement" might be more accurate in a security context.

## skills/pentest-tools/src-hunter/references/industry/telecom-isp.md

**Original snippet:**
> | 国家电网某站点 wooyun-2016-0193221 | admin/123 + 合闸/拉闸 | 弱口令 |

**English translation:**
> | State Grid site wooyun-2016-0193221 | admin/123 + power switching | Weak password |

**Why uncertain:**
"合闸/拉闸" literally means "close breaker/open breaker" or "switch on/switch off." Alternatives considered: "Power switching," "Breaker control," "Close/open breaker." "Power switching" is generic; "Breaker control" is more specific to electrical systems.

## skills/pentest-tools/src-hunter/references/industry/telecom-isp.md

**Original snippet:**
> | 话费查询 | `phone`, `mobile`, `mob` | 查任意用户话费 |

**English translation:**
> | Phone credit query | `phone`, `mobile`, `mob` | Query any user's phone credit |

**Why uncertain:**
"话费" means "phone credit" or "phone bill." Alternatives considered: "Phone credit," "Phone bill," "Mobile balance." "Phone credit" is common in telecom contexts but "phone bill" might be more universally understood.

## skills/pentest-tools/src-hunter/references/industry/telecom-isp.md

**Original snippet:**
> └── 印刷厂 → 充值卡密 / 物联网卡密

**English translation:**
> └── Printing factories → Recharge card codes / IoT card codes

**Why uncertain:**
"充值卡密" means "recharge card password/secret code." Alternatives considered: "Recharge card codes," "Recharge card PINs," "Top-up card secrets." "Recharge card codes" is clear and concise.

## skills/pentest-tools/src-hunter/references/methodology/04-control-gap-hunting.md

**Original snippet:**
> | 撞库（公开数据库 + 无频率限制） | 撞库 |

**English translation:**
> | Credential stuffing (public databases + no rate limiting) | Credential stuffing |

**Why uncertain:**
"撞库" (Zhuangku) can mean "credential stuffing" or "account enumeration." In this context (public databases + no rate limits), it likely refers to using leaked credentials from public databases to attempt logins. Alternatives considered: "Credential stuffing," "Account enumeration," "Credential replay."

## skills/pentest-tools/src-hunter/references/methodology/04-control-gap-hunting.md

**Original snippet:**
> | 资源所有权 | ✗ 账号 A 可读 B 数据 | 见 PoC §1 |

**English translation:**
> | Resource ownership | ✗ Account A can read B's data | See PoC §1 |

**Why uncertain:**
"资源所有权" literally means "resource ownership." In security contexts, this is often referred to as "ownership validation" or "resource authorization." Alternatives considered: "Resource ownership," "Ownership validation," "Resource authorization."

## skills/pentest-tools/src-hunter/references/methodology/04-control-gap-hunting.md

**Original snippet:**
> | 内容含图片头 + 脚本（图片马） | 解析漏洞配合 |

**English translation:**
> | Content contains image header + script (image beacon) | Parsing vulnerability chaining |

**Why uncertain:**
"图片马" (image horse) is Chinese security slang for a malicious payload embedded in an image file. Alternatives considered: "Image beacon," "Image payload," "Image shell," "Polyglot image." "Image beacon" is a reasonable translation but may not be universally understood.


---

## From english.batch17.md

## skills/pentest-tools/src-hunter/references/methodology/00-index.md

**Original snippet:**
> 这个顺序就是 `01-attack-priority.md` 里"攻击路径最短原则"的现金体现。

**English translation:**
> This order is the cash embodiment of the "shortest attack path principle" in `01-attack-priority.md`.

**Why uncertain:**
"现金体现" is colloquial Chinese meaning "concrete/monetary manifestation." Considered "cash embodiment," "monetary expression," and "tangible payoff."

## skills/pentest-tools/src-hunter/references/methodology/00-index.md

**Original snippet:**
> [03] 收尾——证据纪律：抓包、回显、带外、复现率，不写"我猜的"漏洞

**English translation:**
> [03] Wrap-up — evidence discipline: packet capture, echo, out-of-band, reproducibility; never write "I guessed" vulnerabilities

**Why uncertain:**
"收尾" could be "wrap-up," "closing," or "finalization." Chose "wrap-up" to match the workflow tone.

## skills/pentest-tools/src-hunter/references/methodology/01-attack-priority.md

**Original snippet:**
> [P0][未授权][RCE] /api/v1/import 接受 ${jndi:} - 单包打穿

**English translation:**
> [P0][Unauthenticated][RCE] /api/v1/import accepts ${jndi:} - single-packet exploit

**Why uncertain:**
"单包打穿" literally "single packet pierce-through." Alternatives: "one-shot," "single-request pwn," "single-packet compromise."

## skills/pentest-tools/src-hunter/references/methodology/01-attack-priority.md

**Original snippet:**
> 按这个口诀，把同一个目标的所有 finding 排好序再提交，平台审核员看了不头大。

**English translation:**
> Using this mnemonic, sort all findings for the same target before submitting so the platform reviewer does not get overwhelmed.

**Why uncertain:**
"看了不头大" is an idiom meaning "not give a headache" → "not be overwhelmed." Considered "won't be annoyed" or "won't be intimidated."

## skills/pentest-tools/src-hunter/references/methodology/01-attack-priority.md

**Original snippet:**
> | **认证操作** | `/login`、`/reset`、`/sms` | 验证码 + 频率 + 绑定 | 撞库 / 重置 (P1) |

**English translation:**
> | **Authentication operation** | `/login`, `/reset`, `/sms` | CAPTCHA + rate limiting + binding | Credential stuffing / reset (P1) |

**Why uncertain:**
"撞库" is Chinese security slang for credential stuffing. Also considered "account enumeration attack" and "credential reuse attack."

## skills/pentest-tools/src-hunter/references/methodology/02-bypass-toolkit.md

**Original snippet:**
> 1. 多重编码：URL → HTML 实体 → Unicode 三重套娃

**English translation:**
> 1. Multi-layer encoding: URL → HTML entities → Unicode triple nesting

**Why uncertain:**
"三重套娃" (three-layer Russian-doll nesting) is colloquial. Alternatives: "triple nesting," "three nested layers," "stacked three deep."

## skills/pentest-tools/src-hunter/references/methodology/02-bypass-toolkit.md

**Original snippet:**
> → 看常见特征：Cloudflare（cf-ray）、ModSecurity、AWS WAF、阿里云盾、长亭雷池

**English translation:**
> → Check common signatures: Cloudflare (cf-ray), ModSecurity, AWS WAF, Alibaba Cloud Shield, Chaitin SafeLine

**Why uncertain:**
"阿里云盾" is Alibaba Cloud's WAF brand (Alibaba Cloud Shield); "长亭雷池" is Chaitin Tech's SafeLine WAF. Vendor English brand names were used, but Chinese transliterations may be preferred in some contexts.

## skills/pentest-tools/src-hunter/references/methodology/02-bypass-toolkit.md

**Original snippet:**
> 3. 看上传时间戳命名规则（`20140829221136jsp.jsp` 模式 → 时间爆破 ±60 秒）

**English translation:**
> 3. Check the timestamp naming rule (pattern like `20140829221136jsp.jsp` → brute-force the time within ±60 seconds)

**Why uncertain:**
"时间爆破" = "time brute-force." Could also be "timestamp brute-forcing" or "time-window enumeration."

## skills/pentest-tools/src-hunter/references/methodology/04-control-gap-hunting.md

**Original snippet:**
> | 内容含图片头 + 脚本（图片马） | 解析漏洞配合 |

**English translation:**
> | Content contains an image header + script (image webshell) | Combined with a parsing vulnerability |

**Why uncertain:**
"图片马" (image horse) is Chinese security slang for a polyglot file that is a valid image and also contains executable script. Alternatives: "image-shell," "polyglot image payload," "image trojan."

## skills/pentest-tools/src-hunter/references/methodology/04-control-gap-hunting.md

**Original snippet:**
> | 并发 50 次同请求 | 竞态 → 透支 / 双发卡券 |

**English translation:**
> | 50 concurrent identical requests | Race condition → overdraft / duplicate coupons |

**Why uncertain:**
"双发卡券" literally "double-issue card vouchers" — could mean duplicate coupon issuance or duplicate gift-card issuance. "Card voucher" is ambiguous between coupons and stored-value cards.

## skills/pentest-tools/src-hunter/references/methodology/04-control-gap-hunting.md

**Original snippet:**
> | 重置流程跳步骤（直接 GET 第 3 步页面） | 流程跳跃 |

**English translation:**
> | Skip steps in the reset flow (directly GET the step-3 page) | Flow skipping |

**Why uncertain:**
"流程跳跃" could be "flow skipping," "step skipping," or "sequence bypass." Chose "flow skipping" to match the surrounding terminology.

## skills/pentest-tools/src-hunter/references/methodology/04-control-gap-hunting.md

**Original snippet:**
> | 鉴权 | ✓ 缺 Authorization 返回 401 | （包略） |

**English translation:**
> | Authentication | ✓ Missing Authorization returns 401 | (request omitted) |

**Why uncertain:**
"包略" is an abbreviation of "数据包略" (packet omitted/abbreviated). Alternatives: "(packet omitted)," "(traffic elided)," "(request abbreviated)."

## skills/pentest-tools/src-hunter/references/methodology/05-srctimebox-priority.md

**Original snippet:**
> ### 模板 D：SRC 月度刷分——薅长尾

**English translation:**
> ### Template D: SRC monthly score-grinding — harvest the long tail

**Why uncertain:**
"刷分" = "score-grinding" (repeatedly farming points); "薅长尾" uses "薅" (to pluck/fleece, as in coupon-clipping) for "harvest." Alternatives: "farm the long tail," "mine the long tail," "squeeze the long tail."

## skills/pentest-tools/src-hunter/references/methodology/05-srctimebox-priority.md

**Original snippet:**
> | **P2（XSS / CSRF / 重定向）** | — | — | 🟢 拼链子（XSS + IDOR） |

**English translation:**
> | **P2 (XSS / CSRF / redirect)** | — | — | 🟢 Chain-building (XSS + IDOR) |

**Why uncertain:**
"拼链子" literally "assembling a chain." Alternatives: "chain-building," "chaining," "building attack chains." Chose "chain-building" to match the noun-slot style of the other cells.

## skills/pentest-tools/src-hunter/references/methodology/05-srctimebox-priority.md

**Original snippet:**
> 🔴 立即报 / 🟠 高优先 / 🟡 中等 / 🟢 凑数 / — 不存在该组合

**English translation:**
> 🔴 Report immediately / 🟠 High priority / 🟡 Medium / 🟢 Filler / — Combination does not exist

**Why uncertain:**
"凑数" literally "make up the numbers" — here means low-value filler findings. Alternatives: "filler," "padding," "makeweight."

## skills/pentest-tools/src-hunter/references/methodology/05-srctimebox-priority.md

**Original snippet:**
> 2:30–4:00  双账号 IDOR 横纵向                    （62.3% 高危，但容易批量出活）

**English translation:**
> 2:30–4:00  Two-account IDOR horizontal & vertical                    (62.3% high severity, but easy to produce in bulk)

**Why uncertain:**
"出活" is colloquial for "produce results/findings." Alternatives: "produce findings," "yield results," "churn out hits."

## skills/pentest-tools/src-hunter/references/templates/report-submission.md

**Original snippet:**
> > 适用：HackerOne、Bugcrowd、补天、漏洞盒子、CNVD、私域 SRC

**English translation:**
> > Applies to: HackerOne, Bugcrowd, Butian, Vulbox, CNVD, private SRC

**Why uncertain:**
"补天" is Butian (a Chinese bug-bounty platform), "漏洞盒子" is Vulbox (another Chinese platform), and "私域 SRC" means an organization's in-house/private security response center. Vendor English names were used, but some readers may expect pinyin/transliteration or "private bug bounty program."

## skills/pentest-tools/src-hunter/references/templates/report-submission.md

**Original snippet:**
> - **可拖数据**：users、orders、payments 表（推断含 PII / 财务）

**English translation:**
> - **Dumpable data**: users, orders, payments tables (inferred to contain PII / financial data)

**Why uncertain:**
"拖库" (database dumping) is Chinese security slang; "可拖数据" means "data that can be dumped." Alternatives: "extractable data," "exfiltratable data," "data reachable via dump."

## skills/pentest-tools/src-hunter/references/templates/report-submission.md

**Original snippet:**
> - 通用型 vs 事件型，通用型走 CNVD/CNNVD 编号

**English translation:**
> - General type vs incident type; general type goes through CNVD/CNNVD numbering

**Why uncertain:**
CNVD distinguishes "通用型" (general-purpose vulnerability affecting a product) from "事件型" (incident-specific vulnerability affecting a live site). Alternatives: "generic vs incident," "product-level vs event-level," "common vulnerability vs incident vulnerability."


---

## From english.batch18.md

## skills/pentest-tools/src-hunter/references/playbooks/graphql.md

**Original snippet:**
> 字段级越权

**English translation:**
> field-level authorization bypass

**Why uncertain:**
"越权" is the standard Chinese term for exceeding one's authority; in this context it means accessing fields the caller should not read. Alternatives: "field-level privilege escalation", "field-level IDOR", "broken field-level authorization".

## skills/pentest-tools/src-hunter/references/playbooks/graphql.md

**Original snippet:**
> 批量查询 / 别名滥用（绕过限频）

**English translation:**
> Batch Queries / Alias Abuse (rate-limit bypass)

**Why uncertain:**
"限频" literally means "frequency limiting"; the conventional English security term is "rate limiting". Alternatives: "throttling bypass", "rate-limit evasion".

## skills/pentest-tools/src-hunter/references/playbooks/graphql.md

**Original snippet:**
> 折叠：`...frag` 片段循环展开

**English translation:**
> folding: `...frag` fragment cyclic expansion

**Why uncertain:**
"折叠" in GraphQL attack tooling refers to "query folding" via recursive/circular fragments. Alternatives: "fragment cycle expansion", "recursive fragment unfolding". The Chinese phrase is jargon-like and has no single settled English rendering.

## skills/pentest-tools/src-hunter/references/playbooks/graphql.md

**Original snippet:**
> 撞库 / 短信轰炸

**English translation:**
> credential stuffing / SMS bombing

**Why uncertain:**
"撞库" is standard Chinese security slang for credential stuffing; "短信轰炸" means abusing SMS-sending endpoints to bombard a phone number. Alternatives: "credential replay", "SMS flooding".

## skills/pentest-tools/src-hunter/references/playbooks/race-conditions.md

**Original snippet:**
> 优惠券双花

**English translation:**
> coupon double-spend

**Why uncertain:**
"双花" is borrowed from blockchain double-spend terminology and is used in Chinese bug bounty for redeeming a single-use coupon multiple times. Alternatives: "coupon double redemption", "coupon reuse", "duplicate coupon redemption".

## skills/pentest-tools/src-hunter/references/playbooks/race-conditions.md

**Original snippet:**
> 限购抢单

**English translation:**
> purchase-limit order sniping

**Why uncertain:**
"抢单" means grabbing orders during a flash sale or limited-stock event. Alternatives: "flash-sale limit bypass", "bulk order grabbing", "limit-bypass bulk purchase".

## skills/pentest-tools/src-hunter/references/playbooks/race-conditions.md

**Original snippet:**
> 黄牛

**English translation:**
> scalpers

**Why uncertain:**
Culturally specific Chinese term for people (or bots) who bulk-buy limited goods and resell at a markup. Alternatives: "resellers", "scalper bots", "touts".

## skills/pentest-tools/src-hunter/references/playbooks/race-conditions.md

**Original snippet:**
> 余额超扣 → 实际提现真金白银

**English translation:**
> Balance over-deduction → actually withdraw real money

**Why uncertain:**
"真金白银" is an idiom meaning "real gold and silver", i.e., actual money. Alternatives: "real funds", "actual cash". The literal idiom would be misleading in English.

## skills/pentest-tools/src-hunter/references/playbooks/race-conditions.md

**Original snippet:**
> 凭空提现

**English translation:**
> withdraw money out of thin air

**Why uncertain:**
"凭空" means "from nothing / out of thin air"; the phrase describes creating balance from a negative/zero state. Alternatives: "phantom withdrawal", "withdraw nonexistent funds", "fabricated withdrawal".

## skills/pentest-tools/src-hunter/references/playbooks/race-conditions.md

**Original snippet:**
> 状态机跳跃

**English translation:**
> state-machine skipping

**Why uncertain:**
"跳跃" means jumping; the attack skips or reorders legitimate state transitions. Alternatives: "state-machine transition bypass", "state transition skipping".

## skills/pentest-tools/src-hunter/references/playbooks/race-conditions.md

**Original snippet:**
> 唯一约束被破坏

**English translation:**
> unique constraint bypass

**Why uncertain:**
The literal meaning is "unique constraint is broken/violated". I chose "bypass" because it is an attack outcome. Alternatives: "unique constraint violation", "broken unique constraint".

## skills/pentest-tools/src-hunter/references/playbooks/race-conditions.md

**Original snippet:**
> 用并发刷别人的优惠券 / 邀请奖励

**English translation:**
> use concurrency to abuse other people's coupons / invite rewards

**Why uncertain:**
"刷" in Chinese security slang means to farm or repeatedly abuse an endpoint for gain. Alternatives: "farm", "exploit", "repeatedly redeem".

## skills/pentest-tools/src-hunter/references/playbooks/unauth-access.md

**Original snippet:**
> 这是猎手最容易开胡的牌

**English translation:**
> this is the hand a hunter is most likely to win with first

**Why uncertain:**
"开胡" is mahjong slang for "making the first win / getting on the scoreboard". In bug-bounty slang it means "getting your first valid finding". Alternatives: "the easiest first win", "the most likely first payout", "the easiest category to score in".

## skills/pentest-tools/src-hunter/references/playbooks/unauth-access.md

**Original snippet:**
> Redis 未授权 → RCE 三板斧

**English translation:**
> Redis Unauthorized Access → The Three RCE Tricks

**Why uncertain:**
"三板斧" (three axe blows) is an idiom from a famous novel, meaning "a small fixed set of techniques". Alternatives: "three classic RCE techniques", "the standard RCE trio", "three go-to RCE methods".

## skills/pentest-tools/src-hunter/references/playbooks/unauth-access.md

**Original snippet:**
> 用 Redis/Mongo 写马、留 webshell、上 cron

**English translation:**
> use Redis/Mongo to write a webshell, leave a backdoor, or install cron jobs

**Why uncertain:**
"写马" is Chinese hacker slang: "马" (horse) means a webshell/backdoor, so "写马" = "write a webshell". Alternatives: "drop a webshell", "plant a backdoor".

## skills/pentest-tools/src-hunter/references/playbooks/unauth-access.md

**Original snippet:**
> 不要拖库

**English translation:**
> do not dump the database

**Why uncertain:**
"拖库" is Chinese security slang for exfiltrating an entire database ("dragging the database"). Alternatives: "do not exfiltrate the full database", "do not pull the whole database".

## skills/pentest-tools/src-hunter/references/playbooks/unauth-access.md

**Original snippet:**
> 万能密码

**English translation:**
> Universal password

**Why uncertain:**
"万能密码" (universal/all-purpose password) is Chinese slang for SQL-injection login-bypass payloads such as `' or '1'='1`, not an actual password. Alternatives: "authentication-bypass payload", "SQLi login bypass", "magic password".

## skills/pentest-tools/src-hunter/references/playbooks/unauth-access.md

**Original snippet:**
> 电信家庭网关 | telecomadmin/nE7jA%5m（固化无法改）

**English translation:**
> Telecom home gateway | telecomadmin/nE7jA%5m (hardcoded, cannot be changed)

**Why uncertain:**
"固化" in hardware/firmware contexts means "baked in / hardcoded in firmware". Alternatives: "firmware-fixed", "immutable". "电信" here refers to China Telecom specifically. Alternatives: "China Telecom home gateway".

## skills/pentest-tools/src-hunter/references/playbooks/mobile.md

**Original snippet:**
> 加固 | 360 加固、腾讯乐固 → 用脱壳工具 frida-dexdump

**English translation:**
> Hardening | 360 hardening, Tencent Legu → use unpacking tools such as frida-dexdump

**Why uncertain:**
"加固" is the standard Chinese term for app shielding/packing (protecting an APK against reverse engineering). "脱壳" means unpacking/dumping the protected DEX. Alternatives: "app shielding", "packing"; "unpacking" vs "shell removal".

## skills/pentest-tools/src-hunter/references/playbooks/mobile.md

**Original snippet:**
> 海康威视 | admin/12345

**English translation:**
> Hikvision | admin/12345

**Why uncertain:**
"海康威视" is the Chinese name of Hikvision; I used the internationally known brand name. Alternatives: "Hikvision (Haikang Weishi)".

## skills/pentest-tools/src-hunter/references/playbooks/mobile.md

**Original snippet:**
> 大华 | admin/admin

**English translation:**
> Dahua | admin/admin

**Why uncertain:**
"大华" is the Chinese name of Dahua Technology. Alternatives: "Dahua Technology".

## skills/pentest-tools/src-hunter/references/playbooks/mobile.md

**Original snippet:**
> 命中本类的 weakness 分布

**English translation:**
> Weakness distribution matching this category

**Why uncertain:**
"命中本类" means "hits/matches this category" (of vulnerability classification). Alternatives: "weakness distribution for matching reports", "weaknesses found in this category".

## skills/pentest-tools/src-hunter/references/playbooks/dos.md

**Original snippet:**
> DoS 是按量计费云服务（Lambda / GraphQL 解析 / 视频转码）的"账单炸弹"杠杆

**English translation:**
> DoS is the "bill bomb" lever for usage-billed cloud services (Lambda / GraphQL parsing / video transcoding)

**Why uncertain:**
"账单炸弹" (bill bomb) is a coined metaphor for an attack that inflates the victim's cloud bill. Alternatives: "billing bomb", "cost-explosion lever", "invoice bomb".

## skills/pentest-tools/src-hunter/references/playbooks/dos.md

**Original snippet:**
> 用户名长度无上限：服务端 500、Android app 直接 crash，互踢式 DoS

**English translation:**
> No username length limit: server 500, Android app crashes outright; mutual-lockout DoS

**Why uncertain:**
"互踢式" literally means "mutually kicking" (users knocking each other offline, e.g., session or contact-sync invalidation). Alternatives: "mutual-kick DoS", "users kicking each other offline", "cross-user lockout DoS".

## skills/pentest-tools/src-hunter/references/playbooks/dos.md

**Original snippet:**
> 用二倍递增法找拐点（关键：保留时间数据，禁止做满）

**English translation:**
> use doubling increments to find the knee (key: keep the timing data, never max out)

**Why uncertain:**
"拐点" in performance curves means the knee/inflection point where growth turns exponential. Alternatives: "turning point", "inflection point", "exponential knee".

## skills/pentest-tools/src-hunter/references/playbooks/dos.md

**Original snippet:**
> 铁则：DoS 是 SRC 中唯一一类"PoC 本身就可能违法"的漏洞。

**English translation:**
> Iron rule: DoS is the one SRC category where "the PoC itself may be illegal."

**Why uncertain:**
"铁则" = "iron rule" (unbreakable rule). Alternatives: "hard rule", "cardinal rule". Kept the literal metaphor since it reads naturally in English security writing.

## skills/pentest-tools/src-hunter/references/playbooks/dos.md

**Original snippet:**
> 命中本类的 weakness 分布

**English translation:**
> Weakness distribution matching this category

**Why uncertain:**
Same phrase as in unauth-access.md; "命中" means "hits/matches" a vulnerability classification. Alternatives: "weakness distribution for matching reports".


---

## From english.batch19.md

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/凭证窃取.md

**Original snippet:**
> # 凭证窃取

**English translation:**
> # Credential Theft

**Why uncertain:**
"凭证窃取" could be rendered "Credential Theft", "Credential Harvesting", or "Credential Exfiltration". Chose the literal "Credential Theft" for consistency with the filename; "Credential Harvesting" is the more idiomatic red-team term.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/凭证窃取.md

**Original snippet:**
> **语法解析：**

**English translation:**
> **Syntax Breakdown:**

**Why uncertain:**
"语法解析" literally means "syntax parsing/analysis", but in this catalog it labels a breakdown of each command-line flag. Considered "Syntax Analysis", "Command Breakdown", and "Syntax Breakdown"; chose "Syntax Breakdown" as the most natural heading for the content.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/凭证窃取.md

**Original snippet:**
> **漏洞原理：** Windows系统将用户凭证存储在LSASS进程内存中，Mimikatz可以直接读取这些凭证。这是Windows认证机制的设计特性。

**English translation:**
> **Vulnerability Mechanism:** Windows stores user credentials in the memory of the LSASS process, and Mimikatz can read them directly. This is a design characteristic of the Windows authentication mechanism.

**Why uncertain:**
"漏洞原理" is used loosely here: the LSASS behavior is by design, not a software bug. Considered "Vulnerability Principle", "Root Cause", and "Mechanism"; chose "Vulnerability Mechanism" while keeping the sentence's acknowledgment that this is a design characteristic.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/凭证窃取.md

**Original snippet:**
> **Skeleton Key植入**
> > 植入万能密码mimikatz

**English translation:**
> **Skeleton Key injection**
> > Inject the mimikatz master password

**Why uncertain:**
"万能密码" literally means "universal/one-size-fits-all password". In Skeleton Key attacks it is commonly called a "master password" or "skeleton key password". Considered "universal password", "master password", and "backdoor password"; chose "master password".

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/凭证窃取.md

**Original snippet:**
> _模拟域控制器同步获取凭证_

**English translation:**
> _Impersonate domain controller synchronization to obtain credentials_

**Why uncertain:**
"模拟" can mean "simulate" or "impersonate". DCSync abuses the replication protocol by impersonating a domain controller, so "impersonate" is technically accurate; "simulate" would be the more literal rendering.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/凭证窃取.md

**Original snippet:**
> **绕过文件访问监控**
> > 通过卷影副本或流式读取绕过文件访问监控

**English translation:**
> **Bypass file access monitoring**
> > Bypass file access monitoring via volume shadow copies or streamed reads

**Why uncertain:**
"流式读取" means reading a file as a stream. Considered "streamed reads", "streaming reads", and "stream-based reads"; chose "streamed reads" to match the bypass context.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/横向移动.md

**Original snippet:**
> **SSH跳板**
> > 通过跳板机连接

**English translation:**
> **SSH jump host**
> > Connect through a jump host

**Why uncertain:**
"跳板机" is commonly rendered "jump host", "jump box", or "bastion host". Chose "jump host" because the example uses OpenSSH `-J`, whose documentation calls it a jump host. "Bastion host" would imply a hardened network appliance rather than an intermediate SSH server.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/横向移动.md

**Original snippet:**
> 子类：**认证攻击** · tags: `pth` `ntlm` `hash` `authentication`

**English translation:**
> Subclass: **Authentication Attacks** · tags: `pth` `ntlm` `hash` `authentication`

**Why uncertain:**
"认证攻击" literally means "authentication attack". Considered "Authentication Attacks" and "Credential Attacks"; chose "Authentication Attacks" because these payloads abuse the authentication protocol itself rather than stealing credentials.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/横向移动.md

**Original snippet:**
> **前置条件：**
> - 可诱导目标机器认证

**English translation:**
> **Prerequisites:**
> - Able to coerce the target into authenticating

**Why uncertain:**
"诱导" means "induce", "lure", or "coerce". In NTLM relay and PetitPotam contexts the established English term is "coercion" (e.g., "coerce authentication"). Chose "coerce" over the more literal "induce" or "lure".

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/横向移动.md

**Original snippet:**
> 子类：**计划任务** · tags: `at` `scheduled` `lateral`

**English translation:**
> Subclass: **Scheduled Tasks** · tags: `at` `scheduled` `lateral`

**Why uncertain:**
"计划任务" is the Windows "Task Scheduler" feature. Considered "Scheduled Tasks" and "Task Scheduler"; chose "Scheduled Tasks" because the subclass label describes the mechanism used, not the GUI tool name.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/信息收集.md

**Original snippet:**
> # 信息收集

**English translation:**
> # Information Gathering

**Why uncertain:**
"信息收集" can be "Information Gathering", "Reconnaissance", or "Information Collection". Chose "Information Gathering" as the standard penetration-testing phase name; "Reconnaissance" is also common but overlaps with the earlier recon phase naming used elsewhere in the repo.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/信息收集.md

**Original snippet:**
> **概述：** 网络信息收集可以了解内网拓扑、网段划分、网关等信息。

**English translation:**
> **Overview:** Network information gathering reveals the intranet topology, subnet layout, gateways, and more.

**Why uncertain:**
"网段划分" literally means "network segment division". It can describe either the existing subnet layout or the act of segmenting the network. Chose "subnet layout" because the sentence lists it as information to be learned, not as a defensive action.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/信息收集.md

**Original snippet:**
> - 分时段进行扫描

**English translation:**
> - Spread scanning across time windows

**Why uncertain:**
"分时段" means "in divided time periods". Considered "spread scanning across time windows", "scan in phases", and "stagger the scan". Chose the first as the clearest OPSEC guidance.

## skills/pentest-tools/src-hunter/references/payloader/by-category/intranet/信息收集.md

**Original snippet:**
> **查找管理员会话**
> > 查找域管理员登录位置

**English translation:**
> **Find administrator sessions**
> > Find where domain administrators are logged on

**Why uncertain:**
"登录位置" literally means "logon location". Considered "where domain administrators are logged on" and "domain administrator logon locations"; chose the former for readability. The underlying PowerView command `Find-DomainUserLocation` is unchanged.


---

## From english.batch27.md

## skills/browser-extension-reverse/references/extension-analysis.md

**Original snippet:**
> | webRequestBlocking | 中间人式改写 |

**English translation:**
> | webRequestBlocking | Man-in-the-middle style rewriting |

**Why uncertain:**
"中间人式改写" is informal and could also be rendered "interception-style rewriting" or "MITM-style modification"; the phrase describes the capability rather than a specific attack.

## skills/browser-extension-reverse/references/extension-analysis.md

**Original snippet:**
> | nativeMessaging | 出浏览器到本机 |

**English translation:**
> | nativeMessaging | Communication out of the browser to the local machine |

**Why uncertain:**
"出浏览器到本机" is terse; alternatives include "escapes the browser to the host" or "browser-to-native messaging", which may be more idiomatic in extension-security writing.

## skills/browser-extension-reverse/references/extension-analysis.md

**Original snippet:**
> | externally_connectable | 网页驱动扩展 |

**English translation:**
> | externally_connectable | Web pages can drive the extension |

**Why uncertain:**
"网页驱动扩展" could also be "webpage-controlled extension" or "web pages can trigger the extension"; the exact nuance depends on whether the emphasis is on control or invocation.

## skills/cloud-k8s/references/k8s-cloud-checklist.md

**Original snippet:**
> - [ ] 返回的 IAM 角色权限面

**English translation:**
> - [ ] Permission surface of the returned IAM role

**Why uncertain:**
"权限面" is a compressed term; "permission surface" is common in cloud-security writing, but "permission scope" or "permission set" are also valid.

## skills/code-audit/references/sast-review-checklist.md

**Original snippet:**
> - [ ] 鉴权/鉴权中间件覆盖

**English translation:**
> - [ ] Auth/authz middleware coverage

**Why uncertain:**
"鉴权" can mean authentication, authorization, or both depending on context; the duplication in the source is ambiguous, so "auth/authz" was chosen to cover both readings.

## skills/digital-forensics/references/forensics-triage.md

**Original snippet:**
> 2. 内存急症（进程、网络、注入）

**English translation:**
> 2. Memory emergencies (processes, network, injection)

**Why uncertain:**
"内存急症" uses a medical metaphor; alternatives include "urgent memory analysis", "memory triage", or "memory hotspots". The intended urgency may not carry over literally.

## skills/go-rust-reverse/references/go-rust-notes.md

**Original snippet:**
> 两者均：优先字符串驱动，避免在运行时库中迷路。

**English translation:**
> Both: prefer string-driven analysis and avoid getting lost in the runtime libraries.

**Why uncertain:**
"优先字符串驱动" is elliptical; it could mean "prioritize string-driven approaches", "start from strings", or "let strings drive the analysis".

## skills/go-rust-reverse/references/go-rust-notes.md

**Original snippet:**
> Rust：先收集 `src/` 路径字符串与 `Option`/`Result` 处理块。

**English translation:**
> Rust: first collect `src/` path strings and `Option`/`Result` handling blocks.

**Why uncertain:**
"处理块" could mean "handling blocks", "handling code blocks", or "handling branches"; the exact structural unit is ambiguous.


---

## From english.batch23.md

## skills/field-journal/2026-05-25_pentest-cf-access-sibling-subdomain-cookie-poisoning.md

**Original snippet:**
> 返回一个 HTML 页面,中文 UI 写着"裤佬万能代理",输入框 → 跳转 `/?url=<目标>`

**English translation:**
> It returned an HTML page; the Chinese UI read "裤佬万能代理" (Universal Proxy), with an input box → redirects to `/?url=<target>`

**Why uncertain:**
"裤佬" is Chinese internet slang (literally "pants guy"), used here as a nickname/product brand for the proxy landing page. Options considered: leave the original Chinese in quotes (fails the no-CJK requirement), transliterate as "Kulao", or render the functional meaning "Universal Proxy". I kept a parenthetical English gloss so the meaning survives without inventing a brand name.

## skills/field-journal/2026-05-25_pentest-cf-access-sibling-subdomain-cookie-poisoning.md

**Original snippet:**
> **新模式 Top 3 沉淀**(应该加到 `_index.md` 的"高频成功模式")

**English translation:**
> **Top 3 new patterns to capture** (should be added to the "High-Frequency Success Patterns" in `_index.md`)

**Why uncertain:**
"沉淀" literally means "to settle/precipitate," used in Chinese engineering culture to mean "distill and preserve as reusable knowledge." Alternatives: "distill," "codify," "bank." "Capture" is the most natural English for knowledge-management context, but it loses the gradual-accumulation nuance.
