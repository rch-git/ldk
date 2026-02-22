# docker build -t kindest-node-image-with-utils .

FROM kindest/node:v1.35.0

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && \
    apt-get install -y software-properties-common --no-install-recommends && \
    apt-get install -y openssh-server iputils-ping curl bash iproute2 iptables tzdata ca-certificates nano git tree yq && \
    mkdir -p /var/run/sshd /root/.ssh && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    systemctl enable ssh && \
    # generate root key & enable passwordless SSH
    ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -N "" -q && \
    cat /root/.ssh/id_ed25519.pub >> /root/.ssh/authorized_keys && \
    # change permissions to authorized_keys file to -rw------- 
    # change permissions to ./ssh directory to drwx------
    chmod 600 /root/.ssh/authorized_keys && chmod 700 /root/.ssh && \
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ && \
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && \
    helm repo update && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 22
