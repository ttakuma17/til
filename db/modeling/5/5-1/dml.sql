INSERT INTO user_event_types (id, name) VALUES
('user_event_type_1', 'REGISTER'),
('user_event_type_2', 'UPDATE_PROFILE'),
('user_event_type_3', 'ADD_ROLE'),
('user_event_type_4', 'REMOVE_ROLE'),
('user_event_type_5', 'WITHDRAW'),
('user_event_type_6', 'FORCE_OUT');

INSERT INTO user_roles (id, name) VALUES
('user_role_1', 'GENERAL'),
('user_role_2', 'ADMIN');

-- TODO これいるんか？
INSERT INTO users (id) VALUES ('system');
INSERT INTO user_profile_versions (id, user_id, version, name, email) 
VALUES ('system-profile', 'system', 1, 'System', 'system@example.com');
INSERT INTO user_events (
    id, user_id, event_type_id, actor_user_id, role_id
) VALUES (
    'system-create', 'system', 'user_event_type_1', 'system', 'user_role_2'
);

INSERT INTO article_event_types (id, name) VALUES
('article_event_type1', 'DRAFT_CREATED'),
('article_event_type2', 'DRAFT_UPDATED'),
('article_event_type3', 'PUBLISHED'),
('article_event_type4', 'UNPUBLISHED'),
('article_event_type5', 'DELETED');

INSERT INTO users (id) VALUES
('user1'),
('user2'),
('admin1');

INSERT INTO user_profile_versions (id, user_id, version, name, email) VALUES
('profile1', 'user1', 1, '一般ユーザー1', 'user1@example.com'),
('profile2', 'user2', 1, '一般ユーザー2', 'user2@example.com'),
('profile3', 'admin1', 1, '管理者1', 'admin1@example.com');

INSERT INTO user_events (id, user_id, event_type_id, actor_user_id, role_id) VALUES
('user_event1', 'user1', 'user_event_type_1', 'system', 'user_role_1'),
('user_event2', 'user2', 'user_event_type_1', 'system', 'user_role_1'),
('user_event3', 'admin1', 'user_event_type_1', 'system', 'user_role_1'), -- 管理者1の登録と権限付与イベント
('user_event4', 'admin1', 'user_event_type_3', 'system', 'user_role_2');

INSERT INTO articles (id) VALUES
('article1'), -- 公開済み記事
('article2'), -- 下書き記事
('article3'); -- 削除済み記事

INSERT INTO article_versions (id, article_id, version, title, text, created_at) VALUES
('version1', 'article1', 1, '最初の記事', '最初の記事の本文です。', '2024-03-14 10:00:00'),
('version2', 'article1', 2, '最初の記事（更新済み）', '最初の記事の本文を更新しました。', '2024-03-14 11:00:00'),
('version3', 'article2', 1, '下書き記事', '下書き記事の本文です。', '2024-03-14 12:00:00'),
('version4', 'article3', 1, '削除予定の記事', '削除予定の記事の本文です。', '2024-03-14 13:00:00'),
('version5', 'article3', 2, '削除予定の記事（更新済み）', '削除予定の記事の本文を更新しました。', '2024-03-14 14:00:00');

INSERT INTO article_events (id, article_id, event_type_id, user_id, occurred_at) VALUES
('event1', 'article1', 'article_event_type1', 'user1', '2024-03-14 10:00:00'),
('event2', 'article1', 'article_event_type3', 'user1', '2024-03-14 10:30:00'),
('event3', 'article1', 'article_event_type2', 'user1', '2024-03-14 11:00:00'),
('event4', 'article1', 'article_event_type3', 'user1', '2024-03-14 11:30:00'),
('event5', 'article2', 'article_event_type1', 'user2', '2024-03-14 12:00:00'),
('event6', 'article3', 'article_event_type1', 'user1', '2024-03-14 13:00:00'),
('event7', 'article3', 'article_event_type3', 'user1', '2024-03-14 13:30:00'),
('event8', 'article3', 'article_event_type2', 'user1', '2024-03-14 14:00:00'),
('event9', 'article3', 'article_event_type3', 'user1', '2024-03-14 14:30:00'),
('event10', 'article3', 'article_event_type5', 'admin1', '2024-03-14 15:00:00');
