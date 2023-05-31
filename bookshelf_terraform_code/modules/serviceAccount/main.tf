resource "google_service_account" "bookshelf-sa-tf" {
  account_id   = "bookshelf-sa-tf"
  display_name = "bookshelf-sa-tf"
}
resource "google_project_iam_member" "sa-bookshelf-roles4" {
  project = "gcp-2022-bookshelf-gurskyi"
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.bookshelf-sa-tf.email}"
}
resource "google_project_iam_member" "sa-bookshelf-roles1" {
  project = "gcp-2022-bookshelf-gurskyi"
  role    = "roles/source.admin"
  member  = "serviceAccount:${google_service_account.bookshelf-sa-tf.email}"
}
resource "google_project_iam_member" "sa-bookshelf-roles2" {
  project = "gcp-2022-bookshelf-gurskyi"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.bookshelf-sa-tf.email}"
}
resource "google_project_iam_member" "sa-bookshelf-roles5" {
  project = "gcp-2022-bookshelf-gurskyi"
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.bookshelf-sa-tf.email}"
}
resource "google_project_iam_member" "sa-bookshelf-roles6" {
  project = "gcp-2022-bookshelf-gurskyi"
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.bookshelf-sa-tf.email}"
}
resource "google_project_iam_member" "sa-bookshelf-roles7" {
  project = "gcp-2022-bookshelf-gurskyi"
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:${google_service_account.bookshelf-sa-tf.email}"
}
resource "google_project_iam_member" "sa-bookshelf-roles8" {
  project = "gcp-2022-bookshelf-gurskyi"
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.bookshelf-sa-tf.email}"
}
