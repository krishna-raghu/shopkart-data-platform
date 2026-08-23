resource "google_datastream_connection_profile" "postgres_source" {
  display_name          = "Retail PostgreSQL Source"
  location              = var.region
  connection_profile_id = "retail-postgres-source"

  postgresql_profile {
    hostname = google_sql_database_instance.source.public_ip_address
    port     = 5432
    username = "datastream_user"
    password = random_password.datastream.result
    database = google_sql_database.retail.name
  }

  depends_on = [
    google_sql_database_instance.source
  ]
}
resource "google_datastream_connection_profile" "bigquery_destination" {
  display_name          = "Retail BigQuery Destination"
  location              = var.region
  connection_profile_id = "retail-bigquery-destination"

  bigquery_profile {}
}
resource "google_datastream_stream" "retail_cdc" {
  stream_id     = "retail-postgres-to-bigquery"
  display_name  = "Retail PostgreSQL to BigQuery"
  location      = var.region
  desired_state = "RUNNING"

  source_config {
    source_connection_profile = (
      google_datastream_connection_profile.postgres_source.id
    )

    postgresql_source_config {
      publication      = "retail_publication"
      replication_slot = "retail_replication_slot"

      include_objects {
        postgresql_schemas {
          schema = "public"

          postgresql_tables {
            table = "customers"
          }

          postgresql_tables {
            table = "products"
          }

          postgresql_tables {
            table = "orders"
          }

          postgresql_tables {
            table = "order_items"
          }

          postgresql_tables {
            table = "payments"
          }
        }
      }
    }
  }

  destination_config {
    destination_connection_profile = (
      google_datastream_connection_profile.bigquery_destination.id
    )

    bigquery_destination_config {
      data_freshness = "900s"

      merge {}

      single_target_dataset {
        dataset_id = (
          google_bigquery_dataset.warehouse["raw"].id
        )
      }
    }
  }

  backfill_all {}
}