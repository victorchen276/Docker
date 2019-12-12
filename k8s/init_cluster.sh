#！/bin/bash

#must use the static ip
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.99.100

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# kubeadm join 192.168.99.100:6443 --token 8umkfm.fy3l9wasvnn43vdu \
#     --discovery-token-ca-cert-hash sha256:4258ef401a46e6c83c1bd821398ff91c96ce3c77995954e6dd91adb7a8426c03 

#get the join command
# kubeadm token create --print-join-command