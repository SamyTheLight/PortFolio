# UF2P2- Prova d’avaluació

USE uf2_pa2_pelicules;

-- TASCA 1. Escriviu una consulta a SQL per trobar el nom i cognom d’un director i la pel·lícula que va
-- 			dirigir, on va aparèixer l’actriu Claire Danes, també volem el seu paper en aquesta pel·lícula.

SELECT CONCAT(dc.nom,' ',dc.cognoms) director, pl.titol pelicula, ap.rol rol
FROM directors dc
	INNER JOIN directors_pelicules dp ON dc.id_director = dp.id_director
    INNER JOIN pelicules pl ON dp.id_pelicula = pl.id_pelicula
    INNER JOIN actors_pelicules ap ON pl.id_pelicula = ap.id_pelicula
    INNER JOIN actors ac ON ap.id_actor = ac.id_actor
WHERE ac.nom LIKE 'Claire' AND ac.cognoms LIKE 'Danes';

-- TASCA 2. Mostra el títol de les pel·lícules que almenys han rebut valoració, i la valoració màxima que
-- 			han rebut. Mostra-les de més valoració a menys.ALTER
SELECT pl.titol, MAX(cp.valoracio) valoracio
FROM pelicules pl
	INNER JOIN critics_pelicules cp ON pl.id_pelicula = cp.id_pelicula
GROUP BY pl.titol
ORDER BY valoracio DESC;

-- TASCA 3. Escriviu una consulta a SQL per trobar el rol de les actrius de les pel·lícules amb una
-- 			mitjana d’entre 5 i 7 de valoració
SELECT ap.rol rol_actor, AVG(cp.valoracio) mitjana
FROM pelicules pl
	INNER JOIN critics_pelicules cp ON pl.id_pelicula = cp.id_pelicula
    INNER JOIN actors_pelicules ap ON cp.id_pelicula = ap.id_pelicula
    INNER JOIN actors ac ON ap.id_actor = ac.id_actor
WHERE ac.genere = 'D'
GROUP BY ap.rol
HAVING mitjana BETWEEN 5 AND 7;

-- TASCA 4. Mostra els directors que han rebut alguna valoració de 8 ordenats per cognom, nom
SELECT dc.cognoms, dc.nom
FROM directors dc
	INNER JOIN directors_pelicules dp ON dc.id_director = dp.id_director
    INNER JOIN pelicules pl ON dp.id_pelicula = pl.id_pelicula
    INNER JOIN critics_pelicules cp ON pl.id_pelicula = cp.id_pelicula
WHERE cp.valoracio LIKE 8
GROUP BY dc.id_director
ORDER BY dc.cognoms, dc.nom;

-- TASCA 5. De totes les pel·lícules del país UK, mostra el títol, la quantitat d’actors i la valoració mínima.
-- 			Ordenats de major a menor en valoració.
	# Pas 1: mostrem la valoració minima
SELECT MIN(valoracio)
FROM critics_pelicules;

-- TASCA 6. Mostra els crítics i la mitjana de les puntuacions que han fet, també les pel·lícules i la
-- mitjana de puntuacions obtingudes. Volem les mitjanes inferiors A 5.
	# Pas 1: mostrem els crítics i la valoracio mitjana
SELECT ci.nom, AVG(cp.valoracio) valoracio
FROM critics ci
	INNER JOIN critics_pelicules cp ON ci.id_critic = cp.id_critic
GROUP BY ci.nom
HAVING valoracio < 5;
	# Pas 2: mostrem el nom de les pelicules i la seva valoracio mitjana
SELECT pl.titol, AVG(cp.valoracio)  valoracio
FROM pelicules pl
	INNER JOIN critics_pelicules cp ON pl.id_pelicula = cp.id_pelicula
GROUP BY pl.titol
HAVING valoracio < 5;
# Pas 3
SELECT ci.nom, AVG(cp.valoracio) valoracio
FROM critics ci
	INNER JOIN critics_pelicules cp ON ci.id_critic = cp.id_critic
GROUP BY ci.nom
HAVING valoracio < 5
UNION
SELECT pl.titol, AVG(cp.valoracio)  valoracio
FROM pelicules pl
	INNER JOIN critics_pelicules cp ON pl.id_pelicula = cp.id_pelicula
GROUP BY pl.titol
HAVING valoracio < 5;