CREATE TABLE Customer(
    Customer_id INT NOT NULL,
    email VARCHAR(55) NOT NULL,
    password VARCHAR(55) NOT NULL,
    username VARCHAR(55) NOT NULL,
    address VARCHAR(55) NULL,
    phone_number VARCHAR(55) NOT NULL
    PRIMARY KEY (Customer_id),
    UNIQUE (username),
);