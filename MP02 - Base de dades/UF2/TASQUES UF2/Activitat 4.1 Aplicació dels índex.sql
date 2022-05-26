#TASCA 1. Taula empleat.
USE empresa;
SHOW TABLES;
SHOW INDEX FROM empleat;
DROP INDEX uk_empleat_salari_comissio ON empleat;
SHOW INDEX FROM empleat;
ALTER TABLE empleat
			ADD CONSTRAINT uk_empleat_nom_cognoms UNIQUE(nom,cognoms);
SHOW INDEX FROM empleat;
ALTER TABLE empleat 
			ADD INDEX ix_empleat_contracte (contracte);
SHOW INDEX FROM empleat;
CREATE INDEX  ix_empleat_salari ON empleat(salari);
SHOW INDEX FROM empleat;
ALTER TABLE empleat 
			DROP INDEX ix_empleat_contracte;
SHOW INDEX FROM empleat;
#TASCA 2. Taula departament.
SHOW TABLES;
SHOW INDEX FROM departament;
ALTER TABLE departament
			ADD PRIMARY KEY (id_departament);
SHOW INDEX FROM departament;
ALTER TABLE departament 
			ADD CONSTRAINT uk_departament_nom UNIQUE(nom);
SHOW INDEX FROM departament;
DROP INDEX uk_departament_nom on departament;
SHOW INDEX FROM departament;