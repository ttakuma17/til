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
    id            SERIAL PRIMARY KEY,
    paid          BOOLEAN NOT NULL,
    subtotal      INTEGER NOT NULL,
    tax_amount    INTEGER NOT NULL,
    total         INTEGER NOT NULL,
    customer_id   INTEGER,
    created_at    timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at    timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_details
(
    id         SERIAL PRIMARY KEY,
    sales_unit_price INTEGER NOT NULL,
    quantity   INTEGER NOT NULL,
    tax_rate   NUMERIC NOT NULL,
    order_id   INTEGER,
    product_id INTEGER,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_detail_options
(
    id               SERIAL PRIMARY KEY,
    order_details_id INTEGER,
    option_id        INTEGER,
    created_at       timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at       timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE options
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(32) NOT NULL,
    value      VARCHAR(32) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_detail_campaigns
(
    id               SERIAL PRIMARY KEY,
    order_details_id INTEGER,
    campaign_id      INTEGER,
    created_at       timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at       timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE campaigns
(
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(32) NOT NULL,
    campaign_type   VARCHAR(32) NOT NULL,
    campaign_start  timestamp   NOT NULL,
    campaign_end    timestamp   NOT NULL,
    created_at      timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at      timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fixed_discount_campaigns
(
    id              SERIAL PRIMARY KEY,
    campaign_id     INTEGER NOT NULL,
    discount_amount INTEGER NOT NULL,
    created_at      timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at      timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rate_discount_campaigns
(
    id            SERIAL PRIMARY KEY,
    campaign_id   INTEGER NOT NULL,
    discount_rate NUMERIC NOT NULL,
    created_at      timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at      timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products
(
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(32) NOT NULL,
    price               INTEGER     NOT NULL,
    product_category_id SERIAL,
    created_at          timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at          timestamp DEFAULT CURRENT_TIMESTAMP
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

ALTER TABLE order_detail_options
    ADD CONSTRAINT fk_order_detail_options_order_details FOREIGN KEY (order_details_id)
        REFERENCES order_details (id);

ALTER TABLE order_detail_options
    ADD CONSTRAINT fk_order_detail_options_options FOREIGN KEY (option_id)
        REFERENCES options (id);

ALTER TABLE products
    ADD CONSTRAINT fk_products_product_categories FOREIGN KEY (product_category_id)
        REFERENCES product_categories (id);

ALTER TABLE order_detail_campaigns
    ADD CONSTRAINT fk_order_detail_campaigns_order_details FOREIGN KEY (order_details_id)
        REFERENCES order_details (id);

ALTER TABLE order_detail_campaigns
    ADD CONSTRAINT fk_order_detail_campaigns_campaigns FOREIGN KEY (campaign_id)
        REFERENCES campaigns (id);

ALTER TABLE fixed_discount_campaigns
    ADD CONSTRAINT fk_fixed_discount_campaigns_campaigns FOREIGN KEY (campaign_id)
        REFERENCES campaigns (id);

ALTER TABLE rate_discount_campaigns
    ADD CONSTRAINT fk_rate_discount_campaigns_campaigns FOREIGN KEY (campaign_id)
        REFERENCES campaigns (id);
