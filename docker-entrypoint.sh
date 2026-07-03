#!/bin/bash
set -e

echo "========================================="
echo "VOYASTRA CONTAINER STARTUP"
echo "========================================="

echo "Running user: $(whoami)"
echo "UID/GID: $(id -u)/$(id -g)"
echo "Current working directory: $(pwd)"
echo ""

echo "Directory permissions:"

# VALIDATE DIRECTORIES
for dir in /var/voyastra/uploads /var/voyastra/tickets /var/voyastra/pdfs /usr/local/tomcat/logs; do
    if [ ! -d "$dir" ]; then
        echo "Creating missing directory: $dir"
        mkdir -p "$dir"
    fi
    
    # Check if writable by tomcat user
    if ! su -s /bin/bash -c "test -w $dir" tomcat; then
        if ! gosu tomcat test -w "$dir" 2>/dev/null; then
           # We will fix it below, but first check if we even can
           chown -R tomcat:tomcat "$dir" || true
           if ! gosu tomcat test -w "$dir" 2>/dev/null; then
               echo "ERROR: Directory not writable by tomcat: $dir"
               exit 1
           fi
        fi
    fi
done

# PRODUCTION PERMISSIONS
find /var/voyastra -type d -exec chmod 775 {} \;
find /var/voyastra -type f -exec chmod 664 {} \;
chown -R tomcat:tomcat /var/voyastra /usr/local/tomcat/logs

echo "Uploads: $(ls -ld /var/voyastra/uploads)"
echo "Tickets: $(ls -ld /var/voyastra/tickets)"
echo "PDFs: $(ls -ld /var/voyastra/pdfs)"
echo "Tomcat logs: $(ls -ld /usr/local/tomcat/logs)"
echo ""

echo "Disk usage:"
df -h /var/voyastra /usr/local/tomcat/logs
echo ""

echo "Mounted volumes:"
mount | grep -iE 'var/voyastra|tomcat' || echo "No specific mounts detected for voyastra paths."
echo ""

echo "Environment validation:"
check_env() {
    local var_name=$1
    local val="${!var_name}"
    if [ -n "$val" ] && [ "$val" != "null" ]; then
        if [[ "$var_name" == *"KEY"* || "$var_name" == *"SECRET"* || "$var_name" == *"TOKEN"* || "$var_name" == *"SID"* || "$var_name" == *"PASSWORD"* ]]; then
            echo "$var_name: Configured"
        else
            echo "$var_name: $val"
        fi
    else
        echo "$var_name: Missing"
    fi
}

check_env "DB_HOST"
check_env "DB_PORT"
check_env "DB_NAME"
check_env "DB_USER"
check_env "GEMINI_API_KEY"
check_env "GOOGLE_CLIENT_ID"
check_env "GOOGLE_CLIENT_SECRET"
check_env "GOOGLE_MAPS_API_KEY"
check_env "GOOGLE_PLACES_API_KEY"
check_env "TRAVELPAYOUTS_TOKEN"
check_env "RAPIDAPI_KEY"
check_env "SMTP_USER"
check_env "TWILIO_SID"
echo "========================================="

# Disable Tomcat shutdown port to prevent invalid shutdown command logging warnings
if [ -f /usr/local/tomcat/conf/server.xml ]; then
    echo "Disabling Tomcat shutdown port..."
    sed -i 's/port="8005"/port="-1"/g' /usr/local/tomcat/conf/server.xml
fi

if [ "$(whoami)" != "root" ]; then
    echo "ERROR: Container is not running as root. Cannot drop privileges."
    exit 1
fi

echo "Running as tomcat"
exec gosu tomcat "$@"
