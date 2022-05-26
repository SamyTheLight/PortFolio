CREATE DATABASE m02_uf2_a3_botiga_dvd;
CREATE TABLE categoria(
	id_categoria	TINYINT AUTO_INCREMENT,
    nom				VARCHAR(20) NOT NULL,
    PRIMARY KEY	(id_categoria)
);
CREATE TABLE usuari(
	id_usuari	MEDIUMINT AUTO_INCREMENT,
    dni			CHAR(9) NOT NULL,
    nom			VARCHAR(20) NOT NULL,
    cognoms		VARCHAR(40) NOT NULL,
    adreca		VARCHAR(50) NOT NULL,
    ciutat		VARCHAR(40) NOT NULL DEFAULT ('Terrassa'),
    sexe		ENUM('H','D') NOT NULL,
    telefon		CHAR(9),
    mobil		CHAR(9),
    correu_electronic	VARCHAR(50),
    data_naixement	DATE NOT NULL,
    PRIMARY KEY (id_usuari),
	CONSTRAINT uk_usuari_dni UNIQUE (dni),
    CONSTRAINT uk_usuari_mobil UNIQUE (mobil),
    CONSTRAINT uk_usuari_correu_electronic UNIQUE (correu_electronic),
    CONSTRAINT ck_usuari_data_naixement CHECK (data_naixement > '1900/01/01')
);

CREATE TABLE dvd(
	id_dvd		MEDIUMINT AUTO_INCREMENT,
    titol		VARCHAR(50) NOT NULL,
    director	VARCHAR(50) NOT NULL,
    actors		VARCHAR(50) NOT NULL,
    productora	VARCHAR(40) NOT NULL,
    any_filmacio	SMALLINT(4) NOT NULL,
    argument	TEXT,
    durada		SMALLINT NOT NULL,
    data_alta	DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nacionalitat	VARCHAR(20) NOT NULL,
    baixa		ENUM('S','N') NOT NULL,
    categoria_id	TINYINT NOT NULL,
    PRIMARY KEY (id_dvd), 
    CONSTRAINT fk_dvd_categoria FOREIGN KEY (categoria_id)
		REFERENCES categoria(id_categoria),
    CONSTRAINT uk_dvd_titol UNIQUE(titol),
    CONSTRAINT ck_dvd_any_filmacio CHECK (any_filmacio > 1900),
    CONSTRAINT ck_dvd_durada CHECK (durada BETWEEN 1 AND 300),
    CONSTRAINT ck_dvd_data_alta CHECK (data_alta > '2001-01-01')
);
    
CREATE TABLE copia(
	id_copia	TINYINT,
    dvd_id		MEDIUMINT,
    PRIMARY KEY (id_copia, dvd_id),
    CONSTRAINT fk_copia_dvd FOREIGN KEY (dvd_id)
		REFERENCES dvd (id_dvd)
);

CREATE TABLE usuari_copia(
	usuari_id	MEDIUMINT,
    copia_id	TINYINT,
    dvd_id		MEDIUMINT,
    data_lloguer	DATE NOT NULL DEFAULT (CURRENT_DATE),
    data_retorn		DATE,
    PRIMARY KEY (usuari_id, copia_id, dvd_id),
    CONSTRAINT fk_usuari_copia_usuari FOREIGN KEY (usuari_id)
		REFERENCES usuari(id_usuari),
	CONSTRAINT fk_usuari_copia_copia FOREIGN KEY (copia_id, dvd_id)
		REFERENCES copia(id_copia, dvd_id)
);
    
