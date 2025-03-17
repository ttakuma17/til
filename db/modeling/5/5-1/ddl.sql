-- 記事テーブル(R)
CREATE TABLE articles (
    id VARCHAR(36) PRIMARY KEY
);

-- 記事バージョンテーブル(R)
CREATE TABLE article_versions (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    version INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    text TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,-- Resourceテーブルだがcreated_atをつけることにした。Versionがいつつくられたかがわかるように、ただしEventテーブルとJOINすればわかるのもある
    FOREIGN KEY (article_id) REFERENCES articles(id),
    UNIQUE (article_id, version)
);

-- 記事イベントタイプ(R)
CREATE TABLE article_event_types (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);


-- ユーザーテーブル(R)
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY
);

-- 記事イベント(E)
CREATE TABLE article_events (
    id VARCHAR(36) PRIMARY KEY,
    article_id VARCHAR(36) NOT NULL,
    event_type_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    version INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (event_type_id) REFERENCES article_event_types(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ユーザープロフィールバージョン(R)
CREATE TABLE user_profile_versions (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    version INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Resourceテーブルだがcreated_atをつけることにした。Versionがいつつくられたかがわかるように、ただしEventテーブルとJOINすればわかるのもある
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE (user_id, version)
);

-- ユーザーロール(R)
CREATE TABLE user_roles (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- ユーザーイベントタイプ(R)
CREATE TABLE user_event_types (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- ユーザーイベント(E)
CREATE TABLE user_events (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    event_type_id VARCHAR(36) NOT NULL,
    actor_user_id VARCHAR(36) NOT NULL,
    version INT NOT NULL,
    role_id VARCHAR(36),  -- ロール関連イベントのみで使用するため、このカラムだけはNULLを許容、デフォルト値いれとくでもいい気はする
    occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_type_id) REFERENCES user_event_types(id),
    FOREIGN KEY (actor_user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES user_roles(id)
);

CREATE INDEX idx_article_versions_article_id ON article_versions(article_id);
CREATE INDEX idx_article_versions_version ON article_versions(version);
CREATE INDEX idx_article_events_article_id ON article_events(article_id);
CREATE INDEX idx_article_events_type ON article_events(event_type_id);
CREATE INDEX idx_article_events_user_id ON article_events(user_id);
CREATE INDEX idx_article_events_occurred_at ON article_events(occurred_at);
CREATE INDEX idx_user_profile_versions_user_id ON user_profile_versions(user_id);
CREATE INDEX idx_user_profile_versions_version ON user_profile_versions(version);
CREATE INDEX idx_user_profile_versions_email ON user_profile_versions(email);
CREATE INDEX idx_user_events_user_id ON user_events(user_id);
CREATE INDEX idx_user_events_type ON user_events(event_type_id);
CREATE INDEX idx_user_events_actor ON user_events(actor_user_id);
CREATE INDEX idx_user_events_occurred_at ON user_events(occurred_at);


