variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1" # (US>N.virginia)
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

variable "domain_name" {
  type    = string
  default = "devopsproject.org"
}

variable "record_name" {
  description = "The DNS record name to create within the hosted zone (e.g., www.example.com)"
  type        = string
  default     = "www"
}

variable "project" {
  type    = string
  default = "threat-composer-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "prod"
  }
}
