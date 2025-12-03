# API Deployment
resource "kubernetes_deployment" "api" {
  metadata {
    name      = "notes-api"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
    labels = {
      app = "notes-api"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "notes-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "notes-api"
        }
      }

      spec {
        container {
          name  = "api"
          image = var.api_image

          port {
            container_port = 5000
          }

          env {
            name  = "DB_HOST"
            value = "notes-db"
          }

          env {
            name = "DB_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name = "DB_NAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "database"
              }
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }

          resources {
            requests = {
              memory = "128Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "256Mi"
              cpu    = "200m"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.postgres]
}

# API Service
resource "kubernetes_service" "api" {
  metadata {
    name      = "notes-api"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
  }

  spec {
    selector = {
      app = "notes-api"
    }

    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}
