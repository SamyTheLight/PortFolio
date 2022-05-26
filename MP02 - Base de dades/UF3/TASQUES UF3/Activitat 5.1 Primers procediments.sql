# Activitat 5.1 Primers procediments

use uf2_p2_pizzeria;

-- Tasca 1. Mostra tots els valors de la taula clients.
DELIMITER //
CREATE PROCEDURE buscaClients()
BEGIN
	SELECT *
	FROM client;
END //
DELIMITER ;

CALL buscaClients();
DROP PROCEDURE IF EXISTS buscaClients;

-- Tasca 2. Mostra la quantitat total entre postres i begudes que tenim.
DELIMITER //
CREATE PROCEDURE buscaQuantProdBeg()
BEGIN
	SELECT COUNT(*) AS quantitatPostresBegudes
	FROM producte p
		LEFT JOIN beguda be ON p.id_producte = be.id_producte	
		LEFT JOIN postre po ON p.id_producte = po.id_producte;
END //
DELIMITER ;

CALL buscaQuantProdBeg();
DROP PROCEDURE IF EXISTS buscaQuantProdBeg;

-- Tasca 3.Mostra el preu i nom de tots els productes.
DELIMITER //
CREATE PROCEDURE buscaPreuNom()
BEGIN
	SELECT nom, preu
	FROM producte;
END //
DELIMITER ;

CALL buscaPreuNom();
DROP PROCEDURE IF EXISTS buscaPreuNom;

-- Tasca 4.Actualitza el preu de tots els productes amb un increment del 1,5%. A continuació crida també al procediment de la Tasca 3.
DELIMITER //
CREATE PROCEDURE incrementPreu()
BEGIN
	DECLARE	increment DECIMAL(5,3) DEFAULT 0.015;		
    
	UPDATE producte p
	SET preu = preu + TRUNCATE((preu * increment), 2);
END //
DELIMITER ;

CALL incrementPreu();
CALL buscaPreuNom();
DROP PROCEDURE IF EXISTS incrementPreu;

-- Tasca 5. Elimina el procediment de la Tasca 2.
DROP PROCEDURE IF EXISTS buscaQuantProdBeg;

-- Tasca 6. Mostra la informació d’execució del procediment de la Tasca 3.
SHOW CREATE PROCEDURE buscaPreuNom;

-- Tasca 7. Mostra sense usar un procediment tots els procediments generats a la taula del sistema de mysql.
SELECT *
FROM mysql.proc
WHERE db = 'uf2_p2_pizzeria';