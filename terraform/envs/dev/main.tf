locals {
  name_prefix  = "${var.nom_du_projet}-${var.environment}"
  cluster_name = "${local.name_prefix}-eks"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version              = "~> 5.0"
  name                 = "${local.name_prefix}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = var.availability_zone
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  public_subnet_tags = {
    "Name"                                        = "${local.name_prefix}-public"
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
  private_subnet_tags = {
    "Name"                                        = "${local.name_prefix}-private"
    "kubernetes.io/role/internal-elb"             = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
  tags = {
    Terraform   = true
    Environment = var.environment
    Project     = var.nom_du_projet
  } 
}

resource "aws_ecr_repository" "app" {
  name                 = "${local.name_prefix}-${var.ecr_repository_name}"
  image_tag_mutability = var.ecr_tag_mutability
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    Name = "${local.name_prefix}-${var.ecr_repository_name}"
  }
}
resource "aws_ecr_lifecycle_policy" "app_lifecycle" {
  repository = aws_ecr_repository.app.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Retenir les 10 dernieres images"
        selection = {
          tagStatus     = "any",
          #tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name = local.cluster_name
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true
  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_irsa = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2023_x86_64_STANDARD"
    instance_types = var.eks_node_instance_types
    disk_size = 20
  }
  eks_managed_node_groups = {
    default = {
      name = "default-ng"
      desired_size = var.eks_node_desired_size
      min_size = var.eks_node_min_size
      max_size = var.eks_node_max_size
      subnet_ids = module.vpc.private_subnets
      capacity_type = "ON_DEMAND"
    }
  }

  tags = {
    Environement = var.environment
    Project = var.nom_du_projet
  }

}
