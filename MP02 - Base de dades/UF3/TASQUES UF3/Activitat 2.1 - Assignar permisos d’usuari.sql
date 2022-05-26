# Activitat 2.1 - Assignar permisos d’usuari

USE m02_UF3_starwars;

-- Tasca 1. L'usuari yoda és l'administrador, per tant que tingui permís per a fer tot.
GRANT ALL PRIVILEGES ON * TO yoda@localhost;

-- Tasca 2. Connectat amb l’usuari yoda i genera l’estrucura de la base de dades seguint les seguents taules i camps, alhora relaciona-les:
