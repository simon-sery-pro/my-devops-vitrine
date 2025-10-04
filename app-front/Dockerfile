# =================================================================
# Dockerfile multi-stage pour Angular
# Build optimisé avec nginx pour servir l'app en production
# =================================================================

# Stage 1: Build Angular
FROM node:18-alpine AS builder

WORKDIR /app

# Copier package.json et installer les dépendances
COPY package*.json ./
RUN npm ci

# Copier le code source et builder en mode production
COPY . .
RUN npm run build:prod

# Stage 2: Servir avec nginx
FROM nginx:1.25-alpine

# Copier la configuration nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers buildés depuis le stage précédent
COPY --from=builder /app/dist/vitrine-frontend /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Démarrer nginx
CMD ["nginx", "-g", "daemon off;"]
