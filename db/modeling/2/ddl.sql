CREATE TABLE Customers
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(32) NOT NULL,
    tel        VARCHAR(15) NOT NULL,
    create_date timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders
(
    id           SERIAL PRIMARY KEY,
    paid         BOOLEAN NOT NULL,
    payment_total INTEGER NOT NULL,
    customer_id  SERIAL,
    create_date   timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date   timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE OrderDetails
(
    id         SERIAL PRIMARY KEY,
    quantity      INTEGER NOT NULL,
    tax        INTEGER NOT NULL,
    order_id   SERIAL,
    product_id SERIAL,
    create_date timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    price               INTEGER     NOT NULL,
    product_category_id SERIAL,
    product_option_id    SERIAL,
    create_date          timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date          timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Options
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    value                VARCHAR(32) NOT NULL,
    create_date          timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date          timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE OrderDetailOptions
(
    id                  SERIAL PRIMARY KEY,
    order_detail_id SERIAL,
    option_id    SERIAL,
    create_date          timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date          timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ProductOptions
(
    id                  SERIAL PRIMARY KEY,
    product_id SERIAL,
    option_id    SERIAL,
    create_date          timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date          timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ProductCategory
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(32) NOT NULL,
    create_date timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date timestamp DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Orders
    ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id)
        REFERENCES Customers (id);

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (order_id)
        REFERENCES Orders (id)
        ON DELETE CASCADE;

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (product_id)
        REFERENCES Products (id);

ALTER TABLE OrderDetailOptions
    ADD CONSTRAINT FK_OrderDetailOptions_OrderDetails FOREIGN KEY (order_detail_id)
        REFERENCES OrderDetails (id);

ALTER TABLE OrderDetailOptions
    ADD CONSTRAINT FK_OrderDetailOptions_Options FOREIGN KEY (option_id)
        REFERENCES Options (id);

ALTER TABLE Products
    ADD CONSTRAINT FK_Products_ProductCategory FOREIGN KEY (product_category_id)
        REFERENCES ProductCategory (id);

ALTER TABLE ProductOptions
    ADD CONSTRAINT FK_ProductOptions_Products FOREIGN KEY (product_id)
        REFERENCES Products (id);

ALTER TABLE ProductOptions
    ADD CONSTRAINT FK_ProductOptions_Options FOREIGN KEY (option_id)
        REFERENCES Options (id);
