-- Activitat 6.2 - Programació amb CASE

USE uf2_p2_pizzeria;

-- Tasca 1. Crea un procediment que donat un nom, un cognom, telèfon, adreça, població i indicant  si és client 
-- o empleat, l'afegeixi a la taula corresponent. Si no es client o empleat, que no faci res.
DELIMITER //
CREATE OR REPLACE PROCEDURE addClientOEmpleat(IN pOpcio ENUM('client','empleat'), IN pNom VARCHAR(20), IN pCognom VARCHAR(40), IN pTelefon VARCHAR(9), IN pAdreca VARCHAR(50), IN pPoblacio VARCHAR(20))
BEGIN
	CASE pOpcio
		WHEN 'client' THEN
			INSERT INTO client (nom, telefon, adreca, poblacio) VALUES (CONCAT(pNom, ' ', pCognom), pTelefon, pAdreca, pPoblacio);
		WHEN 'empleat' THEN
			INSERT INTO empleat (nom, cognoms) VALUES (pNom, pCognom);
	END CASE;
END //
DELIMITER ;

CALL addClientEmpleat('empleat', 'Toni', 'Montes Cuadrado', NULL, NULL, NULL);
SELECT *
FROM empleat
WHERE nom = 'Toni';

CALL addClientOEmpleat('client', 'Joel', 'Hurtado Comino', 938765433, 'Sau n23', 'Terrassa');
SELECT *
FROM client
WHERE nom = 'Joel Hurtado Comino';

-- Tasca 2. Crea un procediment que, donat ‘client’ o ‘empleat’ i el seu codi identificador, calculi i mostri 
-- quantes comandes ha demanat o gestionat. Si els paràmetres no són vàlids o no hi ha dades que retorni un 
-- missatge d'error identificatiu.
DELIMITER //
CREATE OR REPLACE PROCEDURE getComandesClientEmpleat (OUT pError VARCHAR(100), IN pOpcio ENUM('client','empleat'), IN pId SMALLINT)
BEGIN
	DECLARE num_comandes INT DEFAULT 0;
    SET pError = '';
    IF (pId IS NOT NULL) THEN
        CASE pOpcio
			WHEN pOpcio = 'client' THEN
				SET num_comandes := (SELECT COUNT(*) FROM comanda WHERE client_id = pId);
			WHEN pOpcio = 'empleat' THEN
				SET num_comandes := (SELECT COUNT(*) FROM comanda WHERE empleat_id = pId);
		END CASE;
		IF (num_comandes > 0) THEN 
			SELECT CONCAT(num_comandes, ' comande/s');
		ELSE
			SET pError = 'El client’ o ‘empleat’ no retorna informació';
	ELSE
		SET pError = 'El ’client’ o ‘empleat’ són obligatoris';
	END IF;
END // 
DELIMITER ;

CALL getComandesClientEmpleat(@missatge, 'client', 99);
SELECT @missatge;

-- Tasca 3.Crea un procediment que donada una data ens mostri les reunions a partir d’un paràmetre on:
-- Sí l'opció és 'D', els esdeveniments del mateix dia de la data. 
-- Sí l'opció és 'W', els esdeveniments de la setmana que pertany la data. 
-- Sí l'opció és 'M', els esdeveniments del mes que pertany la data. 
-- Sí l'opció és 'Y', els esdeveniments de l'any que pertany la data. 
DELIMITER //
CREATE PROCEDURE getReunionsByDataAmpliada(IN pData DATE, IN pOpcio ENUM('D', 'W', 'M', 'Y'))
BEGIN
	CASE pOpcio
	WHEN 'D' THEN
		SELECT descripcio, data, hora FROM reunions WHERE data = pData;
	WHEN 'W' THEN
		SELECT descripcio, data, hora FROM reunions WHERE (WEEK(data) = WEEK(pData)) AND (YEAR(data) = YEAR(pData));
		-- SELECT descripcio, data, hora FROM reunions WHERE (YEARWEEK(data) = YEARWEEK(pData)); 
	WHEN 'M' THEN
		SELECT descripcio, data, hora FROM reunions WHERE (MONTH(data) = MONTH(pData)) AND (YEAR(data) = YEAR(pData));
	WHEN 'Y' THEN
		SELECT descripcio, data, hora FROM reunions WHERE (YEAR(data) = YEAR(pData));
	END CASE;
END//
DELIMITER ;

SELECT * 
FROM reunions;
CALL getReunionsByDataAmpliada('2020/04/19','D');
CALL getReunionsByDataAmpliada('2020/03/19','M');
CALL getReunionsByDataAmpliada('2020/03/16','W');
CALL getReunionsByDataAmpliada('2020/04/19','Y');

-- Tasca 4. Retorna per paràmetre la quantitat de pizzes o de begudes o de postres que hem venut individualment a partir d’indicar-li que tipus de producte volem calcular respectivament. 
-- Si no indiquem un tipus de producte, que faci el càlcul amb tots els productes.
DELIMITER //
CREATE PROCEDURE getQuantitatProductesVenutsByTipus(IN pOpcio ENUM('pizzes', 'begudes', 'postres'), OUT pQuantitat SMALLINT)
BEGIN
	DECLARE quantitat_pizzes SMALLINT DEFAULT 0;
    DECLARE quantitat_begudes SMALLINT DEFAULT 0;
    DECLARE quantitat_postres SMALLINT DEFAULT 0;
    
	-- Ens aprofitem de la funció getQuantitatProductesVenuts de l'Activitat 5.2 Tasca 9.
	CALL getQuantitatProductesVenuts(quantitat_pizzes, quantitat_begudes, quantitat_postres);

	CASE pOpcio
		WHEN 'pizzes' THEN
			SET pQuantitat = quantitat_pizzes;
		WHEN 'begudes' THEN
			SET pQuantitat = quantitat_begudes;
		WHEN 'postres' THEN
			SET pQuantitat = quantitat_postres;
		ELSE
			SET pQuantitat = quantitat_pizzes + quantitat_begudes + quantitat_postres;
	END CASE;
END //
DELIMITER ;

CALL getQuantitatProductesVenutsByTipus('pizzes', @quantitat);
SELECT CONCAT(@quantitat, ' pizza/es');
CALL getQuantitatProductesVenutsByTipus('begudes', @quantitat);
SELECT CONCAT(@quantitat, ' beguda/es');
CALL getQuantitatProductesVenutsByTipus('postres', @quantitat);
SELECT CONCAT(@quantitat, ' postre/s');
CALL getQuantitatProductesVenutsByTipus(NULL, @quantitat);
SELECT CONCAT(@quantitat, ' total');

-- Tasca 5. Retorna per paràmetre la quantitat d'ingredients que té un producte en concret a partir del seu identificador. Els productes que no són pizzes en si mateixos són un únic ingredient.
-- DROP PROCEDURE getQuantitatIngredientsByProducte;
DELIMITER //
CREATE PROCEDURE getQuantitatIngredientsByProducte(IN pId_producte SMALLINT(6), OUT pQuantitat SMALLINT)
BEGIN
	SET pQuantitat = 0;
    
    IF (pId_producte IS NOT NULL) THEN
		SELECT count(*) INTO pQuantitat
		FROM productes p
			LEFT JOIN postres po ON p.id_producte = po.id_producte
			LEFT JOIN begudes be ON p.id_producte = be.id_producte
			LEFT JOIN pizzes pz ON p.id_producte = pz.id_producte
			LEFT JOIN pizzes_ingredients pi ON pz.id_producte = pi.id_producte
		WHERE p.id_producte = pId_producte
		GROUP BY p.id_producte;
	END IF;
END //
DELIMITER ;

CALL getQuantitatIngredientsByProducte(1, @quantitat);
SELECT CONCAT(@quantitat, ' ingredient/es');
CALL getQuantitatIngredientsByProducte(2, @quantitat);
SELECT CONCAT(@quantitat, ' ingredient/es');
CALL getQuantitatIngredientsByProducte(8, @quantitat);
SELECT CONCAT(@quantitat, ' ingredient/es');
CALL getQuantitatIngredientsByProducte(NULL, @quantitat);
SELECT CONCAT(@quantitat, ' ingredient/es');


-- Tasca 6. Crea un procediment per generar convocatories de reunions on enviant-li l’identificador de la reunió, convoqui els assitents sí el tipus de reunió és:
--   - General: Ha d’incloure a tots els empleats a la reunió.
--   - Caps: La reunió la realitzen aquells empleats que són caps.
--   - Personal: Assistèixen els empleats que no són caps.
-- DROP PROCEDURE setConvocatoriesReunio;
DELIMITER //
CREATE OR REPLACE PROCEDURE setConvocatoriesReunio(IN pId_reunio SMALLINT(6))
BEGIN
	CASE (SELECT t.nom FROM tipus t INNER JOIN reunions r ON t.id_tipus = r.tipus_id WHERE r.id_reunio = pId_reunio)
		WHEN 'General' THEN
			INSERT INTO empleats_reunions (id_reunio, id_empleat)
				SELECT pId_reunio, id_empleat
				FROM empleats;
		WHEN 'Caps' THEN
			INSERT INTO empleats_reunions (id_reunio, id_empleat)
				SELECT pId_reunio, id_empleat
				FROM empleats
                WHERE empleat_id_cap IS NOT NULL;
		WHEN 'Personal' THEN
			INSERT INTO empleats_reunions (id_reunio, id_empleat)
				SELECT pId_reunio, id_empleat
				FROM empleats
                WHERE empleat_id_cap IS NULL;
	END CASE;
END //
DELIMITER ;

SELECT *  FROM reunions;

CALL setConvocatoriesReunio(5);
SELECT * 
FROM empleats_reunions
WHERE id_reunio = 5;

CALL setConvocatoriesReunio(9);
SELECT * 
FROM empleats_reunions
WHERE id_reunio = 9;

CALL setConvocatoriesReunio(7);
SELECT * 
FROM empleats_reunions
WHERE id_reunio = 7;