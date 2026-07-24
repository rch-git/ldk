**etcd – Exam-Relevant Overview (KCNA focused)**

### What etcd is

etcd is a distributed, strongly consistent key-value store. In Kubernetes it is the **primary backing store** (the cluster database) that holds the entire cluster state: all objects, desired state, observed state, Secrets, ConfigMaps, etc.

It is a core **control plane component**.

### How consistency works – Raft consensus

etcd uses the **Raft consensus algorithm** to maintain consistency across members.

- Raft is leader-based.
- One member is elected leader; the others are followers.
- Writes go to the leader. The leader replicates the data and commits a change only after a **quorum** (majority) of members acknowledge it.
- This guarantees strong consistency and allows the cluster to tolerate failures as long as a majority of members remain available.
- For this reason, production etcd clusters almost always use an **odd number of members** (typically 3 or 5).

### How etcd is created and runs in a kubeadm cluster

In the default (stacked) topology:

1. `kubeadm init` (specifically the phase `kubeadm init phase etcd local`) generates a **static Pod manifest** at  
   `/etc/kubernetes/manifests/etcd.yaml`
2. The **kubelet** on the control plane node watches the manifests directory and creates/runs the etcd Pod from that file.
3. etcd therefore runs as a **static Pod** managed by the kubelet (not by the Kubernetes scheduler or a Deployment).
- Data directory: `/var/lib/etcd`
- Certificates: `/etc/kubernetes/pki/etcd/`
- By default it listens on localhost (HostNetwork) on port 2379 (client) and 2380 (peer).

You can also configure an **external etcd** cluster. In that case kubeadm does not create the local static Pod manifest and the API server is pointed at the external etcd endpoints.

### Key operational facts relevant to the exam

- Only the **kube-apiserver** communicates with etcd. No other control plane component talks to it directly.
- etcd is the single source of truth for the cluster. If etcd data is lost and there are no backups, the cluster state is gone.
- Secrets are stored in etcd (by default unencrypted at rest unless encryption-at-rest is enabled).
- High-availability topologies:
  - **Stacked**: etcd members run on the same nodes as the control plane components.
  - **External**: etcd runs on separate nodes from the control plane.

These are the points most likely to appear on the KCNA exam regarding etcd.