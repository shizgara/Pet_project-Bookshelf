output "CLOUD_STORAGE_BUCKET" {
  value = google_storage_bucket.tf-bucket-for-content.name
}