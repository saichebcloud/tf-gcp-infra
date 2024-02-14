<h1 align="center">Terraform Infrastructure</h1>

This repository is for setting up terraform infrastructure

As of now it support creating

- Google Virtual Private Network (VPC)
- Subnets within the VPC
- Add a route

## Requirements

#### Installed Software

- Terraform - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

- Google Cloud CLI - https://cloud.google.com/sdk/docs/install

#### Configure Service Account

Configure the service account and save the json key for the account in your local system. This file will be needed for terraform to execute.

#### Enable API's

To operate with the service account, you will need to activate the following API(s) on the project where the service account was created.

- Compute Engine API - https://compute.googleapis.com

## Usage

you will need to perform these commands at the root folder

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build

#### Inputs

| Variable                | Description                                                                                                               | Type   | Default                    |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------ | -------------------------- |
| gcp_svc_key             | Service account key filespec used for authentication                                                                      | string |                            |
| gcp_project             | ID of the project where the VPC will be created                                                                           | string |                            |
| gcp_region              | Region where the VPC and subnetworks will be created                                                                      | string |                            |
| vpc_network_name        | Name of the VPC network being created                                                                                     | string |                            |
| subnet_1_ip_cidr_range  | IP CIDR range for the first subnet (e.g., "10.0.1.0/24")                                                                  | string |                            |
| subnet_2_ip_cidr_range  | IP CIDR range for the second subnet (e.g., "10.0.2.0/24")                                                                 | string |                            |
| route_name              | Name of the custom route being created                                                                                    | string | "custom-created"           |
| subnet_1_name           | Name of the first subnet (e.g., "webapp")                                                                                 | string | "webapp"                   |
| subnet_2_name           | Name of the second subnet (e.g., "db")                                                                                    | string | "db"                       |
| routing_mode            | Network routing mode (default 'REGIONAL')                                                                                 | string | "REGIONAL"                 |
| auto_create_subnet_bool | Boolean indicating whether to create subnets automatically in 'auto subnet mode'                                          | bool   | false                      |
| delete_default_routes   | Boolean indicating whether to delete default routes within the network specified with names starting with 'default-route' | bool   | true                       |
| route_dest_range        | Destination IP range for the custom route (e.g., "0.0.0.0/0")                                                             | string | "0.0.0.0/0"                |
| next_hop_gateway        | Next hop for the custom route, typically set to "default-internet-gateway"                                                | string | "default-internet-gateway" |
