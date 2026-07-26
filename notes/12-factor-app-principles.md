**The Twelve-Factor App** is a methodology (from Heroku, documented at 12factor.net) for building portable, scalable, maintainable software-as-a-service applications that work well on modern cloud platforms.  

In the **KCNA exam** it falls under **Cloud Native Architecture** (a significant portion of the exam) and is frequently tested. You need to know what the methodology is, the list of the 12 factors, and especially the principles that directly enable cloud-native properties: portability, horizontal scalability, resilience, continuous deployment, and suitability for containers/Kubernetes.

### Goals of a 12-factor app (high-yield for exam)
- Declarative setup and maximum portability across environments.
- Clean contract with the OS (no reliance on specific server or system administration).
- Suitable for modern cloud platforms (containers + orchestration).
- Minimize divergence between development and production (supports continuous deployment).
- Scale without significant changes to architecture or tooling.

### The 12 Factors (with KCNA-relevant details)

1. **Codebase**  
   One codebase tracked in revision control, many deploys.  
   Single source of truth; the same code is deployed to multiple environments.

2. **Dependencies**  
   Explicitly declare and isolate dependencies.  
   No reliance on system-wide packages. Use a dependency declaration (e.g., `package.json`, `requirements.txt`, `go.mod`) + isolation (containers do this naturally via images).

3. **Config**  
   **Store config in the environment.**  
   Anything that varies between deploys (database URLs, credentials, feature flags, hostnames) must **not** be in the code. Prefer environment variables.  
   Litmus test: the codebase could be open-sourced without leaking secrets.  
   *Kubernetes mapping*: ConfigMaps, Secrets, and environment variables injected into Pods.

4. **Backing services**  
   Treat backing services as **attached resources**.  
   Databases, caches, message queues, SMTP, object storage, etc. are accessed via a URL or credentials in config. The app makes no distinction between a local MySQL and Amazon RDS (or any managed service). You can swap them by changing config only.  
   *Kubernetes mapping*: Services, externalEndpoints, or cloud-provider managed services referenced via config.

5. **Build, release, run**  
   Strictly separate the three stages.  
   - **Build** → turns code into an executable artifact (container image).  
   - **Release** → combines the build + config.  
   - **Run** → executes the release.  
   Releases are immutable and append-only; you never change code at runtime. This is the foundation of CI/CD and immutable infrastructure.

6. **Processes**  
   Execute the app as **one or more stateless processes**.  
   Processes are **share-nothing**. Any data that must persist goes into a backing service. Never store session state in memory or on the local filesystem (sticky sessions are forbidden).  
   This is one of the most important principles for Kubernetes — Pods are ephemeral.

7. **Port binding**  
   Export services via port binding.  
   The app is completely self-contained and binds to a port itself (it does not rely on an external web server being injected).  
   *Kubernetes mapping*: containerPort / targetPort in a Pod/Service.

8. **Concurrency**  
   Scale out via the **process model**.  
   Treat processes as first-class citizens. Scale horizontally by running more processes of the same type rather than making a single process bigger.  
   *Kubernetes mapping*: increasing `replicas` on a Deployment / ReplicaSet.

9. **Disposability**  
   Maximize robustness with **fast startup and graceful shutdown**.  
   Processes should start in seconds and shut down cleanly on `SIGTERM` (finish current work or return jobs to the queue). This enables rapid elastic scaling, rolling updates, and self-healing.  
   Extremely important for containers and Kubernetes (liveness/readiness probes, rolling updates, node drains).

10. **Dev/prod parity**  
    Keep development, staging, and production as similar as possible.  
    Same tooling, same backing services (or very close), same deployment process. Containers + Kubernetes make this much easier than traditional environments.

11. **Logs**  
    Treat logs as **event streams**.  
    The app never manages log files or log rotation. It writes unbuffered to `stdout`/`stderr`. The execution environment (Kubernetes + logging agents) is responsible for collection, aggregation, and routing.  
    *Kubernetes mapping*: container logs collected by the kubelet and shipped by tools such as Fluentd, Fluent Bit, or cloud logging agents.

12. **Admin processes**  
    Run admin/management tasks as **one-off processes**.  
    Database migrations, one-time scripts, console sessions, etc. should use the same codebase and config as the regular app processes, but run as discrete one-off jobs.  
    *Kubernetes mapping*: Jobs and CronJobs.

### Highest-yield points for the KCNA exam
- **Stateless processes + disposability** → why containers and Kubernetes work well (ephemeral Pods, horizontal scaling, self-healing).
- **Config in the environment** → why ConfigMaps/Secrets exist and why you never bake environment-specific values into images.
- **Logs as streams** → why applications should write to stdout and why the platform handles collection.
- **Backing services as attached resources** → loose coupling; swap databases or caches without code changes.
- **Build / release / run separation** → immutable container images + config injected at deploy time (CI/CD / GitOps friendly).
- Overall purpose: produce applications that are **portable, scalable, and resilient** on cloud platforms without special snowflake administration.

Memorize the list of the 12 factors and the short descriptions above. Focus extra attention on factors 3, 6, 9, 11, 4, and 5 — these are the ones most directly tied to cloud-native and Kubernetes behavior.