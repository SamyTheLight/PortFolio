# Activitat 5.1 - Centre educatiu
#Tasca 1. Base de dades del Centre Educatiu
DROP DATABASE IF EXISTS centre_educatiu;
CREATE DATABASE centre_educatiu;
SHOW DATABASES;
USE centre_educatiu;
#Tasca 2. Generació de taules
DROP TABLE IF EXISTS  familia;
CREATE TABLE familia(
	id_familia 					CHAR(3) NOT NULL,
    camp_familia 				VARCHAR(60) NOT NULL,
    PRIMARY KEY (id_familia),
    CONSTRAINT uk_familia_camp_familia UNIQUE (camp_familia)
);

DROP TABLE IF EXISTS cicle_formatiu;
CREATE TABLE cicle_formatiu(
	id_cicle 					VARCHAR(4) NOT NULL,
	titol_cicle 				VARCHAR(60) NOT NULL,
	grau_cicle 					ENUM('GM', 'GS') NOT NULL, #VARCHAR(60) NOT NULL
	familia_id					CHAR(3) NOT NULL,
    PRIMARY KEY (id_cicle),
    CONSTRAINT fk_cicle_formatiu_familia FOREIGN KEY (familia_id) 
			REFERENCES familia (id_familia),
    CONSTRAINT uk_cicle_nom UNIQUE (titol_cicle)
);

DROP TABLE IF EXISTS modul;
CREATE TABLE modul(
	id_modul 					TINYINT AUTO_INCREMENT NOT NULL,
	titol_modul         		VARCHAR(60) NOT NULL,
	cicle_id 					CHAR(4) NOT NULL,
    PRIMARY KEY (id_modul, cicle_id),
    CONSTRAINT fk_modul_familia FOREIGN KEY (cicle_id)
			REFERENCES cicle_formatiu (id_cicle)
);

DROP TABLE IF EXISTS unitat_formativa;
CREATE TABLE unitat_formativa(
	id_unitat_formativa 		TINYINT AUTO_INCREMENT NOT NULL,
    titol_unitat_formativa 		VARCHAR(60) NOT NULL,
    modul_id 					TINYINT NOT NULL,
    cicle_id 					CHAR(4) NOT NULL,
    PRIMARY KEY (id_unitat_formativa, modul_id, cicle_id),
    CONSTRAINT fk_unitat_formativa_modul FOREIGN KEY (cicle_id, modul_id) 
			REFERENCES modul (cicle_id, id_modul)
);
#Tasca 3. Insert
#INSERT INTO nom_taula [llistat_columnes] VALUES [valors_de_dades];
INSERT INTO familia (id_familia, camp_familia) VALUES ('INF', 'Informàtica i comunicació');
INSERT INTO familia (id_familia, camp_familia) VALUES ('ADM', 'Administració i gestió');
INSERT INTO familia (id_familia, camp_familia) VALUES ('COM', 'Comerç i màrqueting');
INSERT INTO familia (id_familia, camp_familia) VALUES ('HOT', 'Hoteleria i turisme 	');
INSERT INTO familia (id_familia, camp_familia) VALUES ('EE', 'Electricitat i electrònica');

INSERT INTO cicle_formatiu (id_cicle, titol_cicle, grau_cicle) VALUES ('SMIX', 'Sistemes Microinformàtics i Xarxes', 'GM');
INSERT INTO cicle_formatiu (id_cicle, titol_cicle, grau_cicle) VALUES ('ASIX', 'Administració de Sistemes Informàtics en la Xarxa', 'GS');
INSERT INTO cicle_formatiu (id_cicle, titol_cicle, grau_cicle) VALUES ('DAM', 'Desenvolupament Aplicacions Multiplataforma', 'GS');
INSERT INTO cicle_formatiu (id_cicle, titol_cicle, grau_cicle) VALUES ('DAW', ' Desenvolupament Aplicacions Web', 'GS');

INSERT INTO modul (id_modul, titol_modul) VALUES ('1', 'Muntatge i manteniment d’equips');
INSERT INTO modul (id_modul, titol_modul) VALUES ('1', 'Muntatge i manteniment d’equips');
INSERT INTO modul (id_modul, titol_modul) VALUES ('1', 'Muntatge i manteniment d’equips');
INSERT INTO modul (id_modul, titol_modul) VALUES ('2', 'Sistemes operatius monolloc');
INSERT INTO modul (id_modul, titol_modul) VALUES ('2', 'Sistemes operatius monolloc');
INSERT INTO modul (id_modul, titol_modul) VALUES ('1', 'Implantació de sistemes operatius');
INSERT INTO modul (id_modul, titol_modul) VALUES ('1', 'Implantació de sistemes operatius');
INSERT INTO modul (id_modul, titol_modul) VALUES ('2', 'Gestió de bases de dades');
INSERT INTO modul (id_modul, titol_modul) VALUES ('2', 'Gestió de bases de dades');
INSERT INTO modul (id_modul, titol_modul) VALUES ('3', 'Programació bàsica');
INSERT INTO modul (id_modul, titol_modul) VALUES ('4', 'Llenguatges de marques');

INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('1', 'Electricitat a l’ordinador');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('2', 'Components d’un equip microinformàtic');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('3', 'Muntatge d’un equip microinformàtic');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('1', 'Introducció als sistemes operatius');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('2', 'Sistemes operatius propietaris');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('1', 'Instal·lació, configuració i explotació del sistema informàtic');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('2', 'Gestió de la informació i de recursos en una xarxa');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('1', 'Introducció a les bases de dades');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('1', 'Programació estructurada');
INSERT INTO unitat_formativa (id_unitat_formativa, titol_unitat_formativa) VALUES ('1', 'Programació amb XML');
#Tasca 4. Modificacions a les taules
ALTER table modul 
		ADD hores SMALLINT NOT NULL;
ALTER TABLE unitat_formativa 
		ADD hores SMALLINT NOT NULL;
#Tasca 5. Update
# Moduls
UPDATE modul SET hores=198 WHERE id_modul=1 AND cicle_id='SMIX';
UPDATE modul SET hores=132 WHERE id_modul=2 AND cicle_id='SMIX';  
UPDATE modul SET hores=231 WHERE id_modul=1 AND cicle_id='ASIX';  
UPDATE modul SET hores=165 WHERE id_modul=2 AND cicle_id='ASIX';  
UPDATE modul SET hores=165 WHERE id_modul=3 AND cicle_id='ASIX'; 
UPDATE modul SET hores=99 WHERE id_modul=4 AND cicle_id='ASIX'; 

# Unitats formatives
UPDATE unitat_formativa SET hores=25 WHERE id_unitat_formativa=1 AND modul_id=1 AND cicle_id='SMIX'; 
UPDATE unitat_formativa SET hores=28 WHERE id_unitat_formativa=2 AND modul_id=1 AND cicle_id='SMIX'; 
UPDATE unitat_formativa SET hores=28 WHERE id_unitat_formativa=3 AND modul_id=1 AND cicle_id='SMIX'; 
UPDATE unitat_formativa SET hores=33 WHERE id_unitat_formativa=1 AND modul_id=2 AND cicle_id='SMIX'; 
UPDATE unitat_formativa SET hores=33 WHERE id_unitat_formativa=2 AND modul_id=2 AND cicle_id='SMIX'; 
UPDATE unitat_formativa SET hores=60 WHERE id_unitat_formativa=1 AND modul_id=1 AND cicle_id='ASIX'; 
UPDATE unitat_formativa SET hores=80 WHERE id_unitat_formativa=2 AND modul_id=1 AND cicle_id='ASIX'; 
UPDATE unitat_formativa SET hores=33 WHERE id_unitat_formativa=1 AND modul_id=2 AND cicle_id='ASIX'; 
UPDATE unitat_formativa SET hores=66 WHERE id_unitat_formativa=2 AND modul_id=2 AND cicle_id='ASIX'; 
UPDATE unitat_formativa SET hores=85 WHERE id_unitat_formativa=1 AND modul_id=3 AND cicle_id='ASIX';
UPDATE unitat_formativa SET hores=45 WHERE id_unitat_formativa=1 AND modul_id=4 AND cicle_id='ASIX';
-- Tasca 6. Delete
DELETE FROM unitat_formativa WHERE modul_id=4 AND cicle_id='ASIX';
DELETE FROM modul WHERE id_modul=4 AND cicle_id='ASIX';  