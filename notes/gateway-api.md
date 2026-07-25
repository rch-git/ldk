**Kubernetes Gateway API** is the official next-generation (successor) API for L4/L7 traffic routing, load balancing, and service networking in Kubernetes. It is designed to be more expressive, extensible, portable, and role-oriented than the older Ingress API.

It is **not** part of core Kubernetes. You install the CRDs + a controller/implementation (e.g., Envoy Gateway, Istio, NGINX Gateway Fabric, etc.). For the KCNA exam, focus on the conceptual model, the three core resources, the role separation, and why it improves on Ingress.

### Core Resources (know these well)

**1. GatewayClass**
- Cluster-scoped resource that acts as a **template/blueprint**.
- Defines a class of Gateways managed by a specific controller (`spec.controllerName`).
- Typically owned/managed by the **infrastructure provider** or cluster operator.
- Similar in spirit to IngressClass, but more formal and central to the model.
- Example idea: “This class is handled by the cloud load-balancer controller” or “this class is handled by Envoy Gateway.”

**2. Gateway**
- Defines an **instance** of traffic-handling infrastructure (the actual entry point — e.g., a load balancer or proxy).
- Must reference exactly one `GatewayClass` via `gatewayClassName`.
- Configures **Listeners** (port, protocol such as HTTP/HTTPS/TCP, TLS settings, hostnames, etc.).
- Represents the north-south entry point into the cluster.
- Typically managed by the **cluster operator**.
- One Gateway can be shared by many applications (via multiple routes).

**3. HTTPRoute**
- Defines the actual **HTTP routing rules**.
- Attaches to one or more Gateways using `parentRefs`.
- Matches traffic on host, path, headers, query parameters, HTTP methods, etc.
- Forwards traffic to backends (usually Services), supports weighted traffic splitting, redirects, rewrites, header modification, etc.
- Typically owned by the **application developer**.
- This is where most of the expressive power lives compared to Ingress.

**Relationship summary (important for exam):**  
GatewayClass → Gateway (references the class) → HTTPRoute (attaches to the Gateway via parentRefs).  
There is a clear separation of concerns between these objects.

### Why Gateway API is better than Ingress (high-value exam points)

| Aspect                  | Ingress                                      | Gateway API                                      |
|-------------------------|----------------------------------------------|--------------------------------------------------|
| **Role separation**    | Mixed (one resource often owned by app teams) | Explicit personas: Infrastructure Provider, Cluster Operator, Application Developer |
| **Features**           | Basic host/path + TLS; advanced features via annotations | Native support for header matching, traffic weighting, redirects, rewrites, method/query matching, etc. |
| **Extensibility**      | Heavy reliance on implementation-specific annotations | Structured extension points (more portable)     |
| **Protocols**          | Primarily HTTP/HTTPS                         | Native L4 (TCP/UDP) + L7 (HTTP, gRPC, TLS routes, etc.) |
| **Sharing**            | Limited                                      | Designed for shared Gateways across teams       |
| **Portability**        | Annotation differences break portability     | Standardized core behavior + conformance tests  |

**Key reasons it is preferred / the successor:**
- Role-oriented design enables clean multi-team / multi-tenant usage.
- Advanced traffic management is first-class instead of annotation hacks.
- Better standardization and portability across controllers.
- Supports more protocols and use cases natively.
- Clear hierarchical model (Class → Gateway → Route).

### Exam-relevant details to remember
- Gateway API is explicitly described as the **successor** to Ingress (common question pattern).
- Main stable resources you need to know: **GatewayClass**, **Gateway**, **HTTPRoute**.
- It is role-oriented / separates concerns between infrastructure and application teams.
- It is implemented via CRDs + external controllers (not core Kubernetes).
- It provides richer, standardized routing without relying on annotations.
- One Gateway can serve many HTTPRoutes (shared infrastructure model).

For KCNA you do **not** need deep YAML syntax, specific controller configuration, or advanced experimental features (GAMMA mesh support, etc.). Focus on the conceptual model, the three core objects, the role separation, and the advantages over Ingress.