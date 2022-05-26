
USE m02_uf2;
CREATE TABLE alumne(
	id_alumne 								TINYINT,
    nom 									VARCHAR(20) NOT NULL,
    cognoms 								VARCHAR(20) NOT NULL,
    data_naixement 							DATE,
    adreca 									VARCHAR(20),
    data_primera_matriculamatricula 		DATE,
    telefon 								VARCHAR(9),
    PRIMARY KEY (id_alumne)
	);
    
CREATE TABLE assignatures(
	id_assignatura 							CHAR(3),
    nom 									VARCHAR(20) NOT NULL,
    cicle 									VARCHAR(20),
	curs 									TINYINT,
    PRIMARY KEY (id_assignatura)
    );
    
CREATE TABLE professors(
	id_professor 							SMALLINT,
    nom 									VARCHAR(20) NOT NULL,
    cognoms 								VARCHAR(20) NOT NULL,
    data_naixement 							DATE,
    adreca 									VARCHAR(20),
    telefon 								VARCHAR(9),
    PRIMARY KEY (id_professor)
    );
    
CREATE TABLE alumne_assignatura(
	alumne_id								SMALLINT,
    assignatura_id							CHAR(3),
    PRIMARY KEY (alumne_id, assignatura_id),
    CONSTRAINT fk_alumne_assignatura_assignatura
		FOREIGN KEY (alumne_id) REFERENCES alumne(id_alumne),
	CONSTRAINT fk_alumne_assignatura_assignatura
		FOREIGN KEY (assignatura_id) REFERENCES assignatura(id_assignatura)
	);

CREATE TABLE professor(
	professor_id							SMALLINT,
    assignatura_id							CHAR(3),
    PRIMARY KEY (professor_id, assignatura_id),
    CONSTRAINT fk_alumne_assignatura_assignatura
		FOREIGN KEY (professor_id) REFERENCES professor(id_professor),
	CONSTRAINT fk_professor_assignatura_assignatura
		FOREIGN KEY (assignatura_id) REFERENCES assignatura(id_assignatura)
	);