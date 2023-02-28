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
}

resource "aws_route" "accepter" {
  count                     = length(local.accepter_route_tables_ids)
  route_table_id            = local.accepter_route_tables_ids[count.index]
  destination_cidr_block    = data.aws_vpc.requester.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  provider                  = aws.accepter
}