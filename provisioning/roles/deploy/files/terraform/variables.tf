variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "notesapp"
}

variable "api_image" {
  description = "Docker image for the API"
  type        = string
  default     = "souff1159/notes-api:v1"
}

variable "frontend_image" {
  description = "Docker image for the frontend"
  type        = string
  default     = "souff1159/notes-frontend:v1"
}

variable "db_image" {
  description = "Docker image for the database"
  type        = string
  default     = "postgres:15-alpine"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "notespass"
}

variable "ingress_host" {
  description = "Ingress hostname"
  type        = string
  # We'll update this later when we know the real IP.
  # For now put a placeholder:
  default     = "notes.127.0.0.1.nip.io"
}

