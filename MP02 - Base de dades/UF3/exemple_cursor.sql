CREATE DATABASE exemple_cursor;
USE exemple_cursor;
CREATE TABLE alumne
    (id		INT				PRIMARY KEY AUTO_INCREMENT,
    nom		VARCHAR(20),
    cognoms	VARCHAR(20)
);
INSERT INTO alumne VALUES (NULL,'Anna','Bosch');
INSERT INTO alumne VALUES (NULL,'Francesc','Bonmatí');
INSERT INTO alumne VALUES (NULL,'Carme','Camí');

DELIMITER //
CREATE PROCEDURE exemple_cursor1()
BEGIN
    DECLARE final INT DEFAULT 0;
    DECLARE var_codi INT;
    DECLARE var_nom VARCHAR(20);
    DECLARE nom_cursor CURSOR FOR SELECT id, nom FROM alumne WHERE cognoms LIKE 'B%';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET final=1;

    OPEN nom_cursor;
    bucle: LOOP
        FETCH FROM nom_cursor INTO var_codi, var_nom;
        IF final=1 THEN
            LEAVE bucle;
        END IF;
        SELECT var_codi,var_nom;
    END LOOP;
    CLOSE nom_cursor;
END //
DELIMITER ;

CALL exemple_cursor1();
