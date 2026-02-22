#!/usr/bin/env bash

###################################################################################################
# Run the script: bash ~/git/ldk/kind-cluster/create-kind-cluster-with-metrics.sh
# Or
# Make this script executable - chmod +x ~/git/ldk/kind-cluster/create-kind-cluster-with-metrics.sh
# Run the script: ~/git/ldk/kind-cluster/create-kind-cluster-with-metrics.sh
###################################################################################################

# Exit immediately upon failure, treat unset vairables as an error & exit, and first nonzero exit code for any pipeline portion
set -euo pipefail

# Either pass a config file when running the script, or it will default to klc.yaml
KIND_CONFIG_FILE="$HOME/git/ldk/kind-cluster/klc.yaml"

# Get the cluster name from config file and if an error is encountered, set cluster name to klc
CLUSTER_NAME="$(yq '.name' "${KIND_CONFIG_FILE}" 2>/dev/null || echo klc)"

# Create kind cluster
echo "[+] Creating Kind cluster: ${CLUSTER_NAME} using ${KIND_CONFIG_FILE}"
kind create cluster --config ${KIND_CONFIG_FILE}

# Wait for core components and DNS to be healthy
echo "[+] Waiting for kube-system core pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n kube-system --timeout=300s || true

# Install metrics server using helm from official release. Ensure that metrics-values.yaml exists in the directory
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm upgrade --install metrics-server metrics-server/metrics-server -n kube-system -f ~/git/ldk/kind-cluster/metrics-values.yaml

# Verify readiness
echo "[+] Waiting for metrics-server to be available..."
kubectl rollout status -n kube-system deploy/metrics-server --timeout=300s
