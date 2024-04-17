#!/bin/bash

sudo apt update -y

sudo apt install apt-transport-https -y

sudo apt install docker.io -y

# Fix docker to run without sudo
sudo usermod -aG docker ${USER}
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker
sudo systemctl enable containerd.service
docker --version
# Allow to use docker without sudo without restart. This command must be used for each terminal
newgrp docker


sudo apt install curl -y

sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo hostnamectl set-hostname "master-node" 
exec bash

new_entries="
192.168.1.21 master-node
192.168.1.83 worker1
192.168.1.72 worker2
"

# Vérifie si les nouvelles entrées existent dans /etc/hosts
if ! sudo grep -qF "$new_entries" /etc/hosts; then
    # Les nouvelles entrées n'existent pas, donc on les ajoute
    echo "$new_entries" | sudo tee -a /etc/hosts > /dev/null
    echo "Les entrées ont été ajoutées au fichier /etc/hosts."
else
    echo "Les entrées existent déjà dans le fichier /etc/hosts."
fi



# To configure the IPV4 bridge on all nodes, execute the following commands on each node.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params 
sudo sysctl --system




sudo apt-get update -y
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
sudo mkdir -p /etc/apt/keyrings



sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"


sudo apt update -y
sudo apt install -y containerd.io


containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml


sudo systemctl restart containerd
sudo systemctl enable containerd


# sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Download public signing key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


# Add kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


# Install kubeadm, Kubectl, Kubelet
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl





# On all nodes
sudo mkdir -p /opt/bin/
sudo curl -fsSLo /opt/bin/flanneld https://github.com/flannel-io/flannel/releases/download/v0.19.0/flanneld-amd64
sudo chmod +x /opt/bin/flanneld
sudo ufw enable


# On master
sudo ufw allow 6443/tcp
sudo ufw allow 2379:2380/tcp
sudo ufw allow 10250/tcp
sudo ufw allow 10259/tcp
sudo ufw allow 10257/tcp
sudo ufw allow 9090/tcp
sudo ufw allow 9099/tcp
sudo ufw allow 9100/tcp
sudo ufw status


# Pull images kubeapi server, kube controller manager, kube-schedular, etcd, kube-proxy, coredns ...
sudo kubeadm config images pull
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.138 --cri-socket=unix:///run/containerd/containerd.sock
# sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.21 --cri-socket=unix:///run/containerd/containerd.sock

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl cluster-info

# Flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

# Calico
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/canal.yaml -O
kubectl apply -f canal.yaml

#kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f  https://calico-v3-25.netlify.app/archive/v3.25/manifests/calico.yaml


# OR only if problem with previous (eviction problems)
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/tigera-operator.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/custom-resources.yaml -O
sed -i 's/cidr: 192\.168\.0\.0\/16/cidr: 10.244.0.0\/16/g' custom-resources.yaml
kubectl create -f custom-resources.yaml




kubectl get pods --all-namespaces


# Get the worker join command
sudo kubeadm token create --print-join-command



# On Worker node
sudo ufw allow 10250/tcp
sudo ufw allow 30000:32767/tcp
sudo ufw allow 9090/tcp
sudo ufw allow 9099/tcp
sudo ufw allow 9100/tcp
sudo ufw status



sudo kubeadm join 192.168.1.21:6443 --token <token> --discovery-token-ca-cert-hash <sha256:...........>
# No need, just for test
### sudo kubeadm init --config kubeadm-config.yml




# # # # next, try to run following kubectl commands to view cluster and node status
# # # kubectl cluster-info
# # # kubectl get nodes



# # # # Install Calico Network if needed
# # # kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/calico.yaml


# # # # Verify the status of pods in kube-system namespace,
# # # kubectl get pods -n kube-system
# # # kubectl get nodes


# # # # Test Your Kubernetes Cluster Installation, To test Kubernetes installation, let’s try to deploy nginx based application and try to access it.
# # # kubectl create deployment nginx-app --image=nginx --replicas=2

# # # kubectl get deployment nginx-app

# # # # Expose the deployment as NodePort,
# # # kubectl expose deployment nginx-app --type=NodePort --port=80


# # # # Run following commands to view service status
# # # kubectl get svc nginx-app
# # # kubectl describe svc nginx-app


# # # # Use following curl command to access nginx based application, (see previous command to get port)
# # # curl http://<woker-node-ip-addres>:31246




# TIP
# If the joining code is lost, it can retrieve using below command

kubeadm token create --print-join-command

#To install metrics server
git clone https://github.com/mialeevs/kubernetes_installation_docker.git
cd kubernetes_installation_docker/
kubectl apply -f metrics-server.yaml
cd
rm -rf kubernetes_installation_docker/
