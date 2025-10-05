#!/bin/bash
# =================================================================
# Script pour lancer l'environnement de dev avec Docker Compose
# Alternative plus rapide que Kubernetes pour développement
# =================================================================

set -e

echo "🐳 Démarrage avec Docker Compose"
echo "================================="

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Vérifier Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose n'est pas installé${NC}"
    exit 1
fi

# Choisir le mode
echo ""
echo "Choisissez le mode:"
echo "  1) Dev (H2 in-memory, sans PostgreSQL)"
echo "  2) Dev avec PostgreSQL"
echo ""
read -p "Votre choix (1 ou 2): " choice

case $choice in
    1)
        echo -e "${YELLOW}🚀 Démarrage en mode dev (H2)...${NC}"
        docker compose up -d --build
        ;;
    2)
        echo -e "${YELLOW}🚀 Démarrage en mode dev avec PostgreSQL...${NC}"
        docker compose --profile with-postgres up -d --build
        ;;
    *)
        echo -e "${RED}❌ Choix invalide${NC}"
        exit 1
        ;;
esac

# Attendre que les services soient prêts
echo -e "${YELLOW}⏳ Attente du démarrage des services...${NC}"
sleep 5

# Vérifier le statut
docker compose ps

echo ""
echo -e "${GREEN}✅ Services démarrés !${NC}"
echo ""
echo "📊 Accès aux services:"
echo "====================="
echo -e "${GREEN}🌐 Frontend:${NC} http://localhost"
echo -e "${GREEN}🔌 Backend API:${NC} http://localhost:8080"
echo -e "${GREEN}💚 Health Check:${NC} http://localhost:8080/actuator/health"
echo -e "${GREEN}🗄️  H2 Console:${NC} http://localhost:8080/h2-console"
if [ "$choice" = "2" ]; then
    echo -e "${GREEN}🐘 PostgreSQL:${NC} localhost:5432 (user: postgres, password: postgres)"
fi
echo ""
echo "📝 Commandes utiles:"
echo "===================="
echo "  • Logs:              docker compose logs -f"
echo "  • Logs backend:      docker compose logs -f backend"
echo "  • Logs frontend:     docker compose logs -f frontend"
echo "  • Arrêter:           docker compose down"
echo "  • Rebuild:           docker compose up -d --build"
echo ""

