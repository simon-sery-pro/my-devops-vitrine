# CI/CD Pipeline - GitHub Actions

Pipeline CI/CD complet pour automatiser le build, test, et déploiement de l'application full-stack sur Kubernetes.

## 📋 Workflows disponibles

### 1. **Backend CI/CD** ([backend-ci.yml](backend-ci.yml))

Workflow pour le backend Java Spring Boot.

**Déclencheurs** :
- Push sur `main` ou `develop` (si changements dans `app-back/`)
- Pull Request vers `main`
- Manuel (`workflow_dispatch`)

**Jobs** :
- ✅ **Build & Test** : Compilation Maven, tests JUnit, coverage
- 🔒 **Security Scan** : Analyse Trivy
- 📦 **Docker Build & Push** : Build image + push vers GitHub Container Registry
- 🚀 **Deploy** : Déploiement Kubernetes (production uniquement)
- ⏮️ **Rollback** : Retour arrière manuel

### 2. **Frontend CI/CD** ([frontend-ci.yml](frontend-ci.yml))

Workflow pour le frontend Angular.

**Déclencheurs** :
- Push sur `main` ou `develop` (si changements dans `app-front/`)
- Pull Request vers `main`
- Manuel

**Jobs** :
- ✅ **Build & Test** : Build Angular, tests Jasmine/Karma, lint
- 🔒 **Security Scan** : npm audit + Trivy
- 📦 **Docker Build & Push** : Build image nginx + push vers GHCR
- 🚀 **Deploy** : Déploiement Kubernetes

### 3. **Terraform Infrastructure** ([terraform-ci.yml](terraform-ci.yml))

Workflow pour l'infrastructure as code.

**Déclencheurs** :
- Push sur `main` (si changements dans `infra/`)
- Pull Request vers `main`
- Manuel

**Jobs** :
- ✅ **Plan** : terraform validate, format, plan
- 🚀 **Apply** : terraform apply (main uniquement)
- 🔒 **Security Scan** : tfsec

## 🔧 Configuration requise

### Secrets GitHub

Aller dans **Settings > Secrets and variables > Actions** et ajouter :

| Secret | Description | Comment l'obtenir |
|--------|-------------|-------------------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key | IAM User avec permissions EKS |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key | IAM User |
| `KUBE_CONFIG` | Kubeconfig base64 | `cat ~/.kube/config \| base64 -w 0` |

### Variables d'environnement

Aller dans **Settings > Environments** et créer :
- `production` (pour déploiements en prod)
- `infrastructure-production` (pour Terraform)

### Permissions

Le workflow nécessite les permissions suivantes (automatiques) :
- **packages: write** : pour push vers GitHub Container Registry
- **contents: read** : pour checkout du code
- **security-events: write** : pour upload des résultats de scan

## 🚀 Utilisation

### Déploiement automatique

1. **Modifier le code** :
   ```bash
   git checkout -b feature/ma-fonctionnalite
   # Faire vos modifications
   git add .
   git commit -m "Add: nouvelle fonctionnalité"
   git push origin feature/ma-fonctionnalite
   ```

2. **Créer une Pull Request** :
   - Les workflows s'exécutent automatiquement
   - Tests et validations visibles dans la PR

3. **Merger vers main** :
   ```bash
   # Après review et approbation
   git checkout main
   git merge feature/ma-fonctionnalite
   git push origin main
   ```
   - Les images Docker sont buildées et pushées
   - Le déploiement en production est automatique

### Déploiement manuel

1. Aller dans **Actions**
2. Sélectionner le workflow (Backend/Frontend)
3. Cliquer sur **Run workflow**
4. Choisir la branche
5. Cliquer **Run workflow**

### Rollback

1. Aller dans **Actions**
2. Sélectionner **Backend CI/CD**
3. Cliquer **Run workflow**
4. Le job `rollback` s'exécutera

## 📊 Rapports et Artifacts

### Test Reports
- Résultats JUnit visibles dans l'onglet **Actions > Workflow Run**
- Coverage reports uploadés vers Codecov

### Security Scans
- Résultats Trivy dans **Security > Code scanning alerts**
- npm audit pour les dépendances frontend

### Artifacts
- JAR backend (1 jour de rétention)
- Build frontend (1 jour)
- Terraform plan (5 jours)

## 🐳 Images Docker

Les images sont automatiquement publiées sur **GitHub Container Registry** :

```
ghcr.io/<votre-username>/my-devops-vitrine/backend:latest
ghcr.io/<votre-username>/my-devops-vitrine/frontend:latest
```

Tags générés :
- `latest` : dernière version de `main`
- `main-<sha>` : version spécifique du commit
- `develop` : dernière version de `develop`

## 🔄 Workflow complet

```
Push/PR → Build → Test → Security Scan → Docker Build → Deploy → Verify
```

### Feature Branch
```
feature/* → Build + Test uniquement
```

### Main Branch
```
main → Build + Test + Security + Docker Build + Deploy Production
```

## 📝 Bonnes pratiques appliquées

- ✅ **Caching** : Maven, npm, Docker layers
- ✅ **Artifacts** : Partage entre jobs
- ✅ **Permissions** : Principe du moindre privilège
- ✅ **Environments** : Protection production
- ✅ **Security** : Scans automatiques (Trivy, tfsec)
- ✅ **Tests** : Automatisés avec reports
- ✅ **Rollback** : Rapide et facile
- ✅ **Cache Docker** : GitHub Actions cache

## 🧪 Test local des workflows

Utiliser [act](https://github.com/nektos/act) pour tester localement :

```bash
# Installer act
brew install act

# Tester le workflow backend
act -W .github/workflows/backend-ci.yml

# Tester avec secrets
act -W .github/workflows/backend-ci.yml --secret-file .secrets
```

## 📈 Monitoring des workflows

- **Actions tab** : Voir tous les runs
- **Insights > Actions** : Statistiques et temps d'exécution
- **Notifications** : Configurables par email/Slack

## 🔗 Ressources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Terraform GitHub Actions](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)
- [kubectl GitHub Action](https://github.com/Azure/setup-kubectl)

## 🛠️ Customisation

### Ajouter un nouveau job

```yaml
mon-job:
  name: Mon Job Custom
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - name: Exécuter script
      run: echo "Hello World"
```

### Ajouter des notifications

```yaml
- name: Send Slack notification
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Modifier les environnements

Éditer les sections `environment` dans les workflows pour changer :
- Nom de l'environnement
- URL de déploiement
- Protection rules
