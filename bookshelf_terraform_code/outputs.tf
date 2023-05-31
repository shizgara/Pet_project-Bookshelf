output "sql_connection_name" {
  value = module.sql_instance.sql_connection_name
}
output "CLOUDSQL_DATABASE" {
  value = module.sql_instance.CLOUDSQL_DATABASE
}
output "CLOUDSQL_USER" {
  value = module.sql_instance.CLOUDSQL_USER
}
output "CLOUD_STORAGE_BUCKET" {
  value = module.bucket.CLOUD_STORAGE_BUCKET
}
