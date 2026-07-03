const mysql = require('mysql2');
const fs = require('fs');

const envPath = '.env';
const envConfig = fs.readFileSync(envPath, 'utf8');
envConfig.split('\n').forEach(line => {
  const parts = line.split('=');
  if (parts.length > 1) {
    const key = parts[0].trim();
    const value = parts.slice(1).join('=').trim();
    process.env[key] = value;
  }
});

const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '3306'),
  user: 'avnadmin',
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: {
    rejectUnauthorized: false
  }
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to database:', err);
    process.exit(1);
  }
  
  console.log('Connected to database.');
  
  connection.query('SELECT DATABASE() AS db', (err, rows) => {
    if (err) throw err;
    console.log('Current Database:', rows[0].db);
    
    connection.query('SHOW TABLES', (err, tables) => {
      if (err) throw err;
      console.log('Tables in database:', tables.map(t => Object.values(t)[0]));
      
      connection.end();
    });
  });
});
