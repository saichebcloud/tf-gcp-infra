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

  direction = var.direction

  allow {
    protocol = var.allow_protocol
    ports    = var.allow_ports
  }

  priority = var.allow_rule_priority

  source_ranges = [google_compute_global_forwarding_rule.lb_forwarding_rule.ip_address, var.gcp_health_range_1, var.gcp_health_range_2]

  target_tags = var.allow_firewall_tags

}

resource "google_compute_firewall" "deny_firewall_rule" {

  name    = var.deny_firewall_name
  network = google_compute_network.vpc_network.name

  deny {
    protocol = var.deny_protocol
    ports    = var.deny_ports
  }

  source_ranges = var.source_ranges

  target_tags = ["webapp"]

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
  length  = var.random_password_length
  special = var.random_password_special
}

resource "google_sql_user" "my_sql_user" {
  name     = var.my_sql_username
  instance = google_sql_database_instance.sql_instance.name
  password = random_password.mysql_password.result
}

resource "google_dns_record_set" "webapp_dns_record" {
  managed_zone = var.dns_zone_name
  name         = var.domain_name
  type         = var.dns_record_type

  # rrdatas = [google_compute_instance.my_instance.network_interface[0].access_config[0].nat_ip]
  rrdatas = [google_compute_global_forwarding_rule.lb_forwarding_rule.ip_address]
}

resource "google_service_account" "webapp_service_account" {
  account_id   = "${var.service_account_id}-${random_integer.random_generated_int.result}"
  display_name = var.service_account_display_name
}

resource "google_project_iam_binding" "service_account_binding_1" {
  project = var.gcp_project
  members = ["${var.service_account_member}:${google_service_account.webapp_service_account.email}"]
  role    = var.role_1
}

resource "google_project_iam_binding" "service_account_binding_2" {
  project = var.gcp_project
  members = ["${var.service_account_member}:${google_service_account.webapp_service_account.email}"]
  role    = var.role_2
}

resource "google_pubsub_schema" "custom_schema" {
  name       = var.schema_name
  type       = var.schema_type
  definition = var.schema_definition
}

resource "google_pubsub_topic" "verify_user" {
  name                       = var.pub_sub_topic
  message_retention_duration = var.pub_sub_message_retention_duration
  depends_on                 = [google_pubsub_schema.custom_schema]

  schema_settings {
    schema   = "${var.schema_location}${var.schema_name}"
    encoding = var.schema_encoding
  }
}

resource "google_project_iam_binding" "service_account_binding_3" {
  project = var.gcp_project
  members = ["${var.service_account_member}:${google_service_account.webapp_service_account.email}"]
  role    = var.role_3
}

resource "google_pubsub_subscription" "email_user" {
  name  = var.sub_name
  topic = google_pubsub_topic.verify_user.id
}

resource "google_storage_bucket" "bucket" {
  name          = "${var.my_sql_username}-${random_integer.random_generated_int.result}"
  location      = var.bucket_location
  force_destroy = var.force_delete_bucket
}

resource "google_storage_bucket_object" "cloud_functon" {
  name   = var.cloud_object_name
  bucket = google_storage_bucket.bucket.id
  source = var.cloud_function_file_name
}

resource "google_vpc_access_connector" "connector" {
  name          = var.connector_name
  ip_cidr_range = var.connector_cidr_range
  network       = google_compute_network.vpc_network.name
}

resource "google_cloudfunctions_function" "send_verification_email" {
  name                  = var.cloud_function_name
  runtime               = var.cloud_function_runtime
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.cloud_functon.name
  vpc_connector         = google_vpc_access_connector.connector.id

  event_trigger {
    event_type = var.event_type
    resource   = google_pubsub_topic.verify_user.id
  }

  region = var.gcp_region

  service_account_email = google_service_account.webapp_service_account.email


  environment_variables = {
    DB_NAME            = google_sql_database.my_database.name
    DB_HOST            = google_sql_database_instance.sql_instance.private_ip_address
    DB_USER            = google_sql_user.my_sql_user.name
    DB_PASSWORD        = random_password.mysql_password.result
    DB_CONNECTION_NAME = google_sql_database_instance.sql_instance.connection_name
    API_KEY            = var.api_key
  }

}

resource "google_project_iam_member" "cloud_function_iam" {
  project = var.gcp_project
  role    = var.role_4
  member  = "serviceAccount:${google_service_account.webapp_service_account.email}"
}

resource "google_pubsub_topic_iam_binding" "topic_iam_binding" {
  topic = google_pubsub_topic.verify_user.name
  role  = var.role_5
  members = [
    "serviceAccount:${google_service_account.webapp_service_account.email}"
  ]
}



resource "google_compute_region_instance_template" "webapp_template" {
  name         = var.instance_template_name
  machine_type = var.machine_type
  disk {
    source_image = var.custom_img_source
  }
  network_interface {
    access_config {
      network_tier = var.network_tier
    }
    subnetwork = google_compute_subnetwork.subnet_1.self_link
  }
  service_account {
    email  = google_service_account.webapp_service_account.email
    scopes = var.instance_template_scope
  }

  metadata = {
    DB_NAME     = google_sql_database.my_database.name
    DB_HOST     = google_sql_database_instance.sql_instance.private_ip_address
    DB_USER     = google_sql_user.my_sql_user.name
    DB_PASSWORD = random_password.mysql_password.result
  }

  tags = var.instance_template_tags

  depends_on = [google_sql_database.my_database, google_sql_user.my_sql_user, random_password.mysql_password]

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

resource "google_compute_http_health_check" "webapp_health_check" {
  name               = var.webapp_health_check_name
  check_interval_sec = var.health_check_interval
  timeout_sec        = var.health_check_timeout
  healthy_threshold  = var.unhealthy_threshold

  request_path = var.health_check_path
  port         = var.webapp_port
}

resource "google_compute_region_instance_group_manager" "webapp_group_manager" {
  name               = var.webapp_group_manager_name
  region             = google_compute_region_instance_template.webapp_template.region
  base_instance_name = var.base_instance_name

  version {
    instance_template = google_compute_region_instance_template.webapp_template.id
    name              = "${var.base_instance_name}-version"
  }
  named_port {
    name = "${var.base_instance_name}-port"
    port = var.webapp_port
  }

  wait_for_instances = var.wait_for_instances

  auto_healing_policies {
    health_check      = google_compute_http_health_check.webapp_health_check.id
    initial_delay_sec = 30
  }

}

resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "${var.base_instance_name}-autoscaler"
  target = google_compute_region_instance_group_manager.webapp_group_manager.id

  autoscaling_policy {
    min_replicas    = var.min_autoscaling_replicas
    max_replicas    = var.max_autoscaling_replicas
    cooldown_period = var.autoscaler_cooldown

    cpu_utilization {
      target = var.cpu_util
    }

  }
}

resource "google_compute_health_check" "backend_health" {
  name               = var.backend_health_check_name
  check_interval_sec = var.health_check_interval
  timeout_sec        = var.health_check_timeout
  healthy_threshold  = var.unhealthy_threshold

  http_health_check {
    request_path = var.health_check_path
    port         = var.webapp_port
  }
}

resource "google_compute_backend_service" "webapp_backend_service" {
  name          = "${var.base_instance_name}-backend-service"
  protocol      = var.backend_protocol
  health_checks = [google_compute_health_check.backend_health.id]
  backend {
    group = google_compute_region_instance_group_manager.webapp_group_manager.instance_group
  }
  port_name = "${var.base_instance_name}-port"
}

resource "google_compute_url_map" "webapp_map" {
  name            = "${var.base_instance_name}-map"
  default_service = google_compute_backend_service.webapp_backend_service.self_link
  depends_on      = [google_compute_backend_service.webapp_backend_service]
  host_rule {
    hosts        = ["saicheb.me"]
    path_matcher = "${var.base_instance_name}-matcher"
  }
  path_matcher {
    name            = "${var.base_instance_name}-matcher"
    default_service = google_compute_backend_service.webapp_backend_service.self_link
    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.webapp_backend_service.self_link
    }
  }
}

resource "google_compute_managed_ssl_certificate" "lb" {
  name = var.lb_ssl_name

  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_target_https_proxy" "lb_default" {
  name             = var.load_balancer_name
  url_map          = google_compute_url_map.webapp_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.lb.id]

  depends_on = [google_compute_managed_ssl_certificate.lb, google_compute_url_map.webapp_map]
}

resource "google_compute_global_forwarding_rule" "lb_forwarding_rule" {
  name       = var.lb_forwarding_rule
  target     = google_compute_target_https_proxy.lb_default.id
  port_range = var.forwarding_port_range
}
