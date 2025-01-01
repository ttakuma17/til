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

INSERT INTO orders (paid, subtotal, tax_amount, total, customer_id)
VALUES
    (true, 3956, 344,4300, 1),
    (false, 11000, 880,11880, 2),
    (false, 3726, 324,4050, 1);

INSERT INTO options (name, value)
VALUES
    ('わさび', 'あり'),
    ('わさび', 'なし'),
    ('シャリ', '小'),
    ('シャリ', '大');

INSERT INTO campaigns (name, campaign_type, campaign_start, campaign_end)
VALUES
    ('年末年始1皿10円オフキャンペーン', 'fixed', '2024-12-30 00:00:00', '2025-01-01 23:59:59'),
    ('年末年始10%オフキャンペーン', 'rate', '2024-12-30 00:00:00', '2025-01-03 23:59:59');

INSERT INTO fixed_discount_campaigns(campaign_id, discount_amount)
VALUES (1, 10);

INSERT INTO rate_discount_campaigns(campaign_id, discount_rate)
VALUES (2, 0.9);

INSERT INTO order_details (sales_unit_price, quantity, tax_rate, order_id, product_id)
VALUES
    (100, 10,0.08, 1, 1),
    (220, 15, 0.08, 1, 5),
    (600, 9, 0.08, 2, 10),
    (1080, 5, 0.08, 2, 10),
    (520, 7, 0.08, 2, 9),
    (390, 4, 0.08, 2, 6),
    (1280, 1 ,0.08, 2, 13),
    (90, 10,0.08, 3, 1),
    (210, 15, 0.08, 3, 5);

INSERT INTO order_detail_options (order_details_id, option_id)
VALUES
    (1, 2),
    (4, 2);

INSERT INTO public.order_detail_campaigns (order_details_id, campaign_id)
VALUES
    (8, 1),
    (9, 1);
