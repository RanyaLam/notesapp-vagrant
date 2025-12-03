# PersistentVolumeClaim for database
resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

# ConfigMap for database initialization
resource "kubernetes_config_map" "db_init" {
  metadata {
    name      = "db-init-script"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
  }

  data = {
    "init.sql" = <<-EOT
      CREATE TABLE IF NOT EXISTS notes (
          id SERIAL PRIMARY KEY,
          content TEXT NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    EOT
  }
}

# Secret for database credentials
resource "kubernetes_secret" "db_credentials" {
  metadata {
    name      = "db-credentials"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
  }

  data = {
    username = base64encode("notesuser")
    password = base64encode(var.db_password)
    database = base64encode("notesdb")
  }

  type = "Opaque"
}

# Database Deployment
resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "notes-db"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
    labels = {
      app = "notes-db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "notes-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "notes-db"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = var.db_image

          port {
            container_port = 5432
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name = "POSTGRES_DB"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "database"
              }
            }
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }

          volume_mount {
            name       = "init-script"
            mount_path = "/docker-entrypoint-initdb.d"
          }

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "250m"
            }
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }
          }
        }

        volume {
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }

        volume {
          name = "init-script"
          config_map {
            name = kubernetes_config_map.db_init.metadata[0].name
          }
        }
      }
    }
  }
}

# Database Service
resource "kubernetes_service" "postgres" {
  metadata {
    name      = "notes-db"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
  }

  spec {
    selector = {
      app = "notes-db"
    }

    port {
      port        = 5432
      target_port = 5432
    }

    type = "ClusterIP"
  }
}
