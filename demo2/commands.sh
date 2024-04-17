#!/bin/bash

docker build -t my-image .

docker tag my-image hichemlamine/k8s-repo:v1

docker images # docker image ls

docker login

docker push hichemlamine/k8s-repo:v1

kubectl get pods
kubectl get deploy


kubectl create deployment app-deploy --image hichemlamine/k8s-repo:v1 

kubectl get deployment

kubectl describe deployment app-deploy

kubectl get pods
kubectl describe pod <name>

kubectl get services

kubectl expose deployment app-deploy --port=80 --type=NodePort

kubectl get svc

kubectl describe svc app-deploy


