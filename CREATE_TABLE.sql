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


CREATE TABLE Product_Type(
   Product_Type_id        VARCHAR(55) NOT NULL PRIMARY KEY
  ,description            VARCHAR(55) NOT NULL
  ,parent_product_type_id VARCHAR(55) NULL
);

CREATE TABLE IF NOT EXISTS restricted_to_sell(
   Product_Type_id VARCHAR(55) NOT NULL
  ,Shop_id         VARCHAR(55) NOT NULL
  ,PRIMARY KEY(Product_Type_id,Shop_id)
);