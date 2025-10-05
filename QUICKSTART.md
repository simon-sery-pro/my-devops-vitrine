# 🚀 Quick Start - Développement Local

Guide rapide pour tester l'application en local sans AWS.

## Option 1 : Minikube (Kubernetes local)

### Installation Minikube

**macOS :**
```bash
brew install minikube
```

**Linux :**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

**Windows :**
```powershell
choco install minikube
```

### Déploiement automatique

```bash
# Cloner le projet
git clone https://github.com/<votre-username>/my-devops-vitrine.git
cd my-devops-vitrine

# Lancer le déploiement
chmod +x scripts/deploy-local.sh
./scripts/deploy-local.sh
```

✅ C'est tout ! Le script :
- Démarre Minikube
- Build les images Docker
- Déploie sur Kubernetes
- Affiche les URLs d'accès

### Accéder à l'application

```bash
# Obtenir l'IP de Minikube
minikube ip

# Ouvrir le frontend dans le navigateur
minikube service frontend-service
```

**URLs** :
- 🌐 Frontend : `http://<minikube-ip>:30081`
- 🔌 API Backend : `http://<minikube-ip>:30080/api/tasks`
- 💚 Health Check : `http://<minikube-ip>:30080/actuator/health`

### Commandes utiles

```bash
# Voir les pods en cours
kubectl get pods

# Logs du backend
kubectl logs -f deployment/backend

# Dashboard Kubernetes
minikube dashboard

# Arrêter Minikube
minikube stop

# Nettoyer complètement
./scripts/cleanup-local.sh
```

---

## Option 2 : Docker Compose (Plus rapide)

### Déploiement

```bash
# Cloner le projet
git clone https://github.com/<votre-username>/my-devops-vitrine.git
cd my-devops-vitrine

# Lancer avec le script
chmod +x scripts/dev-with-docker-compose.sh
./scripts/dev-with-docker-compose.sh

# OU manuellement
docker compose up -d --build
```

### Accéder à l'application

**URLs** :
- 🌐 Frontend : http://localhost
- 🔌 API Backend : http://localhost:8080/api/tasks
- 💚 Health Check : http://localhost:8080/actuator/health
- 🗄️ H2 Console : http://localhost:8080/h2-console

### Commandes utiles

```bash
# Voir les logs
docker compose logs -f

# Logs d'un service
docker compose logs -f backend

# Redémarrer
docker compose restart

# Arrêter
docker compose down
```

---

## Option 3 : Sans conteneurs

### Backend

```bash
# Prérequis : Java 17, Maven
cd app-back
mvn spring-boot:run
```

Accessible sur : http://localhost:8080

### Frontend

```bash
# Prérequis : Node.js 18+
cd app-front
npm install
npm start
```

Accessible sur : http://localhost:4200

---

## 🧪 Tester l'API

```bash
# Health check
curl http://localhost:8080/actuator/health

# Créer une tâche
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Ma première tâche","description":"Test de l API"}'

# Lister les tâches
curl http://localhost:8080/api/tasks

# Récupérer une tâche
curl http://localhost:8080/api/tasks/1
```

---

## 🐛 Problèmes courants

### Minikube ne démarre pas

```bash
# Supprimer et recréer
minikube delete
minikube start --cpus 2 --memory 4096
```

### Port déjà utilisé (Docker Compose)

```bash
# Arrêter les conteneurs existants
docker compose down

# Vérifier les ports
lsof -i :8080
lsof -i :80
```

### Image Docker non trouvée

```bash
# Pour Minikube, vérifier l'environnement Docker
eval $(minikube docker-env)
docker images | grep vitrine

# Rebuilder si nécessaire
docker build -t vitrine-backend:local ./app-back
```

---

## 📚 Aller plus loin

- [Documentation Kubernetes local](k8s/local/README.md)
- [Documentation Backend](app-back/README.md)
- [Documentation Frontend](app-front/README.md)
- [Documentation complète](README.md)

---

**🎯 Bon développement !**
