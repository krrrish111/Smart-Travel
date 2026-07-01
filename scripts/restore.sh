#!/bin/bash
# Restore Voyastra Database from backup file to Docker Container
if [ -z "$1" ]; then
  echo "Usage: ./restore.sh <path_to_backup_file>"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Error: Backup file '$BACKUP_FILE' not found."
  exit 1
fi

echo "Restoring database from '$BACKUP_FILE' to container 'voyastra-mysql'..."
DB_PASS="Home@123"
if docker exec voyastra-app printenv DB_PASSWORD &>/dev/null; then
  DB_PASS=$(docker exec voyastra-app printenv DB_PASSWORD)
fi

docker exec -i voyastra-mysql mysql -u root -p"$DB_PASS" voyastra < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  echo "Database restoration completed successfully."
else
  echo "Restoration failed!"
  exit 1
fi
