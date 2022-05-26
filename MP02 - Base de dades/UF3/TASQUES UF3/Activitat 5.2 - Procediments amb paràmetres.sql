# Activitat 5.2 - Procediments amb paràmetres

use uf2_p2_pizzeria;

-- Tasca 1. Actualitza el preu de tots els productes amb un increment % segons li pasem com a paràmetre. 
-- A continuació crida també al procediment de l’Activitat 5.1 Primers procediments (Tasca 3).
DELIMITER //
CREATE PROCEDURE incrementPreuAll(IN increment DECIMAL(5,3))
BEGIN
	UPDATE producte p
    SET preu = preu + TRUNCATE((preu * increment), 2);
END //
DELIMITER ;
CALL incrementPreuAll(0.015);
CALL buscaPreuNom();

-- Tasca 2. Crea un procediment per afegir ingredients pasant com a parametre tots els valors que permet 
-- la taula. Afegeix un parell de proves.
DELIMITER //
CREATE PROCEDURE addIngredient(IN pId_ingredient VARCHAR(3), IN pNom VARCHAR(20))
BEGIN
	INSERT INTO ingredient (id_ingredient, nom) VALUES (pId_ingredient, pNom);
END //
DELIMITER ;

CALL addIngredient('CHE', 'Tomàquet cherry');
CALL addIngredient('ALB', 'Albahaca');

DROP PROCEDURE IF EXISTS addIngredient;

SELECT id_ingredient, nom FROM ingredient;

-- Tasca 3. Crea una procediment per afegir postres. Afegeix un parell de proves i comprova que s’han inserit 
-- correctament.
DELIMITER //
CREATE PROCEDURE addPostreId(IN pId_producte SMALLINT(6), IN pNom VARCHAR(50), IN pPreu DECIMAL(4,2))
BEGIN
		DECLARE id_producte SMALLINT(6);
		INSERT INTO producte (nom, preu) VALUES (pNom, pPreu);
	SET id_producte = LAST_INSERT_ID();
    INSERT INTO postre (id_producte) VALUES (id_producte);
END // 
DELIMITER ;	

CALL addPostreId(15, 'Gelat Pirulo', 2.50);
CALL addPostreId(16, 'Iogurt', 0.65);

SELECT id_producte, nom, preu FROM producte WHERE id_producte IN (15, 16);
SELECT id_producte FROM postre WHERE id_producte IN (15, 16);

CALL addPostre('Brownie', 3.50);
CALL addPostre('Brownie amb gelat', 4.50);

SELECT p.id_producte AS producte, po.id_producte AS postre, p.nom, p.preu
FROM producte p
	INNER JOIN postre po ON p.id_producte = po.id_producte;
    
-- Tasca 4. Permet eliminar un postre a partir de la seva clau primaria. 
-- Elimina els postres creats a la Tasca 3.
DELIMITER //
CREATE PROCEDURE eliminaPostre(IN dId_producte SMALLINT(6))
BEGIN
    DELETE FROM postre WHERE id_producte = pId_producte;
    DELETE FROM producte WHERE id_producte = pId_producte;
END //
DELIMITER ;

CALL eliminaPostre(15);
CALL eliminaPostre(16);

SELECT id_producte, nom, preu FROM producte;
SELECT id_producte FROM postre;

-- Tasca 5. Cerca que mostri el nom de totes les pizzes que tinguin com a ingredient BAC passat com a paràmetre al procediment.
DELIMITER //
CREATE OR REPLACE PROCEDURE showAllPizzesByIngredient(IN pId_ingredient VARCHAR(3))
BEGIN
	SELECT DISTINCT p.nom
	FROM producte p
		INNER JOIN pizza pz ON p.id_producte              = pz.id_producte
		INNER JOIN pizza_ingredient pzi ON pz.id_producte = pzi.id_producte	
	WHERE pzi.id_ingredient = pId_ingredient;
END //
DELIMITER ;

CALL showAllPizzesByIngredient('BAC');

-- Tasca 6. Retorna en un paràmetre la quantitat en euros que ha facturat l'empleat amb major facturació. Facturacio = quantitat * preu
DELIMITER //
CREATE OR REPLACE PROCEDURE getMajorFacturacioEmpleat(OUT facturacio DECIMAL(5,2))
BEGIN
	SET facturacio = (
		SELECT SUM(cp.quantitat * p.preu)
		FROM empleat em
			INNER JOIN comanda co on em.id_empleat = co.empleat_id
			INNER JOIN comanda_producte cp ON co.numero = cp.numero
			INNER JOIN producte p ON cp.id_producte = p.id_producte
		GROUP BY em.id_empleat
		ORDER BY facturacio DESC
		LIMIT 1);
END //
DELIMITER ;
CALL getMajorFacturacioEmpleat;
SELECT @facturacio;

-- Tasca 7. Retorna en un paràmetre la quantitat de productes diferents d’una comanda que li pasem com a parametre.
DELIMITER //
CREATE OR REPLACE PROCEDURE getQuantitatProducteDiferentsByComanda(IN pNumero SMALLINT(6), OUT pQuantitatProductes SMALLINT)
BEGIN
	SELECT COUNT(*) INTO pQuantitatProductes
	FROM comanda_producte cp 
	WHERE cp.numero = pNumero;
END //
DELIMITER ;

SET @comanda = 10000;
CALL getQuantitatProducteDiferentsByComanda(@comanda, @quantitat);
SELECT @quantitat;

-- Tasca 8. Amb l’ús de SELECT..INTO, retorna per paràmetre, la quantitat de productes que han demanat a totes les comandes d’un producte que també li pasem al propi procediment.
DELIMITER //
CREATE PROCEDURE getQuantitatProducteComandesByProducte(IN pId_producte SMALLINT(6), OUT pQuantitat SMALLINT)
BEGIN
	SELECT SUM(cp.quantitat) INTO pQuantitat
	FROM comandes_productes cp 
	WHERE cp.id_producte = pId_producte;
END //
DELIMITER ;

SET @id_producte = 12;
CALL getQuantitatProducteComandesByProducte(@id_producte, @quantitat);
SELECT @quantitat;

-- Tasca 9. Retorna per paràmetres la quantitat de pizzes, begudes i postres que hem venut individualment.
DELIMITER //
CREATE PROCEDURE getQuantitatProductesVenuts(OUT pQuantitatPizzes SMALLINT, OUT pQuantitatBegudes SMALLINT, OUT pQuantitatPostres SMALLINT)
BEGIN
	SELECT  SUM(IF(pz.id_producte IS NOT NULL, quantitat, 0)),
			SUM(IF(be.id_producte IS NOT NULL, quantitat, 0)),
			SUM(IF(po.id_producte IS NOT NULL, quantitat, 0)) 
            INTO pQuantitatPizzes, pQuantitatBegudes, pQuantitatPostres
	FROM comandes_productes cp
		LEFT JOIN productes p ON cp.id_producte = p.id_producte
		LEFT JOIN pizzes pz ON p.id_producte = pz.id_producte
		LEFT JOIN begudes be ON p.id_producte = be.id_producte	
		LEFT JOIN postres po ON p.id_producte = po.id_producte;
END //
DELIMITER ;

CALL getQuantitatProductesVenuts(@quantitatPizzes, @quantitatBegudes, @quantitatPostres);
SELECT @quantitatPizzes, @quantitatBegudes, @quantitatPostres;