# DAM M02 UF3
# Activitat 1.1 Gestionar usuaris

-- Tasca 2. BD M02 UF3
SHOW DATABASES;
DROP DATABASE IF EXISTS m02_UF3_starwars;
CREATE DATABASE m02_UF3_starwars;
USE m02_UF3_starwars;
-- Tasca 3. Usuari Luke
CREATE USER luke;

-- Tasca 4. Usuari Yoda
CREATE USER yoda@localhost;

-- Tasca 5. Usuari Leia
CREATE USER leia IDENTIFIED BY 'rebel';

-- Tasca 6. Usuari Obi
# IP: 127.0.0.1
CREATE USER obi@'127.0.0.1';

-- Tasca 7. Usuari Chewbacca
CREATE USER chewbacca @'127.0.0.1' IDENTIFIED BY 'chewe';

-- Tasca 8. Usuari Darth Vader

-- Tasca 9. Revisa els usuaris creats
SELECT User, Host, Password
FROM mysql.user;

-- Tasca 10. Connectat

-- Tasca 11. Elimina usuaris
DROP USER luke;
DROP USER chewbacca @'127.0.0.1';

-- Tasca 12. Usuari Obi-Wan Kenobi
RENAME USER obi@'127.0.0.1' TO 'obi-wan.kenobi';

-- Tasca 13. Usuari Leia Organa
RENAME USER leia TO 'leia.organa';

-- Tasca 14. Contrasenya usuari Darth Vader

-- Tasca 15. Contrasenya usuari Yoda
SET PASSWORD FOR yoda@localhost = PASSWORD('força');

-- Tasca 16. Contrasenya usuari Obi-Wan Kenobi
ALTER USER 'obi-wan.kenobi' IDENTIFIED BY 'mestre';

-- Tasca 17. Revisa els usuaris modificats
SELECT User, Host, Password
FROM mysql.user;

-- Tasca 18. Connectat amb els usuaris modificats