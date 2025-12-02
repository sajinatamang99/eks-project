# AWS Provider and Region Setup with Long-Lived Role
provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  vpc_name        = var.vpc_name
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  azs             = data.aws_availability_zones.available.names
}

module "ecr" {
  source = "./modules/ecr"
}
module "eks" {
  source                     = "./modules/eks"
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.private_subnet_ids
  cluster_security_group_ids = [module.vpc.eks_cluster_sg.id]
}

data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
  }
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    }
  }
}

module "helm" {
  source = "./modules/helm"
  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
  depends_on = [module.eks, data.aws_eks_cluster.cluster, data.aws_eks_cluster_auth.cluster]
}
