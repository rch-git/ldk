**Pod Security Admission (PSA)** is a high-priority topic for the KCNA exam. It is frequently tested under Kubernetes security fundamentals.

### Core Concept
**Pod Security Admission** is the built-in Kubernetes **admission controller** (stable since v1.25) that enforces the **Pod Security Standards (PSS)**.

It replaced the old **PodSecurityPolicy (PSP)** mechanism. PSP was deprecated in v1.21 and completely removed in v1.25. You should know that PSA is the modern, recommended replacement.

PSA evaluates Pods (and related workload resources in audit/warn modes) against one of three predefined security profiles and decides whether to allow or reject them based on the configuration of the **namespace**.

### The Three Pod Security Standards (Profiles)
These are the most important items to memorize for the exam:

| Level          | Description                                                                 | Typical Use Case                          | Restrictiveness |
|----------------|-----------------------------------------------------------------------------|-------------------------------------------|-----------------|
| **Privileged** | Completely unrestricted. Allows known privilege escalations and full host access. | System / infrastructure pods managed by highly trusted users | Lowest (none)  |
| **Baseline**   | Minimally restrictive. Prevents known privilege escalations while allowing most default configurations. | Majority of applications and developers   | Medium         |
| **Restricted** | Heavily restricted. Follows current Pod hardening best practices. Builds on Baseline + additional strict controls. | High-security / multi-tenant workloads    | Highest        |

**Key characteristics to remember**:
- The levels are **cumulative** in restrictiveness: Restricted ⊃ Baseline ⊃ Privileged.
- **Privileged** = no restrictions at all.
- **Baseline** = blocks the most common dangerous settings (e.g., privileged containers, hostNetwork/hostPID/hostIPC, hostPath volumes, dangerous capabilities, etc.).
- **Restricted** = Baseline + forces non-root, drops all capabilities except `NET_BIND_SERVICE`, limits volume types, requires seccomp, disallows privilege escalation, etc.

### How Configuration Works (Namespace Labels)
PSA is configured **per namespace** using labels (this is the primary way you interact with it).

**Label format**:
```
pod-security.kubernetes.io/<MODE>: <LEVEL>
```

**Modes** (very important for the exam):

| Mode       | Behavior                                                                 | Effect on Pod Creation |
|------------|--------------------------------------------------------------------------|------------------------|
| **enforce** | Policy violations cause the Pod to be **rejected**                      | Hard failure          |
| **audit**   | Violations are allowed but recorded as **audit annotations** in the audit log | Soft (logging only)   |
| **warn**    | Violations are allowed but the user receives a **warning** message      | Soft (user warning)   |

You can set different levels for different modes on the same namespace. This is a common and exam-relevant pattern.

**Example** (very typical real-world and exam-style configuration):
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-app
  labels:
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

- Pods that violate **baseline** → rejected.
- Pods that violate **restricted** but satisfy baseline → allowed, but produce a warning + audit log entry.

Optional version pins also exist:
```
pod-security.kubernetes.io/enforce-version: v1.29   # or "latest"
```

### Important Exam Points to Remember
- PSA is a **validating** admission controller — it does **not** mutate Pods.
- Enforcement is **namespace-scoped** (not cluster-wide by default, although cluster-wide defaults can be configured on the admission controller itself).
- **Workload resources** (Deployments, StatefulSets, etc.):
  - `audit` and `warn` modes apply to the pod template.
  - `enforce` mode only applies to the actual Pod objects that get created.
- You can mix modes and levels (this is intentional for gradual hardening).
- Exemptions exist (by username, RuntimeClass, or namespace) but are configured at the admission controller level and are secondary knowledge for KCNA.

### Quick Mental Model for the Exam
1. Three profiles: Privileged (open) → Baseline (sensible defaults) → Restricted (hardened).
2. Applied via **namespace labels**.
3. Three modes: `enforce` (reject), `audit` (log), `warn` (warn user).
4. Replaces the old PodSecurityPolicy.

Focus on knowing the **names of the three levels**, what each roughly means, the three modes, and that configuration happens through **namespace labels** of the form `pod-security.kubernetes.io/<mode>: <level>`. That covers the vast majority of KCNA questions on this topic.