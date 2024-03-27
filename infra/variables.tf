variable "gcp_svc_key" {
  type = string
}

variable "gcp_project" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "vpc_network_name" {
  type = string
}

variable "subnet_1_ip_cidr_range" {
  type = string
}

variable "subnet_2_ip_cidr_range" {
  type = string
}

variable "route_name" {
  type    = string
  default = "custom-created"
}

variable "subnet_1_name" {
  type    = string
  default = "webapp"
}

variable "subnet_2_name" {
  type    = string
  default = "db"
}

variable "routing_mode" {
  type    = string
  default = "REGIONAL"
}

variable "auto_create_subnet_bool" {
  type    = bool
  default = false
}

variable "delete_default_routes" {
  type    = bool
  default = true
}

variable "route_dest_range" {
  type    = string
  default = "0.0.0.0/0"
}

variable "next_hop_gateway" {
  type    = string
  default = "default-internet-gateway"
}

variable "firewall_name" {
  type    = string
  default = "my-custom-firewall"
}

variable "allow_protocol" {
  type    = string
  default = "tcp"
}

variable "allow_ports" {
  type    = list(string)
  default = ["5000"]
}

variable "source_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "vm_name" {
  type    = string
  default = "webbapp-instance"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "network_tier" {
  type    = string
  default = "STANDARD"
}

variable "custom_img_source" {
  type = string
}

variable "vm_type" {
  type    = string
  default = "pd-balanced"
}

variable "vm_zone" {
  type = string
}

variable "instance_tags" {
  type    = list(string)
  default = ["webapp"]
}

variable "allow_rule_priority" {
  type    = number
  default = 999
}

variable "deny_firewall_name" {
  type    = string
  default = "deny-firewall-rule"
}

variable "deny_protocol" {
  type    = string
  default = "all"
}

variable "deny_ports" {
  type    = list(string)
  default = []
}

variable "internal_ip_config_name" {
  type    = string
  default = "private-ip-address"
}

variable "ip_address_type" {
  type    = string
  default = "INTERNAL"
}

variable "address_purpose" {
  type    = string
  default = "VPC_PEERING"
}

variable "address_prefix_length" {
  type    = number
  default = 16
}

variable "google_network_service" {
  type    = string
  default = "servicenetworking.googleapis.com"
}

variable "my_sql_instance_name" {
  type    = string
  default = "sql"
}

variable "my_sql_version" {
  type    = string
  default = "MYSQL_8_0"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "my_sql_tier" {
  type    = string
  default = "db-f1-micro"
}

variable "my_sql_availability" {
  type    = string
  default = "REGIONAL"
}

variable "my_sql_disk_type" {
  type    = string
  default = "PD_SSD"
}

variable "my_sql_disk_size" {
  type    = number
  default = 100
}

variable "my_sql_public" {
  type    = bool
  default = false
}

variable "my_sql_path_google_service" {
  type    = bool
  default = true
}

variable "random_int_min" {
  type    = number
  default = 10
}

variable "random_int_max" {
  type    = number
  default = 10000
}

variable "my_sql_db_name" {
  type    = string
  default = "csye"
}

variable "random_password_length" {
  type    = number
  default = 10
}

variable "my_sql_username" {
  type    = string
  default = "saicheb"
}

variable "dns_zone_name" {
  type    = string
  default = "webapp-zone"
}

variable "domain_name" {
  type    = string
  default = "saicheb.me."
}

variable "dns_record_type" {
  type    = string
  default = "A"
}

variable "service_account_id" {
  type    = string
  default = "webapp-sa"
}

variable "service_account_display_name" {
  type    = string
  default = "Webapp Service Account"
}

variable "role_1" {
  type    = string
  default = "roles/logging.admin"
}

variable "role_2" {
  type    = string
  default = "roles/monitoring.metricWriter"
}

variable "role_3" {
  type    = string
  default = "roles/pubsub.publisher"
}

variable "role_4" {
  type    = string
  default = "roles/cloudfunctions.developer"
}

variable "role_5" {
  type    = string
  default = "roles/pubsub.publisher"
}

variable "service_account_member" {
  type    = string
  default = "serviceAccount"
}

variable "allow_stopping_for_update" {
  type    = bool
  default = true
}

variable "service_account_scope" {
  type    = list(string)
  default = ["cloud-platform"]
}

variable "schema_name" {
  type    = string
  default = "custom_schema"
}

variable "schema_type" {
  type    = string
  default = "AVRO"
}

variable "schema_definition" {
  type    = string
  default = "{\n  \"type\" : \"record\",\n  \"name\" : \"Avro\",\n  \"fields\" : [\n    {\n      \"name\" : \"email\",\n      \"type\" : \"string\"\n    },\n    {\n      \"name\" : \"token\",\n      \"type\" : \"string\"\n    }\n  ]\n}\n"
}

variable "pub_sub_topic" {
  type    = string
  default = "verify_user"
}

variable "pub_sub_message_retention_duration" {
  type    = string
  default = "604800s"
}

variable "schema_location" {
  type    = string
  default = "projects/devp-414719/schemas/"
}

variable "schema_encoding" {
  type    = string
  default = "JSON"
}

variable "sub_name" {
  type    = string
  default = "email_user"
}

variable "bucket_location" {
  type    = string
  default = "US"
}

variable "force_delete_bucket" {
  type    = bool
  default = true
}

variable "connector_name" {
  type    = string
  default = "cloud-functions-connector"
}

variable "connector_cidr_range" {
  type    = string
  default = "10.8.0.0/28"
}

variable "cloud_object_name" {
  type    = string
  default = "python_zip_code"
}

variable "cloud_function_name" {
  type    = string
  default = "send_email"
}

variable "cloud_function_runtime" {
  type    = string
  default = "python39"
}

variable "api_key" {
  type    = string
  default = "949e6201ac30ffe152e888858b4ed602-309b0ef4-c814b3da"
}

variable "event_type" {
  type    = string
  default = "google.pubsub.topic.publish"
}

variable "cloud_function_file_name" {
  type    = string
  default = "cloud-function.zip"
}
