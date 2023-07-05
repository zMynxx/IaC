# [Lior Dux] ==================== [ OpenVPN Access Server - Best Practice ] ====================  [24-02-2023] #
# Notes:
# 1) Generalize.
# 2) Create the 'complete automated package' utilizing Packer & Ansible.
# 3) Have an option to create dedicated VPC (with it's own public subnet and VPC Peering) **BEST PRACTICE**
# 4)

module "OpenVPN" {
  source = "./modules/open-vpn"

  # using defaults
  vpc_id            = null
  public_subnet_id  = null
  igw_id            = null
  ami               = null
  availability_zone = null

  # override
  instance_type = "t2.micro"
  env           = "test"
  region        = "us-east-2"
  tags          = merge(local.merged_tags, { Objective = "OpenVPN Server" })
}

module "VPCPeering" {
  providers = {
    aws.accepter  = aws.accepter
    aws.requester = aws.requester
  }

  source = "./modules/vpc-peering"

  # accepter
  accpeter_vpc_id  = "vpc-0111a97a9ba2c8949"
  accepter_region  = module.OpenVPN.region.id
  # accepter_route_tables_ids  = data.aws_route_tables.accepter.ids

  # requester
  requester_vpc_id = module.OpenVPN.vpc.id
  requester_region = module.OpenVPN.region.id
  requester_route_tables_ids = [module.OpenVPN.route_table.id]
  tags             = merge(local.merged_tags, { Objective = "VPC Peering" })

  #depends_on = [module.OpenVPN]
}

############
##  Tags  ##
############
# Levarage timestamp() in 'default_tags'
variable "extra_tags" {
  default = {
    Owner       = "Lior-Develeap"
    Terraform   = "True"
    Environment = "Testing"
  }
}
data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
locals {
  computed_tags = {
    LastModifiedTime = "${timestamp()}"
    LastModifiedBy   = "${data.aws_caller_identity.current.arn}"
  }
  client_tags = { # Client-Specific-Tags
    Owner      = "lior.dux"
    Birthdate  = "20230225"
    Expiration = "20230225"
    Email      = "lior.dux@develeap.com"
  }
  # client_tags = {
  #   join("", ["${var.client_name}", ":env-type"])    = "${var.env}"
  #   join("", ["${var.client_name}", ":data-center"]) = "${var.region}"
  # }
  merged_tags = merge(local.computed_tags, local.client_tags, var.extra_tags)
}