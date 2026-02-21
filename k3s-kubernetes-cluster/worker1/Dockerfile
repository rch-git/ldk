#Dockerfile for control-plane container. Use this command to build the image: 
# docker build -t worker-image .

FROM	ubuntu:22.04

# Make apt package installation use defaults and not prompt the user. This is needed for docker builds which cannot accept user input 
# during container creation.
ENV	DEBIAN_FRONTEND=noninteractive

# --no-install-recommends will disable installing recommended packages to reduce size
RUN	apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		iptables \
		iproute2 \
		bash \
		tzdata \
		openssh-server \
		&& rm -rf /var/lib/apt/lists/*

# Download k3s binary directly (NO installer, NO systemd)
RUN curl -L https://github.com/k3s-io/k3s/releases/latest/download/k3s \
    -o /usr/local/bin/k3s \
    && chmod +x /usr/local/bin/k3s \
    && ln -s /usr/local/bin/k3s /usr/local/bin/kubectl \
    && ln -s /usr/local/bin/k3s /usr/local/bin/crictl \
    && ln -s /usr/local/bin/k3s /usr/local/bin/ctr

# create the directories that are used by k3s

RUN	mkdir -p /var/log/k3s	/etc/rancher/k3s

# sshd runtime dir
RUN mkdir -p /var/run/sshd

CMD	["sleep", "infinity"]
