output "bastion_net_if_id" {
  value = aws_instance.bastion.*.primary_network_interface_id
}
