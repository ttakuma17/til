-- ユーザー登録開始(E)
CREATE TABLE user_event_start (
    user_event_id VARCHAR(36) PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ユーザー(R)
CREATE TABLE users (
    user_event_id VARCHAR(36) PRIMARY KEY,
    user_uuid VARCHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    CONSTRAINT users_user_uuid_unique UNIQUE (user_uuid),
    CONSTRAINT users_email_unique UNIQUE (email),
    CONSTRAINT users_user_event_id_fk FOREIGN KEY (user_event_id) REFERENCES user_event_start(user_event_id)
);

-- ユーザー登録終了(E)
CREATE TABLE user_event_end (
    user_event_result_id VARCHAR(36) PRIMARY KEY,
    user_event_id VARCHAR(36) NOT NULL,
    user_status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_event_end_user_event_id_fk FOREIGN KEY (user_event_id) REFERENCES user_event_start(user_event_id)
);

-- 記事登録開始(E)
CREATE TABLE article_event_start (
    article_event_id VARCHAR(36) PRIMARY KEY,
    article_uuid VARCHAR(36) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT article_event_start_article_uuid_unique UNIQUE (article_uuid)
);

-- 記事(R)
CREATE TABLE articles (
    article_event_id VARCHAR(36) PRIMARY KEY,
    article_uuid VARCHAR(36) NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    CONSTRAINT articles_article_uuid_version_unique UNIQUE (article_uuid, version),
    CONSTRAINT articles_article_event_id_fk FOREIGN KEY (article_event_id) REFERENCES article_event_start(article_event_id)
);

-- 記事登録終了(E)
CREATE TABLE article_event_end (
    article_event_result_id VARCHAR(36) PRIMARY KEY,
    article_event_id VARCHAR(36) NOT NULL,
    article_status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT article_event_end_article_event_id_fk FOREIGN KEY (article_event_id) REFERENCES article_event_start(article_event_id)
);

-- ユーザーブログcreates (R)
CREATE TABLE user_article_creates (
    user_uuid VARCHAR(36) NOT NULL,
    article_event_id VARCHAR(36) NOT NULL,
    PRIMARY KEY (user_uuid, article_event_id),
    CONSTRAINT user_article_creates_user_uuid_fk FOREIGN KEY (user_uuid) REFERENCES users(user_uuid),
    CONSTRAINT user_article_creates_article_event_id_fk FOREIGN KEY (article_event_id) REFERENCES article_event_start(article_event_id)
);

-- インデックス
CREATE INDEX idx_user_event_start_created_at ON user_event_start(created_at);

CREATE INDEX idx_users_user_uuid ON users(user_uuid);
CREATE INDEX idx_users_email ON users(email);

CREATE INDEX idx_user_event_end_user_event_id ON user_event_end(user_event_id);
CREATE INDEX idx_user_event_end_user_status ON user_event_end(user_status);
CREATE INDEX idx_user_event_end_created_at ON user_event_end(created_at);

CREATE INDEX idx_article_event_start_article_uuid ON article_event_start(article_uuid);
CREATE INDEX idx_article_event_start_created_at ON article_event_start(created_at);

CREATE INDEX idx_articles_article_uuid ON articles(article_uuid);
CREATE INDEX idx_articles_version ON articles(version);

CREATE INDEX idx_article_event_end_article_event_id ON article_event_end(article_event_id);
CREATE INDEX idx_article_event_end_article_status ON article_event_end(article_status);
CREATE INDEX idx_article_event_end_created_at ON article_event_end(created_at);

CREATE INDEX idx_user_article_creates_user_uuid ON user_article_creates(user_uuid);
CREATE INDEX idx_user_article_creates_article_event_id ON user_article_creates(article_event_id);
