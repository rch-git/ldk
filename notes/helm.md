**Helm & Helm Charts — KCNA Exam Focus**

KCNA treats Helm under **Cloud Native Application Delivery**. You are expected to understand what it is, why it exists, the basic structure of a chart, the difference between a chart and a release, how values work, and the main lifecycle commands. You do **not** need deep template syntax or advanced chart development skills.

### 1. What is Helm?
Helm is the **package manager for Kubernetes** (CNCF graduated project).

It is to Kubernetes what `apt`/`yum` is to Linux or `npm` is to Node.js.  
It lets you:
- Package Kubernetes applications
- Configure them consistently
- Install, upgrade, and roll them back reliably
- Share them via repositories

Without Helm you manage many separate YAML files. With Helm you manage one packaged unit.

### 2. What is a Helm Chart?
A **chart** is a package that contains all the Kubernetes resource definitions needed to run an application, plus configuration and metadata.

Think of a chart as a versioned, reusable application package.

When you install a chart, Helm creates a **release** (a specific running instance of that chart in a cluster).

### 3. Chart Structure (must know)
A chart is a directory (or `.tgz` package) with this standard layout:

```
mychart/
├── Chart.yaml          # Required – metadata
├── values.yaml         # Required – default configuration values
├── templates/          # Required – Kubernetes YAML templates
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── _helpers.tpl    # Optional helper templates
│   └── NOTES.txt       # Optional post-install notes
├── charts/             # Optional – chart dependencies (subcharts)
└── crds/               # Optional – Custom Resource Definitions
```

**Key files and what they mean:**

| File / Directory | Purpose | Exam Relevance |
|------------------|---------|----------------|
| `Chart.yaml` | Metadata about the chart | name, version, description, apiVersion, appVersion, dependencies |
| `values.yaml` | Default configuration values | The main way to parameterize the chart |
| `templates/` | Go-templated Kubernetes manifests | These become real YAML after values are applied |
| `charts/` | Dependent charts | Subcharts that the main chart needs |
| `crds/` | CRDs | Installed first (before other resources) |

**Important `Chart.yaml` fields:**
- `apiVersion`: `v2` (Helm 3)
- `name`: Chart name
- `version`: Chart version (SemVer) — this is the package version
- `appVersion`: Version of the actual application (informational)
- `description`, `type` (`application` or `library`), `dependencies`

### 4. Core Concepts You Must Distinguish

| Term | Meaning |
|------|---------|
| **Chart** | The package / template (the “recipe”) |
| **Release** | A specific installed instance of a chart in a cluster |
| **Repository** | A collection of charts (public like Artifact Hub or private) |
| **Values** | Configuration parameters that customize the chart |

One chart can produce many releases (e.g., `myapp-dev`, `myapp-staging`, `myapp-prod`).

### 5. Values & Configuration (very important)
`values.yaml` holds the **default** settings.

You override them at install/upgrade time in two main ways:

- Command-line: `--set key=value` or `--set replicaCount=3`
- Values file: `-f myvalues.yaml` or `--values myvalues.yaml`

**Merge order** (highest priority wins):
1. Values passed with `--set`
2. Values files (`-f`)
3. Chart’s default `values.yaml`

Common flags related to values:
- `--reuse-values` → keep previous values on upgrade
- `--reset-values` → discard previous values and use only new ones
- `--set-string` → force a value to be treated as a string

Templates access values with `{{ .Values.something }}`.

### 6. Essential Commands (know what each does)

| Command | Purpose |
|---------|---------|
| `helm repo add <name> <url>` | Add a chart repository |
| `helm repo update` | Refresh local cache of charts |
| `helm search repo <keyword>` | Search for charts |
| `helm install <release> <chart>` | Install a new release |
| `helm upgrade <release> <chart>` | Upgrade an existing release |
| `helm upgrade --install ...` | Install if missing, otherwise upgrade (very common pattern) |
| `helm uninstall <release>` | Delete a release |
| `helm list` / `helm ls` | List releases |
| `helm status <release>` | Show status of a release |
| `helm history <release>` | Show revision history |
| `helm rollback <release> [revision]` | Roll back to a previous revision |
| `helm template <chart>` | Render templates locally (no install) |
| `helm package <chart-dir>` | Package chart into a `.tgz` |

Useful safety flags:
- `--atomic` → automatically roll back on failure
- `--wait` → wait until resources are ready
- `--dry-run` → simulate without applying

### 7. Why Helm Matters in the Cloud Native Ecosystem
- Makes complex applications **repeatable and versioned**
- Separates configuration from code (values vs templates)
- Works well with GitOps tools (Argo CD and Flux can deploy Helm charts)
- Provides built-in upgrade and rollback history
- Acts as a standard packaging format across teams and organizations

**Related tools you should contrast:**
- **Kustomize** → template-free, built into `kubectl`, good for simple overlays
- **Helm** → full packaging + templating + release management (better for sharing and complex apps)
- Plain YAML → fine for simple cases, becomes painful at scale

### 8. Quick Mental Model for the Exam
> Helm packages Kubernetes YAML into **charts**.  
> You install a chart → it becomes a **release**.  
> You configure the release with **values**.  
> You manage the lifecycle with `install` / `upgrade` / `rollback`.  
> Charts live in **repositories**.

That mental model covers the large majority of KCNA questions about Helm.

Focus on understanding the concepts above rather than memorizing every flag. The exam cares that you know *what* Helm is for and the basic building blocks of a chart and a release.