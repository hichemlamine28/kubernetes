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
192.168.1.138 master-node
192.168.1.72 worker-node1
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



# Download public signing key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubeadm, Kubectl, Kubelet
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


# # # # Install Kubernetes Cluster
# # # sudo kubeadm init --control-plane-endpoint=k8smaster.example.net

# # # mkdir -p $HOME/.kube
# # # sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# # # sudo chown $(id -u):$(id -g) $HOME/.kube/config

# # # # next, try to run following kubectl commands to view cluster and node status
# # # kubectl cluster-info
# # # kubectl get nodes


# # # # Join Worker node  example
# # # sudo kubeadm join k8smaster.example.net:6443 --token vt4ua6.wcma2y8pl4menxh2 \
# # #    --discovery-token-ca-cert-hash sha256:0494aa7fc6ced8f8e7b20137ec0c5d2699dc5f8e616656932ff9173c94962a36


# # # kubectl get nodes


# # # # Install Calico Network 
# # # kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml


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

