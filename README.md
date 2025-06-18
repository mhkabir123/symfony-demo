
# Symfony Demo Application Deployment on GKE

This project demonstrates the deployment of a Symfony PHP application on a managed Kubernetes cluster using **Google Kubernetes Engine (GKE)**. The application is exposed externally via the **NGINX Ingress Controller**.

---

## 🚀 Deployment Instructions

Follow the steps below to deploy and access the Symfony application:

1. **Clone the Repository**

   ```bash
   git clone https://github.com/mhkabir123/symfony-demo.git
   cd symfony-demo
   ```

2. **Make the Setup Script Executable**

   ```bash
   chmod +x setup.sh
   ```

3. **Run the Setup Script**

   This will deploy all required Kubernetes resources.

   ```bash
   ./setup.sh
   ```

4. **Update Your Local Hosts File**

   After deployment, the script will output an external IP address. Add the following entry to your `/etc/hosts` file:

   ```
   <INGRESS_IP> symfony-php-demo.com
   ```

   Replace `<INGRESS_IP>` with the actual IP provided by the script.

---

## ✅ What This Setup Includes

- **Symfony Application Deployment**  
  The main application is deployed using a Kubernetes `Deployment` and depends on a `Job` for running database migrations.

- **NGINX Ingress Controller**  
  If an ingress controller is not already installed, the setup script will deploy it from the `ingress-controller/` directory.

- **External Access**  
  The application becomes accessible via `https://symfony-php-demo.com` with proper TLS termination.

---

## 🔧 Components Overview

### Deployments
- The main application is deployed via a Kubernetes `Deployment`.
- It uses the image: `mhkabir/symfony-demo:v5` from Docker Hub.
- The application pod starts **only after** the PHP migration job completes.

### StatefulSet (PostgreSQL)
- PostgreSQL is deployed using a `StatefulSet` for persistence and stable identity.
- It uses `volumeClaimTemplates` and `volumeMounts` to retain database data.

### Horizontal Pod Autoscaler (HPA)
- The application is configured with HPA to auto-scale based on CPU utilization.
- **Note:** The [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server) must be installed.

### Database Migration Job
- A Kubernetes `Job` ensures the database schema is migrated before the application starts.
- It waits for PostgreSQL availability before execution.

### Ingress Resource
- An `Ingress` object provides external HTTPS access.
- TLS certificates are stored as Kubernetes secrets.

### RBAC: Roles & RoleBindings
- Three sets of `Role` and `RoleBinding` are used to grant the required permissions to each service account.

### Secrets and TLS
- Two Kubernetes secrets:
  - One for database connection strings and credentials.
  - One for TLS (used by Ingress to serve HTTPS).

### Service Accounts
- Dedicated service accounts are assigned to:
  - Symfony application
  - Database migration job
  - PostgreSQL

### Namespace
- The namespace used for deployment can be customized in the `setup.sh` script via the `NAMESPACE` variable.

---

## 📊 Installing the Metrics Server (If Not Already Installed)

To enable resource-based scaling (HPA), you must have the Kubernetes Metrics Server running.

### Install Metrics Server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Verify Installation

```bash
kubectl get deployment metrics-server -n kube-system
kubectl get pods -n kube-system | grep metrics-server
```

---

## 📦 Container Image

A public Docker container image of the Symfony application is available:

```text
mhkabir/symfony-demo:v5
```

This image is used during deployment by the Kubernetes resources.

---

## 📬 Contact & Contributions

Feel free to open issues or submit pull requests if you'd like to contribute or encounter any problems during deployment.

---
