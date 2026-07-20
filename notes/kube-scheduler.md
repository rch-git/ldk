**Kube-scheduler** is a core **control plane component** in Kubernetes. It's essential for KCNA-level understanding of how Pods get placed on Nodes. Here's focused trivia and key facts tailored for exam prep:

### Responsibilities (What it does)

- **Primary job**: Assigns (schedules) **unscheduled Pods** (those without a `nodeName` set) to suitable Nodes.
- Watches the **API Server** for new/pending Pods.
- Determines **feasible nodes** (**filtering** phase): Checks constraints like resource requests (CPU/memory), node selectors, affinity/anti-affinity, taints/tolerations, volume requirements, etc.
- **Scores** feasible nodes (scoring phase) based on factors like resource utilization, pod spreading, etc., then picks the best one (or one with highest score).
- Performs **binding**: Updates the Pod spec in the API Server with the chosen `nodeName`.
- Supports **multiple schedulers** in a cluster (via scheduler profiles or custom schedulers) and **Scheduling Profiles** (configurable plugins for QueueSort, Filter, Score, Bind, etc.).
- Does **not** actually run the Pod — it only decides *where* it should run. The **kubelet** on the target Node picks it up and launches it.

### Where it runs

- Runs on **control plane / master node(s)** (not on worker nodes).
- In **kubeadm** setups (very common in exams/labs), it runs as a **Static Pod** in the `kube-system` namespace.
  - Manifest typically at `/etc/kubernetes/manifests/kube-scheduler.yaml` on the control plane node.
  - The local **kubelet** directly manages it (bypassing the API Server for its own lifecycle).

**Yes, it is a static pod** in standard deployments. This is a common exam point — control plane components like `kube-apiserver`, `kube-controller-manager`, `kube-scheduler`, and `etcd` (sometimes) run as static Pods for bootstrapping and high availability.

### Communications

- **Mainly with kube-apiserver**: Uses **watch** mechanism (via informers) to monitor Pods, Nodes, and other resources. It reads cluster state (Node capacity, existing Pods, etc.) and writes binding decisions back.
- Does **not** directly talk to kubelets for scheduling (kubelet watches the API Server for assigned Pods).
- Relies on **etcd** indirectly (via API Server) for persistent state.
- Can interact with other components through the API Server (e.g., for custom resources or extenders).

### KCNA-Relevant Exam Tips / Gotchas

- **Pod creation flow** (classic question): `kubectl create` → API Server → etcd → Scheduler watches & binds → Kubelet on Node detects → Container runtime starts it.
- If no suitable Node → Pod stays in **Pending** state.
- You can manually schedule by setting `nodeName` in Pod spec (bypasses scheduler).
- **Static Pods** vs regular Pods: Static Pods are managed by kubelet on one node only; they appear in the cluster but have limitations (no full API control).
- High availability: In multi-master setups, multiple scheduler instances can run, but only one is active (leader election).
- Extensibility: Plugins, scheduler profiles, or custom schedulers (specify `schedulerName` in Pod spec).
- Commands to know:
  - `kubectl get pods -n kube-system | grep scheduler` (to see it).
  - Logs: `kubectl logs kube-scheduler-<node> -n kube-system`.
  - Describe Nodes/Pods for scheduling info.

**Quick mnemonic**: Scheduler = "Matchmaker for Pods & Nodes" — filters, scores, binds via API Server. Runs as static Pod on control plane.

This should cover the high-yield points for KCNA. Focus on the scheduling cycle (Filter → Score → Bind) and its interaction with API Server + kubelet. If you want trivia on related topics (e.g., kube-controller-manager, static Pods in more depth, or practice questions), just let me know! Keep crushing the prep. 🚀