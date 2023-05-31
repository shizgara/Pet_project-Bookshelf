terraform {
 backend "gcs" {
   bucket  = "tf-bookshelf-gurskyi"
   prefix  = "terraform/state"
 }
}