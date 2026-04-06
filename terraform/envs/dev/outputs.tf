output "region_aws" {
  value = var.region_aws
}
output "nom_du_projet" {
  value = var.nom_du_projet
}
output "name_prefix" {
  value = local.name_prefix
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "cluster_name" {
  value = local.cluster_name
}
output "ecr_repository_name" {
  value = aws_ecr_repository.app.name
}
output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}


output "eks_cluster_name" {
  value = module.eks.cluster_name
}
output "eks_cluster_version" {
  value = module.eks.cluster_version
}
output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}