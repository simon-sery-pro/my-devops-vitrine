# 🚀 DevOps Vitrine - Full-Stack Kubernetes Project

Projet vitrine démontrant les compétences **DevOps / SRE** avec déploiement d'une application full-stack sur Kubernetes, Infrastructure as Code (Terraform), CI/CD GitLab, et observabilité complète.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28-326CE5?logo=kubernetes)
![Terraform](https://img.shields.io/badge/Terraform-1.0+-7B42BC?logo=terraform)
![GitLab CI](https://img.shields.io/badge/GitLab%20CI-CD-FCA121?logo=gitlab)

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
│                       GitLab CI/CD                          │
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
- **CI/CD** : GitLab CI/CD
- **Registry** : GitLab Container Registry
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
│   ├── manifests/           # YAML Kubernetes bruts
│   │   ├── backend-deployment.yaml
│   │   ├── frontend-deployment.yaml
│   │   ├── configmap.yaml
│   │   └── secret.yaml
│   ├── helm/                # Charts Helm
│   │   ├── backend/
│   │   └── frontend/
│   └── README.md
│
├── ci-cd/                    # Pipeline GitLab CI/CD
│   ├── .gitlab-ci.yml       # Pipeline complet
│   └── README.md
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
- [GitLab](https://gitlab.com) account avec Runner actif

### Comptes cloud

- Compte AWS avec permissions IAM pour EKS
- OU environnement local avec Minikube/Kind

## 🚀 Démarrage Rapide

### 1. Provisionner l'infrastructure

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

### 2. Déployer l'application

#### Option A : Avec kubectl (manifests)

```bash
cd k8s

# Créer les secrets
kubectl create secret docker-registry gitlab-registry-secret \
  --docker-server=registry.gitlab.com \
  --docker-username=<your-username> \
  --docker-password=<your-token>

# Déployer
kubectl apply -f manifests/
```

#### Option B : Avec Helm (recommandé)

```bash
cd k8s

# Backend
helm install backend helm/backend \
  --set image.tag=latest

# Frontend
helm install frontend helm/frontend \
  --set image.tag=latest
```

### 3. Vérifier le déploiement

```bash
# Vérifier les pods
kubectl get pods

# Vérifier les services
kubectl get svc

# Obtenir l'URL du frontend
kubectl get svc frontend-service
```

### 4. Tester localement (développement)

#### Backend

```bash
cd app-back
mvn spring-boot:run
# → http://localhost:8080
```

#### Frontend

```bash
cd app-front
npm install
npm start
# → http://localhost:4200
```

## 🔄 CI/CD Pipeline

Le pipeline GitLab CI/CD automatise :

### Stages

1. **BUILD** 🔨
   - Compilation backend (Maven)
   - Build frontend (npm)

2. **TEST** ✅
   - Tests unitaires (JUnit, Jasmine)
   - Coverage reports
   - Security scan (Trivy)

3. **PACKAGE** 📦
   - Build images Docker
   - Push vers GitLab Registry

4. **DEPLOY** 🚀
   - Déploiement Kubernetes
   - Rolling updates
   - Health checks

5. **ROLLBACK** ⏮️
   - Retour arrière manuel si nécessaire

### Configuration

Variables à définir dans **GitLab > Settings > CI/CD > Variables** :

| Variable | Description |
|----------|-------------|
| `CI_REGISTRY_USER` | Username GitLab |
| `CI_REGISTRY_PASSWORD` | Token GitLab |
| `KUBE_CONFIG` | Kubeconfig base64 |

Voir [ci-cd/README.md](ci-cd/README.md) pour plus de détails.

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
- [CI/CD Pipeline](ci-cd/README.md)
- [Backend Java](app-back/README.md)
- [Frontend Angular](app-front/README.md)

## 🔗 Ressources

- [Terraform AWS EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Angular Documentation](https://angular.io/docs)
- [GitLab CI/CD](https://docs.gitlab.com/ee/ci/)

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
