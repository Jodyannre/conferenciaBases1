const mysql = require('mysql2/promise');
require('dotenv').config();

// Create a connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST, //Dirección de host
  user: process.env.DB_USER, //Nombre de usuario
  password: process.env.DB_PASS, //Pass del usuario
  database: process.env.DATABASE, //Nombre de base de datos
  charset: 'utf8mb4', // Especifica el conjunto de caracteres UTF-8 para la conexión
  waitForConnections: true, //Esperar a que se libere una conexión si ya se están usando todas
  connectionLimit: 10, // Número máximo de conexiones simultáneas
  queueLimit: 0, // Sin límite de conexiones en espera
});

module.exports = pool;