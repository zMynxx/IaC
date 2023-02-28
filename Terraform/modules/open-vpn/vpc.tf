# [Lior Dux] ==================== [ OpenVPN Access Server ] ====================  [24-02-2023] #
#
# Needed and optional variables for this module.
#

#########
## VPC ##
#########
resource "aws_vpc" "dedicated-vpc" {
  count                = var.vpc_id == null ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = merge(var.tags, { Name = "${var.env}.dedicated_for_vpn.vpc" })
}

######################
## Internet Gateway ##
######################
resource "aws_internet_gateway" "dedicated-igw" {
  count  = var.igw_id == null ? 1 : 0
  vpc_id = var.vpc_id != null ? var.vpc_id : "${aws_vpc.dedicated-vpc[0].id}"
  tags   = merge(var.tags, { Name = "${var.env}.dedicated_for_vpn.igw" })
}

###################
## Public Subnet ##
###################
resource "aws_subnet" "dedicated-subnet" {
  count                   = var.public_subnet_id == null ? 1 : 0
  vpc_id                  = var.vpc_id == null ? "${aws_vpc.dedicated-vpc[0].id}" : var.vpc_id
  cidr_block              = "10.0.1.0/28"
  map_public_ip_on_launch = true //it makes this a public subnet
  availability_zone       = var.availability_zone != null ? "${var.availability_zone}" : var.region != null ? "${var.region}a" : "${data.aws_region.current.name}a"
  tags                    = merge(var.tags, { Name = "${var.env}.dedicated_for_vpn.ps" })
}

#################
## Route Table ##
#################
resource "aws_route_table" "dedicated-public-rt" {
  count  = var.public_subnet_id == null ? 1 : 0
  vpc_id = var.vpc_id != null ? var.vpc_id : "${aws_vpc.dedicated-vpc[0].id}"

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0" //CRT uses this IGW to reach internet
    gateway_id = var.igw_id != null ? var.igw_id : "${aws_internet_gateway.dedicated-igw[0].id}"
  }
  tags = merge(var.tags, { Name = "${var.env}.dedicated_for_vpn.rt" })
}

##############################
## Route Table Associations ##
##############################
resource "aws_route_table_association" "subnet" {
  subnet_id      = var.public_subnet_id != null ? var.public_subnet_id : "${aws_subnet.dedicated-subnet[0].id}"
  route_table_id = aws_route_table.dedicated-public-rt[0].id
}

########################
## VPN Security Group ##
########################
# My IP for SSH Access
data "http" "myip" {
  url = "https://ifconfig.me/ip"
}

output "ip" {
  value = data.http.myip.response_body
}

# DEBUG PRINT
output "ip-only-cidr" {
  value = "${chomp(data.http.myip.response_body)}/32"
}

resource "aws_security_group" "vpn_access_server" {
  name        = "${var.env}.vpn-access-server.sg"
  description = "Security group for VPN access server"
  vpc_id      = var.vpc_id != null ? var.vpc_id : "${aws_vpc.dedicated-vpc[0].id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${data.http.myip.response_body}/32"] #["0.0.0.0/0"]
  }

  # ingress {
  #   protocol    = "tcp"
  #   from_port   = 943
  #   to_port     = 943
  #   cidr_blocks = ["${data.http.myip.response_body}/32"] #["0.0.0.0/0"]
  # }

  # ingress {
  #   protocol    = "tcp"
  #   from_port   = 443
  #   to_port     = 443
  #   cidr_blocks = ["${data.http.myip.response_body}/32"] #["0.0.0.0/0"]
  # }

  ingress {
    protocol    = "udp"
    from_port   = 1194
    to_port     = 1194
    cidr_blocks = ["${data.http.myip.response_body}/32"] #["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.env}.vpn-access-server.sg" })
}