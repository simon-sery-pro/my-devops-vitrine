#!/bin/bash
# =================================================================
# Script de déploiement local sur Minikube
# Automatise le build et déploiement pour environnement de dev
# =================================================================

set -e  # Arrêter en cas d'erreur

echo "🚀 Déploiement local sur Minikube"
echo "=================================="

# Couleurs pour output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier que Minikube est installé
if ! command -v minikube &> /dev/null; then
    echo -e "${RED}❌ Minikube n'est pas installé${NC}"
    echo "Installation: https://minikube.sigs.k8s.io/docs/start/"
    exit 1
fi

# Vérifier que kubectl est installé
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl n'est pas installé${NC}"
    exit 1
fi

# Démarrer Minikube si nécessaire
echo -e "${YELLOW}📦 Vérification de Minikube...${NC}"
if ! minikube status &> /dev/null; then
    echo -e "${YELLOW}⚡ Démarrage de Minikube...${NC}"
    minikube start --cpus 2 --memory 4096 --driver=docker
else
    echo -e "${GREEN}✅ Minikube est déjà démarré${NC}"
fi

# Configurer Docker pour utiliser le daemon Minikube
echo -e "${YELLOW}🐳 Configuration de Docker pour Minikube...${NC}"
eval $(minikube docker-env)

# Build des images Docker dans Minikube
echo -e "${YELLOW}🔨 Build de l'image backend...${NC}"
cd app-back
docker build -t vitrine-backend:local .
cd ..

echo -e "${YELLOW}🔨 Build de l'image frontend...${NC}"
cd app-front
docker build -t vitrine-frontend:local .
cd ..

# Déployer sur Kubernetes
echo -e "${YELLOW}☸️  Déploiement sur Kubernetes...${NC}"
kubectl apply -f k8s/local/backend-deployment-local.yaml
kubectl apply -f k8s/local/frontend-deployment-local.yaml

# Attendre que les déploiements soient prêts
echo -e "${YELLOW}⏳ Attente du déploiement du backend...${NC}"
kubectl wait --for=condition=available --timeout=120s deployment/backend

echo -e "${YELLOW}⏳ Attente du déploiement du frontend...${NC}"
kubectl wait --for=condition=available --timeout=120s deployment/frontend

# Afficher les informations d'accès
echo -e "${GREEN}✅ Déploiement réussi !${NC}"
echo ""
echo "📊 Informations d'accès:"
echo "========================"

# Obtenir l'IP de Minikube
MINIKUBE_IP=$(minikube ip)

echo -e "${GREEN}🌐 Frontend:${NC} http://${MINIKUBE_IP}:30081"
echo -e "${GREEN}🔌 Backend API:${NC} http://${MINIKUBE_IP}:30080"
echo -e "${GREEN}💚 Backend Health:${NC} http://${MINIKUBE_IP}:30080/actuator/health"
echo -e "${GREEN}📈 Backend Metrics:${NC} http://${MINIKUBE_IP}:30080/actuator/prometheus"
echo ""

# Commandes utiles
echo "📝 Commandes utiles:"
echo "===================="
echo "  • Voir les pods:          kubectl get pods"
echo "  • Logs backend:           kubectl logs -f deployment/backend"
echo "  • Logs frontend:          kubectl logs -f deployment/frontend"
echo "  • Dashboard Minikube:     minikube dashboard"
echo "  • Ouvrir le frontend:     minikube service frontend-service"
echo "  • Arrêter Minikube:       minikube stop"
echo "  • Supprimer déploiement:  ./scripts/cleanup-local.sh"
echo ""

# Optionnel: Ouvrir le frontend dans le navigateur
read -p "Ouvrir le frontend dans le navigateur? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    minikube service frontend-service
fi
