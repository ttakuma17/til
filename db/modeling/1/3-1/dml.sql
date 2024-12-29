INSERT INTO ProductCategory (name)
VALUES
    ('セットメニュー'),
    ('お好みすし');

INSERT INTO ProductGroups (name)
VALUES
    ('玉子'),
    ('えび'),
    ('生サーモン'),
    ('ゆでげそ'),
    ('あじ'),
    ('いくら'),
    ('活ヒラメ'),
    ('中トロ'),
    ('あなご一本ずし'),
    ('うに'),
    ('はな'),
    ('みさき'),
    ('海鮮ちらし'),
    ('鮨八宝巻');

INSERT INTO Products (name, price, product_category_id, product_group_id)
VALUES
    ('玉子', 100, 2, 1),
    ('玉子(シャリ小)', 100, 2, 1),
    ('玉子(シャリ大)', 100, 2, 1),
    ('玉子(さびぬき)', 100, 2, 1),
    ('玉子(さびぬき - シャリ小)', 100, 2, 1),
    ('玉子(さびぬき - シャリ大)', 100, 2, 1),
    ('えび', 180, 2, 2),
    ('えび(シャリ小)', 180, 2, 2),
    ('えび(シャリ大)', 180, 2, 2),
    ('えび(さびぬき)', 180, 2, 2),
    ('えび(さびぬき - シャリ小)', 180, 2, 2),
    ('えび(さびぬき - シャリ大)', 180, 2, 2),
    ('生サーモン', 180, 2, 3),
    ('生サーモン(シャリ小)', 220, 2, 3),
    ('生サーモン(シャリ大)', 220, 2, 3),
    ('生サーモン(さびぬき)', 220, 2, 3),
    ('生サーモン(さびぬき - シャリ小)', 220, 2, 3),
    ('生サーモン(さびぬき - シャリ大)', 220, 2, 3),
    ('ゆでげそ', 150, 2, 4),
    ('ゆでげそ(シャリ小)', 150, 2, 4),
    ('ゆでげそ(シャリ大)', 150, 2, 4),
    ('ゆでげそ(さびぬき)', 150, 2, 4),
    ('ゆでげそ(さびぬき - シャリ小)', 150, 2, 4),
    ('ゆでげそ(さびぬき - シャリ大)', 150, 2, 4),
    ('あじ', 260, 2, 5),
    ('あじ(シャリ小)', 260, 2, 5),
    ('あじ(シャリ大)', 260, 2, 5),
    ('あじ(さびぬき)', 260, 2, 5),
    ('あじ(さびぬき - シャリ小)', 260, 2, 5),
    ('あじ(さびぬき - シャリ大)', 260, 2, 5),
    ('いくら', 260, 2, 6),
    ('いくら(シャリ小)', 260, 2, 6),
    ('いくら(シャリ大)', 260, 2, 6),
    ('いくら(さびぬき)', 260, 2, 6),
    ('いくら(さびぬき - シャリ小)', 260, 2, 6),
    ('いくら(さびぬき - シャリ大)', 260, 2, 6),
    ('はな', 8650, 1, 11),
    ('はな(さびぬき)', 8650, 1, 11),
    ('みさき', 1940, 1, 12),
    ('みさき(さびぬき)', 1940, 1, 12),
    ('海鮮ちらし', 1280, 1, 13),
    ('海鮮ちらし(さびぬき)', 1280, 1, 13),
    ('鮨八宝巻', 1280, 1, 14),
    ('鮨八宝巻（さびぬき）', 1280, 1, 14);

INSERT INTO Customers (name, tel)
VALUES
    ('すずき　たろう', '090-1234-5678'),
    ('さとう　じろう', '090-1234-5679');

INSERT INTO Orders (paid, payment_total, customer_id)
VALUES
    (TRUE, 4300, 1),
    (FALSE, 1640, 2);

INSERT INTO OrderDetails (id, quantity, tax, order_id, product_id)
VALUES
    (1, 10, 0.8, 1, 1), -- 100 * 10
    (2, 15, 0.8, 1, 17), -- 220 * 15
    (3, 2, 0.8, 2, 8), -- 180 * 2
    (4, 1, 0.8, 2, 40); -- 1280 * 1

