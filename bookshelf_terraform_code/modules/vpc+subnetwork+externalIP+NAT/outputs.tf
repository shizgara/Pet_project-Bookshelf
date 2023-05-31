output "vpcname" {
  value = google_compute_network.bookshelf-vpc-tf.name
}

output "subname" {
  value = google_compute_subnetwork.bookshelf-subnetwok-tf.name
}

output "vpcid" {
  value = google_compute_network.bookshelf-vpc-tf.self_link
}
output "external_ip" {
  value = google_compute_address.bookshelf-public-ip-for-nat-tf.address
}