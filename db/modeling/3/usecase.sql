-- ディレクトリ配下の公開中ドキュメントを取得
SELECT 
    documents.id as "ドキュメントID",
    documents.title as "タイトル",
    documents.content as "本文"
FROM directories 
JOIN writes ON writes.directory_id = directories.id
JOIN write_statuses ON write_statuses.write_id = writes.id 
JOIN documents on documents.id = writes.document_id
WHERE directories.name = 'documents' AND write_statuses.status = '公開中';

-- 特定ディレクトリ配下のディレクトリ一覧を表示
SELECT 
    directories.id AS 親ディレクトリID,
    directories.name AS 親ディレクトリ名,
    self_directories.name AS 子ディレクトリ名
FROM directories
JOIN directory_paths ON directories.id = directory_paths.parent_id
JOIN directories AS self_directories ON directory_paths.child_id = self_directories.id
WHERE directories.name = 'documents'; 

-- 特定のドキュメントの更新履歴を作成日時順に取得
SELECT * FROM document_histories 
WHERE document_id = 1 
ORDER BY created_at DESC

-- 別のディレクトリへドキュメントを移動
UPDATE writes 
SET directory_id = 3, user_id = 2
WHERE writes.id = 1
