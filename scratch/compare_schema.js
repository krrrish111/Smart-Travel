const fs = require('fs');
const path = require('path');

const dbSchema = require('./db_schema.json');
const dbTables = new Set(Object.keys(dbSchema).map(t => t.toLowerCase()));

// Extract tables from 01-schema.sql
const sqlContent = fs.readFileSync(path.join(__dirname, '../database/init/01-schema.sql'), 'utf-8');
const createTableRegex = /CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?([a-zA-Z0-9_]+)`?/gi;
let sqlTables = new Set();
let match;
while ((match = createTableRegex.exec(sqlContent)) !== null) {
  sqlTables.add(match[1].toLowerCase());
}

// Find tables in SQL that are not in DB
const missingFromDb = [...sqlTables].filter(t => !dbTables.has(t));

// Find tables in Java DAOs
const javaTables = new Set();
function walkSync(dir, filelist = []) {
  fs.readdirSync(dir).forEach(file => {
    const dirFile = path.join(dir, file);
    if (fs.statSync(dirFile).isDirectory()) {
      filelist = walkSync(dirFile, filelist);
    } else {
      filelist.push(dirFile);
    }
  });
  return filelist;
}
const javaFiles = walkSync(path.join(__dirname, '../src/main/java')).filter(f => f.endsWith('.java'));

const sqlKeywords = /FROM\s+([a-zA-Z0-9_]+)|JOIN\s+([a-zA-Z0-9_]+)|INTO\s+([a-zA-Z0-9_]+)|UPDATE\s+([a-zA-Z0-9_]+)/gi;
for (const file of javaFiles) {
  const content = fs.readFileSync(file, 'utf-8');
  let sqlMatch;
  while ((sqlMatch = sqlKeywords.exec(content)) !== null) {
    const table = (sqlMatch[1] || sqlMatch[2] || sqlMatch[3] || sqlMatch[4]).toLowerCase();
    // Exclude common Java keywords or false positives
    if (!['string', 'where', 'select', 'join', 'left', 'right', 'inner', 'outer', 'all', 'any'].includes(table)) {
      javaTables.add(table);
    }
  }
}

// Find tables in Java that are NOT in live DB
const missingJavaTables = [...javaTables].filter(t => !dbTables.has(t));

console.log('Tables in 01-schema.sql missing from DB:', missingFromDb);
console.log('Tables in Java missing from DB:', missingJavaTables);
