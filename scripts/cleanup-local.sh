#!/bin/bash
# =================================================================
# Script de nettoyage de l'environnement local Minikube
# =================================================================

set -e

echo "🧹 Nettoyage de l'environnement local"
echo "======================================"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Supprimer les déploiements
echo -e "${YELLOW}🗑️  Suppression des déploiements...${NC}"
kubectl delete -f k8s/local/backend-deployment-local.yaml --ignore-not-found=true
kubectl delete -f k8s/local/frontend-deployment-local.yaml --ignore-not-found=true

echo -e "${GREEN}✅ Déploiements supprimés${NC}"

# Proposer de supprimer les images Docker
read -p "Supprimer les images Docker locales? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    eval $(minikube docker-env)
    docker rmi vitrine-backend:local vitrine-frontend:local 2>/dev/null || true
    echo -e "${GREEN}✅ Images Docker supprimées${NC}"
fi

# Proposer d'arrêter Minikube
read -p "Arrêter Minikube? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    minikube stop
    echo -e "${GREEN}✅ Minikube arrêté${NC}"
fi

echo -e "${GREEN}✨ Nettoyage terminé${NC}"
