# CI/CD Pipeline - GitLab

Pipeline CI/CD complet pour automatiser le build, test, et déploiement de l'application full-stack sur Kubernetes.

## 📋 Architecture du Pipeline

```
┌─────────┐   ┌──────┐   ┌─────────┐   ┌────────┐   ┌──────────┐
│  BUILD  │ → │ TEST │ → │ PACKAGE │ → │ DEPLOY │ → │ ROLLBACK │
└─────────┘   └──────┘   └─────────┘   └────────┘   └──────────┘
```

### Stages détaillés

1. **BUILD** 🔨
   - Compilation backend (Maven)
   - Build frontend (npm)
   - Génération des artifacts

2. **TEST** ✅
   - Tests unitaires backend (JUnit)
   - Tests frontend (Jest/Karma)
   - Lint & code quality
   - Security scan (Trivy)
   - Rapports de couverture

3. **PACKAGE** 📦
   - Build images Docker
   - Push vers GitLab Container Registry
   - Tag avec commit SHA + latest

4. **DEPLOY** 🚀
   - Déploiement Kubernetes (kubectl ou Helm)
   - Rolling update avec zero downtime
   - Health checks automatiques
   - **Déclenchement manuel** pour sécurité

5. **ROLLBACK** ⏮️
   - Retour à la version précédente
   - Déclenché manuellement si problème

## 🔧 Configuration requise

### Variables GitLab CI/CD

Configurer dans **Settings > CI/CD > Variables** :

| Variable | Description | Type |
|----------|-------------|------|
| `CI_REGISTRY_USER` | Username GitLab | Variable |
| `CI_REGISTRY_PASSWORD` | Token/Password GitLab | Protected |
| `KUBE_CONFIG` | Kubeconfig base64 | Protected, Masked |
| `SLACK_WEBHOOK_URL` | URL webhook Slack (optionnel) | Variable |

### Générer KUBE_CONFIG

```bash
# Récupérer kubeconfig depuis EKS
aws eks update-kubeconfig --region eu-west-1 --name devops-vitrine-cluster

# Encoder en base64
cat ~/.kube/config | base64 -w 0
```

Copier le résultat dans la variable `KUBE_CONFIG` sur GitLab.

## 🚀 Utilisation

### Déclenchement automatique

Le pipeline se déclenche automatiquement sur :
- Push sur `main` ou `develop`
- Merge requests
- Changements dans `/app-back` ou `/app-front`

### Déploiement manuel

1. Aller dans **CI/CD > Pipelines**
2. Sélectionner le pipeline souhaité
3. Cliquer sur ▶️ à côté du job `deploy:backend` ou `deploy:frontend`
4. Confirmer le déploiement

### Rollback

En cas de problème :

1. Aller dans **CI/CD > Pipelines**
2. Trouver le pipeline actif
3. Cliquer sur ▶️ à côté de `rollback:backend` ou `rollback:frontend`
4. Kubernetes revient automatiquement à la version précédente

## 📊 Rapports

Le pipeline génère automatiquement :

- ✅ **Test reports** : résultats JUnit visibles dans Merge Requests
- 📈 **Coverage reports** : couverture de code affichée
- 🔒 **Security scans** : vulnérabilités détectées par Trivy

## 🏗️ Bonnes pratiques appliquées

- ✅ **Cache Maven/npm** pour accélérer les builds
- ✅ **Artifacts** pour partager entre stages
- ✅ **Only/changes** pour optimiser (ne rebuild que si changements)
- ✅ **Manual deployment** sur production
- ✅ **Rollback** facile et rapide
- ✅ **Security scanning** automatique
- ✅ **Multi-stage** pour séparation des responsabilités
- ✅ **Notifications** Slack (optionnel)

## 🐳 Docker Images

Les images sont taguées avec :
- `$CI_COMMIT_SHORT_SHA` : identifiant unique du commit
- `latest` : dernière version stable

Exemple :
```
registry.gitlab.com/yourproject/backend:abc1234
registry.gitlab.com/yourproject/backend:latest
```

## 🔄 Workflows

### Feature branch
```bash
git checkout -b feature/nouvelle-fonctionnalite
git push origin feature/nouvelle-fonctionnalite
# → Pipeline exécute build + test uniquement
```

### Déploiement production
```bash
git checkout main
git merge develop
git push origin main
# → Pipeline complet (build, test, package)
# → Déploiement manuel via GitLab UI
```

## 🧪 Test local du pipeline

Utiliser `gitlab-runner` localement :

```bash
# Installer gitlab-runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# Exécuter le pipeline localement
gitlab-runner exec docker build:backend
gitlab-runner exec docker test:backend
```

## 📝 Personnalisation

### Ajouter un nouveau job

```yaml
mon-job:
  stage: test
  image: alpine:latest
  script:
    - echo "Mon script personnalisé"
  only:
    - main
```

### Modifier le déploiement

Éditer la section `deploy:*` dans `.gitlab-ci.yml` pour ajuster :
- Namespace Kubernetes
- Stratégie de déploiement (Helm vs kubectl)
- Conditions de déclenchement

## 🔗 Ressources

- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Helm Documentation](https://helm.sh/docs/)
