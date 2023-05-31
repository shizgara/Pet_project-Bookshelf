output "sa_email" {
  value = google_service_account.bookshelf-sa-tf.email
}
output "sa_id" {
  value = google_service_account.bookshelf-sa-tf.id
}