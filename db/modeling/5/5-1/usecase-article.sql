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

























-- 1. 1000文字程度の本文を記入して保存できることの確認
-- 1000文字のテストデータを作成
WITH test_article AS (
    INSERT INTO articles (id) VALUES ('test_long_article') RETURNING id
)
INSERT INTO article_versions (id, article_id, title, text)
SELECT 
    'test_long_version',
    id,
    '長文テスト',
    repeat('これはテスト文章です。', 100) -- 1000文字以上のテキスト
FROM test_article;

-- 保存された文章の長さを確認
SELECT 
    id,
    title,
    length(text) as text_length,
    text
FROM article_versions 
WHERE article_id = 'test_long_article';

-- 2. 記事の履歴管理のテスト
-- 2.1 記事の更新履歴が正しく保存されているか確認（article1を使用）
SELECT 
    av.version,
    av.title,
    av.text,
    av.created_at,
    ae.event_type_id,
    ae.status,
    up.name as modified_by_user
FROM article_versions av
JOIN article_events ae ON av.article_id = ae.article_id 
    AND av.version = ae.version
JOIN user_profile_versions up ON ae.user_id = up.user_id
WHERE av.article_id = 'article1'
ORDER BY av.version;

-- 2.2 特定の記事の履歴一覧表示（article3を使用 - 作成→公開→更新→削除の履歴がある）
WITH version_history AS (
    SELECT 
        av.version,
        av.title,
        av.text,
        av.created_at,
        ae.event_type_id,
        ae.status,
        ae.occurred_at,
        up.name as modified_by_user,
        ROW_NUMBER() OVER (PARTITION BY up.user_id ORDER BY up.version DESC) as user_version_rn
    FROM article_versions av
    JOIN article_events ae ON av.article_id = ae.article_id 
        AND av.version = ae.version
    JOIN user_profile_versions up ON ae.user_id = up.user_id
    WHERE av.article_id = 'article3'
)
SELECT 
    version,
    title,
    text,
    created_at,
    event_type_id,
    status,
    occurred_at,
    modified_by_user
FROM version_history
WHERE user_version_rn = 1
ORDER BY version;

-- 2.3 過去バージョンへの復元をシミュレート（article3の第1バージョンに戻す）
-- 2.3.1 まず復元したいバージョンの内容を確認
SELECT version, title, text
FROM article_versions
WHERE article_id = 'article3' AND version = 1;

-- 2.3.2 新しいバージョンとして復元
WITH latest_version AS (
    SELECT COALESCE(MAX(version), 0) + 1 as next_version
    FROM article_versions
    WHERE article_id = 'article3'
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
    'article3',
    next_version,
    title,
    text
FROM article_versions
WHERE article_id = 'article3' 
AND version = 1;

-- 復元イベントを記録
INSERT INTO article_events (
    id,
    article_id,
    event_type_id,
    user_id,
    version,
    status
)
SELECT 
    'restore_event',
    'article3',
    'article_event_type2', -- VERSION
    'user1',
    (SELECT MAX(version) FROM article_versions WHERE article_id = 'article3'),
    'draft';

-- 2.3.3 復元後の状態を確認
SELECT 
    av.version,
    av.title,
    av.text,
    ae.event_type_id,
    ae.status,
    ae.occurred_at
FROM article_versions av
JOIN article_events ae ON av.article_id = ae.article_id 
    AND av.version = ae.version
WHERE av.article_id = 'article3'
ORDER BY av.version;

-- 3. 最新状態の公開記事一覧表示
WITH latest_article_states AS (
    SELECT 
        ae.article_id,
        ae.status,
        ae.occurred_at,
        ae.user_id,
        ROW_NUMBER() OVER (
            PARTITION BY ae.article_id 
            ORDER BY ae.occurred_at DESC
        ) as rn
    FROM article_events ae
),
latest_versions AS (
    SELECT 
        article_id,
        MAX(version) as latest_version
    FROM article_versions
    GROUP BY article_id
)
SELECT 
    a.id,
    av.title,
    av.text,
    av.version,
    av.created_at,
    up.name as author_name,
    las.status as current_status
FROM articles a
JOIN latest_versions lv ON a.id = lv.article_id
JOIN article_versions av ON a.id = av.article_id 
    AND av.version = lv.latest_version
JOIN latest_article_states las ON a.id = las.article_id
    AND las.rn = 1
JOIN user_profile_versions up ON las.user_id = up.user_id
WHERE las.status = 'published'
AND up.version = (
    SELECT MAX(version)
    FROM user_profile_versions
    WHERE user_id = las.user_id
)
ORDER BY av.created_at DESC;

-- 4. テストデータのクリーンアップ（必要な場合）
DELETE FROM article_events WHERE article_id = 'test_long_article';
DELETE FROM article_versions WHERE article_id = 'test_long_article';
DELETE FROM articles WHERE id = 'test_long_article';
