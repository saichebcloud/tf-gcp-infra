resource "google_compute_network" "vpc_network" {

  name                            = var.vpc_network_name
  project                         = var.gcp_project
  auto_create_subnetworks         = var.auto_create_subnet_bool
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes

}

resource "google_compute_subnetwork" "subnet_1" {

  name          = var.subnet_1_name
  ip_cidr_range = var.subnet_1_ip_cidr_range
  network       = google_compute_network.vpc_network.name

}

resource "google_compute_subnetwork" "subnet_2" {

  name          = var.subnet_2_name
  ip_cidr_range = var.subnet_2_ip_cidr_range
  network       = google_compute_network.vpc_network.name

}

resource "google_compute_route" "route" {

  name             = "${var.route_name}-route"
  dest_range       = var.route_dest_range
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = var.next_hop_gateway

}


