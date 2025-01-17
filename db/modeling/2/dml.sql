INSERT INTO users (user_uuid, name, email)
VALUES ('user-uuid-1', '山田太郎', 'taro.yamada@example.com'),
       ('user-uuid-2', '鈴木花子', 'hanako.suzuki@example.com'),
       ('user-uuid-3', '田中次郎', 'jiro.tanaka@example.com');

INSERT INTO workspaces (workspace_uuid, name)
VALUES ('workspace-uuid-1', 'a company'),
       ('workspace-uuid-2', 'b company'),
       ('workspace-uuid-3', 'c company');

INSERT INTO channels (channel_uuid, name, workspace_uuid)
VALUES ('channel-uuid-1', '一般', 'workspace-uuid-1'),
       ('channel-uuid-2', '開発', 'workspace-uuid-1'),
       ('channel-uuid-3', '経理', 'workspace-uuid-1'),
       ('channel-uuid-4', '一般', 'workspace-uuid-2'),
       ('channel-uuid-5', 'プロジェクトA', 'workspace-uuid-2');

INSERT INTO workspace_events (user_uuid, status, workspace_uuid)
VALUES ('user-uuid-1', '参加', 'workspace-uuid-1'),
       ('user-uuid-1', '参加', 'workspace-uuid-2'),
       ('user-uuid-1', '参加', 'workspace-uuid-3'),
       ('user-uuid-2', '参加', 'workspace-uuid-1'),
       ('user-uuid-2', '参加', 'workspace-uuid-2'),
       ('user-uuid-2', '参加', 'workspace-uuid-3'),
       ('user-uuid-3', '参加', 'workspace-uuid-1'),
       ('user-uuid-3', '参加', 'workspace-uuid-2'),
       ('user-uuid-3', '参加', 'workspace-uuid-3'),
       ('user-uuid-3', '退会', 'workspace-uuid-1'),
       ('user-uuid-3', '退会', 'workspace-uuid-2'),
       ('user-uuid-3', '退会', 'workspace-uuid-3');

INSERT INTO channel_events (user_uuid, status, channel_uuid)
VALUES ('user-uuid-1', '参加', 'channel-uuid-1'),
       ('user-uuid-1', '参加', 'channel-uuid-2'),
       ('user-uuid-1', '参加', 'channel-uuid-3'),
       ('user-uuid-1', '参加', 'channel-uuid-4'),
       ('user-uuid-1', '参加', 'channel-uuid-5'),
       ('user-uuid-2', '参加', 'channel-uuid-1'),
       ('user-uuid-2', '参加', 'channel-uuid-2'),
       ('user-uuid-2', '参加', 'channel-uuid-3'),
       ('user-uuid-2', '参加', 'channel-uuid-4'),
       ('user-uuid-2', '参加', 'channel-uuid-5'),
       ('user-uuid-2', '退会', 'channel-uuid-4'),
       ('user-uuid-2', '退会', 'channel-uuid-5');

INSERT INTO messages (message_uuid, content, type)
VALUES ('message-uuid-1', 'こんにちは', 'message'),
       ('message-uuid-2', '進捗はどうですか？', 'thread_message'),
       ('message-uuid-3', 'こんばんは', 'message'),
       ('message-uuid-4', '次のミーティングはいつにしますか', 'message'),
       ('message-uuid-5', '来週の火曜日にしましょう', 'thread_message'),
       ('message-uuid-6', '火曜日は都合がわるいです。水曜日は？', 'thread_message'),
       ('message-uuid-7', '〇〇について質問があります', 'message'),
       ('message-uuid-8', '来週のスケジュールを調整しましょう', 'message'),
       ('message-uuid-9', '来週いっぱい休みいただいています', 'thread_message'),
       ('message-uuid-10', 'では出勤メンバーだけでスケジュール調整します', 'thread_message');

INSERT INTO thread_messages (thread_message_uuid, post_order, parent_message_uuid, message_uuid)
VALUES ('thread-message-uuid-1', 1, 'message-uuid-1', 'message-uuid-2'),
       ('thread-message-uuid-2', 1, 'message-uuid-4', 'message-uuid-5'),
       ('thread-message-uuid-3', 2, 'message-uuid-4', 'message-uuid-6'),
       ('thread-message-uuid-4', 1, 'message-uuid-8', 'message-uuid-9'),
       ('thread-message-uuid-5', 2, 'message-uuid-8', 'message-uuid-10');

INSERT INTO posts (post_uuid, status, user_uuid, message_uuid, channel_uuid)
VALUES ('post-uuid-1', 'CREATED', 'user-uuid-1', 'message-uuid-1', 'channel-uuid-1'),
       ('post-uuid-2', 'CREATED', 'user-uuid-2', 'message-uuid-2', 'channel-uuid-1'),
       ('post-uuid-3', 'CREATED', 'user-uuid-1', 'message-uuid-3', 'channel-uuid-2'),
       ('post-uuid-4', 'CREATED', 'user-uuid-1', 'message-uuid-4', 'channel-uuid-1'),
       ('post-uuid-5', 'CREATED', 'user-uuid-1', 'message-uuid-5', 'channel-uuid-1'),
       ('post-uuid-6', 'CREATED', 'user-uuid-1', 'message-uuid-6', 'channel-uuid-1'),
       ('post-uuid-7', 'DELETED', 'user-uuid-1', 'message-uuid-7', 'channel-uuid-1'),
       ('post-uuid-8', 'UPDATED', 'user-uuid-1', 'message-uuid-8', 'channel-uuid-1'),
       ('post-uuid-9', 'CREATED', 'user-uuid-1', 'message-uuid-9', 'channel-uuid-1'),
       ('post-uuid-10', 'DELETED', 'user-uuid-1', 'message-uuid-10', 'channel-uuid-1');
