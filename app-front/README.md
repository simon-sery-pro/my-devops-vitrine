# Frontend - Angular

Application web de gestion de tâches (To-Do List) développée avec Angular 17.

## 🚀 Stack Technique

- **Angular 17** (standalone components)
- **TypeScript 5.2**
- **RxJS 7** (programmation réactive)
- **HttpClient** (communication API)
- **Nginx** (serveur web pour production)

## 📋 Fonctionnalités

- ✅ Créer des tâches avec titre et description
- ✅ Marquer comme complété / non complété
- ✅ Modifier une tâche existante
- ✅ Supprimer une tâche
- ✅ Interface responsive (mobile-friendly)
- ✅ Communication temps réel avec l'API backend

## 🛠️ Développement Local

### Prérequis

- Node.js 18+
- npm 9+

### Installation

```bash
cd app-front
npm install
```

### Lancement en développement

```bash
npm start
# ou
ng serve
```

L'application est disponible sur : `http://localhost:4200`

### Configuration de l'API

Modifier `src/environments/environment.ts` pour pointer vers votre backend :

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080'  // URL du backend
};
```

## 🏗️ Build Production

### Build des assets

```bash
npm run build:prod
# ou
ng build --configuration production
```

Les fichiers sont générés dans `/dist/vitrine-frontend`

### Optimisations appliquées

- ✅ Tree shaking et minification
- ✅ Bundling optimisé
- ✅ AOT compilation
- ✅ Lazy loading (si multi-routes)

## 🐳 Docker

### Build de l'image

```bash
docker build -t vitrine-frontend:latest .
```

### Run du container

```bash
docker run -d -p 80:80 vitrine-frontend:latest
```

L'application est accessible sur : `http://localhost`

### Docker multi-stage

Le Dockerfile utilise :
1. **Stage 1** : Build avec Node.js
2. **Stage 2** : Runtime avec nginx (image légère)

## 🧪 Tests

### Tests unitaires

```bash
npm test
# ou
ng test
```

### Tests unitaires en mode CI

```bash
npm run test:ci
```

### Lint du code

```bash
npm run lint
```

## 📂 Architecture

```
src/
├── app/
│   ├── app.component.ts          # Composant principal
│   ├── app.component.html        # Template
│   ├── app.component.css         # Styles
│   ├── task.model.ts             # Interface Task
│   └── task.service.ts           # Service HTTP
├── environments/
│   ├── environment.ts            # Config dev
│   └── environment.prod.ts       # Config prod
├── main.ts                       # Point d'entrée
├── index.html                    # HTML principal
└── styles.css                    # Styles globaux
```

## 🎨 Interface utilisateur

- Design moderne avec dégradés
- Cartes pour chaque tâche
- États visuels (complété / non complété)
- Mode édition inline
- Responsive design

## 🔗 Intégration Backend

Le service `TaskService` communique avec l'API REST :

```typescript
GET    /api/tasks              → Lister toutes les tâches
GET    /api/tasks/{id}         → Récupérer une tâche
POST   /api/tasks              → Créer une tâche
PUT    /api/tasks/{id}         → Mettre à jour
DELETE /api/tasks/{id}         → Supprimer
```

## 🌐 Configuration nginx

Le fichier `nginx.conf` configure :
- Compression gzip
- Headers de sécurité
- Routing SPA (single page app)
- Cache des assets statiques
- Health check endpoint `/health`

## 📦 Scripts disponibles

| Script | Description |
|--------|-------------|
| `npm start` | Lance le serveur de dev |
| `npm run build` | Build de production |
| `npm test` | Lance les tests |
| `npm run test:ci` | Tests en mode CI |
| `npm run lint` | Lint du code |

## 🔧 Variables d'environnement

En production, l'URL de l'API est configurée dans `environment.prod.ts` :

```typescript
apiUrl: 'http://backend-service/api'
```

Cette URL correspond au service Kubernetes backend.

## 🚀 Déploiement Kubernetes

L'image Docker est déployée via les manifests Kubernetes dans `/k8s` :

```yaml
image: registry.gitlab.com/yourproject/frontend:latest
```

Le service est exposé via :
- **LoadBalancer** (cloud)
- **NodePort** (local)
- **Ingress** (avec nom de domaine)

## 🔗 Ressources

- [Angular Documentation](https://angular.io/docs)
- [RxJS Documentation](https://rxjs.dev/)
- [Nginx Documentation](https://nginx.org/en/docs/)
