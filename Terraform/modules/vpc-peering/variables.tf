# [Lior Dux] ==================== [ VPC Peering Connection ] ====================  [25-02-2023] #
#
# Set up variables needed for this module.
#

###############
## Variables ##
###############

#accepter
variable "accpeter_vpc_id" {}
variable "accepter_region" {}

#requester
variable "requester_vpc_id" {}
variable "requester_region" {}
variable "tags" {
  type        = object({})
  description = "describe your variable"
  default     = {}
}