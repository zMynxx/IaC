# [Lior Dux] ==================== [ OpenVPN Access Server ] ====================  [24-02-2023] #
#
# Ec2 instance set up for this module.
#
# 1. Custom ami (ubuntu or build with Packer).
# 2. SSH Keys to set up.
# 3. Ec2 Elastic IP attachment.
#

################
## Custom AMI ##
################
data "aws_ami" "custom_ami" {
  count = var.ami == null ? 1 : 0
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.*.1-x86_64-gp2"] #["test.openvpn-server-ce-*.ami"] #["OpenVPNServer-CE-*"]
  }
  most_recent = true
  owners      = ["amazon"] #["self"]
}

output "ami_id" {
  value = data.aws_ami.custom_ami[0].id
}

#########################
## Custom SSH Key Pair ##
#########################
variable "key_name" {
  description = "Name for key pair to be created."
  default     = "default.vpn-access-server.kp"
}

resource "tls_private_key" "example" {
  count     = var.sshkey == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count      = var.sshkey == null ? 1 : 0
  key_name   = var.key_name
  public_key = tls_private_key.example[0].public_key_openssh

  provisioner "local-exec" { # Create key on builder machine
    command = "echo '${tls_private_key.example[0].private_key_pem}' > ./${var.key_name}.pem"
  }

  provisioner "local-exec" { # Set permissions
    command = "chmod 400 ./${var.key_name}.pem"
  }
}

output "private_key" {
  value     = tls_private_key.example[0].private_key_pem
  sensitive = true
}

################
## Custom EC2 ##
################
resource "aws_instance" "vpn_access_server" {
  ami                         = var.ami != null ? var.ami : data.aws_ami.custom_ami[0].id
  instance_type               = var.instance_type
  vpc_security_group_ids      = ["${aws_security_group.vpn_access_server.id}"]
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_id != null ? var.public_subnet_id : "${aws_subnet.dedicated-subnet[0].id}"
  key_name                    = var.key_name != null ? var.key_name : "${aws_key_pair.generated_key[0].key_name}"
  tags                        = merge(var.tags, { Name = "${var.env}.vpn-access-server.ec2" })
}

### Optional - Elastic IP ###
resource "aws_eip" "vpn_access_server" {
  instance = aws_instance.vpn_access_server.id
  vpc      = true
  tags     = merge(var.tags, { Name = "${var.env}.vpn-access-server.eip" })
}

output "vpn_access_server_dns" {
  value       = "https://${aws_eip.vpn_access_server.public_dns}:943/admin"
  description = "The public url address of the vpn server admin interface."
}