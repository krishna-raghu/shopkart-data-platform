locals {
  services = toset([
    "sqladmin.googleapis.com",
    "datastream.googleapis.com",
    "bigquery.googleapis.com",
    "dataform.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com"
  ])
}

resource "google_project_service" "services" {
  for_each = local.services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}