terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.26"
      configuration_aliases = [aws.accepter, aws.requester]
    }
  }
}