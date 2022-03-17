output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "default_network_acl_id" {
  value = aws_vpc.main_vpc.default_network_acl_id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "privat_subnets" {
  value = aws_subnet.privat_subnets.*.id
}
