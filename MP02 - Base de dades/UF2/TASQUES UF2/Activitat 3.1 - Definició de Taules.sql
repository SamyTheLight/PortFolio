USE m02_uf2;
CREATE TABLE TREBALL(
	nom 		VARCHAR(20),
    carrec 		VARCHAR(50),
    edat 		INTEGER,
    PRIMARY KEY (nom)
);
CREATE TABLE CIUTAT(
	comarca 	VARCHAR(25) NOT NULL,
    provincia 	VARCHAR(25) NOT NULL,
    habitants 	INTEGER,
    nom  		VARCHAR(25),
    PRIMARY KEY (nom)
    );
CREATE TABLE DEPARTAMENT(
	numero 			INTEGER(2),
    nom 			VARCHAR(9) NOT NULL,
    localitzacio 	VARCHAR(10),
    PRIMARY KEY (numero),
    CONSTRAINT uk_departament_nom UNIQUE (nom)
    );
CREATE TABLE CLIENT(
	nom 				VARCHAR(25)NOT NULL,
    cognoms				VARCHAR(25) NOT NULL,
    data_naixement		DATE,
    tipus				VARCHAR(25) DEFAULT(habitual),
    id_client			INTEGER AUTO_INCREMENT,
    PRIMARY KEY (id_client),
    CONSTRAINT uk_client_nom_cognoms UNIQUE (nom, cognoms)
    );
    
    #Activitat 8.1 Consultes amb ordenació
    -- Tasca 1. Treball.
	# Crea una taula anomenada TREBALL amb els camps nom, edat i càrrec, 
	# sent els camps nom i càrrec amb una longitud màxima de 20 i 50 
    # respectivament. La clau primària serà el nom.
CREATE TABLE treball(
    nom     VARCHAR(20),
    edat    INTEGER,
    carrec  VARCHAR(50),
    PRIMARY KEY (nom)
);
-- Tasca 2. Ciutat.
	# Crea una taula anomenada CIUTAT amb els camps comarca, província i 
    # habitants, i un camp identificador que serà clau primària que conté 
    # el nom de la ciutat. Els camps textuals tindran una longitud màxima 
    # de 25 caràcters. Cap podrà ser nul excepte el nombre d’habitants. 
CREATE TABLE ciutat(
    nom            VARCHAR(25),
    comarca     VARCHAR(25) NOT NULL,
    provincia   VARCHAR(25) NOT NULL,
    habitants   INTEGER,
    PRIMARY KEY (nom)
);
-- Tasca 3. Departament.
	# Crear una taula DEPARTAMENT amb camps:
		# 1. número (numèric d’amplada 2).
		# 2. nom (VARCHAR d’amplada 9).
		# 3. localització (VARCHAR d’amplada 10)
    # Com a valor únic el nom i com a clau primària el número de departament.
CREATE TABLE departament(
    numero       INTEGER(2),
    nom             VARCHAR(9) NOT NULL,
    localitzacio VARCHAR(10),
    PRIMARY KEY (numero),
    CONSTRAINT uk_departament_nom UNIQUE(nom)
);
-- Tasca 4. Client.
	# Crea una taula anomenada CLIENT amb els camps nom, cognoms, data de 
    # naixement, tipus, i un camp identificador que serà clau primària i 
	# autonúmeric, els noms-cognoms seran únics, i el camp tipus agafarà com a 
    # valor per defecte ‘Habitual’.
CREATE TABLE client(
   id_client        INTEGER    AUTO_INCREMENT,
   nom                VARCHAR(25) NOT NULL,
   cognoms          VARCHAR(25) NOT NULL,
   data_naixement   DATE,
   tipus            VARCHAR(25) DEFAULT("Habitual"),
   PRIMARY KEY (id_client),
   CONSTRAINT     uk_client_nom_cognoms UNIQUE (nom,cognoms)
);

    