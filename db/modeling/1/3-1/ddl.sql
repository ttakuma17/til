CREATE TABLE customers
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(32) NOT NULL,
    tel        VARCHAR(15) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders
(
    id           SERIAL PRIMARY KEY,
    paid         BOOLEAN NOT NULL,
    payment_total INTEGER NOT NULL,
    customer_id   INTEGER,
    created_at   timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at   timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_details
(
    id         SERIAL PRIMARY KEY,
    quantity   INTEGER NOT NULL,
    subtotal   INTEGER NOT NULL,
    tax_rate   NUMERIC NOT NULL,
    order_id   INTEGER,
    product_id INTEGER,
    campaign_id INTEGER DEFAULT 0,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_detail_options
(
    id         SERIAL PRIMARY KEY,
    order_details_id INTEGER,
    option_id INTEGER,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE options
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    value               VARCHAR(32) NOT NULL,
    created_at          timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at          timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE campaigns
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    discount_rate       NUMERIC NOT NULL,
    campaign_start      timestamp NOT NULL,
    campaign_end        timestamp NOT NULL,
    created_at         timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at         timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    price               INTEGER     NOT NULL,
    product_category_id SERIAL,
    created_at         timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at         timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_categories
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(32) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
        REFERENCES customers (id)
        ON DELETE CASCADE;

ALTER TABLE order_details
    ADD CONSTRAINT fk_order_details_orders FOREIGN KEY (order_id)
        REFERENCES orders (id);

ALTER TABLE order_details
    ADD CONSTRAINT fk_order_details_products FOREIGN KEY (product_id)
        REFERENCES products (id);

ALTER TABLE order_details
    ADD CONSTRAINT fk_order_details_campaigns FOREIGN KEY (campaign_id)
        REFERENCES campaigns (id);

ALTER TABLE order_detail_options
    ADD CONSTRAINT fk_order_detail_options_ordersDetail FOREIGN KEY (order_details_id)
        REFERENCES order_details (id);

ALTER TABLE order_detail_options
    ADD CONSTRAINT fk_order_detail_options_options FOREIGN KEY (option_id)
        REFERENCES options (id);

ALTER TABLE products
    ADD CONSTRAINT fk_products_product_categories FOREIGN KEY (product_category_id)
        REFERENCES product_categories (id);
