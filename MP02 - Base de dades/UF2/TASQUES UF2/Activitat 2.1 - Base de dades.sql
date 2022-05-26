#Activitat 2.1 - Base de Dades
-- Tasca 1. Hello World
	# Crea una base de dades anomenada hello_world si no existeix al teu sistema.	
	# A continuació, elimina la base de dades creada.
CREATE DATABASE IF NOT EXISTS hello_world;
DROP DATABASE hello_world;
-- Tasca 2. BD M02 UF2
	# Un cop dins de l’entorn SQL, mostra les bases de dades del teu sistema. 
    # Crea una base de dades anomenada m02_uf2 i introdueix l’ordre per indicar que vols treballar amb aquesta base de dades.
SHOW DATABASES;
CREATE DATABASE m02_uf2;
USE m02_uf2;
-- Tasca 3. Usuari amb privilegis
	# Crea un usuari amb el teu nom que disposi de tots els privilegis sobre la base de dades creada a la Tasca 2. BD M02 UF2.
CREATE USER 'alumne'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON m02_uf2.* TO 'alumne'@'localhost';

