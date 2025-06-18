#!/bin/bash

NAMESPACE="demo-app"
INGRESS_NAMESPACE="ingress-nginx"

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

echo "Creating application namespace: $NAMESPACE if not exists"
kubectl get ns $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE


echo "Applying manifests from the same folder"
kubectl apply -n $NAMESPACE -f .

# Optional: Add to /etc/hosts

DOMAIN="symfony-php-demo.com"
echo -e "\n\033[1mAdd following entry to the hosts file, /etc/hosts:\033[0m"
echo -e "$INGRESS_IP $DOMAIN"
echo -e "\n🎉 Setup complete! The Application is running on namespace:'\033[1m$NAMESPACE\033[0m' and You can access the SYMFONY DEMO app at \033[1mhttps://$DOMAIN\033[0m"
