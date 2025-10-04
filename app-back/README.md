# Backend - Java Spring Boot

API REST pour la gestion de tâches (To-Do List) développée avec Spring Boot 3.

## 🚀 Stack Technique

- **Java 17**
- **Spring Boot 3.2** (Web, Data JPA, Actuator)
- **PostgreSQL** (production) / **H2** (développement)
- **Maven** (build)
- **Lombok** (réduction boilerplate)
- **Micrometer + Prometheus** (métriques)

## 📋 Fonctionnalités

### API REST CRUD

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/api/tasks` | Liste toutes les tâches |
| GET | `/api/tasks/{id}` | Récupère une tâche par ID |
| POST | `/api/tasks` | Crée une nouvelle tâche |
| PUT | `/api/tasks/{id}` | Met à jour une tâche |
| DELETE | `/api/tasks/{id}` | Supprime une tâche |
| GET | `/api/tasks/status/{completed}` | Filtre par statut |
| GET | `/api/tasks/search?q=titre` | Recherche par titre |

### Endpoints Actuator

| Endpoint | Description |
|----------|-------------|
| `/actuator/health` | État de santé global |
| `/actuator/health/liveness` | Probe liveness Kubernetes |
| `/actuator/health/readiness` | Probe readiness Kubernetes |
| `/actuator/metrics` | Métriques application |
| `/actuator/prometheus` | Métriques format Prometheus |

## 🛠️ Développement Local

### Prérequis

- Java 17+
- Maven 3.6+
- PostgreSQL (optionnel, H2 utilisé par défaut en dev)

### Build & Run

```bash
# Compiler
mvn clean compile

# Lancer les tests
mvn test

# Package JAR
mvn clean package

# Exécuter l'application
mvn spring-boot:run

# Ou avec le JAR
java -jar target/vitrine-backend-1.0.0.jar
```

L'API est disponible sur : `http://localhost:8080`

### Mode développement (H2)

Par défaut, le profil `dev` utilise H2 en mémoire :

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

Console H2 : `http://localhost:8080/h2-console`

### Mode production (PostgreSQL)

```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=vitrine_db
export DB_USER=postgres
export DB_PASSWORD=yourpassword

mvn spring-boot:run -Dspring-boot.run.profiles=production
```

## 🐳 Docker

### Build de l'image

```bash
docker build -t vitrine-backend:latest .
```

### Run du container

```bash
docker run -d -p 8080:8080 \
  -e DB_HOST=postgres \
  -e DB_PASSWORD=secret \
  -e SPRING_PROFILES_ACTIVE=production \
  vitrine-backend:latest
```

## 🧪 Tests

### Tests unitaires

```bash
mvn test
```

### Couverture de code (Jacoco)

```bash
mvn test jacoco:report
```

Rapport disponible : `target/site/jacoco/index.html`

### Test de l'API

```bash
# Créer une tâche
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Ma première tâche","description":"Description"}'

# Lister les tâches
curl http://localhost:8080/api/tasks

# Health check
curl http://localhost:8080/actuator/health
```

## 📊 Monitoring

### Métriques Prometheus

```bash
curl http://localhost:8080/actuator/prometheus
```

Métriques exposées :
- JVM (heap, threads, GC)
- HTTP requests (durée, statut)
- Métriques custom business

### Health Checks Kubernetes

```bash
# Liveness (application vivante)
curl http://localhost:8080/actuator/health/liveness

# Readiness (prête à recevoir du trafic)
curl http://localhost:8080/actuator/health/readiness
```

## 🏗️ Architecture

```
src/main/java/com/devops/vitrine/
├── VitrineApplication.java      # Point d'entrée
├── controller/
│   └── TaskController.java      # REST Controller
├── service/
│   └── TaskService.java         # Logique métier
├── repository/
│   └── TaskRepository.java      # Accès données (JPA)
└── model/
    └── Task.java                # Entité JPA
```

## 🔐 Sécurité

⚠️ **À améliorer pour la production** :

- [ ] Ajouter Spring Security
- [ ] Implémenter JWT authentication
- [ ] Limiter CORS (`@CrossOrigin(origins = "*")` à restreindre)
- [ ] Ajouter rate limiting
- [ ] Valider toutes les entrées utilisateur

## 📝 Variables d'environnement

| Variable | Description | Défaut |
|----------|-------------|--------|
| `SERVER_PORT` | Port du serveur | `8080` |
| `DB_HOST` | Hôte PostgreSQL | `localhost` |
| `DB_PORT` | Port PostgreSQL | `5432` |
| `DB_NAME` | Nom de la BDD | `vitrine_db` |
| `DB_USER` | Utilisateur BDD | `postgres` |
| `DB_PASSWORD` | Mot de passe BDD | `postgres` |
| `SPRING_PROFILES_ACTIVE` | Profil actif | `dev` |
| `LOG_LEVEL` | Niveau de log | `INFO` |

## 🔗 Ressources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
- [Micrometer Prometheus](https://micrometer.io/docs/registry/prometheus)
