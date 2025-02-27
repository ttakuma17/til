-- 最新バージョンのユーザー情報を取得
SELECT * FROM users 
WHERE user_uuid = 'uuid-user-1' 
ORDER BY version DESC 
LIMIT 1;

-- ユーザーの履歴を取得
SELECT * FROM users 
WHERE user_uuid = 'uuid-user-1' 
ORDER BY version ASC;

-- 最新バージョンの公開記事を取得
SELECT * FROM published_articles 
WHERE article_uuid = 'uuid-article-1' 
AND status != 'DELETED'
ORDER BY version DESC 
LIMIT 1;

-- 記事の編集履歴を取得
SELECT * FROM draft_articles 
WHERE article_uuid = 'uuid-article-1' 
ORDER BY version ASC;

-- 特定ユーザーが作成した記事のイベントを取得
SELECT ae.* 
FROM article_events ae
WHERE ae.user_uuid = 'uuid-user-1'
ORDER BY ae.created_at DESC;

-- 非公開にされた記事を取得
SELECT pa.* 
FROM published_articles pa
JOIN unpublished_articles ua ON pa.article_uuid = ua.published_article_uuid
WHERE ua.status = 'CREATED'
ORDER BY pa.version DESC;

-- 特定の記事の状態変更履歴を取得
SELECT ae.event_type, ae.created_at, ae.version
FROM article_events ae
WHERE ae.article_uuid = 'uuid-article-1'
ORDER BY ae.created_at ASC;

-- 削除された公開記事を取得
SELECT * 
FROM published_articles
WHERE status = 'DELETED'
ORDER BY version DESC;
