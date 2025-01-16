-- ユーザー (R)
CREATE TABLE users
(
    id         SERIAL PRIMARY KEY,
    user_uuid  VARCHAR(36) NOT NULL UNIQUE,
    name       VARCHAR NOT NULL,
    email      VARCHAR NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ワークスペース (R)
CREATE TABLE workspaces
(
    id             SERIAL PRIMARY KEY,
    workspace_uuid VARCHAR(36) NOT NULL UNIQUE,
    name           VARCHAR NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- チャンネル (R)
CREATE TABLE channels
(
    id             SERIAL PRIMARY KEY,
    channel_uuid   VARCHAR(36) NOT NULL UNIQUE,
    name           VARCHAR NOT NULL,
    workspace_uuid VARCHAR NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_channels_workspace_uuid FOREIGN KEY (workspace_uuid)
        REFERENCES workspaces (workspace_uuid)
);

-- ワークスペースイベント (E)
CREATE TABLE workspace_events
(
    id             SERIAL PRIMARY KEY,
    user_uuid      VARCHAR(36) NOT NULL,
    status         VARCHAR NOT NULL,
    workspace_uuid VARCHAR(36) NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_workspace_events_user_uuid FOREIGN KEY (user_uuid)
        REFERENCES users (user_uuid),
    CONSTRAINT fk_workspace_events_workspace_uuid FOREIGN KEY (workspace_uuid)
        REFERENCES workspaces (workspace_uuid)
);

-- チャンネルイベント (E)
CREATE TABLE channel_events
(
    id           SERIAL PRIMARY KEY,
    user_uuid    VARCHAR(36) NOT NULL,
    status       VARCHAR NOT NULL,
    channel_uuid VARCHAR(36) NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_channel_events_user_uuid FOREIGN KEY (user_uuid)
        REFERENCES users (user_uuid),
    CONSTRAINT fk_channel_events_channel_uuid FOREIGN KEY (channel_uuid)
        REFERENCES channels (channel_uuid)
);


-- メッセージ (R)
CREATE TABLE messages
(
    id           SERIAL PRIMARY KEY,
    message_uuid VARCHAR(36) NOT NULL UNIQUE,
    content      TEXT    NOT NULL,
    type         VARCHAR NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- スレッドメッセージ (R)
CREATE TABLE thread_messages
(
    id                  SERIAL PRIMARY KEY,
    thread_message_uuid VARCHAR(36) NOT NULL UNIQUE,
    post_order          INT     NOT NULL,
    parent_message_uuid VARCHAR(36) NOT NULL,
    message_uuid        VARCHAR(36) NOT NULL,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_thread_messages_parent_message_uuid FOREIGN KEY (parent_message_uuid)
        REFERENCES messages (message_uuid),
    CONSTRAINT fk_thread_messages_message_uuid FOREIGN KEY (message_uuid)
        REFERENCES messages (message_uuid)
);

-- 投稿 (E)
CREATE TABLE posts
(
    id           SERIAL PRIMARY KEY,
    post_uuid    VARCHAR NOT NULL UNIQUE,
    status       VARCHAR NOT NULL,
    user_uuid    VARCHAR NOT NULL,
    message_uuid VARCHAR,
    channel_uuid VARCHAR NOT NULL,
    posted_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_user_uuid FOREIGN KEY (user_uuid)
        REFERENCES users (user_uuid),
    CONSTRAINT fk_posts_message_uuid FOREIGN KEY (message_uuid)
        REFERENCES messages (message_uuid),
    CONSTRAINT fk_posts_channel_uuid FOREIGN KEY (channel_uuid)
        REFERENCES channels (channel_uuid)
);

-- indexを追加
CREATE INDEX idx_users_user_uuid ON users (user_uuid);
CREATE INDEX idx_workspaces_workspace_uuid ON workspaces (workspace_uuid);
CREATE INDEX idx_messages_message_uuid ON messages (message_uuid);

CREATE INDEX idx_channels_channel_uuid ON channels (channel_uuid);
CREATE INDEX idx_channels_workspace_uuid ON channels (workspace_uuid);

CREATE INDEX idx_workspace_events_user_uuid ON workspace_events (user_uuid);
CREATE INDEX idx_workspace_events_workspace_uuid ON workspace_events (workspace_uuid);

CREATE INDEX idx_channel_events_user_uuid ON channel_events (user_uuid);
CREATE INDEX idx_channel_events_channel_id ON channel_events (channel_uuid);

CREATE INDEX idx_posts_post_uuid ON posts (post_uuid);
CREATE INDEX idx_posts_user_uuid ON posts (user_uuid);
CREATE INDEX idx_posts_message_uuid ON posts (message_uuid);
CREATE INDEX idx_posts_channel_uuid ON posts (channel_uuid);

CREATE INDEX idx_thread_messages_thread_message_uuid ON thread_messages (thread_message_uuid);
CREATE INDEX idx_thread_messages_parent_message_uuid ON thread_messages (parent_message_uuid);
CREATE INDEX idx_thread_messages_message_uuid ON thread_messages (message_uuid);