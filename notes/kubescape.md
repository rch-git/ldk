**Kubescape** is a CNCF incubating project (accepted to CNCF in 2022, promoted to incubating in early 2025) that provides open-source Kubernetes security posture management (KSPM).

### Most salient points for the KCNA exam

- **Purpose**: It scans Kubernetes environments for misconfigurations and vulnerabilities, then reports risk scores and compliance status. It is one of the main tools in the cloud-native security space for hardening clusters and shifting security left.

- **What it scans**:
  - Live clusters
  - Kubernetes YAML manifests
  - Helm charts
  - Container images / registries
  - Code repositories (in some workflows)

- **Frameworks it evaluates against** (high-value for exam questions):
  - NSA-CISA Kubernetes Hardening Guidance
  - CIS Kubernetes Benchmarks
  - MITRE ATT&CK®
  - Other compliance frameworks (and custom policies)

- **How it works at a high level**:
  - CLI for one-off or CI/CD/IDE scans (shift-left security)
  - In-cluster Operator for continuous monitoring and runtime insights
  - Uses Open Policy Agent (OPA)/Rego under the hood for many of its controls

- **Relevance to KCNA domains**:
  - Cloud Native Ecosystem & Architecture — know major CNCF projects in the security category
  - Cloud-native security principles — awareness of tools that help enforce least privilege, detect misconfigurations, and improve the security posture of clusters and workloads
  - It sits alongside other commonly referenced tools such as Falco (runtime threat detection), OPA/Gatekeeper (policy), and kube-bench (CIS checks)

**Exam tip**: You will not need deep configuration knowledge or command syntax. Focus on *what* it is (CNCF Kubernetes security scanner/posture tool), *what* it checks against (NSA-CISA, CIS, MITRE), and that it supports both pre-deployment (manifests/Helm) and runtime/cluster scanning.

That covers the level of detail expected on KCNA.