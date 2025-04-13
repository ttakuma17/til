-- ユーザー登録 開始イベント登録/ユーザー情報登録/終了イベント登録　という流れで記録する
INSERT INTO user_event_start (user_event_id)
VALUES ('ues1');
INSERT INTO users (user_event_id, user_uuid, name, email)
VALUES ('ues1', 'uuid-user-1', 'John Doe', 'john@example.com');
INSERT INTO user_event_end (user_event_result_id, user_event_id, user_status)
VALUES ('uee1', 'ues1', 'ACTIVE');

INSERT INTO user_event_start (user_event_id)
VALUES ('ues2');

INSERT INTO users (user_event_id, user_uuid, name, email)
VALUES ('ues2', 'uuid-user-2', 'Jane Smith', 'jane@example.com');

INSERT INTO user_event_end (user_event_result_id, user_event_id, user_status)
VALUES ('uee2', 'ues2', 'ACTIVE');

-- 記事登録 開始イベント登録/記事作成/終了イベント登録　という流れで記録する
INSERT INTO article_event_start (article_event_id, article_uuid)
VALUES ('aes1', 'uuid-article-1');

INSERT INTO articles (article_event_id, article_uuid, version, title, content)
VALUES ('aes1', 'uuid-article-1', 1, '初めての記事', 'これは記事の内容です。');

INSERT INTO article_event_end (article_event_result_id, article_event_id, article_status)
VALUES ('aee1', 'aes1', 'DRAFT');

-- ユーザーと記事の関連付け
INSERT INTO user_article_creates (user_uuid, article_event_id)
VALUES ('uuid-user-1', 'aes1');

-- 記事登録開始イベント（バージョン2 - 編集）
INSERT INTO article_event_start (article_event_id, article_uuid)
VALUES ('aes2', 'uuid-article-1');

-- 記事作成（バージョン2 - 編集）
INSERT INTO articles (article_event_id, article_uuid, version, title, content)
VALUES ('aes2', 'uuid-article-1', 2, '初めての記事（編集済み）', 'これは編集された記事の内容です。');

-- 記事登録終了イベント（公開状態）
INSERT INTO article_event_end (article_event_result_id, article_event_id, article_status)
VALUES ('aee2', 'aes2', 'PUBLISHED');

-- ユーザーと記事の関連付け（編集）
INSERT INTO user_article_creates (user_uuid, article_event_id)
VALUES ('uuid-user-1', 'aes2');

-- 記事登録開始イベント（バージョン3 - 非公開化）
INSERT INTO article_event_start (article_event_id, article_uuid)
VALUES ('aes3', 'uuid-article-1');

-- 記事作成（バージョン3 - 非公開化）
INSERT INTO articles (article_event_id, article_uuid, version, title, content)
VALUES ('aes3', 'uuid-article-1', 3, '初めての記事（公開版・更新）', 'これは更新された公開記事の内容です。これで確定です');

-- 記事登録終了イベント（非公開状態）
INSERT INTO article_event_end (article_event_result_id, article_event_id, article_status)
VALUES ('aee3', 'aes3', 'UNPUBLISHED');

-- ユーザーと記事の関連付け（非公開化）
INSERT INTO user_article_creates (user_uuid, article_event_id)
VALUES ('uuid-user-1', 'aes3');

-- 2つ目の記事登録
INSERT INTO article_event_start (article_event_id, article_uuid)
VALUES ('aes4', 'uuid-article-2');

INSERT INTO articles (article_event_id, article_uuid, version, title, content)
VALUES ('aes4', 'uuid-article-2', 1, '2つ目の記事', 'これは2つ目の記事の内容です。');

INSERT INTO article_event_end (article_event_result_id, article_event_id, article_status)
VALUES ('aee4', 'aes4', 'PUBLISHED');

INSERT INTO user_article_creates (user_uuid, article_event_id)
VALUES ('uuid-user-2', 'aes4');
