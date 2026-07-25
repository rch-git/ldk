**From a KCNA perspective**, here are the most important points about **Role**, **RoleBinding**, **ClusterRole**, and **ClusterRoleBinding**. These form the core of Kubernetes RBAC (Role-Based Access Control).

### Core Concepts

| Object              | Scope              | What it does                                      | Namespaced? |
|---------------------|--------------------|---------------------------------------------------|-------------|
| **Role**            | Single namespace   | Defines a set of permissions (rules)              | Yes        |
| **ClusterRole**     | Cluster-wide       | Defines a set of permissions (rules)              | No         |
| **RoleBinding**     | Single namespace   | Grants a Role (or ClusterRole) to subjects        | Yes        |
| **ClusterRoleBinding** | Entire cluster  | Grants a ClusterRole to subjects                  | No         |

### Key Points You Must Know

**1. Role vs ClusterRole (the permission definitions)**
- Both contain **rules** that specify:
  - `apiGroups`
  - `resources` (e.g., pods, secrets, deployments)
  - `verbs` (get, list, watch, create, update, patch, delete, etc.)
- Permissions are **purely additive** — there are no deny rules.
- **Role** → always scoped to **one namespace**. You must specify the namespace when creating it.
- **ClusterRole** → not namespaced. It can be used for:
  - Cluster-scoped resources (nodes, persistentvolumes, namespaces, etc.)
  - Namespaced resources **across all namespaces**
  - Non-resource URLs (e.g., `/healthz`)

**2. RoleBinding vs ClusterRoleBinding (the grants)**
- Both connect **subjects** (User, Group, or ServiceAccount) to a role.
- **RoleBinding**:
  - Lives in a namespace.
  - Grants permissions **only inside that namespace**.
  - Can reference a **Role** in the same namespace **or** a **ClusterRole**.
- **ClusterRoleBinding**:
  - Not namespaced.
  - Grants the referenced **ClusterRole** across the **entire cluster**.
  - Can **only** reference a ClusterRole (not a Role).

**3. Critical mixing rules (very common exam focus)**
- A **RoleBinding** can reference a **ClusterRole**. When it does, the permissions apply **only in the RoleBinding’s namespace**.
  - This is a common and recommended pattern for reusable permissions.
- A **ClusterRoleBinding** cannot reference a Role.
- You cannot change the `roleRef` of an existing binding after creation. You must delete and recreate the binding if you want to point it to a different role.

**4. Subjects**
Subjects can be:
- `User` (human or external identity)
- `Group`
- `ServiceAccount` (most common for workloads)

### Mental Model for the Exam

- Need permissions **in one namespace** → use **Role + RoleBinding**
- Need the **same permissions in multiple namespaces** → create one **ClusterRole** and bind it with multiple **RoleBindings**
- Need permissions **across the whole cluster** (including cluster-scoped resources) → use **ClusterRole + ClusterRoleBinding**

### Quick Summary for Memorization

- **Role / RoleBinding** = namespace-scoped
- **ClusterRole / ClusterRoleBinding** = cluster-scoped
- RoleBinding can point to either a Role **or** a ClusterRole
- ClusterRoleBinding can only point to a ClusterRole
- Always prefer the least privilege (prefer RoleBindings over ClusterRoleBindings when possible)

These distinctions (especially the ability of a RoleBinding to reference a ClusterRole while still limiting scope to one namespace) are frequently tested on the KCNA.