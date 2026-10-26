# CTF Resource Quick Reference

> Curated from [awesome-ctf-resources](https://github.com/devploit/awesome-ctf-resources) and [awesome-ctf](https://github.com/apsdehal/awesome-ctf)
> Organized by CTF challenge type; only the most practical tools and resources are kept.

---

## General Frameworks

| Tool | Purpose | Link |
|------|------|------|
| Pwntools | Exploit development framework (Python) | https://github.com/Gallopsled/pwntools |
| ctf-tools | One-click CTF toolset installer | https://github.com/zardus/ctf-tools |
| Ciphey | AI automatic decryption | https://github.com/ciphey/ciphey |
| CyberChef | Online encoding/decoding and encryption/decryption | https://gchq.github.io/CyberChef/ |

---

## Web Category

### Tools
| Tool | Purpose |
|------|------|
| Burp Suite | HTTP interception/replay/scanning |
| SQLMap | SQL injection |
| XSStrike | XSS detection |
| dirsearch | Directory discovery |
| JWT_Tool | JWT attacks |
| SSRFmap | SSRF exploitation |

### Common Topics
- SQL injection (union-based/blind/time-based blind/stacked)
- XSS (reflected/stored/DOM)
- SSRF (internal network probing/cloud metadata)
- File upload (bypassing extension/MIME/content detection)
- Deserialization (PHP/Java/Python pickle)
- Template injection (SSTI)
- JWT forgery/key confusion

### Payload References
- https://github.com/swisskyrepo/PayloadsAllTheThings
- https://book.hacktricks.wiki/

---

## Reverse Engineering Category

### Tools
| Tool | Purpose |
|------|------|
| IDA Pro / Ghidra | Decompilation |
| radare2 / r2 | CLI analysis |
| angr | Symbolic execution |
| Frida | Dynamic hooking |
| GDB + pwndbg | Debugging |
| uncompyle6 | Python decompilation |
| jadx | Android decompilation |
| dnSpy | .NET decompilation |

### Common Topics
- Algorithm recovery (encryption/encoding/custom)
- Anti-debugging/anti-VM bypass
- Packers/obfuscation (UPX/VMProtect/OLLVM)
- Symbolic execution constraint solving
- Dynamic hooking to bypass checks
- Go/Rust reversing (symbol recovery)

---

## Pwn Category

### Tools
| Tool | Purpose |
|------|------|
| Pwntools | Exploit development |
| GDB + pwndbg/GEF | Debugging |
| ROPgadget | ROP chain construction |
| one_gadget | libc one-shot |
| checksec | Protection detection |
| LibcSearcher | libc version identification |

### Common Topics
- Stack overflow (ret2text/ret2libc/ret2shellcode/ROP)
- Heap exploitation (UAF/double free/tcache/fastbin)
- Format string (arbitrary read/write)
- Integer overflow
- Kernel pwn (privilege escalation/race condition)
- Sandbox escape (seccomp bypass)

### Common Payload Patterns
```python
# ret2libc template
from pwn import *
elf = ELF('./vuln')
libc = ELF('./libc.so.6')
p = process('./vuln')
# leak libc base → calculate system/binsh → overwrite ret
```

---

## Crypto Category

### Tools
| Tool | Purpose |
|------|------|
| SageMath | Mathematical computation |
| RsaCtfTool | Automated RSA attacks |
| hashcat/john | Hash cracking |
| CyberChef | Encoding/decoding |
| z3 (SMT solver) | Constraint solving |

### Common Topics
- RSA (small public exponent/common modulus/Wiener/Coppersmith)
- AES (ECB/CBC padding oracle/bit flipping)
- Classical ciphers (Caesar/Vigenere/substitution)
- Hash length extension attacks
- Elliptic curves (ECDSA nonce reuse)
- Lattice cryptography (LLL/CVP)

---

## Forensics Category

### Tools
| Tool | Purpose |
|------|------|
| Volatility | Memory forensics |
| Autopsy/Sleuth Kit | Disk forensics |
| Wireshark | Traffic analysis |
| binwalk | Firmware/file extraction |
| foremost | File recovery |
| exiftool | Metadata extraction |

### Common Topics
- Memory dump analysis (processes/passwords/malicious code)
- PCAP traffic analysis (HTTP/DNS/TCP reassembly)
- Filesystem analysis (deleted file recovery/hidden partitions)
- Log analysis (web logs/system logs)
- Disk image analysis

---

## Misc/Stego Category

### Tools
| Tool | Purpose |
|------|------|
| StegSolve | Image steganography analysis |
| zsteg | PNG/BMP steganography |
| steghide | JPEG steganography |
| Audacity | Audio analysis |
| strings/xxd | Basic analysis |
| file/binwalk | File type identification |

### Common Topics
- LSB steganography (image least significant bits)
- File header repair/concatenation
- QR codes/barcodes
- Audio spectrogram steganography
- ZIP pseudo-encryption/known-plaintext attacks
- Encoding identification (Base64/Hex/Morse/Braille)

---

## Online Platforms

| Platform | Features | Link |
|------|------|------|
| CTFTime | Event calendar + writeups | https://ctftime.org/ |
| HackTheBox | Hands-on target machines | https://www.hackthebox.com/ |
| TryHackMe | Guided learning | https://tryhackme.com/ |
| PicoCTF | Beginner-friendly | https://picoctf.org/ |
| pwnable.kr | Pwn-focused | http://pwnable.kr/ |
| cryptopals | Crypto-focused | https://cryptopals.com/ |
| OverTheWire | War series challenges | https://overthewire.org/ |
| Root-Me | General challenges | https://www.root-me.org/ |

---

## Writeup Resources

| Resource | Link |
|------|------|
| CTFTime Writeups | https://ctftime.org/writeups |
| 0xdf hacks stuff | https://0xdf.gitlab.io/ |
| LiveOverflow (YouTube) | https://www.youtube.com/c/LiveOverflow |
| John Hammond (YouTube) | https://www.youtube.com/c/JohnHammond010 |
| IppSec (HTB walkthrough) | https://www.youtube.com/c/ippsec |
