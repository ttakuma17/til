CREATE TABLE Customers
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(32) NOT NULL,
    tel        VARCHAR(15) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders
(
    id           SERIAL PRIMARY KEY,
    paid         BOOLEAN NOT NULL,
    payment_total INTEGER NOT NULL,
    customer_id  SERIAL,
    created_at   timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at   timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE OrderDetails
(
    id         SERIAL PRIMARY KEY,
    quantity      INTEGER NOT NULL,
    tax        INTEGER NOT NULL,
    order_id   SERIAL,
    product_id SERIAL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    price               INTEGER     NOT NULL,
    product_category_id SERIAL,
    product_group_id     SERIAL,
    created_at          timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at          timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ProductCategory
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(32) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ProductGroups
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(32) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Orders
    ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id)
        REFERENCES Customers (id)
        ON DELETE CASCADE;

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (order_id)
        REFERENCES Orders (id)
        ON DELETE CASCADE;

ALTER TABLE Products
    ADD CONSTRAINT FK_Products_ProductCategory FOREIGN KEY (product_category_id)
        REFERENCES ProductCategory (id)
        ON DELETE SET NULL;

ALTER TABLE Products
    ADD CONSTRAINT FK_Products_ProductGroups FOREIGN KEY (product_group_id)
        REFERENCES ProductGroups (id)
        ON DELETE SET NULL;
