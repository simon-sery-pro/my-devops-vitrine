# 📊 Observabilité - Stack LGTM avec OpenTelemetry

Stack d'observabilité complète basée sur **OpenTelemetry** et les outils **Grafana** (LGTM : Loki, Grafana, Tempo, Mimir).

## 🏗️ Architecture

```
┌──────────────┐     ┌──────────────┐
│   Backend    │     │   Frontend   │
│  (Spring)    │     │  (Angular)   │
└──────┬───────┘     └──────┬───────┘
       │ OTLP                │ OTLP
       │ (traces,logs,       │
       │  metrics)            │
       └────────┬─────────────┘
                ↓
    ┌─────────────────────────┐
    │  OpenTelemetry          │
    │  Collector              │
    │  (Gateway centrale)     │
    └───┬──────┬────────┬─────┘
        │      │        │
   Traces   Logs    Metrics
        │      │        │
        ↓      ↓        ↓
    ┌─────┐ ┌──────┐ ┌───────┐
    │Tempo│ │ Loki │ │ Mimir │
    └──┬──┘ └───┬──┘ └───┬───┘
       │        │        │
       └────────┴────────┘
                │
         ┌──────▼──────┐
         │   Grafana   │
         │ (Dashboards)│
         └─────────────┘
```

## 📦 Composants

### 1. **OpenTelemetry Collector**
- **Rôle** : Gateway centrale pour collecter toutes les données d'observabilité
- **Port** : 4317 (gRPC), 4318 (HTTP)
- **Fonctions** :
  - Réception des traces, logs et métriques
  - Transformation et enrichissement des données
  - Routing vers les backends appropriés

### 2. **Grafana Tempo** - Traces distribuées
- **Rôle** : Stockage et recherche de traces
- **Port** : 3200
- **Features** :
  - Traces complètes de bout en bout
  - Corrélation avec logs et métriques
  - Service graph génération

### 3. **Grafana Loki** - Agrégation de logs
- **Rôle** : Stockage et recherche de logs
- **Port** : 3100
- **Features** :
  - Logs structurés en JSON
  - Corrélation avec traces (traceID)
  - Query language LogQL

### 4. **Grafana Mimir** - Métriques long-terme
- **Rôle** : Stockage des métriques
- **Port** : 9009
- **Features** :
  - Compatible Prometheus
  - Stockage haute disponibilité
  - Query language PromQL

### 5. **Grafana** - Visualisation
- **Rôle** : Dashboards et visualisation
- **Port** : 3000
- **Credentials** : admin / admin

## 🚀 Démarrage

### Avec Docker Compose

```bash
# Démarrer toute la stack
docker compose up -d

# Vérifier les services
docker compose ps

# Accéder à Grafana
open http://localhost:3000
```

### URLs d'accès

| Service | URL | Description |
|---------|-----|-------------|
| **Grafana** | http://localhost:3000 | Dashboards et visualisation |
| **Backend API** | http://localhost:8080 | Application backend |
| **Frontend** | http://localhost:80 | Application web |
| **OTel Collector** | http://localhost:4318 | Endpoint OTLP HTTP |
| **Tempo** | http://localhost:3200 | API Tempo |
| **Loki** | http://localhost:3100 | API Loki |
| **Mimir** | http://localhost:9009 | API Mimir |

## 🔍 Utilisation de Grafana

### 1. Explorer les Traces (Tempo)

1. Aller dans **Explore**
2. Sélectionner datasource **Tempo**
3. Rechercher par :
   - Service name : `vitrine-backend`
   - Tags : `http.method`, `http.status_code`
   - TraceID (si connu)

**Exemple de query** :
```
{ service.name="vitrine-backend" && http.status_code=200 }
```

### 2. Explorer les Logs (Loki)

1. Aller dans **Explore**
2. Sélectionner datasource **Loki**
3. Query LogQL :

```logql
{application="vitrine-backend"} |= "error"
```

**Corrélation avec traces** :
```logql
{application="vitrine-backend"} | json | traceID="<trace-id>"
```

### 3. Explorer les Métriques (Mimir)

1. Aller dans **Explore**
2. Sélectionner datasource **Mimir**
3. Query PromQL :

```promql
# Request rate
rate(http_server_requests_seconds_count{service="vitrine-backend"}[5m])

# Latency p95
histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))

# JVM Memory
jvm_memory_used_bytes{service="vitrine-backend"}
```

## 📈 Métriques disponibles

### Backend (Spring Boot)

#### HTTP Metrics
- `http_server_requests_seconds_count` - Nombre de requêtes
- `http_server_requests_seconds_sum` - Temps total
- `http_server_requests_seconds_bucket` - Histogramme latence

#### JVM Metrics
- `jvm_memory_used_bytes` - Mémoire utilisée
- `jvm_gc_pause_seconds` - Pause GC
- `jvm_threads_live` - Threads actifs

#### Custom Metrics (via Spring Boot Actuator)
- `tasks_created_total` - Nombre de tâches créées
- `tasks_deleted_total` - Nombre de tâches supprimées

## 🔗 Corrélation Traces-Logs-Metrics

### De Trace → Logs
Dans Tempo, cliquer sur un span → "Logs for this span" → Ouvre Loki filtré par traceID

### De Trace → Metrics
Dans Tempo, cliquer sur "Metrics" → Ouvre Mimir avec les métriques du service

### De Logs → Trace
Dans Loki, si le log contient un `traceID`, cliquer dessus → Ouvre la trace dans Tempo

## 🧪 Tester l'observabilité

### Générer du trafic

```bash
# Créer des tâches
for i in {1..10}; do
  curl -X POST http://localhost:8080/api/tasks \
    -H "Content-Type: application/json" \
    -d "{\"title\":\"Task $i\",\"description\":\"Test task\"}"
done

# Lister les tâches (génère des traces)
curl http://localhost:8080/api/tasks

# Générer des erreurs (404)
curl http://localhost:8080/api/tasks/999999
```

### Vérifier dans Grafana

1. **Explore > Tempo** : Voir les traces générées
2. **Explore > Loki** : Voir les logs des requêtes
3. **Explore > Mimir** : Voir les métriques HTTP

## 📊 Dashboards pré-configurés

### Créer un dashboard personnalisé

1. Aller dans **Dashboards > New > New Dashboard**
2. Add visualization
3. Sélectionner datasource (Tempo/Loki/Mimir)
4. Créer les panels :

**Panel 1 - Request Rate** :
```promql
sum(rate(http_server_requests_seconds_count[5m])) by (method, uri)
```

**Panel 2 - Error Rate** :
```promql
sum(rate(http_server_requests_seconds_count{status=~"5.."}[5m]))
/
sum(rate(http_server_requests_seconds_count[5m]))
```

**Panel 3 - Recent Logs** :
```logql
{application="vitrine-backend"} | json
```

## 🔧 Configuration avancée

### Ajouter des traces custom

Dans le backend Spring Boot :

```java
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.Tracer;

@Autowired
private Tracer tracer;

public void myMethod() {
    Span span = tracer.spanBuilder("custom-operation").startSpan();
    try {
        // Votre code
        span.setAttribute("custom.attribute", "value");
    } finally {
        span.end();
    }
}
```

### Ajouter des logs structurés

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import net.logstash.logback.argument.StructuredArguments;

private static final Logger log = LoggerFactory.getLogger(MyClass.class);

log.info("User action",
    StructuredArguments.keyValue("userId", userId),
    StructuredArguments.keyValue("action", "create_task"));
```

## 🐛 Troubleshooting

### Les traces n'apparaissent pas

```bash
# Vérifier que le backend envoie bien les données
curl http://localhost:8080/actuator/health

# Vérifier les logs du collector
docker compose logs otel-collector

# Vérifier Tempo
curl http://localhost:3200/status/services
```

### Les logs ne sont pas structurés

Vérifier que le profil Spring est correct :
```bash
docker compose exec backend env | grep SPRING_PROFILES_ACTIVE
```

### Grafana ne voit pas les datasources

```bash
# Redémarrer Grafana
docker compose restart grafana

# Vérifier les datasources
curl http://localhost:3000/api/datasources
```

## 📚 Ressources

- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Grafana Tempo](https://grafana.com/docs/tempo/)
- [Grafana Loki](https://grafana.com/docs/loki/)
- [Grafana Mimir](https://grafana.com/docs/mimir/)
- [Spring Boot OpenTelemetry](https://opentelemetry.io/docs/instrumentation/java/spring-boot/)

## 🎯 Prochaines étapes

- [ ] Ajouter des alertes dans Grafana
- [ ] Créer des dashboards métier
- [ ] Configurer la rétention des données
- [ ] Ajouter Alertmanager
- [ ] Instrumenter le frontend Angular
- [ ] Déployer sur Kubernetes
