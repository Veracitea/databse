CREATE TABLE Customer(
    Customer_id INT NOT NULL,
    email VARCHAR(55) NOT NULL,
    password VARCHAR(55) NOT NULL,
    username VARCHAR(55) NOT NULL,
    address VARCHAR(55) NULL,
    phone_number VARCHAR(55) NOT NULL,
    PRIMARY KEY (Customer_id),
    UNIQUE (username)
);

CREATE TABLE Shop(
   Shop_id VARCHAR(10) NOT NULL PRIMARY KEY
  ,name    VARCHAR(40) NOT NULL
);
