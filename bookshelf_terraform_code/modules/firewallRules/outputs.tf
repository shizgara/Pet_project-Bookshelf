output "ssh" {
  value = google_compute_firewall.bookshelf-ssh-tf.target_tags
}

output "web" {
  value = google_compute_firewall.bookshelf-web-tf.target_tags
}