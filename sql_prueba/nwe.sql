
CREATE TABLE IF NOT EXISTS django_migrations (
	id	integer NOT NULL,
	app	varchar(255) NOT NULL,
	name	varchar(255) NOT NULL,
	applied	datetime NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS auth_group_permissions (
	id	integer NOT NULL,
	group_id	integer NOT NULL,
	permission_id	integer NOT NULL,
	FOREIGN KEY(permission_id) REFERENCES auth_permission(id) ,
	FOREIGN KEY(group_id) REFERENCES auth_group(id) ,
	PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS auth_user_groups (
	id	integer NOT NULL,
	user_id	integer NOT NULL,
	group_id	integer NOT NULL,
	FOREIGN KEY(user_id) REFERENCES auth_user(id) ,
	PRIMARY KEY(id),
	FOREIGN KEY(group_id) REFERENCES auth_group(id) 
);
CREATE TABLE IF NOT EXISTS auth_user_user_permissions (
	id	integer NOT NULL,
	user_id	integer NOT NULL,
	permission_id	integer NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(permission_id) REFERENCES auth_permission(id) ,
	FOREIGN KEY(user_id) REFERENCES auth_user(id) 
);
CREATE TABLE IF NOT EXISTS django_admin_log (
	id	integer NOT NULL,
	action_time	datetime NOT NULL,
	object_id	text,
	object_repr	varchar(200) NOT NULL,
	change_message	text NOT NULL,
	content_type_id	integer,
	user_id	integer NOT NULL,
	action_flag	smallint unsigned NOT NULL CHECK(action_flag >= 0),
	PRIMARY KEY(id),
	FOREIGN KEY(content_type_id) REFERENCES django_content_type(id) ,
	FOREIGN KEY(user_id) REFERENCES auth_user(id) 
);
CREATE TABLE IF NOT EXISTS django_content_type (
	id	integer NOT NULL,
	app_label	varchar(100) NOT NULL,
	model	varchar(100) NOT NULL,
	PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS auth_permission (
	id	integer NOT NULL,
	content_type_id	integer NOT NULL,
	codename	varchar(100) NOT NULL,
	name	varchar(255) NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(content_type_id) REFERENCES django_content_type(id) 
);
CREATE TABLE IF NOT EXISTS auth_group (
	id	integer NOT NULL,
	name	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS auth_user (
	id	integer NOT NULL,
	password	varchar(128) NOT NULL,
	last_login	datetime,
	is_superuser	bool NOT NULL,
	username	varchar(150) NOT NULL UNIQUE,
	last_name	varchar(150) NOT NULL,
	email	varchar(254) NOT NULL,
	is_staff	bool NOT NULL,
	is_active	bool NOT NULL,
	date_joined	datetime NOT NULL,
	first_name	varchar(150) NOT NULL,
	PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS django_session (
	session_key	varchar(40) NOT NULL,
	session_data	text NOT NULL,
	expire_date	datetime NOT NULL,
	PRIMARY KEY(session_key)
);
CREATE TABLE IF NOT EXISTS Quiz_elegirrespuesta (
	id	integer NOT NULL,
	correcta	bool NOT NULL,
	texto	text NOT NULL,
	pregunta_id	integer NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(pregunta_id) REFERENCES Quiz_pregunta(id) 
);
CREATE TABLE IF NOT EXISTS Quiz_pregunta (
	id	integer NOT NULL,
	texto	text NOT NULL,
	max_puntaje	decimal NOT NULL,
	dificultad	integer,
	tipo	text NOT NULL,
	unidad	integer NOT NULL,
	PRIMARY KEY(id)
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
CREATE TABLE IF NOT EXISTS Quiz_quizusuario (
	id	integer NOT NULL,
	puntaje_total	decimal,
	usuario	text NOT NULL,
	nombre	text,
	num_p	integer NOT NULL,
	PRIMARY KEY(id)
);