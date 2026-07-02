const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

async function run() {
  const conn = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Home@123',
    database: 'voyastra',
    multipleStatements: true
  });

  const syncSql = fs.readFileSync(path.join(__dirname, 'sync.sql'), 'utf-8');
  
  if (syncSql.trim().length > 0) {
      console.log('Executing sync SQL...');
      await conn.query(syncSql);
      console.log('Sync complete.');
  } else {
      console.log('No sync SQL to execute.');
  }
  
  await conn.end();
}

run().catch(err => {
    console.error(err);
    process.exit(1);
});
