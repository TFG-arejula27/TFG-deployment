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

#instalamos prometheus
kubectl apply -f prometheus/.
#instalamos openFaas
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml

helm repo add openfaas https://openfaas.github.io/faas-netes/

export TIMEOUT=2m

helm repo update \
 && helm upgrade openfaas --install openfaas/openfaas \
    --namespace openfaas  \
    --set functionNamespace=openfaas-fn \
    --set generateBasicAuth=true \
    --set gateway.upstreamTimeout=$TIMEOUT \
  	--set gateway.writeTimeout=$TIMEOUT \
  	--set gateway.readTimeout=$TIMEOUT \
  	--set faasnetes.writeTimeout=$TIMEOUT \
  	--set faasnetes.readTimeout=$TIMEOUT \
  	--set queueWorker.ackWait=$TIMEOUT


PASSWORD=$(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode) && \
echo "OpenFaaS admin password: $PASSWORD" 

echo "Open faas desplegado, procedemos a exponerlo e iniciar sesión"
sleep 40 #wait until service is up

kubectl port-forward -n openfaas svc/gateway 8080:8080 &

sleep 5
OPENFAAS_URL="127.0.0.1:8080"

faas-cli login -g ${OPENFAAS_URL} -u admin --password ${PASSWORD}
faas-cli version

#grafana
kubectl apply -f grafana/.

sleep 25
kubectl port-forward svc/grafana 3000:3000 &
