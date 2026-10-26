---
name: cloud-k8s
description: Use for authorized cloud, container, and Kubernetes security assessment including metadata SSRF, IAM misconfig, container escape paths, and cluster RBAC review.
---

# Cloud / Container / Kubernetes Security

## ACTION REQUIRED (execute immediately after reading)

1. `NOW`: Read `../field-journal/precedent-pentest.md` — **Cloud/K8s testing requires written authorization**
2. `NOW`: case-init + scope; clarify account boundaries and prohibit destructive operations
3. `NOW`: Confirm this is cloud metadata/container/K8s/IAM, not ordinary web scanning (the latter → `pentest-tools/`)
4. `NEXT`: tool-index; kubectl/aws/gcloud, etc. are mostly manual installations
5. `ACT`: Start from "Identity and Exposure Surface"; do not default to scanning the entire network

## Applicable Scenarios

- Cloud metadata SSRF (169.254.169.254 / IMDS)
- IAM excessive permissions, public storage buckets, misconfigured security groups
- Docker/containerd escape path assessment
- Kubernetes RBAC, Secrets, Admission, supply-chain images
- Container image vulnerabilities (can link with `supply-chain-security/`)

## Workflow

### Phase 1 — Identity and Boundaries

```text
□ Current identity: cloud AK/SK, K8s SA, node SSH?
□ Scope: single account / single cluster / single namespace
□ Network profile: authorized_target_only
```

### Phase 2 — Cloud Control Plane

```bash
# Example (replace per vendor; MUST be within authorized accounts)
aws sts get-caller-identity
aws s3 ls
# Corresponding identity commands for Azure / GCP
```

```text
□ Public buckets / misconfigured ACLs
□ Metadata: IMDSv1 vs v2; SSRF chains
□ Role assumability (PassRole) and lateral movement
```

### Phase 3 — Containers

```text
□ Whether privileged / hostPath / hostNetwork
□ capabilities (SYS_ADMIN, etc.)
□ Writable host paths → escape candidates
□ Image history and known CVEs → Trivy
```

### Phase 4 — Kubernetes

```bash
kubectl auth can-i --list
kubectl get pods,secrets,svc -A
kubectl get clusterrolebindings
```

```text
□ SA token mounts and permissions
□ Missing dangerous admission webhooks
□ etcd / dashboard exposure
□ Whether network policies default to allow
```

## Toolchain

| Tool | Purpose | Bootstrap |
|------|------|------|
| kubectl | Cluster interaction | Manual |
| trivy | Images/IaC | bootstrap `trivy` if available |
| kube-bench / kubeaudit | CIS/configuration | Manual |
| pacu / scoutsuite | Cloud auditing (authorized) | Manual |
| nuclei | Known cloud vulnerability templates | bootstrap nmap/nuclei ecosystem |

## References

- `references/k8s-cloud-checklist.md`
- CTF comparison: `../../CTF-Sandbox-Orchestrator/competition-agent-cloud/`
- `../supply-chain-security/` `../pentest-tools/`

## Routing Context

**Upstream**: MASTER R23
**Downstream**: Got a node shell → `attack-chain` / `windows-ad`; image vulnerabilities → supply-chain
**MUST NOT**: Scan other tenants of public clouds without authorization

## Task Completion Self-Check

- [ ] Was the work limited to authorized accounts/clusters?
- [ ] Do the findings include reproduction and impact?
- [ ] Were destructive operations avoided?
- [ ] Report / journal?
