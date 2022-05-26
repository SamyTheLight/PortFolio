USE uf2_p2_pizzeria;

-- Tasca 1
GRANT ALL PRIVILEGES ON *.* TO 'pz.root'@localhost IDENTIFIED BY '1234' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Tasca 2.
#connectem amb un usuari administrador 
GRANT ALL PRIVILEGES ON *.* TO 'pz.root' WITH GRANT OPTION;
FLUSH PRIVILEGES;
#connectem amb l'usuari pz.root
GRANT CREATE USER ON *.* TO 'pz.administracio' IDENTIFIED BY '1234';
FLUSH PRIVILEGES;

-- Tasca 3.
CREATE ROLE 'dissenyador.global', 'dissenyador.productes', 'operador.persones', 'operador.productes', repartidor;
FLUSH PRIVILEGES;

-- Tasca 4.
GRANT CREATE,ALTER,DROP ON uf2_p2_pizzeria.* TO 'dissenyador.global';
FLUSH PRIVILEGES;

-- Tasca 5.
GRANT ALTER ON uf2_p2_pizzeria.producte TO 'dissenyador.productes';
GRANT ALTER ON uf2_p2_pizzeria.pizza TO 'dissenyador.productes';
GRANT ALTER ON uf2_p2_pizzeria.pizza_ingredient TO 'dissenyador.productes';
GRANT ALTER ON uf2_p2_pizzeria.ingredient TO 'dissenyador.productes';
GRANT ALTER ON uf2_p2_pizzeria.postre TO 'dissenyador.productes';
GRANT ALTER ON uf2_p2_pizzeria.beguda TO 'dissenyador.productes';
FLUSH PRIVILEGES;

-- Tasca 6.
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.client TO 'operador.persones';
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.empleat TO 'operador.persones';
FLUSH PRIVILEGES;

-- Tasca 7.
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.producte TO 'operador.productes';
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.pizza TO 'operador.productes';
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.pizza_ingredient TO 'operador.productes';
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.ingredient TO 'operador.productes';
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.postre TO 'operador.productes';
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.beguda TO 'operador.productes';
FLUSH PRIVILEGES;

-- Tasca 8.
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.comanda TO 'repartidor';
GRANT SELECT, INSERT, DELETE, UPDATE ON uf2_p2_pizzeria.comanda_producte TO 'repartidor';
FLUSH PRIVILEGES;

-- Tasca 9.
GRANT 'dissenyador.global' TO 'pz.joan' IDENTIFIED BY '1234';
GRANT 'dissenyador.global' TO 'pz.maria' IDENTIFIED BY '1234';
GRANT 'dissenyador.productes' TO 'pz.maria';
GRANT 'dissenyador.productes' TO 'pz.jordi' IDENTIFIED BY '1234';
GRANT 'operador.persones' TO 'pz.eric' IDENTIFIED BY '1234';
GRANT 'operador.productes' TO 'pz.eric';
GRANT 'operador.productes' TO 'pz.dani' IDENTIFIED BY '1234';
GRANT repartidor TO 'pz.dani';
GRANT repartidor TO 'pz.pol' IDENTIFIED BY '1234';
FLUSH PRIVILEGES;

-- Tasca 10.
REVOKE DELETE ON m02_uf3.ingredient FROM 'pz.dani';
REVOKE DELETE ON m02_uf3.pizza_ingredient FROM 'pz.dani';
FLUSH PRIVILEGES;