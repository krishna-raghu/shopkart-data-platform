# ------------------------------------------------------------
# Dataform → BigQuery Job User
# ------------------------------------------------------------

resource "google_project_iam_member" "dataform_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"

  member = (
    "serviceAccount:${google_service_account.dataform.email}"
  )
}


# ------------------------------------------------------------
# Dataform → RAW Dataset Reader
# ------------------------------------------------------------

resource "google_bigquery_dataset_iam_member" "dataform_raw_reader" {
  dataset_id = google_bigquery_dataset.warehouse["raw"].dataset_id

  role = "roles/bigquery.dataViewer"

  member = (
    "serviceAccount:${google_service_account.dataform.email}"
  )
}


# ------------------------------------------------------------
# Dataform → STAGING Dataset Editor
# ------------------------------------------------------------

resource "google_bigquery_dataset_iam_member" "dataform_staging_editor" {
  dataset_id = google_bigquery_dataset.warehouse["staging"].dataset_id

  role = "roles/bigquery.dataEditor"

  member = (
    "serviceAccount:${google_service_account.dataform.email}"
  )
}


# ------------------------------------------------------------
# Dataform → CORE Dataset Editor
# ------------------------------------------------------------

resource "google_bigquery_dataset_iam_member" "dataform_core_editor" {
  dataset_id = google_bigquery_dataset.warehouse["core"].dataset_id

  role = "roles/bigquery.dataEditor"

  member = (
    "serviceAccount:${google_service_account.dataform.email}"
  )
}


# ------------------------------------------------------------
# Dataform → MARTS Dataset Editor
# ------------------------------------------------------------

resource "google_bigquery_dataset_iam_member" "dataform_marts_editor" {
  dataset_id = google_bigquery_dataset.warehouse["marts"].dataset_id

  role = "roles/bigquery.dataEditor"

  member = (
    "serviceAccount:${google_service_account.dataform.email}"
  )
}


# ------------------------------------------------------------
# Dataform → ASSERTIONS Dataset Editor
# ------------------------------------------------------------

resource "google_bigquery_dataset_iam_member" "dataform_assertions_editor" {
  dataset_id = google_bigquery_dataset.warehouse["assertions"].dataset_id

  role = "roles/bigquery.dataEditor"

  member = (
    "serviceAccount:${google_service_account.dataform.email}"
  )
}