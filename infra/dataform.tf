# ------------------------------------------------------------
# Dataform Runtime Service Account
# ------------------------------------------------------------

resource "google_service_account" "dataform" {
  account_id   = "retail-dataform"
  display_name = "Retail Dataform Execution"
}


# ------------------------------------------------------------
# Current GCP Project
# ------------------------------------------------------------

data "google_project" "current" {
  project_id = var.project_id
}


# ------------------------------------------------------------
# Dataform Service Agent
# ------------------------------------------------------------

locals {
  dataform_service_agent = (
    "service-${data.google_project.current.number}@gcp-sa-dataform.iam.gserviceaccount.com"
  )
}


# ------------------------------------------------------------
# Allow Dataform Service Agent to impersonate runtime account
# ------------------------------------------------------------

resource "google_service_account_iam_member" "dataform_agent_user" {
  service_account_id = google_service_account.dataform.name

  role = "roles/iam.serviceAccountUser"

  member = (
    "serviceAccount:${local.dataform_service_agent}"
  )
}


# ------------------------------------------------------------
# Allow Dataform Service Agent to create tokens
# ------------------------------------------------------------

resource "google_service_account_iam_member" "dataform_agent_token_creator" {
  service_account_id = google_service_account.dataform.name

  role = "roles/iam.serviceAccountTokenCreator"

  member = (
    "serviceAccount:${local.dataform_service_agent}"
  )
}


# ------------------------------------------------------------
# Dataform Repository
# ------------------------------------------------------------

resource "google_dataform_repository" "warehouse" {
  provider = google-beta

  name   = "retail-enterprise-warehouse"
  region = var.region
}

resource "google_dataform_repository_release_config" "production" {
  provider = google-beta

  project    = google_dataform_repository.warehouse.project
  region     = google_dataform_repository.warehouse.region
  repository = google_dataform_repository.warehouse.name

  name          = "production"
  git_commitish = "main"

  code_compilation_config {
    default_database = var.project_id
    default_schema   = "warehouse_staging"
    default_location = var.region
    assertion_schema = "warehouse_assertions"
  }
}

resource "google_dataform_repository_workflow_config" "production_hourly" {
  provider = google-beta

  project        = google_dataform_repository.warehouse.project
  region         = google_dataform_repository.warehouse.region
  repository     = google_dataform_repository.warehouse.name

  name = "production-hourly"

  release_config = (
    google_dataform_repository_release_config.production.id
  )

  invocation_config {
    service_account = google_service_account.dataform.email

    transitive_dependencies_included = true

    fully_refresh_incremental_tables_enabled = false
  }

  cron_schedule = "0 * * * *"
  time_zone     = "Europe/London"
}