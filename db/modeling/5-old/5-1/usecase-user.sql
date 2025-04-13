-- ユーザー関連のユースケース
-- ユーザーの新規登録
WITH new_user AS (
    INSERT INTO users (id) 
    VALUES ('user3')
    RETURNING id
)
INSERT INTO user_profile_versions (
    id, user_id, version, name, email
) 
SELECT 
    'profile4',
    'user3',
    1,
    '一般ユーザー3',
    'user3@example.com'
FROM new_user;

INSERT INTO user_events (
    id, user_id, event_type_id, actor_user_id, role_id
) VALUES (
    'user_event5',
    'user3',
    'user_event_type_1',
    'system',
    'user_role_1'
);

-- プロフィール更新
WITH latest_version AS (
    SELECT COALESCE(MAX(version), 0) + 1 as next_version
    FROM user_profile_versions
    WHERE user_id = 'user3'
)
INSERT INTO user_profile_versions (
    id, user_id, version, name, email
) 
SELECT 
    'profile5',
    'user3',
    next_version,
    '一般ユーザー3',
    'user3-updated@example.com'
FROM latest_version;

INSERT INTO user_events (
    id, user_id, event_type_id, actor_user_id
) VALUES (
    'user_event6',
    'user3', 
    'user_event_type_2',
    'system'
);
