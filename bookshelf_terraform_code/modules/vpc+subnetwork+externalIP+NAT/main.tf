resource "google_compute_address" "bookshelf-public-ip-for-nat-tf" { 
  name = var.ipname                                           
}

resource "google_compute_network" "bookshelf-vpc-tf" { 
  name                    = var.vpc-name            
  auto_create_subnetworks = false                   
}

resource "google_compute_subnetwork" "bookshelf-subnetwok-tf" {     
  name          = var.sub-name                            
  ip_cidr_range = var.range                               
  region        = var.region                              
  network       = google_compute_network.bookshelf-vpc-tf.id 
}

resource "google_compute_router" "bookshelf-router-tf" {               
  name    = var.route-name                                
  region  = google_compute_subnetwork.bookshelf-subnetwok-tf.region 
  network = google_compute_network.bookshelf-vpc-tf.id       
}

resource "google_compute_router_nat" "bookshelf-nat-tf" { 
  name   = var.nat-name                                
  router = google_compute_router.bookshelf-router-tf.name           
  region = google_compute_router.bookshelf-router-tf.region         

  nat_ip_allocate_option = "MANUAL_ONLY"                                              
  nat_ips                = [google_compute_address.bookshelf-public-ip-for-nat-tf.self_link] 

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"            
  subnetwork {                                                          
    name                    = google_compute_subnetwork.bookshelf-subnetwok-tf.id 
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]                         
  }
}
