provider "aws" {
  region = var.aws_region
}

# module "storage" {
#   source      = "./storage"
#   client_name = var.client_name
# }

module "networking" {
  source                = "./networking"
  client_name           = var.client_name
  vpc_cidr              = var.vpc_cidr
  public_subnets_prefix = var.public_subnets_prefix
  public_subnets_count  = var.public_subnets_count
  privat_subnets_prefix = var.privat_subnets_prefix
  privat_subnets_count  = var.privat_subnets_count
  private_gateway_id    = module.computing.bastion_net_if_id
}

module "security" {
  source                 = "./security"
  client_name            = var.client_name
  vpc_id                 = module.networking.main_vpc_id
  vpc_cidr               = var.vpc_cidr
  default_network_acl_id = module.networking.default_network_acl_id
  bastion_inbound_ports  = var.bastion_inbound_ports
  privat_subnets_prefix  = var.privat_subnets_prefix
}

module "computing" {
  source         = "./computing"
  client_name    = var.client_name
  instance_type  = var.instance_type
  public_sg_id   = module.security.public_sg_id
  privat_sg_id   = module.security.privat_sg_id
  public_subnets = module.networking.public_subnets
  privat_subnets = module.networking.privat_subnets
  bastion_count  = var.bastion_count
  app_count      = var.app_count
}

