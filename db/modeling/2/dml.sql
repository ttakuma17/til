INSERT INTO users (user_uuid, name, email) VALUES
('uuid-1', '山田太郎', 'taro.yamada@example.com'),
('uuid-2', '鈴木花子', 'hanako.suzuki@example.com');

INSERT INTO workspaces (workspace_uuid, name) VALUES
('workspace-uuid-1', '開発チーム'),
('workspace-uuid-2', 'マーケティングチーム');

INSERT INTO channels (channel_uuid, name, workspace_uuid) VALUES
('channel-uuid-1', '一般', 'workspace-uuid-1'),
('channel-uuid-2', 'プロジェクトA', 'workspace-uuid-1');

INSERT INTO join_workspaces (user_uuid, workspace_id) VALUES
('uuid-1', 1),
('uuid-2', 2);

INSERT INTO join_channels (user_uuid, channel_id) VALUES
('uuid-1', 1),
('uuid-2', 2);

INSERT INTO leave_workspaces (user_uuid, workspace_uuid) VALUES
('uuid-1', 'workspace-uuid-1'),
('uuid-2', 'workspace-uuid-2');

INSERT INTO leave_channels (user_uuid, channel_uuid) VALUES
('uuid-1', 'channel-uuid-1'),
('uuid-2', 'channel-uuid-2');

INSERT INTO posts (post_uuid, status, user_uuid, channel_uuid) VALUES
('post-uuid-1', 'active', 'uuid-1', 'channel-uuid-1'),
('post-uuid-2', 'inactive', 'uuid-2', 'channel-uuid-2');

INSERT INTO messages (message_uuid, content, type) VALUES
('message-uuid-1', 'こんにちは、皆さん！', 'message'),
('message-uuid-2', 'プロジェクトAの進捗はどうですか？', 'thread_message');

INSERT INTO thread_messages (thread_message_uuid, status, post_order, parent_message_uuid) VALUES
('thread-message-uuid-2', 'PUBLISHED', 1, 'message-uuid-1');
