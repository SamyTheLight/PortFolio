# DAM M02 UF3
# Activitat Activitat 6.1 Programació amb IF

USE uf2_p2_pizzeria;

-- Tasca 1. Crea un procediment per generar l’estructura de la gestió de reunions. Usa un paràmetre on:
-- Si li passem 'C', crei l'estructura de les taules.
-- Si li passem 'D', elimini les taules.
-- Recorda que aquesta estructura pot o no existir al executar el procediment.
DELIMITER //
CREATE OR REPLACE PROCEDURE createGestioReunions (IN pOpcio ENUM('C', 'D'))
BEGIN
IF (pOpcio = 'C') THEN -- Creem les taules reunions, empleat_reunions i tipus_reunions
CREATE TABLE IF NOT EXISTS tipus (
id_tipus TINYINT AUTO_INCREMENT,
nom VARCHAR(10) NOT NULL,
lloc VARCHAR(20) NOT NULL,
            PRIMARY KEY (id_tipus),
            CONSTRAINT uk_tipus_nom UNIQUE (nom)
) ENGINE=INNODB;
CREATE TABLE IF NOT EXISTS reunions (
id_reunio SMALLINT AUTO_INCREMENT,
data DATE NOT NULL,
hora TIME NOT NULL,
descripcio VARCHAR(20) NOT NULL,
            tipus_id TINYINT NOT NULL,
            PRIMARY KEY (id_reunio),
            CONSTRAINT fk_reunions_tipus FOREIGN KEY (tipus_id) REFERENCES tipus (id_tipus)
) ENGINE=INNODB;
CREATE TABLE IF NOT EXISTS empleats_reunions (
id_empleat SMALLINT(3),
id_reunio SMALLINT,
PRIMARY KEY (id_empleat, id_reunio),
CONSTRAINT fk_empleat_reunions_empleat FOREIGN KEY (id_empleat) REFERENCES empleat (id_empleat),
CONSTRAINT fk_empleat_reunions_reunions FOREIGN KEY (id_reunio) REFERENCES reunions (id_reunio)
) ENGINE=INNODB;    
-- Creem i afegim en la taula empleats la FK empleat_id_cap
        ALTER TABLE empleat ADD COLUMN IF NOT EXISTS empleat_id_cap SMALLINT(3);
ALTER TABLE empleat DROP CONSTRAINT IF EXISTS fk_empleat_empleat_cap;
ALTER TABLE empleat DROP INDEX IF EXISTS fk_empleat_empleat_cap;
        ALTER TABLE empleat ADD CONSTRAINT fk_empleat_empleat_cap FOREIGN KEY IF NOT EXISTS (empleat_id_cap) REFERENCES empleat (id_empleat);
-- Si la opcio es 'D', borrem totes les taules anteriors
ELSEIF (pOpcio = 'D') THEN
        ALTER TABLE empleat DROP FOREIGN KEY IF EXISTS fk_empleat_empleat_cap;
        ALTER TABLE empleat DROP INDEX IF EXISTS fk_empleat_empleat_cap;
ALTER TABLE empleat DROP COLUMN IF EXISTS empleat_id_cap;
DROP TABLE IF EXISTS empleats_reunions;
        DROP TABLE IF EXISTS reunions;
        DROP TABLE IF EXISTS tipus;
END IF;
END//
DELIMITER ;

DROP PROCEDURE createGestioReunions;

CALL createGestioReunions('C');
CALL createGestioReunions('C');
CALL createGestioReunions('D');
CALL createGestioReunions('D');
CALL createGestioReunions('C');

-- Tasca 2. Crea una procediment per afegir Tipus de reunions. Incorpora a la BD aquestes:
DELIMITER //
CREATE PROCEDURE addTipusReunions (IN pNom VARCHAR(10), pLloc VARCHAR(20))
BEGIN
	INSERT INTO tipus(nom, lloc) VALUES(pNom, pLloc);
END //
DELIMITER ;

CALL addTipusReunions ('Caps', 'Oficina central');
CALL addTipusReunions ('General', 'Local principal');
CALL addTipusReunions ('Personal', 'Local Principal');

SELECT * FROM tipus;

-- Tasca 3. Crea una procediment per afegir Reunions. Afegeix un parell per a cada Tipus de reunió.
DELIMITER // 
CREATE PROCEDURE addReunions (IN pTipus_id TINYINT, IN pData DATE, IN pHora TIME, IN pDescripcio VARCHAR(20))
BEGIN
	INSERT INTO reunio(tipus_id, data, hora, descripcio) VALUES(pTipus_id, pData, pHora, pDescripcio);
END //
DELIMITER ;

CALL addReunions('2020-03-10', '10:00', 'Sindicat', (SELECT id_tipus FROM tipus WHERE nom = 'General'));
CALL addReunions('2020-03-10', '12:00', 'Empresa', (SELECT id_tipus FROM tipus WHERE nom = 'Caps'));
CALL addReunions('2020-03-12', '10:00', 'Tendes', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'));


-- Tasca 4. Crea un procediment que busqui els empleats per nom i cognoms. Tingueu en compte que si deixem algun dels paràmetres buits 
-- cerqui pels altres o mostri tots els empleats.
DELIMITER //
CREATE PROCEDURE searchEmpleats (IN pNom VARCHAR(10), pCognom VARCHAR(20))
BEGIN
	IF (pNom IS NOT NULL AND pCognom IS NOT NULL) THEN -- Cerca per nom i cognoms
	  SELECT * FROM empleat;
      
	ELSEIF (pNom IS NULL AND pCognom IS NOT NULL) THEN -- Cerca per cognoms
	 SELECT * FROM empleat
		WHERE cognoms LIKE pCognom;
        
	ELSEIF (pNom IS NOT NULL AND pCognom IS NULL) THEN -- Cerca per nom
	 SELECT * FROM empleat
		WHERE nom LIKE pNom;
        
	ELSE -- Cerca tots
	 SELECT * FROM empleat; 
	END IF;
END //
DELIMITER ;

DROP PROCEDURE searchEmpleats;

CALL searchEmpleats(NULL, NULL);
CALL searchEmpleats('Jordi', NULL);
CALL searchEmpleats(NULL, 'Casas');
CALL searchEmpleats('Marta', 'Pou');
CALL searchEmpleats('%r%', NULL);

-- Tasca 5. Crea una procediment per gestionar els Empleats. Amb la condició qué:
-- Sí l’empleat existeix, modifica les seves dades
-- sino, el crea de nou.
DELIMITER //
CREATE PROCEDURE createEmpleat (IN pId_empleat SMALLINT(3), IN pNom VARCHAR(20), IN pCognoms VARCHAR(40), IN pEmpleat_id_cap SMALLINT(3))	
BEGIN
-- Si existeix 1 empleat, modifiquem les seves dades
	IF (SELECT 1 FROM empleat WHERE id_empleat = pId_empleat) THEN
		UPDATE empleat
        SET nom = pNom, cognoms = pCognoms, empleat_id_cap = pEmpleat_id_cap
        WHERE id_empleat = pId_empleat;
-- Si no existeix, el creem nosaltres
	ELSE
		INSERT INTO empleat (id_empleat, nom, cognoms, empleat_id_cap) SELECT pId_empleat, pNom, pCognoms, pEmpleat_id_cap;
	END IF;
END //
DELIMITER ;

CALL createEmpleat(3, 'Jose', 'Garcia', NULL);
CALL createEmpleat(4, 'Joan', 'Rodriguez', NULL);
CALL createEmpleat(5, 'Ivan', 'Reuz', NULL);

-- Tasca 6. Crea una procediment per asignar un cap a un empleat. Dona d’alta un parell d’empleats siguin caps. En cas que:
-- L’empleat cap no s’informir vol dir que aquell empleat ja no te cap.
-- L’empleat i el cap han d’existir en cas que s’informin, sino s’ha de retornar un avis a l’usuari.
DELIMITER //
CREATE PROCEDURE setCapAEmpleat(OUT pError VARCHAR(30), IN pId_empleat SMALLINT(3), IN pEmpleat_id_cap SMALLINT(3))
BEGIN
	SET pError = '';
	IF (((SELECT 1 FROM empleats WHERE id_empleat = pId_empleat) AND 
        (SELECT 1 FROM empleats WHERE id_empleat = pEmpleat_id_cap))
        OR 
        ((SELECT 1 FROM empleats WHERE id_empleat = pId_empleat) AND (pEmpleat_id_cap IS NULL))
       ) THEN
		UPDATE empleats 
		SET empleat_id_cap = pEmpleat_id_cap
		WHERE id_empleat = pId_empleat;
	ELSE
		SET pError = 'L''empleat o el cap no existeix';
	END IF;
END //
DELIMITER ;

CALL setCapAEmpleat(@missatge, 3, 1);
SELECT @missatge;
CALL setCapAEmpleat(@missatge, 4, 2);
SELECT @missatge;
CALL setCapAEmpleat(@missatge, 5, 333);
SELECT @missatge;
CALL setCapAEmpleat(@missatge, 5, 1);
SELECT @missatge;
CALL setCapAEmpleat(@missatge, 5, NULL);
SELECT @missatge;


-- Tasca 7. Crea un procediment que esborri totes les reunions entre dues dates. A més:
-- Si deixem la primera data en blanc esborrarà totes les reunions anteriors a la segona data,
-- i si deixem la segona data en blanc esborrarà totes les runions posteriors a la primera data. 
-- Finalment, si no hi ha dates elimina tots els registres.
DELIMITER //
CREATE PROCEDURE delReunions(IN pData_inici DATE, IN pData_fi DATE)
BEGIN
	IF (pData_inici IS NOT NULL AND pData_fi IS NOT NULL) THEN
		DELETE er
		FROM empleats_reunions er
			INNER JOIN reunions r ON er.id_reunio = r.id_reunio
		WHERE r.data BETWEEN pData_inici AND pData_fi;
        
		DELETE FROM reunions WHERE data BETWEEN pData_inici AND pData_fi;
	ELSEIF (pData_inici IS NULL AND pData_fi IS NOT NULL) THEN
		DELETE er
		FROM empleats_reunions er
			INNER JOIN reunions r ON er.id_reunio = r.id_reunio
		WHERE r.data <= pData_fi;

		DELETE FROM reunions WHERE data <= pData_fi;
	ELSEIF (pData_inici IS NOT NULL AND pData_fi IS NULL) THEN
		DELETE er
		FROM empleats_reunions er
			INNER JOIN reunions r ON er.id_reunio = r.id_reunio
		WHERE r.data >= pData_inici;

		DELETE FROM reunions WHERE data >= pData_inici;
	ELSE -- IF (pData_inici IS NULL AND pData_fi IS NULL) THEN
		DELETE FROM empleats_reunions;
		DELETE FROM reunions;
	END IF;
END //
DELIMITER ;

CALL delReunions('2020-03-10', '2020-03-10');
CALL delReunions('2020-03-11', '2020-03-12');
CALL delReunions('2020-03-12', NULL);
CALL delReunions(NULL, '2020-03-16');
CALL delReunions(NULL, NULL);


-- Tasca 8. Crea un procediment que donada una data endarrereixi els esdeveniments d’aquella data un mes. 
DELIMITER //
CREATE PROCEDURE setEndarrarimentReunio1Mes(IN pData DATE)
BEGIN
	UPDATE reunions 
    SET data = ADDDATE(data,  INTERVAL 1 MONTH)
    WHERE data = pData;
END //
DELIMITER ;

CALL addReunions('2020-03-10', '10:00', 'Sindicat', (SELECT id_tipus FROM tipus WHERE nom = 'General'));
CALL addReunions('2020-03-10', '12:00', 'Empresa', (SELECT id_tipus FROM tipus WHERE nom = 'Caps'));
CALL addReunions('2020-03-12', '10:00', 'Tendes', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'));
CALL addReunions('2020-03-18', '10:00', 'Sindicat 2', (SELECT id_tipus FROM tipus WHERE nom = 'General'));
CALL addReunions('2020-03-16', '12:00', 'Empresa 2', (SELECT id_tipus FROM tipus WHERE nom = 'Caps'));
CALL addReunions('2020-03-19', '10:00', 'Tendes 2', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'));
CALL addReunions('2020-03-19', '16:00', 'Tendes 3', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'));
SELECT *
FROM reunions;

CALL setEndarrarimentReunio1Mes('2020-03-19');
SELECT *
FROM reunions;

-- Tasca 9. Crea un procediment que donada una reunió i un paràmetre amb els valors ‘W’, ‘D’, ‘M’ o ‘Y’, endarrereixi una setmana, un dia, un més o un any la reunió, respectivament. 
DELIMITER //
CREATE PROCEDURE setEndarrarimentReunio(IN pId_reunio SMALLINT, IN pOpcio ENUM('W', 'D', 'M', 'Y'))
BEGIN
	IF (pOpcio = 'W') THEN
		UPDATE reunions 
		SET data = ADDDATE(data,  INTERVAL 1 WEEK)
		WHERE id_reunio = pId_reunio;
	ELSEIF (pOpcio = 'D') THEN
		UPDATE reunions 
		SET data = ADDDATE(data,  INTERVAL 1 DAY)
		WHERE id_reunio = pId_reunio;
	ELSEIF (pOpcio = 'M') THEN
		UPDATE reunions 
		SET data = ADDDATE(data,  INTERVAL 1 MONTH)
		WHERE id_reunio = pId_reunio;
	ELSEIF (pOpcio = 'Y') THEN
		UPDATE reunions 
		SET data = ADDDATE(data,  INTERVAL 1 YEAR)
		WHERE id_reunio = pId_reunio;
    END IF;
END //
DELIMITER ;

SELECT *
FROM reunions;
CALL setEndarrarimentReunio(5, 'D');
CALL setEndarrarimentReunio(6, 'W');
CALL setEndarrarimentReunio(7, 'M');
CALL setEndarrarimentReunio(8, 'Y');
SELECT *
FROM reunions;

-- Tasca 10. Crea un procediment per generar l’estructura de la gestió de sorteigs. Usa un paràmetre on: 
-- Si li passem 'C', crei l'estructura de les taules.
-- Si li passem 'D', elimini les taules.
-- Recorda que aquesta estructura pot o no existir al executar el procediment.
DELIMITER // 
CREATE PROCEDURE createGestioSorteigs(IN pOpcio ENUM('C', 'D')) 
BEGIN 
	IF (pOpcio = 'C') THEN 
		CREATE TABLE IF NOT EXISTS sorteigs (
			id_sorteig SMALLINT AUTO_INCREMENT, 
			nom VARCHAR(20) NOT NULL,
            data DATE NOT NULL,
			premis TINYINT NOT NULL,
            PRIMARY KEY (id_sorteig),
            CONSTRAINT uk_sorteigs_data UNIQUE (data)
		) ENGINE=INNODB; 
		CREATE TABLE IF NOT EXISTS sorteigs_comandes (
			id_sorteig SMALLINT,
			numero  SMALLINT,
			PRIMARY KEY (id_sorteig, numero),
			CONSTRAINT fk_sorteigs_comandes_sorteigs FOREIGN KEY (id_sorteig) REFERENCES sorteigs (id_sorteig),
			CONSTRAINT fk_sorteigs_comandes_comandes FOREIGN KEY (numero) REFERENCES comandes (numero)
		) ENGINE=INNODB;     
	ELSEIF (pOpcio = 'D') THEN
		DROP TABLE IF EXISTS sorteigs_comandes; 
        DROP TABLE IF EXISTS sorteigs; 
	END IF; 
END// 
DELIMITER ; 

CALL createGestioSorteigs(NULL);
CALL createGestioSorteigs('A');
CALL createGestioSorteigs('C');
CALL createGestioSorteigs('D');
CALL createGestioSorteigs('C');

-- Tasca 11. Crea una procediment per afegir Sorteigs.
DELIMITER //
CREATE PROCEDURE addSorteig(IN pNom VARCHAR(20), IN pData DATE, IN pPremis TINYINT)
BEGIN
	INSERT INTO sorteigs (nom, data, premis) VALUES (pNom, pData, pPremis);
END //
DELIMITER ;

CALL addSorteig('Dia del client', '2020-03-12', 2);
CALL addSorteig('Dia del mes', '2020-03-15', 1);

SELECT *
FROM sorteigs;

-- Tasca 12. Crea una procediment per eliminar Sorteigs. Amb la condició qué:
-- Si no indiquem un sorteig, esborra tots els existents,
-- però si indica un identificador de sorteig l’esborra si existeix i sinó ens retorna per parametre un missatge que no existeix el sorteig.
DELIMITER //
CREATE PROCEDURE delSorteigs(OUT pError VARCHAR(30), IN pId_sorteig SMALLINT)
BEGIN
	IF (pId_sorteig IS NOT NULL) THEN
		IF (SELECT 1 FROM sorteigs WHERE id_sorteig = pId_sorteig) THEN
			DELETE FROM sorteigs WHERE id_sorteig = pId_sorteig;
		ELSE
			SET pError = 'El sorteig no existeix';
		END IF;
	ELSE
		DELETE FROM sorteigs;
	END IF;
END //
DELIMITER ;

CALL delSorteigs(@missatge, 2);
SELECT @missatge;
SELECT *
FROM sorteigs
WHERE id_sorteig = 2;

CALL delSorteigs(@missatge, 23);
SELECT @missatge;
SELECT *
FROM sorteigs
WHERE id_sorteig = 23;

CALL delSorteigs(@missatge, NULL);
SELECT @missatge;
SELECT *
FROM sorteigs;