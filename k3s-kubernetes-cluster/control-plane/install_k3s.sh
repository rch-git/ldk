export INSTALL_K3S_SKIP_ENABLE=true
export K3S_KUBECONFIG_MODE="644"

curl -sfL https://get.k3s.io | sh -s - server --cluster-init
