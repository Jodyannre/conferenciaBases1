function getStudent(row) {
  return {
    id_student: row.id_student,
    name: row.name,
    carnet: row.carnet,
    pass: row.pass,
  };
}

module.exports = {
  getStudent,
};