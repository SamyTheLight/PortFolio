USE m02_uf2;

DROP TABLE IF EXISTS fabricant;

CREATE TABLE fabricant(
	caracteristiques	VARCHAR(20),
    id_fabricant		SMALLINT PRIMARY KEY,
    nom 				VARCHAR(20) NOT NULL,
    adreca_web 			VARCHAR(20),
    telefon				VARCHAR(9)
);
DROP TABLE IF EXISTS producte;

CREATE TABLE productes(
	id_producte 	INTEGER PRIMARY KEY,
    nom				VARCHAR(20) NOT NULL,
    descripció		VARCHAR(20),
    categoria		VARCHAR(20),
    telefon 		VARCHAR(9),
    codi_fabricant INTEGER NOT NULL,
    CONSTRAINT fk_producte_fabricant FOREIGN KEY (codi) REFERENCES fabricant(codi_fabricant)
);
