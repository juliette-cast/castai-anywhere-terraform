# Start Minikube using the Docker driver
resource "null_resource" "start_minikube" {
  provisioner "local-exec" {
    command = "minikube start --driver=docker"
  }
}

# Wait for Minikube to be ready
data "external" "wait_for_minikube" {
  program = ["bash", "-c", "while ! kubectl get nodes >/dev/null 2>&1; do sleep 5; done; echo '{}'"]
  depends_on = [null_resource.start_minikube]
}

# Configure the Kubernetes provider to use the minikube context
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"

}

# Configure the Helm provider using the same minikube context
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }

}

# Create the namespace "castai-agent" with the required Helm metadata
resource "kubernetes_namespace" "castai" {
  depends_on = [data.external.wait_for_minikube]
  metadata {
    name = "castai-agent"
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name"      = "castai-agent"
      "meta.helm.sh/release-namespace" = "castai-agent"
    }
  }
}

# Install CAST AI Agent using the Helm chart with an increased timeout
resource "helm_release" "castai_agent" {
  depends_on       = [kubernetes_namespace.castai]
  name             = "castai-agent"
  repository       = "https://castai.github.io/helm-charts"
  chart            = "castai-agent"
  namespace        = "castai-agent"
  create_namespace = false
  timeout          = 600  # Wait up to 10 minutes

  set {
    name  = "apiKey"
    value = var.cast_ai_api_key
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  # Explicitly set the provider to "anywhere" so the agent knows its running in an on-prem cluster.
  set {
    name  = "provider"
    value = "anywhere"
  }
}

# resource "helm_release" "castai_cluster_controller" {
#   depends_on       = [helm_release.castai_agent]
#   name             = "castai-cluster-controller"
#   repository       = "https://castai.github.io/helm-charts"
#   chart            = "castai-cluster-controller"
#   namespace        = "castai-agent"
#   create_namespace = false
#   timeout          = 600

#   set {
#     name  = "castai.clusterID"
#     value = var.cluster_id
#   }
#   set {
#     name  = "provider"
#     value = "anywhere"
#   }
#   set {
#     name  = "apiKey"
#     value = var.cast_ai_api_key
#   }
# }
