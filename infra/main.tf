# =================================================================
# Terraform configuration pour provisionner un cluster Kubernetes
# Provider: AWS EKS (adaptable pour Azure AKS ou GCP GKE)
# =================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }

  # Backend S3 pour stocker le state (bonne pratique)
  # Décommenter et configurer pour la production
  # backend "s3" {
  #   bucket = "my-terraform-state-bucket"
  #   key    = "devops-vitrine/terraform.tfstate"
  #   region = "eu-west-1"
  # }
}

# Provider AWS
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "DevOps-Vitrine"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# VPC pour le cluster EKS
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Tags requis pour EKS
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Cluster EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Endpoint public pour accès simplifié (à sécuriser en prod)
  cluster_endpoint_public_access = true

  # Node groups pour les workers
  eks_managed_node_groups = {
    general = {
      desired_size = var.desired_capacity
      min_size     = var.min_capacity
      max_size     = var.max_capacity

      instance_types = [var.instance_type]
      capacity_type  = "ON_DEMAND"

      labels = {
        role = "general"
      }

      tags = {
        NodeGroup = "general"
      }
    }
  }

  # Activer les addons EKS
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
}

# Data source pour les zones de disponibilité
data "aws_availability_zones" "available" {
  state = "available"
}

# Configuration du provider Kubernetes (pour déploiement post-cluster)
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}
