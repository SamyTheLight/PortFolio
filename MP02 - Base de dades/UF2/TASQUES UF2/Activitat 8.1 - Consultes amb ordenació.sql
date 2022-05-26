#Activitat 8.1 Consultes amb ordenació

USE uf2_p2_pizzeria;

-- TASCA 1.
	# Mostra el nom del client, adreça i població ordenats per població.
SELECT cl.nom, cl.adreca, cl.poblacio
	FROM client as cl
    ORDER BY poblacio;
-- TASCA 2.
	# Mostra les dades dels empleats ordenats per cognom i nom.
SELECT em.id_empleat, em.nom, em.cognoms
	FROM empleat as em
    ORDER BY nom, cognoms;
-- TASCA 3.
	# Mostra el nom i preu dels productes, ordenats de mayor a menor en preu.
SELECT  pr.nom, pr.preu
	FROM producte as pr
    ORDER BY preu DESC;
-- TASCA 4.
	# Mostra les begudes i el preu d'aquestes, ordenats de mayor a menor preu i despres pel nom.
SELECT pr.nom, pr.preu
FROM producte as pr
	INNER JOIN beguda as be ON pr.id_producte = be.id_producte
ORDER BY pr.preu DESC, pr.nom;
-- TASCA 5.
	# Mostra el nom de les pizzes i el nom dels seus ingredients segons 
    # l'ordre desc per les pizzes i asc pels ingredients.
SELECT p.nom, ig.nom
FROM producte p
	INNER JOIN pizza pz ON p.id_producte = pz.id_producte
    INNER JOIN pizza_ingredient pi ON pz.id_producte = pi.id_producte
    INNER JOIN ingredient ig ON pi.id_ingredient = ig.id_ingredient
ORDER BY p.nom DESC, ig.nom;

-- Tasca 6. Mostra el nom dels ingredients de la pizza ibèrica ordenats descendement.
SELECT ig.nom
FROM producte p 
	INNER JOIN pizza pz ON p.id_producte = pz.id_producte
	INNER JOIN pizza_ingredient pi ON pz.id_producte = pi.id_producte
	INNER JOIN ingredient ig ON pi.id_ingredient = ig.id_ingredient
WHERE p.nom = 'Pizza ibèrica'
ORDER BY ig.nom DESC;

-- Tasca 7. Mostra el nom de les pizzes que tenen Pinya o Mozzarella , ordenades pel nom de la pizza descendenment.
SELECT DISTINCT p.nom
FROM producte p 
	INNER JOIN pizza pz ON p.id_producte = pz.id_producte
	INNER JOIN pizza_ingredient pi ON pz.id_producte = pi.id_producte
	INNER JOIN ingredient ig ON pi.id_ingredient = ig.id_ingredient
WHERE ig.nom = 'Pinya' OR ig.nom = 'Mozzarella'
ORDER BY p.nom DESC;

-- Tasca 8. Mostra el nom de les postres, preu dels nostres productes que ha demanat en Guillem Jam, ordenats per preu.
SELECT DISTINCT p.nom, p.preu
FROM producte p
	INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte
	INNER JOIN comanda co ON co.numero = cp.numero
	INNER JOIN client ci ON co.client_id = ci.id_client
	INNER JOIN postre po ON p.id_producte = po.id_producte
WHERE ci.nom = 'Guillem Jam'
ORDER BY p.preu;