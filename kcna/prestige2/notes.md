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

