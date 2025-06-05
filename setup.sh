#!/bin/bash

NAMESPACE="demo-app"
INGRESS_NAMESPACE="ingress-nginx"
#INGRESS_URL="https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml"

echo "Installing NGINX Ingress Controller (if not already installed)..."
kubectl get ns $INGRESS_NAMESPACE >/dev/null 2>&1 || kubectl apply -f -n $INGRESS_NAMESPACE -f ./ingress-controller

echo "Waiting for Ingress controller to be ready..."
kubectl wait --namespace $INGRESS_NAMESPACE \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

echo "Waiting for the ingress controller to be assigned an external IP..."
while true; do
  INGRESS_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  if [[ -n "$INGRESS_IP" ]]; then
    echo "External IP assigned: $INGRESS_IP"
    break
  fi
  echo "⌛ Still waiting..."
  sleep 5
done

echo "Creating application namespace: $NAMESPACE"
kubectl get ns $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE


echo "Applying manifests from the same folder"
kubectl apply -n $NAMESPACE -f .

# Optional: Add to /etc/hosts

DOMAIN="symfony-php-demo.com"
echo "Mapping $DOMAIN to $INGRESS_IP in /etc/hosts (you may be prompted for sudo password)..."

if grep -q "$DOMAIN" /etc/hosts; then
  echo "Updating existing host entry..."
  sudo sed -i.bak "/$DOMAIN/d" /etc/hosts
fi
echo "$INGRESS_IP $DOMAIN" | sudo tee -a /etc/hosts > /dev/null

echo "🎉 Setup complete! The Application is running on namespace:'$NAMESPACE' and You can access the SYMFONY DEMO app at https://$DOMAIN"
