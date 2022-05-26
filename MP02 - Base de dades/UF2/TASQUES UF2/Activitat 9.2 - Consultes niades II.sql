# DAM M02 UF2
# Activitat 9.2 - Consultes niades II

USE uf2_p2_pizzeria;

-- Tasca 1. Mostra la quantitat de pizzes, begudes i postres que tenim a la nostra carta.
SELECT (SELECT COUNT(*)
		FROM producte p 
			INNER JOIN pizza pz ON p.id_producte = pz.id_producte
	    ) AS pizzes,
        (SELECT COUNT(*)
		FROM producte p 
			INNER JOIN beguda be ON p.id_producte = be.id_producte
	    ) AS begudes,
        (SELECT COUNT(*)
		FROM producte p 
			INNER JOIN postre po ON p.id_producte = po.id_producte
	    ) AS postres;
        
        
-- Tasca 2. Mostra la quantitat de pizzes, begudes i postres que hem venut.
SELECT (SELECT SUM(cp.quantitat)
		FROM comanda_producte cp
			INNER JOIN pizza pz ON cp.id_producte = pz.id_producte
		) AS pizzes,
        (SELECT SUM(cp.quantitat)
		FROM comanda_producte cp
			INNER JOIN beguda be ON cp.id_producte = be.id_producte
		) AS begudes,
        (SELECT SUM(cp.quantitat)
		FROM comanda_producte cp
			INNER JOIN postre po ON cp.id_producte = po.id_producte
		) AS postres;

-- Tasca 3. Mostra el numero de comanda y el preu total de cada comanda.
# Pas 1: Mostrem el numero de cada comanda
SELECT c.numero
FROM comanda c
ORDER BY c.numero;
# Pas 2: Calculem l'import total d'una comanda qualsevol (10002)
SELECT SUM(p.preu * cp.quantitat) AS preu_total
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
WHERE cp.numero = 10008;
# Pas 3: Combinem les dues consultes
SELECT c.numero, (SELECT SUM(s_p.preu * s_cp.quantitat) 
				  FROM comanda_producte s_cp
						INNER JOIN producte s_p ON s_cp.id_producte = s_p.id_producte
				  WHERE s_cp.numero = c.numero) AS preu_total
FROM comanda c
ORDER BY c.numero;

-- Tasca 4. De les comandes que han demanat postres, mostra l'import total de la comanda.
# Pas 1: Mostrem les comandes que han demanat postres
SELECT DISTINCT c.numero
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
	INNER JOIN postre po ON cp.id_producte = po.id_producte
ORDER BY cp.numero; #Comandes 10000, 10002, 10005, 10008

# Pas 2: Calculem l'import total d'una comanda qualsevol (10002)
SELECT SUM(s_p.preu * s_cp.quantitat) AS preu_total
FROM comanda_producte s_cp
	INNER JOIN producte s_p ON s_cp.id_producte = s_p.id_producte
WHERE s_cp.numero = 10002;

# Pas 3: Combinem les dues consultes
SELECT DISTINCT c.numero, (SELECT SUM(s_p.preu * s_cp.quantitat) 
						   FROM comanda_producte s_cp
								INNER JOIN producte s_p ON s_cp.id_producte = s_p.id_producte
						   WHERE s_cp.numero = c.numero) AS preu_total
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
	INNER JOIN postre po ON cp.id_producte = po.id_producte
ORDER BY cp.numero;

-- Tasca 5. Mostra quants productes hi ha a cada comanda.
# Pas 1: Mostrem totes les comandes
SELECT c.numero
FROM comanda c
ORDER BY c.numero;
# Pas 2: Mostrem la quantitat de productes d'una comanda (10004)
SELECT SUM(cp.quantitat) AS quantitat_productes
FROM comanda_producte cp
WHERE cp.numero = 10004;

# Pas 3: Combinem les dues comandes.
SELECT c.numero, (SELECT SUM(cp.quantitat) 
				  FROM comanda_producte cp
				  WHERE cp.numero = c.numero) AS quantitat_productes
FROM comanda c
ORDER BY c.numero;

-- Tasca 6. Dels clients que han demanat alguna vegada comandes al local, mostra el número i la
-- data de totes les comandes que han fet aquests clients.
# Pas 1: Mostrem els clients que han demanat al local
SELECT c.client_id
FROM comanda c
WHERE domicili_local LIKE 'L'; # Surten 1, 6

# Pas 2: Mostrem les comandes d'aquests clients.
SELECT c.numero numero_comanda, DATE(c.data_hora) data
FROM comanda c
WHERE client_id IN (1, 6)
ORDER BY c.data_hora;

# Pas 3: Agrupem les dues instruccions
SELECT c.numero numero_comanda, DATE(c.data_hora) data
FROM comanda c
WHERE client_id IN (SELECT c.client_id
					FROM comanda c
					WHERE domicili_local LIKE 'L')
ORDER BY c.data_hora;

-- Tasca 7. Mostra quants ingredients té cada pizza
# Pas 1: Mostrem totes les pizzes
SELECT p.id_producte, p.nom
FROM producte p
	 INNER JOIN pizza pz ON p.id_producte = pz.id_producte;
     
# Pas 2: Mostrem quants ingredients té una pizza (id = 6, Pizza Barbacoa)
SELECT COUNT(id_ingredient)
FROM pizza pz
	INNER JOIN pizza_ingredient pzig ON pz.id_producte = pzig.id_producte
WHERE pz.id_producte = 9;

# Pas 3: Agrupem les dues instruccions
SELECT p.id_producte, p.nom, (SELECT COUNT(id_ingredient)
							  FROM pizza pz
								   INNER JOIN pizza_ingredient pzig ON pz.id_producte = pzig.id_producte
							  WHERE pz.id_producte = p.id_producte) AS quantitat_ingredients
FROM producte p
	 INNER JOIN pizza pz ON p.id_producte = pz.id_producte;
     
-- Tasca 8. Mostra quantes pizzes barbacoa ha demanat cada client.
#Pas 1: Mirem quants clients hi ha
SELECT cl.id_client, cl.nom
FROM client cl;

# Pas 2: Mirem quantes pizzes barbacoa ha demanat un client (p.e, Josep Vila id = 1)
SELECT cl.nom, cp.quantitat, p.nom
FROM client cl
	INNER JOIN comanda c ON cl.id_client = c.client_id
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN pizza pz on p.id_producte = pz.id_producte
WHERE cl.id_client = 1 AND p.nom LIKE '%Barbacoa'; 
#Observem que en Josep Vila ha fet 2 comandes demanant 2 i 1 pizzes Pizza Barbacoa respectivament
SELECT SUM(cp.quantitat) AS quantitat_PizzaBarbacoa
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN pizza pz on p.id_producte = pz.id_producte
WHERE c.client_id = 1 AND p.nom LIKE '%Barbacoa'; 

# Pas 3: Agrupem les dues instruccions
SELECT cl.id_client, cl.nom, (SELECT SUM(cp.quantitat) 
							  FROM comanda c
								INNER JOIN comanda_producte cp ON c.numero = cp.numero
								INNER JOIN producte p ON cp.id_producte = p.id_producte
								INNER JOIN pizza pz on p.id_producte = pz.id_producte
							 WHERE c.client_id = cl.id_client AND p.nom LIKE '%Barbacoa') AS quantitat_PizzaBarbacoa
FROM client cl; 

-- Tasca 9. Dels clients que han demanat la pizza al local, mostra quants productes diferents han demanat. 

INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) 
	VALUE (10010, '20220109204500', 'L', 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10010, 6, 4);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10010, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10010, 8, 3);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10010, 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10010, 2, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10010, 12, 2);

INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) 
	VALUE (10011, '20220109214500', 'L', 2, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10011, 6, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10011, 9, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10011, 8, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10011, 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10011, 12, 2);
-- Tasca 10. Mostra la quantitat de begudes i de pizzes de la comanda 10005.
# Pas 1: Mostrem la comanda 10005
SELECT numero, data_hora, domicili_local, client_id, empleat_id
FROM comanda c
WHERE c.numero = 10005;

# Pas 2: 
	# a) Mostrem les pizzes de la comanda 10005.
SELECT SUM(quantitat)
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN pizza pz ON cp.id_producte = pz.id_producte
WHERE cp.numero = 10005;
	# b) Mostrem les begudes de la comanda 10005.
SELECT SUM(quantitat)
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN beguda be ON cp.id_producte = be.id_producte
WHERE cp.numero = 10005;

# Pas 3: Combinem les dues instruccions
SELECT *, (SELECT SUM(quantitat)
		   FROM comanda c
				INNER JOIN comanda_producte cp ON c.numero = cp.numero
				INNER JOIN pizza pz ON cp.id_producte = pz.id_producte
		   WHERE cp.numero = 10005) AS quantitat_pizza, 
           (SELECT SUM(quantitat)
			FROM comanda c
				INNER JOIN comanda_producte cp ON c.numero = cp.numero
				INNER JOIN beguda be ON cp.id_producte = be.id_producte
			WHERE cp.numero = 10005) AS quantitat_beguda
FROM comanda c
WHERE c.numero = 10005;

-- Tasca 11. Mostra els clients que han facturat més de 50€.

# Pas 1: Mostrem la llista de clients
SELECT *
FROM client cl;

# Pas 2: Mostrem quant a facturat un client (p.e. Josep Vila id = 1)
SELECT SUM(quantitat * preu)
FROM client cl
	INNER JOIN comanda c ON cl.id_client = c.client_id
    INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
WHERE c.client_id = 1;

# Pas 3: Combinem les dues instruccions
SELECT nom, (SELECT SUM(cp.quantitat * p.preu) AS facturacio
			 FROM comanda co 
				INNER JOIN comanda_producte cp ON co.numero = cp.numero
				INNER JOIN producte p ON cp.id_producte = p.id_producte
			 WHERE co.client_id = cl.id_client) AS facturacio
FROM client AS cl
WHERE (SELECT SUM(cp.quantitat * p.preu) AS facturacio
	   FROM comanda co 
			INNER JOIN comanda_producte cp ON co.numero = cp.numero
			INNER JOIN producte p ON cp.id_producte = p.id_producte
	   WHERE co.client_id = cl.id_client) > 50;

-- Tasca 12. Mostra les vegades que utilitzem cada ingredient.
# Pas 1: Mostrem tots els ingredients
SELECT *
FROM ingredient;

# Pas 2: Mostrem les vegades que fem servir un ingredient (p.e. el Bacon id = BAC)
SELECT COUNT(id_ingredient) AS ingredients_vegades_utilitzats
FROM pizza_ingredient pzig
WHERE id_ingredient LIKE 'BAC';

# Pas 3: Combinem les dues instruccions
SELECT nom, (SELECT COUNT(id_ingredient) 
			 FROM pizza_ingredient pzig
			 WHERE ig.id_ingredient = pzig.id_ingredient) AS ingredients_vegades_utilitzats
FROM ingredient ig;

-- Tasca 13. Mostra les vegades totals que hem utilitzat cada ingredient (tingueu en compte que si hem demanat dues pizzes, hem de comptar els ingredients dues vegades)
# Pas 1: Mostrem tots els ingredients
SELECT ig.nom
FROM ingredient ig;

# Pas 2: Mostrem les vegades que fem servir un ingredient (p.e. el Bacon id = BAC)
SELECT SUM(quantitat)
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
	INNER JOIN pizza pz ON p.id_producte = pz.id_producte
    INNER JOIN pizza_ingredient pzig ON pzig.id_producte = pz.id_producte
WHERE pzig.id_ingredient = 'BAC';

# Pas 3: Combinem les dues instruccions
SELECT ig.nom, (SELECT SUM(quantitat)
				FROM comanda_producte cp
					INNER JOIN producte p ON cp.id_producte = p.id_producte
					INNER JOIN pizza pz ON p.id_producte = pz.id_producte
					INNER JOIN pizza_ingredient pzig ON pzig.id_producte = pz.id_producte
				WHERE pzig.id_ingredient = ig.id_ingredient) AS quantita_Producte
FROM ingredient ig;

-- Tasca 14. Mostra l'import que hem facturat de cada beguda.
# Pas 1: Mostrem la llista de begudes
SELECT p.nom, p.id_producte
FROM beguda be
	INNER JOIN producte p ON p.id_producte = be.id_producte;
    
# Pas 2: Mostrem quant hem facturat en una veguda (p.e. Ampolla Coca-Cola id = 1)
SELECT SUM(cp.quantitat * p.preu) AS facturacio
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN beguda be ON p.id_producte = be.id_producte
WHERE cp.id_producte = 1;

# Pas 3: Combinem les dues instruccions
SELECT p.nom, (SELECT IFNULL(SUM(cp.quantitat * s_p.preu), 0) as facturat
			   FROM comanda_producte cp
					INNER JOIN producte s_p ON cp.id_producte = s_p.id_producte
					INNER JOIN beguda s_be ON s_p.id_producte = s_be.id_producte
			   WHERE cp.id_producte = be.id_producte) as facturat
FROM producte p
	INNER JOIN beguda be ON p.id_producte = be.id_producte;