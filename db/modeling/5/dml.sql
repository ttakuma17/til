-- 新規ユーザーの作成
INSERT INTO users (id, user_uuid, name, email, status, version)
VALUES ('u1', 'uuid-user-1', 'John Doe', 'john@example.com', 'ACTIVE', 1);

-- ユーザー情報の更新（新しいバージョンとして挿入）
INSERT INTO users (id, user_uuid, name, email, status, version)
VALUES ('u2', 'uuid-user-1', 'John Doe', 'john.updated@example.com', 'ACTIVE', 2);

-- ユーザーステータスの変更
INSERT INTO users (id, user_uuid, name, email, status, version)
VALUES ('u3', 'uuid-user-1', 'John Doe', 'john.updated@example.com', 'INACTIVE', 3);

-- ユーザーイベントの記録
INSERT INTO user_events (id, user_uuid, event_type, created_at, version)
VALUES ('ue1', 'uuid-user-1', 'REGISTERED', CURRENT_TIMESTAMP, 1);

INSERT INTO user_events (id, user_uuid, event_type, created_at, version)
VALUES ('ue2', 'uuid-user-1', 'UPDATED', CURRENT_TIMESTAMP, 2);

INSERT INTO user_events (id, user_uuid, event_type, created_at, version)
VALUES ('ue3', 'uuid-user-1', 'DEACTIVATED', CURRENT_TIMESTAMP, 3);

-- 記事関連のDMLクエリ
-- 下書き記事の作成
INSERT INTO draft_articles (id, article_uuid, title, content, status, version)
VALUES ('da1', 'uuid-article-1', '初めての記事', 'これは記事の内容です。', 'CREATED', 1);

-- 下書き記事の更新
INSERT INTO draft_articles (id, article_uuid, title, content, status, version)
VALUES ('da2', 'uuid-article-1', '初めての記事（編集済み）', 'これは編集された記事の内容です。', 'CREATED', 2);

-- 記事の公開
INSERT INTO published_articles (id, article_uuid, title, content, status, version)
VALUES ('pa1', 'uuid-article-1', '初めての記事（公開版）', 'これは公開された記事の内容です。', 'CREATED', 1);

-- 公開記事の更新
INSERT INTO published_articles (id, article_uuid, title, content, status, version)
VALUES ('pa2', 'uuid-article-1', '初めての記事（公開版・更新）', 'これは更新された公開記事の内容です。', 'CREATED', 2);

-- 公開記事の非公開化
INSERT INTO published_articles (id, article_uuid, title, content, status, version)
VALUES ('pa3', 'uuid-article-1', '初めての記事（公開版・更新）', 'これは更新された公開記事の内容です。これで確定です', 'DELETED', 3);

-- 記事の非公開化
INSERT INTO unpublished_articles (id, published_article_uuid, status)
VALUES ('ua1', 'uuid-article-1', 'CREATED');

-- 記事イベントの記録
INSERT INTO article_events (id, article_uuid, event_type, user_uuid, version, created_at)
VALUES ('ae1', 'uuid-article-1', 'DRAFT_CREATED', 'uuid-user-1', 1, CURRENT_TIMESTAMP);

INSERT INTO article_events (id, article_uuid, event_type, user_uuid, version, created_at)
VALUES ('ae2', 'uuid-article-1', 'PUBLISHED', 'uuid-user-1', 1, CURRENT_TIMESTAMP);

INSERT INTO article_events (id, article_uuid, event_type, user_uuid, version, created_at)
VALUES ('ae3', 'uuid-article-1', 'DRAFT_CREATED', 'uuid-user-1', 2, CURRENT_TIMESTAMP);

INSERT INTO article_events (id, article_uuid, event_type, user_uuid, version, created_at)
VALUES ('ae4', 'uuid-article-1', 'PUBLISHED', 'uuid-user-1', 2, CURRENT_TIMESTAMP);

INSERT INTO article_events (id, article_uuid, event_type, user_uuid, version, created_at)
VALUES ('ae5', 'uuid-article-1', 'UNPUBLISHED', 'uuid-user-1', 2, CURRENT_TIMESTAMP);

INSERT INTO article_events (id, article_uuid, event_type, user_uuid, version, created_at)
VALUES ('ae6', 'uuid-article-1', 'REPUBLISHED', 'uuid-user-1', 2, CURRENT_TIMESTAMP);
