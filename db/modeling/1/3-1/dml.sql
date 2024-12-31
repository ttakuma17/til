INSERT INTO product_categories (name)
VALUES
    ('セットメニュー'),
    ('お好みすし');

INSERT INTO products (name, price, product_category_id)
VALUES
    ('玉子', 100, 2),
    ('えび', 180, 2),
    ('生サーモン', 180, 2),
    ('ゆでげそ', 150, 2),
    ('あじ', 220, 2),
    ('いくら', 260, 2),
    ('活ヒラメ', 360, 2),
    ('中トロ', 460, 2),
    ('あなご一本ずし', 520, 2),
    ('うに', 600, 2),
    ('はな', 8650, 1),
    ('みさき', 1940, 1),
    ('海鮮ちらし', 1280, 1),
    ('鮨八宝巻', 1280, 1);

INSERT INTO customers (name, tel)
VALUES
    ('すずき　たろう', '090-1234-5678'),
    ('さとう　じろう', '090-1234-5679');

INSERT INTO orders (paid, payment_total, customer_id)
VALUES
    (true, 4300, 1),
    (false, 11880, 2);

INSERT INTO options (name, value)
VALUES
    ('わさび', 'あり'),
    ('わさび', 'なし'),
    ('シャリ', '小'),
    ('シャリ', '大');

INSERT INTO campaigns (name, discount_rate, campaign_start, campaign_end)
VALUES
    ('年末年始10%オフキャンペーン',10, '2024-12-30 00:00:00', '2025-01-01 23:59:59'),
    ('年末年始50%オフキャンペーン',50, '2024-12-30 00:00:00', '2025-01-03 23:59:59');;

INSERT INTO order_details (quantity, subtotal, tax_rate, order_id, product_id, campaign_id)
VALUES
    (10, 1000 ,0.08, 1, 1, 1),
    (15, 3300, 0.08, 1, 5, 1),
    (9, 5400, 0.08, 2, 10, 2),
    (5, 5400, 0.08, 2, 10, 1),
    (7, 3640, 0.08, 2, 9, 2),
    (4, 1560, 0.08, 2, 6, 2),
    (1, 1280 ,0.08, 2, 13, 2);

INSERT INTO order_detail_options (order_details_id, option_id)
VALUES
    (1, 2),
    (4, 2);

INSERT INTO order_detail_options (order_details_id, option_id)
VALUES
    (1, 2),
    (4, 2);