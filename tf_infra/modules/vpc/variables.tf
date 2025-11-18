variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-west-2" # London
}

variable "azs" {
  description = "List of Availability Zones to use for subnets"
  type        = list(string)
}

variable "vpc_name" {
  type    = string
  default = "prod_vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = {
    "private_subnet_1" = 0
    "private_subnet_2" = 1
  }
}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 0
    "public_subnet_2" = 1
  }
}
