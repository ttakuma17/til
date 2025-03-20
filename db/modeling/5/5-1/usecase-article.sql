-- 記事関連のユースケース --
-- 1. 記事の作成から公開、非公開、削除まで
-- 1.1 記事の新規作成（下書き）
INSERT INTO articles (id) VALUES ('article4');

INSERT INTO article_versions (id, article_id, version, title, text)
VALUES ('version6', 'article4', 1, '記事4', '記事4の本文です。');

INSERT INTO article_events (
    id, article_id, event_type_id, user_id
) VALUES (
    'event11', 'article4', 'article_event_type1', 'user3'
);

-- 1.2 記事の更新
WITH latest_version AS (
    SELECT COALESCE(MAX(version), 0) + 1 as next_version
    FROM article_versions
    WHERE article_id = 'article4'
)
INSERT INTO article_versions (id, article_id, version, title, text)
VALUES (
    'version7', 'article4', 2, '記事4の更新', '記事4の本文を更新しました。'
);

INSERT INTO article_events (
    id, article_id, event_type_id, user_id
) VALUES (
    'event12', 'article4', 'article_event_type2', 'user3'
);

-- 1.3 記事の公開
INSERT INTO article_events (
    id, article_id, event_type_id, user_id
) VALUES (
    'event13', 'article4', 'article_event_type3', 'user3'
);

-- 1.4 記事を非公開にする
INSERT INTO article_events (
    id, article_id, event_type_id, user_id
) VALUES (
    'event14', 'article4', 'article_event_type4', 'user3'
);

-- 1.5 記事を削除する
INSERT INTO article_events (
    id, article_id, event_type_id, user_id
) VALUES (
    'event15', 'article4', 'article_event_type5', 'user3'
);

-- 2. 記事の閲覧系
-- 2.1 公開中の記事一覧を取得　
-- 公開中の記事のIDを取得。公開中の記事のIDに重複があるなら、最新日時のものを取得
-- 記事の内容まで取ってないのは、一覧を取得するAPIで内容まですべて取るにはしないという考え。
WITH latest_publish_events AS (
    SELECT 
        article_id,
        occurred_at as published_at
    FROM article_events
    WHERE event_type_id = 'article_event_type3'
),
latest_status_events AS (
    SELECT
        article_id,
        event_type_id,
        occurred_at,
        ROW_NUMBER() OVER (PARTITION BY article_id ORDER BY occurred_at DESC) as rn
    FROM article_events 
    WHERE event_type_id IN ('article_event_type3', 'article_event_type4', 'article_event_type5')
)
SELECT 
    lpe.article_id
FROM latest_publish_events lpe
JOIN latest_status_events lse ON lpe.article_id = lse.article_id
WHERE lse.rn = 1 
AND lse.event_type_id = 'article_event_type3'
AND lse.occurred_at = lpe.published_at;

-- 2.2 特定の記事の履歴を取得
-- 特定の記事IDに紐づく、Eventをすべて取得する
SELECT 
    article_id,
    event_type_id,
    occurred_at
FROM article_events
WHERE article_id = 'article4';

-- 2.3 記事の復元をする場合
-- 2.3 過去バージョンへの復元をシミュレート（article4をバージョン１に戻す）
-- 2.3.1 まず復元したいバージョンの内容を確認
SELECT version, title, text
FROM article_versions
WHERE article_id = 'article4' AND version = 1;

-- 2.3.2 新しいバージョンとして復元
WITH latest_version AS (
    SELECT article_id, COALESCE(MAX(version), 0) + 1 as next_version
    FROM article_versions
    WHERE article_id = 'article4'
    GROUP BY article_id
)
INSERT INTO article_versions (
    id, 
    article_id, 
    version, 
    title, 
    text
)
SELECT 
    'restored_version',
    'article4',
    lv.next_version,
    av.title,
    av.text
FROM latest_version lv
JOIN article_versions av ON av.article_id = lv.article_id
WHERE av.article_id = 'article4'
AND av.version = 1;

-- 復元イベントを記録
INSERT INTO article_events (
    id,
    article_id,
    event_type_id,
    user_id
)
SELECT 
    'restore_event',
    'article4',
    'article_event_type3', 
    'user3';

-- 2.3.3 復元後の状態を確認
SELECT 
    av.version,
    av.title,
    av.text,
    ae.event_type_id,
    ae.occurred_at
FROM article_versions av
JOIN article_events ae ON av.article_id = ae.article_id
WHERE av.article_id = 'article4'
ORDER BY av.version;
