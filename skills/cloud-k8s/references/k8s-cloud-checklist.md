# Cloud / K8s Checklist (Condensed)

## IMDS
- [ ] Can SSRF reach 169.254.169.254
- [ ] Is IMDSv2 enforced
- [ ] Permission surface of the returned IAM role

## K8s High-Risk
- [ ] Excessive cluster-admin bindings
- [ ] Secrets in plaintext environment variables
- [ ] privileged + hostPID/hostPath combination
- [ ] Anonymous auth / insecure apiserver port

## Containers
- [ ] Running as root
- [ ] Able to load kernel modules / docker.sock mounted
