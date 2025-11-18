# AWS Provider and Region Setup
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

module "helm" {
  source = "./modules/helm"
  depends_on = [module.eks]
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
provider "helm" {}
