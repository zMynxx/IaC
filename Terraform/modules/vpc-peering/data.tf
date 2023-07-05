# [Lior Dux] ==================== [ VPC Peering Connection ] ====================  [25-02-2023] #
#
# Set up data needed for this module.
#

############
## Routes ##
############
data "aws_vpc" "accepter" {
  count = length(var.accpeter_vpc_id) > 0 : var.accpeter_vpc_id : 0
  provider = aws.accepter

  id       = var.accpeter_vpc_id
}

data "aws_route_tables" "accepter" {
  count = length(var.accpeter_vpc_id) > 0 : var.accpeter_vpc_id : 0
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
  count = length(var.requester_vpc_id) > 0 : var.requester_vpc_id : 0
  provider = aws.requester

  id       = var.requester_vpc_id
}

data "aws_route_tables" "requester" {
  count = length(var.requester_vpc_id) > 0 : var.requester_vpc_id : 0
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
  value = coalesce(data.aws_vpc.accepter.*, )
}

output "accpeter_rt" {
  value = coalesce(data.aws_route_tables.accepter.ids, )
}


output "requester_vpc" {
  value = coalesce(data.aws_vpc.requester.*, )
}


output "requester_rt" {
  value = coalesce(data.aws_route_tables.accepter.ids, )
}
