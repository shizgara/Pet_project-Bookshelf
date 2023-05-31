module "bucket" {
  source   = "./modules/bucket"
  location = "europe-west1"
  name     = "tf-bucket-for-content"
  role     = "roles/storage.objectViewer"
  member   = "allUsers"
  class    = "STANDARD"
}

module "serviceAccount" {
  source = "./modules/serviceAccount"
}

module "vpc-subnetwork-external_ip-nat" {
  source     = "./modules/vpc+subnetwork+externalIP+NAT"
  vpc-name   = "bookshelf-vpc-tf"
  sub-name   = "bookshelf-subnet-tf-eu-west1"
  range      = "10.24.5.0/24"
  region     = "europe-west1"
  ipname     = "bookshelf-public-ip-nat"
  route-name = "bookshelf-router"
  nat-name   = "bookshelf-nat"
}

module "sql_instance" {
  source        = "./modules/sql_instance"
  vpcid         = module.vpc-subnetwork-external_ip-nat.vpcid
  region        = "europe-west1"
  db-version    = "MYSQL_5_7"
  type          = "db-f1-micro"
  db-name       = "bookshelf"
  db-user       = "bookshelf-user"
}

module "firewall" {
  source  = "./modules/firewallRules"
  vpcname = module.vpc-subnetwork-external_ip-nat.vpcname
}

module "template" {
  source      = "./modules/template+mig+balancer"
  subnet_name = module.vpc-subnetwork-external_ip-nat.subname
  vpc_name    = module.vpc-subnetwork-external_ip-nat.vpcname
  sa_email    = module.serviceAccount.sa_email
  template_name ="bookshelf-template-tf"
  instance_group_name = "bookshelf-instance-group-manager"
  image_family = "debian-10"
  image_project = "debian-cloud"
  template_diskSize = 10
  machine_type = "n1-standard-1"
  region = "europe-west1"
  zone = "europe-west1-b"
  base_instance_name = "bookshelf"
  health_check_name = "bookshelf-health-checks"
  
  sa_id = module.serviceAccount.sa_id
  sql_connection_name = module.sql_instance.sql_connection_name
  DATA_BACKEND = "cloudsql"
  CLOUDSQL_USER = module.sql_instance.CLOUDSQL_USER
  CLOUDSQL_PASSWORD = module.sql_instance.CLOUDSQL_PASSWORD
  CLOUDSQL_DATABASE = module.sql_instance.CLOUDSQL_DATABASE
  CLOUD_STORAGE_BUCKET = module.bucket.CLOUD_STORAGE_BUCKET
  PROJECT_ID = "gcp-2022-bookshelf-gurskyi"
  depends_on = [
    module.sql_instance
  ]
}
