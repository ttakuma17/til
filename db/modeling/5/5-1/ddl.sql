-- ユーザーテーブル(R)
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY
);

-- ユーザー情報テーブル(R)
CREATE TABLE user_profiles (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE(email)
);

-- ユーザー情報変更イベント(E)
CREATE TABLE user_profile_change_events (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    user_profile_id VARCHAR(36) NOT NULL,
    changed_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (user_profile_id) REFERENCES user_profiles(id)
);

-- ユーザーロールテーブル(R)
CREATE TABLE user_roles (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- 初期ロールデータ
INSERT INTO user_roles (id, name) VALUES 
    ('role-1', 'admin'),
    ('role-2', 'general_user');

-- セルフサインアップイベント(E)
CREATE TABLE user_self_registration_events (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    role_id VARCHAR(36) NOT NULL,
    user_profile_id VARCHAR(36) NOT NULL,
    registered_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES user_roles(id),
    FOREIGN KEY (user_profile_id) REFERENCES user_profiles(id)
);

-- ユーザーロール割り当てイベント(E)
CREATE TABLE user_role_assignment_events (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    role_id VARCHAR(36) NOT NULL,
    assigned_by_user_id VARCHAR(36) NOT NULL,
    assigned_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES user_roles(id),
    FOREIGN KEY (assigned_by_user_id) REFERENCES users(id)
);

-- ユーザー退会イベント(E)
CREATE TABLE user_withdrawal_events (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    withdrawn_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ユーザー強制退会イベント(E)
CREATE TABLE user_forced_withdrawal_events (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    admin_user_id VARCHAR(36) NOT NULL,
    reason VARCHAR(1000) NOT NULL,
    forced_withdrawn_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- 記事テーブル(R)
CREATE TABLE articles (
    id VARCHAR(36) PRIMARY KEY
);

-- ドラフト記事テーブル(R)
CREATE TABLE draft_articles (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    text TEXT NOT NULL,
    FOREIGN KEY (article_id) REFERENCES articles(id)
);

-- 公開記事テーブル(R)
CREATE TABLE published_articles (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    text TEXT NOT NULL,
    FOREIGN KEY (article_id) REFERENCES articles(id)
);

-- ドラフト作成イベント(E)
CREATE TABLE draft_creation_events (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    draft_created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ドラフト削除イベント(E)
CREATE TABLE draft_deletion_events (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    draft_deleted_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 記事公開イベント(E)
CREATE TABLE article_publication_events (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    published_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 記事非公開イベント(E)
CREATE TABLE article_unpublication_events (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    unpublished_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 記事削除イベント(E)
CREATE TABLE article_deletion_events (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    deleted_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- インデックスの作成
CREATE INDEX idx_user_self_registration_events_user_id ON user_self_registration_events(user_id);
CREATE INDEX idx_user_self_registration_events_role_id ON user_self_registration_events(role_id);
CREATE INDEX idx_user_role_assignment_events_user_id ON user_role_assignment_events(user_id);
CREATE INDEX idx_user_role_assignment_events_role_id ON user_role_assignment_events(role_id);
CREATE INDEX idx_user_withdrawal_events_user_id ON user_withdrawal_events(user_id);
CREATE INDEX idx_user_forced_withdrawal_events_user_id ON user_forced_withdrawal_events(user_id);
CREATE INDEX idx_draft_articles_article_id ON draft_articles(article_id);
CREATE INDEX idx_published_articles_article_id ON published_articles(article_id);
CREATE INDEX idx_draft_creation_events_article_id ON draft_creation_events(article_id);
CREATE INDEX idx_draft_creation_events_user_id ON draft_creation_events(user_id);
CREATE INDEX idx_draft_deletion_events_article_id ON draft_deletion_events(article_id);
CREATE INDEX idx_draft_deletion_events_user_id ON draft_deletion_events(user_id);
CREATE INDEX idx_article_publication_events_article_id ON article_publication_events(article_id);
CREATE INDEX idx_article_publication_events_user_id ON article_publication_events(user_id);
CREATE INDEX idx_article_unpublication_events_article_id ON article_unpublication_events(article_id);
CREATE INDEX idx_article_unpublication_events_user_id ON article_unpublication_events(user_id);
CREATE INDEX idx_article_deletion_events_article_id ON article_deletion_events(article_id);
CREATE INDEX idx_article_deletion_events_user_id ON article_deletion_events(user_id);

-- タイムスタンプのインデックス
CREATE INDEX idx_user_self_registration_events_date ON user_self_registration_events(registered_date);
CREATE INDEX idx_user_role_assignment_events_date ON user_role_assignment_events(assigned_date);
CREATE INDEX idx_user_withdrawal_events_date ON user_withdrawal_events(withdrawn_date);
CREATE INDEX idx_user_forced_withdrawal_events_date ON user_forced_withdrawal_events(forced_withdrawn_date);
CREATE INDEX idx_draft_creation_events_date ON draft_creation_events(draft_created_date);
CREATE INDEX idx_draft_deletion_events_date ON draft_deletion_events(draft_deleted_date);
CREATE INDEX idx_article_publication_events_date ON article_publication_events(published_date);
CREATE INDEX idx_article_unpublication_events_date ON article_unpublication_events(unpublished_date);
CREATE INDEX idx_article_deletion_events_date ON article_deletion_events(deleted_date);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_user_profiles_email ON user_profiles(email);
CREATE INDEX idx_user_profile_change_events_user_id ON user_profile_change_events(user_id);
CREATE INDEX idx_user_profile_change_events_profile_id ON user_profile_change_events(user_profile_id);
CREATE INDEX idx_user_profile_change_events_date ON user_profile_change_events(changed_date);
CREATE INDEX idx_user_self_registration_events_profile_id ON user_self_registration_events(user_profile_id);


-- タイトル検索用インデックス
CREATE INDEX idx_published_articles_title ON published_articles(title);
CREATE INDEX idx_draft_articles_title ON draft_articles(title);
