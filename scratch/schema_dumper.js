const mysql = require('mysql2/promise');
const fs = require('fs');

async function run() {
  const conn = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Home@123',
    database: 'voyastra'
  });

  const [tables] = await conn.query('SHOW TABLES');
  let schemaData = {};
  let createTableStatements = [];

  for (let row of tables) {
    const tableName = Object.values(row)[0];
    const [cols] = await conn.query(`SHOW COLUMNS FROM ${tableName}`);
    schemaData[tableName] = cols.map(c => ({
      Field: c.Field,
      Type: c.Type,
      Null: c.Null,
      Key: c.Key,
      Default: c.Default,
      Extra: c.Extra
    }));

    const [createRes] = await conn.query(`SHOW CREATE TABLE ${tableName}`);
    createTableStatements.push(createRes[0]['Create Table'] + ';');
  }
  
  fs.writeFileSync('scratch/db_schema.json', JSON.stringify(schemaData, null, 2));
  fs.writeFileSync('scratch/backup_schema.sql', createTableStatements.join('\n\n'));
  console.log('Schema extraction complete.');
  
  await conn.end();
}

run().catch(console.error);
