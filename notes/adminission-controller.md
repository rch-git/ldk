**Admission Controllers** in Kubernetes are plugins (pieces of code) that intercept API requests to the Kubernetes API server *after* authentication and authorization but *before* the object is persisted to etcd. They act as a final gatekeeper: they can modify (mutate) the object, validate it against policies, or reject the request.

They apply to create, update, delete, and certain custom verbs. They do **not** apply to pure read operations (`get`, `list`, `watch`).

### Lifecycle of a Request

A typical mutating/creating request flows like this through the API server:

1. **Client → API Server**  
   Request arrives (e.g., `kubectl apply`, client library, or controller).

2. **Authentication**  
   “Who are you?” (certificates, bearer tokens, service accounts, etc.).

3. **Authorization**  
   “Are you allowed to do this?” (usually RBAC).

4. **Admission Control** (the focus of this topic)  
   - **Mutating phase** runs first.  
   - API server performs its own schema validation + defaulting.  
   - **Validating phase** runs next.  

5. **Persistence**  
   If everything passes, the object is written to etcd.

6. **Response** returned to the client.

If *any* admission controller rejects the request, the entire request fails immediately.

### What Tasks Do Admission Controllers Perform?

Admission controllers operate in two ordered phases:

| Phase | Type | What it can do | Examples of tasks |
|-------|------|----------------|-------------------|
| **1. Mutating** | Can change the object | Inject defaults, add labels/annotations, inject sidecars, set resource requests/limits, add tolerations, set default StorageClass or IngressClass, create related objects (e.g., ServiceAccount token secrets) | `LimitRanger` (adds default resource requests/limits), `ServiceAccount` (auto-mounts token), `DefaultStorageClass`, `DefaultIngressClass`, `MutatingAdmissionWebhook` |
| **2. Validating** | Cannot change the object | Accept or reject based on policy | `ResourceQuota` (enforce quotas), `NamespaceLifecycle` (prevent deletion of system namespaces, block creation in terminating namespaces), `PodSecurity` (enforce Pod Security Standards), `ValidatingAdmissionWebhook`, `ValidatingAdmissionPolicy` (CEL-based) |

Some controllers are both mutating *and* validating (e.g., `LimitRanger`, `Priority`).

Additional responsibilities:
- Enforce security and governance policies without requiring changes to every client.
- Perform side effects (e.g., updating quota usage counters) — these must be carefully designed because later controllers might still reject the request.
- Support dry-run requests (side effects should be skipped on dry-run).

### Where Does the Controller Live?

- **Built-in admission controllers** live *inside* the `kube-apiserver` process itself. They are compiled into the API server binary and configured via flags (`--enable-admission-plugins` / `--disable-admission-plugins`).
- **Dynamic admission controllers** (webhooks) are external HTTP services. The API server calls them via `MutatingWebhookConfiguration` or `ValidatingWebhookConfiguration` objects. The webhook code itself usually runs as a Deployment + Service inside the cluster (or externally).

### KCNA-Relevant Points

KCNA focuses on foundational understanding rather than deep configuration or writing custom controllers. Key exam-relevant facts:

- **Purpose**: Enforce cluster policies, set defaults, and provide security/governance after authn/authz but before etcd.
- **Two phases** (order is fixed and important):
  1. Mutating (can change the object)
  2. Validating (accept/reject only)
- **Built-in vs Dynamic**:
  - Built-in = compiled into API server (enabled/disabled by flags).
  - Dynamic = Admission webhooks (`MutatingAdmissionWebhook` + `ValidatingAdmissionWebhook` plugins must be enabled) or newer CEL-based `ValidatingAdmissionPolicy`.
- Common / recommended built-in controllers you should recognize:
  - `NamespaceLifecycle`
  - `LimitRanger`
  - `ResourceQuota`
  - `ServiceAccount`
  - `PodSecurity` (stable, enforces Pod Security Standards)
  - `DefaultStorageClass` / `DefaultIngressClass`
  - `MutatingAdmissionWebhook` / `ValidatingAdmissionWebhook`
- Admission controllers do **not** replace RBAC — they complement it. RBAC answers “can this user do this action?”; admission answers “does this object meet policy?”.
- Popular policy engines (OPA/Gatekeeper, Kyverno, etc.) are implemented as validating/mutating admission webhooks.
- You enable/disable plugins on the API server; you cannot turn them on/off per-namespace with the built-in controllers (webhooks and PodSecurity can be more selective via selectors or labels).

### Quick Mental Model for the Exam

```
Request → AuthN → AuthZ → [Mutating Admission] → Schema Validation → [Validating Admission] → etcd
```

Admission is the last chance to change or reject an object before it becomes cluster state.

This covers the core knowledge expected for KCNA on the topic. Focus on the phases, the distinction between mutating and validating, the position in the request lifecycle, and the fact that they live in (or are called by) the API server.