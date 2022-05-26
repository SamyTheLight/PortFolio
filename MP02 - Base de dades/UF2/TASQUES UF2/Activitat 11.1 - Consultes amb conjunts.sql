# DAM M02 UF2
# Activitat 11.1 - Consultes amb conjunts

USE uf2_p2_pizzeria;

-- Tasca 1. Mostra el nom i cognoms dels clients i treballadors.
SELECT cl.nom AS nom_cognoms
FROM client cl
UNION
SELECT CONCAT(e.nom, ' ', e.cognoms) AS nom_cognoms
FROM empleat em
ORDER BY nom_cognom;

-- Tasca 2. Mostra la quantitat de pizzes, begudes i postres que tenim a la nostra carta.
	# Forma facil (mostrando solo la cantidad)
SELECT COUNT(*) AS carta
FROM producte p
	INNER JOIN pizza pz ON p.id_producte = pz.id_producte # 6 pizzes
UNION
SELECT COUNT(*) AS carta
FROM producte p
	INNER JOIN beguda be ON p.id_producte = be.id_producte # 5 begudes
UNION
SELECT COUNT(*) AS carta
FROM producte p
	INNER JOIN postre po ON p.id_producte = po.id_producte; # 3 postres
    
    # Forma dificil (mostrando cantidad concatenada con un nombre)
SELECT CONCAT(CAST(COUNT(*) AS CHAR), ' pizzes') AS carta
		FROM producte p
            INNER JOIN pizza pz ON p.id_producte = pz.id_producte
UNION
SELECT CONCAT(CAST(COUNT(*) AS CHAR), ' begudes') AS carta
		FROM producte p
            INNER JOIN beguda be ON p.id_producte = be.id_producte	
UNION
SELECT CONCAT(CAST(COUNT(*) AS CHAR), ' postres') AS carta
		FROM producte p
            INNER JOIN postre po ON p.id_producte = po.id_producte;
            
-- Tasca 3. Mostra quins preus de begudes i postres coincideixen.
(
	SELECT p.preu
    FROM producte p
		INNER JOIN 	beguda be ON p.id_producte = be.id_producte
)
INTERSECT
(
	SELECT p.preu
    FROM producte p
		INNER JOIN 	postre po ON p.id_producte = po.id_producte
);

-- Tasca 4. Mostra quins preus de postres no tenim a begudes.
(
	SELECT p.preu
    FROM producte p
		INNER JOIN 	postre po ON p.id_producte = po.id_producte
)
EXCEPT
(
	SELECT p.preu
    FROM producte p
		INNER JOIN 	beguda be ON p.id_producte = be.id_producte
);