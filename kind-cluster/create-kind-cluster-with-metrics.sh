#!/usr/bin/env bash

# Either pass a config file when running the script, or it will default to klc.yaml
KIND_CONFIG_FILE="${1: ~/git/ldk/kind-cluster/klc.yaml}"

# Get the cluster name from config file and if an error is encountered, set cluster name to klc
CLUSTER_NAME="$(yq '.name' "$(KIND_CONFIG_FILE)" 2>/dev/null || echo klc)"

# Create kind cluster
echo "[+] Creating Kind cluster: ${CLUSTER_NAME} using ${KIND_CONFIG_FILE}"
kind create cluster --config "${KIND_CONFIG_FILE}"

# Wait for core components and DNS to be healthy
echo "[+] Waiting for kube-system core pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n kube-system --timeout=300s || true

# Install metrics server using helm from official release
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm upgrade --install metrics-server metrics-server/metrics-server -n kube-system \
  --set args="{--kubelet-insecure-tls,--kubelet-preferred-address-types=InternalIP}"
