# Symfony Application Deployment on GKE (Case-1)

The test has been successfully performed on a managed Kubernetes cluster (GKE),
using the NGINX Ingress Controller for external access.

#Instructions to Deploy and Access the Symfony Application:

1. Make the setup script executable:

    $ chmod +x setup.sh

2. Run the setup script to deploy all required resources:

    $ ./setup.sh

This will:
- Deploy the Symfony application to your cluster
- Set up the Ingress resource
- Automatically map the domain to your cluster's external IP in '/etc/hosts'
- Make the application accessible via 'https://symfony-php-demo.com'


## Container Image

A Docker container image for the Symfony application has been built and published publicly to Docker Hub:

    "mhkabir/symfony-demo:v1"

This image is pulled and used during deployment by the Kubernetes resources.
