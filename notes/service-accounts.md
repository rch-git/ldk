**Service Accounts (SAs) in Kubernetes** are non-human identities used by Pods (and other workloads) to authenticate to the API server. From a **KCNA perspective**, they sit at the intersection of authentication and authorization and are a core part of Kubernetes security fundamentals.

### What Are Service Accounts?
- A ServiceAccount is a namespaced Kubernetes API object that gives processes running inside Pods an identity.
- **Users** = human identities (usually managed outside Kubernetes, e.g., via OIDC, certificates, or cloud IAM).
- **Service Accounts** = machine/workload identities (managed inside the cluster as `ServiceAccount` objects).

Every namespace automatically gets a `default` ServiceAccount when it is created. If a Pod does not specify a ServiceAccount, it uses this `default` one.

### How Are They Created?
You create them just like any other Kubernetes resource:

```bash
kubectl create serviceaccount my-app-sa -n my-namespace
```

Or via YAML:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-app-sa
  namespace: my-namespace
```

That’s it. Creating the ServiceAccount alone gives it **almost no permissions**.

### How Are They Used by Pods?
In the Pod (or Deployment/StatefulSet) spec:

```yaml
spec:
  serviceAccountName: my-app-sa   # optional — defaults to "default"
  automountServiceAccountToken: true  # default is true
```

When a Pod starts:
1. The kubelet requests a token for that ServiceAccount.
2. Kubernetes mounts the token (as a projected volume) into the Pod (usually at `/var/run/secrets/kubernetes.io/serviceaccount/`).
3. Applications inside the Pod can use this token to call the Kubernetes API.

**Modern behavior (important for KCNA-level understanding):**
- Tokens are short-lived, bound to the Pod, and automatically rotated (TokenRequest API + projected volumes).
- You can disable automatic mounting with `automountServiceAccountToken: false` if the Pod does not need API access (reduces attack surface).

### How RBAC Ties Into Service Accounts
This is the most important conceptual link for KCNA.

- **Authentication** → “Who are you?” → handled by the ServiceAccount + its token.
- **Authorization** → “What are you allowed to do?” → handled by **RBAC**.

A ServiceAccount by itself has almost no rights (only basic API discovery). To give it permissions you must:

1. Create a **Role** (namespace-scoped) or **ClusterRole** (cluster-scoped) that lists the allowed verbs + resources.
2. Create a **RoleBinding** or **ClusterRoleBinding** that binds that role to the ServiceAccount.

Example (namespace-scoped):

```yaml
# Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: my-namespace
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]

# RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: my-namespace
subjects:
- kind: ServiceAccount
  name: my-app-sa
  namespace: my-namespace
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

In RBAC subjects, ServiceAccounts appear as:
- Username format: `system:serviceaccount:<namespace>:<sa-name>`
- Groups: `system:serviceaccounts` and `system:serviceaccounts:<namespace>`

### Most Relevant Points for KCNA
These are the concepts the exam cares about:

| Topic | Key Point |
|------|-----------|
| **Identity** | SAs give Pods an identity so they can talk to the API server |
| **Default SA** | Every namespace has one named `default`. Prefer dedicated SAs over reusing `default` |
| **Least Privilege** | Create application-specific ServiceAccounts and bind only the minimum required Role |
| **RBAC Link** | ServiceAccount = subject in RoleBinding / ClusterRoleBinding |
| **Tokens** | Automatically mounted (projected volume). Can be disabled |
| **Security Implication** | Over-privileged ServiceAccounts (especially `default`) are a common security risk |
| **Scope** | ServiceAccounts are namespaced; ClusterRoleBindings can still grant them cluster-wide rights |

### Quick Mental Model
1. Create a ServiceAccount → gives the Pod an identity.
2. Create a Role/ClusterRole → defines what is allowed.
3. Create a RoleBinding/ClusterRoleBinding → connects the identity to the permissions.
4. Reference the ServiceAccount in the Pod → the Pod now runs with those permissions.

That combination (ServiceAccount + RBAC) is how Kubernetes implements identity and access control for workloads. For KCNA, focus on understanding *why* they exist and how they connect to RBAC rather than deep token mechanics or advanced projection options.