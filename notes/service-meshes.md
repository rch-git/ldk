**Service Meshes – KCNA-relevant points only**

### Core Definition
A **service mesh** is a dedicated infrastructure layer that handles **service-to-service (east-west) communication** in a microservices architecture.  

It adds capabilities **transparently** (without changing application code) such as traffic management, security, and observability.  

It is one of the defining elements of cloud-native architecture (alongside containers, microservices, immutable infrastructure, and declarative APIs).

### Architecture (Most Important Exam Fact)
Every service mesh has two main parts:

| Component       | Role                                                                 | Typical Implementation                  |
|-----------------|----------------------------------------------------------------------|-----------------------------------------|
| **Data Plane**  | Handles actual traffic (proxying, encryption, metrics, routing)     | Sidecar proxies running next to each service |
| **Control Plane** | Configures and manages the data plane (policies, certificates, discovery, routing rules) | Central management components |

**Exam-critical answer**: The two common components of a service mesh are the **service proxy** and the **control plane**.

### Sidecar Pattern
- The dominant deployment model.
- A lightweight **proxy container** (most commonly **Envoy**) is injected into the **same Pod** as the application container.
- All inbound and outbound traffic from the application goes through the sidecar.
- This is what enables the mesh features without modifying application code.

### Key Capabilities Provided by a Service Mesh
These are the reasons you use one (and what the exam expects you to know):

- **Traffic management**: Advanced load balancing, retries, timeouts, circuit breaking, canary/A-B testing, fault injection, traffic shifting.
- **Security**: **Mutual TLS (mTLS)** for encryption + authentication between services, plus fine-grained authorization policies.
- **Observability**: Automatic collection of metrics, logs, and distributed traces for all service-to-service traffic.
- Service discovery and resilience features (beyond what basic Kubernetes Services provide).

### Popular Service Meshes (Know the names)
- **Istio** — Feature-rich, uses Envoy proxy (most frequently mentioned).
- **Linkerd** — Lightweight, CNCF graduated project.
- Others that sometimes appear: Consul Connect, Cilium (eBPF-based).

### Relation to Kubernetes
- Kubernetes **Services** give you basic service discovery + Layer-4 load balancing.
- A service mesh sits **on top** of that and adds Layer-7 features, strong security (mTLS), and rich observability.

### Service Mesh Interface (SMI)
A specification that defined a common, portable set of APIs so different service meshes could be used in a more interchangeable way on Kubernetes. (It has been archived, but the concept of a standard interface still appears in some study materials.)

### What You Do *Not* Need for KCNA
- Specific Istio CRDs (VirtualService, DestinationRule, Gateway, etc.)
- Detailed configuration or installation steps
- Deep comparison of performance or operational complexity between meshes
- How to write mesh policies

**Bottom line for the exam**:  
Know the definition, the **sidecar + control plane / data plane** architecture, the main benefits (especially **mTLS**, traffic control, and observability), and the two most common examples (**Istio** and **Linkerd**).