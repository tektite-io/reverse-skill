# [Seed] PCAP Custom Binary Protocol Reverse Engineering

## Scenario Classification
Packet Capture Analysis / Protocol Reverse Engineering

## Goal Overview
An IoT device or desktop client uses a custom binary TCP protocol (not HTTP). A PCAP capture is available; recover the frame structure, field semantics, and encryption layer (if any), and write a local client/server reproduction.

## Complete Execution Chain

1. Open the PCAP in Wireshark and start with basic statistics.
   - `Statistics → Conversations` to view IP/port pairs.
   - `Statistics → I/O Graphs` to view data cadence.
2. Identify the true application-layer stream (strip away standard layers such as TLS).
3. On a given TCP stream → `Follow → TCP Stream` → switch to RAW mode → export.
4. Binary-level observation: are the first few bytes of each frame a fixed magic / length field?
   ```bash
   xxd dump.bin | head -20
   ```
5. Look for patterns in hex view: fixed header, length, TLV, CRC.
6. Write a Python parser (struct + scapy) to decode frame by frame.
7. Cross-check protocol fields by decompiling the binary (in IDA / Ghidra, inspect the structs around send/recv).
8. Verify: start your own client and send a frame → the server response matches.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Wireshark does not recognize the protocol and only shows "Data" | It is a private protocol with no dissector | Write a Wireshark Lua dissector or analyze offline directly in Python | 30min |
| Looks irregular; every frame differs | Compression or encryption layer present | Use entropy analysis (`ent dump.bin`) to determine whether it is encrypted; find the nonce/IV field | 1h |
| Length field calculation is wrong | Length may be little-endian / big-endian / include or exclude itself | Collect several frames of different lengths and solve a system of equations | 40min |
| TLS captured but cannot decrypt | Client does not write SSLKEYLOGFILE | Hook at the client process layer (Frida on ssl_read/ssl_write) to capture plaintext | 1.5h |
| Data is correct but server does not respond | Protocol uses an incrementing seq / nonce; replays are rejected | Figure out how seq is computed (usually a hash of the previous frame or an incrementing counter) | 50min |

## Toolchain Findings

- A **Wireshark Lua Dissector** can turn a private protocol into a Wireshark visualization in under 100 lines.
- With **scapy**, just define a `Packet` subclass when writing a Python parser.
- **Kaitai Struct** describes protocol structures in YAML and can generate parsers for multiple languages (Python/Java/C++/JS); suitable for long-term reuse.
- **NetworkMiner** is better suited than Wireshark for post-incident forensics (automatically reassembles files and identifies credentials).
- **ent / binwalk -E** for entropy: >7.5 almost certainly means encrypted.

## Key Code/Commands

scapy custom protocol example (TLV):

```python
from scapy.all import *

class MyMsg(Packet):
    name = "MyProto"
    fields_desc = [
        StrFixedLenField("magic", b"\xab\xcd", 2),
        ByteField("version", 1),
        ByteField("type", 0),
        LenField("length", None, fmt="H"),     # H = uint16 BE
        XIntField("seq", 0),
        StrLenField("payload", "", length_from=lambda p: p.length - 8),
        XShortField("crc", 0),
    ]

# Parse PCAP
pkts = rdpcap('dump.pcap')
for p in pkts:
    if TCP in p and p[TCP].dport == 9527 and p.payload:
        msg = MyMsg(bytes(p[TCP].payload))
        msg.show()
```

Kaitai Struct YAML (preferred for long-term projects):

```yaml
# myproto.ksy
meta:
  id: myproto
  endian: be
seq:
  - id: magic
    contents: [0xab, 0xcd]
  - id: version
    type: u1
  - id: type
    type: u1
  - id: length
    type: u2
  - id: seq_no
    type: u4
  - id: payload
    size: length - 8
  - id: crc
    type: u2
```

Entropy analysis:

```bash
binwalk -E dump.bin             # entropy graph
ent dump.bin                    # numeric value
```

## Suggestions for This Package

- Add a "4-step method for custom protocol reverse engineering" chapter to `reverse-engineering/platforms.md`.
- Add a `reverse-engineering/references/kaitai-cheatsheet.md` quick reference.
- Add scapy (pip) and binwalk to the bootstrap manifest.

## Reusable Patterns/Script Snippets

**4-step method for custom protocol reverse engineering**:

```text
1. Watch the rhythm (I/O graph + Conversations to find session boundaries)
2. Find frame boundaries (magic / length / terminator)
3. Break down fields (fixed header, length, payload, checksum)
4. Verify encryption (entropy + find nonce + reverse the send function in the binary)
```

**Tip for finding frame length**:

Export all PSH packets in the same stream → look at the total length of each TCP segment; see whether a length field (try positions i, i+1, i+2) can derive the segment length.

## Evolution Actions
- [ ] Add a protocol reverse engineering chapter to reverse-engineering/platforms.md
- [ ] Add scapy / binwalk to bootstrap-manifest
- [ ] Add a Kaitai Struct quick reference

## Environment Information
- Kali / Ubuntu, Wireshark 4.x, Python 3.10+, scapy 2.5
- Target protocol: custom TCP binary (with TLV / length prefix)
- Encryption layer: depends on the situation (commonly AES-CTR / ChaCha20)

## Anonymization Requirements
This entry is seed data, written based on public protocol reverse engineering methods, and does not involve real products.
