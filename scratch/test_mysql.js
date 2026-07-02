const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'Home@123',
  database: 'voyastra'
});
connection.connect((err) => {
  if (err) {
    console.error('Error connecting: ' + err.stack);
    process.exit(1);
  }
  console.log('Connected as id ' + connection.threadId);
  connection.end();
});
