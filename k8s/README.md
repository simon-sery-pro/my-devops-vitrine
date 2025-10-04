# Kubernetes - Manifests & Helm Charts

Ce dossier contient les manifests Kubernetes et charts Helm pour déployer l'application full-stack.

## 📁 Structure

```
/k8s
├── /manifests          # Fichiers YAML Kubernetes bruts
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── configmap.yaml
│   └── secret.yaml
└── /helm               # Charts Helm pour déploiement avancé
    ├── /backend
    └── /frontend
```

## 🚀 Déploiement avec kubectl (manifests)

### Prérequis
- Cluster Kubernetes fonctionnel
- `kubectl` configuré avec le bon contexte

### 1. Créer les secrets
```bash
# Secret pour accès GitLab Registry
kubectl create secret docker-registry gitlab-registry-secret \
  --docker-server=registry.gitlab.com \
  --docker-username=<votre-username> \
  --docker-password=<votre-token> \
  --docker-email=<votre-email>

# Appliquer les autres secrets
kubectl apply -f manifests/secret.yaml
```

### 2. Déployer les ConfigMaps
```bash
kubectl apply -f manifests/configmap.yaml
```

### 3. Déployer le backend
```bash
kubectl apply -f manifests/backend-deployment.yaml
kubectl apply -f manifests/backend-service.yaml
```

### 4. Déployer le frontend
```bash
kubectl apply -f manifests/frontend-deployment.yaml
kubectl apply -f manifests/frontend-service.yaml
```

### 5. Vérifier les déploiements
```bash
# Vérifier les pods
kubectl get pods

# Vérifier les services
kubectl get svc

# Logs du backend
kubectl logs -f deployment/backend

# Accéder au frontend (LoadBalancer)
kubectl get svc frontend-service
```

## ⚓ Déploiement avec Helm (recommandé)

### Installation du chart backend
```bash
helm install backend helm/backend \
  --set image.repository=registry.gitlab.com/yourproject/backend \
  --set image.tag=v1.0.0
```

### Installation du chart frontend
```bash
helm install frontend helm/frontend \
  --set image.repository=registry.gitlab.com/yourproject/frontend \
  --set image.tag=v1.0.0
```

### Mise à jour
```bash
helm upgrade backend helm/backend --set image.tag=v1.1.0
```

### Désinstallation
```bash
helm uninstall backend
helm uninstall frontend
```

## 🔧 Configuration

### ConfigMaps
- `backend-config` : configuration DB, profils Spring
- `frontend-config` : URL de l'API backend

### Secrets
- `backend-secret` : mot de passe DB, JWT secret
- `gitlab-registry-secret` : accès au container registry

⚠️ **En production** : utiliser External Secrets Operator ou Sealed Secrets

## 🏗️ Health Checks

### Backend
- **Liveness** : `/actuator/health/liveness`
- **Readiness** : `/actuator/health/readiness`

### Frontend
- **Liveness/Readiness** : `/` (nginx)

## 📊 Observabilité

Les pods backend exposent des métriques Prometheus sur `/actuator/prometheus` (port 8080).

Annotations ajoutées :
```yaml
prometheus.io/scrape: "true"
prometheus.io/port: "8080"
prometheus.io/path: "/actuator/prometheus"
```

## 🔄 Rolling Updates

Stratégie configurée :
- `maxSurge: 1` : 1 pod supplémentaire pendant update
- `maxUnavailable: 0` : aucun pod indisponible (zero downtime)

## 💡 Bonnes pratiques appliquées

- ✅ Health checks (liveness + readiness)
- ✅ Resource limits et requests
- ✅ Rolling updates avec zero downtime
- ✅ Secrets séparés des ConfigMaps
- ✅ Labels et selectors cohérents
- ✅ ImagePullSecrets pour registries privés
- ✅ Annotations Prometheus pour monitoring

## 🧪 Test local avec Minikube

```bash
# Démarrer minikube
minikube start

# Déployer
kubectl apply -f manifests/

# Accéder au service frontend
minikube service frontend-service
```
