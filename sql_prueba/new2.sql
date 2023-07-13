BEGIN TRANSACTION;
DROP TABLE IF EXISTS "django_migrations";
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "auth_group_permissions";
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "auth_user_groups";
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
DROP TABLE IF EXISTS "auth_user_user_permissions";
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
DROP TABLE IF EXISTS "django_admin_log";
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"action_time"	datetime NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
DROP TABLE IF EXISTS "django_content_type";
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "auth_permission";
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
DROP TABLE IF EXISTS "auth_group";
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "auth_user";
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"last_name"	varchar(150) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"first_name"	varchar(150) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "django_session";
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
DROP TABLE IF EXISTS "Quiz_elegirrespuesta";
CREATE TABLE IF NOT EXISTS "Quiz_elegirrespuesta" (
	"id"	integer NOT NULL,
	"correcta"	bool NOT NULL,
	"texto"	text NOT NULL,
	"pregunta_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("pregunta_id") REFERENCES "Quiz_pregunta"("id") DEFERRABLE INITIALLY DEFERRED
);
DROP TABLE IF EXISTS "Quiz_pregunta";
CREATE TABLE IF NOT EXISTS "Quiz_pregunta" (
	"id"	integer NOT NULL,
	"texto"	text NOT NULL,
	"max_puntaje"	decimal NOT NULL,
	"dificultad"	integer,
	"tipo"	text NOT NULL,
	"unidad"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "Quiz_comentariousuario";
CREATE TABLE IF NOT EXISTS "Quiz_comentariousuario" (
	"id"	integer NOT NULL,
	"comentario"	text NOT NULL,
	"nombreUser_id"	integer,
	"quizUser_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("nombreUser_id") REFERENCES "Quiz_quizusuario"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("quizUser_id") REFERENCES "Quiz_quizusuario"("id") DEFERRABLE INITIALLY DEFERRED
);
DROP TABLE IF EXISTS "Quiz_preguntasrespondidas";
CREATE TABLE IF NOT EXISTS "Quiz_preguntasrespondidas" (
	"id"	integer NOT NULL,
	"correcta"	bool NOT NULL,
	"puntaje_obtenido"	decimal NOT NULL,
	"pregunta_id"	integer NOT NULL,
	"respuesta_id"	integer,
	"quizUser_id"	integer NOT NULL,
	"nombreUser_id"	integer,
	"uso_ayuda"	bool NOT NULL,
	"dificultad"	integer,
	"tiempo_pregunta"	integer,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("pregunta_id") REFERENCES "Quiz_pregunta"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("respuesta_id") REFERENCES "Quiz_elegirrespuesta"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("nombreUser_id") REFERENCES "Quiz_quizusuario"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("quizUser_id") REFERENCES "Quiz_quizusuario"("id") DEFERRABLE INITIALLY DEFERRED
);
DROP TABLE IF EXISTS "Quiz_quizusuario";
CREATE TABLE IF NOT EXISTS "Quiz_quizusuario" (
	"id"	integer NOT NULL,
	"puntaje_total"	decimal,
	"usuario"	text NOT NULL,
	"nombre"	text,
	"num_p"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP INDEX IF EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq";
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
DROP INDEX IF EXISTS "auth_group_permissions_group_id_b120cbf9";
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
DROP INDEX IF EXISTS "auth_group_permissions_permission_id_84c5c92e";
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
DROP INDEX IF EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq";
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
DROP INDEX IF EXISTS "auth_user_groups_user_id_6a12ed8b";
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
DROP INDEX IF EXISTS "auth_user_groups_group_id_97559544";
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
DROP INDEX IF EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq";
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
DROP INDEX IF EXISTS "auth_user_user_permissions_user_id_a95ead1b";
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
DROP INDEX IF EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c";
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
DROP INDEX IF EXISTS "django_admin_log_content_type_id_c4bce8eb";
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
DROP INDEX IF EXISTS "django_admin_log_user_id_c564eba6";
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
DROP INDEX IF EXISTS "django_content_type_app_label_model_76bd3d3b_uniq";
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
DROP INDEX IF EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq";
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
DROP INDEX IF EXISTS "auth_permission_content_type_id_2f476e4b";
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
DROP INDEX IF EXISTS "django_session_expire_date_a5c62663";
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
DROP INDEX IF EXISTS "Quiz_elegirrespuesta_pregunta_id_c9f2164a";
CREATE INDEX IF NOT EXISTS "Quiz_elegirrespuesta_pregunta_id_c9f2164a" ON "Quiz_elegirrespuesta" (
	"pregunta_id"
);
DROP INDEX IF EXISTS "Quiz_comentariousuario_nombreUser_id_193a585b";
CREATE INDEX IF NOT EXISTS "Quiz_comentariousuario_nombreUser_id_193a585b" ON "Quiz_comentariousuario" (
	"nombreUser_id"
);
DROP INDEX IF EXISTS "Quiz_comentariousuario_quizUser_id_4ea3c5b4";
CREATE INDEX IF NOT EXISTS "Quiz_comentariousuario_quizUser_id_4ea3c5b4" ON "Quiz_comentariousuario" (
	"quizUser_id"
);
DROP INDEX IF EXISTS "Quiz_preguntasrespondidas_pregunta_id_d4bc6d16";
CREATE INDEX IF NOT EXISTS "Quiz_preguntasrespondidas_pregunta_id_d4bc6d16" ON "Quiz_preguntasrespondidas" (
	"pregunta_id"
);
DROP INDEX IF EXISTS "Quiz_preguntasrespondidas_respuesta_id_364e59ad";
CREATE INDEX IF NOT EXISTS "Quiz_preguntasrespondidas_respuesta_id_364e59ad" ON "Quiz_preguntasrespondidas" (
	"respuesta_id"
);
DROP INDEX IF EXISTS "Quiz_preguntasrespondidas_quizUser_id_3c8c01c0";
CREATE INDEX IF NOT EXISTS "Quiz_preguntasrespondidas_quizUser_id_3c8c01c0" ON "Quiz_preguntasrespondidas" (
	"quizUser_id"
);
DROP INDEX IF EXISTS "Quiz_preguntasrespondidas_nombreUser_id_8a73b962";
CREATE INDEX IF NOT EXISTS "Quiz_preguntasrespondidas_nombreUser_id_8a73b962" ON "Quiz_preguntasrespondidas" (
	"nombreUser_id"
);
COMMIT;
