SHOW DATABASES;
DROP DATABASE IF EXISTS practica_uf2p1;
CREATE DATABASE practica_uf2p1;
USE practica_uf2p1;
SHOW TABLES;

DROP TABLE IF EXISTS aula;
CREATE TABLE aula(
	numero_aula			VARCHAR(3) NOT NULL PRIMARY KEY #A01, A02, B01 ...
);

DROP TABLE IF EXISTS ordinador;
CREATE TABLE ordinador(
	numero_serie 		VARCHAR (20) NOT NULL PRIMARY KEY, 
    velocitat 			DECIMAL (6,2) NOT NULL, #3200.45 Mhz (sin contar el espacio, el punto y Mhz).
    memoria 			VARCHAR (6) NOT NULL, #2560MB (es necesario especificar el tipo de memoria 'MB, GB, T'. Por ello estamos obligados a usar VARCHAR).
    numero_correlatiu 	TINYINT UNSIGNED NOT NULL, #UNSIGNED para evitar asignar a un ordenador un numero correlativo negativo (ya que no tiene sentido que exista el ordenador -1 (del aula A01, por ejemplo).
    aula_numero			VARCHAR (3) NOT NULL, 
    CONSTRAINT fk_ordinador_aula FOREIGN KEY (aula_numero) REFERENCES aula (numero_aula),
    CONSTRAINT uk_ordinador_numero_serie UNIQUE (numero_serie)
);

DROP TABLE IF EXISTS usuari;
CREATE TABLE usuari(
	dni					CHAR(9) NOT NULL PRIMARY KEY,
    nom 				VARCHAR (20) NOT NULL,
    cognoms				VARCHAR (20) NOT NULL,
    nom_usuari 			VARCHAR (20) NOT NULL,
    correu_electronic 	VARCHAR (50) NOT NULL,
    poblacio 			VARCHAR (20) NOT NULL, #Se tiene en consideracion en la base de datos que sea obligatorio rellenar todos los campos.
    CONSTRAINT uk_usuari_dni UNIQUE (dni),
    CONSTRAINT ck_usuari_correu_electronic CHECK ('@')
);

DROP TABLE IF EXISTS ordinador_usuari;
CREATE TABLE ordinador_usuari(
	dni					CHAR(9) NOT NULL,
    serie_numero 		VARCHAR (20) NOT NULL, 
    dataHora_connexio	DATETIME NOT NULL, #Este campo contiene el año, mes, dia, horas, minutos y segundos. Mas adelante se alterara la columna para añadir por defecto la fecha (año, mes, dia, horas, minutos y segundos) actual. 
    PRIMARY KEY (dni, serie_numero),
    CONSTRAINT fk_ordinador_usuari_usuari FOREIGN KEY (dni) REFERENCES usuari (dni),
    CONSTRAINT fk_ordinador_usuari_ordinador FOREIGN KEY (serie_numero) REFERENCES ordinador (numero_serie)
);
ALTER TABLE ordinador_usuari
			MODIFY dataHora_connexio DATETIME DEFAULT CURRENT_TIMESTAMP; #Seria lo mismo que añadir directamente 'DATETIME DEFAULT CURRENT_TIMESTAMP' en 'dataHora_connexio'.
SHOW INDEX FROM usuari; #Mostramos los indices para comprovar los cambios efectuados.
CREATE INDEX ix_usuari_correu_electronic ON usuari (correu_electronic);
ALTER TABLE usuari ADD INDEX ix_usuari_poblacio (poblacio);