output "sql_connection_name" {
  value = google_sql_database_instance.instance.connection_name
}
output "CLOUDSQL_USER" {
  value = google_sql_user.users.name
}
output "CLOUDSQL_PASSWORD" {
  value = google_sql_user.users.password
}
output "CLOUDSQL_DATABASE" {
  value = google_sql_database.bookshelf.name
}
