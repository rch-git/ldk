**Persistent Volumes (PVs)** give Kubernetes durable storage that survives pod restarts, rescheduling, and deletions.

Pods are ephemeral. Any data written inside a container is lost when the pod disappears. PVs solve this by providing cluster-level storage that applications can claim and reuse.

### Core Building Blocks

- **PersistentVolume (PV)**  
  A piece of storage that exists in the cluster. It is cluster-scoped (not namespaced) and is usually backed by cloud disks, NFS, local storage, or other storage systems.

- **PersistentVolumeClaim (PVC)**  
  A request for storage made by a user or application. It is namespaced. The claim specifies size, access mode, and optionally a StorageClass. Kubernetes matches it to a suitable PV.

- **StorageClass**  
  A template that defines how storage should be dynamically created. It enables on-demand provisioning instead of requiring an administrator to pre-create every volume.

### Static vs Dynamic Provisioning

| Type     | Who creates the PV?     | When is it created?          | Typical use case                  |
|----------|-------------------------|------------------------------|-----------------------------------|
| Static   | Cluster administrator   | Ahead of time                | Pre-allocated or special hardware |
| Dynamic  | Storage provisioner     | Automatically when a PVC is created | Most cloud and modern clusters    |

Dynamic provisioning is the standard approach in cloud-native environments and is frequently tested.

### Status and Lifecycle

Both PVs and PVCs have a **phase** (status) that shows where they are in their lifecycle. Understanding these phases is important for the exam.

#### PersistentVolume Phases

| Phase      | Meaning                                                                 | When you see it |
|------------|-------------------------------------------------------------------------|-----------------|
| **Available** | The volume exists and is free. No claim is using it yet.               | Right after a PV is created (static) or after dynamic provisioning finishes and before a PVC claims it. |
| **Bound**     | The volume has been successfully matched and bound to a PVC.           | After a PVC finds a matching PV (or a dynamic PV is created and bound). This is the normal “in-use” state. |
| **Released**  | The PVC that was using the volume has been deleted, but the volume still exists and retains its data. | After you delete a PVC. What happens next depends on the reclaim policy. |
| **Failed**    | Something went wrong with the volume (rare).                           | When the underlying storage system reports an error that Kubernetes cannot recover from automatically. |

#### PersistentVolumeClaim Phases

| Phase      | Meaning                                                                 | When you see it |
|------------|-------------------------------------------------------------------------|-----------------|
| **Pending**   | The claim has been created but no suitable volume has been bound yet.  | Immediately after creating a PVC, while Kubernetes is looking for a match or waiting for dynamic provisioning. |
| **Bound**     | The claim has been successfully bound to a PersistentVolume.           | Once a matching PV is found (or created) and the binding is complete. |
| **Lost**      | The bound PersistentVolume has been lost or become unavailable.        | Rare. Occurs if the underlying storage disappears or becomes inaccessible while the claim still exists. |

**Key exam point:**  
A PVC stays in `Pending` until a matching PV is available. If dynamic provisioning is configured correctly, the wait is usually short. If it stays pending, the most common causes are missing StorageClass, insufficient capacity, or incompatible access modes.

### Reclaim Policy (What Happens After Released)

Once a PVC is deleted, the PV moves to `Released`. The reclaim policy then decides the next action:

- **Retain** — Keep the volume and its data. An administrator must manually clean it up and make it available again.
- **Delete** — Automatically delete the underlying storage (common with cloud disks).
- **Recycle** — Deprecated. Do not rely on it.

### Access Modes

These describe how the volume can be mounted by nodes or pods:

- **ReadWriteOnce (RWO)** — Mounted as read-write by a single node. Most common for cloud block storage.
- **ReadOnlyMany (ROX)** — Mounted read-only by many nodes.
- **ReadWriteMany (RWX)** — Mounted read-write by many nodes (requires shared storage such as NFS or certain file services).
- **ReadWriteOncePod (RWOP)** — Mounted read-write by only one pod (newer mode).

**Common confusion:**  
RWO restricts the volume to one **node**, not necessarily one pod. Multiple pods on the same node can still use an RWO volume. RWOP is the mode that truly limits it to a single pod.

### Volume Mode

- **Filesystem** (default) — The volume is formatted and mounted as a directory.
- **Block** — Presented as a raw block device (useful for databases that manage their own storage).

### How a Pod Uses the Storage

1. Create a PVC that requests the needed size and access mode.
2. Reference the PVC in the Pod (or Deployment/StatefulSet) under `volumes`.
3. Mount it into a container using `volumeMounts`.

StatefulSets are the preferred workload type when each pod needs its own stable persistent storage. They automatically create PVCs via `volumeClaimTemplates`.

### Exam Traps to Watch For

- PVs are **cluster-scoped**; PVCs are **namespaced**.
- A PVC can bind to a larger PV (it only needs enough capacity). The reverse is not allowed.
- Access modes and StorageClass must be compatible for binding to succeed.
- Once bound, the relationship stays until the PVC is deleted.
- A PVC with no `storageClassName` uses the cluster’s default StorageClass (if one exists).
- `hostPath` is not a true PersistentVolume and is generally avoided in production.

### Simple Mental Model

- **PV** = the actual storage resource in the cluster  
- **PVC** = the request/ticket for that storage  
- **StorageClass** = the rules (and automation) for creating storage on demand  
- **Phase/Status** = the current state of the volume or claim (Available → Bound → Released, or Pending → Bound)

Focus on the relationship between PV, PVC, and StorageClass, the four access modes, the reclaim policies, and the phase transitions. These topics appear regularly in KCNA-style questions.