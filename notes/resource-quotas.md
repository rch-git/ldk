**Resource Quotas (ResourceQuota) – KCNA Exam Focus**

A **ResourceQuota** is a namespaced object that sets **hard limits** on the *total (aggregate)* amount of resources that can be consumed inside a single namespace. It is the primary tool for preventing one team or workload from exhausting cluster resources in a multi-tenant environment.

### Core Purpose
- Enforce fair sharing of CPU, memory, storage, and object counts across namespaces.
- Protect the cluster from resource exhaustion and control-plane overload.
- All limits under `spec.hard` are **hard** — they cannot be exceeded.

### What ResourceQuota Can Limit

**1. Compute Resources (most tested)**
| Field              | Meaning |
|--------------------|---------|
| `requests.cpu` / `cpu` | Total CPU *requests* across non-terminated pods |
| `requests.memory` / `memory` | Total memory *requests* across non-terminated pods |
| `limits.cpu`       | Total CPU *limits* across non-terminated pods |
| `limits.memory`    | Total memory *limits* across non-terminated pods |

**Critical exam rule**:  
If a ResourceQuota exists for CPU or memory, **every container must specify the corresponding request (and limit if that is also quota’d)**. Missing requests/limits → pod is rejected at admission with a 403 Forbidden error.

Only **non-terminated** pods (not `Succeeded` or `Failed`) count toward the quota.

**2. Storage**
- `requests.storage` – total storage requested by PVCs
- `persistentvolumeclaims` – maximum number of PVCs
- Can be scoped by StorageClass

**3. Object Counts**
- `pods`, `services`, `services.loadbalancers`, `services.nodeports`
- `configmaps`, `secrets`, `persistentvolumeclaims`, etc.
- `count/<resource>.<group>` form for non-core resources (e.g. `count/deployments.apps`)

### Important Behaviors & QoS Interaction (Highly Tested)

ResourceQuota works closely with **Quality of Service (QoS)** classes:

- **Guaranteed**: requests == limits for every container
- **Burstable**: at least one container has requests < limits (or requests set but limits higher)
- **BestEffort**: no requests or limits set at all

**Quota Scopes** allow you to apply different limits based on QoS (and other attributes):

| Scope            | Matches |
|------------------|---------|
| `BestEffort`     | BestEffort pods only |
| `NotBestEffort`  | Guaranteed **and** Burstable pods |
| `Terminating`    | Pods with `activeDeadlineSeconds` set |
| `NotTerminating` | Pods without `activeDeadlineSeconds` |

This means you can (and often should) create separate ResourceQuotas for BestEffort vs Burstable/Guaranteed workloads.

### Key Enforcement Behaviors You Must Know
- Enforced at **admission time** only. Existing pods are never killed or resized by a quota.
- All-or-nothing: if creating a new pod would exceed *any* hard limit, the entire request is rejected.
- Controllers (Deployment, ReplicaSet, etc.) can still be created even if they would eventually exceed the quota — only the pods that breach the limit are blocked.
- When a compute quota exists, pods **must** declare requests/limits → this directly influences their QoS class (Burstable is the most common result when requests < limits).
- ResourceQuota status shows both `hard` and `used` values for monitoring.

### Relationship to LimitRange
- **LimitRange** → sets defaults, minimums, and maximums *per container/pod*.
- **ResourceQuota** → sets the *total ceiling* for the entire namespace.
- Best practice: Use LimitRange to inject default requests/limits so pods are not rejected by a ResourceQuota that requires them. This often results in Burstable QoS pods.

### Typical Example
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    pods: "20"
```

### KCNA Bottom Line – Remember These Points
1. ResourceQuota = **hard aggregate limits per namespace**.
2. When compute quotas exist, pods **must** specify requests/limits (otherwise rejected).
3. This requirement strongly influences QoS class — most real-world pods end up **Burstable**.
4. You can scope quotas by QoS (`BestEffort` vs `NotBestEffort`) so Burstable/Guaranteed workloads can have different limits from BestEffort ones.
5. Only non-terminated pods count; existing pods are never forcibly terminated by the quota.
6. Complements LimitRange (per-pod defaults vs namespace totals).

These interactions between ResourceQuota, requests/limits, and QoS classes (especially Burstable) are frequently tested on the KCNA exam.