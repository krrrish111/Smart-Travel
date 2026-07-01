# Restore Voyastra Database from backup file to Docker Container (Windows PowerShell)
param (
    [Parameter(Mandatory=$true)]
    [string]$BackupFile
)

if (-Not (Test-Path $BackupFile)) {
    Write-Error "Backup file '$BackupFile' not found."
    Exit
}

Write-Host "Restoring database from '$BackupFile' to container 'voyastra-mysql'..."
Get-Content $BackupFile | docker exec -i voyastra-mysql mysql -u root -pHome@123 voyastra

if ($LASTEXITCODE -eq 0) {
    Write-Host "Database restoration completed successfully." -ForegroundColor Green
} else {
    Write-Warning "Restoration failed!"
}
