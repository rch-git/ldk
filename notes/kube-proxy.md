**Kube-proxy Trivia (KCNA Exam Focus)**

### What is kube-proxy?

- **Core role**: Kube-proxy is the **network proxy** that runs on **every node** in the Kubernetes cluster. It implements the **Kubernetes Service** abstraction by maintaining **network rules** on the nodes.
- It enables **stable virtual IP addresses** (ClusterIP) for Services so clients can reach Pods without knowing their changing IPs.
- Without kube-proxy, Service load-balancing and discovery would not work.
- Not a static pod.

### Where does it run?

- **On every node** (worker nodes + control-plane nodes if they are schedulable).
- Deployed as a **DaemonSet** (`kube-system` namespace) — one Pod per node.
- Runs as a static binary/process on the node (not always inside a Pod in minimal setups, but DaemonSet is standard in kubeadm, etc.).

### What is it responsible for?

**Main responsibilities**:

- Watches the Kubernetes API server for **Service** and **EndpointSlice** (or Endpoints) changes.
- Programs **network rules** on the node to route traffic destined for a Service to healthy backend Pods.
- Performs **load balancing** across Pods backing a Service (round-robin by default).
- Handles **Service types**:
  - `ClusterIP` → internal cluster traffic
  - `NodePort` → exposes Service on each node’s IP at a static port
  - `LoadBalancer` → works with cloud provider or external LB (kube-proxy handles the NodePort part)
  - `ExternalName` → mainly DNS-based (less involvement from kube-proxy)
- Supports **session affinity** (ClientIP).
- Handles **headless Services** (no ClusterIP, direct to Pods via DNS).

**Modes** (important for exam):

- **iptables** (default in most setups) — uses Linux iptables for high-performance NAT.
- **IPVS** (better scalability, recommended for large clusters) — uses Linux IP Virtual Server.
- **userspace** (legacy, slow, rarely used).

### What does it communicate with?

- **Kubernetes API server** — watches for Service & EndpointSlice updates (via kube-apiserver).
- **etcd** indirectly (through API server).
- **Node’s network stack** (iptables / IPVS / conntrack).
- **kubelet** indirectly — kube-proxy and kubelet work together for Pod networking.
- Does **not** directly talk to Pods or other kube-proxies (it’s per-node).

### Key Exam-Style Facts & Gotchas

- Runs on **all nodes**, not just workers.
- Part of the **control plane + node components** picture (alongside kubelet, kube-scheduler, etc.).
- Does **not** handle Pod-to-Pod networking — that’s the responsibility of the **Container Network Interface (CNI)** plugin (e.g., Calico, Flannel, Cilium).
- Kube-proxy + CNI together enable full Kubernetes networking model.
- If kube-proxy is down on a node → Services become unreachable from that node.
- `kubectl get pods -n kube-system -l component=kube-proxy` to check it.
- Configuration lives in `/var/lib/kube-proxy/` or via ConfigMap.
- Uses **EndpointSlices** (modern, more scalable than old Endpoints) for backend tracking.

**Quick Mnemonics for KCNA**:

- “Kube-proxy = Service VIP → Pod load balancing on every node.”
- “API server watcher → programs iptables/IPVS.”
- “Not responsible for Pod networking (CNI).”

Would you like a set of KCNA-style multiple-choice trivia questions on kube-proxy (or on kubelet, CNI, Services, etc.) next? Or a comparison table with other components? Keep firing questions as you prepare! 🚀