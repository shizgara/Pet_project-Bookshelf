data "google_compute_image" "my_image" { // Looking for latest version image
  family  = var.image_family
  project = var.image_project
}

resource "google_compute_instance_template" "bookshelf-template-tf" {
  name         = var.template_name
  machine_type = var.machine_type
  region       = var.region
  tags         = var.tags
  disk {
    auto_delete  = true
    boot         = true
    disk_size_gb = var.template_diskSize
    source_image = data.google_compute_image.my_image.self_link
  }
// Startup script

  metadata = {
    startup-script = <<-EOF
    apt update && apt install -y python3-pip git
    pip3 install ansible==2.9.27
    gcloud source repos clone ansible_bookshelf /opt/ansible_bookshelf --project=gcp-2022-bookshelf-gurskyi && cd /opt/ansible_bookshelf
    #ansible-galaxy collection install community.general:6.3.0
    ansible-playbook main.yml -e sql_connection_name=${var.sql_connection_name} -e DATA_BACKEND=${var.DATA_BACKEND} -e CLOUDSQL_USER=${var.CLOUDSQL_USER} -e CLOUDSQL_PASSWORD=${var.CLOUDSQL_PASSWORD} -e CLOUDSQL_DATABASE=${var.CLOUDSQL_DATABASE} -e CLOUD_STORAGE_BUCKET=${var.CLOUD_STORAGE_BUCKET} -e PROJECT_ID=${var.PROJECT_ID}
  EOF
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
  }

  service_account {
    email  = var.sa_email
    scopes = var.scopes
  }

  depends_on = [
    var.sa_id
  ]
}


resource "google_compute_instance_group_manager" "bookshelf-mig-tf" { 
  name = var.instance_group_name
  zone = var.zone
  named_port {
    name = "http"
    port = 8080
  }
  version {
    instance_template = google_compute_instance_template.bookshelf-template-tf.id
    name              = "primary"
  }
  base_instance_name = var.base_instance_name
  target_size        = 1

  auto_healing_policies {
    health_check      = google_compute_health_check.bookshelf-health-checks.id
    initial_delay_sec = 300
  }

}

resource "google_compute_health_check" "bookshelf-health-checks" { 
  name                = var.health_check_name
  check_interval_sec  = 10 
  healthy_threshold   = 2  
  timeout_sec         = 10 
  unhealthy_threshold = 5  

http_health_check {
    port = "8080"
    request_path = "/_ah/health"
  }

}

resource "google_compute_autoscaler" "bookshelf-auroscaler" { 
  name   = "bookshelf-autoscaler"
  zone   = "europe-west1-b"
  target = google_compute_instance_group_manager.bookshelf-mig-tf.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_global_address" "external_ip-loadbalancer-bookshelf-tf" { 
  name       = "external-ip-loadbalancer-bookshelf-tf"
  ip_version = "IPV4"
}

resource "google_compute_backend_service" "bookshelf-backend-tf" { 
  name                            = "bookshelf-web-backend-service"
  connection_draining_timeout_sec = 0
  health_checks                   = [google_compute_health_check.bookshelf-health-checks.id] 
  load_balancing_scheme           = "EXTERNAL_MANAGED"                                       
  port_name                       = "http"
  protocol                        = "HTTP"
  session_affinity                = "NONE"
  timeout_sec                     = 30
  backend {
    group           = google_compute_instance_group_manager.bookshelf-mig-tf.instance_group 
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 0.8 
  }
}

resource "google_compute_url_map" "default" { 
  name            = "bookshelf-web-map-http"
  default_service = google_compute_backend_service.bookshelf-backend-tf.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "bookshelf-http-lb-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" { 
  name                  = "bookshelf-http-content-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED" 
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.external_ip-loadbalancer-bookshelf-tf.id 
}
