CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    user_uuid VARCHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT users_user_uuid_status_version_unique UNIQUE (user_uuid, status, version)
);

CREATE TABLE user_events (
    id VARCHAR(36) PRIMARY KEY,
    user_uuid VARCHAR(36) NOT NULL,
    event_type VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    version INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE draft_articles (
    id VARCHAR(36) PRIMARY KEY,
    article_uuid VARCHAR(36) NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT draft_articles_article_uuid_status_version_unique UNIQUE (article_uuid, status, version)
);

CREATE TABLE published_articles (
    id VARCHAR(36) PRIMARY KEY,
    article_uuid VARCHAR(36) NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT published_articles_article_uuid_status_version_unique UNIQUE (article_uuid, status, version)
);

-- 非公開→公開→非公開とか繰り返す可能性も考えられるので、unique制約はつけてない
CREATE TABLE unpublished_articles (
    id VARCHAR(36) PRIMARY KEY,
    published_article_uuid VARCHAR(36) NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE article_events (
    id VARCHAR(36) PRIMARY KEY,
    article_uuid VARCHAR(36) NOT NULL,
    event_type VARCHAR(30) NOT NULL,
    user_uuid VARCHAR(36) NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL
);

CREATE INDEX idx_users_user_uuid ON users(user_uuid);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);

CREATE INDEX idx_user_events_user_uuid ON user_events(user_uuid);
CREATE INDEX idx_user_events_created_at ON user_events(created_at);

CREATE INDEX idx_draft_articles_article_uuid ON draft_articles(article_uuid);
CREATE INDEX idx_draft_articles_status ON draft_articles(status);

CREATE INDEX idx_published_articles_article_uuid ON published_articles(article_uuid);
CREATE INDEX idx_published_articles_status ON published_articles(status);

CREATE INDEX idx_unpublished_articles_published_article_uuid ON unpublished_articles(published_article_uuid);

CREATE INDEX idx_article_events_article_uuid ON article_events(article_uuid);
CREATE INDEX idx_article_events_event_type ON article_events(event_type);
CREATE INDEX idx_article_events_user_uuid ON article_events(user_uuid);
CREATE INDEX idx_article_events_created_at ON article_events(created_at);
