**Ingress and Ingress Controllers** are high-value conceptual topics on the KCNA exam (primarily under Container Orchestration / Networking).

### Ingress
An **Ingress** is a Kubernetes API object that manages **external HTTP/HTTPS access** to Services inside the cluster.

Key points to remember:
- It defines **routing rules** based on:
  - Hostname (name-based virtual hosting)
  - URL path
- It supports **TLS/SSL termination**, load balancing, and name-based virtual hosting.
- It works at **Layer 7** (application layer) — only for HTTP and HTTPS traffic.
- For non-HTTP traffic you still use Service types (`NodePort` or `LoadBalancer`).

**Most important exam fact**:  
Creating an Ingress resource **by itself does nothing**. It is only a set of rules (desired state). Something must implement those rules.

### Ingress Controllers
An **Ingress Controller** is the component that actually implements the rules defined in Ingress resources.

Key points:
- It continuously watches the Kubernetes API for Ingress objects and configures a reverse proxy / load balancer accordingly.
- It is **not** part of core Kubernetes — you must deploy one (usually as a Deployment + Service).
- Popular examples you should recognize: **NGINX Ingress Controller**, Traefik, HAProxy, Contour, cloud-provider controllers (GCE, AWS ALB, etc.).

**Critical relationship**:
| Component          | Role                                      | Does it route traffic? |
|--------------------|-------------------------------------------|------------------------|
| Ingress resource   | Declares the rules (host + path → Service)| No                     |
| Ingress Controller | Implements the rules                      | Yes                    |

### Other Exam-Relevant Details
- You can run **multiple** Ingress Controllers in the same cluster. You select which one handles a particular Ingress via the `ingressClassName` field (and `IngressClass` resources).
- Ingress is more efficient than creating a separate `LoadBalancer` Service for every HTTP application — one external endpoint can route many apps via host/path rules.
- TLS certificates are usually stored as Kubernetes Secrets and referenced in the Ingress.
- The Ingress API is stable but frozen. The recommended long-term replacement is the **Gateway API**, but KCNA still focuses on classic Ingress.

### Quick Mental Model for the Exam
Think of it like this:
- Service (`LoadBalancer` / `NodePort`) → “Expose this application”
- Ingress + Controller → “Expose *many* HTTP applications smartly under one entry point with host/path rules and TLS”

The single most commonly tested idea is: **an Ingress object is useless without a running Ingress Controller**.