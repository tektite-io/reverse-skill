# AI-Assisted Reverse Engineering

> LLM-driven decompilation / multi-agent verification / neural semantic recovery
> The biggest paradigm shift of 2025-2026

## Core Tools and Models

### LLM4Decompile
- The first open-source framework to use LLMs for binary-to-source decompilation
- Supports multiple architectures: x86/ARM/MIPS
- Input: assembly code → Output: C source code
- Training data: millions of source-assembly pairs

### Decaf (2026)
- **Compiler feedback verification**: Compile the LLM-generated source → compare against the original binary
- Result: decompilation rate 26% → 83.9% (ExeBench Real -O2)
- Key insight: feedback loops are more effective than larger models

### Constraint-Guided Multi-Agent (2026)
- Three-stage verification pipeline:
  1. Syntactic correctness (parsing)
  2. Compilability (GCC)
  3. Behavioral equivalence (LLM-generated test cases)
- 84-97% re-executability rate, only $0.03-0.05 per run

### REMEND (2026)
- Specialty: extracting mathematical equations from binaries
- 89.8-92.4% accuracy (across 3 ISAs × 3 optimization levels × 2 languages)
- Speed: 0.132s/function, only 12M parameters

### Glaurung
- Open-source Ghidra alternative, Rust core + Python bindings
- **AI-native architecture**: LLM agents embedded in every analysis layer
- Evidence artifacts: plain/rich/JSON/JSONL multi-format output for LLM consumption
- Supports: ELF/PE/Mach-O, x86/ARM/RISC-V, IOC detection, entropy analysis

## Workflow: AI-Augmented Binary Analysis

### 1. LLM-Assisted Rapid Reconnaissance

```text
□ strings extraction → LLM semantic classification (URL/keys/paths/protocols)
□ Import table analysis → LLM infers functionality (encryption=OpenSSL? networking=libcurl?)
□ Disassembly snippets → LLM identifies patterns (crypto algorithms, anti-debugging, VM detection)
□ Error messages → LLM infers context ("Invalid license" → location of licensing logic)
```

### 2. Neural Decompilation

```bash
# LLM4Decompile
python llm4decompile.py --binary target.so --arch arm64 --output target.c

# Verify results (recompile + compare)
gcc -O2 -o target_recompiled target.c -fPIC -shared
# → Verify output behavioral equivalence
```

### 3. Multi-Agent Verification

```text
Agent 1 (syntax): Check whether the generated C code can be parsed
  ↓ Failure → Feed error message back to LLM for retry
Agent 2 (compilation): GCC compile → check warnings/errors
  ↓ Failure → Feed compilation errors back to LLM
Agent 3 (behavior): LLM generates inputs → run original and recompiled versions → compare outputs
  ↓ Mismatch → Feed differences back to LLM → iterative correction
```

### 4. LLM-Assisted Static Analysis

```text
□ Function renaming: Input decompiled pseudocode → LLM suggests semantic names
□ Type recovery: Analyze context → LLM infers struct/class definitions
□ Algorithm identification: Assembly snippets → LLM identifies crypto algorithms (AES/TEA/RC4/custom)
□ Protocol reverse engineering: Network packet sequences → LLM infers protocol format
□ Comment generation: Decompiled code → LLM generates Chinese/English comments
```

### 5. macOS/iOS Private Framework Reverse Engineering (MOTIF)

```text
Problem: macOS private frameworks are undocumented and lack type information
Solution: LLM analyzes usage patterns → infers method signatures and parameter types
Result: ObjC signature recovery 15% → 86% (vs. static analysis)
```

## LLM Prompt Templates

### Function Semantic Analysis

```
You are a reverse engineering expert. Analyze this decompiled function:

[pseudocode]

1. What does this function do? (one sentence)
2. Suggest a meaningful function name.
3. What are the input parameters and their likely types?
4. What is the return value?
5. What external APIs/functions does it depend on?
6. Any security-relevant operations (crypto, auth, network, file I/O)?
```

### Algorithm Identification

```
Analyze this assembly/disassembly for cryptographic operations:

[assembly code]

1. Is this a known cryptographic algorithm? (AES/DES/RC4/TEA/ChaCha20/custom?)
2. Identify the key schedule and round structure.
3. What is the key size?
4. Are there any hardcoded constants that identify the algorithm?
```

### Protocol Format Inference

```
Given this network packet sequence, infer the protocol structure:

[hex dump]

1. Identify magic bytes and length fields.
2. Propose a struct definition for the packet header.
3. What field(s) appear to be checksums/CRCs?
4. Is this a known protocol or custom?
```

## Tool Selection

| Scenario | Recommended Tool | Cost |
|------|---------|------|
| Fast decompilation | LLM4Decompile | Free (local GPU) |
| High-precision decompilation | Constraint-Guided Multi-Agent | ~$0.05/binary |
| Mathematical function extraction | REMEND | Free |
| Cross-platform RE | Glaurung (Rust) | Free and open source |
| LLM interaction | Claude API / GPT-4 / DeepSeek | ~$0.01-0.10/run |

## Limitations

- **Complex control flow**: Virtualized/obfuscated code remains difficult (control flow flattening, VMProtect)
- **Indirect calls**: Virtual function tables and function pointers are hard to recover
- **Inlined functions**: Boundaries blur after compiler inlining
- **Floating-point operations**: Semantic recovery of vectorized instructions needs improvement
- **Context window**: Large functions (>1000 lines) exceed LLM context limits

Source: Decaf (2026), REMEND (2026), Constraint-Guided Multi-Agent Decompilation (2026), LLM4Decompile, Glaurung
