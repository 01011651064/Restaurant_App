const mysql = require('mysql2/promise');

const dbConnection = mysql.createConnection({
    host: process.env.MYSQL_URL,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASS,
    database: process.env.MYSQL_DATABASE_NAME,
    multipleStatements: true
});

module.exports = dbConnection;