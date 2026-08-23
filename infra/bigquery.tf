locals {
  warehouse_datasets = {
    raw        = "warehouse_raw"
    staging    = "warehouse_staging"
    core       = "warehouse_core"
    marts      = "warehouse_marts"
    assertions = "warehouse_assertions"
  }
}

resource "google_bigquery_dataset" "warehouse" {
  for_each = local.warehouse_datasets

  dataset_id = each.value
  location   = var.region

  labels = {
    environment = var.environment
    layer       = each.key
  }

  delete_contents_on_destroy = true

  depends_on = [
    google_project_service.services
  ]
}