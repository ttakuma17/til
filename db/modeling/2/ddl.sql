-- ユーザー (R)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_uuid VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ワークスペース (R)
CREATE TABLE workspaces (
    id SERIAL PRIMARY KEY,
    workspace_uuid VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- チャンネル (R)
CREATE TABLE channels (
    id SERIAL PRIMARY KEY,
    channel_uuid VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    workspace_uuid VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ワークスペース参加 (E)
CREATE TABLE join_workspaces (
    id SERIAL PRIMARY KEY,
    user_uuid VARCHAR NOT NULL,
    workspace_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- チャンネル参加 (E)
CREATE TABLE join_channels (
    id SERIAL PRIMARY KEY,
    user_uuid VARCHAR NOT NULL,
    channel_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ワークスペース退出 (E)
CREATE TABLE leave_workspaces (
    id SERIAL PRIMARY KEY,
    user_uuid VARCHAR NOT NULL,
    workspace_uuid VARCHAR NOT NULL,
    left_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- チャンネル退出 (E)
CREATE TABLE leave_channels (
    id SERIAL PRIMARY KEY,
    user_uuid VARCHAR NOT NULL,
    channel_uuid VARCHAR NOT NULL,
    left_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 投稿 (E)
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    post_uuid VARCHAR NOT NULL UNIQUE,
    status VARCHAR NOT NULL,
    user_uuid VARCHAR NOT NULL,
    message_uuid VARCHAR,
    channel_uuid VARCHAR NOT NULL,
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- メッセージ (R)
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    message_uuid VARCHAR NOT NULL UNIQUE,
    content TEXT NOT NULL,
    type VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- スレッドメッセージ (R)
CREATE TABLE thread_messages (
    id SERIAL PRIMARY KEY,
    thread_message_uuid VARCHAR NOT NULL UNIQUE,
    status VARCHAR NOT NULL,
    post_order INT NOT NULL,
    parent_message_uuid VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 外部キー制約の追加
ALTER TABLE channels
ADD CONSTRAINT fk_channels_workspace_uuid
FOREIGN KEY (workspace_uuid)
REFERENCES workspaces (workspace_uuid);

ALTER TABLE join_workspaces
ADD CONSTRAINT fk_join_workspaces_user_uuid
FOREIGN KEY (user_uuid)
REFERENCES users (user_uuid);

ALTER TABLE join_workspaces
ADD CONSTRAINT fk_join_workspaces_workspace_id
FOREIGN KEY (workspace_id)
REFERENCES workspaces (id);

ALTER TABLE join_channels
ADD CONSTRAINT fk_join_channels_user_uuid
FOREIGN KEY (user_uuid)
REFERENCES users (user_uuid);

ALTER TABLE join_channels
ADD CONSTRAINT fk_join_channels_channel_id
FOREIGN KEY (channel_id)
REFERENCES channels (id);

ALTER TABLE leave_workspaces
ADD CONSTRAINT fk_leave_workspaces_user_uuid
FOREIGN KEY (user_uuid)
REFERENCES users (user_uuid);

ALTER TABLE leave_workspaces
ADD CONSTRAINT fk_leave_workspaces_workspace_uuid
FOREIGN KEY (workspace_uuid)
REFERENCES workspaces (workspace_uuid);

ALTER TABLE leave_channels
ADD CONSTRAINT fk_leave_channels_user_uuid
FOREIGN KEY (user_uuid)
REFERENCES users (user_uuid);

ALTER TABLE leave_channels
ADD CONSTRAINT fk_leave_channels_channel_uuid
FOREIGN KEY (channel_uuid)
REFERENCES channels (channel_uuid);

ALTER TABLE posts
ADD CONSTRAINT fk_posts_user_uuid
FOREIGN KEY (user_uuid)
REFERENCES users (user_uuid);

ALTER TABLE posts
ADD CONSTRAINT fk_posts_message_uuid
FOREIGN KEY (message_uuid)
REFERENCES messages (message_uuid);

ALTER TABLE posts
ADD CONSTRAINT fk_posts_channel_uuid
FOREIGN KEY (channel_uuid)
REFERENCES channels (channel_uuid);

ALTER TABLE thread_messages
ADD CONSTRAINT fk_thread_messages_parent_message_uuid
FOREIGN KEY (parent_message_uuid)
REFERENCES messages (message_uuid);

-- indexを追加
CREATE INDEX idx_users_user_uuid ON users (user_uuid);
CREATE INDEX idx_workspaces_workspace_uuid ON workspaces (workspace_uuid);
CREATE INDEX idx_messages_message_uuid ON messages (message_uuid);

CREATE INDEX idx_channels_channel_uuid ON channels (channel_uuid);
CREATE INDEX idx_channels_workspace_uuid ON channels (workspace_uuid);

CREATE INDEX idx_join_workspaces_user_uuid ON join_workspaces (user_uuid);
CREATE INDEX idx_join_workspaces_workspace_id ON join_workspaces (workspace_id);

CREATE INDEX idx_join_channels_user_uuid ON join_channels (user_uuid);
CREATE INDEX idx_join_channels_channel_id ON join_channels (channel_id);

CREATE INDEX idx_leave_workspaces_workspace_uuid ON leave_workspaces (workspace_uuid);
CREATE INDEX idx_leave_workspaces_user_uuid ON leave_workspaces (user_uuid);

CREATE INDEX idx_leave_channels_channel_uuid ON leave_channels (channel_uuid);
CREATE INDEX idx_leave_channels_user_uuid ON leave_channels (user_uuid);

CREATE INDEX idx_posts_post_uuid ON posts (post_uuid);
CREATE INDEX idx_posts_user_uuid ON posts (user_uuid);
CREATE INDEX idx_posts_message_uuid ON posts (message_uuid);
CREATE INDEX idx_posts_channel_uuid ON posts (channel_uuid);

CREATE INDEX idx_thread_messages_thread_message_uuid ON thread_messages (thread_message_uuid);
CREATE INDEX idx_thread_messages_parent_message_uuid ON thread_messages (parent_message_uuid);
