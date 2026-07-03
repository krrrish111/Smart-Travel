# Voyastra

## Project Overview
Voyastra is a comprehensive travel planning platform designed to make booking hotels, generating itineraries, and discovering local experiences seamless and intuitive. It leverages AI for trip generation, along with integrations for Maps, Payments, and SMS/Email communications.

## Tech Stack
- **Backend:** Java 17, Java Servlets, JSP, JSTL, Apache Tomcat 9
- **Build Tool:** Maven
- **Database:** MySQL 8
- **Containerization:** Docker & Docker Compose
- **APIs & Integrations:** Google OAuth, Google Maps, Google Places, Gemini AI, Razorpay, TravelPayouts, Twilio, JavaMail, Cloudinary

## Features
- Secure Google OAuth & Native Authentication
- AI-Powered Trip Planning via Gemini
- Interactive Maps & Directions via Google Maps
- Real-time Flight & Fare Search via TravelPayouts
- Hotel Booking & Review System
- Secure Payment Gateway via Razorpay
- Automated Email (SMTP) & SMS (Twilio) Notifications
- PDF Ticket Generation

## Environment Variables
Before running the application, copy `.env.example` to `.env` and fill in your keys:
```bash
cp .env.example .env
```
Ensure that all required keys (e.g., `GEMINI_API_KEY`, `GOOGLE_CLIENT_ID`, `RAZORPAY_KEY`, etc.) are provided.

## Docker Setup & Run Instructions
The application is fully containerized. You only need Docker and Docker Compose installed.

### Build and Run:
```bash
docker compose up --build -d
```

### Stop Containers:
```bash
docker compose down
```

## Build Instructions (Local without Docker)
1. Ensure Java 17 and Maven are installed.
2. Run `mvn clean package` to build the `voyastra.war` file.
3. Deploy the `.war` to your local Tomcat 9 `webapps` directory.

## Health Endpoint
To check if the application is running correctly, access the health endpoint:
```
http://localhost:8080/health
```
*(Note: If deploying the war file locally without Docker, the endpoint will be at `http://localhost:8080/voyastra/health` due to the webapp renaming to `voyastra.war`)*

## Deployment
Voyastra is ready to be deployed to PaaS providers like Render, AWS ECS, or DigitalOcean App Platform using the provided `Dockerfile` and `docker-compose.yml`.
Ensure that all secrets from `.env` are set as environment variables in your deployment environment.

## Troubleshooting
- **Database Connection Issues:** Ensure `DB_PASSWORD` and `MYSQL_ROOT_PASSWORD` match in your `.env` file. Wait a few seconds for the MySQL container to become fully healthy before accessing the app.
- **Missing API Keys:** If AI trips or Map features fail, verify that `GEMINI_API_KEY` and `GOOGLE_MAPS_API_KEY` are correctly loaded.
- **File Uploads Failing:** Ensure the `uploads/` directory has appropriate write permissions inside the Docker container or mapped volume.
