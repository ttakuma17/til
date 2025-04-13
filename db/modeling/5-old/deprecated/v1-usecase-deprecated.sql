-- 最新のアクティブなユーザー一覧を取得
SELECT u.*
FROM users u
JOIN user_event_end uee ON u.user_event_id = uee.user_event_id
WHERE uee.user_status = 'ACTIVE';

-- 特定のユーザーの詳細情報を取得
SELECT u.*, uee.user_status, ues.created_at AS registration_date, uee.created_at AS status_updated_at
FROM users u
JOIN user_event_start ues ON u.user_event_id = ues.user_event_id
JOIN user_event_end uee ON ues.user_event_id = uee.user_event_id
WHERE u.user_uuid = 'uuid-user-1';

-- 特定の記事の最新バージョンを取得
SELECT a.*, aee.article_status
FROM articles a
JOIN article_event_end aee ON a.article_event_id = aee.article_event_id
WHERE a.article_uuid = 'uuid-article-1'
ORDER BY a.version DESC
LIMIT 1;

-- 特定の記事の全バージョン履歴を取得
SELECT a.*, aee.article_status, aes.created_at AS created_at
FROM articles a
JOIN article_event_start aes ON a.article_event_id = aes.article_event_id
JOIN article_event_end aee ON aes.article_event_id = aee.article_event_id
WHERE a.article_uuid = 'uuid-article-1'
ORDER BY a.version ASC;

-- 公開状態の記事一覧を取得
SELECT a.*, u.name AS author_name, aes.created_at AS created_at
FROM articles a
JOIN article_event_start aes ON a.article_event_id = aes.article_event_id
JOIN article_event_end aee ON aes.article_event_id = aee.article_event_id
JOIN user_article_creates uac ON a.article_event_id = uac.article_event_id
JOIN users u ON uac.user_uuid = u.user_uuid
WHERE aee.article_status = 'PUBLISHED'
ORDER BY aes.created_at DESC;

-- 特定ユーザーが作成した記事一覧を取得
SELECT a.*, aee.article_status, aes.created_at AS created_at
FROM articles a
JOIN article_event_start aes ON a.article_event_id = aes.article_event_id
JOIN article_event_end aee ON aes.article_event_id = aee.article_event_id
JOIN user_article_creates uac ON a.article_event_id = uac.article_event_id
WHERE uac.user_uuid = 'uuid-user-1'
ORDER BY aes.created_at DESC;

-- 各記事の最新バージョンのみを取得
WITH latest_versions AS (
    SELECT article_uuid, MAX(version) AS latest_version
    FROM articles
    GROUP BY article_uuid
)
SELECT a.*, aee.article_status, aes.created_at AS created_at
FROM articles a
JOIN latest_versions lv ON a.article_uuid = lv.article_uuid AND a.version = lv.latest_version
JOIN article_event_start aes ON a.article_event_id = aes.article_event_id
JOIN article_event_end aee ON aes.article_event_id = aee.article_event_id
ORDER BY aes.created_at DESC;

-- 非公開状態の記事一覧を取得
SELECT a.*, u.name AS author_name, aes.created_at AS created_at
FROM articles a
JOIN article_event_start aes ON a.article_event_id = aes.article_event_id
JOIN article_event_end aee ON aes.article_event_id = aee.article_event_id
JOIN user_article_creates uac ON a.article_event_id = uac.article_event_id
JOIN users u ON uac.user_uuid = u.user_uuid
WHERE aee.article_status = 'UNPUBLISHED'
ORDER BY aes.created_at DESC;
