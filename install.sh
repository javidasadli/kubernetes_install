swapoff -a
nano /etc/fstab
# Uncomment swap
apt-get update
apt-get install openssh-server
apt-get install -y docker.io
systemctl enable docker.service
apt-get update && apt-get install -y apt-transport-https curl
apt install gnupg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
            deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl
nano /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Add the line below to this file!
# Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"

#Master

kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=10.100.141.215
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml 
kubectl get pods -o wide --all-namespaces

kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml


kubeadm join 10.100.141.213:6443 --token 4oa1ft.1gxfhiq0eumu9u5q --discovery-token-ca-cert-hash sha256:734ca8484da4363dbb4ec7ce1dfa85700632f50b43abcd8bd9def045caf769a6
