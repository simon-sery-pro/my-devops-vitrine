# Développement Local - Kubernetes

Configuration pour déployer l'application en local avec **Minikube** ou **Kind** pour le développement.

## 🎯 Pourquoi du Kubernetes local ?

- ✅ Tester dans un environnement proche de la production
- ✅ Valider les manifests Kubernetes
- ✅ Tester les health checks, rolling updates, etc.
- ✅ Développer sans dépendre d'un cluster cloud

## 🚀 Méthode 1 : Script automatique (recommandé)

### Déploiement complet en une commande

```bash
./scripts/deploy-local.sh
```

Ce script :
1. Démarre Minikube si nécessaire
2. Build les images Docker localement
3. Déploie backend et frontend sur Kubernetes
4. Affiche les URLs d'accès

### Nettoyage

```bash
./scripts/cleanup-local.sh
```

## 🛠️ Méthode 2 : Déploiement manuel

### Prérequis

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) >= 1.30
- [kubectl](https://kubernetes.io/docs/tasks/tools/) >= 1.28
- Docker Desktop ou Docker CLI

### 1. Démarrer Minikube

```bash
# Démarrer avec 2 CPUs et 4Go RAM
minikube start --cpus 2 --memory 4096

# Vérifier le statut
minikube status

# Ouvrir le dashboard (optionnel)
minikube dashboard
```

### 2. Configurer Docker pour Minikube

```bash
# Utiliser le daemon Docker de Minikube
eval $(minikube docker-env)

# Vérifier
docker ps
```

### 3. Builder les images localement

```bash
# Backend
cd app-back
docker build -t vitrine-backend:local .

# Frontend
cd ../app-front
docker build -t vitrine-frontend:local .
cd ..
```

### 4. Déployer sur Kubernetes

```bash
# Déployer backend
kubectl apply -f k8s/local/backend-deployment-local.yaml

# Déployer frontend
kubectl apply -f k8s/local/frontend-deployment-local.yaml

# Vérifier les pods
kubectl get pods

# Attendre que les pods soient prêts
kubectl wait --for=condition=ready pod -l app=backend --timeout=120s
kubectl wait --for=condition=ready pod -l app=frontend --timeout=120s
```

### 5. Accéder à l'application

```bash
# Obtenir l'IP de Minikube
minikube ip

# Ou ouvrir directement dans le navigateur
minikube service frontend-service
minikube service backend-service
```

**URLs d'accès** :
- Frontend : `http://<minikube-ip>:30081`
- Backend API : `http://<minikube-ip>:30080`
- Backend Health : `http://<minikube-ip>:30080/actuator/health`

## 🐳 Alternative : Docker Compose

Pour un démarrage encore plus rapide (sans Kubernetes) :

```bash
./scripts/dev-with-docker-compose.sh
```

Ou manuellement :

```bash
# Mode dev simple (H2 in-memory)
docker compose up -d --build

# Avec PostgreSQL
docker compose --profile with-postgres up -d --build
```

**URLs** :
- Frontend : http://localhost
- Backend : http://localhost:8080
- H2 Console : http://localhost:8080/h2-console

## 📊 Commandes utiles

### Kubernetes / Minikube

```bash
# Voir les pods
kubectl get pods

# Logs du backend
kubectl logs -f deployment/backend

# Logs du frontend
kubectl logs -f deployment/frontend

# Décrire un pod (debug)
kubectl describe pod <pod-name>

# Accéder à un pod (shell)
kubectl exec -it deployment/backend -- /bin/sh

# Port-forward (alternative au NodePort)
kubectl port-forward deployment/backend 8080:8080

# Dashboard Minikube
minikube dashboard

# Arrêter Minikube
minikube stop

# Supprimer complètement Minikube
minikube delete
```

### Docker Compose

```bash
# Voir les logs
docker compose logs -f

# Logs d'un service spécifique
docker compose logs -f backend

# Redémarrer un service
docker compose restart backend

# Rebuild et redémarrer
docker compose up -d --build backend

# Arrêter
docker compose down

# Arrêter et supprimer les volumes
docker compose down -v
```

## 🔧 Configuration locale

### Différences avec production

| Paramètre | Production | Local |
|-----------|-----------|-------|
| Replicas | 2 | 1 |
| Database | PostgreSQL | H2 (in-memory) |
| Image Pull Policy | Always | Never (cache local) |
| Service Type | LoadBalancer | NodePort |
| Resources | CPU 500m, RAM 1Gi | CPU 100m, RAM 256Mi |
| NodePort Backend | - | 30080 |
| NodePort Frontend | - | 30081 |

### Variables d'environnement

Backend local utilise :
```yaml
SPRING_PROFILES_ACTIVE: dev
SPRING_DATASOURCE_URL: jdbc:h2:mem:testdb
SPRING_JPA_HIBERNATE_DDL_AUTO: create-drop
```

## 🧪 Tests locaux

### Tester l'API backend

```bash
# Health check
curl http://$(minikube ip):30080/actuator/health

# Créer une tâche
curl -X POST http://$(minikube ip):30080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test local","description":"Ma première tâche"}'

# Lister les tâches
curl http://$(minikube ip):30080/api/tasks
```

### Tester le frontend

Ouvrir dans le navigateur :
```bash
open http://$(minikube ip):30081
```

## 🐛 Troubleshooting

### Pods en CrashLoopBackOff

```bash
# Voir les logs
kubectl logs <pod-name>

# Décrire le pod pour voir les événements
kubectl describe pod <pod-name>
```

### Image non trouvée

```bash
# Vérifier que vous utilisez le Docker de Minikube
eval $(minikube docker-env)

# Lister les images
docker images | grep vitrine

# Rebuilder si nécessaire
docker build -t vitrine-backend:local ./app-back
```

### Service inaccessible

```bash
# Vérifier les services
kubectl get svc

# Vérifier que le pod est ready
kubectl get pods

# Tester avec port-forward
kubectl port-forward service/backend-service 8080:80
```

### Minikube ne démarre pas

```bash
# Supprimer et recréer
minikube delete
minikube start --cpus 2 --memory 4096

# Changer de driver si problème
minikube start --driver=virtualbox
# ou
minikube start --driver=hyperkit
```

## 🔄 Workflow de développement

1. **Faire vos modifications** dans `app-back/` ou `app-front/`

2. **Rebuilder l'image concernée** :
   ```bash
   eval $(minikube docker-env)
   docker build -t vitrine-backend:local ./app-back
   ```

3. **Redéployer** :
   ```bash
   kubectl rollout restart deployment/backend
   ```

4. **Vérifier les logs** :
   ```bash
   kubectl logs -f deployment/backend
   ```

## 💡 Alternatives à Minikube

### Kind (Kubernetes in Docker)

```bash
# Installer Kind
brew install kind

# Créer un cluster
kind create cluster --name vitrine

# Charger les images
kind load docker-image vitrine-backend:local --name vitrine
kind load docker-image vitrine-frontend:local --name vitrine

# Déployer
kubectl apply -f k8s/local/
```

### K3s / K3d

```bash
# Créer un cluster K3d
k3d cluster create vitrine

# Importer les images
k3d image import vitrine-backend:local -c vitrine
k3d image import vitrine-frontend:local -c vitrine
```

## 📚 Ressources

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kind Documentation](https://kind.sigs.k8s.io/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
