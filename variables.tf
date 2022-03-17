
variable "aws_region" {}
variable "client_name" {}

variable "vpc_cidr" {}
variable "public_subnets_prefix" {}
variable "public_subnets_count" {}
variable "privat_subnets_prefix" {}
variable "privat_subnets_count" {}

variable "instance_type" {}
variable "bastion_count" {}
variable "app_count" {}

variable "bastion_inbound_ports" {}
