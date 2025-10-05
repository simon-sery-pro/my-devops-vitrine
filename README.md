# 🚀 DevOps Vitrine - Full-Stack Kubernetes Project

Projet vitrine démontrant les compétences **DevOps / SRE** avec déploiement d'une application full-stack sur Kubernetes, Infrastructure as Code (Terraform), CI/CD GitHub Actions, et observabilité complète.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28-326CE5?logo=kubernetes)
![Terraform](https://img.shields.io/badge/Terraform-1.0+-7B42BC?logo=terraform)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI/CD-2088FF?logo=github-actions)

## 📋 Table des matières

- [Architecture](#architecture)
- [Stack Technique](#stack-technique)
- [Prérequis](#prérequis)
- [Démarrage Rapide](#démarrage-rapide)
- [Structure du Projet](#structure-du-projet)
- [Déploiement](#déploiement)
- [CI/CD Pipeline](#cicd-pipeline)
- [Observabilité](#observabilité)
- [Bonnes Pratiques](#bonnes-pratiques)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Actions CI/CD                    │
│  (Build → Test → Package → Deploy → Monitoring)            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                  Kubernetes Cluster (EKS)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Frontend   │  │   Backend    │  │  Prometheus  │     │
│  │   (Angular)  │→ │ (Spring Boot)│→ │   Grafana    │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│           ↓                ↓                                 │
│  ┌──────────────────────────────────────────────┐          │
│  │            PostgreSQL Database                │          │
│  └──────────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────┘
                              ↑
┌─────────────────────────────────────────────────────────────┐
│           Infrastructure as Code (Terraform)                │
│        AWS EKS + VPC + Security Groups + IAM                │
└─────────────────────────────────────────────────────────────┘
```

## 🛠️ Stack Technique

### Infrastructure
- **Cloud Provider** : AWS (EKS)
- **IaC** : Terraform 1.0+
- **Orchestration** : Kubernetes 1.28
- **Packaging** : Helm 3

### Backend
- **Framework** : Java 17 + Spring Boot 3.2
- **Database** : PostgreSQL
- **Build** : Maven
- **Containerization** : Docker multi-stage

### Frontend
- **Framework** : Angular 17
- **Language** : TypeScript 5.2
- **Web Server** : Nginx
- **Containerization** : Docker multi-stage

### CI/CD & Observabilité
- **CI/CD** : GitHub Actions
- **Registry** : GitHub Container Registry (GHCR)
- **Monitoring** : Prometheus + Grafana
- **Logging** : Spring Boot Actuator
- **Security** : Trivy scanner

## 📁 Structure du Projet

```
my-devops-vitrine/
├── infra/                    # Terraform - Provisioning cluster K8s
│   ├── main.tf              # Configuration EKS + VPC
│   ├── variables.tf         # Variables parametrables
│   ├── outputs.tf           # Outputs (kubeconfig, endpoints)
│   └── README.md
│
├── k8s/                      # Kubernetes manifests & Helm
│   ├── manifests/           # YAML Kubernetes pour production
│   │   ├── backend-deployment.yaml
│   │   ├── frontend-deployment.yaml
│   │   ├── configmap.yaml
│   │   └── secret.yaml
│   ├── local/               # YAML pour développement local
│   │   ├── backend-deployment-local.yaml
│   │   ├── frontend-deployment-local.yaml
│   │   └── README.md
│   ├── helm/                # Charts Helm
│   │   ├── backend/
│   │   └── frontend/
│   └── README.md
│
├── .github/workflows/        # GitHub Actions CI/CD
│   ├── backend-ci.yml       # Pipeline backend
│   ├── frontend-ci.yml      # Pipeline frontend
│   ├── terraform-ci.yml     # Pipeline infrastructure
│   └── README.md
│
├── scripts/                  # Scripts utilitaires
│   ├── deploy-local.sh      # Déploiement local Minikube
│   ├── cleanup-local.sh     # Nettoyage environnement local
│   └── dev-with-docker-compose.sh  # Démarrage Docker Compose
│
├── app-back/                 # Backend Java Spring Boot
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile
│   └── README.md
│
├── app-front/                # Frontend Angular
│   ├── src/
│   ├── package.json
│   ├── Dockerfile
│   ├── nginx.conf
│   └── README.md
│
├── docker-compose.yml        # Docker Compose pour dev local
├── README.md                 # Ce fichier
└── .gitignore
```

## ⚙️ Prérequis

### Outils nécessaires

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/) >= 1.28
- [Helm](https://helm.sh/docs/intro/install/) >= 3.0
- [AWS CLI](https://aws.amazon.com/cli/) (configuré avec credentials)
- [Docker](https://docs.docker.com/get-docker/) >= 24.0
- Compte [GitHub](https://github.com) avec Actions activé

### Comptes cloud

- Compte AWS avec permissions IAM pour EKS
- OU environnement local avec Minikube/Kind

## 🚀 Démarrage Rapide

### Option 1 : Développement Local (recommandé pour débuter)

#### A. Avec script automatique Minikube

```bash
# Déploiement complet en une commande
./scripts/deploy-local.sh

# Accès : http://<minikube-ip>:30081
```

#### B. Avec Docker Compose (encore plus rapide)

```bash
# Lancer l'environnement dev
./scripts/dev-with-docker-compose.sh

# Accès : http://localhost
```

Voir [k8s/local/README.md](k8s/local/README.md) pour plus de détails.

### Option 2 : Test local sans Kubernetes

```bash
# Backend
cd app-back
mvn spring-boot:run
# → http://localhost:8080

# Frontend (dans un autre terminal)
cd app-front
npm install && npm start
# → http://localhost:4200
```

### Option 3 : Déploiement Production (AWS EKS)

#### 1. Provisionner l'infrastructure

```bash
cd infra

# Initialiser Terraform
terraform init

# Vérifier le plan
terraform plan

# Appliquer la configuration
terraform apply

# Configurer kubectl
aws eks update-kubeconfig --region eu-west-1 --name devops-vitrine-cluster
```

#### 2. Déployer l'application

##### A. Avec kubectl (manifests)

```bash
cd k8s

# Créer les secrets (pour GHCR)
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<your-github-username> \
  --docker-password=<your-github-token>

# Déployer
kubectl apply -f manifests/
```

##### B. Avec Helm (recommandé)

```bash
cd k8s

# Backend
helm install backend helm/backend \
  --set image.tag=latest

# Frontend
helm install frontend helm/frontend \
  --set image.tag=latest
```

#### 3. Vérifier le déploiement

```bash
# Vérifier les pods
kubectl get pods

# Vérifier les services
kubectl get svc

# Obtenir l'URL du frontend
kubectl get svc frontend-service
```


## 🔄 CI/CD Pipeline

Le pipeline GitHub Actions automatise :

### Workflows

1. **Backend CI/CD** ([backend-ci.yml](.github/workflows/backend-ci.yml))
   - Build & Test (Maven, JUnit)
   - Security Scan (Trivy)
   - Docker Build & Push (GHCR)
   - Deploy Kubernetes

2. **Frontend CI/CD** ([frontend-ci.yml](.github/workflows/frontend-ci.yml))
   - Build & Test (npm, Jasmine)
   - Security Scan
   - Docker Build & Push
   - Deploy Kubernetes

3. **Terraform Infrastructure** ([terraform-ci.yml](.github/workflows/terraform-ci.yml))
   - Terraform Plan
   - Terraform Apply
   - tfsec Security Scan

### Configuration

Secrets à définir dans **Settings > Secrets and variables > Actions** :

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key |
| `KUBE_CONFIG` | Kubeconfig base64 |

Voir [.github/workflows/README.md](.github/workflows/README.md) pour plus de détails.

## 📊 Observabilité

### Métriques Prometheus

Le backend expose des métriques sur `/actuator/prometheus` :
- JVM metrics (heap, GC, threads)
- HTTP requests (latency, errors)
- Custom business metrics

### Health Checks

- **Liveness** : `/actuator/health/liveness`
- **Readiness** : `/actuator/health/readiness`

### Grafana Dashboards

À venir : Dashboards Grafana pour monitoring complet.

## ✅ Bonnes Pratiques DevOps Appliquées

### Infrastructure as Code
- ✅ Terraform avec modules officiels AWS
- ✅ Variables externalisées
- ✅ State distant (S3)
- ✅ Versioning des providers

### Kubernetes
- ✅ Health checks (liveness + readiness)
- ✅ Resource limits et requests
- ✅ Rolling updates (zero downtime)
- ✅ ConfigMaps et Secrets séparés
- ✅ Helm charts pour déploiement

### CI/CD
- ✅ Pipeline multi-stages
- ✅ Tests automatisés
- ✅ Security scanning
- ✅ Docker multi-stage builds
- ✅ Déploiement manuel en production
- ✅ Rollback automatique

### Sécurité
- ✅ Images Docker non-root
- ✅ Secrets Kubernetes (à améliorer avec Vault)
- ✅ Scan de vulnérabilités (Trivy)
- ✅ HTTPS/TLS (à configurer)

### Observabilité
- ✅ Métriques Prometheus
- ✅ Logs structurés
- ✅ Health endpoints
- ✅ Annotations pour monitoring

## 🧪 Tests

### Backend

```bash
cd app-back
mvn test                    # Tests unitaires
mvn verify                  # Tests d'intégration
mvn jacoco:report           # Coverage report
```

### Frontend

```bash
cd app-front
npm test                    # Tests unitaires
npm run test:ci             # Mode CI (headless)
npm run lint                # Linting
```

## 📚 Documentation

Chaque dossier contient un README.md détaillé :

- [Infrastructure (Terraform)](infra/README.md)
- [Kubernetes](k8s/README.md)
- [CI/CD Pipeline](.github/workflows/README.md)
- [Backend Java](app-back/README.md)
- [Frontend Angular](app-front/README.md)

## 🔗 Ressources

- [Terraform AWS EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Angular Documentation](https://angular.io/docs)
- [GitHub Actions](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## 🤝 Contribution

Ce projet est un portfolio personnel. Les suggestions sont les bienvenues via issues.

## 📄 License

MIT License - Libre d'utilisation pour apprentissage et portfolio.

---

**Développé par** : [Votre Nom] - Ingénieur DevOps / SRE
**Contact** : [votre-email@example.com]
**LinkedIn** : [linkedin.com/in/votre-profil](https://linkedin.com)

---

### 🎯 Prochaines améliorations

- [ ] Ajouter Ingress Controller (nginx-ingress)
- [ ] Implémenter HashiCorp Vault pour secrets
- [ ] Ajouter monitoring Grafana complet
- [ ] Mettre en place Elastic Stack (ELK) pour logs
- [ ] Implémenter ArgoCD pour GitOps
- [ ] Ajouter tests E2E (Cypress)
- [ ] Configurer Auto-scaling (HPA)
