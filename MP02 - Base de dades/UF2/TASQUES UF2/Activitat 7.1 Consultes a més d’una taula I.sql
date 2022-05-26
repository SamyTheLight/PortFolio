#1. Base de Dades de la pizzeria
DROP DATABASE IF EXISTS uf2_p2_pizzeria;
CREATE DATABASE 		uf2_p2_pizzeria;
USE 					uf2_p2_pizzeria;
#2. Generació de taules
CREATE TABLE client(
    id_client 			SMALLINT AUTO_INCREMENT,
    nom 				VARCHAR(20) NOT NULL,
    telefon 			VARCHAR(9),
    adreca 				VARCHAR(50) NOT NULL,
    poblacio 			VARCHAR(20) NOT NULL DEFAULT 'Terrassa',
    PRIMARY KEY (id_client),
    CONSTRAINT uk_client_telefon UNIQUE (telefon)
)  ENGINE=INNODB;

CREATE TABLE empleat(
    id_empleat 			SMALLINT(3) AUTO_INCREMENT,
    nom					VARCHAR(20) NOT NULL,
    cognoms 			VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_empleat)
)  ENGINE=INNODB;

CREATE TABLE comanda(
    numero 				SMALLINT AUTO_INCREMENT,
    data_hora 			TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    domicili_local 		ENUM('D', 'L') NOT NULL,
    client_id 			SMALLINT NOT NULL,
    empleat_id 			SMALLINT(3) NOT NULL,
    PRIMARY KEY (numero),
    CONSTRAINT fk_comanda_client FOREIGN KEY (client_id)
        REFERENCES client (id_client),
    CONSTRAINT fk_comanda_empleat FOREIGN KEY (empleat_id)
        REFERENCES empleat (id_empleat)
)  ENGINE=INNODB , AUTO_INCREMENT=10000;

CREATE TABLE producte(
    id_producte 		SMALLINT AUTO_INCREMENT,
    nom					VARCHAR(50) NOT NULL,
    preu 				DECIMAL(4 , 2 ) NOT NULL,
    PRIMARY KEY (id_producte),
    CONSTRAINT uk_producte_nom UNIQUE (nom),
    CONSTRAINT ck_producte_preu CHECK (preu BETWEEN 0.01 AND 99.99)
)  ENGINE=INNODB;

CREATE TABLE beguda(
    id_producte 		SMALLINT,
    capacitat 			SMALLINT(3) NOT NULL,
    alcoholica 			ENUM('N', 'S') NOT NULL,
    PRIMARY KEY (id_producte),
    CONSTRAINT fk_beguda_producte FOREIGN KEY (id_producte)
        REFERENCES producte (id_producte),
    CONSTRAINT ck_beguda_capacitat CHECK (capacitat BETWEEN 1 AND 150)
)  ENGINE=INNODB;

CREATE TABLE pizza(
	id_producte 		SMALLINT,
    PRIMARY KEY (id_producte),
    CONSTRAINT fk_pizza_producte FOREIGN KEY (id_producte)
        REFERENCES producte (id_producte)
)  ENGINE=INNODB;

CREATE TABLE postre(
	id_producte 		SMALLINT,
    PRIMARY KEY (id_producte),
    CONSTRAINT fk_postre_producte FOREIGN KEY (id_producte)
        REFERENCES producte (id_producte)
)  ENGINE=INNODB;

CREATE TABLE ingredient(
    id_ingredient 		VARCHAR(3),
    nom 				VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_ingredient),
    CONSTRAINT uk_ingredient_nom UNIQUE (nom)
)  ENGINE=INNODB;

CREATE TABLE pizza_ingredient(
    id_producte 		SMALLINT,
    id_ingredient 		VARCHAR(3),
    PRIMARY KEY (id_producte , id_ingredient),
    CONSTRAINT fk_pizza_ingredient_pizza FOREIGN KEY (id_producte)
        REFERENCES pizza (id_producte),
    CONSTRAINT fk_pizza_ingredient_ingredient FOREIGN KEY (id_ingredient)
        REFERENCES ingredient (id_ingredient)
)  ENGINE=INNODB;

CREATE TABLE comanda_producte (
    numero 				SMALLINT,
    id_producte 		SMALLINT,
    quantitat 			SMALLINT(2) NOT NULL,
    PRIMARY KEY (numero , id_producte),
    CONSTRAINT fk_comanda_producte_comanda FOREIGN KEY (numero)
        REFERENCES comanda (numero),
    CONSTRAINT comanda_producte_producte FOREIGN KEY (id_producte)
        REFERENCES producte (id_producte),
    CONSTRAINT ck_comanda_producte_quantitat CHECK (quantitat BETWEEN 1 AND 99)
)  ENGINE=INNODB;
    
#Activitat 7.1 Consultes a més d'una taula I

    -- Tasca 1. Mostra el nom del client de la comanda 10002.
	# Mostra el nom del client de la comanda 10002.
SELECT cl.id_client, cl.nom, co.numero
	FROM client AS cl
	INNER JOIN comanda as co ON co.client_id = cl.id_client
WHERE co.numero = 10002;

	-- Tasca 2. Mostra el nom del empleat que han venut la comanda 10000.
	# Mostra el nom del empleat que ha venut la comanda 10000.
SELECT em.id_empleat, em.nom, co.numero
	FROM empleat as em
    INNER JOIN comanda as co ON co.empleat_id = em.id_empleat
WHERE co.numero = 10000;
    -- TASCA 3.
	# Mostra el número de comanda i si eren a recollir en el local o repartiment domicili 
    # les comandes que ha demanat en Josep Vila.
SELECT co.numero, co.domicili_local, cl.id_client, cl.nom
	FROM comanda as co
    INNER JOIN client as cl ON co.client_id = cl.id_client
WHERE cl.id_client = 1;
-- TASCA 4.
	# Mostra el el número de comanda i el nom del clients que han demanat comandes al local.
SELECT co.numero, co.domicili_local, id_client, cl.nom
	FROM comanda as co
    INNER JOIN client as cl ON co.client_id = cl.id_client
WHERE (domicili_local = 'L');
-- TASCA 5.
	# Mostra el nom dels empleats que han servit comandes a la Carme Garcia.
SELECT DISTINCT em.nom
	FROM empleat as em
    INNER JOIN comanda co ON em.id_empleat = co.empleat_id
    INNER JOIN client cl ON co.client_id = cl.id_client
WHERE (cl.nom = 'Carmen Garcia');
-- TASCA 6.
	# Mostra la data i hora que ha fet comandes l'empleada Marta Pou.
SELECT co.data_hora
	FROM empleat AS em
    INNER JOIN comanda co ON em.id_empleat = co.empleat_id
WHERE em.nom LIKE "Marta" AND em.cognom LIKE "Pou";
-- TASCA 7. 
	# Mostra quantes comandes han demanat per servir a domicili.
SELECT COUNT(*) AS domicili_local
	FROM comanda
WHERE domicili_local = 'D';

-- Tasca 8. Mostra els números de comanda que han demanat pizza 4 estacions.
SELECT cp.numero
	FROM comanda_producte cp
    INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN pizza pz ON p.id_producte = pz.id_producte
WHERE p.nom = 'Pizza 4 estacions'; 

-- Tasca 9: Mostra quantes Coca-colas hem venut.
SELECT SUM(cp.quantitat) AS totalCocaColas
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
    INNER JOIN beguda b ON p.id_producte = b.id_producte
WHERE p.nom LIKE '%Coca-Cola'; 

-- Tasca 10. Mostra els ingredient que té la pizza barbacoa.
SELECT pzi.id_ingredient
FROM pizza pz
	INNER JOIN pizza_ingredient pzi ON pzi.id_producte = pz.id_producte
WHERE pz.id_producte = 6; -- He consultat abans que la pizza barbacoa te id = 6.

-- Tasca 11. Mostra les beguda i el preu d'aquestes.
SELECT p.nom, p.preu
FROM producte p
	INNER JOIN beguda be ON p.id_producte = be.id_producte;

-- Tasca 12. Mostra el nom de les pizza que tenen pinya.
SELECT p.nom
FROM producte p
	INNER JOIN pizza pz ON p.id_producte = pz.id_producte
    INNER JOIN pizza_ingredient pzi ON pz.id_producte = pzi.id_producte
WHERE pzi.id_ingredient LIKE 'PIN';

-- Tasca 13. Mostra la quantitat d’ingredient que té la pizza 4 estacions.
SELECT COUNT(*)
FROM  pizza pz
	INNER JOIN pizza_ingredient pzi ON pz.id_producte = pzi.id_producte
WHERE pz.id_producte = 9; -- He consultat abans que la pizza 4 estacions te id = 9.

-- Taca 14. Mostra quantes beguda no alcohòliques hi ha a la carta.
SELECT COUNT(*)
FROM producte p
	INNER JOIN beguda be ON p.id_producte = be.id_producte
WHERE be.alcoholica LIKE 'N';

-- Tasca 15. Mostra el preu total de la comanda 10005.
SELECT SUM(cp.quantitat * p.preu) AS Preu_total_comanda_10005
FROM comanda_producte cp
	INNER JOIN producte p ON cp.id_producte = p.id_producte
WHERE cp.numero = 10005;

-- Tasca 16. Mostra quantes pizzes hem servit a fora de Terrassa.
SELECT SUM(cp.quantitat) 
FROM client cl
	INNER JOIN comanda c ON cl.id_client = c.client_id
    INNER JOIN comanda_producte cp ON c.numero = cp.numero
    INNER JOIN producte p ON cp. id_producte = p.id_producte
    INNER JOIN pizza pz ON p.id_producte = pz.id_producte
WHERE cl.poblacio NOT LIKE 'Terrassa';

-- Tasca 17. Mostra la quantitat de pizza que té la nostra carta.
SELECT COUNT(*)
FROM pizza;

-- Tasca 18. Mostra el nom dels postres dels nostres productes que ha demanat la Júlia Guillén.
SELECT p.nom AS Postre
FROM client cl
	INNER JOIN comanda c ON cl.id_client = c.client_id
	INNER JOIN comanda_producte cp ON c.numero = cp.numero
	INNER JOIN producte p ON cp. id_producte = p.id_producte
    INNER JOIN postre pt ON p.id_producte = pt.id_producte
WHERE cl.nom LIKE 'Júlia Guillén';

-- Tasca 19. Mostra el nom del client han demanat almenys 4 unitats d’una mateixa beguda a una comanda.
SELECT DISTINCT cl.nom
FROM client cl 
	INNER JOIN comanda co ON cl.id_client = co.client_id
    INNER JOIN comanda_producte cp ON co.numero = cp.numero
    INNER JOIN beguda be ON cp.id_producte = be.id_producte
WHERE cp.quantitat >= 4;
