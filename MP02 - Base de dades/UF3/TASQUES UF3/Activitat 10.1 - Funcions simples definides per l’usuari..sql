-- Activitat 10.1 - Funcions simples definides per l’usuari.

USE uf2_p2_pizzeria;

-- Tasca 1.
-- Volem crear una funció anomenada getDescripcioQualificacio, on ha partir d’un parametre tipus string variable,
-- sí s’envia amb valor 'apte' retorni una 'A', en cas de 'no apte' retorni 'NA', per totes les altres posibles opcions 
-- retornarà 'NS/NC'.

DELIMITER //
CREATE OR REPLACE FUNCTION getDescripcioQualificacio (pQualificacio VARCHAR(10))
RETURNS VARCHAR(5)
BEGIN	
	IF(pQualificacio ='apte') THEN
		RETURN 'A';
	ELSEIF(pQualificacio = 'no apte') THEN
		RETURN 'N/A';
	ELSE
		RETURN 'NS/SC';
	END IF;
END //
DELIMITER ;

SELECT getDescripcioQualificacio('apte');
SELECT getDescripcioQualificacio('no apte');
SELECT getDescripcioQualificacio('APTE');
SELECT getDescripcioQualificacio('No apte');

-- Tasca 2.
-- Crea una funció anomenada getApteByNota que retorni el valor 'apte' si escrivim una nota que és superior a 5, i 'no apte' en cas contrari.

DELIMITER //
CREATE OR REPLACE FUNCTION getApteByNota (pNota DECIMAL(4,2))
RETURNS VARCHAR (7)
BEGIN
	IF(pNota > 5) THEN
		RETURN 'apte';
	ELSE
		RETURN 'no apte';
	END IF;
END //
DELIMITER ;
        
SELECT getApteByNota(4.9), getApteByNota(5);

-- Tasca 3.
-- Crea una funció anomenada getTornByHora que segons l'hora que li introduïm ens digui torn de 'matí' (si és una hora entre les 8 i les 15) 
-- o torn de 'tarda' (si és una hora entre les 16 i les 22). En cas que no sigui cap d'aquest que escrigui un guió '-'.

DELIMITER //
CREATE OR REPLACE FUNCTION getTornByHora (pHora TIME)
RETURNS VARCHAR(10)
BEGIN
	IF(pHora BETWEEN '08:00' AND '15:00') THEN
		RETURN 'matí';
	ELSEIF(pHora BETWEEN '16:00' AND '22:00') THEN
		RETURN 'tarda';
	ELSE
		RETURN '-';
	END IF;
END //
DELIMITER ;

SELECT getTornByHora('08:00'), getTornByHora('16:00'), getTornByHora('23:00');

-- Tasca 4.
-- Crea una funció anomenada getNomComplet de manera que retorni el nom i els cognoms concatenats en el mateix camp. 
DELIMITER //
CREATE OR REPLACE FUNCTION getNomComplet (pNom VARCHAR(20), pCognom VARCHAR(20))
RETURNS VARCHAR(51)
BEGIN
	RETURN CONCAT(pNom, ' ', pCognom);
END //
DELIMITER ;

SELECT getNomComplet('Samuel','Garcia');

-- Tasca 5.
-- Crea una funció anomenada getConversioDolars, de manera que retorni el valor en Dòlars d'un import en Euros, on 1€ = 1,08 $.
DELIMITER //
CREATE OR REPLACE FUNCTION getConversioDolars (pImport DECIMAL(6,2))
RETURNS DECIMAL(6,2)
BEGIN
	DECLARE DOLAR DECIMAL(3,2) DEFAULT 1.08;
    RETURN pImport * DOLAR;
END //
DELIMITER ;

-- Tasca 6.
-- Crea una funció anomenada getValorAbsolut de manera que sumi dos valors enters en valor absolut.
DELIMITER //
CREATE OR REPLACE FUNCTION getValorAbsolut (pValor1 SMALLINT, pValor2 SMALLINT)
RETURNS SMALLINT
BEGIN
	RETURN SUM(pValor1 + pValor2);
END //
DELIMITER ;
	