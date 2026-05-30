## Tuesday, May 26, 2026, 4:59 AM CDT

#### AutoScaling

reactive, scheduled, predictive

what is auto scaling

pattern we can adopt for scaling of infrastructure. scaling up, down, sideways.

cpu, memory are the big metrics. depends on application also. think netflix - lot of transcoding. large reliance of gpu.

reactive vs proactive auto scaling. if we see a sudden increase in threshold, server scales up. this is reactive. great if workload can reactive quickly.

scheduled auto scaling, specific dates and times can be targeted for increased workload. end of month processing for banks.

- vertical scaling adding additional resources to existing components. vmware esxi is an example. 
- horizontal scaling - addition or removal of resources to existing resources. increasing the number of servers from 1 -> 5 while keeping the resources of individual services the same. 
- cloud native uses hpa more. 

consider both for cloud native application. 

automation is very important in scaling. 

also important to consider testing for automation strategy. also consider concurrency. 

cluster auto scaler is a tool used to adjust the cluster. there is a github project for this. 

horizontal and vertical pod autoscaler. hpa and vpa. hpa increases or decrease the number of replicas (pods). 

keda - kubernetes event driven autoscaling. keda can scale to zero. good from cost saving perspective. knative supports scale to zero. 

hpa in kubernetes updates replica sets in deployments (most common) and stateful sets. it also updates any scalable controllers that expose a scale interface. 

hpa makes decisions based on metrics. cpu and memory are starting points. 

#### 22 - Serverless

serverless involves server. serverless is someone else's server. we dont need to worry about managing and maintaining servers. cloud provider manages this. removes burden involved in maintenance. typically we interact with serverless offering via code. 

aws lambda common serverless. faas (function as service). upload code as a zip file. serverless is event driven architecture. billed when code runs. auto scaling is a core component of serverless offerings. it can scale to zero. this is built in. set thresholds based on cost considerations. 

provisions concurrency - number of instances that can run at the same time. 

knative and openfaas. serverless web app on top of kubernets, automatically create load blancer and pods. 

cloud event specification describes event data in common formats. hosted by cncf. there is sdk in most major languages and cover common protocols. 

#### 24 - Community and Governance

envoy and prometheus are a part of cncf. 

sandbox, incubating, graduating. crossing the chasm is the difficult area to cross between incubating to graduating. 

innovators are users who use sandbox projects. early adopters or visionaries who use incubating projects. the chasm is encountered. early majority or pragmatists who this project before graduation. this is followed by late majority or conservatives who use graduated projects. laggards are skeptics. those use the project when they are absolutely required, and are forced to use due to competition etc. 

projects demonstrate their maturity to CNCF technical oversight committee (toc). 

elections and voting happens at CNCF with regards to projects. discussion and reconciliation happen. elections and voting happens when no compromise can be reached. votes can be binding and nonbinding. 

sig - special interest groups that focus on a particular area of a project. anyone can join this group and contribute. good way to get involved in open source. 

tag - technical advisory groups for cncf projects. provide guidence across specific domains. coordinate needs of users. 

kcd - kubernetes community days. community led, cncf supported, local, smaller. 


#### 27 - Personas

dev ops engineer - skill set spans development and operations. all rounder. infrastructure provisioning, automation, networking, automation/scripting. advocacy is an important part of this role. ethos for driving change. 

sre (site reliability engineering) - founded by google in 2003. has a crossover with dev ops. a problem at google that affects 1% is a big problem. sre focuses more on reliability, up time, relilience. ability to rapidly resolve problems. creation and implementations of sla, slo (serice level objectives), sli (service level indicator). 

cloud ops engineer - paralles to dev ops and cloud ops. cloud ops has focus on deploy, operate and monitor. more aligned with cloud technology. ansible, etc. 

security engineer - specialized in it security. has a holistic view of security. attack vectors, best practices etc. 

dev sec ops engineer - security, operations and development. 

full stack developer - frontend development, web frameworks, frontend desktop frameworks, backend development, database.

cloud architect - decide target platforms, multi cloud, cloud tooling, interoperability, requirement evaluation, interpersonal skills.

data engineering - access to data, scale en-masse, distributed processing, algorithmic usage. 

#### 30 - Open Standards

Docker is an example of open standards. 

Docker is the defacto container technology

Open Container Initiative - Under the control of linux foundation. open standards for containers. 

- image specification (image spec) - It is the standard for file system in containers. Tools to build a file system into an image include docker, podman, buildkit and buildah. 

- Runtime specification (runtime spec) - how to run a filesystem bundle, download, unpack and run. RunC is lightweight tool for running OCI containers. kata containers, gvisor etc. are other implementations. 

distribution specification (distribution spec) - built on top of docker. ex - dockerhub. 

container network interface - knowingly or unknowlingly used in kubernetes. cni compatible implementation needs to be installed to transition a node from not ready to ready. CNI can be overridden. many CNI implementations available. 

container storage interface (csi) - rook (graduated cncf project)

container runtime interface (CRI) - used by kubelet to interact with containerd (which is a service that runs on top of RunC)

runc vs containerd

- runc is very low level. it runs the containers. single purpose of create and start containers. 
- containerd is high level. kubelet interacts with it. responsible for handling container lifecycle. pull and manage images. its the orchestrator. used by highlevel tools like docker. 

kublet/docker -> containerd -> runc -> linux kernel. 

containerd creates the pod. 

service mesh interface (smi). 

#### 32 - Introduction to Containers

Namespaces and Cgroups most important concepts. 

chroot - change the root directory of a running process. important for keeping process from accessing files its not supposed to use. ip addresses and other resources are still usable. 

namespaces is a logical grouping of resources. 

original namespaces - 

- user
- pid - independant process 
- network namespace - isolated network stack
- mount namespace - for mount points for filesystems
- uts (unix timesharing)
- ipc - inter process communication namespace

new namespace - 

- cgroups - control groups (most important). provide the ability to isolate resource units. prioritization -> which process has higher priority. ability to control process in a group (start, stop, frozen, restart). cgroups v2 is preferred. 

docker took namespaces (including cgroups) and created the containers. all containers share the os. 

#### 36 - Container Images

container image - portable self contained bundle of software 

oci compliant images can be used in docker, kubernetes etc. 

container - instance of software. 

digest is the checksum of an image. 

#### 39 - Running Containers

`docker version` command to run to get the version

containerd is a graduated cncf project donated by docker. 

runc is donated to oci by docker. 

#### 42 - Container Network Services and Volumes

80/tcp is the format for how ports is listed. its not accessible outside. that is the container port

0.0.0.0:32768->80/tcp means that locally, you can access the application on 32768 but inside the container it is running on 80

docker run -d --rm -p 12345:80 nginx

this will map 12345 on local to 80 inside the container. 

#### 51 - Container Orchestration Introduction

container orchestration is automating the operational need of running container. this provides standards and frameworks for deploying containerized applications. 

this excels in provisioning, deployment, availability, self healing, scheduling, exposing container services

kubernates won the orchestration race. open shift, docker swarm and nomad exist, but they are very small in footprint. 

#### 53 - Kubernetes Architecture

control plane - where most major components in kubernetes run

nodes - workloads run

control plane
- runc (namespaces and cgroups) this is the reference implementation of low level runtime. this is an oci compatible runtimes. crun, kataruntime, givzor are other alternatives. 
- typically this is not manually installed. 
- high level container runtime is installed. 
- containerd is donated to cncf by docker. this manages the entire container life cycle (pulling, storing, execution, networking). installing containerd via a package manager, it will install runc. 
- kubelet (present on control plane also). 
- static pods based on a directory. they communicate with kublet on nodes. 
    - etcd (strongly consistent key value store, headless elections, network partitions, source of truth.) multiple instances of etcd is recommend for prod. odd number is preferred. raft consensus is used by etcd. api server is the main component that talks to etcd. 
    - kubeapi server. central point of cluster. it is used by all users and components for access. provides restful api interface. stores all data in persistent storage backend. kubelet also talks to api server. kubectl communictes with control plane via api server. 
    - kube scheduler is a control plane process, and it is a static pod. determind which nodes are valid placement for pods. 
    - the controller manager are static pods on the control plane. they are control loops that monitor the state of cluster. they are responsible for moving the cluster towards the desired state. 
- kube proxy runs as a daemon set runs as a standard pod on the contol place. communicates with api server. configures tcp/udp/sctp on any system. runs on both control plane and node
- coredns is a dns server which is a kubernetes deployment. it is a normal pod. when a worker pod does a dns look up, it goes to coredns, and that replies in the form of a clusterip. 
- cloud controller manager - seen in public cloud providers. bridges functionality of cloud provider and cluster. integrate load balancer etc. 
    

node
- runc
- kubelet (present on node but not exclusive). maintains pods. makes use of podspec. can receive requests via api or by monitoring a directory.
- kube proxy runs as a daemon set runs as a standard pod on the contol place. communicates with api server. configures tcp/udp/sctp on any system. runs on both control plane and node

cni (container network interface)

- coredns - how do i find you?
- cni - how do i reach you. 

cni and coredns work together and solve different problems. 

cni is a contract between container runtime (via kubelet) and a plugin on each node.

when a pod is created - 

- add an interface to the pod
- assign an ip
- program routes so traffic can reach pods
- apply policy (optional)

modern cni
- flannel
- calico
- cilium

#### 60 - Kubernetes Pods - Part 1

- smallest unit of compute
- one or more containers
- containers will share networking and will communicate using localhost. 
- each pod has a unit ip address
- containers in a pod communicate using Inter process communicatiojn (ipc)
- a pod can encapsulate an application, its dependencies, shared storage, networking into a deployable unit. 

when running remotely, use kubectl port forwarding. 

