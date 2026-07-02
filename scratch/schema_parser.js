const fs = require('fs');
const path = require('path');

const sqlContent = fs.readFileSync(path.join(__dirname, '../database/init/01-schema.sql'), 'utf-8');

// Parse tables from 01-schema.sql manually
const tablesInSql = {};
let currentTable = null;

const lines = sqlContent.split('\\n');
for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();
    const createMatch = line.match(/^CREATE\\s+TABLE\\s+(?:IF\\s+NOT\\s+EXISTS\\s+)?\\\`?([a-zA-Z0-9_]+)\\\`?/i);
    if (createMatch) {
        currentTable = createMatch[1].toLowerCase();
        tablesInSql[currentTable] = { createDdl: [line] };
        continue;
    }
    
    if (currentTable) {
        tablesInSql[currentTable].createDdl.push(line);
        if (line.endsWith(';')) {
            currentTable = null;
        }
    }
}

// hotel_search_history
tablesInSql['hotel_search_history'] = {
    createDdl: [
        "CREATE TABLE IF NOT EXISTS hotel_search_history (",
        "    id INT AUTO_INCREMENT PRIMARY KEY,",
        "    user_id INT NOT NULL,",
        "    destination VARCHAR(255) NOT NULL,",
        "    check_in DATE,",
        "    check_out DATE,",
        "    rooms INT,",
        "    adults INT,",
        "    children INT,",
        "    hotel_type VARCHAR(100),",
        "    amenities TEXT,",
        "    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,",
        "    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE",
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    ]
};

// Generate voyastra_complete.sql
let finalSql = "-- ==========================================\n";
finalSql += "-- VOYASTRA COMPLETE PRODUCTION SCHEMA\n";
finalSql += "-- Compatible with MySQL 8.x (Railway)\n";
finalSql += "-- ==========================================\n\n";
finalSql += "SET FOREIGN_KEY_CHECKS = 0;\n\n";

for (const t in tablesInSql) {
    finalSql += tablesInSql[t].createDdl.join('\\n') + "\\n\\n";
}

const seedContent = fs.readFileSync(path.join(__dirname, '../database/init/02-seed.sql'), 'utf-8');

// Remove the users INSERT statement (lines 5-8 typically)
// Matches INSERT IGNORE INTO users ... until the semicolon
let filteredSeed = seedContent.replace(/INSERT IGNORE INTO users[\s\S]*?;\r?\n/i, '');

finalSql += "\\n\\n-- ==========================================\n";
finalSql += "-- ESSENTIAL LOOKUP DATA (NO USER/PERSONAL DATA)\n";
finalSql += "-- ==========================================\n";
finalSql += filteredSeed + "\\n";
finalSql += "SET FOREIGN_KEY_CHECKS = 1;\\n";

fs.writeFileSync(path.join(__dirname, '../voyastra_complete.sql'), finalSql);
console.log('voyastra_complete.sql regenerated without user data.');
