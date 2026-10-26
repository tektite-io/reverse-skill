# Kali Linux entry (short redirect)

> **The detailed instructions in [kali/README-kali.md](kali/README-kali.md) are authoritative.**  
> This file is only a quick Kali entry point at the repository root, to avoid maintaining duplicate content under `kali/`.

## AI: execute immediately after reading

```text
1. Detect the package root (the directory containing README.md / skills/)
2. Read kali/README-kali.md → then read and execute kali/RULES-kali.md
3. bash kali/scripts/refresh-tool-index.sh
4. Task routing is shared with Windows: skills/MASTER-ROUTING.md, skills/ops/ (scope gate)
5. Report the configuration result to the user
```

## Humans: get started in 30 seconds

```bash
cd /path/to/reverse-skill
bash kali/scripts/refresh-tool-index.sh
# See kali/README-kali.md for detailed bootstrap / MCP instructions
```

## Relationship to the main package

| Content | Location |
|---------|----------|
| Shared skills / routing / ops | `skills/`, `RULES.md` |
| Kali scripts and manifest | `kali/scripts/` |
| Full Kali documentation | **[kali/README-kali.md](kali/README-kali.md)** |

For general AI guidance, see [README_AI.md](README_AI.md) (when choosing the Kali branch, refer to the documents in this directory).
