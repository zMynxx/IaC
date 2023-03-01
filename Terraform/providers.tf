# [Lior Dux] ==================== [ OpenVPN Access Server - Best Practice ] ====================  [24-02-2023] #
# Notes:
# 1) Generalize.
# 2) Create the 'complete automated package' utilizing Packer & Ansible.
# 3) Have an option to create dedicated VPC (with it's own public subnet and VPC Peering) **BEST PRACTICE**
# 4)

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26"
    }
  }
}

# Configure the AWS Provider using local files
## request
provider "aws" {
  shared_config_files      = [pathexpand("~/.aws/config")]
  shared_credentials_files = [pathexpand("~/.aws/credentials")]
  profile                  = "develeap"
  alias                    = "requester"
  region                   = "us-east-2"
}

## accepter
provider "aws" {
  shared_config_files      = [pathexpand("~/.aws/config")]
  shared_credentials_files = [pathexpand("~/.aws/credentials")]
  profile                  = "develeap"
  alias                    = "accepter"
  region                   = "us-east-2" # var.accepter_region
}
