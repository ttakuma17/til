INSERT INTO ProductCategory (name)
VALUES
    ('セットメニュー'),
    ('お好みすし');

INSERT INTO Products (name, price, product_category_id)
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

INSERT INTO Customers (name, tel)
VALUES
    ('すずき　たろう', '090-1234-5678'),
    ('さとう　じろう', '090-1234-5679');

INSERT INTO Orders (paid, payment_total, customer_id)
VALUES
    (true, 4300, 1),
    (false, 1640, 2);

INSERT INTO OrderDetails (quantity, subtotal, tax, order_id, product_id, campaign_id)
VALUES
    (10, 1000 ,8, 1, 1, 1),
    (15, 3300, 8, 1, 5, 1),
    (2, 360, 8, 2, 7, 1),
    (1, 1280 ,8, 2, 13, 1);

INSERT INTO Options (name, value)
VALUES
    ('わさび', 'あり'),
    ('わさび', 'なし'),
    ('シャリ', '小'),
    ('シャリ', '大');

INSERT INTO OrderDetailsOptions (order_details_id, option_id)
VALUES
    (1280, 1);

INSERT INTO OrderDetailsOptions (order_details_id, option_id)
VALUES
    (1, 2),
    (2, 4);

INSERT INTO Campaign (name, discount_rate, campaign_start, campaign_end)
VALUES
    ('年末年始10%オフキャンペーン',10, '2024-12-30 00:00:00', '2025-01-01 23:59:59');
