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
  provider = aws.accepter

  vpc_id   = var.accpeter_vpc_id
  # lifecycle {
  #   precondition {
  #     condition     = var.accepter_route_tables_ids == []
  #     error_message = "The number of instances (ERROR) must be evenly divisible by the number of private subnets ()."
  #   }
  # }
}

data "aws_vpc" "requester" {
  provider = aws.requester

  id       = var.requester_vpc_id
}

data "aws_route_tables" "requester" {
  provider = aws.requester

  vpc_id   = var.requester_vpc_id
  # lifecycle {
  #   precondition {
  #     condition     = var.requester_route_tables_ids == []
  #     error_message = "The number of instances (ERROR) must be evenly divisible by the number of private subnets ()."
  #   }
  # }
}

#### peering configuration ####
data "aws_availability_zones" "available" {
  provider = aws.requester
}

output "accpeter_vpc" {
  value = data.aws_vpc.accepter.*
}

output "accpeter_rt" {
  value = data.aws_route_tables.accepter.ids
}


output "requester_vpc" {
  value = data.aws_vpc.requester.*
}


output "requester_rt" {
  value = data.aws_route_tables.accepter.ids
}
