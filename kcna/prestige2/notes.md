# Kubernetes & Cloud Native Study Notes

**Started:** Tuesday, May 26, 2026

---

## Auto Scaling

**Types:** Reactive • Scheduled • Predictive

### What is Auto Scaling?
Auto Scaling is a design pattern for dynamically adjusting infrastructure resources (**scaling up**, **down**, or **sideways**) based on demand.

- **Key Metrics**: CPU and memory are the primary ones, but it heavily depends on the application.
  - Example: Netflix relies heavily on GPU for video transcoding.

### Reactive vs Proactive (Scheduled) Auto Scaling
- **Reactive**: Automatically scales when thresholds (e.g., high CPU) are crossed. Ideal when workloads can react quickly.
- **Scheduled (Proactive)**: Scales based on known patterns, like specific dates/times.
  - Example: End-of-month processing for banks.

### Scaling Approaches
- **Vertical Scaling**: Adding more resources (CPU/RAM) to an existing instance.
  - Example: VMware ESXi.
- **Horizontal Scaling**: Adding or removing more instances/servers.
  - Example: Increasing from 1 to 5 servers while keeping individual resources the same.

**Cloud Native Tip**: Consider both vertical and horizontal scaling. Cloud-native apps often use **HPA** (Horizontal Pod Autoscaler) heavily.

### Important Considerations
- **Automation** is critical for effective scaling.
- Always test your automation strategy thoroughly.
- Consider **concurrency** limits.
- **Cluster Autoscaler**: Tool to adjust the number of nodes in the cluster (popular GitHub project).
- **HPA vs VPA**:
  - **HPA** (Horizontal Pod Autoscaler): Increases/decreases the number of pod replicas.
  - **VPA** (Vertical Pod Autoscaler): Adjusts resource requests/limits for pods.
- **KEDA** (Kubernetes Event-Driven Autoscaling): Scales based on events and supports **scaling to zero** (great for cost savings). Knative also supports scale-to-zero.
- HPA updates ReplicaSets (in Deployments), StatefulSets, and any scalable resource exposing the scale sub-resource.
- HPA decisions are based on metrics (CPU, memory, and custom metrics).

---

## 22 - Serverless

**Key Idea**: "Serverless" still involves servers — they are just **someone else’s servers** (managed by the cloud provider).

- You don’t manage or maintain servers.
- You interact via code.
- Removes operational burden.

**Common Example**: AWS Lambda (FaaS — Function as a Service)
- Upload code as a zip.
- **Event-driven** architecture.
- Billed only for execution time (pay-per-use).
- Auto-scaling is built-in and can **scale to zero**.

**Other Concepts**:
- **Provisioned Concurrency**: Controls the number of instances ready to run simultaneously.
- **Knative** & **OpenFaaS**: Serverless frameworks on Kubernetes that auto-provision load balancers and pods.
- **CloudEvents Specification**: CNCF standard for describing event data in a common format. Has SDKs for most languages.

---

## 24 - Community and Governance (CNCF)

- **Examples**: Envoy and Prometheus are CNCF projects.

### Project Maturity Levels
- **Sandbox** → **Incubating** → **Graduating**
- Crossing from Incubating to Graduating is the hardest (“Crossing the Chasm”).

### Adoption Curve
- **Innovators**: Use Sandbox projects.
- **Early Adopters / Visionaries**: Use Incubating projects.
- **Early Majority / Pragmatists**: Adopt before full graduation.
- **Late Majority / Conservatives**: Prefer Graduated projects.
- **Laggards**: Only use when forced (competition pressure).

Projects must demonstrate maturity to the **CNCF Technical Oversight Committee (TOC)**.

### Governance
- Elections and voting occur when consensus fails.
- Votes can be binding or non-binding.
- **SIGs** (Special Interest Groups): Focused groups anyone can join to contribute — great entry point for open source.
- **TAGs** (Technical Advisory Groups): Provide guidance across domains.

**KCD**: Kubernetes Community Days — community-led, CNCF-supported, local events (smaller scale).

---

## 27 - Common Personas / Roles

- **DevOps Engineer**: Full-stack infra + dev skills. Provisioning, automation, networking, scripting. Strong advocacy and change-driving mindset.
- **SRE (Site Reliability Engineering)**: Originated at Google (2003). Focuses on **reliability**, uptime, resilience, and rapid incident resolution.
  - Key artifacts: **SLA**, **SLO**, **SLI**.
- **Cloud Ops Engineer**: Focused on deploy/operate/monitor in cloud environments. Tools like Ansible.
- **Security Engineer**: Holistic security view — attack vectors, best practices, defense-in-depth.
- **DevSecOps Engineer**: Combines Development + Security + Operations.
- **Full Stack Developer**: Frontend, backend, databases, frameworks (web + desktop).
- **Cloud Architect**: Chooses platforms, designs multi-cloud strategies, evaluates tools, ensures interoperability. Strong soft skills required.
- **Data Engineer**: Focuses on data access at scale, distributed processing, and algorithms.

---

## 30 - Open Standards

- **Docker** is the de facto container technology and a great example of open standards in practice.

### Open Container Initiative (OCI)
Managed by the Linux Foundation. Defines open standards for containers:

- **Image Spec**: Standard for container filesystem/images. Tools: Docker, Podman, BuildKit, Buildah.
- **Runtime Spec**: How to run a filesystem bundle. Reference implementation: **runc**. Others: Kata Containers, gVisor.
- **Distribution Spec**: Image distribution (e.g., Docker Hub).

### Other Important Interfaces
- **CNI** (Container Network Interface): Used in Kubernetes to make nodes “Ready”. Can be overridden. Popular: Flannel, Calico, Cilium.
- **CSI** (Container Storage Interface): Rook is a graduated CNCF project implementing this.
- **CRI** (Container Runtime Interface): Used by kubelet to talk to container runtimes (e.g., containerd).

### runc vs containerd
- **runc**: Low-level OCI runtime. Only creates and starts containers.
- **containerd**: Higher-level daemon/orchestrator. Handles image pull, lifecycle, storage. Used by Docker and kubelet.

**Flow**: `kubectl/Docker → containerd → runc → Linux Kernel`

**SMI** (Service Mesh Interface): Another important standard.

---

## 32 - Introduction to Containers

**Core Concepts**: Namespaces + **cgroups** (most important).

- **chroot**: Changes the root directory of a process for isolation (but IP/network still shared).

**Namespaces** = Logical isolation of resources:
- User, PID, Network, Mount, UTS, IPC

**cgroups** (Control Groups):
- Isolate and prioritize resources.
- Control actions (start/stop/freeze).
- **cgroups v2** is the modern preferred version.

**Docker** popularized containers by combining namespaces + cgroups. Containers share the host OS kernel.

---

## 36 - Container Images

- **Container Image**: Portable, self-contained bundle of an application and its dependencies.
- OCI-compliant images work across Docker, Kubernetes, etc.
- **Container**: A running instance of an image.
- **Digest**: Checksum (SHA) of the image for integrity.

---

## 39 - Running Containers

- `docker version` — Check installed Docker version.
- **containerd**: Graduated CNCF project (donated by Docker).
- **runc**: Donated to OCI by Docker.

---

## 42 - Container Networking & Ports

- Port format: `80/tcp` = container port (internal only).
- Example output: `0.0.0.0:32768->80/tcp` → Host port 32768 maps to container port 80.

**Example Command**:
```bash
docker run -d --rm -p 12345:80 nginx
```
→ Maps host port **12345** to container port **80**.

---

## 51 - Container Orchestration

Container orchestration automates the management of containers — provisioning, deployment, scaling, self-healing, scheduling, and service exposure.

**Kubernetes** won the orchestration war. Others (OpenShift, Docker Swarm, Nomad) have much smaller adoption.

---

## 53 - Kubernetes Architecture

### Control Plane (Master)
Where cluster management components run.

- **Low-level Runtime**: runc (OCI reference). Alternatives: crun, Kata, gVisor.
- **High-level Runtime**: **containerd** (manages full lifecycle: pull, store, run, networking).
- **kubelet**: Agent on every node (including control plane).
- **Static Pods**: Defined via manifest files on disk.

**Key Control Plane Components**:
- **etcd**: Strongly consistent key-value store (source of truth). Use odd number of nodes + Raft consensus.
- **kube-apiserver**: Central hub. All communication goes through its REST API.
- **kube-scheduler**: Assigns pods to nodes.
- **kube-controller-manager**: Control loops that move cluster toward desired state.
- **kube-proxy**: Handles networking rules (TCP/UDP/SCTP). Runs on all nodes.
- **CoreDNS**: In-cluster DNS server.
- **Cloud Controller Manager**: Cloud provider integration (load balancers, etc.).

### Worker Nodes
- Run application workloads.
- Contain: runc + containerd + kubelet + kube-proxy + CNI plugin.

### Networking
- **CoreDNS**: “How do I find you?” (Service discovery)
- **CNI**: “How do I reach you?” (Pod networking)
  - Responsibilities when creating a pod: Add interface, assign IP, set up routes, apply network policies.

**Popular CNIs**: Flannel, Calico, Cilium.

---

## 60 - Kubernetes Pods (Part 1)

- Smallest deployable unit in Kubernetes.
- Can contain one or more tightly coupled containers.
- Containers in the same pod:
  - Share the same network namespace (communicate via `localhost`).
  - Share the same IP address.
  - Can communicate via IPC.
- Encapsulates app + dependencies + storage + networking.

**Tip**: For remote clusters, use `kubectl port-forward` to access pods locally.

---

**Notes cleaned, grammar fixed, structure improved, and technical terms standardized.**  
Let me know if you'd like me to expand any section, add diagrams, create flashcards, or continue with the next topics!