use  tesis;

-- -----------------------------------------------------
-- Table `tesis`.`Quiz_comentariousuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesis`.`Quiz_comentariousuario` (
  `nombreUser_id` int not null,
  `quizUser_id` int not null,
  `id` INT NOT NULL AUTO_INCREMENT,
  `comentario` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`id`),
  foreign key(nombreUser_id) references Quiz_quizusuario(id),
  foreign key (quizUser_id) references Quiz_quizusuario(id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tesis`.`Quiz_elegirrespuesta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tesis`.`Quiz_elegirrespuesta`;
CREATE TABLE IF NOT EXISTS `tesis`.`Quiz_elegirrespuesta` (
  `pregunta_id` int not null,
  `id` INT NOT NULL ,
  `correcta` INT NOT NULL,
  `texto` VARCHAR(250) NOT NULL,
  `id_materia` int NOT NULL,
  primary key (`correcta`,`id`),
  foreign key (pregunta_id) references Quiz_pregunta (id),
  foreign key (id_materia) references Quiz_materia (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tesis`.`Quiz_pregunta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesis`.`Quiz_pregunta` (
  `id_materia` int not null,
  `id` INT NOT NULL,
  `texto` VARCHAR(350) NOT NULL,
  `max_puntaje` INT NOT NULL,
  `dificultad` INT NOT NULL,
  `tipo` VARCHAR(50) NOT NULL,
  `unidad` INT NOT NULL,
  `materia` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  foreign key (id_materia) references Quiz_materia (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tesis`.`Quiz_preguntasrespondidas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tesis`.`Quiz_preguntasrespondidas`;
CREATE TABLE `tesis`.`Quiz_preguntasrespondidas` (
  `id` INT NOT NULL,
  `correcta` INT NOT NULL,
  `puntaje_obtenido` INT NOT NULL,
  `pregunta_id` INT NOT NULL,
  `respuesta_id` INT NOT NULL,
  `nombreUser_id` INT NOT NULL,
  `quizUser_id` INT NOT NULL,
  `uso_ayuda` INT NOT NULL,
  `dificultad` INT NOT NULL,
  `tiempo_pregunta` INT NOT NULL,
  `id_materia` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_materia`) REFERENCES `Quiz_materia` (`id`),
  FOREIGN KEY (`quizUser_id`) REFERENCES `Quiz_quizusuario` (`id`),
  FOREIGN KEY (`nombreUser_id`) REFERENCES `Quiz_quizusuario` (`id`),
  FOREIGN KEY (`pregunta_id`) REFERENCES `Quiz_pregunta` (`id`),
  INDEX `idx_correcta` (`correcta`),
  FOREIGN KEY (`correcta`) REFERENCES `Quiz_elegirrespuesta` (`correcta`),
  FOREIGN KEY (`pregunta_id`) REFERENCES `Quiz_pregunta` (`id`)
) ENGINE=InnoDB;


-- -----------------------------------------------------
-- Table `tesis`.`Quiz_quizusuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesis`.`Quiz_quizusuario` (
  `id` INT NOT NULL,
  `puntaje_total` INT NULL,
  `usuario` VARCHAR(100) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `num_p` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tesis`.`Quiz_materia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tesis`.`Quiz_materia` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `nombre_docente` VARCHAR(45) NOT NULL,
  `ciclo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
