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

resource "google_compute_global_address" "private_ip_address" {

  name          = var.internal_ip_config_name
  address_type  = var.ip_address_type
  purpose       = var.address_purpose
  network       = google_compute_network.vpc_network.id
  prefix_length = var.address_prefix_length

}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.vpc_network.id
  service                 = var.google_network_service
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_route" "route" {

  name             = "${var.route_name}-route"
  dest_range       = var.route_dest_range
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = var.next_hop_gateway

}

resource "google_compute_firewall" "webapp_firewall" {

  name    = var.firewall_name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = var.allow_protocol
    ports    = var.allow_ports
  }

  priority = var.allow_rule_priority

  source_ranges = var.source_ranges

  target_tags = google_compute_instance.my_instance.tags

}

resource "google_compute_firewall" "deny_firewall_rule" {

  name    = var.deny_firewall_name
  network = google_compute_network.vpc_network.name

  deny {
    protocol = var.deny_protocol
    ports    = var.deny_ports
  }

  source_ranges = var.source_ranges

  target_tags = google_compute_instance.my_instance.tags

}

resource "google_compute_instance" "my_instance" {

  name         = var.vm_name
  machine_type = var.machine_type
  network_interface {
    access_config {
      network_tier = var.network_tier
    }
    subnetwork = google_compute_subnetwork.subnet_1.name
  }
  boot_disk {
    initialize_params {
      image = var.custom_img_source
      type  = var.vm_type
    }
  }

  tags = var.instance_tags

  zone = var.vm_zone


  depends_on = [google_sql_database.my_database]

  metadata = {
    DB_NAME     = google_sql_database.my_database.name
    DB_HOST     = google_sql_database_instance.sql_instance.private_ip_address
    DB_USER     = google_sql_user.my_sql_user.name
    DB_PASSWORD = random_password.mysql_password.result
  }

  metadata_startup_script = <<-SCRIPT

  #!/bin/bash

  echo "DB_NAME=${google_sql_database.my_database.name}" > /tmp/.env
  echo "DB_HOST=${google_sql_database_instance.sql_instance.private_ip_address}" >> /tmp/.env
  echo "DB_PORT=3306" >> /tmp/.env
  echo "DB_USER=${google_sql_user.my_sql_user.name}" >> /tmp/.env
  echo "DB_PASSWORD=${random_password.mysql_password.result}" >> /tmp/.env

  cp /tmp/.env /home/csye6225/.env

  SCRIPT

}

resource "random_integer" "random_generated_int" {
  min = var.random_int_min
  max = var.random_int_max
}

resource "google_sql_database_instance" "sql_instance" {

  name                = "${var.my_sql_instance_name}-${random_integer.random_generated_int.result}"
  database_version    = var.my_sql_version
  deletion_protection = var.deletion_protection
  depends_on          = [google_service_networking_connection.default]
  settings {
    tier              = var.my_sql_tier
    availability_type = var.my_sql_availability
    disk_type         = var.my_sql_disk_type
    disk_size         = var.my_sql_disk_size
    ip_configuration {
      ipv4_enabled                                  = var.my_sql_public
      private_network                               = google_compute_network.vpc_network.id
      enable_private_path_for_google_cloud_services = var.my_sql_path_google_service
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }
}

resource "google_sql_database" "my_database" {
  name     = var.my_sql_db_name
  instance = google_sql_database_instance.sql_instance.name
}

resource "random_password" "mysql_password" {
  length = var.random_password_length
}

resource "google_sql_user" "my_sql_user" {
  name     = var.my_sql_username
  instance = google_sql_database_instance.sql_instance.name
  password = random_password.mysql_password.result
}
