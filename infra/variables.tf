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
