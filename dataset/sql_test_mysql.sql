-- Crear el esquema mini_project
DROP SCHEMA IF EXISTS mini_project;
CREATE SCHEMA IF NOT EXISTS mini_project;

-- Usar el esquema mini_project
USE mini_project;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    surname VARCHAR(128) NOT NULL
);

-- Table: chargers
CREATE TABLE IF NOT EXISTS chargers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    label VARCHAR(128) NOT NULL,
    type ENUM('AC', 'DC') NOT NULL DEFAULT 'AC'
);

-- Table: sessions
CREATE TABLE IF NOT EXISTS sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    charger_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (charger_id) REFERENCES chargers(id)
);

-- Insert data into users table
INSERT INTO users (id, name, surname) VALUES
    (1, 'John', 'Doe'),
    (2, 'Jane', 'Smith'),
    (3, 'Michael', 'Johnson'),
    (4, 'Patricia', 'Brown'),
    (5, 'Robert', 'Jones'),
    (6, 'Linda', 'Garcia'),
    (7, 'David', 'Martinez'),
    (8, 'Barbara', 'Rodriguez'),
    (9, 'James', 'Wilson'),
    (10, 'Maria', 'Davis');

-- Insert data into chargers table
INSERT INTO chargers (id, label, type) VALUES
    (1, 'Home #1', 'AC'),
    (2, 'Home #2', 'DC'),
    (3, 'Home #3', 'AC'),
    (4, 'Home #4', 'DC'),
    (5, 'Home #5', 'AC'),
    (6, 'Office #1', 'DC'),
    (7, 'Office #2', 'AC'),
    (8, 'Office #3', 'DC'),
    (9, 'Office #4', 'AC'),
    (10, 'Office #5', 'DC');

