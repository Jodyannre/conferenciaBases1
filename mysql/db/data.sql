use db;

CREATE TABLE STUDENTS (
	id_student BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	carnet BIGINT UNSIGNED NOT NULL,
	pass VARCHAR(32) NOT NULL,
	PRIMARY KEY (id_student)
);

CREATE TABLE COURSES (
	id_course BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_course)
);

CREATE TABLE ASSIGMENTS (
	id_assignment BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	student_id BIGINT UNSIGNED NOT NULL,
	course_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (id_assignment)
);


CREATE TABLE ERRORS (
    error_code INT PRIMARY KEY,
    error_message VARCHAR(255)
);


ALTER TABLE ASSIGMENTS
ADD CONSTRAINT FK_A_S
FOREIGN KEY (student_id) REFERENCES STUDENTS(id_student); 

ALTER TABLE ASSIGMENTS
ADD CONSTRAINT FK_A_C
FOREIGN KEY (course_id) REFERENCES COURSES(id_course); 







DROP PROCEDURE IF EXISTS Create_course;
DELIMITER $$
CREATE PROCEDURE Create_course(
	IN name_in VARCHAR(50)
)
BEGIN
	DECLARE id int;
	DECLARE sql_state CHAR(5);
	DECLARE errno INT;
	DECLARE message TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1
			sql_state = RETURNED_SQLSTATE, 
			errno = MYSQL_ERRNO, 
			message = MESSAGE_TEXT; 
		 ROLLBACK;
		 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = message; 
		 
    END;
	START TRANSACTION;
		INSERT INTO COURSES(name)
		VALUES (name_in);
        SET id = LAST_INSERT_ID();
        IF id>100 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Error premeditado';
		END IF;
	COMMIT;
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS Create_student;
DELIMITER //
CREATE PROCEDURE Create_student(
	IN name_in VARCHAR(50),
    IN carnet_in BIGINT UNSIGNED,
    IN pass_in VARCHAR(32)
)
BEGIN
    DECLARE sql_state CHAR(5);
	DECLARE errno INT;
	DECLARE message TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1
			sql_state = RETURNED_SQLSTATE, 
			errno = MYSQL_ERRNO, 
			message = MESSAGE_TEXT; 
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = message; 
    END;
    
    START TRANSACTION;
    

    INSERT INTO STUDENTS (name,carnet,pass)
    VALUES (name_in,carnet_in,pass_in);
	

	IF NOT EsCadenaSegura(name_in) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Código malicioso en consulta';
	END IF;

    COMMIT;
    
    SELECT 'Usuario creado y asignado con éxito' as message;  
END;
// 
DELIMITER ;




DROP PROCEDURE IF EXISTS Create_assigment;
DELIMITER //
CREATE PROCEDURE Create_assigment(
	IN name_in VARCHAR(50),
    IN course_in VARCHAR(50)
)
BEGIN

    DECLARE id_student_in BIGINT UNSIGNED;
	DECLARE id_course_in BIGINT UNSIGNED;
    

    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Erro al crear y asignar al nuevo usuario"; 
    END;
    
    START TRANSACTION;
        

    SET id_course_in = (SELECT id_course FROM COURSES WHERE name = course_in);
	

    SET id_student_in = (SELECT id_student FROM STUDENTS WHERE name = name_in);
    

    INSERT INTO ASSIGMENTS (student_id,course_id)
    VALUES (id_student_in,id_course_in);
    

    COMMIT;
    
    SELECT 'Usuario creado y asignado con éxito' as message;  
END;
// 
DELIMITER ;




DROP PROCEDURE IF EXISTS Get_student_name;
DELIMITER $$
CREATE PROCEDURE Get_student_name(
	IN id_in BIGINT UNSIGNED,
    OUT name_out VARCHAR(50)
)
BEGIN
	DECLARE error_msg VARCHAR(50) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_msg; 
		END;
    START TRANSACTION;
		SELECT name INTO name_out FROM STUDENTS 
        WHERE id_student = id_in;

		IF name_out IS NULL THEN
			SET error_msg = (SELECT error_message FROM ERRORS WHERE error_code=1);
			SIGNAL SQLSTATE '45000';
		END IF;
    COMMIT;
END;
$$
DELIMITER ;



DROP PROCEDURE IF EXISTS Get_number_from_text;
DELIMITER $$
CREATE PROCEDURE Get_number_from_text(
	IN tipo_in VARCHAR(50),
    OUT number_out INT UNSIGNED
)
BEGIN
	IF LOWER(tipo_in) = 'alto' THEN
		SET number_out = 150;
	ELSEIF LOWER(tipo_in) = 'medio' THEN
		SET number_out = 75;
	ELSE
		SET number_out = 15;
	END IF;
END;
$$
DELIMITER ;




DROP PROCEDURE IF EXISTS Sum_numbers;
DELIMITER $$
CREATE PROCEDURE Sum_numbers(
	INOUT number_in BIGINT UNSIGNED
)
BEGIN
	SET number_in = number_in + 1;
END;
$$
DELIMITER ;






DROP PROCEDURE IF EXISTS Update_course;
DELIMITER $$
CREATE PROCEDURE Update_course(
	IN name_in VARCHAR(50),
    IN id_in BIGINT UNSIGNED
)
BEGIN
	UPDATE COURSES
    SET name = name_in
    WHERE id_course = id_in;
END;
$$
DELIMITER ;



DROP PROCEDURE IF EXISTS Get_Last_Student_P;
DELIMITER $$
CREATE PROCEDURE Get_Last_Student_P(

)
BEGIN
	SELECT * FROM STUDENTS ORDER BY id_student DESC LIMIT 1;
END;
$$
DELIMITER ;









DROP FUNCTION IF EXISTS Calculate_circle_area;
DELIMITER //
CREATE FUNCTION Calculate_circle_area(radio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE area DECIMAL(10,2);
    SET area = 3.1416 * radio * radio;
    RETURN area;
END;
//
DELIMITER ;



DROP FUNCTION IF EXISTS Get_Date;
DELIMITER //
CREATE FUNCTION Get_Date()
RETURNS DATETIME READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE fecha_hora DATETIME;
    SET fecha_hora = NOW();
    RETURN fecha_hora;
END;
//
DELIMITER ;



DROP FUNCTION IF EXISTS Get_Last_Student;
DELIMITER //
CREATE FUNCTION Get_Last_Student()
RETURNS VARCHAR(50) READS SQL DATA
NOT DETERMINISTIC
BEGIN
	DECLARE ultimo_id INT;
    SELECT id_student INTO ultimo_id FROM STUDENTS ORDER BY id_student DESC LIMIT 1;
    RETURN ultimo_id;
END;
//
DELIMITER ;


DROP FUNCTION IF EXISTS EsCadenaSegura;
DELIMITER $$
CREATE FUNCTION EsCadenaSegura(inputString VARCHAR(255)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE esSegura BOOLEAN DEFAULT TRUE;


  IF (INSTR(inputString, 'SELECT') > 0 OR
      INSTR(inputString, 'INSERT') > 0 OR
      INSTR(inputString, 'UPDATE') > 0 OR
      INSTR(inputString, 'DELETE') > 0 OR
      INSTR(inputString, 'DROP') > 0 OR
      INSTR(inputString, 'TRUNCATE') > 0 OR
      INSTR(inputString, 'ALTER') > 0 OR
      INSTR(inputString, 'EXEC') > 0) THEN
    SET esSegura = FALSE;
  END IF;

  RETURN esSegura;
END;
$$
DELIMITER ;







DROP PROCEDURE IF EXISTS crear_asignar_usuario;
DELIMITER //
CREATE PROCEDURE crear_asignar_usuario(
	IN name_in VARCHAR(50),
    IN carnet_in BIGINT UNSIGNED,
    IN pass_in VARCHAR(32),
    IN course_in BIGINT UNSIGNED
)
BEGIN

    DECLARE id_student_in BIGINT UNSIGNED;
    

    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Erro al crear y asignar al nuevo usuario"; 
    END;
    
    START TRANSACTION;

    INSERT INTO STUDENTS (name,carnet,pass)
    VALUES (name_in,carnet_in,pass_in);
    

    SET id_student_in = LAST_INSERT_ID();
    

    INSERT INTO ASSIGMENTS (student_id,course_id)
    VALUES (id_student_in,course_in);

    COMMIT;
    
    SELECT 'Usuario creado y asignado con éxito' as message;  
END;
// 
DELIMITER ;
