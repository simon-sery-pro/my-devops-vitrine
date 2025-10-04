# =================================================================
# Variables Terraform pour la configuration du cluster Kubernetes
# =================================================================

variable "aws_region" {
  description = "Région AWS où déployer le cluster EKS"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
  default     = "devops-vitrine-cluster"
}

variable "kubernetes_version" {
  description = "Version de Kubernetes à déployer"
  type        = string
  default     = "1.28"
}

variable "environment" {
  description = "Environnement (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block pour le VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "CIDR blocks pour les subnets privés"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks pour les subnets publics"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "instance_type" {
  description = "Type d'instance EC2 pour les nodes Kubernetes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Nombre désiré de nodes dans le cluster"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Nombre minimum de nodes dans le cluster"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Nombre maximum de nodes dans le cluster"
  type        = number
  default     = 4
}
