terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26"
    }
  }
}

# Configure the AWS Provider using local files
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "develeap"
  alias                    = "requester"
  region                   = "us-east-2"
}

## accepter
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "develeap"
  alias                    = "accepter"
  region                   = "us-east-2" # var.accepter_region
}
