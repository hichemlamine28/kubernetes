#!/bin/bash
pip install fastapi
pip install uvicorn

pip install -r requirements.txt

mkdir app
cd app
touch _init_.py
code main.py


# To launch app
uvicorn main:app --reload



# To add item using str
curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:8000/items?item=apple'

# To get item
curl -X GET http://127.0.0.1:8000/items/0


# To get all items
curl -X GET http://127.0.0.1:8000/items?limit=3

# To add item using Item
curl -X POST -H "Content-Type: application/json" -d '{"text":"apple"}' 'http://127.0.0.1:8000/item'




# Visit this URL: http://localhost:8000/docs
# Visit this URL: http://localhost:8000/redoc



# Maintenant  go pour  Docker et Kubernetes ====>>>>

docker build -t k8s-fast-api .

# To run locally
docker run -p 8000:80 k8s-fast-api

# Tag image Rebuild or just tag)
docker build -t hichemlamine/k8s-fast-api:v1 .
# or just do this: docker tag k8s-fast-api hichemlamine/k8s-fast-api:v1

# Now push to registry
docker push hichemlamine/k8s-fast-api:v1

cd kubernetes
# Create deployment.yml + service.yml

kubectl apply -f .

kubectl get pods -w

kubectl port-forward <pod> 8080:80







# Very Useful for Kubeadm

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/baremetal/deploy.yaml


sudo snap install helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress --namespace ingress --create-namespace --set rbac.create=true,controller.kind=DaemonSet,controller.service.type=ClusterIP,controller.hostNetwork=true ingress-nginx/ingress-nginx
kubectl delete validatingwebhookconfiguration ingress-ingress-nginx-admission
