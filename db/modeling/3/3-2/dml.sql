INSERT INTO users (name) VALUES
('田中一郎'),
('佐藤花子'),
('鈴木次郎');

INSERT INTO user_statuses (user_id, status) VALUES
(1, '有効'),
(2, '削除済'),
(3, '有効');

INSERT INTO directories (name) VALUES
('documents'),
('biz'),
('tmp'),
('test');

INSERT INTO directory_paths (parent_id, child_id) VALUES
(1, 2),
(1, 3),
(3, 4);

INSERT INTO documents (title, content) VALUES
('ドキュメント1', '1つめのドキュメント'),
('ドキュメント2', '2つめのドキュメント'),
('ドキュメント3', '3つめのドキュメント');

INSERT INTO document_histories (document_id, title, content) VALUES
(1, 'ドキュメント1', '1つめのドキュメント'),
(2, 'ドキュメント2', '2つめのドキュメント'),
(3, 'ドキュメント3', '3つめのドキュメント');

INSERT INTO writes (user_id, directory_id, document_id) VALUES
(1, 1, 1),
(2, 1, 2),
(2, 3, 3);

INSERT INTO write_statuses (write_id, user_id, status) VALUES
(1, 1, '公開中'),
(2, 2, '公開中'),
(3, 2, '公開中');

INSERT INTO document_order (directory_id, document_id, priority) VALUES
(1, 1, 1),
(1, 2, 2),
(3, 3, 1);
