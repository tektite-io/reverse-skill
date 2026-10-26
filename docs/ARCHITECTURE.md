# System Architecture Diagram

## Complete Behavior Chain Flowchart

```mermaid
flowchart TD
    Start([User proposes security/reverse-engineering task]) --> Detect{Trigger keyword match?}
    Detect -->|Yes| ReadRouting[Read SKILL.md + routing.md]
    Detect -->|No| Normal([Normal conversation])
    
    ReadRouting --> RouteMatch{Routing matrix match?}
    RouteMatch -->|Not matched| ProposeNew[Propose new skill<br/>per CONTRIBUTING.md]
    RouteMatch -->|Matched| CheckJournal[Check field-journal<br/>for similar experience]
    
    CheckJournal --> CheckTools[Read tool-index.md<br/>confirm tool status]
    CheckTools --> ToolOK{Tool available?}
    
    ToolOK -->|Missing| Bootstrap[Invoke bootstrap-reverse.ps1<br/>auto-install]
    ToolOK -->|Available| Execute[Enter skill workflow]
    
    Bootstrap --> BootOK{Installation successful?}
    BootOK -->|Success| Execute
    BootOK -->|Failed| Guide[Output structured guidance<br/>wait for user manual handling]
    Guide --> UserConfirm([User confirms installed])
    UserConfirm --> Execute
    
    Execute --> TaskDone{Task complete?}
    TaskDone -->|No| Execute
    TaskDone -->|Yes| ReviewCase[Invoke case-review<br/>validate evidence graph]
    ReviewCase --> GenReport[Invoke docs-generator<br/>generate report + diagrams]
    
    GenReport --> WriteJournal[Write back to field-journal<br/>accumulate experience]
    WriteJournal --> UpdateIndex[Update index/routing/manifest]
    UpdateIndex --> Output([Output final result])
```

## Skills Module Relationship Diagram

```mermaid
flowchart LR
    subgraph RoutingLayer[Routing Layer]
        SKILL[SKILL.md<br/>Master control entry]
        Routing[routing.md<br/>Routing matrix]
    end

    subgraph ReverseEngineering[Reverse Engineering]
        APK[apk-reverse<br/>APK reverse engineering]
        IDA[ida-reverse<br/>IDA Pro]
        R2[radare2<br/>CLI analysis]
        RE[reverse-engineering<br/>General methodology]
        BinDiff[binary-diff<br/>Symbol migration]
        PatchDiff[patch-diff-exploit<br/>N-day weaponization]
    end

    subgraph Exploitation[Exploitation]
        Pwn[pwn-chain<br/>RE→exploit]
        Firmware[firmware-pentest<br/>Firmware full chain]
    end

    subgraph PenetrationTesting[Penetration Testing]
        Pentest[pentest-tools<br/>Toolchain + loop framework]
        SrcHunter[src-hunter<br/>19 playbooks]
        EDR[edr-bypass-re<br/>EDR bypass]
    end

    subgraph WebBrowser[Web/Browser]
        JS[js-reverse<br/>JS signature reverse engineering]
        Browser[browser-automation<br/>Playwright+OpenReverse]
    end

    subgraph Infrastructure[Infrastructure]
        Bootstrap[bootstrap-reverse.ps1<br/>On-demand bootstrap]
        Discovery[ToolDiscovery.ps1<br/>Tool discovery]
        ToolIndex[tool-index<br/>Status index]
    end

    subgraph OutputLayer[Output Layer]
        Docs[docs-generator<br/>Report generation]
        Diagram[diagram-generator<br/>Diagram generation]
        Review[case-review<br/>Evidence graph audit]
        Journal[field-journal<br/>Automatic evolution]
    end

    subgraph External[External]
        CTF[CTF-Sandbox-Orchestrator<br/>40+ sub-skills]
    end

    SKILL --> Routing
    Routing --> APK & IDA & R2 & RE & BinDiff & PatchDiff
    Routing --> Pentest & JS & Browser & Pwn & Firmware & EDR
    Routing --> CTF

    Pentest --> SrcHunter
    APK -->|.so triage| IDA
    APK -->|.so triage| R2
    PatchDiff -->|Write PoC| Pwn
    Firmware -->|Find crash| Pwn
    Pwn -->|Integrate| Pentest
    EDR -->|Delivery phase| Pentest
    JS -->|Browser operations| Browser
    
    Bootstrap --> Discovery --> ToolIndex
    
    APK & IDA & R2 & Pentest & JS -->|Task complete| Review
    Review --> Docs
    Docs --> Diagram
    Docs --> Journal
```

## Bootstrap Process

```mermaid
flowchart TD
    Need[Tool missing detected] --> ReadManifest[Read bootstrap-manifest.json]
    ReadManifest --> Kind{Installation type?}
    
    Kind -->|github-release-zip| GH[From GitHub Release<br/>download and unzip ZIP]
    Kind -->|pip-package| Pip[pip install]
    Kind -->|npm-mcp| NPM[npx start + register MCP]
    Kind -->|npm-global| Global[npm install -g<br/>+ postInstall]
    Kind -->|winget-package| Winget[winget install]
    Kind -->|local-http-mcp| HTTP[Register URL + start service]
    
    GH & Pip & NPM & Global & Winget & HTTP --> Verify{Verify availability?}
    Verify -->|Success| AddPath[Add to PATH<br/>refresh tool-index]
    Verify -->|Failed| Manual[Output manual installation guidance]
    
    AddPath --> Continue([Continue executing task])
    Manual --> Wait([Wait for user confirmation])
```

## Penetration Testing Loop

```mermaid
flowchart TD
    Init[Initialization: determine target/scope/tools] --> Loop

    subgraph Loop[Core Loop]
        Align[1. Realign objectives] --> Review[2. Review known findings]
        Review --> Decide[3. Decide next action]
        Decide --> Risk{4. Risk gate}
        Risk -->|Low/Medium/High| Exec[5. Execute action]
        Risk -->|Critical| Ask[Request user approval]
        Ask -->|Approved| Exec
        Exec --> Record[6. Record results]
        Record --> Check{7. Self-check}
        Check -->|Continue| Align
        Check -->|Done| Done
    end

    Done[8. Completion check] --> Report([Generate final report])
```

## Automatic Evolution Mechanism

```mermaid
flowchart LR
    Task([Complete task]) --> WriteLog[Write to field-journal<br/>pitfalls + solutions + code]
    WriteLog --> UpdateIdx[Update _index.md<br/>categorize by scenario]
    UpdateIdx --> CheckUpdate{Need system update?}
    
    CheckUpdate -->|Routing missing| FixRoute[Update routing.md]
    CheckUpdate -->|Tool changed| FixTool[Refresh tool-index]
    CheckUpdate -->|New tool| FixManifest[Update bootstrap-manifest]
    CheckUpdate -->|No update needed| Done([Done])
    
    FixRoute & FixTool & FixManifest --> Done

    NewTask([Next similar task]) --> ReadIdx[Read _index.md]
    ReadIdx --> Reuse[Reuse existing experience<br/>avoid repeating pitfalls]
```

## Multi-Platform Support Architecture

```mermaid
flowchart TD
    subgraph SharedLayer["Shared Layer (Platform-Independent)"]
        Skills[skills/<br/>SKILL.md + routing.md + references]
        CTF[CTF-Sandbox-Orchestrator/<br/>40+ sub-skills]
        Journal[field-journal/<br/>Accumulated experience]
        Docs[docs-generator + diagram-generator]
    end

    subgraph Windows["Windows Platform Layer"]
        WinScripts[skills/scripts/*.ps1<br/>PowerShell scripts]
        WinManifest[bootstrap-manifest.json<br/>winget + GitHub ZIP]
        WinRules[RULES.md<br/>Windows version rules]
    end

    subgraph Kali["Kali Linux Platform Layer"]
        KaliScripts[kali/scripts/*.sh<br/>Bash scripts]
        KaliManifest[kali/scripts/bootstrap-manifest.json<br/>apt + pip + GitHub tar]
        KaliRules[kali/RULES-kali.md<br/>Kali version rules]
    end

    Skills --> WinScripts & KaliScripts
    CTF --> WinScripts & KaliScripts
    Journal --> WinScripts & KaliScripts

    WinScripts --> WinManifest
    KaliScripts --> KaliManifest

    WinRules --> Skills
    KaliRules --> Skills
```

### Platform Selection Logic

| Environment | Rule file used | Scripts used | Package management |
|------|--------------|-----------|--------|
| Windows | `RULES.md` | `skills/scripts/*.ps1` | winget / GitHub Release ZIP |
| Kali Linux | `kali/RULES-kali.md` | `kali/scripts/*.sh` | apt / pip / npm / GitHub tar.gz |

### Kali Version Features

- **Many pre-installed tools**: nmap, sqlmap, hashcat, hydra, metasploit, radare2, binwalk, burpsuite, etc. require no bootstrap
- **Unified apt management**: no winget needed, no manual ZIP extraction needed
- **Native bash**: simpler scripts, no PowerShell dependency
- **Path conventions**: `/usr/bin/`, `/opt/`, `~/tools/`, no drive letters or space issues

## File Reading Sequence Diagram

```mermaid
sequenceDiagram
    participant U as User
    participant AI as AI Client
    participant R as RULES.md / RULES-kali.md
    participant SK as SKILL.md
    participant RT as routing.md
    participant TI as tool-index.md
    participant FJ as field-journal
    participant SUB as Sub-skill
    participant BS as bootstrap
    participant DOC as docs-generator

    U->>AI: Propose security task
    AI->>R: Read routing rules
    AI->>SK: Read master control entry
    AI->>RT: Routing match
    AI->>FJ: Check similar experience
    AI->>TI: Confirm tool status
    alt Tool missing
        AI->>BS: Auto-install (.ps1 or .sh)
        BS-->>AI: Result
    end
    AI->>SUB: Enter workflow
    AI-->>U: Task result
    AI->>DOC: Generate report
    AI->>FJ: Write back experience
    AI-->>U: Complete
```
