# Backup Voyastra Database from Docker Container (Windows PowerShell)
$BackupDir = ".\database\backups"
If (-Not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = "$BackupDir\voyastra_backup_$Timestamp.sql"

Write-Host "Backing up database from container 'voyastra-mysql'..."
docker exec -t voyastra-mysql mysqldump -u root -pHome@123 voyastra > $BackupFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "Backup completed successfully: $BackupFile" -ForegroundColor Green
} else {
    Write-Warning "Backup failed!"
}
