resource "random_id" "db_name_suffix" { 
  byte_length = 4
}

resource "random_password" "password" { 
  length           = 16 
  special          = true 
  override_special = "#$_+:" 
}

# Create a secret 
resource "google_secret_manager_secret" "bookshelfUser-password" {
  secret_id = "bookshelfUser-password"
  replication { 
    automatic = true
  }
}

# Add the secret data for secret
resource "google_secret_manager_secret_version" "bookshelf-password" {
  secret = google_secret_manager_secret.bookshelfUser-password.id
  secret_data = random_password.password.result
}

resource "google_sql_database_instance" "instance" { // Create sql instance
name = "bookshelf-db-tf-${random_id.db_name_suffix.hex}"
database_version = var.db-version
depends_on       = [google_service_networking_connection.private_vpc_connection]
region = var.region
settings {
tier = var.type
ip_configuration {
  ipv4_enabled    = false
      private_network = var.vpcid
    }
}
deletion_protection  = "false"
}

resource "google_sql_database" "bookshelf" { // Create DB
name = var.db-name
instance = "${google_sql_database_instance.instance.name}"
}

resource "google_sql_user" "users" { // Create user + password
name = var.db-user
instance = "${google_sql_database_instance.instance.name}"
password = google_secret_manager_secret_version.bookshelf-password.secret_data
}

resource "google_compute_global_address" "private_ip_block" {// Create vpc peering
  name         = "private-ip-block"
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  prefix_length = 20
  network       = var.vpcid
}

resource "google_service_networking_connection" "private_vpc_connection" { // Create private vpc connection
  network                 = var.vpcid
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}