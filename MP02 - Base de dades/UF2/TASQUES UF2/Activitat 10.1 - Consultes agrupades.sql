# DAM M02 UF2
# Activitat 10.1 - Consultes agrupades 

USE uf2_p2_pizzeria;

-- Tasca 1. Mostra les vegades que utilitzem cada ingredient.
SELECT ig.nom, pi.id_ingredient, COUNT(*) AS total_ingredients
FROM pizza_ingredient pi
	INNER JOIN ingredient ig ON pi.id_ingredient = ig.id_ingredient
GROUP BY pi.id_producte;

-- Tasca 2. Mostra els ingredient que utilitzem més de 2 vegades.
SELECT ig.nom, COUNT(*) vegades
FROM  pizza_ingredient pi
	INNER JOIN ingredient ig ON pi.id_ingredient = ig.id_ingredient
GROUP BY pi.id_ingredient
HAVING COUNT(*) > 2;

-- Tasca 3. Mostra el numero de comanda y el preu total de cada comanda.
SELECT cp.numero, SUM(cp.quantitat * p.preu) total
FROM comanda_producte cp
    INNER JOIN producte p ON cp.id_producte = p.id_producte
GROUP BY cp.numero;

-- Tasca 4. Mostra quants producte hi ha a cada comanda.
SELECT numero, SUM(quantitat)
FROM comanda_producte
GROUP BY numero;

-- Tasca 5 Mostra els client que han facturat més de 50€.
SELECT cl.nom, SUM(cp.quantitat * p.preu) facturacio
FROM client cl
	INNER JOIN comanda co ON cl.id_client = co.client_id
    INNER JOIN comanda_producte cp ON co.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
GROUP BY cl.id_client
HAVING facturacio > 50;

-- Tasca 6. Mostra quant ha facturat cada empleat.
SELECT CONCAT(em.nom, ' ', em.cognoms) AS nom_cognoms, SUM(cp.quantitat * p.preu) AS facturacio
FROM empleat em
	INNER JOIN comanda co ON em.id_empleat = co.empleat_id
    INNER JOIN comanda_producte cp ON co.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
GROUP BY em.id_empleat;

-- Tasca 7.  Mostra els empleats que han facturat més de 200€.

SELECT em.nom, SUM(cp.quantitat * p.preu) facturacio
FROM empleat em
	INNER JOIN comanda co ON em.id_empleat = co.empleat_id
    INNER JOIN comanda_producte cp ON co.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
GROUP BY em.id_empleat
HAVING facturacio > 200;

-- Tasca 8. Mostra la quantitat de postre que han demanat cadascun dels client Josep Vila i Guillem Jam.
SELECT cl.nom, SUM(cp.quantitat) quantitat_postre
FROM client cl
	INNER JOIN comanda co ON cl.id_client = co.client_id
    INNER JOIN comanda_producte cp ON co.numero = cp.numero
    INNER JOIN postre po ON cp.id_producte = po.id_producte
WHERE cl.nom IN ('Josep Vila','Guillem Jam')
GROUP BY cl.nom;

-- Tasca 9. Mostra les comanda amb un import superior a 40€ en pizza, ordenat per l’import de mayor a menor i per numero de comanda.
SELECT cp.numero, SUM(cp.quantitat * p.preu) as import
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN pizza pz ON p.id_producte = pz.id_producte
GROUP BY cp.numero
HAVING import > 40 
ORDER BY import DESC;