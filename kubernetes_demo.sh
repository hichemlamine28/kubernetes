#!/bin/bash


# next, try to run following kubectl commands to view cluster and node status
kubectl cluster-info
kubectl get nodes


# Verify the status of pods in kube-system namespace,
kubectl get pods -n kube-system
kubectl get nodes


# Test Your Kubernetes Cluster Installation, To test Kubernetes installation, let’s try to deploy nginx based application and try to access it.
kubectl create deployment nginx-app --image=nginx --replicas=2

kubectl get deployment nginx-app

# Expose the deployment as NodePort,
kubectl expose deployment nginx-app --type=NodePort --port=80


# Run following commands to view service status
kubectl get svc nginx-app
kubectl describe svc nginx-app


# Use following curl command to access nginx based application, (see previous command to get port)
curl http://<woker-node-ip-addres>:31246





## https://labs.play-with-k8s.com/

# Online Platform to explore and learn and use jubernetes
# Everything on browser, No installation or setup required
# 4 hours time limit | max instance 8
# To login use github or dockerhub
