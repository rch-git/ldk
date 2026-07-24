**In a typical kubeadm-based Kubernetes cluster, the main static pods are the control plane components on the control-plane node(s):**

- `etcd`
- `kube-apiserver`
- `kube-controller-manager`
- `kube-scheduler`

These appear in the `kube-system` namespace (as mirror pods) with the node name appended, e.g. `etcd-control-plane`, `kube-apiserver-control-plane`, etc.

Worker nodes usually have **no** static pods by default. Components like `kube-proxy` and CoreDNS are typically run as DaemonSets or Deployments, not static pods.

### Key trivia about static pods (KCNA-relevant)

- **Managed only by the kubelet** — The API server and scheduler have nothing to do with their lifecycle. The kubelet watches a local directory (almost always `/etc/kubernetes/manifests`) and starts/stops/restarts the pods based on the YAML files it finds there.
- **They exist so the control plane can bootstrap itself.** When you run `kubeadm init`, there is no API server yet. The kubelet starts the critical components from the local manifests so the cluster can come up.
- **Mirror pods** — Once the API server is running, the kubelet creates a read-only “mirror” of each static pod in the API so you can see them with `kubectl get pods -n kube-system`. You cannot edit or delete the real static pod through the API; if you delete the mirror, the kubelet just recreates it.
- **Name + node name** — Mirror pods are named `<pod-name>-<node-hostname>` so you can tell which node they belong to.
- **No scheduler involvement** — Static pods are bound to a specific node by definition. The Kubernetes scheduler never places them.
- **Useful for KCNA exam points** — Know the difference between static pods and DaemonSets (both run on every/selected nodes, but DaemonSets are controlled by the API server; static pods are not). Also know the classic directory `/etc/kubernetes/manifests` and that control-plane components run as static pods in kubeadm clusters.

**Quick identification tip** (handy for labs or troubleshooting):  
Static/mirror pods have an `ownerReference` of kind `Node`. Regular pods are owned by ReplicaSets, DaemonSets, etc.

This is core KCNA material under the “Kubernetes Fundamentals / Architecture / Workloads” domain. Understanding why the control plane runs as static pods is one of the classic “how does the cluster start itself?” questions.