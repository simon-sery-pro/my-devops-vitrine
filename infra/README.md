# Infrastructure - Terraform

Ce dossier contient les fichiers Terraform pour provisionner un cluster Kubernetes sur AWS EKS.

## 📋 Prérequis

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configuré avec les credentials
- Compte AWS avec permissions IAM suffisantes (EKS, VPC, EC2)

## 🏗️ Architecture

Le cluster EKS est déployé avec :
- **VPC dédié** avec subnets publics et privés sur 3 AZs
- **NAT Gateway** pour accès internet depuis les subnets privés
- **Node Group managé** avec auto-scaling (1-4 nodes t3.medium)
- **Addons EKS** : CoreDNS, kube-proxy, VPC-CNI

## 🚀 Déploiement

### 1. Initialiser Terraform
```bash
cd infra
terraform init
```

### 2. Vérifier le plan d'exécution
```bash
terraform plan
```

### 3. Appliquer la configuration
```bash
terraform apply
```

### 4. Configurer kubectl
Après le déploiement, récupérer le kubeconfig :
```bash
aws eks update-kubeconfig --region eu-west-1 --name devops-vitrine-cluster
```

Vérifier l'accès au cluster :
```bash
kubectl get nodes
```

## 🔧 Configuration

### Variables personnalisables

Créer un fichier `terraform.tfvars` pour personnaliser :

```hcl
aws_region         = "eu-west-1"
cluster_name       = "my-devops-cluster"
kubernetes_version = "1.28"
instance_type      = "t3.medium"
desired_capacity   = 2
```

### Backend S3 (recommandé pour production)

Décommenter et configurer le backend S3 dans `main.tf` :

```hcl
backend "s3" {
  bucket = "my-terraform-state-bucket"
  key    = "devops-vitrine/terraform.tfstate"
  region = "eu-west-1"
}
```

## 📊 Outputs

Après le déploiement, Terraform affiche :
- Nom du cluster
- Endpoint du cluster
- Commande pour configurer kubectl
- IDs VPC et subnets

## 🧹 Nettoyage

Pour détruire toutes les ressources :
```bash
terraform destroy
```

## 💡 Alternative locale (Minikube)

Pour tester localement sans AWS :

```bash
# Installer minikube
minikube start --cpus 2 --memory 4096

# Vérifier
kubectl get nodes
```

## 📝 Bonnes pratiques

- ✅ State distant (S3) pour travail en équipe
- ✅ Variables externalisées
- ✅ Tags pour traçabilité
- ✅ Modules Terraform officiels AWS
- ✅ Versioning des providers
