-- Activitat 9.1 - Procediments amb cursors

USE uf2_p2_pizzeria;

-- Tasca 1.
-- Afegeix una columna nova la taula clients que s’anomenti num_comandes. Aquest nou camp contindrà 
-- la quantitat de comandes diferents que ha realitzat aquell client.

-- Crea un procediment emmagatzemat que, sense rebre cap paràmetre, ompli la columna num_comandes amb 
-- el nombre de comandes que ha fet cada client.

ALTER TABLE client ADD COLUMN (num_comandes INT DEFAULT 0); /*Afegim la columna num_comandes*/

DELIMITER //
CREATE OR REPLACE PROCEDURE doNumComandesClient()
BEGIN
	DECLARE done INT DEFAULT FALSE; /*Per finalitzar la instrucció*/
    DECLARE var_client_id, var_total_comandes INT; /*Declarem les variables per a client_id i AFEGIM la columna total_comandes*/
    DECLARE cursor_comandes CURSOR FOR SELECT client_id, COUNT(*) FROM comanda GROUP BY client_id; /*Declarem el cursor on li pasarem el parametres del id del client i del total de comandes ordenats pel id del client*/
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cursor_comandes; /*obrim el cursor*/
    read_loop: LOOP /*Creem el bucle loop per, en aquest cas, omplir la columna num_comandes amb el nombre de comandes que ha fet cada client*/
		FETCH FROM cursor_comandes INTO var_client_id, var_total_comandes;/*Anem omplint les variables del cursor (linia 18)*/
        
        IF done THEN
			LEAVE read_loop; /*Si ha acabat d'omplir, sortim del bucle LOOP*/
		END IF;
        /*omplim la columna num_comandes amb el nombre de comandes que ha fet cada client*/
		UPDATE client
		SET num_comandes = var_total_comandes
		WHERE id_client = var_client_id;
	END LOOP;
	CLOSE cursor_comandes;
END; //
DELIMITER ;

SELECT * FROM client;
CALL doNumComandesClient();
SELECT * FROM client;

-- Tasca 2.
-- Afegeix una columna nova a la taula empleats que s’anomeni facturacio. Contindrà la 
-- facturació total que ha fet aquell empleat, excloent-hi l'IVA. Per a aquesta activitat, 
-- suposarem que tots els preus dels productes són amb IVA inclòs.

-- Crea un procediment emmagatzemat que, rebent per paràmetre un enter que representa el 
-- % d'IVA (per exemple, 10), ompli la columna de quantitat de facturació total de l'empleat 
-- sense comptar l'IVA.

ALTER TABLE empleat ADD COLUMN IF NOT EXISTS facturacio DECIMAL(8,2) DEFAULT 0;

DELIMITER //
CREATE OR REPLACE PROCEDURE addFacturacioEmpleat (IN pIVA INT)
BEGIN 
	DECLARE done INT DEFAULT FALSE;
	DECLARE var_empleat_id, var_facturacio DECIMAL(8,2);
	DECLARE cursor_comandes CURSOR FOR SELECT empleat_id, SUM(cp.quantitat * p.preu) AS facturacio
														  FROM comanda co
															INNER JOIN comanda_producte cp ON co.numero = cp.numero
															INNER JOIN producte p ON cp.id_producte = p.id_producte
														  GROUP BY empleat_id
													      ORDER BY facturacio DESC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	OPEN cursor_comandes;
    read_loop: LOOP
		FETCH FROM cursor_comandes INTO var_empleat_id, var_facturacio;
        IF done THEN
			LEAVE read_loop;
		END IF;
        /*Calculem la facturacio incloent l'IVA (10% IVA)*/
        UPDATE empleat
        SET facturacio = var_facturacio / (1+(pIva/100))
        WHERE id_empleat = var_empleat_id;
	END LOOP;
    CLOSE cursor_comandes;
END; //
DELIMITER ;

SELECT * FROM empleat;
CALL addFacturacioEmpleat(10);
SELECT * FROM empleat;

SELECT co.empleat_id, SUM(cp.quantitat * p.preu) AS facturacio
FROM comanda co
	INNER JOIN comanda_producte cp ON co.numero = cp.numero
	INNER JOIN producte p ON cp.id_producte = p.id_producte
GROUP BY empleat_id
ORDER BY facturacio DESC;

-- Tasca 3.
-- Crea un procediment anomenat duplicaProductesByTipus. El procediment rebrà per 
-- paràmetre el tipus de productes a duplicar (‘B’ per a les begudes, ‘D’ pels postres 
-- i ‘P’ per a les pizzes).

-- El procediment duplicarà a la taula o taules corresponents tots els productes d'aquell tipus, 
-- afegint al final del nom del producte s'hi afegirà el text "(còpia)". Per exemple, si estem 
-- duplicant les begudes i tenim una 'Ampolla Coca-Cola' es crearà un nou producte anomenat 
-- 'Ampolla Coca-Cola (còpia)’.

DELIMITER //
CREATE OR REPLACE PROCEDURE duplicaProductesByTipus(IN pOpcio ENUM('B','D', 'P'))
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE var_id_producte SMALLINT(6);
  DECLARE var_capacitat SMALLINT(3);
  DECLARE var_preu DECIMAL(4,2);
  DECLARE var_nom VARCHAR(50);
  DECLARE var_alcoholica ENUM('N','S');
  
  DECLARE cur_begudes CURSOR FOR SELECT p.nom, p.preu, be.capacitat, be.alcoholica
									FROM producte p
										INNER JOIN beguda be ON p.id_producte = be.id_producte;
  DECLARE cur_pizzes CURSOR FOR SELECT p.nom, p.preu
									FROM producte p
										INNER JOIN pizza pz ON p.id_producte = pz.id_producte;
  DECLARE cur_postres CURSOR FOR SELECT p.nom, p.preu
									FROM producte p
										INNER JOIN postre po ON p.id_producte = po.id_producte;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur_begudes;
  OPEN cur_pizzes;
  OPEN cur_postres;

  read_loop: LOOP
    CASE pOpcio
		WHEN 'B' THEN
			FETCH cur_begudes INTO var_nom, var_preu, var_capacitat, var_alcoholica;
		WHEN 'D' THEN
			FETCH cur_postres INTO var_nom, var_preu;
		WHEN 'P' THEN
			FETCH cur_pizzes INTO var_nom, var_preu;
    END CASE;
    
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    SET var_nom = CONCAT(var_nom, ' (còpia)');
    INSERT INTO producte (nom, preu) VALUES (var_nom, var_preu);
    SET var_id_producte = LAST_INSERT_ID();
    
    CASE pOpcio
    WHEN 'B' THEN
        INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUES (var_id_producte, var_capacitat, var_alcoholica);
    WHEN 'D' THEN
        INSERT INTO postre (id_producte) VALUES (var_id_producte);
    WHEN 'P' THEN
        INSERT INTO pizza (id_producte) VALUES (var_id_producte);
    END CASE;
  END LOOP;

  CLOSE cur_begudes;
  CLOSE cur_pizzes;
  CLOSE cur_postres;
END; //
DELIMITER ;

SELECT * FROM producte;
SELECT * FROM pizza;
CALL duplicaProductesByTipus('P');
SELECT * FROM producte;
SELECT * FROM pizza;