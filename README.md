# Voyastra Smart Travel - Production Dockerization & Deployment Guide

This guide details the containerization, environment setup, database operations, and multi-cloud deployment instructions for the Voyastra Smart Travel application.

---

## Folder Structure Summary

```
voyastra/
├── .dockerignore
├── .env.example
├── Dockerfile
├── docker-compose.yml
├── pom.xml
├── database/
│   └── init/
│       ├── 01-schema.sql  (Consolidated database schema)
│       └── 02-seed.sql    (Initial mock and administrative data)
├── scripts/
│   ├── backup.sh          (Unix database backup script)
│   ├── restore.sh         (Unix database restoration script)
│   ├── backup.ps1         (Windows database backup script)
│   └── restore.ps1        (Windows database restoration script)
└── src/
    └── main/
        └── java/com/voyastra/
            ├── config/
            │   └── ConfigManager.java (Reads system environment)
            └── controller/
                └── HealthServlet.java (System /health diagnostics)
```

---

## 1. Quick Start

Ensure Docker Desktop / Engine is running.

### Step 1: Set up Environment Variables
Duplicate `.env.example` as `.env` and fill in your details:
```bash
cp .env.example .env
```
Ensure you set your `GEMINI_API_KEY`, API tokens, and credentials.

### Step 2: Run Application
Start the entire stack using Docker Compose:
```bash
docker compose up --build -d
```
This single command compiles the project via Maven, constructs the Tomcat image, starts the MySQL database, initializes all database tables, seeds mock data, and registers phpMyAdmin.

### Step 3: Access Application
- **Main Web Application**: [http://localhost:8080/voyastra](http://localhost:8080/voyastra)
- **Health Diagnostics Endpoint**: [http://localhost:8080/voyastra/health](http://localhost:8080/voyastra/health)
- **phpMyAdmin Console**: [http://localhost:8081](http://localhost:8081)

---

## 2. Docker Operations

- **Stop Containers**:
  ```bash
  docker compose down
  ```
- **Stop and Clear Volumes**:
  ```bash
  docker compose down -v
  ```
- **View Application Logs**:
  ```bash
  docker compose logs -f voyastra
  ```
- **View Database Logs**:
  ```bash
  docker compose logs -f mysql
  ```

---

## 3. Database Backup & Restoration

Backup and restoration scripts are available inside the `scripts/` folder.

### On Linux / macOS
- **Backup**:
  ```bash
  ./scripts/backup.sh
  ```
- **Restore**:
  ```bash
  ./scripts/restore.sh ./database/backups/voyastra_backup_xxxx.sql
  ```

### On Windows (PowerShell)
- **Backup**:
  ```powershell
  .\scripts\backup.ps1
  ```
- **Restore**:
  ```powershell
  .\scripts\restore.ps1 -BackupFile .\database\backups\voyastra_backup_xxxx.sql
  ```

---

## 4. Production Cloud Deployment Guides

### A. AWS EC2 (Ubuntu VPS)
1. Provision an Ubuntu EC2 instance and associate an Elastic IP.
2. Install Docker and Docker Compose on the host:
   ```bash
   sudo apt update && sudo apt install docker.io docker-compose-v2 -y
   ```
3. Clone your codebase, navigate to the directory, and configure `.env` with production keys.
4. Run the stack:
   ```bash
   sudo docker compose up --build -d
   ```
5. Configure Security Groups to allow incoming traffic on port `8080` (or set up an Nginx reverse proxy to handle SSL/TLS traffic on `443`).

### B. Render / Railway / Google Cloud Run
1. Since Cloud Run / Render run stateless application containers, deploy the `Dockerfile` directly by connecting your Github repository.
2. Spin up a managed MySQL database instance (e.g. Google Cloud SQL or Railway database).
3. Connect the application by overriding variables in the service environment block:
   - `DB_HOST`: Mapped to the managed database hostname.
   - `DB_PORT`: Database port (e.g. `3306`).
   - `DB_NAME`: Database name.
   - `DB_USER` / `DB_PASSWORD`: Managed credentials.
   - `UPLOAD_DIR`: Point to a mounted cloud storage volume or persistent mount.
