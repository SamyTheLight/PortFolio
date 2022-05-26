# Activitat 9.1 - Consultes niades

USE uf2_p2_pizzeria;

-- Tasca 1. Mostra els ingredient de les pizza de la darrera comanda que s'ha demanat.
/*1er. Mostrem la darrera comanda.*/
SELECT MAX(numero)
FROM comanda;
# Dóna la comanda 10009

/*2on. Mostrem els ingredient de la comanda 10009.*/
SELECT DISTINCT ig.nom
FROM comanda_producte cp 
	INNER JOIN pizza pz ON cp.id_producte = pz.id_producte
	INNER JOIN pizza_ingredient pi ON pz.id_producte = pi.id_producte
	INNER JOIN ingredient ig ON pi.id_ingredient = ig.id_ingredient
WHERE cp.numero = 10009;

/*3er. Agrupem les dues instruccions*/
SELECT DISTINCT ig.nom
FROM comanda_producte cp 
	INNER JOIN pizza pz ON cp.id_producte = pz.id_producte
	INNER JOIN pizza_ingredient pi ON pz.id_producte = pi.id_producte
	INNER JOIN ingredient ig ON pi.id_ingredient = ig.id_ingredient
WHERE cp.numero = (SELECT MAX(numero)
					FROM comanda);	
	
 -- Tasca 2. Dels clients que han demanat alguna vegada comanda al local, mostra el número i la data  de totes les comanda que han fet aquests clients.
 
/*1er. Mostrem clients que han demanat a local*/
SELECT cl.id_client, cl.nom
FROM client cl
	INNER JOIN comanda c ON c.client_id = cl.id_client
WHERE c.domicili_local = 'L'; 

/*2on. Mostrem el numero i data de totes les comandes que han fet el Josep i el Guillem (id = 1, 6 respectivament)*/
SELECT numero, data_hora
FROM comanda
WHERE client_id IN (1, 6); /*WHERE client_id = 1 OR client_id = 6*/

/*3er. Agrupem les dues instruccions*/
SELECT numero, data_hora
FROM comanda 
WHERE client_id IN (SELECT client_id
					FROM comanda c
                    WHERE c.domicili_local = 'L');

-- Tasca 3. De les comanda que han demanat cervesa, mostra les pizza que han demanat.

/*1er. Mostrem comandes que han demanat cervesa*/
SELECT numero
FROM comanda_producte cp
    INNER JOIN producte p ON cp.id_producte = p.id_producte
WHERE p.nom LIKE '%cervesa%'; #comandes 10002, 10003, 10005 i 10008.

/*2on. Mostrem les pizzes d'aquestes comandes*/	
SELECT p.nom
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN pizza pz ON p.id_producte = pz.id_producte
WHERE cp.numero IN (10002, 10003, 10005, 10008);

/*3er. Agrupem les dues instruccions*/
SELECT p.nom
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN pizza pz ON p.id_producte = pz.id_producte
WHERE cp.numero IN (SELECT numero
					FROM comanda_producte cp
						INNER JOIN producte p ON cp.id_producte = p.id_producte
					WHERE p.nom LIKE '%cervesa%');


-- Tasca 4. Dels clients que han demanat la pizza Pizza Barbacoa mostra totes les begudes que han demanat.
/*1er. Mostrem clients que han demanat pizza Pizza Barbacoa.*/
SELECT DISTINCT cl.nom, cl.id_client
FROM client cl
	INNER JOIN comanda c ON cl.id_client = c.client_id
    INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
WHERE p.nom LIKE 'Pizza Barbacoa'; #surten id_client = 1, 2, 7.

/*2on. Mostrem les begudes que han demanat aquests clients*/
SELECT DISTINCT p.nom
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN beguda be ON p.id_producte = be.id_producte
WHERE client_id IN (1, 2, 7);

/*3er. Agrupem les dues instruccions*/
SELECT DISTINCT p.nom
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN beguda be ON p.id_producte = be.id_producte
WHERE client_id IN (SELECT DISTINCT cl.id_client
					FROM client cl
						INNER JOIN comanda c ON cl.id_client = c.client_id
						INNER JOIN comanda_producte cp ON c.numero = cp.numero
						INNER JOIN producte p ON cp.id_producte = p.id_producte
					WHERE p.nom LIKE 'Pizza Barbacoa');
                    
-- Tasca 5. Mostra els ingredient de les pizzes que tenen Pernil york.
/*1er. Mostrem les pizzes que tenen pernil york*/
SELECT pz.id_producte
FROM pizza pz
	INNER JOIN 	pizza_ingredient pzig ON pz.id_producte = pzig.id_producte
WHERE pzig.id_ingredient LIKE 'PER'; #Surten les pizzes amb id = 8 i 11

/*2on. Mostrem els ingredients d'aquestes 2 pizzes*/
SELECT DISTINCT ig.nom
FROM pizza_ingredient pzig
	INNER JOIN ingredient ig ON pzig.id_ingredient = ig.id_ingredient
WHERE id_producte IN (8, 11);     

/*3er. Agrupem les dues instruccions*/  
SELECT DISTINCT ig.nom
FROM pizza_ingredient pzig
	INNER JOIN ingredient ig ON pzig.id_ingredient = ig.id_ingredient
WHERE id_producte IN (SELECT pz.id_producte
					  FROM pizza pz
						INNER JOIN 	pizza_ingredient pzig ON pz.id_producte = pzig.id_producte
					  WHERE pzig.id_ingredient LIKE 'PER');
                      
-- Tasca 6. De les comanda que han demanat Coca-Cola, mostra totes les begudes
/*1er. Mostrem les comandes que han demanat Coca-cola*/
SELECT c.numero AS numero_comanda
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p  ON cp.id_producte = p.id_producte
WHERE p.nom LIKE '%Coca-cola'; #surten les comandes 10000, 10002, 10004, 10005, 10007

/*2on. Mostrem totes les begudes d'aquestes 5 comandes*/
SELECT DISTINCT p.nom
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN beguda be ON p.id_producte = be.id_producte
WHERE Cp.numero IN (10000, 10002, 10004, 10005, 10007);

/*3er. Agrupem les dues instruccions*/ 
SELECT DISTINCT p.nom
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN beguda be ON p.id_producte = be.id_producte
WHERE Cp.numero IN (SELECT c.numero AS numero_comanda
					FROM comanda c
						INNER JOIN comanda_producte cp ON c.numero = cp.numero
						INNER JOIN producte p  ON cp.id_producte = p.id_producte
					WHERE p.nom LIKE '%Coca-cola');

-- Tasca 7. Mostra el nom del producte que s'ha demanat més vegades en una comanda.
/*1. Mostrem el producte que s'ha demanat més vegades*/
SELECT MAX(quantitat), p.nom
FROM comanda c
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p ON cp.id_producte = p.id_producte; 
#Ens diu que el producte mes demanat es Ampolla Coca-cola i s'ha demanat 6 vegades.   