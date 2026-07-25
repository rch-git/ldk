**Pod Disruption Budget (PDB)** is one of the more important conceptual topics that appears in KCNA.

### What is a Pod Disruption Budget?

A **PodDisruptionBudget** is a Kubernetes resource that limits how many pods of a replicated application can be voluntarily disrupted (taken down) at the same time.

It acts as a safety guard so that cluster maintenance (node drains, upgrades, etc.) does not take your application offline.

### Voluntary vs Involuntary Disruptions (Critical Distinction)

| Type              | Examples                                      | Does PDB protect against it? |
|-------------------|-----------------------------------------------|------------------------------|
| **Voluntary**     | `kubectl drain`, node upgrades, scaling down, deliberate pod deletion | **Yes**                     |
| **Involuntary**   | Node crash, hardware failure, OOM kill, network partition | **No**                      |

This distinction is frequently tested. PDBs only control *voluntary* disruptions.

### Key Fields You Must Remember

A PDB has three important fields:

- **`selector`** (required) — Label selector that identifies which pods the PDB applies to.
- **`minAvailable`** — Minimum number (or percentage) of pods that must remain available.
- **`maxUnavailable`** — Maximum number (or percentage) of pods that can be unavailable at once.

You can specify **only one** of `minAvailable` or `maxUnavailable`.

**Examples of values:**
- `minAvailable: 2` → At least 2 pods must stay running
- `minAvailable: "50%"` → At least 50% of pods must stay running
- `maxUnavailable: 1` → Only 1 pod can be down at a time
- `maxUnavailable: "25%"` → Up to 25% of pods can be disrupted

### How It Works (High-Level)

When someone tries to evict a pod (most commonly via `kubectl drain`), Kubernetes checks the PDB:

- If removing the pod would violate the budget → eviction is **blocked**.
- The operation waits (or fails) until the budget allows the eviction.

This is why draining a node with pods protected by a tight PDB can hang or fail.

### Typical Use Cases (Exam-Relevant)

- Protecting a Deployment or StatefulSet during node maintenance.
- Ensuring quorum for stateful applications (e.g., keep at least 2 out of 3 pods for ZooKeeper/etcd-style systems).
- Guaranteeing a minimum level of availability while the cluster is being upgraded or nodes are being replaced.

### Important Points for KCNA

- PDB is a **namespaced** resource (`policy/v1`).
- It works with controllers that manage replicas (Deployments, ReplicaSets, StatefulSets).
- It does **not** protect against node failures or crashes.
- Setting `minAvailable: 100%` or `maxUnavailable: 0` means **no voluntary disruptions are allowed** (drain will be blocked).
- PDBs are part of the broader theme of **application availability** and **safe cluster operations**.

### Quick Memory Hook for the Exam

> **PDB = “Don’t take down too many of my pods at once during planned maintenance.”**

It is the mechanism Kubernetes uses to protect application availability during *voluntary* disruptions.

That’s the complete set of knowledge expected at the KCNA level.