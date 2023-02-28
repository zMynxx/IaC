# [Lior Dux] ==================== [ OpenVPN Access Server ] ====================  [24-02-2023] #
#
# Needed and optional variables for this module.
#

#################
## Credentials ##
#################
# variable "admin_user" {
#   description = "Name of the admin user to be created."
#   default     = "openvpn"
# }

# Pull Credentials from SSM Parameter store ##
# data "aws_ssm_parameter" "admin_pw" {
#   name = "OpenVPN_Admin_PW"
#   with_decryption = true
# }

# variable "admin_pw" {
#   description = "A password to set for the admin user."
#   default     = "testing132"
#   sensitive   = true
# }

###############
## Variables ##
###############
variable "vpc_id" {
  type        = string
  description = "A VPC Id to launch the OpenVPN Server in, will create a dedicated-vpc if not provided."
  default     = null
}

variable "public_subnet_id" {
  type        = string
  description = "A Public Subnet Id to launch the OpenVPN Server in, will create a dedicated-subnet if not provided."
  default     = null
}

variable "igw_id" {
  type        = string
  description = "An Internet Gateway ID to attach to the Public Subnet the OpenVPN Server is in, will create a dedicated-igw if not provided."
  default     = null
}

variable "sshkey" {
  type        = string
  description = "A SSH Key name (on aws) to associate the OpenVPN Server with. "
  default     = null
}

variable "ami" {
  type        = string
  description = "This is the AMI for the most recent version of OpenVPN access server with 10 connected devices"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "The instance size for the VPN server."
  default     = "t2.micro"
}

variable "env" {
  type        = string
  description = "describe your variable"
  default     = "test"
}

variable "client_name" {
  type        = string
  description = "describe your variable"
  default     = "myclient"
}

variable "availability_zone" {
  type        = string
  description = "describe your variable"
  default     = null
}

variable "tags" {
  type        = object({})
  description = "describe your variable"
  default     = {}
}

data "aws_region" "current" {}
variable "region" {
  type        = string
  description = "describe your variable"
  default     = null
}