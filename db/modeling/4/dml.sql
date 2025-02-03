INSERT INTO interval_types (name, max_value) VALUES
    ('hour', 24),
    ('day', 7);

-- TODO 24時間間隔と1日間隔は同じなので、データとしては23時間までとかに制御してもいいかも
INSERT INTO interval_settings (interval_type_id, interval) VALUES
    (1, 12),
    (1, 24),
    (2, 1),
    (2, 7);

INSERT INTO clients (slack_id) VALUES
    ('U1234567890'),
    ('U2345678901'),
    ('U3456789012');

INSERT INTO representatives (slack_id) VALUES
    ('U9876543210'),
    ('U8765432109'),
    ('U7654321098');

INSERT INTO tasks (content) VALUES
    ('タスク1'),
    ('タスク2'),
    ('タスク3');

INSERT INTO reminds (
    content,
    done,
    client_id,
    representative_id,
    task_id,
    interval_setting_id
) VALUES
    ('タスク1をしてください', FALSE, 1, 1, 1, 1),
    ('タスク2を準備してください', FALSE, 2, 2, 2, 3),
    ('タスク3はまだですか', FALSE, 3, 3, 3, 4);
