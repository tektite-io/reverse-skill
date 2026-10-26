# [Seed] Web API Unauthorized Access + IDOR

## Scenario Classification
Penetration Testing

## Goal Overview
Perform black-box testing on a web application's REST API and discover unauthorized access and IDOR vulnerabilities.

## Complete Execution Chain

1. Information Gathering: Nmap scan → discover port 443 running Nginx + backend API.
2. Directory Discovery: FFUF brute force → discover the `/api/v1/` path.
3. API Enumeration: Access `/api/v1/docs` → discover exposed Swagger documentation.
4. Authentication Analysis: Register two test accounts, A and B.
5. Test IDOR: Use account A's token to access account B's resources → success (horizontal privilege escalation).
6. Test Unauthorized Access: Remove the Authorization header → some endpoints still return data (unauthorized access).
7. Verify Impact: Confirm that personal information of any user (name, email, phone number) can be read.
8. Evidence Collection: Save request/response screenshots, anonymize them, and compile a report.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| FFUF blocked by WAF | Request rate too high, triggering rate limiting | Reduce rate `-rate 10`, add `-H "User-Agent: Mozilla/5.0..."` | 10min |
| Swagger documentation 404 | Path is not the standard /swagger | Try `/api/v1/docs`, `/api-docs`, `/openapi.json` | 5min |
| IDOR test uncertain if successful | Returned data has no obvious user identifier | Compare responses from the two accounts and find the `user_id` field difference | 15min |
| Report rejected by SRC | Only submitted screenshots without complete reproduction steps | Add curl commands + full request/response | 20min |

## Toolchain Findings

- FFUF is faster than Gobuster, but the rate must be controlled to avoid being blocked.
- Exposed Swagger/OpenAPI documentation is the fastest way to enumerate APIs.
- IDOR testing must use two of your own accounts to test each other; do not touch other people's data.
- SRC reports must include reproducible curl commands, not just screenshots.

## Key Code/Commands

```bash
# Directory discovery
ffuf -u https://target.example.com/api/v1/FUZZ -w /path/to/SecLists/Discovery/Web-Content/api/api-endpoints.txt -rate 10

# IDOR test
# Use account A's token to access account B's resources
curl -H "Authorization: Bearer <token_A>" https://target.example.com/api/v1/users/USER_B_ID

# Unauthorized access test
curl https://target.example.com/api/v1/users/USER_B_ID
# If it returns 200 + data → unauthorized access
```

## Suggestions for This Package

- pentest-tools should include a dedicated checklist for "API penetration testing".
- src-hunter's IDOR playbook is very useful, but lacks guidance on "how to determine the scope of IDOR impact".

## Reusable Patterns/Script Snippets

**Three-step API unauthorized access testing method**:
```text
1. Normal request (with token) → record normal response
2. Remove token → check if data is still returned (unauthorized)
3. Switch to another user's token → check if access is possible (privilege escalation)
```

**IDOR quick verification**:
```text
1. Register two accounts, A and B
2. Obtain A's resource ID and B's resource ID
3. Request B's resource ID using A's token
4. If B's data is returned → IDOR confirmed
```

## Evolution Actions
- [ ] No need to update routing matrix
- [ ] No need to update bootstrap-manifest
- [ ] No need to update sub-skill documentation

## Environment Information
- OS: Windows (local) → target Linux server
- Tool versions: FFUF 2.x, curl, Burp Suite
- Target platform: Web API (REST, JSON)

## Anonymization Requirements
This entry is seed data, written based on public technical patterns, and does not involve real targets.

---
<!-- [Community Contribution] Seed data, no PR required -->
