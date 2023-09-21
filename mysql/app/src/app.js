const express = require('express');
const app = express();
const routes = require('./routes/routes.js');
require('dotenv').config();


app.use('/', routes);


const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor escuchando en el puerto ${PORT}`);
});
