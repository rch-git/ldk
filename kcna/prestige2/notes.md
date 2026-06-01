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

## 85. Kubernetes Jobs

completions

desired number of successfully finished pods that the job should run with. null means success one is success of all. 

parallelism

max. desired pods the job should run at a given time. actual number in steady state is less than this number when completions - successful < 1 i.e. when work left is less than max parallelism. 

completion 20 (job creates 20 pods)
parallelism 5 (no more than 5 pods are active at any given time)

deleting a job will terminate all the pods. 

cron jobs - time based job scheduler. 

crontab.guru

successfuljobshistorylimit: 3

## 89. Kubernetes ConfigMaps

--from-literal=color=red --from-literal=key=value

--from-env-file to load from a file

## 92. Kubernetes Secrets

secret is an object that can be used to store senitive information. password, tokens, keys. 

no need to include confidential information in application. 

base64 encoded. 

kubectl create secret generic color-secret --from-literal=color=red --from-literal=key=value

stored in etcd unencrypted. etcd access should be restricted. 

secretRef instead of configMapRef

## 96. Kubernetes Labels

labels in k8s are fundaments in identifying and organizing resources. 

assigning metadata to k8s objects. 

tagging resources. 

identify individual or groups of resources. ex - app1 or team1

a service can use label secletor to identify pods to route traffic to. 

ci cd pipeline can be use lables for deploying. 

load balancing and network policies to define rules for pod communication. 

create scopes for environments in k8s cluster. dev, test, prod. 

thoughtful label strategy = better administration. 

run: nginx 

selector
run: nginx

when we expose a service, the label is used as a selector. 

kubectl get all --selector run=nginx

## 98. Kubernetes Annotations

annotations are metadata along with labels. they are not a replacement for labels. 

labels are for identification and selection. annotations are for descriptive and instructive metadata - not for identification or selection. 

operational metadata, trigger behavior, controller configuration, build info. 

ex - 

annotations:
company.org/owner: "platform-team"
company.org/ticket: "ops-1234"
company.org/note: "This is a note"

changing annotation will trigger a new replicaset. this is important metadata. 

## 102. Kubernetes Startup, Liveness and Readiness Probes

there are three types of probes for apps in k8s. 

startup - has the app finished starting. pending or failing at this stage does not run liveness or rediness

liveness - should k8s restart this container. is this pod still alive? kubelet will restart this container based on restart policy. 

rediness - should pod receive traffic? if it fails, removed from service backends. 

k8s does not show a steady stream of success. only failures show in kubectl describe. 

## 105. Kubernetes API

The KCNA Examination focusses on the theory of the API and particular attention should be made for the following areas -

    How CRD's can be used to extend the Kubernetes API

    How to list resource types in a cluster

    The use of --authorization-mode

    The main three stages a request will pass through on its journey via the API server
    
primary interface for users and system components

restfulapi

users interact with api using kubectl, helm and client libraries. create deployments, services etc. 

monitoring tools, internal components. 

kubescheduler uses api to track state of pods, nodes, scheduling pods onto nodes. 

kubelet uses api to report status of nodes and pods on the node. receive instructions on which pods to run. 

kube api server can use admission controller to enforce rules. 

- request arrival, https endpoint, listening on 6443
- route matching (based on url, and method get, post put, delete)
- authentication (does it include a api key)
- authorization (if --authorization-mode is not set in api server, defaults to alwaysallow)
- admission controller
- validation (checks request data for format etc.)
- request handling (passed to function)
- response generation
- response sending

crd - custom resource definition

- way to define new resource types
`apiVersion: mysql.oracle.com/v2`
`kind: InnoDBCluster`

kubectl is a warapper to the api. 

kubectl apt-resources 

`kubectl proxy &` will serve on 8001 locally, no authentication needed and have to use http. 

”Rule #7: Deprecated behaviors must function for no less than 1 year after their announced deprecation.”

https://kubernetes.io/docs/reference/using-api/#api-versioning

## 110. Kubernetes RBAC

method of regulating access to resources inside the cluster. 

policy based access for users, groups and service accounts.

kubeconfig is the starting point of rbac. 

certificate-authority-data, client-certificate-data, client-key-data

when cluster is created, ca is setup. for creating and verifying certificates. ca public cert allows verifying the authenticity of the server for the client. 

`subject: O = system:masters, CN = system:admin`

with rbac k8s is not concerned with managing users or groups. there is no concept of users or groups. k8s expects certificates with subject identifier. 

user john doe
country usa

CN=john doe
O=USA

ownership of certificate with private key proves who the user is. if it is signed, k8s respects this as a valid user and group. we permission the users and groups with rbac. 

`kubectl get clusterrolebindings`

users - individuals or applications that interact with cluster. 

users are not managed by k8s. they are assumed to be managed by an external entity. 

groups are also typically managed outside of k8s. 

groups are a way to attach some users to a set of permissions. 

service accounts are used by applications. not by humans. service accounts are k8s objects. they are managed by k8s. they are used to give app running in pod to give necessary permissions. 

cluster role is a non namespaced resource. applies to entire cluster. 

clusterrolebinding binds a clusterrole to a service account. 

system:admin -> system:masters -> cluster-admin role via crb. 

kubectl describe ClusterRole/cluster-admin

resources *.*
Verbs [*]

kubectl auth can-i '*' '*' //resource verb

role - namespace - grants specific permissions within a namespace
rolebinding - namespace - binds users/groups/service accounts to a role within a namespace
clusterrole - clusterwide - grants permissions to resource across cluster
clusterrolebindings - clusterwide - binds users, groups, service accounts to a clusterrole. 

From a KCNA examination viewpoint, it is important to be aware that by default, a Pod will be assigned the ‘default’ Service Account in that Namespace.

## 117. Kubernetes Scheduler and NodeName

## 121. Kubernetes Taints and Tolerations

taints are applied to nodes. should not accept any pods that do not have matching toleration. 

tolerations are applied to pods. allowing them to scheduled on nodes with matching taints. 

kubeadm can have taints that prevent pods from running on control plane nodes. 

k3s, microk8s remove taints. pods can run on control plane. 

format for taint - key=value:effect

noschedule - pods currently running on the node are not evicted. 

noexecute - pods are evicted. 

deployments are a better use case for pods because they handle evictions better.

pods have to fulfill all taints. 

## 124. Kubernetes Affinity

requiredDuringSchedulingIgnoredDuringExecution - hard rule. The scheduler must place the pod only on nodes that match the affinity rules, or the pod will remain unscheduled. 
preferredDuringSchedulingIgnoredDuringExecution - soft rule. The scheduler tries to place the pod on matching nodes when possible, but it can still schedule the pod elsewhere if no matching node is available.

node affinity - pin workloads to nodes
pod affinity/anti-affinity - co locate pods, or separate them
preferred affinity - bias placement

kubernetes scheduling = filters + scoring

preferred affinity = score boost
required affinity = filter

nodeSelectorTerms:
- matchExpressions:
  - key: disktype
    operator: In
    values:
    - ssd
    
affinity uses labels. not taints and tolerations. 

weight from each rule defined in the pod spec is summed across entire node. weights contribute to the overall node score. node with the highest score wins. 

pod affinity - pods should run on the same node.
anti pod affinity - pods should not run on the same node. 

topologyKey - scope or boundary of where these rules should be applied. 

narrower the scope, more precise the placement control. 

hostname = node
zone = availability zone
region = geographic region

spec:
  affinity:
    podAffinity: #another pod should be running with the same value
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: role
            operator: In
            values:
            - backend
          topologyKey: kubernetes.io/hostname
          
if one pod ends up on worker-1, then pod with this spec will end up on the same node.

spec:
  affinity:
    podAntiAffinity: #another pod should be running with the same value
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: role
            operator: In
            values:
            - backend
          topologyKey: kubernetes.io/hostname

## 128. Kubernetes Storage

What is Ephemeral Storage
- does not survive restarts. used as required. discarded after use. EmptyDir - good example, which serves as temp directory for apps. it is a scratch space. check pointing for long computation. emptyDir.medium field set to memory will give us cache like file system. 


What is Persistent Storage

- storage persists removal of container. 


storage class - k3ks has persistent storage backed by host (local-path)
pv - persistent volume is created from storage class. persistent volume. 
pvc - persistent volume claim is made and assigned to pv. 

claims must be in the same namespace as pods. 

manual - create pv, and the pvc ourselves. 
dynamic - create pvc against storage class, which creates pv. will be in pending until it is used. yaml will not contain volume name. 

they differ in reclaim policies. 

- delete - default. deleted when claim is released. default when pv is dynamically created.
- recycle - scrub operation
- retain - data is kept until the volume is deleted. default when pv is manually created. 

Most important - local-path storage will persist only on the node the the pod starts the first time. if the pod starts on a different node, the data is gone. use node selectors to work around this. backend storage does not traverse nodes. 


What is Rook
- open source persistent storage offering. rook.io. distributed storage systems into self managing, scaling and healing storage system. Rook (specifically Rook-Ceph) is the Kubernetes operator that installs, configures and manages Ceph to expose those storage types as Kubernetes PersistentVolumes. https://rook.io/docs/rook/v1.12/Getting-Started/quickstart

What is Ceph
- Ceph, by contrast, is the distributed storage platform itself. It provides object, block and file storage in one unified system, and is widely used as a backend for cloud-native and virtualized workloads. 

The relationship between Rook and Ceph (Rook is designed to ease the orchestration of Ceph in Kubernetes)


## 132. Kubernetes StatefulSets

The purpose of StatefulSets

- workload api objects that are used to manage stateful applications. deployments are typically stateless - applying a volume makes is somewhat stateful. 
- stateful sets have no concept of replicasets. maintain stick identity for pods. pods create their own pvc. 3 pods will result in 3 pvcs and 3 volumes. 
- stable unique network identifiers
- stable persistent storage
- ordered graceful deployment and scaling
- ordered automatic rolling updates

stateful sets cannot be created by cli. deployment and statefulset have mostly identical spec. serviceName gives stable network id. kind: StatefulSet. 

pods have statefulsetname-0, -1, -2 etc. 

partition is a way to restrict updates to certain pods. partition: 2 means only pods with "-2" or greater will be updated. 

deleting a pod in statefulset will recreate the pod. 

if the entire statefulset is deleted, pvcs and pvs still exist. recreating the statefulset will reuse pvs and pvcs. 

The difference/similarities between StatefulSets and Deployments

The StatefulSet relation/dependency on Services for naming and how this can be used to provide stable names, for the StatefulSet

## 135. Kubernetes NetworkPolicies

network policies can restrict ingress (incoming traffic inside the cluster) or egress (outgoing traffic) to pods. one way to do this is by matching labels.

## 138. Kubernetes Ingress

has a limited role in kcna. api gateway is more widely used.

manage external access to services inside the cluster.

ingress controller receives and forwards the traffic. also responsible for securing and controlling traffic.

multiple routing rules into a single resource. better for scaling. can provide ssl and tls termination. centralized point of management.

typically clusters do not contain ingress controller. public cloud providers may include ingress offerings that integrate with provider.

kubernetes-ingress - F5 nginx open source implementation
ingress-nginx - retired. this is an open source impelmentation that is no longer receiving updates.

ingress API in kubernetes is not deprecated. it is in GA - general availability. gateway api is considered a successor, but ingress API is not deprecated.

helm is the easiest way to get kubernetes-ingress.

`kubectl get ingressclass`

in managed k8s environments the default is set.

pod label -> service (selector) -> endpoint slice.

`kubectl create ingress minimal-ingress --class=nginx-example ==rule="/testpath*=test:80" -o yaml --dry-run=client`

## 143. Kubernetes Gateway API

L4 and L7 routing. next gen successor to ingress api.

generic, role oriented.

concers: path and hostname routing, tls termination.

gateway api splits configuration into management chuncks across resources.

platform teams define controllers, app teams define how traffic routed.

gateway class - defined which controller will implement dateway. nginx, envoy.

gateway - namespaced resource. network entry point. port, protocol, tls, makes use of gateway class.

httproute - namespaced. http or grpc routing rules. match condition and backend ref to services. parent ref links to one or more backend services.

policy filter - optional object.

expressive and consistent. supports multi controller setup as standard. no relying on controller specific annotations.

role oriented design.

platform team - install and control gateway controllers ex - nginx

cluster operator - own gateway objects. specify LBs, IPs, ports hostnames, tls settings.

app teams - they create HTTPRoute resources. they use parentRefs.

security team - cluster wide policy. referencegrants.

setup helm
install gateway api crds
install nginx gateway controller
deploy demo backends
create a dateway
create httproutes
test routing
add tls termination
httpp -> https redirect
weight routing