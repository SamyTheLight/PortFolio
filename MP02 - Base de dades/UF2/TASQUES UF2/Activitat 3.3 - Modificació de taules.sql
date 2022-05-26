#TASCA 1. Base de dades.
DROP DATABASE IF EXISTS empresa;
CREATE DATABASE empresa;
#TASCA 2. Taula empleat.
USE empresa;
CREATE TABLE empleat(
	id_empleat 				INTEGER (4) PRIMARY KEY NOT NULL,
    nom 					VARCHAR (15),
    cognoms 				VARCHAR (30),
    treball 				VARCHAR (10),
    carrec 					INTEGER (4),
    contracte 				DATE,
    salari 					INTEGER (7),
    comissio 				INTEGER (7),
    departament 			INTEGER (2)
);
#TASCA 3. Modificacions empleats.
ALTER TABLE empleat 
			MODIFY salari NUMERIC (7,2) NOT NULL;
ALTER TABLE empleat
			ADD CONSTRAINT uk_empleat_salari_comissio UNIQUE (salari, comissio);
ALTER TABLE empleat
			CHANGE treball direccio VARCHAR(30);
#TASCA 4. Taula departament.
DROP TABLE IF EXISTS departament;
CREATE TABLE departament(
	id_departament 			INTEGER (2) PRIMARY KEY,
    nom 					VARCHAR (9),
    localitzacio 			VARCHAR (10),
    alta 					DATE
);
#TASCA 5. Modificacions empleats II.
ALTER TABLE empleat
			CHANGE departament departament_id INTEGER (2);
ALTER TABLE empleat
			ADD CONSTRAINT fk_empleat_departament FOREIGN KEY (departament_id) REFERENCES departament (id_departament);
#TASCA 6. Modificacions Departament.
SHOW CREATE TABLE departament;
SHOW CREATE TABLE empleat;
ALTER TABLE empleat
			DROP FOREIGN KEY fk_empleat_departament;
ALTER TABLE departament
			DROP PRIMARY KEY;
ALTER TABLE departament
			MODIFY localitzacio VARCHAR (10) NOT NULL DEFAULT 'Terrassa';
ALTER TABLE departament
			DROP COLUMN alta;
ALTER TABLE departament
			ADD registre DATETIME DEFAULT CURRENT_TIMESTAMP;