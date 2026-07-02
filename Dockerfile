# ==========================================
# STAGE 1: MAVEN BUILD BUILDER
# ==========================================
FROM maven:3.9.9-eclipse-temurin-21 AS builder
WORKDIR /app

# Copy pom.xml and cache dependencies offline
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build the war file
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# STAGE 2: tomcat PRODUCTION RUNTIME
# ==========================================
FROM tomcat:9.0-jdk17-temurin-jammy
WORKDIR /usr/local/tomcat

# 1. Install curl securely and clean apt cache to minimize image size
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gosu && \
    rm -rf /var/lib/apt/lists/*

# 2. Remove Tomcat default applications to reduce attack surface
RUN rm -rf webapps/*

# 3. Copy only the built war file from builder stage
COPY --from=builder /app/target/voyastra.war webapps/voyastra.war

# 4. Create upload folder and establish a secure, non-root tomcat user
RUN mkdir -p /var/voyastra/uploads && \
    groupadd -r tomcat && \
    useradd -r -g tomcat -d /usr/local/tomcat -s /sbin/nologin tomcat && \
    chown -R tomcat:tomcat /usr/local/tomcat /var/voyastra/uploads

# 5. Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 6. Expose default Tomcat HTTP port
EXPOSE 8080

# 7. Environment variable defaults
ENV UPLOAD_DIR=/var/voyastra/uploads \
    DB_HOST=mysql \
    DB_PORT=3306 \
    DB_NAME=voyastra \
    DB_USER=root \
    DB_PASSWORD=root

# 8. Define standard health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD curl -f http://localhost:8080/voyastra/health || exit 1

# 9. Set entrypoint and start Tomcat server
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
