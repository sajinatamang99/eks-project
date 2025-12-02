variable "cluster_version" {
  default     = "1.33"
  description = "kubernetes version"
}

variable "cluster_name" {
  description = "VPC ID where EKS cluster will be created"
  type        = string
  default     = "eks-prod-cluster"
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for EKS cluster"
  type        = list(string)
}
variable "cluster_security_group_ids" {
  description = "List of security group IDs for EKS cluster"
  type        = list(string)
}

variable "eks_node_name" {
  type    = string
  default = "eks-node-group"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.large"]
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1

}

variable "max_size" {
  type    = number
  default = 2
}
