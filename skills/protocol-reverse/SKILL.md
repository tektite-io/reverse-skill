---
name: protocol-reverse
description: Use for authorized reverse engineering of custom binary protocols, Protobuf/gRPC, WebSocket frames, and PCAP-driven protocol recovery.
---

# Protocol Reverse Engineering

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-reverse.md` — confirm authorization and routine operation boundaries
2. `NOW`: Confirm whether the task is **protocol/traffic/serialization format** reverse engineering (not pure Web parameter signing → switch to `js-reverse/`)
3. `NOW`: If there is target network interaction → `../scripts/case-init.ps1` to complete scope; if `auth` is not granted, ACT against the target is prohibited
4. `NEXT`: Read `../tool-index.md`; missing tools bootstrap (tshark/wireshark etc. may require manual installation)
5. `ACT`: Enter Workflow Phase 1 and produce a frame layout or message dictionary draft

## Applicable Scenarios

- Custom TCP/UDP binary protocols
- Protobuf / gRPC / FlatBuffers / MessagePack
- WebSocket / MQTT / proprietary RPC
- PCAP / PCAPNG field and state machine recovery
- Client-server validation, sequence numbers, encrypted frame headers

## Not Covered by This Skill

| Situation | Where to Go |
|------|------|
| HTTP parameter signing / JS encryption only | `js-reverse/` |
| TLS certificate issues only | `pentest-tools/` or browser proxy |
| Deep protocol stack analysis + emulation in firmware | `firmware-pentest/` then return to this skill |

## Workflow

### Phase 1 — Collection and Triage

```text
□ Obtain samples: PCAP / proxy export / client logs / binary
□ Mark direction: C→S / S→C; whether there is a handshake, heartbeat, reconnect
□ Fixed header? Magic number? Length field? TLV? Fixed length?
□ Compressed (zlib/gzip/lz4) or encrypted (AES/ChaCha within frames)?
□ tshark -r cap.pcap -T fields -e frame.number -e ip.src -e tcp.payload
```

### Phase 2 — Frame Layout Recovery

```text
□ Align multiple messages of the same type; find invariant bytes / auto-increment sequence numbers
□ Length field: big-endian/little-endian, includes header/does not include header
□ Checksum: CRC16/32, checksum, HMAC position
□ Draw the state machine: Connect → Auth → Ready → Request/Response → Close
□ Tools: Wireshark custom dissector draft / ImHex / 010 Editor templates / Kaitai Struct
```

### Phase 3 — Serialization and Encryption

```text
□ Protobuf: .proto recovery (blackboxprotobuf / pbtk / protoc --decode_raw)
□ gRPC: HTTP/2 headers + protobuf body
□ Encryption: find key derivation (client so/dll/JS) → coordinate with ida-reverse / js-reverse / apk-reverse
□ Replay: only within authorized scope; harmless fields first, then sensitive operations
```

### Phase 4 — Artifacts

```text
MUST produce:
- Message type table (name / opcode / fields)
- At least 1 reproducible decoding command or script
- Evidence: raw hex excerpt + decoding result (redacted)
```

## Toolchain

| Tool | Required | Purpose | Bootstrap |
|------|------|------|------|
| tshark / Wireshark | Strongly recommended | PCAP parsing | Manual / winget |
| Python3 | Yes | Decoding scripts | System |
| blackboxprotobuf | Optional | Unknown protobuf | pip |
| ImHex / 010 | Optional | Structure templates | Manual |
| IDA / r2 / Ghidra | As needed | Client serialization functions | See corresponding skill |

## References

- `references/protocol-workflow.md` — Frame layout and Protobuf quick reference
- Related: `../ida-reverse/` `../js-reverse/` `../firmware-pentest/` `../pentest-tools/`

## Routing Context

**Upstream**: `MASTER-ROUTING` R21 · `routing.md`  
**Downstream**: Need client algorithm → `ida-reverse`/`js-reverse`; need replay exploitation → `pentest-tools`/`api-security`  
**Peer**: `malware-analysis` (C2 protocols), `digital-forensics` (traffic forensics)

## Task Completion Self-Check

- [ ] Was the message layout or state machine recovered (rather than just pasting hex)?
- [ ] Is there a reproducible decoding command?
- [ ] Was scope / redaction observed?
- [ ] Was the field-journal / report Checklist written back?
