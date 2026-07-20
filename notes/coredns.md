**CoreDNS** is the default DNS server for Kubernetes clusters (replacing the older kube-dns). It is a flexible, extensible, CNCF-graduated DNS server written in Go that serves as the cluster's internal DNS provider.

### What is CoreDNS responsible for?
- **Service discovery**: Provides DNS records for Kubernetes Services and Pods so applications can resolve names like `my-service.my-namespace.svc.cluster.local` to the correct ClusterIP (or individual Pod IPs for headless services).
- **A/AAAA records** for Services and (optionally) Pods.
- **SRV records** for service ports/protocols.
- **PTR records** for reverse lookups.
- It watches the Kubernetes API (via the `kubernetes` plugin) for changes to Services, Endpoints/EndpointSlices, Pods, etc., and dynamically updates its responses.

**Key trivia for KCNA**:
- Default domain: `cluster.local` (configurable).
- It implements the Kubernetes DNS-Based Service Discovery Specification.
- Supports features like stub domains, upstream forwarders, autopath (search path optimization), and more via its plugin architecture.

### How does it work?
1. CoreDNS runs as a container (usually in the `kube-system` namespace).
2. Its configuration lives in a ConfigMap (typically named `coredns`), which defines a `Corefile` with server blocks and plugins.
3. The critical plugin is **`kubernetes`**: It connects to the Kubernetes API server (in-cluster via ServiceAccount by default) and sets up watches/informers on relevant objects (Services, Endpoints/EndpointSlices, etc.).
4. On startup, it waits up to ~5 seconds (configurable via `startup_timeout`) to sync before serving DNS; it serves SERVFAIL for unsynced Kubernetes queries during initial sync.
5. Queries for cluster domains are handled by the kubernetes plugin; others can be forwarded upstream (e.g., to 8.8.8.8).
6. It caches responses and is highly performant/scalable.

Pods in the cluster get the CoreDNS Service IP (usually `10.96.0.10` or similar) as their DNS server via the `kubelet` (which injects it into `/etc/resolv.conf` inside Pods, along with the search path `svc.cluster.local cluster.local` etc.).

### Interaction with other Kubernetes components
- **kubelet**: On every node, the kubelet configures Pod DNS settings (nameserver + search domains) pointing to the CoreDNS Service. It also manages the CoreDNS Pods themselves (via the Deployment).
- **kube-proxy**: Handles load-balancing traffic to the CoreDNS Pods (ClusterIP Service). CoreDNS itself doesn't depend directly on kube-proxy for its DNS function.
- **API Server**: CoreDNS watches it (via the kubernetes plugin) for object changes. Rate limiting options (`apiserver_qps`, `apiserver_burst`) help prevent overwhelming the API server.
- **EndpointSlices**: Modern CoreDNS prefers watching EndpointSlices for better scalability (instead of the older Endpoints resource).
- **Pods/Services**: CoreDNS translates Kubernetes object metadata into DNS records. It can optionally provide Pod IPs (with `pods verified` mode for security).
- **Control Plane**: Deployed via kubeadm (or manually) as a regular Deployment + Service (not a control-plane component like etcd or apiserver).

### On which nodes does it run?
- CoreDNS Pods are scheduled on **worker nodes** (or wherever your node selectors/taints allow; typically not restricted to control-plane nodes only).
- It runs as a **Deployment** (with a ReplicaSet) for high availability — usually 2+ replicas. You can scale it based on cluster size.
- Not tied to specific nodes like DaemonSets (e.g., unlike kube-proxy or CNI plugins in some cases), but the Deployment ensures it's spread across nodes.

### Is it a static pod?
**No.** Static Pods are managed directly by the kubelet from manifests in `/etc/kubernetes/manifests/` (e.g., kube-apiserver, kube-controller-manager, etcd). CoreDNS is a regular, API-server-managed workload (Deployment). You won't see it listed as static when running `kubectl get pods -o wide` or checking static pod manifests.

**KCNA exam tips**:
- Know it's the cluster DNS, deployed in `kube-system`.
- Understand the `Corefile` basics and the kubernetes plugin.
- Remember it replaced kube-dns (kubeadm has used CoreDNS by default for a long time).
- Key concepts: watches API objects, provides service/pod discovery, configured via ConfigMap, scalable Deployment.
- Common troubleshooting: Check CoreDNS logs for API connection issues, ConfigMap changes, or forwarding problems.

This should cover the high-yield trivia! Let me know if you want practice questions, Corefile examples, or coverage of other KCNA topics like Services, Ingress, or CNI. Good luck with the exam! 🚀