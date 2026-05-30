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

- Use curl pod for accessing pods etc. 

using sleep infinity is a good option to make a ubuntu or other such pods stay running. following this, we can exec into the pod. pid 1 in the pod is going to be sleep infinity. 

in newer version of kubernetes use --now to shut down the pod right away. 

## 61 - Kubernetes Pods (Part 2)

kubectl can be used to create yaml. 

restartPolicy : always, never, onfailure. 

kubectl explain can be used. kubectl explain pod.spec.restartPolicy

create, replace, delete are imperative command. 

kubectl apply is a declarative command. 

## 62 - Kubernetes Pods (Part 3)

sidecar - container on the side. used to carry out a specific task on the side. 

if there are two container on a pod, they share an ipaddress. 

in a kubernetes cluster limits - 
- 5000 nodes max
- 110 pods/node
- 150,000 pods
- 300,000 containers

## 66. Kubernetes Pods Troubleshooting

- kubectl describe
- kubectl logs
- kubectl exec

very useful for troubleshooting

pod lifecycle
- pending - k8s knows about this pod
- containerCreating
- running - main process is running
- invalidimagename
- errimagepull - registry doesnt exist, cant talk to registry etc. 
- imagepullbackoff
- succeeded
- completed - container exited and the pod keeps restarting
- runcontainererror - if a bad argument is passed to pid 1. like 'sleeep'. 

pending with no node assigned is usually a scheduling problem. 
pending with a node assigned is typically an image or container problem

os based images usually have a default command like bash. if no sleep infinity is passed, it will exit immediately because no command is sent to bash. 

kubectl logs -p <container name> can be used to view previous logs. only works when container is restarted. 

kubectl logs ubuntu --all-containers -f --tail=20

kubectl exec ubuntu -c ubuntu -- env to get all the environment variables. 

## 69. Kubernetes Namespaces

fundamental to dividing resources. 

town - cluster
house - namespace
room - pod
furniture - containers

- isolation
- resource management per namespace
- security - rbac
- organization - rbac

kube-node-lease - hold objects associated with nodes. can send heartbeat to detect node failure. 
kube-public - for resources that should be readable to the entire cluster. 

kubectl api-resources will show whether or not a resource is namespaced. 

kubectl config view will show the default context. 

kubectl config set-context --current --namespace=mynamespace

## 72. Kubernetes Deployments and ReplicaSets

kubernetes deployment is a resource object. declarative updates for applications. allow outline application lifecycle. images, pod replicas. designed to update app predictably. maintain availability. deployment makes sure the number of pods is as expected. updates are phased out gradually to prevent all instances from being updated simultaneosly. 

rollbacks happen when something goes wrong. makes updates safer. 

deployments manage replicasets. declarative way to deploy manage applications. 

deployments automatically create replicasets. append an identifier. 

deployments have a rollout history. 

kubectl annototate kubernetes.io/change-cause will update the field. 

strategy - maxSurge (increase the number of pods by 25% of desired), maxUnavailable (up to 25% of the pods can be unavailable during updates)

kubectl rollout undo deployment/nginx

4th revision becomes 6th revision when we do an undo. 

deleting deployment will delte replicasets. 

In a Pod the spec for the Pod itself starts at the top level - spec

In a Deployment, the spec for the Pod starts at spec.template.spec

## 76. Kubernetes DaemonSets

Ensure that a pod runs on every node. 

CNI, security, logging are common daemonsets. 

daemonset is a kubernetes resource that ensures that all nodes run a copy pod. when a new node is added, daemonset ensures that the pod starts on the node. 
- logging (filebeat), monitoring, networking. 

daemonset is a deployment for nodes. one pod per node. 

there is no kubectl command for creating a daemonset. create a deployment and make changes instead. 

there is no concept of replicas or strategy in daemonset. 

## 79. Kubernetes Kubectl Set Image & Patch

setimage is a convenience command. designed specifically for updating container images

especially useful with deploymnets. it will kick off a rolling update. 

kubectl patch is more general purpose. any part of the resource spec can be updated by spending partial spec. 

kubectl set image pod/nginx *=nginx:stable

kubectl set image deployment/web *=nginx:alpine-slin; kubectl rollout status deployment/web

when using a deployment, a new replicaset is created when the image changes. 

kubectl patch is more powerful. can send a partial update to the api server. 

kubectl patch uses strategic merge. this means the contents of the patch is merge with what exists. 

if the patch modifies the spec with an entirely new image with a different name, then a new pod is created. 

patch uses jsonpatch. 

## 82. Kubernetes Services

a default service in kubernetes is a clusterip

dns name: curl <service-name>.<namespace-name>.svc.cluster.local

we can expose a deployment as a nodeport

80:12345/tcp
- 80 is the port the application is listening to
- 12345 is the port each kubernetes node is listening on

external name is a cname

