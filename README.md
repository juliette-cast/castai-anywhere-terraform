# CAST AI Anywhere Terraform Deployment

This repository contains Terraform code to deploy CAST AI components on an "anywhere" (on-prem/Minikube) Kubernetes cluster. The configuration deploys two components:

- **CAST AI Agent** (required)
- **CAST AI Cluster Controller** (optional)

The CAST AI Agent collects metrics and manages workload configurations to optimize your cluster. The Cluster Controller (if enabled) performs additional cluster operations.

## Prerequisites

Before deploying, ensure you have the following installed and configured:

- **Terraform** (v1.x recommended)  
  [Download Terraform](https://www.terraform.io/downloads)
- **Minikube**  
  [Start Minikube](https://minikube.sigs.k8s.io/docs/start/)
- **Docker Desktop** (make sure Docker is running)  
  [Download Docker Desktop](https://www.docker.com/products/docker-desktop)
- **kubectl**  
  [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- **Helm**  
  [Install Helm](https://helm.sh/docs/intro/install/)

You will also need:
- A valid **CAST AI API Key** (https://docs.cast.ai/docs/authentication)
- A unique cluster identifier (for example, `minikube-anywhere-cluster`)

## Repository Structure

- **main.tf**  
  Contains the Terraform configuration to:
  - Start Minikube and wait until it is ready.
  - Configure the Kubernetes and Helm providers (using the `minikube` context).
  - Create the required namespace.
  - Deploy the CAST AI Agent.
  - Optionally deploy the CAST AI Cluster Controller.
- **variables.tf**  
  Defines variables for your CAST AI API key and cluster identifier.
- **outputs.tf**  
  Displays outputs such as the status of the deployed components.

## Setup and Deployment

### 1. Clone the Repository

Clone the repository to your local machine:

```sh
git clone https://github.com/juliette-cast/castai-anywhere-terraform.git
cd castai-anywhere-terraform
```

### 2. Initialize Terraform

Run the following command to initialize Terraform and download the required providers:

```sh
terraform init
```

### 3. Validate the Terraform Configuration

Ensure the configuration is correct:

```sh
terraform validate
```

### 4. Plan the Deployment

Preview what Terraform will create:

```sh
terraform plan
```

### 5. Apply the Configuration

Deploy the CAST AI Agent and optional components:

```sh
terraform apply
```

### 6. Verify Deployment

Check the status of deployed components:

```sh
kubectl get pods -n castai-agent
```

Expected output:
```sh
NAME                                          READY   STATUS    RESTARTS   AGE
castai-agent-597c687958-9gq4p                 1/1     Running   0          2m
```

### 7. Check CAST AI Console

1. **Log in to [CAST AI Console](https://app.cast.ai)**
2. **Navigate to `Clusters`**
3. **Confirm that the Minikube cluster is "Connected"**

### 8. Optional: Destroy the Deployment

If you need to remove the deployment, run:

```sh
terraform destroy
```
