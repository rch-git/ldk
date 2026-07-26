**Security Context** is a core Kubernetes security topic on the KCNA exam (under security best practices / container security). You need a solid conceptual understanding of what it is, the two levels, the most important fields and what they mean, and how it relates to Pod Security Standards.

### What is a Security Context?
A **Security Context** defines privilege and access control settings for a Pod or Container. It controls how the processes inside containers run (user/group IDs, capabilities, filesystem access, privilege escalation, etc.).

It is part of the “Containers” layer in the **4Cs of Cloud Native Security** (Cloud, Clusters, Containers, Code).

### Two Levels (Very Important)
| Level | Location in YAML | Applies to | Notes |
|-------|------------------|------------|-------|
| **Pod Security Context** | `spec.securityContext` | All containers in the Pod + some volume settings | Type: `PodSecurityContext` |
| **Container Security Context** | `spec.containers[].securityContext` | One specific container | Type: `SecurityContext`. **Overrides** Pod-level settings for overlapping fields |

Container-level always wins when both are set for the same field.

### Most Important Settings to Remember for KCNA

| Setting | Level | What it means | Secure value / Best practice |
|---------|-------|---------------|------------------------------|
| `runAsNonRoot` | Pod or Container | Forces the container to run as a non-root user (UID ≠ 0). Kubernetes rejects the Pod if the process would run as root. | `true` |
| `runAsUser` | Pod or Container | Exact UID the process runs as | Non-zero (e.g. `1000` or `10001`) |
| `runAsGroup` | Pod or Container | Primary GID of the process | Non-zero |
| `fsGroup` | **Pod only** | Supplementary group ID applied to volumes. Files created in volumes are owned by this GID so all containers in the Pod can access them. | Use when sharing volumes |
| `privileged` | Container | Gives the container almost all privileges of the host (very dangerous — essentially root on the node). | `false` (default, never set to true unless absolutely required) |
| `allowPrivilegeEscalation` | Container | Controls whether a process can gain more privileges than its parent (sets the Linux `no_new_privs` flag). Always `true` if the container is privileged or has `CAP_SYS_ADMIN`. | `false` |
| `readOnlyRootFilesystem` | Container | Mounts the container’s root filesystem as read-only. Prevents writing to the container filesystem (forces use of volumes). | `true` |
| `capabilities` | Container | Linux capabilities (finer-grained privileges than “root”). You can `add` or `drop` them. | `drop: ["ALL"]` then `add` only what is needed (e.g. `NET_BIND_SERVICE`) |
| `seccompProfile` | Pod or Container | Restricts the system calls the container can make. | `type: RuntimeDefault` (or a custom profile) |
| `seLinuxOptions` | Pod or Container | SELinux labels (user/role/type/level) | Usually leave at defaults unless you know what you’re doing |

**Other fields you may see**: `supplementalGroups`, `sysctls`, `procMount`, `appArmorProfile`, Windows-specific options.

### Key Relationships & Exam Points
- **Principle of least privilege** is the guiding idea: run as non-root, drop all unnecessary capabilities, use read-only root filesystem, and disable privilege escalation.
- `capabilities` is the modern, safer alternative to running a privileged container.
- These settings are **runtime configuration**. They are what the container runtime actually enforces when the Pod starts.
- **Pod Security Standards (PSS)** (the replacement for the deprecated PodSecurityPolicy) *enforce* good Security Context values:
  - **Privileged** → unrestricted (no restrictions).
  - **Baseline** → blocks known privilege escalations (no privileged containers, limited capabilities, no hostPath, etc.).
  - **Restricted** → strongest hardening (requires `runAsNonRoot: true`, `allowPrivilegeEscalation: false`, drop `ALL` capabilities, etc.).

PSS is enforced by the Pod Security Admission controller (usually via namespace labels).

### Typical Secure Container Security Context Example
```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop: ["ALL"]
    add: ["NET_BIND_SERVICE"]   # only if needed
  seccompProfile:
    type: RuntimeDefault
```

### What KCNA Expects You to Know
- Definition and purpose of Security Context.
- Difference between Pod-level and Container-level (and that container overrides pod).
- Meaning of the high-impact settings above (`runAsNonRoot`, `privileged`, `allowPrivilegeEscalation`, `readOnlyRootFilesystem`, `capabilities`).
- That these are how you apply the principle of least privilege at the container level.
- How Security Contexts relate to Pod Security Standards (Restricted profile requires the strongest settings).
- Awareness that Privileged containers and running as root are major risks.

You do **not** need deep implementation details, exact capability lists beyond the common ones, or advanced SELinux/AppArmor configuration for KCNA — those belong more to CKS/KCSA. Focus on the concepts, the key fields, least privilege, and the link to Pod Security Standards.