data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.client_name}_ssh_key"
  public_key = file("~/.ssh/disney_id_rsa.pub")
}

resource "aws_instance" "bastion" {
  count                  = var.bastion_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh_key.id
  vpc_security_group_ids = [var.public_sg_id]
  subnet_id              = element(var.public_subnets, count.index)

  source_dest_check = false

  user_data = file("computing/scripts/iptables_nat.sh")

  tags = {
    Name = "${var.client_name}_bastion-${count.index + 1}"
  }
}

resource "aws_instance" "app" {
  count                  = var.app_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh_key.id
  vpc_security_group_ids = [var.privat_sg_id]
  subnet_id              = element(var.privat_subnets, count.index)

  tags = {
    Name = "${var.client_name}_app-${count.index + 1}"
  }
}
