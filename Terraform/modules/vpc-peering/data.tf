# [Lior Dux] ==================== [ VPC Peering Connection ] ====================  [25-02-2023] #
#
# Set up data needed for this module.
#

############
## Routes ##
############
data "aws_vpc" "accepter" {
  id       = var.accpeter_vpc_id
  provider = aws.accepter
}

data "aws_route_tables" "accepter" {
  vpc_id   = var.accpeter_vpc_id
  provider = aws.accepter
}

data "aws_vpc" "requester" {
  id       = var.requester_vpc_id
  provider = aws.requester
}

data "aws_route_tables" "requester" {
  vpc_id   = var.requester_vpc_id
  provider = aws.requester
}

#### peering configuration ####
data "aws_availability_zones" "available" {
  provider = aws.requester
}

output "accpeter_vpc" {
  value = data.aws_vpc.accepter.*
}


output "accpeter_rt" {
  value = data.aws_route_tables.accepter.*
}


output "requester_vpc" {
  value = data.aws_vpc.requester.*
}


output "requester_rt" {
  value = data.aws_route_tables.accepter.*
}
