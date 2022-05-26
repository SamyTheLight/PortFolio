-- Activitat 6.3 - Programació amb WHILE

USE uf2_p2_pizzeria;

-- Tasca 1. Crea un procediment que donat dues dates, esborri totes les reunions compreses entre aquells dies. 
-- Si no hi ha reunions a esborrar o les dates no s'informen, retornar un avís d'error.
DELIMITER //
CREATE OR REPLACE PROCEDURE deleteReunionsByDies(Out pError VARCHAR(100), IN pData_Inici DATE, IN pData_Fi DATE)
BEGIN
	IF (
    (pData_Inici IS NOT NULL) AND (pData_Fi IS NOT NULL) AND (pData_Inici <= pData_Fi) AND
    (SELECT 1 FROM reunions WHERE data BETWEEN pData_Inici AND pData_Fi LIMIT 1)
		) THEN
			SET pError = '';
            WHILE (pData_Inici <= pData_Fi) DO
				-- Esborrem també les convocatories a les reunions.
				DELETE er
				FROM empleats_reunions er
					INNER JOIN reunions r ON er.id_reunio = r.id_reunio
				WHERE r.data = pData_inici;

				DELETE FROM reunions WHERE data = pData_Inici;
            
				SET pData_Inici = ADDDATE(pData_Inici, INTERVAL 1 DAY);
			END WHILE;
		ELSE
			SET pError = 'No hi ha reunions o les dates són incorrectes';
        END IF;
	END //
    DELIMITER ;
    
CALL deleteReunionsByDies(@missatge, '2020/04/15', '2020/04/19');
SELECT @missatge;
CALL deleteReunionsByDies(@missatge, '2020/04/15', '2020/04/19');
SELECT @missatge;
CALL deleteReunionsByDies(@missatge, '2020/04/17', '2020/04/16');
SELECT @missatge;
CALL deleteReunionsByDies(@missatge, NULL, '2020/04/19');
SELECT @missatge;

-- Tasca 2. Crea un procediment que generi reunions, de manera que inserirà un esdeveniment repetit cada cert temps. 
-- Els paràmetres que li donarem seran els següents:
	-- Data d'inici de les insercions,
	-- Data final de les insercions,
	-- Hora de l'esdeveniment,
	-- Esdeveniment
    -- Identificador del Tipus de reunió, recordeu que les reunions de:
		-- Caps assisteixen els empleats que són caps, 
		-- a les reunions General assisteixen tots els empleats
		-- i les reunions de Personal només aquells que no són caps
	-- Freqüència: D (diària), W (setmanal), M (mensual) i Y (anual).
DELIMITER //
CREATE PROCEDURE setReunions(IN pData_Inici DATE, IN pData_Fi DATE, IN pHora TIME,
							 IN pDescripcio VARCHAR(20), IN pTipus_Id TINYINT, IN pOpcio ENUM('D', 'W', 'M', 'Y'))	
BEGIN
		DECLARE data_reunio DATE DEFAULT pData_Inici;
    DECLARE id_reunio SMALLINT(6);
    
	WHILE (data_reunio <= pData_Fi) DO
		-- Ens aprofitem de la funció addReunions de l'Activitat 6.1 Tasca 3 per afegir una reunió
        CALL addReunions(data_reunio, pHora, pDescripcio, pTipus_Id);
        SET id_reunio = LAST_INSERT_ID();
        -- Ens aprofitem de la funció setConvocatoriesReunio de l'Activitat 6.2 Tasca 6. per convocar als empleats
        CALL setConvocatoriesReunio(id_reunio);
        
		CASE pOpcio
			WHEN 'D' THEN
				SET data_reunio = ADDDATE(data_reunio, INTERVAL 1 DAY);
			WHEN 'W' THEN
				SET data_reunio = ADDDATE(data_reunio, INTERVAL 1 WEEK);
			WHEN 'M' THEN
				SET data_reunio = ADDDATE(data_reunio, INTERVAL 1 MONTH);
			WHEN 'Y' THEN
				SET data_reunio = ADDDATE(data_reunio, INTERVAL 1 YEAR);
		END CASE;
	END WHILE;
END //
DELIMITER ;

SELECT *
FROM reunions;
CALL setReunions('2020/04/30', '2020/05/30', '20:00', 'Reunió de Caps 4', (SELECT id_tipus FROM tipus WHERE nom = 'Caps'), 'M');
SELECT *
FROM reunions
WHERE (data BETWEEN '2020/04/30' AND '2020/05/30') AND hora = '20:00' 
	AND tipus_id = (SELECT id_tipus FROM tipus WHERE nom = 'Caps');

CALL setReunions('2020/04/30', '2025/04/30', '21:00', 'Reunió General 4', (SELECT id_tipus FROM tipus WHERE nom = 'General'), 'Y');
SELECT *
FROM reunions
WHERE (data BETWEEN '2020/04/30' AND '2025/04/30') AND hora = '21:00' 
	AND tipus_id = (SELECT id_tipus FROM tipus WHERE nom = 'General');
    
CALL setReunions('2020/04/30', '2020/05/10', '22:00', 'Reunió de Personal 4', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'), 'D');
SELECT *
FROM reunions
WHERE (data BETWEEN '2020/04/30' AND '2020/05/10') AND hora = '22:00' 
	AND tipus_id = (SELECT id_tipus FROM tipus WHERE nom = 'Personal');
    
CALL setReunions('2020/04/30', '2020/06/10', '23:00', 'Reunió de Personal 5', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'), 'W');
SELECT *
FROM reunions
WHERE (data BETWEEN '2020/04/30' AND '2020/06/10') AND hora = '23:00' 
	AND tipus_id = (SELECT id_tipus FROM tipus WHERE nom = 'Personal');
        
