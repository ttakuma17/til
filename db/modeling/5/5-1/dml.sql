-- ユーザーロールは先に準備
INSERT INTO user_roles (id, name) VALUES 
    ('role-1', 'admin'),
    ('role-2', 'general_user');
-- ユーザーテーブル
INSERT INTO users (id) VALUES
    ('user-1'),
    ('user-2'),
    ('user-3'),
    ('user-4'),
    ('user-5'),
    ('system');

-- ユーザー情報テーブル
INSERT INTO user_profiles (id, user_id, name, email) VALUES
    ('profile-1', 'user-1', '山田太郎', 'yamada@example.com'),
    ('profile-2', 'user-2', '佐藤花子', 'sato@example.com'),
    ('profile-3', 'user-3', '鈴木一郎', 'suzuki@example.com'),
    ('profile-4', 'user-4', '田中美咲', 'tanaka@example.com'),
    ('profile-5', 'user-5', '伊藤健一', 'ito@example.com');

-- ユーザーロール割当イベント
INSERT INTO user_role_assignment_events (id, user_id, role_id, assigned_date) VALUES
    ('role-assign-1', 'user-1', 'role-2', CURRENT_TIMESTAMP),
    ('role-assign-2', 'user-2', 'role-2', CURRENT_TIMESTAMP),
    ('role-assign-3', 'user-3', 'role-2', CURRENT_TIMESTAMP),
    ('role-assign-4', 'user-4', 'role-2', CURRENT_TIMESTAMP),
    ('role-assign-5', 'user-5', 'role-2', CURRENT_TIMESTAMP),
    ('role-assign-6', 'system', 'role-1', CURRENT_TIMESTAMP);

-- サインアップイベント
INSERT INTO user_self_registration_events (id, user_id, role_id, user_profile_id, registered_date) VALUES
    ('signup-1', 'user-1', 'role-2', 'profile-1', CURRENT_TIMESTAMP),
    ('signup-2', 'user-2', 'role-2', 'profile-2', CURRENT_TIMESTAMP),
    ('signup-3', 'user-3', 'role-2', 'profile-3', CURRENT_TIMESTAMP),
    ('signup-4', 'user-4', 'role-2', 'profile-4', CURRENT_TIMESTAMP),
    ('signup-5', 'user-5', 'role-2', 'profile-5', CURRENT_TIMESTAMP);

-- user1のprofileを変更して、変更イベントを記録
INSERT INTO user_profiles (id, user_id, name, email) VALUES
    ('profile-6', 'user-1', '山田次郎', 'yamada@example.com');
INSERT INTO user_profile_change_events (id, user_id, user_profile_id, changed_date) VALUES
    ('profile-change-1', 'user-1', 'profile-6', CURRENT_TIMESTAMP);
-- user3は退会したとして、ユーザー退会イベントを記録
INSERT INTO user_withdrawal_events (id, user_id, withdrawn_date) VALUES
    ('withdrawal-1', 'user-3', CURRENT_TIMESTAMP);
-- user4は強制的に退会したとして、ユーザー強制退会イベントを記録
INSERT INTO user_forced_withdrawal_events (id, user_id, admin_user_id, reason, forced_withdrawn_date) VALUES
    ('forced-withdrawal-1', 'user-4', 'system', '違反行為', CURRENT_TIMESTAMP);
-- 記事テーブル
INSERT INTO articles (id) VALUES
    ('article-1'),
    ('article-2');
-- ドラフト作成イベントとドラフト記事リソースを記録
INSERT INTO draft_creation_events (id, article_id, user_id, draft_created_date) VALUES
    ('draft-creation-1', 'article-1', 'user-1', CURRENT_TIMESTAMP);
INSERT INTO draft_articles (id, article_id, title, text) VALUES
    ('draft-article-1', 'article-1', 'ドラフト記事1', 'ドラフト記事1の内容');
-- 作成したドラフト記事を公開するイベントと公開記事を記録
INSERT INTO article_publication_events (id, article_id, user_id, published_date) VALUES
    ('article-publication-1', 'article-1', 'user-1', CURRENT_TIMESTAMP);
INSERT INTO published_articles (id, article_id, title, text) VALUES
    ('published-article-1', 'article-1', '公開記事1', '公開記事1の内容');
-- 公開記事を非公開にするイベントを記録
INSERT INTO article_unpublication_events (id, article_id, user_id, unpublished_date) VALUES
    ('article-unpublication-1', 'article-1', 'user-1', CURRENT_TIMESTAMP);
-- 非公開記事を再公開するイベントを記録
INSERT INTO article_publication_events (id, article_id, user_id, published_date) VALUES
    ('article-publication-2', 'article-1', 'user-1', CURRENT_TIMESTAMP);
INSERT INTO published_articles (id, article_id, title, text) VALUES
    ('published-article-2', 'article-1', '公開記事1', '公開記事1の内容');
-- 公開記事を削除するイベントを記録
INSERT INTO article_deletion_events (id, article_id, user_id, deleted_date) VALUES
    ('article-deletion-1', 'article-1', 'user-1', CURRENT_TIMESTAMP);
-- ドラフト作成イベントとドラフト記事リソースを記録
INSERT INTO draft_creation_events (id, article_id, user_id, draft_created_date) VALUES
    ('draft-creation-2', 'article-2', 'user-2', CURRENT_TIMESTAMP);
INSERT INTO draft_articles (id, article_id, title, text) VALUES
    ('draft-article-2', 'article-2', 'ドラフト記事2', 'ドラフト記事2の内容');
-- 作成したドラフト記事を公開するイベントと公開記事を記録
INSERT INTO article_publication_events (id, article_id, user_id) VALUES
    ('article-publication-3', 'article-2', 'user-2');
INSERT INTO published_articles (id, article_id, title, text) VALUES
    ('published-article-3', 'article-2', '公開記事2', '公開記事2の内容');

-- 公開済みの記事からドラフトを作成、公開するイベントを記録
INSERT INTO draft_creation_events (id, article_id, user_id, draft_created_date) VALUES
    ('draft-creation-3', 'article-2', 'user-2', CURRENT_TIMESTAMP);
INSERT INTO draft_articles (id, article_id, title, text) VALUES
    ('draft-article-3', 'article-2', 'ドラフト記事3', 'ドラフト記事3の内容 - 更新版');
INSERT INTO article_publication_events (id, article_id, user_id) VALUES
    ('article-publication-4', 'article-2', 'user-2');
INSERT INTO published_articles (id, article_id, title, text) VALUES
    ('published-article-4', 'article-2', '公開記事2 - 更新版', '公開記事2の内容 - 更新版');
