# Activitat 6.1 - Consultes BD Botànic

USE uf2_act_5_2_botanic;

-- Tasca 1. Mostra el identificador i nom popular de les plantes que floreixen a l'estiu. 
SELECT id_planta, nom_popular
FROM planta
WHERE estacio_id = 'Estiu';
    
-- Tasca 2. Mostra els camps identificador  identificador i nom popular, com a nom_cientific 
-- i popular de les plantes que floreixen a l’hivern i a la tardor.
SELECT id_planta AS nom_cientific, nom_popular AS popular
FROM planta
WHERE estacio_id IN ('Hivern','Tardor');
    
-- Tasca 3. Mostra el nom científic de les plantes que utilitzen adob 'Casadob'.
SELECT DISTINCT planta_id
FROM adob_estacio_planta
WHERE adob_id = 'Casadob';

-- Tasca 4. Mostra el nom dels adob de la firma comercial 'Prisadob' i mostra també de quin tipus són.
SELECT id_adob, tipus
FROM adob
WHERE firma_comercial_id = 'Prisadob';

-- Tasca 5. Mostra les plantes que necessiten estar a una temperatura superior a 16ºC.
SELECT id_planta
FROM planta_interior
WHERE temperatura > 16;
    
-- Tasca 6. Mostra el nom científic de les plantes que utilitzin una quantitat d'adob entre 40 i 50 (tots dos inclosos).
SELECT DISTINCT planta_id
FROM adob_estacio_planta
WHERE quantitat BETWEEN 40 AND 50
# WHERE quantitat >= 40 AND quantitat <= 50; -- Equivalent
    
-- Taca 7. Mostra les plantes que se les ha adobat al hivern i a la tardor.
SELECT DISTINCT planta_id
FROM adob_estacio_planta
WHERE estacio_id IN ('Hivern','Tardor');
#WHERE id_estacio = 'Hivern' OR id_estacio = 'Tardor'; -- Equivalent

-- Tasca 8. Mostra el nom científic i el nom popular de les plantes que el seu nom popular conté una 'i'.
SELECT id_planta, nom_popular
FROM planta
WHERE nom_popular LIKE '%i%';

-- Tasca 9. Mostra els adobs de les firmes comercials Cirsadob i Tirsadob. Mostra també a la firma a la que pertanyen.
SELECT id_adob, firma_comercial_id
FROM adob
WHERE firma_comercial_id IN ('Cirsadob','Tirsadob');

-- Tasca 10. Mostra les plantes que utilitzen adob 'Casadob' i un quantitat superior a 40 unitats.
SELECT DISTINCT planta_id
FROM adob_estacio_planta
WHERE adob_id = 'Casadob' AND quantitat > 40;;

-- Tasca 11. Mostra el nom científic de les plantes que s'han adobat a la primavera o les que han utilitzat adob 'Sanexplant'.
SELECT DISTINCT planta_id
FROM adob_estacio_planta
WHERE estacio_id = 'Primavera' OR adob_id = 'Sanexplant';

-- Tasca 12. Mostra el nom científic de les plantes amb un cicle de vida llarg.
SELECT id_planta
FROM planta_exterior 
WHERE tipus = 'P';

-- Tasca 13. Mostra el nom científic de les plantes que s’han d’ubicar amb ‘Llum directa’ i alhora amb una temperatura de 15ºC.
SELECT id_planta
FROM planta_interior
WHERE ubicacio = 'Llum directa' AND temperatura = 15;

-- Tasca 14. Mostra les firmes comercials amb 7 caràcters i finalitza el seu nom amb ‘adob’.
SELECT id_firma_comercial
FROM firma_comercial
WHERE id_firma_comercial LIKE '___adob';

-- Tasca 15. Mostra els adobs d’acció inmediata, que són subministrats per les firmes comercials
-- que el seu nom comença amb ‘T’ o ‘P’.
SELECT id_adob
FROM adob
WHERE tipus = 'AI' AND (firma_comercial_id LIKE 'T%' OR firma_comercial_id LIKE 'P%');