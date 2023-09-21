const pool = require('../utils/db.config');

// Controlador para obtener el último estudiante
async function getLastStudent(req, res) {
    try {
      const connection = await pool.getConnection(); // Obtiene una conexión del pool
      // Ejecuta el stored procedure getLastStudent
      const [rows] = await connection.query('CALL Get_Last_Student_P()');
      // Libera la conexión
      connection.release();

      // Verifica si se encontraron resultados
      if (rows.length > 0) {
        // Crea el modelo
        const ultimoEstudiante = rows[0][0];

        res.json(ultimoEstudiante);
      } else {
        res.status(404).json({ message: 'No se encontraron estudiantes.' });
      }
    } catch (error) {
      console.error('Error al obtener el último estudiante:', error);
      res.status(500).json({ error: 'Ocurrió un error al obtener el último estudiante.' });
    }
  }





  // Controlador para crear un estudiante
async function createStudent(req, res) {
  try {
    //Entrada de datos, generalmente se haria usando el req, pero por ejemplo se hace de forma directa
    const {name,carnet,pass}= {name:'Carlitox',carnet:199152845,pass:'12345678'};
    const connection = await pool.getConnection(); // Obtiene una conexión del pool
    // Ejecuta el stored procedure getLastStudent
    const [rows] = await connection.query('CALL Create_student(?,?,?)',[name,carnet,pass]);
    // Libera la conexión
    connection.release();

    // Verifica si se encontraron resultados
    if (rows.length > 0) {
      // Crea el modelo
      const resultado = rows[0][0];
      res.json(resultado);
    } else {
      res.status(404).json({ message: 'Algo extraño paso.' });
    }
  } catch (error) {
    //console.error(error);
    res.status(500).json({ error: error.message });
  }
}


//Controlador para calcular el área de un círculo llamando a una función almacenada
async function calculateArea(req, res) {
  try {
    //Entrada de datos, generalmente se haria usando el req, pero por ejemplo se hace de forma directa
    const area = 10;
    const connection = await pool.getConnection(); // Obtiene una conexión del pool
    // Ejecuta el stored procedure getLastStudent
    const [rows] = await connection.query('SELECT Calculate_circle_area(?) AS Area',[area]);
    // Libera la conexión
    connection.release();
    // Verifica si se encontraron resultados
    if (rows.length > 0) {
      // Crea el modelo
      const resultado = rows[0];
      res.json(resultado);
    } else {
      res.status(404).json({ message: 'Algo extraño paso.' });
    }
  }catch (error) {
    //Imprimir el error en consola
    //console.error(error);
    //Capturar y delver el error que se genero desde la base de datos
    res.status(500).json({ error: error.message });
  }
}



//Controlador para obtener el nombre de un estudiante por id, utilizando parámetros tipo OUT
async function getStudentName(req, res) {
    //Entrada de datos, generalmente se haria usando el req, pero por ejemplo se hace de forma directa
    const id_student = 1;
  
    try {
      // Obtener una conexión desde el pool
      const connection = await pool.getConnection();
  
      try {
        // Ejecutar el procedimiento almacenado y almacenar el resultado en el parámetro OUT @student_name
        await connection.query('CALL Get_Student_Name(?, @student_name)', [id_student]);
  
        // Obtener el valor de @student_name
        const [result] = await connection.query('SELECT @student_name AS StudentName');
  
        // Liberar la conexión
        connection.release();

        const student_name = result[0].StudentName;
        res.json({ student_name });
      } catch (error) {
        // Manejar errores en la consulta SQL
        console.error('Error al ejecutar la consulta SQL:', error.message);
        connection.release();
        res.status(500).json({ error: error.message });
      }
    } catch (error) {
      // Manejar errores al obtener una conexión
      console.error('Error al obtener una conexión:', error);
      res.status(500).json({ error: 'Error de conexión a la base de datos' });
    }

}


  module.exports = {
    getLastStudent,
    createStudent,
    calculateArea,
    getStudentName
  };