#!/bin/bash
# Backup Voyastra Database from Docker Container
BACKUP_DIR="./database/backups"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/voyastra_backup_$TIMESTAMP.sql"

echo "Backing up database from container 'voyastra-mysql'..."
# Fetch the password from env if possible
DB_PASS="Home@123"
if docker exec voyastra-app printenv DB_PASSWORD &>/dev/null; then
  DB_PASS=$(docker exec voyastra-app printenv DB_PASSWORD)
fi

docker exec -t voyastra-mysql mysqldump -u root -p"$DB_PASS" voyastra > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  echo "Backup completed successfully: $BACKUP_FILE"
else
  echo "Backup failed!"
  exit 1
fi
