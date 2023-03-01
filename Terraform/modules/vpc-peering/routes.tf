# [Lior Dux] ==================== [ VPC Peering Connection ] ====================  [25-02-2023] #
#
# Set up routes needed for this module.
#

############
## Routes ##
############

####  route tables ####
resource "aws_route" "requester" {
  count                     = length(local.requester_route_tables_ids)
  route_table_id            = local.requester_route_tables_ids[count.index]
  destination_cidr_block    = data.aws_vpc.accepter.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  provider                  = aws.requester

  depends_on = [data.aws_route_tables.requester]
  # lifecycle {
  #   precondition {
  #     condition     = data.aws_route_tables.requester != null
  #     error_message = "The number of instances (ERROR) must be evenly divisible by the number of private subnets ()."
  #   }
  # }
}

resource "aws_route" "accepter" {
  count                     = length(local.accepter_route_tables_ids)
  route_table_id            = local.accepter_route_tables_ids[count.index]
  destination_cidr_block    = data.aws_vpc.requester.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  provider                  = aws.accepter

  depends_on = [data.aws_route_tables.accepter]
  # lifecycle {
  #   precondition {
  #     condition     = data.aws_route_tables.accepter != null
  #     error_message = "The number of instances (ERROR) must be evenly divisible by the number of private subnets ()."
  #   }
  # }
}