# Attack Chain Playbook Quick Reference

> Select the corresponding playbook based on the target type. Each playbook defines the standard path from initial access to goal achievement.

---

## Playbook 1: External Web Application → Domain Controller

```
1. Subdomain enumeration + port scanning
2. Web fingerprinting → Identify known vulnerable components
3. Exploit vulnerabilities to gain Webshell / RCE
4. Internal network information gathering (ipconfig/ifconfig, arp, net user)
5. Set up tunnels (frp/chisel/ssh)
6. Internal network scanning (live hosts, open ports)
7. Credential acquisition (mimikatz/hashdump/config files)
8. Lateral movement (PTH/WMI/PsExec)
9. Domain information gathering (BloodHound)
10. Domain privilege escalation (Kerberoasting/DCSync/Constrained Delegation)
11. Obtain domain controller privileges
```

**Key Toolchain**: subfinder → httpx → nuclei → sqlmap/sstimap → frp → nmap → mimikatz → crackmapexec → bloodhound → certipy

---

## Playbook 2: Phishing → Internal Network Penetration

```
1. Target employee information gathering (LinkedIn/Maimai)
2. Construct phishing emails (spoofed sender/legitimate subject)
3. Craft payloads (macro documents/LNK/ISO/HTML smuggling)
4. Send phishing emails
5. Wait for beacon (C2 beacon)
6. Local information gathering + privilege escalation
7. Credential extraction
8. Lateral movement
9. Persistence
10. Goal achieved
```

**Key Toolchain**: theHarvester → gophish → msfvenom/cobalt-strike → mimikatz → bloodhound

---

## Playbook 3: Close-Access Penetration → Internal Network

```
1. Physical reconnaissance (WiFi signals, access control types, USB ports)
2. WiFi attacks (Fluxion rogue AP / WPA cracking)
   or BadUSB injection (Rubber Ducky keyboard injection)
   or Network injection (Raspberry Pi / LAN Turtle)
3. Obtain internal network access point
4. Internal network scanning
5. Subsequent steps are the same as Steps 5-11 in Playbook 1
```

**Key Toolchain**: fluxion/aircrack-ng → rubber-ducky → frp → nmap → crackmapexec

---

## Playbook 4: Cloud Environment Penetration

```
1. Cloud asset discovery (subdomain → CNAME → cloud provider)
2. Bucket enumeration (S3/OSS/Blob public access)
3. SSRF → Cloud metadata (169.254.169.254)
4. Obtain temporary credentials (AK/SK/Token)
5. Cloud API enumeration (IAM/EC2/Lambda/RDS)
6. Privilege escalation (PassRole/AssumeRole)
7. Lateral movement (cross-account/cross-region)
8. Data acquisition
```

**Key Toolchain**: subfinder → nuclei(ssrf) → aws-cli → pacu → ScoutSuite

---

## Playbook 5: Bug Bounty / SRC Rapid Initial Access

```
1. Asset collection (subdomains + ports + JS files)
2. Fingerprinting → Rapid validation of known vulnerabilities (nuclei)
3. Parameter discovery (arjun/paramspider)
4. Test by category:
   - IDOR/Unauthorized access (modify ID/modify role)
   - SSRF (internal network probing/cloud metadata)
   - SQL injection (sqlmap)
   - XSS (xsstrike)
   - File upload (bypass detection)
   - Logic vulnerabilities (payment/verification code/password reset)
5. Write PoC + submit report
```

**Key Toolchain**: subfinder → httpx → nuclei → arjun → sqlmap → xsstrike → burpsuite

---

## Playbook 6: AD CS Certificate Attack

```
1. Discover AD CS services (certipy find)
2. Identify vulnerable templates (ESC1-ESC8)
3. Request malicious certificate
4. Authenticate as target user using the certificate
5. Obtain NTLM Hash or TGT
6. DCSync to export all credentials
```

**Key Toolchain**: certipy → rubeus → mimikatz → secretsdump

---

## General Decision Matrix

| Current State | Next Priority |
|---------|-------------|
| Only target domain | Subdomain enumeration → Port scanning → Web fingerprinting |
| Web vulnerability found | Obtain shell → Internal network information gathering |
| Low-privilege shell | Privilege escalation → Credential extraction |
| Have an internal machine | Set up tunnel → Internal network scanning → Lateral movement |
| Have domain user credentials | BloodHound → Find attack path |
| Have domain admin Hash | DCSync → Golden Ticket |
| Have cloud AK/SK | Enumerate permissions → Privilege escalation → Data acquisition |
| Phishing beacon established | Local privilege escalation → Credentials → Lateral movement |
| Close-access connection | Internal network scanning → Same as above |
