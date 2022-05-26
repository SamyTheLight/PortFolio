/*
UF2PA2: Prova d'avaluació Consultes (solució).sql
*/

USE uf2_pa2_pelicules;

-- Tasca 1. Escriviu una consulta a SQL per trobar el nom i cognom d’un director i la pel·lícula que va dirigir, on va aparèixer l’actriu Claire Danes, també volem el seu paper en aquesta pel·lícula.
SELECT d.nom, d.cognoms, p.titol, ap.rol
FROM pelicules p
    INNER JOIN directors_pelicules dp ON p.id_pelicula = dp.id_pelicula
    INNER JOIN directors d ON dp.id_director = d.id_director
    INNER JOIN actors_pelicules ap ON ap.id_pelicula = p.id_pelicula
    INNER JOIN actors a ON ap.id_actor = a.id_actor
WHERE a.nom = 'Claire' AND a.cognoms = 'Danes';

-- Tasca 2. Mostra el títol de les pel·lícules que almenys han rebut valoració, i la valoració màxima que han rebut. Mostra-les de més valoració a menys.
SELECT p.titol, MAX(cp.valoracio)
FROM pelicules p
    INNER JOIN critics_pelicules cp ON p.id_pelicula = cp.id_pelicula
GROUP BY p.id_pelicula
ORDER BY MAX(cp.valoracio) DESC;

-- Tasca 3. Escriviu una consulta a SQL per trobar el rol de les actrius de les pel·lícules amb una mitjana d’entre 5 i 7 de valoració.
SELECT  ap.rol, AVG(cp.valoracio)
FROM critics_pelicules cp
    INNER JOIN actors_pelicules ap ON ap.id_pelicula = cp.id_pelicula
    INNER JOIN actors a ON ap.id_actor = a.id_actor
WHERE a.genere = 'D'
GROUP BY ap.rol
HAVING AVG(cp.valoracio) BETWEEN 5 AND 7;
#o
SELECT ap.rol, (select AVG(s_cp.valoracio)
                from critics_pelicules s_cp
                WHERE s_cp.id_pelicula = ap.id_pelicula
                GROUP BY s_cp.id_pelicula) AS mitja
FROM actors_pelicules ap
    INNER JOIN actors a ON ap.id_actor = a.id_actor
WHERE a.genere = 'D' AND ((select AVG(s_cp.valoracio)
                from critics_pelicules s_cp
                WHERE s_cp.id_pelicula = ap.id_pelicula
                GROUP BY s_cp.id_pelicula) BETWEEN 5 AND 7);

-- Tasca 4. Mostra els directors que han rebut alguna valoració de 8 ordenats per cognom, nom.
SELECT d.nom, d.cognoms
FROM pelicules p
    INNER JOIN directors_pelicules dp ON p.id_pelicula = dp.id_pelicula
    INNER JOIN directors d ON dp.id_director = d.id_director
    INNER JOIN critics_pelicules cp ON p.id_pelicula = cp.id_pelicula
WHERE cp.valoracio = 8
GROUP BY d.nom, d.cognoms
ORDER BY d.cognoms, d.nom;

-- Tasca 5. De totes les pel·lícules del país UK, mostra el títol, la quantitat d’actors i la valoració mínima. Ordenats de major a menor en valoració.
SELECT titol, MAX(a) AS actors, MAX(b) AS valoracio
FROM (
	SELECT p.titol, COUNT(ap.id_actor) AS a, 0 AS b
	FROM pelicules p
		LEFT JOIN actors_pelicules ap ON ap.id_pelicula = p.id_pelicula
	WHERE p.pais = 'UK'
	GROUP BY p.titol
	UNION
	SELECT p.titol, 0, MIN(cp.valoracio)
	FROM pelicules p
		LEFT JOIN critics_pelicules cp ON p.id_pelicula = cp.id_pelicula
	WHERE p.pais = 'UK'
	GROUP BY p.titol) aa
GROUP BY titol
ORDER BY valoracio DESC;
#o
/*
SELECT DISTINCT p.titol, (SELECT COUNT(*)
				FROM actors_pelicules AS ap
                WHERE ap.id_pelicula = p.id_pelicula)  AS Quantitat_Actors, (SELECT IF (MIN(cp.valoracio) IS NOT NULL,MIN(cp.valoracio),'-No te-')
																				FROM critics_pelicules AS cp
																				WHERE cp.id_pelicula = p.id_pelicula) AS valoracio_MIN
FROM pelicules AS p
LEFT JOIN actors_pelicules AS ap ON p.id_pelicula = ap.id_pelicula
WHERE p.pais = 'UK'
ORDER BY valoracio_MIN DESC;
*/

-- Tasca 6. Mostra els crítics i la mitjana de les puntuacions que han fet, també les pel·lícules i la mitjana de puntuacions obtingudes. Volem les mitjanes inferiors a 5.
SELECT c.nom, AVG(cp.valoracio) AS mitjana
FROM critics c
    INNER JOIN critics_pelicules cp ON c.id_critic = cp.id_critic
GROUP BY c.id_critic
HAVING mitjana < 5
UNION
SELECT p.titol, AVG(cp.valoracio) AS mitjana
FROM pelicules p
    INNER JOIN critics_pelicules cp ON p.id_pelicula = cp.id_pelicula
GROUP BY p.id_pelicula
HAVING mitjana < 5;
