const fs = require('fs');
const path = require('path');

const dbSchema = require('./db_schema.json');
const sqlContent = fs.readFileSync(path.join(__dirname, '../database/init/01-schema.sql'), 'utf-8');

// Also find hotel_search_history missing table definition
const extraTables = `
CREATE TABLE IF NOT EXISTS hotel_search_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    destination VARCHAR(255) NOT NULL,
    check_in DATE,
    check_out DATE,
    rooms INT,
    adults INT,
    children INT,
    hotel_type VARCHAR(100),
    amenities TEXT,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
`;

let finalSyncSql = '';

// We know trips and flights are missing. Let's extract their CREATE TABLE from 01-schema.sql
const getCreateTable = (tableName) => {
    const regex = new RegExp(\`CREATE\\s+TABLE\\s+(?:IF\\s+NOT\\s+EXISTS\\s+)?\\\`?\${tableName}\\\`?\\s*\\(([\\\\s\\\\S]*?)\\)\\s*(?:ENGINE|;)\`, 'i');
    const match = sqlContent.match(regex);
    if (match) {
        return \`CREATE TABLE IF NOT EXISTS \${tableName} (\n\${match[1]}\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\`;
    }
    return null;
}

const missingTables = ['trips', 'flights'];
for (const t of missingTables) {
    const ddl = getCreateTable(t);
    if (ddl) {
        finalSyncSql += ddl + '\n\n';
    }
}

finalSyncSql += extraTables + '\n';

fs.writeFileSync(path.join(__dirname, 'sync.sql'), finalSyncSql.trim());
console.log('Generated sync.sql');
