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


CREATE TABLE Product(
   Product_id      VARCHAR(55) NOT NULL PRIMARY KEY
  ,name            VARCHAR(55) NOT NULL
  ,color           VARCHAR(55) NOT NULL
  ,size            VARCHAR(55) NOT NULL
  ,price           INTEGER  NOT NULL
  ,description     VARCHAR(55) NOT NULL
  ,Shop_id         VARCHAR(10) NOT NULL
  ,Product_Type_id VARCHAR(55) NOT NULL
  ,UNIQUE (Shop_id, name, color, size)
  ,UNIQUE (description)
   ,FOREIGN KEY (Shop_id) REFERENCES Shop(Shop_id)
   ON DELETE CASCADE ON UPDATE CASCADE
   ,FOREIGN KEY (Product_Type_id) REFERENCES Product_Type(Product_Type_id)
   ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Photo(
   Photo_ID   VARCHAR(55) NOT NULL PRIMARY KEY
  ,image_url  VARCHAR(2000) NOT NULL
  ,Product_ID VARCHAR(55) NOT NULL
  ,UNIQUE (image_url, Product_ID)
   ,FOREIGN KEY (Product_ID) REFERENCES Product(Product_id)
   ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Shipment(
   Shipment_id     VARCHAR(55) NOT NULL PRIMARY KEY
  ,tracking_number VARCHAR(55) NOT NULL
  ,date            DATETIME  NOT NULL
  ,UNIQUE (tracking_number)
);

CREATE TABLE CreditCard(
   CreditCard_number VARCHAR(55) NOT NULL PRIMARY KEY
  ,ExpireDate        DATETIME  NOT NULL
  ,Customer_id       INT  NOT NULL
   ,FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
   ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Orders(
   Order_id    VARCHAR(55) NOT NULL PRIMARY KEY
  ,date        DATETIME  NOT NULL
  ,status      VARCHAR(55) NOT NULL
  ,Customer_id INT  NOT NULL
   ,FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
   ON DELETE CASCADE ON UPDATE CASCADE
);
--order is keyword issue
--solved

CREATE TABLE Invoice(
   Invoice_number VARCHAR(55) NOT NULL PRIMARY KEY
  ,status         VARCHAR(55) NOT NULL
  ,date           DATETIME  NOT NULL
  ,Order_id       VARCHAR(55) NOT NULL
  ,UNIQUE (Order_id)
   ,FOREIGN KEY (Order_id) REFERENCES Orders(Order_id)   
   ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE Order_item(
   Order_id    VARCHAR(55) NOT NULL
  ,seq_id      INT  NOT NULL
  ,unit_price  INT  NOT NULL
  ,quantity    INT  NOT NULL
  ,status      VARCHAR(55) NOT NULL
  ,Shipment_id VARCHAR(55)
  ,Product_id  VARCHAR(55) NOT NULL
  ,PRIMARY KEY(Order_id,seq_id)
  ,UNIQUE (Order_id, Product_id)
   ,FOREIGN KEY (Order_id) REFERENCES Orders(Order_id)
   ON DELETE CASCADE ON UPDATE CASCADE
   ,FOREIGN KEY (Product_id) REFERENCES Product(Product_id)
   ON DELETE CASCADE ON UPDATE CASCADE
   ,FOREIGN KEY (Shipment_id) REFERENCES Shipment(Shipment_id)
   ON DELETE CASCADE ON UPDATE CASCADE
); --cust id fk issue

CREATE TABLE Payment(
   Payment_id        VARCHAR(55) NOT NULL PRIMARY KEY
  ,date              DATETIME  NOT NULL
  ,amount            INT  NOT NULL
  ,CreditCard_number VARCHAR(55)  NOT NULL
  ,Invoice_number    VARCHAR(55) NOT NULL
   ,FOREIGN KEY (CreditCard_number) REFERENCES CreditCard(CreditCard_number)
   ON DELETE CASCADE ON UPDATE CASCADE
   ,FOREIGN KEY (Invoice_number) REFERENCES Invoice(Invoice_number)
   ON DELETE CASCADE ON UPDATE CASCADE
); --can only choose 1 fk issue
