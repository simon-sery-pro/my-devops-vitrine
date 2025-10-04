# =================================================================
# Dockerfile multi-stage pour Java Spring Boot
# Build optimisé avec layer caching Maven
# =================================================================

# Stage 1: Build avec Maven
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copier le POM et télécharger les dépendances (layer cache)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le code source et builder
COPY src ./src
RUN mvn clean package -DskipTests -B

# Stage 2: Runtime avec JRE minimal
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Créer un utilisateur non-root pour sécurité
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copier le JAR depuis le stage builder
COPY --from=builder /app/target/*.jar app.jar

# Exposer le port
EXPOSE 8080

# Variables d'environnement
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health/liveness || exit 1

# Point d'entrée
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
