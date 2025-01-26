-- ユーザー (R)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ユーザーステータス (R)
CREATE TABLE user_statuses (
    user_id INTEGER REFERENCES users(id),
    status VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, created_at)
);

-- ディレクトリ(R)
CREATE TABLE directories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ディレクトリパス(R)
CREATE TABLE directory_paths (
    parent_id INTEGER REFERENCES directories(id) ON DELETE CASCADE,
    child_id INTEGER REFERENCES directories(id) ON DELETE CASCADE,
    PRIMARY KEY (parent_id, child_id)
);

-- ドキュメント(R)
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ドキュメント履歴(R)
CREATE TABLE document_histories (
    document_id INTEGER REFERENCES documents(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (document_id, created_at)
);

-- 執筆
CREATE TABLE writes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    directory_id INTEGER REFERENCES directories(id),
    document_id INTEGER REFERENCES documents(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 執筆状況
CREATE TABLE write_statuses (
    write_id INTEGER REFERENCES writes(id),
    user_id INTEGER REFERENCES users(id),
    status VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (write_id, created_at)
);