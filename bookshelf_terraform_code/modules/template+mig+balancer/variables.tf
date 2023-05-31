variable "subnet_name" {
}
variable "vpc_name" {
}
variable "image_family" {
}
variable "template_name" {
}
variable "image_project" {
}
variable "template_diskSize" {
}
variable "machine_type" {
}
variable "region" {
}
variable "zone" {
}
variable "base_instance_name" {
}
variable "health_check_name" {
}
variable "instance_group_name" {
}
variable "sa_email" {
}
variable "sa_id" {
}
variable "sql_connection_name" {
}
variable "DATA_BACKEND" {
}
variable "CLOUDSQL_USER" {
}
variable "CLOUDSQL_PASSWORD" {
}
variable "CLOUDSQL_DATABASE" {
}
variable "CLOUD_STORAGE_BUCKET" {
}
variable "PROJECT_ID" {
}
variable "tags" {
  description = "Network tags"
  type        = list(string)
  default     = ["ssh", "web"]
}
variable "scopes" {
  description = "scopes for template"
  type        = list(string)
  default     = ["cloud-platform"]
}


