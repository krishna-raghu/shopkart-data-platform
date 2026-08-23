output "cloudsql_instance_name" {
  value = google_sql_database_instance.source.name
}

output "cloudsql_connection_name" {
  value = google_sql_database_instance.source.connection_name
}

output "cloudsql_public_ip" {
  value = google_sql_database_instance.source.public_ip_address
}

output "postgres_password" {
  value     = random_password.postgres.result
  sensitive = true
}
output "datastream_db_password" {
  value     = random_password.datastream.result
  sensitive = true
}