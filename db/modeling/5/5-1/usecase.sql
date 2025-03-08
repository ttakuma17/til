-- 1. 記事の作成日時を取得するクエリ
SELECT 
    a.id as article_id,
    LEAST(
        MIN(dce.draft_created_date),
        MIN(pe.published_date)
    ) as created_date
FROM articles a
LEFT JOIN draft_creation_events dce ON a.id = dce.article_id
LEFT JOIN article_publication_events pe ON a.id = pe.article_id
GROUP BY a.id;

-- 2. 記事の最終更新日時を取得（全イベントの中で最新のもの）
SELECT 
    a.id as article_id,
    GREATEST(
        MAX(dce.draft_created_date),
        MAX(pe.published_date),
        MAX(ue.unpublished_date)
    ) as last_modified_date
FROM articles a
LEFT JOIN draft_creation_events dce ON a.id = dce.article_id
LEFT JOIN article_publication_events pe ON a.id = pe.article_id
LEFT JOIN article_unpublication_events ue ON a.id = ue.article_id
GROUP BY a.id;

-- 3. 特定の記事（article_id = 'xxx'）の公開履歴を時系列で取得
WITH all_events AS (
    SELECT 
        article_id,
        event_date,
        event_type,
        user_id
    FROM (
        SELECT 
            article_id,
            published_date as event_date,
            'published' as event_type,
            user_id
        FROM article_publication_events
        WHERE article_id = 'xxx'
    ) publication_events
),
event_details AS (
    SELECT 
        ae.article_id,
        ae.event_date,
        ae.event_type,
        CASE 
            WHEN ae.event_type = 'published' THEN p.title
            ELSE NULL
        END as title,
        u.name as user_name,
        ROW_NUMBER() OVER (
            PARTITION BY ae.article_id 
            ORDER BY ae.event_date
        ) as event_sequence
    FROM all_events ae
    LEFT JOIN published_articles p ON ae.article_id = p.article_id
    JOIN users u ON ae.user_id = u.id
)
SELECT 
    event_date,
    event_type,
    title,
    user_name
FROM event_details
ORDER BY event_sequence ASC;

-- 4. 記事の現在の公開状態を確認
WITH publication_status AS (
    SELECT 
        article_id,
        published_date as event_date,
        'published' as status
    FROM article_publication_events ape
    WHERE NOT EXISTS (
        SELECT 1 
        FROM article_unpublication_events aue
        WHERE aue.article_id = ape.article_id
        AND aue.unpublished_date > ape.published_date
    )
)
SELECT 
    a.id as article_id,
    COALESCE(ps.status, 'unpublished') as current_status,
    ps.event_date as last_status_change
FROM articles a
LEFT JOIN publication_status ps ON a.id = ps.article_id;

-- 5. 公開済みの記事を更新する際のトランザクション
BEGIN;

-- 5.1 新しいドラフトを作成
INSERT INTO draft_articles (id, article_id, title, text)
SELECT 
    'new_draft_id',  -- 新しいUUID
    article_id,
    title,
    text
FROM published_articles
WHERE article_id = 'xxx';

-- 5.2 ドラフト作成イベントを記録
INSERT INTO draft_creation_events (
    id, 
    article_id, 
    user_id, 
    draft_created_date
) VALUES (
    'new_event_id',  -- 新しいUUID
    'xxx',           -- 対象記事ID
    'current_user_id', -- 現在のユーザーID
    CURRENT_TIMESTAMP
);

COMMIT;

-- 6. 公開された記事の履歴を取得
WITH publication_events AS (
    SELECT 
        article_id,
        published_date as event_date,
        'published' as event_type,
        user_id,
        ROW_NUMBER() OVER (
            PARTITION BY article_id 
            ORDER BY published_date ASC
        ) as version_number
    FROM article_publication_events
    WHERE article_id = 'xxx'
)
SELECT 
    pe.event_date,
    pe.event_type,
    pe.version_number,
    pa.title,
    u.name as user_name
FROM publication_events pe
JOIN published_articles pa ON pe.article_id = pa.article_id
JOIN users u ON pe.user_id = u.id
ORDER BY pe.event_date ASC;

-- 7.検索
-- 現在公開中の記事をタイトルで検索
WITH current_published AS (
    SELECT 
        article_id,
        MAX(published_date) as latest_publish_date
    FROM article_publication_events
    WHERE NOT EXISTS (
        SELECT 1 
        FROM article_unpublication_events aue
        WHERE aue.article_id = article_publication_events.article_id
        AND aue.unpublished_date > article_publication_events.published_date
    )
    GROUP BY article_id
)
SELECT 
    pa.article_id,
    pa.title,
    cp.latest_publish_date,
    u.name as published_by
FROM published_articles pa
JOIN current_published cp ON pa.article_id = cp.article_id
JOIN article_publication_events ape ON cp.article_id = ape.article_id 
    AND cp.latest_publish_date = ape.published_date
JOIN users u ON ape.user_id = u.id
WHERE pa.title LIKE '%検索キーワード%'
ORDER BY cp.latest_publish_date DESC;


LIKEで検索効率が悪い問題がある

1. 直近の対応 これで解消するならこれだけ
CREATE INDEX idx_published_articles_title ON published_articles(title);

2.曖昧けんさくが要件として必須の場合、全文検索インデックスというものを追加する
-- 1. 全文検索インデックスの追加（PostgreSQLの場合）
ALTER TABLE published_articles ADD COLUMN title_tsv tsvector;
CREATE INDEX idx_published_articles_title_tsv ON published_articles USING gin(title_tsv);

-- トリガーで自動更新
CREATE FUNCTION update_title_tsv() RETURNS trigger AS $$
BEGIN
  NEW.title_tsv := to_tsvector('japanese', NEW.title);
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsvector_update BEFORE INSERT OR UPDATE
ON published_articles FOR EACH ROW EXECUTE FUNCTION update_title_tsv();

3. 頻繁に検索処理が実行されるならマテリアライズドビューの作成（頻繁な検索が必要な場合）
CREATE MATERIALIZED VIEW current_published_articles AS
SELECT 
    pa.article_id,
    pa.title,
    pa.text,
    ape.published_date,
    u.name as published_by
FROM published_articles pa
JOIN (
    SELECT 
        article_id,
        MAX(published_date) as latest_publish_date
    FROM article_publication_events
    WHERE NOT EXISTS (
        SELECT 1 
        FROM article_unpublication_events aue
        WHERE aue.article_id = article_publication_events.article_id
        AND aue.unpublished_date > article_publication_events.published_date
    )
    GROUP BY article_id
) cp ON pa.article_id = cp.article_id
JOIN article_publication_events ape ON cp.article_id = ape.article_id 
    AND cp.latest_publish_date = ape.published_date
JOIN users u ON ape.user_id = u.id;

CREATE INDEX idx_current_published_articles_title ON current_published_articles(title);
