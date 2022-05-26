# DAM M02 UF2
# Activitat 12.1 - Consultes a més d'una taula II 

USE uf2_p2_pizzeria;

-- Tasca 1. Mostra els productes que no siguin postres.
SELECT p.nom
FROM producte p
	LEFT JOIN postre po ON p.id_producte = po.id_producte
WHERE po.id_producte IS NULL;

-- Tasca 2. Mostra tots els productes i la quantitat d'ingredients que tenen. Els productes que no son pizzes en si mateixos són un únic ingredient.
SELECT p.nom, COUNT(*) as ingredients
FROM producte p
	LEFT JOIN beguda be ON p.id_producte = be.id_producte
    LEFT JOIN postre po ON p.id_producte = po.id_producte
    LEFT JOIN pizza pz ON p.id_producte = pz.id_producte
		LEFT JOIN pizza_ingredient pi ON p.id_producte = pi.id_producte
GROUP BY p.nom;

-- Tasca 3. Mostra la quantitat de pizzes, begudes i postres que hem venut.
SELECT SUM(IF(pz.id_producte IS NOT NULL, quantitat, 0)) AS pizzes,
	   SUM(IF(be.id_producte IS NOT NULL, quantitat, 0)) AS begudes,
       SUM(IF(po.id_producte IS NOT NULL, quantitat, 0)) AS postre
FROM comanda_producte cp
	LEFT JOIN producte p on cp.id_producte = p.id_producte
    LEFT JOIN pizza pz on cp.id_producte = pz.id_producte
	LEFT JOIN beguda be on cp.id_producte = be.id_producte
	LEFT JOIN postre po on cp.id_producte = po.id_producte;

-- Tasca 4. Afegeix l'ingredient 'CEB', 'Ceba'. Mostra tots els ingredients i la quantitat que fem servir a les pizzes.
INSERT INTO ingredient (id_ingredient, nom) VALUE ('CEB', 'Ceba');

SELECT ig.nom, IF(pi.id_ingredient IS NOT NULL, COUNT(*), 0) AS vegades
FROM ingredient ig  
	LEFT JOIN pizza_ingredient pi ON ig.id_ingredient = pi.id_ingredient
GROUP BY pi.id_ingredient;