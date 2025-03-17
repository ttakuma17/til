-- ディレクトリ内のドキュメントの順番を取得する 
SELECT
    directory_id,
    document_id,
    priority
    -- ROW_NUMBER() OVER (PARTITION BY directory_id ORDER BY priority) as display_order -- 最悪priorityに抜けが生まれたとしても、display_orderで何番目かは出してくれるが今は不要
FROM
    document_order
WHERE directory_id = 1;

-- ドキュメントの追加
INSERT INTO document_order (directory_id, document_id, priority) 
VALUES (1, 3, 4);

-- ドキュメントの移動 2番と3番いれかえ
UPDATE document_order 
SET priority = CASE 
    WHEN priority = 2 THEN 3 
    WHEN priority = 3 THEN 2
    ELSE priority
    END
WHERE priority IN(2, 3)
