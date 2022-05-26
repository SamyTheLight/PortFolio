/*
Pràctica UF2P2 - Informació d'una BD (solució) - CREACIÓ
A Terrassa es vol obrir una nova pizzeria amb servei a domicili i ens ha demanat que 
li dissenyem la base de dades que anomenarem pizzeria.

Sabem que els clients realitzaran les comandes per telèfon, per tant la pizzeria 
utilitzarà el número telefònic per cercar-ho però alhora té un identificador propi
com a client auto-generat. A més volem registrar el nom, l’adreça i la població del client. 
Tots aquests camps són obligatoris que s'omplin i sabem que la majoria de clients que es registren són de Terrassa.

També volem registrar l’empleat que realitza cada comanda. 
Cada empleat està identificat per un codi numèric (que sabem que com a molt tindrà 3 xifres), 
i també volem emmagatzemar sempre el seu nom i els cognoms
.
En la carta de productes tenim tres categories: pizzes, begudes i postres.
De les pizzes volem registrar un codi numèric, el nom, el preu i els ingredients 
dels quals estan compostes. Cada ingredient estarà codificat per 
un codi de tres lletres i tindrem també el seu nom.

De les begudes volem registrar un codi numèric, el nom, el preu,
el volum de líquid que conté en centilitres i si es tracta d’una beguda alcohòlica.
De les postres volem registrar un codi numèric, el nom i el preu.
*/

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

#3. Insert
/*INSERT INTO nom_taula [llistat_columnes] VALUES [valors_de_dades];*/
    #Insert client
INSERT INTO client (nom, telefon, adreca, poblacio) VALUES ('Josep Vila', '937853354', 'C. del Pi 23', 'Terrassa');
INSERT INTO client (nom, telefon, adreca, poblacio) VALUES ('Carme Garcia', '937883402', 'Plaça Nova 3', 'Terrassa');
INSERT INTO client (nom, telefon, adreca, poblacio) VALUES ('Enric Miralles', '606989866', 'Carrer Romaní 6', 'Matadepera');
INSERT INTO client (nom, telefon, adreca, poblacio) VALUES ('Miquel Bover', '937753222', 'Carrer Can Boada 78', 'Terrassa');
INSERT INTO client (nom, telefon, adreca, poblacio) VALUES ('Marta Ribas', '937862655', 'Carrer Aviació 3', 'Terrassa');
INSERT INTO client (nom, telefon, adreca, poblacio) VALUES ('Guillem Jam', '937858555', 'Carrer de Dalt 4', 'Terrassa');
INSERT INTO client (nom, telefon, adreca, poblacio) VALUES ('Júlia Guillén', '626895456', 'C. Robert 8', 'Terrassa');

SELECT * FROM uf2_p2_pizzeria.client;
	#Insert empleat
INSERT INTO empleat (id_empleat, nom, cognoms) VALUES (1, 'Jordi', 'Casas');
INSERT INTO empleat (id_empleat, nom, cognoms) VALUES (2, 'Marta', 'Pou');

SELECT * FROM uf2_p2_pizzeria.empleat;
	#Insert comanda	
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10000, '20170109204500', 'L', 1, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10001, '20170109205100', 'D', 2, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10002, '20170109212000', 'D', 3, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10003, '20170109213300', 'D', 4, 2);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10004, '20170110210000', 'D', 5, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10005, '20170110213500', 'L', 6, 2);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10006, '20170110215000', 'D', 1, 2);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10007, '20170111203200', 'D', 2, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10008, '20170111211000', 'D', 7, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, client_id, empleat_id) VALUES (10009, '20170111212400', 'D', 1, 2);

SELECT * FROM uf2_p2_pizzeria.comanda;
#SELECT * FROM comanda WHERE data_hora='2017-01-09 20:45'
	#Insert producte	
INSERT INTO producte (id_producte ,nom ,preu) VALUES (1, 'Ampolla Coca-Cola' , 1.95);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (2, 'Ampolla Fanta Llimona', 1.95);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (3, 'Llauna Nestea', 1.5);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (4, 'Llauna Cervesa Damm', 1.55);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (5, 'Llauna Cervesa sense alcohol', 1.55);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (6, 'Pizza Barbacoa', 19.95);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (7, 'Pizza Carbonara', 18.95);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (8, 'Pizza Hawaiana', 16.95);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (9, 'Pizza 4 estacions', 18.95);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (10, 'Pizza Ibèrica', 21.95);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (11, 'Pizza De la casa', 19.95);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (12, 'Gelat Cornetto Classic', 1);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (13, 'Paquet de trufes de xocolata', 2.25);
INSERT INTO producte (id_producte ,nom ,preu) VALUES (14, 'Gelat Magnum', 1.95);

SELECT * FROM uf2_p2_pizzeria.producte;
	#Insert beguda
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUES (1, 50, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUES (2, 50, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUES (3, 33, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUES (4, 33, 'S');
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUES (5, 33, 'N');

SELECT * FROM uf2_p2_pizzeria.beguda;
	#Insert pizza
INSERT INTO pizza (id_producte) VALUES (6);
INSERT INTO pizza (id_producte) VALUES (7);
INSERT INTO pizza (id_producte) VALUES (8);
INSERT INTO pizza (id_producte) VALUES (9);
INSERT INTO pizza (id_producte) VALUES (10);
INSERT INTO pizza (id_producte) VALUES (11);

SELECT * FROM uf2_p2_pizzeria.pizza;
	#Insert postre
INSERT INTO postre (id_producte) VALUES (12);
INSERT INTO postre (id_producte) VALUES (13);
INSERT INTO postre (id_producte) VALUES (14);

SELECT * FROM uf2_p2_pizzeria.postre;
	#Insert ingredient
INSERT INTO ingredient (id_ingredient, nom) VALUES ('BAC', 'Bacon');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('BAR', 'Salsa barbacoa');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('CAB', 'Salsa carbonara');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('CAR', 'Carn');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('IBE', 'Pernil ibèric');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('MOZ', 'Mozzarella');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('NAT', 'Tomàquet natural');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('OLI', 'Olives negres');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('PER', 'Pernil york');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('PIN', 'Pinya');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('POL', 'Pollastre');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('TOM', 'Salsa de tomàquet');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('TON', 'Tonyina');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('XAM', 'Xampinyons');
	#Insert pizza_ingredient
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6 , 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 'POL');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 'CAR');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 'BAR');

INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7,'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 'XAM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 'CAB');

INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (8,'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (8,'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (8, 'PIN');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (8,'PER');

INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9,'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9,'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9,'PER');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9,'TON');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9,'OLI');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9,'XAM');  

INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (10,'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (10,'NAT');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (10,'IBE');

INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11,'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11,'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11,'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11,'PER');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11,'CAR'); 
    #Insert comanda_producte
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10000, 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10000, 2, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10000, 6, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10000, 12, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10001, 10, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10002, 1, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10002, 4, 3);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10002, 11, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10002, 14, 4);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10003, 4, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10003, 5, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10003, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10003, 8, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10004, 1, 6);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10004, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10004, 9, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10005, 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10005, 5, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10005, 12, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10005, 13, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10006, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10006, 10, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10006, 11, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10007, 1, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10007, 2, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10007, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10008, 4, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10008, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10008, 14, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10009, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUES (10009, 9, 1);

-- Consultes
	
SELECT nom, telefon, adreca
	FROM client
	WHERE poblacio = 'Terrassa';
    
SELECT nom, telefon, adreca
	FROM client
	WHERE poblacio <> 'Terrassa';
  
SELECT nom, telefon, adreca
	FROM client
	WHERE telefon LIKE '93785____';
    
SELECT nom, cognoms
	FROM empleat
    WHERE nom LIKE '%a%' 
		OR cognoms LIKE '%a%';
   
SELECT numero, data_hora
	FROM comanda
	WHERE domicili_local = 'L';
    #6.6
SELECT numero
	FROM comanda
    WHERE domicili_local = 'D' 
		AND client_id = '1';

SELECT nom, preu
	FROM producte
    WHERE preu > '17';
    
SELECT id_ingredient, nom
	FROM ingredient
    WHERE nom LIKE 'Pernil%';
    
SELECT DISTINCT id_producte
	FROM pizza_ingredient
    WHERE id_ingredient = 'XAM'
		OR id_ingredient = 'CAB'
        OR id_ingredient = 'PIN';
	
SELECT DISTINCT numero
	FROM comanda_producte
    WHERE quantitat BETWEEN 3 AND 4;
    
#Activitat 7.1 Consultes a més d'una taula I
    -- TASCA 1.
	# Mostra el nom del client de la comanda 10002.
SELECT cl.id_client, cl.nom, co.numero
	FROM client AS cl
	INNER JOIN comanda as co ON co.client_id = cl.id_client
    WHERE co.numero = 10002;
	-- TASCA 2.
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
SELECT em.id_empleat, em.nom, co.client_id, cl