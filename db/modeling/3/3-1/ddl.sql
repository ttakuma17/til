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
    status VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, created_at)
);
CREATE INDEX user_statuses_user_id_idx ON user_statuses (user_id); 

-- ディレクトリ(R)
CREATE TABLE directories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX directory_name_idx ON directories (name); 

-- ディレクトリパス(R)
CREATE TABLE directory_paths (
    parent_id INTEGER REFERENCES directories(id),
    child_id INTEGER REFERENCES directories(id),
    PRIMARY KEY (parent_id, child_id)
);
CREATE INDEX directory_paths_parent_id_idx ON directory_paths (parent_id); 
CREATE INDEX directory_paths_child_id_idx ON directory_paths (child_id); 

-- ドキュメント(R)
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ドキュメント履歴(R)
CREATE TABLE document_histories (
    document_id INTEGER REFERENCES documents(id),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (document_id, created_at)
);
CREATE INDEX document_histories_document_id_idx ON document_histories (document_id); 

-- 執筆 (E)
CREATE TABLE writes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    directory_id INTEGER REFERENCES directories(id),
    document_id INTEGER REFERENCES documents(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX writes_user_id_idx ON writes (user_id);
CREATE INDEX writes_directory_id_idx ON writes (directory_id); 
CREATE INDEX writes_document_id_idx ON writes (document_id); 

-- 執筆状況 (R)
CREATE TABLE write_statuses (
    write_id INTEGER REFERENCES writes(id),
    user_id INTEGER REFERENCES users(id),
    status VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (write_id, created_at)
);
CREATE INDEX write_statuses_write_id_idx ON writes (write_id);
CREATE INDEX write_statuses_user_id_idx ON writes (user_id);
