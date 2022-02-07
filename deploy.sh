#!/bin/bash


echo "comprobaciones previas..."
helm version >/dev/null 2>&1
if [ $? -gt 0 ];then
  echo "helm not installed"
  exit 1
fi
echo "todo ok, lanzamiento de máquinas"
#lanzamos las VMs mediante vagrant
cd vagrantk3s && vagrant up --no-paralle
cd ..

#instalamos openFaas
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml

helm repo add openfaas https://openfaas.github.io/faas-netes/

helm repo update \
 && helm upgrade openfaas --install openfaas/openfaas \
    --namespace openfaas  \
    --set functionNamespace=openfaas-fn \
    --set generateBasicAuth=true


PASSWORD=$(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode) && \
echo "OpenFaaS admin password: $PASSWORD" 
