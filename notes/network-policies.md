**Network Policies** are one of the most important security concepts on the KCNA.

### What They Are
NetworkPolicy is a Kubernetes resource that controls **pod-to-pod** (and pod-to-external) traffic at **Layer 3/4** (IP address + port). It works with TCP, UDP, and SCTP.

It is essentially a **firewall for Pods**. You define rules based on labels that say which pods are allowed to talk to which other pods (or namespaces or IP blocks).

### Default Behavior (Critical for KCNA)
- By default, **all traffic is allowed**. Pods are *non-isolated*.
- The moment you create a NetworkPolicy that selects a pod and includes `Ingress` or `Egress` in `policyTypes`, that pod becomes **isolated** for that direction.
- Once isolated, **only** the traffic you explicitly allow is permitted (whitelist model). There is no “deny” rule — only allow rules.
- Policies are **additive**. If multiple policies select the same pod, the allowed traffic is the union of all of them.

### How They Work
A NetworkPolicy has three main parts:

1. **`podSelector`** — which pods this policy applies to (empty `{}` = all pods in the namespace).
2. **`policyTypes`** — `Ingress`, `Egress`, or both.
3. **Rules**:
   - `ingress` → who is allowed to *talk to* these pods
   - `egress` → who these pods are allowed to *talk to*

You can select sources/destinations by:
- `podSelector` (labels)
- `namespaceSelector` (labels on namespaces)
- `ipBlock` (CIDR ranges)

**Important rule**: For traffic between two pods to be allowed, *both* the source pod’s egress rule **and** the destination pod’s ingress rule must permit it.

### Network Policy vs Ingress (Very Common Exam Distinction)

| Aspect              | NetworkPolicy                          | Ingress                              |
|---------------------|----------------------------------------|--------------------------------------|
| Direction           | East-West (pod ↔ pod) + limited external | North-South (external → cluster)    |
| Layer               | L3/L4 (IP + port)                      | L7 (HTTP/HTTPS, host/path)          |
| Purpose             | Security / microsegmentation           | Routing external traffic to Services |
| Enforcement         | CNI plugin                             | Ingress Controller                  |
| Scope               | Internal cluster traffic               | External access                     |

They solve completely different problems.

### Interaction with CNI (Extremely Important)
Kubernetes itself does **not** enforce Network Policies.

- The **CNI plugin** is responsible for actually implementing the rules (usually by programming iptables, nftables, or eBPF).
- If your CNI does **not** support NetworkPolicy, creating NetworkPolicy objects does **nothing**.
- Common CNIs that support them: **Calico**, **Cilium**, **Weave Net**, and newer versions of Amazon VPC CNI (when enabled).
- Basic Flannel (without a policy controller) traditionally did **not** enforce them.

This is why you often hear “you need a CNI that supports Network Policies.”

### Salient KCNA Points to Remember
- Default = allow all. NetworkPolicy = isolate + whitelist.
- Network Policies are a core **security** control (pod-level network segmentation / zero-trust).
- They are **not** the same as Ingress.
- Enforcement depends entirely on the CNI.
- You cannot target Services by name — only by pod labels, namespace labels, or IP blocks.
- Traffic to/from the node itself is always allowed.
- DNS is frequently broken by overly strict egress policies (you must explicitly allow CoreDNS).

For KCNA, focus on the high-level understanding: purpose, default behavior, difference from Ingress, and the dependency on CNI support. You will not be asked to write complex YAML, but you need to know what the object does and how it fits into the networking + security model.