# =================================================================
# Outputs Terraform - Informations utiles après le provisioning
# =================================================================

output "cluster_name" {
  description = "Nom du cluster EKS créé"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint pour accéder au cluster Kubernetes"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group du cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "Certificat CA du cluster (base64)"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_region" {
  description = "Région AWS du cluster"
  value       = var.aws_region
}

output "vpc_id" {
  description = "ID du VPC créé"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "IDs des subnets privés"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "IDs des subnets publics"
  value       = module.vpc.public_subnets
}

# Commande pour configurer kubectl
output "configure_kubectl" {
  description = "Commande pour configurer kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
