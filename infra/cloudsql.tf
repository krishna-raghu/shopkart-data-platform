resource "random_password" "postgres" {
  length  = 20
  special = false
}

resource "google_sql_database_instance" "source" {
  name             = "retail-oltp-${var.environment}"
  database_version = "POSTGRES_16"
  region           = var.region

  settings {
    tier    = "db-f1-micro"
    edition = "ENTERPRISE"

    database_flags {
      name  = "cloudsql.logical_decoding"
      value = "on"
    }

    ip_configuration {
      ipv4_enabled = true

      authorized_networks {
        name  = "datastream-1"
        value = "34.89.121.226/32"
      }

      authorized_networks {
        name  = "datastream-2"
        value = "35.197.249.117/32"
      }

      authorized_networks {
        name  = "datastream-3"
        value = "34.105.244.177/32"
      }

      authorized_networks {
        name  = "datastream-4"
        value = "35.242.151.51/32"
      }

      authorized_networks {
        name  = "datastream-5"
        value = "35.189.120.213/32"
      }
    }
  }

  deletion_protection = false

  depends_on = [
    google_project_service.services
  ]
}

resource "google_sql_database" "retail" {
  name     = "retail"
  instance = google_sql_database_instance.source.name
}

resource "google_sql_user" "postgres" {
  name     = "postgres"
  instance = google_sql_database_instance.source.name
  password = random_password.postgres.result
}
resource "random_password" "datastream" {
  length  = 24
  special = false
}