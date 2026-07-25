**Persistent Volume Claims (PVCs)** are how applications request persistent storage in Kubernetes. They act as the middle layer between your Pods and the actual storage, so developers don’t need to know about disks, cloud volumes, or NFS details.

### Simple Analogy
- **PersistentVolume (PV)** = the actual storage resource in the cluster  
- **PersistentVolumeClaim (PVC)** = a request ticket that says “I need this much storage with these rules”

Pods never use a PV directly — they always go through a PVC.

### How Binding Works
When you create a PVC, Kubernetes looks for a matching PV (or dynamically creates one using a StorageClass) and binds them together.  
Binding is **one-to-one and exclusive**. Once bound, that PV cannot be claimed by any other PVC.

### Statuses – What They Mean and How They Change

#### PVC Statuses
| Status     | Meaning                                                                 | Common Reason |
|------------|-------------------------------------------------------------------------|---------------|
| **Pending** | Waiting for a suitable PV to become available or to be provisioned     | No matching PV exists yet, size/access mode doesn’t match, or dynamic provisioning is still happening |
| **Bound**   | Successfully linked to a PV                                            | Matching completed |
| **Lost**    | The PVC is still around but the underlying PV is no longer usable      | Rare — usually happens if the PV was manually deleted while the PVC still existed |
| **Terminating** | Being deleted, but protected because a Pod is still using it        | Finalizer (`kubernetes.io/pvc-protection`) is active |

#### PV Statuses (Phases)
| Status      | Meaning                                                                 | What happens next |
|-------------|-------------------------------------------------------------------------|-------------------|
| **Available** | Free and ready to be claimed                                           | Waiting for a PVC |
| **Bound**    | Currently claimed by a PVC                                             | In active use |
| **Released**  | The PVC was deleted, but the PV (and data) still exists                | Happens with `Retain` reclaim policy. An admin must clean it up manually |
| **Failed**    | Something went wrong during reclaim                                    | Needs investigation |

**Typical flow of status changes:**
1. You create a PVC → status becomes **Pending**
2. Kubernetes finds or creates a matching PV → both become **Bound**
3. You delete the PVC:
   - If reclaim policy is `Delete` → PV is removed
   - If reclaim policy is `Retain` → PV moves to **Released**
4. If a Pod is still using the PVC when you try to delete it → PVC goes to **Terminating** until the Pod is gone

### Other Key Points for KCNA

**Access Modes** (very commonly tested):
- **ReadWriteOnce (RWO)** – one node can mount it read-write (most common)
- **ReadOnlyMany (ROX)** – many nodes can mount it read-only
- **ReadWriteMany (RWX)** – many nodes can mount it read-write
- **ReadWriteOncePod (RWOP)** – only one Pod can use it

The PV must support at least the access mode the PVC is asking for.

**Static vs Dynamic Provisioning**
- **Static** → Admin creates PVs in advance. PVCs just claim them.
- **Dynamic** → You create a PVC with a StorageClass. Kubernetes automatically creates the PV for you. This is the preferred modern approach.

**Reclaim Policies**
- **Delete** (default for dynamic volumes) – deletes the PV and the actual storage
- **Retain** – keeps the PV and data after the PVC is deleted (moves PV to Released)
- **Recycle** – deprecated, avoid it

**Namespace Note**
- PVCs are **namespaced** (a Pod can only use a PVC in the same namespace)
- PVs are **cluster-scoped** (not tied to a namespace)

### Exam Tips
- A PVC stuck in **Pending** almost always means no matching PV is available or dynamic provisioning failed.
- Binding is exclusive — one PVC = one PV.
- Pods reference the **PVC name**, never the PV name.
- Know the difference between **Available → Bound → Released**.
- Storage Object in Use Protection prevents accidental data loss by blocking deletion of in-use PVCs/PVs.

This status lifecycle is one of the most practical things to understand for both the exam and real clusters. Once you can read `kubectl get pvc` and `kubectl get pv` and immediately know what’s going on, the rest of Kubernetes storage becomes much clearer.