variable "cast_ai_api_key" {
  description = "Your CAST AI API key"
  type        = string
  # For demonstration, we set a default. In production, pass this as a variable instead.
  default     = "cece9b3a81982494ada68b6f658b509f2010a1e147552c522def15b768f0aab0"
}

variable "cluster_name" {
  description = "Name of your cluster"
  type        = string
  default     = "minikube-cluster"
}

# variable "cluster_id" {
#   description = "Identifier for your anywhere cluster (used as clusterName and clusterID)"
#   type        = string
#   default     = "794f9c72-1024-4127-87e3-3fa07179a287"
# }

