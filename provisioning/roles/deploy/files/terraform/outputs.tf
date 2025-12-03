output "namespace" {
  description = "Kubernetes namespace"
  value       = kubernetes_namespace.notesapp.metadata[0].name
}

output "ingress_host" {
  description = "Ingress hostname"
  value       = var.ingress_host
}

output "application_url" {
  description = "Application URL"
  value       = "http://${var.ingress_host}"
}
