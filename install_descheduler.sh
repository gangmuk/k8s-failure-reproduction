
# install kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash

# move kustomize executable to bin path
sudo mv kustomize /usr/local/bin

# install descheduler
kustomize build 'github.com/kubernetes-sigs/descheduler/kubernetes/deployment?ref=v0.26.0' | kubectl apply -f -
