**Kustomize (KCNA-relevant view)**

Kustomize is Kubernetes’ **native, template-free** way to customize YAML manifests. It is the main alternative to Helm in the Cloud Native Application Delivery domain.

### Core Idea You Must Remember
- You keep a single set of clean base manifests.
- You create **overlays** that describe only the differences for each environment (dev, staging, prod).
- Everything stays pure YAML — no templating language.

This is the most important conceptual point for the exam.

### How It Works
- A directory containing a file named `kustomization.yaml` (or `.yml`) is a **kustomization**.
- Kustomize reads that file, pulls in the listed resources, applies the declared customizations, and outputs the final set of manifests.

**Built into kubectl** (since 1.14):
- `kubectl apply -k <directory>` → apply the rendered manifests
- `kubectl kustomize <directory>` → just print the rendered YAML (very useful for understanding)

### Base vs Overlay (the key mental model)

| Concept   | Meaning |
|-----------|--------|
| **Base**  | Directory with the common, environment-agnostic resources + its own `kustomization.yaml`. A base has no knowledge of any overlay. |
| **Overlay** | Directory that points at one or more bases and adds environment-specific changes (patches, labels, replica counts, images, etc.). |

You almost always structure it as:
```
base/
  kustomization.yaml
  deployment.yaml
  service.yaml
overlays/
  dev/
    kustomization.yaml
  prod/
    kustomization.yaml
```

### Most Important Fields in `kustomization.yaml`

These are the settings worth knowing for KCNA:

- **`resources`**  
  List of YAML files or directories (bases) to include.  
  This is the foundation of every kustomization.

- **`namespace`**  
  Sets the namespace on every resource.

- **`namePrefix` / `nameSuffix`**  
  Prepends or appends a string to every resource name (very common for environment isolation).

- **`commonLabels` / `commonAnnotations`**  
  Adds the same labels or annotations to all resources.

- **`images`**  
  Changes container image name/tag/digest without writing a patch.  
  Extremely common pattern.

- **`configMapGenerator` / `secretGenerator`**  
  Generates ConfigMaps or Secrets from files, env files, or literal key-value pairs.  
  By default they get a content-hash suffix (you can disable this).

- **`patches`** (or the older `patchesStrategicMerge` / `patchesJson6902`)  
  Apply targeted modifications (change replica count, add resource limits, etc.).

### Why Kustomize Matters in the KCNA Context

| Topic | What the exam expects you to understand |
|-------|----------------------------------------|
| Application Delivery | Kustomize is a declarative, template-free configuration tool |
| vs Helm | Helm = package manager + templating; Kustomize = pure YAML overlays |
| GitOps | Works extremely well with GitOps tools (Flux has first-class Kustomize support) |
| Declarative nature | You describe the desired final state; Kustomize produces it |

### Quick Mental Checklist for the Exam
- Template-free → Kustomize  
- Charts + values.yaml + templating → Helm  
- Built into `kubectl` with `-k` flag → Kustomize  
- Base + overlays pattern → Kustomize  
- Generating ConfigMaps/Secrets with a content hash → Kustomize generators  

That is essentially everything you need for KCNA. The exam tests conceptual understanding of the base/overlay model and the difference from Helm, not deep syntax or advanced patch types.