# Activitat 6.2 - Consultes amb funcions

USE uf2_act_5_2_botanic;

-- Tasca 1. Mostra la quantitat total d'adob que hem de fer servir.
SELECT SUM(quantitat) quantitat_total
FROM adob_estacio_planta;
    
-- Tasca 2. Mostra la mitjana d'adob Casadob amb que s'han adobat les plantes.
SELECT AVG(quantitat) mitjana
FROM adob_estacio_planta
WHERE adob_id = 'Casadob';

-- Tasca 3. Mostra la mitjana de temperatura a la que han d'estar les plantes d'interior.
SELECT AVG(temperatura) mitjana
FROM planta_interior;

-- Tasca 4. Mostra la quantitat mínima i màxima d'adob que s'utilitza alguna vegada (en una sola consulta).
SELECT MIN(quantitat) minim, MAX(quantitat) maxim
FROM adob_estacio_planta;

-- Tasca 5. Mostra la temperatura màxima de pot estar una plante d'interior.
SELECT MAX(temperatura)
FROM planta_interior;

-- Tasca 6. Mostra la quantitat total d'adob que utilitza la planta Euphorbia.
SELECT SUM(quantitat) AS 'quantitat_total'
FROM adob_estacio_planta
WHERE planta_id = 'Euphorbia';


USE uf2_p2_pizzeria;

-- Tasca 7. Mostra la quantitat total de comandes han demanat per servir a domicili.
SELECT COUNT(*) AS quantitat_total
FROM comanda
WHERE domicili_local LIKE 'D';

-- Tasca 8. Mostra la quantitat d'ingredients que té la pizza Pizza Carbonara.
SELECT count(*)
FROM pizza_ingredient
WHERE producte_id = 6;

-- Tasca 9. Mostra la quantitat de pizzes que porten Carn.
SELECT count(*)
FROM pizza_ingredient
WHERE ingredient_id = 'CAR';

-- Tasca 10. Mostra la quantitat de productes total que han demanat a la comanda 10000.
SELECT SUM(quantitat) AS quantitat_productes
FROM comanda_producte
WHERE numero = 10000;

-- Tasca 11. Mostra el número de les comandes i en que dia de la setmana que s'han fet.
SELECT numero, DAYNAME(data_hora) AS dia
FROM comanda;

USE uf2_act_5_2_botanic;

-- Tasca 12. Concatena dos columnes amb una separació opcional.
SELECT CONCAT(id_adob, firma_comercial_id) AS Adobs
FROM adob;

SELECT CONCAT(id_adob, ' *** ', firma_comercial_id) AS Adobs
FROM adob;

-- Tasca 13. Mostra un nombre determinat de caràcters començant per l'esquerra d’un o varis camps de la taula adobs.
SELECT LEFT(id_adob, 4) AS adobs
FROM adob;

SELECT CONCAT(id_adob, ' - ', LEFT(firma_comercial_id, 3)) AS adobs
FROM adob;

-- Tasca 14. Mostra un nombre determinat de caràcters començant per la dreta d’un o varis camps de la taula adobs.
SELECT RIGHT(id_adob, 3) AS adobs
FROM adob;

SELECT CONCAT(id_adob, ' - ', RIGHT(firma_comercial_id, 3)) AS adobs
FROM adob;

-- Tasca 15. Mostra el número de caràcters del nom de l'adob per a cada un dels registres de la taula adobs.
SELECT LENGTH(id_adob) AS caracters
FROM adob;

-- Taca 16. Mostra el número de caràcters del nom de l'adob i el nom de l’adob, per a cada un dels registres de 
-- la taula adobs amb longitud de càracters menors a 10.
SELECT id_adob, LENGTH(id_adob) AS caracters
FROM adob
WHERE LENGTH(id_adob) < 10;

-- Tasca 17. Mostra en mínuscules el nom de les firmes comecials de la taula adobs. Ara fés que no es repetexin.
SELECT LOWER(firma_comercial_id) AS firma_comercial
FROM adob;

SELECT DISTINCT firma_comercial_id, LOWER(firma_comercial_id) FIRMA
FROM adob;

-- Tasca 18. Mostra en nom de l'adob, alhora en majúscules i també en majúscules els 4 primers caràcters.
SELECT id_adob, UPPER(id_adob) AS majuscula_adob, UPPER(LEFT(id_adob, 4)) AS majuscula_4c_adob
FROM adob;

-- Tasca 19. Mostra la quantitat total d'adob, la quantitat total si el subministre d'adob s'incremente en 10 per a cada dosi, i  la quantitat total d'adob + 10.
SELECT SUM(quantitat) quantitat_total, SUM(quantitat + 10) AS quantitat_mes_10_total, SUM(quantitat) + 10 AS quantitat_total_mes_10
FROM adob_estacio_planta;

-- Tasca 20. Mostra la quantitat d'adob, i crea columnes amb la quantitat si li restem 100, multipliquem 10, dividim per 10 i fem la divisió entera (DIV) per 20.
SELECT quantitat, (quantitat - 100) AS resta, (quantitat * 10) AS multiplicacio, (quantitat / 10) AS divisio, (quantitat DIV 10) AS divisi_entera
FROM adob_estacio_planta;

-- Tasca 21. Mostra el valor absolut de la quantitat d'adob, i crea columnes amb la quantitat si li restem 100, i el valor absolut si restem 100 a la quantitat.
SELECT ABS(quantitat) AS abs_quantitat, quantitat - 100 AS quantitat_menys_10, ABS(quantitat - 100) AS abs_quantitat_menys_10
FROM adob_estacio_planta;

-- Tasca 22. Mostra la quantitat d'adob dividit entre 7, i mostra la divisió redondejada, redondejada cap adalt i cap abaix.
SELECT quantitat / 7 AS quantitat_7, ROUND(quantitat / 7) AS round_quantitat_7, CEIL(quantitat / 7) AS ceil_quantitat_7, FLOOR(quantitat / 7) AS floor_quantitat_7
FROM adob_estacio_planta;

-- Tasca 23. Mostra la quantitat d'adob, el seu mòdul a 2, elevat a 2, i 2 elevat a la quantitat. Alhora l'arrel de la quantitat i l'arrel redondejadats a 4 decimals.
SELECT quantitat, MOD(quantitat, 2) AS mod2_quantitat, POW(quantitat, 2) AS pow_quantitat_2, POW(2, quantitat) AS pow_2_quantitat,
	SQRT(quantitat) AS sqrt_quantitat, ROUND(SQRT(quantitat), 4) AS sqrt_round_quantitat_4
FROM adob_estacio_planta;

-- Tasca 24.  Mostra la data actual, l'hora actual, el timestamp actual.
SELECT CURDATE(), CURTIME(), NOW();

-- Tasca 25.  Mostra la data '2012-01-31 20:01:38', en funció d'aquesta data mostra alhora: el dia, el dia de mes, el dia de la setmana, 
-- el mes, l'últim dia del mes, el dia de l'any, l'any.
SELECT DATE('2012-01-31 20:01:38') AS data, DAY('2012-07-31 20:01:38') AS dia, DAYOFMONTH('2012-01-31 20:01:38') AS dia_mes, 
	DAYOFWEEK('2012-01-31 20:01:38') AS dia_setmana, MONTH('2012-07-31 20:01:38') AS mes, LAST_DAY('2012-07-31 20:01:38') AS ultim_dia_mes,
    DAYOFYEAR('2012-07-31 20:01:38') AS dia_any, YEAR('2012-07-31 20:01:38') AS any;

-- Tasca 26.  Mostra la data actual, en funció d'aquesta data mostra alhora: el dia, el dia de mes , el dia de la setmana, el mes, el dia de l'any, l'any.
SELECT NOW() AS data, DAY(NOW()) AS dia, DAYOFMONTH(NOW()) AS dia_mes, 
	DAYOFWEEK(NOW()) AS dia_setmana, MONTH(NOW()) AS mes, LAST_DAY(NOW()) AS ultim_dia_mes,
	DAYOFYEAR(NOW()) AS dia_any, YEAR(NOW()) AS any;

-- Tasca 27.  Mostra l'hora '2012-07-31 20:01:38', en funció d'aquesta hora mostra alhora: el minut, el segon.
SELECT HOUR('2012-07-31 20:01:38') AS hora, MINUTE('2012-07-31 20:01:38') AS minut, SECOND('2012-07-31 20:01:38') AS segon;

-- Tasca 28.  Mostra l'hora actual, en funció d'aquesta hora mostra alhora: el minut, el segon.
SELECT HOUR(CURTIME()) AS hora, MINUTE(CURTIME()) AS minut, SECOND(CURTIME()) AS segon;