resource "google_storage_bucket" "tf-bucket-for-content" { 
  name                        = var.name  
  location                    = var.location 
  force_destroy               = true   
  storage_class               = var.class 
  public_access_prevention    = "inherited" 
  uniform_bucket_level_access = true 
}

resource "google_storage_bucket_iam_member" "bookshelf-role" {
  bucket = google_storage_bucket.tf-bucket-for-content.name
  role   = var.role 
  member = var.member 
}
