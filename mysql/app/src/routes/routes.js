const express = require('express');
const router = express.Router();
const controllers = require('../controllers/student.controller');

// Rutas

//Inicio
router.get('/', (req, res) => {res.send('Hello World');});
//Obtenre el último estudiante
router.get('/student', controllers.getLastStudent);
//Crear un estudiante
router.get('/createStudent', controllers.createStudent);
//Calcular el área de un círculo
router.get('/area', controllers.calculateArea);
//Obtener el nombre de un estudiante por id
router.get('/getStudentName', controllers.getStudentName);

module.exports = router;