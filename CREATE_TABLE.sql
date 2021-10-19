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

CREATE TABLE restricted_to_sell(
   Product_Type_id VARCHAR(55) NOT NULL
  ,Shop_id         VARCHAR(10) NOT NULL
  ,PRIMARY KEY(Product_Type_id,Shop_id)
  ,FOREIGN KEY (Product_Type_id) REFERENCES Product_Type(Product_Type_id)
   ON DELETE CASCADE ON UPDATE CASCADE
   ,FOREIGN KEY (Shop_id) REFERENCES Shop(Shop_id)
   ON DELETE CASCADE ON UPDATE CASCADE
);
-----------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Photo(
   Photo_ID   VARCHAR(55) NOT NULL PRIMARY KEY
  ,image_url  VARCHAR(2000) NOT NULL
  ,Product_ID VARCHAR(55) NOT NULL
  UNIQUE (image_url, Product_ID)
);

CREATE TABLE Product(
   Product_id      VARCHAR(55) NOT NULL PRIMARY KEY
  ,name            VARCHAR(55) NOT NULL
  ,color           VARCHAR(55) NOT NULL
  ,size            VARCHAR(55) NOT NULL
  ,price           INTEGER  NOT NULL
  ,description     VARCHAR(55) NOT NULL
  ,Shop_id         VARCHAR(55) NOT NULL
  ,Product_Type_id VARCHAR(55) NOT NULL
  UNIQUE (Shop_id, name, color, size)
  UNIQUE (description)
);