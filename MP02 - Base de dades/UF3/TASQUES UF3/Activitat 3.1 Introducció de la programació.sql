-- Activitat 3.1 Introducció de la programació

USE uf2_p2_pizzeria;

-- Tasca 1. Mostra quantes comandes es van fer l'11/01/2017. Fes servir una variable.

/*1er. Mostrem les comandes que hi ha*/
SELECT numero, data_hora
FROM comanda;

/*2on. Creem les variables necessaries*/
SET @data = '2017-01-11%';

/*3er. Mostrem el total de comandes*/
SELECT COUNT(*) as totalComandes
FROM comanda
WHERE data_hora LIKE @data;

-- Tasca 2. Mostra el nom del clients i un contador del registre alhora que es mostren els 
-- valors de la consulta ordenats per nom.

/*1er. Mostrem els clients*/
SELECT *
FROM client;

/*2on. Creem el contador*/
SET @contador = 0;

/*3er. Creem el bucle*/
SELECT nom, @contador := @contador + 1 AS contador
from client
ORDER BY nom;

-- Tasca 3. Enmagatzema la quantitat en euros que ha facturat l'empleat amb major facturació. 
-- Mostra posteriorment la dada enmagazemada a la variable amb el valor resultant.

/*1er. Mostrem el empleat amb la facturació més alta*/
SELECT em.nom, SUM(cp.quantitat * p.preu) as facturacio
FROM empleat em
	INNER JOIN comanda co on em.id_empleat = co.empleat_id
    INNER JOIN comanda_producte cp on co.numero = cp.numero
    INNER JOIN producte p on cp.id_producte = p.id_producte
GROUP BY em.nom; -- Observem que la Marta té la facturació més alta.
	
/*2on. Agrupem les dues instruccions, utilitzant una subconsulta*/
SELECT MAX(facturat.facturacio) INTO @facturacio
FROM empleat em
	INNER JOIN (
			SELECT em.nom, SUM(cp.quantitat * p.preu) as facturacio
			FROM empleat em
				INNER JOIN comanda co on em.id_empleat = co.empleat_id
				INNER JOIN comanda_producte cp on co.numero = cp.numero
				INNER JOIN producte p on cp.id_producte = p.id_producte
			GROUP BY em.nom) AS facturat on em.id_empleat = facturat.id_empleat;

-- Tasca 4. A partir d'una variable amb el valor d'increment de preus del 1%, aplica 
-- l'increment de preus a tots els postres
SET @increment = CAST(0.01 AS DECIMAL(4,2)); 
UPDATE producte
SET preu = preu + (preu * @increment)
WHERE id_producte IN (SELECT id_producte FROM postre po);

-- Tasca 5. Localitza el client que més ha comprat (valor total de les seves comandes). Enmagatzema el nom del client i el preu total de totes les seves comandes, posteriorment mostra les dades enmagazemades de les variables.
SELECT cl.nom, SUM(cp.quantitat * p.preu) AS facturacio INTO @client, @facturacio
FROM clients cl
	INNER JOIN comandes co on cl.id_client = co.client_id
	INNER JOIN comandes_productes cp ON co.numero = cp.numero
    INNER JOIN productes p ON cp.id_producte = p.id_producte
GROUP BY cl.id_client
ORDER BY facturacio DESC
LIMIT 1;

SELECT @client, @facturacio;

-- Tasca 6. Cerca que busqui totes les pizzes que tinguin com a ingredient BAC. Fes servir una variable per l'ingredient.
/*1er. Mostrem totes les pizzes BAC*/
SELECT *
FROM producte p
	INNER JOIN pizza pz ON p.id_producte = pz.id_producte
	INNER JOIN pizza_ingredient pzi ON pzi.id_producte = pz.id_producte;
/*2on. Creem una variable que contingui el ingredient a cercar*/
SET @ingredient = 'BAC';
/*3er. Agrupem les dues instruccions*/
SELECT DISTINCT p.nom
FROM producte p
	INNER JOIN pizza pz ON p.id_producte = pz.id_producte
	INNER JOIN pizza_ingredient pzi ON pz.id_producte	 = pzi.id_producte	
WHERE pzi.id_ingredient = @ingredient;


-- Tasca 7. Fent l'ús de variables, modifica el preu del producte 3 a 1.65 €
/*1er. Mostrem el producte 3*/
SELECT *
FROM producte
	WHERE id_producte = 3;
/*2on. Actualitzem la taula producte. Creem la variable*/
UPDATE producte
SET 
	preu = 1.65
WHERE
	id_producte = 3;
/*3er. Mostrem la taula actualitzada*/
SELECT *
FROM producte
	WHERE id_producte = 3;