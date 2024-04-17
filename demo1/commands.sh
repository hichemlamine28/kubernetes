#!/bin/bash


kubectl apply -f deployment.yml
kubectl expose deployment tomcat-deployment --type=NodePort
kubectl get svc tomcat-deployment

