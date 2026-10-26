---
name: pwn-chain
description: |
  Full-chain engineering methodology from reverse engineering to a working exploit.
  Applicable scenarios: you have the binary + vulnerability point + target environment and need to write an exploit that reliably works end-to-end (not just a script that reproduces locally and crashes as soon as it is run remotely).
  Covers three major directions: stack overflow / heap exploitation / kernel pwn. Emphasizes the engineering gap between "CTF local success → real remote stable success": libc version mismatch, heap spray timing, SMEP/SMAP/KASLR, stack alignment, remote buffering.
  Core toolchain: pwntools + GEF/pwndbg + ROPgadget/Ropper + one_gadget + libc-database + qemu-system kernel debugging.
  Trigger keywords: pwn, stack overflow, heap overflow, ROP, ret2libc, ret2csu, one_gadget, libc-database, heap exploitation, tcache, fastbin, unsorted bin, kernel pwn, kROP, SMEP, SMAP, KASLR, modprobe_path, pwntools, GEF, pwndbg.
---

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md` — confirm this skill's operations are authorized routine operations
2. `NOW`: Confirm whether the current task falls within this skill's applicable scope
3. `NEXT`: Read `../tool-index.md`, verify tool availability and actual paths
4. `NEXT`: When tools are missing, call bootstrap; do not guess paths
5. `ACT`: Enter the first step of the "Workflow" and execute; do not stop at the confirmation state

# From Vulnerability Point to Working Exploit (Pwn Chain)

## Applicable Scope

Use this skill when the task belongs to the following scenarios:

1. **Have the binary + known vulnerability point** — Static analysis/audit/fuzzing has already found an overflow/UAF/double free; need to go from trigger to shell.
2. **CTF challenge already works locally but fails remotely** — Remote environment differences break the script; need stabilization.
3. **Binary exploitation of real targets** — In SRC / red team scenarios, a memory corruption vulnerability has been identified; need to construct RCE.
4. **Linux kernel driver ioctl bug** — Triggered from user mode; goal is privilege escalation to root.

**Prerequisite**: You already know "where it crashes." This skill is not responsible for discovering vulnerabilities (that is fuzzing / auditing); it is only responsible for "writing an exploit from the vulnerability point."

### Division of Labor with Other Skills

| Scenario | Use |
|------|--------|
| Identify custom VM / anti-debug / complex obfuscation | `reverse-engineering/` |
| Open a binary from scratch for static analysis | `ida-reverse/` or `radare2/` |
| **Have a vulnerability point, write an exploit to work remotely** | **This skill** |
| Integrate the shell obtained from pwn into a complete attack chain | `attack-chain/` (downstream) |

`reverse-engineering/` focuses on "understanding what the program is doing" (pattern recognition, protocol recovery, solving strange mechanisms in CTF challenges); this skill focuses on "turning an already-understood vulnerability into an executable attack." The two are often used together, but the division of labor is clear.

## Core Workflow

```text
Step 1: Confirm vulnerability type + protection mechanisms
   ├─ checksec ./vuln (NX / Canary / PIE / RELRO / Fortify)
   ├─ file ./vuln  + readelf -d ./vuln
   ├─ Vulnerability classification: stack overflow / format string / heap (UAF/DF/OF) / integer / race / kernel
   └─ → Decide which references/ to use

Step 2: Choose exploitation strategy
   ├─ NX off + no ASLR → direct shellcode
   ├─ NX on + libc provided → ret2libc / one_gadget
   ├─ NX on + no libc → leak then libc-database lookup
   ├─ Heap → technique by glibc version (tcache/fastbin/unsorted/large)
   └─ Kernel → commit_creds / modprobe_path / core_pattern

Step 3: Prepare libc + gadgets
   ├─ libc-database: ./find puts 0x6f0
   ├─ ROPgadget --binary ./libc.so.6 --only "pop|ret"
   ├─ one_gadget ./libc.so.6
   └─ Calculate base: leak_addr - libc.sym['puts']

Step 4: Write pwntools template (local process)
   ├─ context.binary = ELF('./vuln')
   ├─ p = process('./vuln')  /  p = gdb.debug('./vuln','b *main+xx')
   ├─ payload = cyclic(N) + p64(ret) + ...
   └─ p.interactive()

Step 5: Works locally
   ├─ Repeatedly attach + inspect registers + adjust offset
   ├─ Use pwndbg/GEF's vmmap / heap / bins / telescope
   └─ After it works, switch to remote()

Step 6: Remote stabilization
   ├─ libc offset: use leak to look up libc-database; do not guess
   ├─ Stack alignment: 16-byte misalignment → movaps crash → add a ret gadget
   ├─ Remote network latency → recvuntil precise anchor strings; disable fuzzy sleep
   ├─ Remote buffering: sendlineafter is more stable than sendline
   ├─ Heap spray success rate: increase spray count + leave padding chunks to prevent merging
   └─ Run multiple times: write while True to verify success rate ≥ 95%
```

## Typical Scenarios

### Scenario 1: Remote 64-bit Binary (NX+PIE+canary, libc provided)

```text
Available: ./vuln (64-bit ELF, NX, PIE, canary) + ./libc.so.6 + nc host port
Vulnerability: read(buf, 0x200) but buf is only 0x40 bytes → stack overflow
Protections: canary blocks it; PIE randomizes .text

Strategy:
1. First leak canary (stack/format string/partial read)
2. Then leak a libc function address (puts@got)
3. Compute libc base with libc.address = leaked - libc.sym['puts']
4. Use one_gadget ./libc.so.6 to choose a magic gadget whose constraints can be satisfied
5. payload = padding + canary + saved_rbp + (pop_rdi + bin_sh + system) or direct one_gadget
6. Add a ret gadget to fix stack alignment (critical!)
```

For the complete template, see `references/stack-pwn.md`.

### Scenario 2: Linux Kernel Driver ioctl Out-of-Bounds Write → Get Root

```text
Available: vmlinux + bzImage + initramfs.cpio.gz + custom vuln.ko
Vulnerability: in ioctl(0x1337, ptr), copy_from_user length is controllable → kernel heap overflow (kmalloc-64 slab)
Protections: SMEP, SMAP, KASLR, KPTI

Strategy:
1. Modify the init script to get a root shell (CTF) or first leak the KASLR base then continue (real)
2. Leak the kernel base via /proc/kallsyms (may be restricted) or uninitialized heap spray
3. Spray tty_struct / msg_msg / pipe_buffer in the kmalloc-64 slab
4. Overwrite the vtable pointer to point to user mode → not possible (SMEP); switch to stack pivot + kernel ROP
5. ROP chain: prepare_kernel_cred(0) → commit_creds → swapgs+iretq → user-mode execve("/bin/sh")
6. Or simpler: overwrite modprobe_path to "/tmp/x", write /tmp/x, then trigger modprobe
```

For the complete template, see `references/kernel-pwn.md`.

## On-Demand Bootstrap

### Tool Dependencies

| Tool | Purpose | Installation |
|------|------|---------|
| pwntools | Exploit writing framework | `pip install pwntools` |
| GEF | gdb enhancement (recommended for kernel + user mode) | `git clone https://github.com/bata24/gef` (fork actively maintained) |
| pwndbg | gdb enhancement (best heap debugging experience) | `git clone https://github.com/pwndbg/pwndbg && ./setup.sh` |
| ROPgadget | Gadget search | `pip install ropgadget` |
| Ropper | Gadget search (alternative, supports more architectures) | `pip install ropper` |
| one_gadget | libc magic gadget finder | `gem install one_gadget` (requires ruby) |
| libc-database | libc fingerprint lookup | `git clone https://github.com/niklasb/libc-database && ./get` |
| qemu-system-x86_64 | Kernel challenge debugging | `apt install qemu-system-x86` |
| binwalk / cpio | initramfs unpacking | `apt install binwalk cpio` |
| patchelf | Switch libc versions | `apt install patchelf` |

### Bootstrap Check Script

```bash
# One-click check + install core tools
for t in pwntools ropgadget ropper; do
  pip show $t >/dev/null 2>&1 || pip install $t
done

command -v one_gadget >/dev/null || gem install one_gadget

[ -d ~/tools/libc-database ] || git clone https://github.com/niklasb/libc-database ~/tools/libc-database
[ -d ~/tools/libc-database/db ] || (cd ~/tools/libc-database && ./get ubuntu debian)

[ -d ~/tools/pwndbg ] || (git clone https://github.com/pwndbg/pwndbg ~/tools/pwndbg && cd ~/tools/pwndbg && ./setup.sh)
```

### After Automatic Installation of the Same Tool Fails Twice

Stop retrying and output structured manual installation steps (pip source / gem source / domestic Git mirror / apt source) for the user to confirm.

## Routing Context

**Upstream entry**: `skills/SKILL.md` (master control), `routing.md`
**Trigger conditions**: Have a binary + identified vulnerability point; need to write an exploit

**Upstream skills (use them first, then return to this skill)**:
- Still do not understand what the binary is doing → `reverse-engineering/`
- Need detailed static analysis → `ida-reverse/`
- Quick reconnaissance to confirm architecture/protections → `radare2/`

**Downstream skills (after obtaining a shell)**:
- Integrate into a complete attack chain (lateral movement, privilege escalation, persistence) → `attack-chain/`

**Submodule navigation**:
- Stack exploitation (ret2libc / ret2csu / one_gadget / stack alignment) → `references/stack-pwn.md`
- Heap exploitation (tcache / fastbin / unsorted / large bin / FILE struct) → `references/heap-pwn.md`
- Kernel pwn (kROP / SMEP-SMAP bypass / KASLR leak / modprobe_path) → `references/kernel-pwn.md`

## Notes

- **Do not deliver after it works locally** — Local libc / ASLR / network environments differ from remote; you must run continuously 20+ times in remote mode to verify stability.
- **libc version must be confirmed** — Use leak + libc-database lookup; do not assume it is the default libc of Ubuntu 22.04.
- **Stack alignment is a common 64-bit pitfall** — `movaps xmm0, [rsp]` segfaults when rsp is not 16-byte aligned; add an empty `ret` gadget to solve it.
- **Heap exploitation is extremely sensitive to glibc version** — tcache was introduced in 2.27, safe-linking in 2.32, hooks removed in 2.34; each version has a different exploitation path.
- **Kernel pwn must first confirm CPU flags** — Whether qemu boot parameters include +smep +smap +pku directly determines how to write the ROP chain.
- **One KASLR leak is enough** — After obtaining one kernel address, all addresses are computed as offsets; do not repeatedly leak.

## Task Completion Self-Check (MUST pass before claiming completion)

- [ ] Have I executed each step in the workflow (rather than just reading)?
- [ ] Have I used real tool paths based on `tool-index`?
- [ ] Have I produced reproducible evidence (commands/scripts/screenshots/reports)?
- [ ] Have I completed and written back the Checklist items required by RULES?
