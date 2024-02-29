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
