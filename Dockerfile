# --- Stage 1: Build stage ---
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
# Download dependencies first to utilize Docker layer caching
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# --- Stage 2: Runtime stage ---
FROM tomcat:9.0-jdk17-temurin-jammy
WORKDIR /usr/local/tomcat

# Install curl in tomcat image for Docker healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Remove default Tomcat webapps to clean up
RUN rm -rf webapps/*

# Copy built WAR file from builder stage
COPY --from=builder /app/target/voyastra.war webapps/voyastra.war

# Create dynamic upload directory
RUN mkdir -p /var/voyastra/uploads && chmod -R 777 /var/voyastra/uploads

# Expose HTTP port
EXPOSE 8080

# Environment variables defaults
ENV UPLOAD_DIR=/var/voyastra/uploads
ENV DB_HOST=mysql
ENV DB_PORT=3306
ENV DB_NAME=voyastra
ENV DB_USER=root
ENV DB_PASSWORD=root

# Set up health check using curl calling our HealthServlet
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:8080/voyastra/health || exit 1

CMD ["catalina.sh", "run"]
