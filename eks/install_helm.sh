#!/bin/bash
cd ~/environment

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh

chmod +x get_helm.sh

./get_helm.sh


# Configure Helm access with RBAC
# Helm relies on a service called tiller that requires special permission 
# on the kubernetes cluster, so we need to build a Service Account for tiller to use. 
# We’ll then apply this to the cluster.
# To create a new service account manifest:
cat <<EoF > ~/environment/rbac.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EoF

kubectl apply -f ~/environment/rbac.yaml
helm init --service-account tiller
helm completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion