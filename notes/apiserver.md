**Kubernetes API Server (kube-apiserver) Trivia for KCNA Prep**

The API server is the **central hub** and front door of the Kubernetes control plane. Almost every exam question on architecture, component interactions, or troubleshooting touches on it. Here’s focused trivia in bite-sized points:

### Where It Runs

- Runs on **control plane nodes** (formerly called master nodes).
- In a highly available (HA) setup, you run **multiple instances** of kube-apiserver (one per control plane node) for redundancy.
- It is **stateless** — this is why scaling it horizontally is straightforward (just add more control plane nodes and load-balance requests).
- Worker nodes do **not** run the API server (they run kubelet + kube-proxy + container runtime).

### Core Responsibilities

- **Exposes the Kubernetes API** (RESTful) — this is the *only* way to interact with the cluster (kubectl, clients, controllers, etc. all talk to it).
- **Authentication** (who are you?) + **Authorization** (what can you do?) + **Admission Control** (validations, webhooks, mutating/validating).
- **Validation & configuration** of API objects (Pods, Services, Deployments, etc.).
- **Serves as the single source of truth** for cluster state — all reads/writes go through it.
- Handles **watch streams** (efficient change notifications that controllers and clients use).

### Key Communications

- **Only component that talks directly to etcd** — it reads/writes all persistent cluster state to etcd. Other control plane components (scheduler, controller-manager) go through the API server to reach etcd. This isolation is important for data consistency.
- **Receives requests** from:
  - kubectl / external clients
  - Controllers (Deployment controller, etc.)
  - Scheduler
  - kubelet (on worker nodes — for status updates, pod specs)
- **Sends instructions** to kubelets on worker nodes (via the API).
- Communicates with other control plane components (scheduler, controller-manager) via the API it exposes.

### Exam-Friendly Facts & Gotchas

- **Hub-and-spoke model**: Everything goes through the API server — it is the “brain’s mouth and ears.”
- If the API server is down → cluster becomes **unmanageable** (you can’t create/update resources, but existing Pods may continue running for a while).
- Highly available clusters run 3+ control plane nodes with stacked etcd or external etcd.
- kube-apiserver is configured via flags (e.g., `--etcd-servers`, `--bind-address`, `--secure-port=6443`, admission plugins, etc.).
- It performs **optimistic concurrency** using resourceVersion to handle concurrent updates safely.
- In troubleshooting: Check API server logs for authz/authn failures, admission webhook issues, or etcd connectivity problems.

### Quick Mental Model for KCNA

```
Clients (kubectl, dashboards, operators, etc.)
          ↓ (REST API calls)
   kube-apiserver
   (auth + authorization + validation + admission + watch)
          ↓ (only direct link)
          etcd (persistent cluster state)

          ↑↓ (all via API server)
Scheduler
Controller Manager (deployment, replica, etc. controllers)
Kubelet (on every node)
Kube-proxy
Other components
```

**Pro Tip for the Exam**: When a question mentions “which component communicates with etcd” or “central component for all API operations,” the answer is almost always **API Server**. Also remember it’s the only component that directly interacts with etcd.

Memorize: **Stateless + Control Plane only + etcd gateway + All roads lead through it.**

This should cover most API server questions you’ll see. Want similar trivia cards for Scheduler, Controller Manager, etcd, or Kubelet next? Or practice questions on this topic? Just say the word — keep crushing that KCNA prep! 🚀

`kube-apiserver` is typically run as a **Static Pod** in standard Kubernetes setups (especially those created with `kubeadm`).

### Quick Explanation for KCNA

- **Static Pods** are pods managed directly by the **kubelet** on a node, **not** by the Kubernetes control plane (no Deployment, ReplicaSet, etc.).
- They are defined by Pod manifest files placed in a specific directory (usually `/etc/kubernetes/manifests/`).
- The kubelet on the control plane node automatically creates and monitors them.

### Control Plane Components as Static Pods

In a typical `kubeadm`-based cluster, the following run as **static pods** on control plane nodes:

- `kube-apiserver`
- `kube-controller-manager`
- `kube-scheduler`
- `etcd` (when using stacked etcd)

You can see them with:

```bash
kubectl get pods -n kube-system
```

They usually show names like `kube-apiserver-<node-name>`, and their status is managed locally by the kubelet.

### Why Static Pods for Control Plane?

This is a **bootstrapping** solution — the control plane needs to start before the full Kubernetes API is available to manage Deployments/ReplicaSets. Static pods allow the components to come up independently.

### Exam Tips

- Expect questions like: “How are control plane components started?” or “What are static pods used for?”
- Static pods appear in `kubectl get pods`, but you **cannot** delete or scale them using normal Kubernetes objects (the kubelet will recreate them from the manifest).
- You can customize them by editing the manifest files in `/etc/kubernetes/manifests/` (the kubelet will automatically pick up changes).

This ties back nicely to our API server discussion — it runs as a static pod on control plane nodes.

Want me to show the typical manifest structure for kube-apiserver or trivia on other static pod behaviors? Just let me know! Keep going with the prep.