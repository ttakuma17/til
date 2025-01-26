-- ドキュメントを更新して履歴を追加するようにファイルをわける
UPDATE documents SET title = 'ドキュメント1', content = '1つめのドキュメントの更新版' WHERE id = 1;
INSERT INTO document_histories (document_id, title, content) VALUES
(1, 'ドキュメント1', '1つめのドキュメントの更新版');

