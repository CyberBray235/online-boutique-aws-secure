variable "region_aws" {
  description = "Region aws ou les ressources seront deployées"
  type        = string
  default     = "us-west-1"
}

variable "nom_du_projet" {
  description = "Nom du projet encours"
  type        = string
  default     = "online-boutique-aws"
}

variable "environment" {
  description = "Environement de travail"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "Cidr du vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Zone de disponibilité"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "sous réseaux publique"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "sous réseaux privé"
  type        = list(string)
  default     = ["10.0.22.0/24", "10.0.33.0/24"]
}

variable "ecr_repository_name" {
  description = "Nom du repo qui va stocker nos fichiers"
  type        = string
  default     = "online_boutique"
}

variable "ecr_tag_mutability" {
  description = "pour la mutation des tags"
  type        = string
  default     = "MUTABLE"
}

variable "eks_cluster_version" {
  description = "version du cluster eks"
  type = string
  default = "1.31"
}
variable "eks_node_instance_types" {
  description = "types d'nstance ec2 pour eks"
  type = list(string)
  default = [ "m7i-flex.large" ]
}
variable "eks_node_min_size" {
  description = "Nombre minimum de worker"
  type = number
  default = 1
}
variable "eks_node_max_size" {
  description = "Nombre max de worker"
  type = number
  default = 3
}
variable "eks_node_desired_size" {
  description = "Nombre de worker voulu"
  type = number
  default = 2
}