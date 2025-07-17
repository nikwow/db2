CREATE DATABASE procedure01;
USE procedure01;

CREATE TABLE clients (
    id_clients INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    CPF VARCHAR (11)
);

CREATE TABLE orders (
    id_order INT PRIMARY KEY AUTO_INCREMENT,
    dte DATE,
    total DOUBLE,
    id_clients INT,
    CONSTRAINT fk_client FOREIGN KEY (id_clients) REFERENCES clients (id_clients)
);

INSERT INTO clients (name, CPF) VALUES ("Luis Filipe", "11111111111");
INSERT INTO clients (name, CPF) VALUES ("Fayssal Araujo", "22222222222");

INSERT INTO orders (dte, total, id_clients) VALUES ('2023-01-15', 150.75, 1);
INSERT INTO orders (dte, total, id_clients) VALUES ('2023-02-20', 200.00, 1);
INSERT INTO orders (dte, total, id_clients) VALUES ('2023-03-10', 50.25, 2);

DELIMITER $$
    CREATE PROCEDURE get_orders(IN id INT)
    BEGIN
        SELECT
            id_order as 'Order Number',
            dte as 'Order Date',
            total as 'Total Order Value'
        FROM
            orders
        WHERE
            id_clients = id;
    end $$
DELIMITER ;

CALL get_orders(1);
CALL get_orders(2);