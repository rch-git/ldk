**`kubectl explain`** and **`kubectl describe`** serve very different purposes. From a KCNA perspective, you mainly need to know *when* and *why* you use each one.

### kubectl explain
- **Purpose**: Shows the **schema / documentation** of a Kubernetes API resource (or a nested field).
- It answers: “What fields does this resource have, what type are they, and what do they mean?”
- Works on **resource types**, not specific instances.
- Pulls information from the OpenAPI schema of the API server (or cached local schema).

**Examples**:
```bash
kubectl explain pods
kubectl explain pods.spec
kubectl explain pods.spec.containers
kubectl explain deployment.spec.replicas
kubectl explain pods --recursive
```

**Key characteristics for KCNA**:
- Useful for learning and writing manifests.
- Does **not** show the current state of any live object.
- Can be used even when you just want to understand the structure of a resource.

### kubectl describe
- **Purpose**: Shows a **human-readable detailed view** of a **specific live resource** (or multiple resources) that currently exists in the cluster.
- It answers: “What is the current state of this particular object, and what events have happened to it?”
- Includes configuration summary + status + events (very useful for troubleshooting).

**Examples**:
```bash
kubectl describe pod nginx-7d8b49557c-xyz12
kubectl describe node worker-1
kubectl describe deployment my-app
kubectl describe pods -l app=nginx
```

**Key characteristics for KCNA**:
- Shows real cluster state (status, conditions, events, assigned node, etc.).
- Primary tool for basic troubleshooting (especially “why is this Pod pending / crashing?”).
- Output is not pure YAML/JSON — it’s formatted for readability.

### Quick Comparison (KCNA-relevant)

| Aspect                  | `kubectl explain`                          | `kubectl describe`                          |
|-------------------------|--------------------------------------------|---------------------------------------------|
| **What it operates on** | Resource **type** / fields                 | Specific **instance(s)** of a resource      |
| **Main purpose**        | Documentation / schema                     | Current state + events                      |
| **Shows live data?**    | No                                         | Yes                                         |
| **Shows events?**       | No                                         | Yes (very useful)                           |
| **Typical use**         | Learning fields, writing YAML              | Debugging / inspecting running objects      |
| **Example question**    | “What does `spec.replicas` mean?”          | “Why is this Pod not starting?”             |

### KCNA Takeaway
- Use **`explain`** when you need to understand the *structure* of a resource.
- Use **`describe`** when you need to inspect the *current state and history* of a concrete object in the cluster.

They are complementary — many people use both during the same troubleshooting session (`explain` to understand a field, then `describe` to see what value it actually has and what events occurred).