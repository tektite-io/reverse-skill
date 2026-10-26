# Kernel Driver Reverse Engineering Reference

> Covers Windows/Linux kernel driver reverse engineering, rootkit analysis, and C/C++ binary pattern recognition.

---

## Windows Driver Reverse Engineering

### Driver Types

| Type | Characteristics | Analysis focus |
|------|------|---------|
| WDM (Windows Driver Model) | Legacy driver; manages IRPs manually | DriverEntry → device creation → Dispatch routines |
| KMDF (Kernel Mode Driver Framework) | Modern framework; event-driven | EvtDriverDeviceAdd → Queue → I/O callbacks |
| WDF (Windows Driver Foundation) | Umbrella term for KMDF + UMDF | Look for WdfDriverCreate calls |
| Minifilter | File system filter driver | FltRegisterFilter → Pre/Post callbacks |

### WDM Driver Analysis Workflow

```text
1. Find DriverEntry (the entry point)
   - IDA identifies it automatically, or search for IoCreateDevice / IoCreateSymbolicLink

2. Find the device name and symbolic link
   - IoCreateDevice → DeviceName (e.g., \Device\MyDriver)
   - IoCreateSymbolicLink → SymLink (e.g., \DosDevices\MyDriver)

3. Find the Dispatch routines
   - DriverObject->MajorFunction[IRP_MJ_DEVICE_CONTROL] = DispatchIoctl
   - This is the entry point called from user mode via DeviceIoControl

4. Analyze IOCTL handling
   - switch(IoControlCode) dispatches different functions
   - IOCTL encoding: CTL_CODE(DeviceType, Function, Method, Access)
   - Method: METHOD_BUFFERED / METHOD_IN_DIRECT / METHOD_OUT_DIRECT / METHOD_NEITHER

5. Find vulnerabilities
   - User-controlled buffer without length validation → overflow
   - METHOD_NEITHER uses user pointers directly → arbitrary read/write
   - IOCTL permission not checked → unprivileged users can call it
```

### IOCTL Encoding Parsing

```python
# Parse an IOCTL code
def decode_ioctl(code):
    device_type = (code >> 16) & 0xFFFF
    access = (code >> 14) & 0x3
    function = (code >> 2) & 0xFFF
    method = code & 0x3
    
    methods = {0: "BUFFERED", 1: "IN_DIRECT", 2: "OUT_DIRECT", 3: "NEITHER"}
    access_types = {0: "ANY", 1: "READ", 2: "WRITE", 3: "READ|WRITE"}
    
    return f"DevType=0x{device_type:X} Func=0x{function:X} Method={methods[method]} Access={access_types[access]}"

# Example
decode_ioctl(0x80002034)
# DevType=0x8000 Func=0x80D Method=BUFFERED Access=ANY
```

### IDA Plugins

| Plugin | Purpose | Link |
|------|------|------|
| **Driver Buddy Reloaded** | Automatically identifies IOCTLs, Dispatch routines, device names | https://github.com/VoidSec/DriverBuddyReloaded |
| **WinDbg + IDA** | Kernel debugging + static analysis combined | Built-in |
| **FLIRT/Lumina** | Identify WDK library functions | Built into IDA |

### Reference Articles

- [Windows Drivers RE Methodology (VoidSec)](https://voidsec.com/windows-drivers-reverse-engineering-methodology/) — the most complete WDM driver reverse engineering methodology
- [Driver Reversing 101](https://eversinc33.com/posts/driver-reversing.html) — WDM vs KMDF comparison
- [Methodology of Reversing Vulnerable Killer Drivers](https://whiteknightlabs.com/2025/10/28/methodology-of-reversing-vulnerable-killer-drivers/) — vulnerable driver analysis

---

## Linux Kernel Module Reverse Engineering

### LKM (Loadable Kernel Module) Structure

```text
Key functions:
- init_module / module_init → executed when the module is loaded
- cleanup_module / module_exit → executed when the module is unloaded

Key structures:
- struct file_operations → open/read/write/ioctl for character devices
- struct net_device_ops → network device operations
- struct block_device_operations → block device operations
```

### Analysis Workflow

```text
1. Confirm it is a kernel module
   file module.ko → "ELF 64-bit ... relocatable" (note: relocatable, not executable)

2. Find the init/exit functions
   readelf -s module.ko | grep -E "init_module|cleanup_module"
   Or look for module information in the .modinfo section

3. Find the file_operations structure
   Search for register_chrdev / cdev_add / misc_register
   → Locate the fops struct → locate the ioctl/read/write handlers

4. Analyze ioctl handling
   unlocked_ioctl / compat_ioctl functions
   → switch(cmd) dispatch

5. Look for rootkit behavior
   - Modify sys_call_table → syscall hook
   - Modify the /proc filesystem → hide processes/files
   - Register a netfilter hook → hide network connections
   - Modify the VFS layer → hide files
```

### Common Rootkit Techniques

| Technique | Characteristics | Detection Method |
|------|------|---------|
| syscall table hook | Modify `sys_call_table` entries | Compare the in-memory table against the on-disk vmlinux |
| VFS hook | Modify `file_operations` function pointers | Check whether fops pointers point outside the kernel code segment |
| Netfilter hook | `nf_register_net_hook` | Walk the netfilter hook list |
| kprobe/ftrace hook | Register kprobe or ftrace callbacks | Check the ftrace registration list |
| eBPF rootkit | Load a malicious BPF program | `bpftool prog list` |
| DKOM | Directly modify kernel objects (process lists) | Walk the task_struct list and compare with /proc |

### Tools

| Tool | Purpose |
|------|------|
| `crash` | Kernel dump analysis |
| `volatility3` | Memory forensics (Linux profile) |
| `dmesg` / `journalctl` | Kernel logs |
| `lsmod` / `/proc/modules` | List of loaded modules |
| `modinfo` | Module metadata |
| `strace` | System call tracing (user-mode perspective) |

---

## C/C++ Reverse Engineering Pattern Recognition

### Common C Patterns

| Source Pattern | Disassembly Characteristics |
|---------|-----------|
| `if-else` | `cmp` + `jcc` (conditional jump) |
| `switch-case` | Jump table (`jmp [rax*8 + table]`) or a chain of `cmp` |
| `for` loop | `cmp` + `jl/jle` + loop body + `inc/add` + `jmp` back |
| `while` loop | Condition check at the top of the loop |
| `do-while` | Condition check at the bottom of the loop |
| Function pointer call | `call rax` or `call [reg+offset]` |
| `struct` access | `[reg+fixed offset]` (e.g., `[rdi+0x10]`) |
| `malloc` + use | `call malloc` → return value stored in a register → later accesses use that register+offset |
| String comparison | `call strcmp` or `repe cmpsb` |

### C++-Specific Patterns

| Source Pattern | Disassembly Characteristics |
|---------|-----------|
| **Virtual function call** | `mov rax, [rcx]` (fetch vtable) → `call [rax+offset]` (invoke virtual function) |
| **Constructor** | Allocate memory → write the vtable pointer → initialize members |
| **Destructor** | Clean up members → may call `operator delete` |
| **this pointer** | The first argument (rcx/rdi) is the object pointer |
| **Inheritance** | The vtable contains parent-class virtual functions + subclass overrides |
| **Multiple inheritance** | The object contains multiple vtable pointers (at different offsets) |
| **RTTI** | A `type_info` pointer precedes the vtable |
| **Exception handling** | `__cxa_throw` / `_CxxThrowException` |
| **STL containers** | `std::vector`: `{begin, end, capacity}` three-pointer structure |
| **std::string** | Small String Optimization (SSO): short strings inline, long strings heap-allocated |

### vtable Reverse Engineering Method

```text
1. Find the vtable
   - Search for a contiguous array of function pointers (in .rodata or .rdata)
   - Constructors write the vtable pointer with `mov [rcx], offset vtable`

2. Determine the class hierarchy
   - The -8 offset before the vtable is usually the RTTI pointer (if not stripped)
   - Multiple vtables sharing the first few entries → inheritance relationship

3. Annotate virtual functions
   - vtable[0] is usually the destructor (or deleting destructor)
   - Annotate subsequent entries by offset: vtable[1] = func1, vtable[2] = func2...

4. Operations in IDA
   - Create a struct at the vtable address (each field is a function pointer)
   - Add comments to `call [rax+offset]` indicating which virtual function is called
```

### Structure Recovery

```text
Method 1: Infer from access patterns
  mov eax, [rdi+0x00]  → field_0: int/ptr (4/8 bytes)
  mov ecx, [rdi+0x08]  → field_8: int/ptr
  movss xmm0, [rdi+0x10] → field_10: float

Method 2: Infer from sizeof
  call malloc(0x30) → struct size 0x30 (48 bytes)
  
Method 3: Infer from the constructor
  The constructor initializes all fields → field types and offsets are clear at a glance

Method 4: Use IDA's "Create struct" feature
  Select the access pattern → Edit → Struct → Create struct from selection
```

---

## Common Compiler Signatures

| Compiler | Identifying Characteristics |
|--------|---------|
| MSVC | `_security_cookie` checks, `__fastcall` calling convention, Rich Header |
| GCC | `__stack_chk_fail`, `-fstack-protector`, `.note.GNU-stack` |
| Clang/LLVM | Similar to GCC but different optimization patterns, `__asan_*` (if sanitizer is enabled) |
| MinGW | GCC characteristics + Windows API calls |
| AOSP Clang | Android-specific `__android_log_print`, PGO markers |

### Optimization Level Identification

| Optimization Level | Characteristics |
|---------|------|
| -O0 | Lots of redundant movs, every variable on the stack, functions not inlined |
| -O1 | Basic optimizations, some variables in registers |
| -O2 | Loop unrolling, function inlining, tail-call optimization |
| -O3 / -Os | Aggressive inlining, vectorization (SIMD), code hard to read |
| PGO | Hot-path optimization, cold code split into `.text.cold` |
| LTO | Cross-module inlining, global dead code elimination |

---

## Kernel Debugging Environments

### Windows

```text
Debugger: WinDbg Preview
Connection: network debugging (recommended) or serial port

Target machine settings:
bcdedit /debug on
bcdedit /dbgsettings net hostip:192.168.x.x port:50000

Debugger connection:
WinDbg → File → Attach to Kernel → Net → Port:50000 Key:xxx

Common commands:
!analyze -v          # Automatically analyze a crash
lm                   # List loaded modules
!drvobj \Driver\xxx  # Inspect a driver object
dt nt!_DRIVER_OBJECT # Display a structure
bp module!function   # Set a breakpoint
```

### Linux

```text
Debugger: GDB + QEMU or kgdb

QEMU kernel debugging:
qemu-system-x86_64 -kernel bzImage -s -S ...
gdb vmlinux -ex "target remote :1234"

Common commands:
info threads         # Kernel threads
lx-symbols           # Load kernel symbols (requires scripts/gdb/)
p init_task          # Inspect the init process
lx-dmesg             # Kernel log
```

---

## Agent Action Anchors (Issue #65 U–AV)

Aligned with §5 of `references/nonpe-format-cookbook.md` (short table; does not replace the workflow above):

| ID | Action | Evidence |
|----|------|----------|
| AG | `DriverEntry` is short → scan non-empty `MajorFunction` slots, prioritizing DEVICE_CONTROL/CREATE | `E-driver-irp-handlers` |
| AH | Build an IOCTL control-code → handler table with METHOD_* | `E-driver-ioctl` |
| AI | Suspected BYOVD: cross-check against public vulnerable-driver lists; record name/hash/signature and call intent; **do not write exploit steps** | `E-driver-byovd` |

## Reference Resources

| Resource | Description | Link |
|------|------|------|
| VoidSec driver reverse engineering methodology | Complete Windows WDM driver analysis workflow | https://voidsec.com/windows-drivers-reverse-engineering-methodology/ |
| Elastic Rootkit series | Linux rootkit classification + detection | https://security-labs.elastic.co/security-labs/linux-rootkits-1-hooked-on-linux |
| Driver Buddy Reloaded | IDA driver analysis plugin | https://github.com/VoidSec/DriverBuddyReloaded |
| LOLDrivers | List of known vulnerable drivers | https://www.loldrivers.io/ |
| Windows Driver Samples | Microsoft's official driver samples | https://github.com/microsoft/Windows-driver-samples |
| Linux Kernel Module Programming | Kernel module development tutorial | https://sysprog21.github.io/lkmpg/ |
| Trail of Bits - Devirtualizing C++ | vtable reverse engineering method | https://blog.trailofbits.com/2017/02/13/devirtualizing-c-with-binary-ninja/ |
