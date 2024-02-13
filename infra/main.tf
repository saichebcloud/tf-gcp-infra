resource "google_compute_network" "vpc_network" {

  name                            = var.vpc_network_name
  project                         = var.gcp_project
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true

}

resource "google_compute_subnetwork" "webapp" {

  name          = "webapp"
  ip_cidr_range = var.webapp_ip_cidr_range
  network       = google_compute_network.vpc_network.name

}

resource "google_compute_subnetwork" "db" {

  name          = "db"
  ip_cidr_range = var.db_ip_cidr_range
  network       = google_compute_network.vpc_network.name

}

resource "google_compute_route" "webapp_route" {

  name             = "webapp-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = "default-internet-gateway"

}
