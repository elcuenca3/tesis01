
CREATE TABLE IF NOT EXISTS Quiz_pregunta (
	id	integer NOT NULL,
	texto	text NOT NULL,
	max_puntaje	decimal NOT NULL,
	dificultad	integer,
	tipo	text NOT NULL,
	unidad	integer NOT NULL,
	PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS Quiz_quizusuario (
	id	integer NOT NULL,
	puntaje_total	decimal,
	usuario	text NOT NULL,
	nombre	text,
	num_p	integer NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS Quiz_elegirrespuesta (
	id	integer NOT NULL,
	correcta	bool NOT NULL,
	texto	text NOT NULL,
	pregunta_id	integer NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(pregunta_id) REFERENCES Quiz_pregunta(id) 
);

CREATE TABLE IF NOT EXISTS Quiz_comentariousuario (
	id	integer NOT NULL,
	comentario	text NOT NULL,
	nombreUser_id	integer,
	quizUser_id	integer NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(nombreUser_id) REFERENCES Quiz_quizusuario(id) ,
	FOREIGN KEY(quizUser_id) REFERENCES Quiz_quizusuario(id) 
);
CREATE TABLE IF NOT EXISTS Quiz_preguntasrespondidas (
	id	integer NOT NULL,
	correcta	bool NOT NULL,
	puntaje_obtenido	decimal NOT NULL,
	pregunta_id	integer NOT NULL,
	respuesta_id	integer,
	quizUser_id	integer NOT NULL,
	nombreUser_id	integer,
	uso_ayuda	bool NOT NULL,
	dificultad	integer,
	tiempo_pregunta	integer,
	PRIMARY KEY(id),
	FOREIGN KEY(pregunta_id) REFERENCES Quiz_pregunta(id) ,
	FOREIGN KEY(respuesta_id) REFERENCES Quiz_elegirrespuesta(id) ,
	FOREIGN KEY(nombreUser_id) REFERENCES Quiz_quizusuario(id) ,
	FOREIGN KEY(quizUser_id) REFERENCES Quiz_quizusuario(id) 
);
