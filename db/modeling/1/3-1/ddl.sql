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
    customer_id   INTEGER,
    create_date   timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date   timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE OrderDetails
(
    id         SERIAL PRIMARY KEY,
    quantity   INTEGER NOT NULL,
    subtotal   INTEGER NOT NULL,
    tax        INTEGER NOT NULL,
    order_id   INTEGER,
    product_id INTEGER,
    campaign_id INTEGER DEFAULT 0,
    create_date timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE OrderDetailsOptions
(
    id         SERIAL PRIMARY KEY,
    order_details_id INTEGER,
    option_id INTEGER,
    create_date timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Options
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    value               VARCHAR(32) NOT NULL,
    create_date          timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date          timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Campaign
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    discount_rate       INTEGER NOT NULL,
    campaign_start      timestamp NOT NULL,
    campaign_end        timestamp NOT NULL,
    create_date         timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date         timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    price               INTEGER     NOT NULL,
    product_category_id SERIAL,
    create_date         timestamp DEFAULT CURRENT_TIMESTAMP,
    update_date         timestamp DEFAULT CURRENT_TIMESTAMP
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
        REFERENCES Customers (id)
        ON DELETE CASCADE;

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (order_id)
        REFERENCES Orders (id);

ALTER TABLE OrderDetailsOptions
    ADD CONSTRAINT FK_OrderDetailsOptions_OrdersDetail FOREIGN KEY (order_details_id)
        REFERENCES OrderDetails (id);

ALTER TABLE OrderDetailsOptions
    ADD CONSTRAINT FK_OrderDetailsOptions_Options FOREIGN KEY (option_id)
        REFERENCES Options (id);

ALTER TABLE Products
    ADD CONSTRAINT FK_Products_ProductCategory FOREIGN KEY (product_category_id)
        REFERENCES ProductCategory (id);
