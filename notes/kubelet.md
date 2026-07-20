**Kubelet Trivia (KCNA Exam Focus)**

### Core Identity & Placement

- **Kubelet** is the **primary Kubernetes agent** (node agent) that runs on **every node** in the cluster.
  - Runs on **worker nodes** (where pods actually execute workloads).
  - Also runs on **control plane nodes** (in self-managed clusters) — though its main job there is still managing static pods like API server, etcd, controller-manager, scheduler, etc.
- It is **not** present on the client side (kubectl, etc.) or outside the cluster.

### Main Responsibilities (High-Yield for Exam)

- **Pod lifecycle management**: Starts, stops, restarts, and monitors pods on its node.
  - Uses the **Container Runtime Interface (CRI)** to talk to the container runtime (containerd, CRI-O, Docker shim in older setups).
- **Node registration**: Automatically registers the node with the Kubernetes API server (including node labels, capacity, etc.).
- **Health & reporting**:
  - Performs **liveness, readiness, and startup probes** defined in pod specs.
  - Reports node status (Ready/Schedulable/NotReady) and pod status back to the API server.
- **Volume & storage management**: Mounts volumes, secrets, ConfigMaps, and hostPath volumes into containers.
- **Image management**: Pulls container images as needed.
- **Resource enforcement**: Works with the kubelet’s cgroups and eviction policies to enforce resource requests/limits and handle node pressure (e.g., OOM kills, disk pressure eviction).
- **Static pods**: Manages static pods defined via manifest files in `/etc/kubernetes/manifests/` (common on control plane nodes). Bypasses `kube-apiserver`

**Key phrase to remember**: “Kubelet is the Kubernetes node daemon responsible for making sure the containers described in Pod specs are actually running on its node.”

### Communications

- **Primary communication**: With the **Kubernetes API server** (over HTTPS).
  - Watches for pods assigned to its node.
  - Sends heartbeats, status updates, and metrics.
- **Container runtime**: Via gRPC over the CRI (Container Runtime Interface).
- **Indirect**:
  - Talks to **kube-proxy** indirectly (kube-proxy handles networking rules).
  - Does **not** talk directly to etcd, scheduler, or controller manager — everything goes through the API server.
- **Authentication**: Uses TLS client certificates (usually) or service account tokens.

### Important Concepts & Gotchas (Exam Style)

- **NodeNotReady** condition → usually means the kubelet is down, not communicating with API server, or has network issues.
- **Kubelet restart** does **not** delete running containers (graceful behavior) — but pods will be rescheduled if the node is marked NotReady long enough.
- **--pod-manifest-path** flag: Used for static pods.
- **--config** flag points to kubelet config file (common in modern setups).
- **Eviction signals**: MemoryPressure, DiskPressure, PIDPressure, ImageFS, NodeFS, etc.
- Kubelet does **not** schedule pods — that’s the scheduler’s job. It only receives already-scheduled pods from the API server.

### Quick Comparison (Helpful for Exam Questions)

| Component             | Runs On       | Main Job                         | Communicates With |
| --------------------- | ------------- | -------------------------------- | ----------------- |
| **Kubelet**           | Every node    | Pod execution & node health      | API server + CRI  |
| **kube-proxy**        | Every node    | Networking rules (iptables/IPVS) | API server        |
| **Container Runtime** | Every node    | Actually running containers      | Kubelet (CRI)     |
| **Scheduler**         | Control plane | Decides which node a pod goes to | API server        |

### Mnemonics / One-Liners

- “If a pod is supposed to run on a node, the **kubelet** is the one that actually makes it happen.”
- “Kubelet = Kubernetes + Let (the containers run).”
- “Kubelet watches the API server for pods assigned to its node and reports back status.”

**KCNA Tip**: Expect questions like:

- “Which component is responsible for starting containers on a node?”
- “What happens when the kubelet stops communicating with the API server?” - NodeNotReady
- “Which component uses the CRI?”

Would you like trivia on **kube-proxy**, **containerd**, static pods, or a quick comparison table for all node components next? Or practice questions on this topic? Keep grinding! 🚀