
resource "google_compute_firewall" "bookshelf-ssh-tf" { // Creating firewall rule for ssh connection
  name    = "bookshelf-allow-ssh-tf"                    //
  network = var.vpcname

  allow {
    protocol = "tcp" // The IP protocol to which this rule applies
    ports    = ["22"]
  }

  target_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_firewall" "bookshelf-web-tf" { //Creating firewall rule for http connection
  name    = "bookshelf-allow-http-tf"
  network = var.vpcname

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags   = ["web"]
  source_ranges = ["0.0.0.0/0"]


}
