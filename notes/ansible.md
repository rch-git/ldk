**Ansible – High-Level Overview (KCNA-Relevant)**

- **What it is**: Open-source automation/configuration management tool focused on infrastructure as code (IaC), application deployment, and orchestration. It is agentless and uses simple YAML playbooks.

- **Core model**: Declarative + imperative hybrid. You describe the desired state in playbooks; Ansible modules execute the necessary steps to reach it.

- **Key components**:
  - **Inventory** – List of managed hosts/groups (static files or dynamic from cloud/K8s sources).
  - **Playbooks** – YAML files that define tasks, roles, and workflows.
  - **Modules** – Reusable units of work (package install, service management, file copy, Kubernetes API calls, etc.).
  - **Roles** – Reusable, organized collections of tasks, variables, and handlers.
  - **Ansible Controller** – The machine that runs playbooks and connects to targets (typically via SSH or API).

- **Why it matters for cloud-native / KCNA**:
  - Automates Kubernetes cluster bootstrap, node configuration, and day-2 operations.
  - Manages application deployments and configuration across hybrid/multi-cloud environments.
  - Complements Kubernetes by handling the underlying OS, networking, and non-containerized components.
  - Supports GitOps-style workflows when combined with version control and CI/CD.
  - Works well alongside other CNCF/cloud-native tools (Terraform for provisioning, Helm/Operators for K8s apps, etc.).

- **Key characteristics relevant to cloud-native practices**:
  - Agentless (no daemon required on managed nodes → lower operational overhead).
  - Idempotent by design (safe to re-run).
  - Extensible via collections and the Kubernetes collection (ansible.kubernetes / community.kubernetes).
  - Push-based model that fits well with infrastructure automation outside the cluster.

- **Typical KCNA-aligned use cases**:
  - Preparing nodes and installing container runtimes / kubelet.
  - Configuring networking, storage, or security baselines for clusters.
  - Deploying and updating applications or supporting services around Kubernetes.
  - Automating repetitive operational tasks in a cloud-native platform.

Ansible is not a Kubernetes-native controller (like Operators or Helm), but it is a common tool in the broader cloud-native toolchain for infrastructure and configuration automation.