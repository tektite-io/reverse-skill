# [Seed] ELF Self-Extracting Loader Reverse Engineering

## Scenario Classification
Binary Analysis

## Goal Overview
Analyze an ARM64 ELF self-extracting loader disguised as a .sh script, and recover its decompression algorithm and payload injection process.

## Complete Execution Chain

1. Use the `file` command to confirm the real type (ELF, not a shell script).
2. Use `readelf -l` to view program headers → discover that the 3rd PHDR is intentionally corrupted (0x0a padding).
3. Use `rabin2 -I` to obtain architecture (AArch64), entry point, and compiler information.
4. Load into IDA/Ghidra → start analysis from the entry point.
5. Identify the LZSS decompression loop (bitstream operations + sliding window copy-back).
6. Identify the injection flow: mmap → decompress → mprotect → jump.
7. Rewrite the decompressor in Python and dump the payload.
8. Analyze the payload content (contains a `/proc/self/exe` reference, indicating it is a process injector).

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| readelf error, unable to parse | The 3rd PHDR is intentionally filled with 0x0a | Ignore the corrupted PHDR, only look at the first 2 LOAD segments | 10min |
| IDA decompilation result unreadable | Dense ARM64 bit operations, poor Hex-Rays optimization | Switch to disassembly view for manual analysis | 30min |
| Python decompressor implementation outputs errors | pop_bit refill path returns wrong value (adcs vs adds) | Carefully compare with assembly; on refill, the return value is the bit31 of the newly loaded word | 2h |
| Uncertain about payload entry offset | The meaning of the `entry_offset` field in the data table is unclear | Trace the loader function's `br mmap_base + 0x14`; confirm the entry is at +0x14 | 20min |

## Toolchain Findings

- The `file` command is the first step; never trust file extensions.
- `rabin2 -I` is more fault-tolerant than `readelf` (it can handle corrupted PHDRs).
- For ARM64 code with dense bit operations, a decompiler is not as good as reading the assembly directly.
- The Python `struct` module plus a hand-written decompressor is the standard method for analyzing custom compression.

## Key Code/Commands

```bash
# Confirm file type
file LinYuDriverLoader4.9.sh
# ELF 64-bit LSB executable, ARM aarch64

# View program headers
readelf -l binary 2>/dev/null | head -20

# Extract compressed data
dd if=binary bs=1 skip=$((0xa6a24)) count=1981 of=compressed.bin

# Calculate file offset
# vaddr 0x3d66bc → file_offset = 0x3d66bc - 0x330000 = 0xa66bc
```

```python
# LZSS decompressor core (simplified)
def decompress(data):
    shift_reg = 0x80000000
    # ... bitstream reading + literal/match branches
```

## Suggestions for This Package

- `elf-analysis.md` should include more features for "custom compression algorithm identification".
- The ARM64 syscall table should include descriptions of cache maintenance instructions (dc cvau / ic ivau).
- Suggest adding a general methodology for "how to rewrite assembly algorithms in Python".

## Reusable Patterns/Script Snippets

**Standard pattern for identifying self-extracting ELF**:
```text
Entry point → minimal initialization → call decompression function → mmap(RW) → decompress into mmap region → mprotect(RX) → jump
```

**General pattern for ARM64 bitstream reading**:
```text
lsl w4, w4, #1    # left shift (extract the highest bit into carry)
cbz w4, refill    # if shifted empty, load a new 32-bit word from input
```

## Evolution Actions
- [x] Updated sub-skill documentation (elf-analysis.md has been added)
- [ ] No need to update routing matrix
- [ ] No need to update bootstrap-manifest

## Environment Information
- OS: Linux/Android ARM64 target
- Tool versions: IDA Pro / Ghidra + radare2
- Target platform: Android ARM64 (AArch64)

## Anonymization Requirements
This entry is seed data, written based on public technical patterns, and does not involve real targets.

---
<!-- [Community Contribution] Seed data, no PR required -->
