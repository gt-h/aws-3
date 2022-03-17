aws_region  = "us-east-1"
client_name = "disney"

vpc_cidr              = "192.168.0.0/16"
public_subnets_prefix = 0
public_subnets_count  = 2
privat_subnets_prefix = 10
privat_subnets_count  = 3

instance_type = "t2.micro"
bastion_count = 1
app_count     = 1

bastion_inbound_ports = [22, 80, 443]
