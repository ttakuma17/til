-- ユーザー登録
WITH new_user AS (
    INSERT INTO users (id) 
    VALUES (:user_id)
    RETURNING id
)
INSERT INTO user_profile_versions (
    id, user_id, version, name, email
) 
SELECT 
    :profile_id,
    id,
    1,
    :name,
    :email
FROM new_user;

INSERT INTO user_events (
    id, user_id, event_type_id, actor_user_id, version, role_id
) VALUES (
    :event_id,
    :user_id,
    'REGISTER',
    'system',
    1,
    'GENERAL'
);

-- プロフィール更新
WITH latest_version AS (
    SELECT COALESCE(MAX(version), 0) + 1 as next_version
    FROM user_profile_versions
    WHERE user_id = :user_id
)
INSERT INTO user_profile_versions (
    id, user_id, version, name, email
) 
SELECT 
    :profile_id,
    :user_id,
    next_version,
    :name,
    :email
FROM latest_version;

INSERT INTO user_events (
    id, user_id, event_type_id, actor_user_id, version
) 
SELECT 
    :event_id,
    :user_id,
    'PROFILE',
    :actor_user_id,
    next_version
FROM latest_version;

-

-- 記事関連のユースケース --

-- 1. 記事の作成から公開までの流れ
-- 1.1 記事の新規作成（下書き）
INSERT INTO articles (id) VALUES (:article_id);

INSERT INTO article_versions (id, article_id, version, title, text)
VALUES (:version_id, :article_id, 1, :title, :text);

INSERT INTO article_events (
    id, article_id, event_type_id, user_id, version, status
) VALUES (
    :event_id, :article_id, 'CREATE', :user_id, 1, 'draft'
);

-- 1.2 記事の更新
WITH latest_version AS (
    SELECT COALESCE(MAX(version), 0) + 1 as next_version
    FROM article_versions
    WHERE article_id = :article_id
)
INSERT INTO article_versions (id, article_id, version, title, text)
SELECT :version_id, :article_id, next_version, :title, :text
FROM latest_version;

INSERT INTO article_events (
    id, article_id, event_type_id, user_id, version, status
) 
SELECT :event_id, :article_id, 'VERSION', :user_id, next_version, 'draft'
FROM latest_version;

-- 1.3 記事の公開
INSERT INTO article_events (
    id, article_id, event_type_id, user_id, version, status
)
SELECT 
    :event_id, :article_id, 'PUBLISH', :user_id, 
    (SELECT MAX(version) FROM article_versions WHERE article_id = :article_id),
    'published';

-- 2. 記事の閲覧系
-- 2.1 公開中の記事一覧を取得
WITH latest_article_states AS (
    SELECT 
        ae.article_id,
        ae.status,
        ae.occurred_at,
        ae.user_id,
        ROW_NUMBER() OVER (
            PARTITION BY ae.article_id 
            ORDER BY ae.occurred_at DESC
        ) as rn
    FROM article_events ae
),
latest_versions AS (
    SELECT 
        article_id,
        MAX(version) as latest_version
    FROM article_versions
    GROUP BY article_id
)
SELECT 
    a.id,
    av.title,
    av.text,
    av.version,
    av.created_at,
    up.name as author_name
FROM articles a
JOIN latest_versions lv ON a.id = lv.article_id
JOIN article_versions av ON a.id = av.article_id 
    AND av.version = lv.latest_version
JOIN latest_article_states las ON a.id = las.article_id
    AND las.rn = 1
    AND las.status = 'published'
JOIN user_profile_versions up ON las.user_id = up.user_id
WHERE up.version = (
    SELECT MAX(version)
    FROM user_profile_versions
    WHERE user_id = las.user_id
)
ORDER BY av.created_at DESC;

-- 2.2 特定の記事の履歴を取得
SELECT 
    av.version,
    av.title,
    av.text,
    av.created_at,
    ae.event_type_id,
    aet.name as event_name,
    ae.status,
    up.name as modified_by_user
FROM article_versions av
JOIN article_events ae ON av.article_id = ae.article_id 
    AND av.version = ae.version
JOIN article_event_types aet ON ae.event_type_id = aet.id
JOIN user_profile_versions up ON ae.user_id = up.user_id
    AND up.version = (
        SELECT MAX(version)
        FROM user_profile_versions
        WHERE user_id = ae.user_id
    )
WHERE av.article_id = :article_id
ORDER BY av.version DESC;

-- 3. 記事の状態変更
-- 3.1 記事を非公開にする
INSERT INTO article_events (
    id, article_id, event_type_id, user_id, version, status
)
SELECT 
    :event_id, :article_id, 'UNPUBLISH', :user_id,
    (SELECT MAX(version) FROM article_versions WHERE article_id = :article_id),
    'unpublished';

-- 3.2 記事を削除する
INSERT INTO article_events (
    id, article_id, event_type_id, user_id, version, status
)
SELECT 
    :event_id, :article_id, 'DELETE', :user_id,
    (SELECT MAX(version) FROM article_versions WHERE article_id = :article_id),
    'deleted';

-- 3.3 過去バージョンの記事を復元
WITH latest_version AS (
    SELECT COALESCE(MAX(version), 0) + 1 as next_version
    FROM article_versions
    WHERE article_id = :article_id
)
INSERT INTO article_versions (id, article_id, version, title, text)
SELECT 
    :new_version_id, :article_id, next_version, title, text
FROM article_versions
WHERE article_id = :article_id 
AND version = :selected_version;

INSERT INTO article_events (
    id, article_id, event_type_id, user_id, version, status
) 
SELECT 
    :event_id, :article_id, 'VERSION', :user_id, next_version, 'draft'
FROM latest_version;
