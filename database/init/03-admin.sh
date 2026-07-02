#!/bin/bash
# Initialize or update the admin user from environment variables
USE_EMAIL="${ADMIN_EMAIL:-admin@voyastra.com}"
# Default hash is BCrypt for 'Admin@123'
USE_HASH="${ADMIN_PASSWORD_HASH:-$2a$12$OhufE14IFnHVGNvDtOlTKOuEYohGZD/HUV6CUEBioKhevSiRdcbIu}"

echo "Configuring admin user ($USE_EMAIL) in database..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "
USE voyastra;
INSERT INTO users (name, email, password, role, is_verified)
VALUES ('Voyastra Admin', '$USE_EMAIL', '$USE_HASH', 'ADMIN', 1)
ON DUPLICATE KEY UPDATE password='$USE_HASH';
"
