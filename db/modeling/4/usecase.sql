-- /penpen-outgoing 自分(U1234567890)が設定したタスク一覧を表示
SELECT * FROM clients JOIN reminds ON clients.id = reminds.client_id
WHERE slack_id = 'U1234567890' AND done = FALSE;

-- /penpen-list 自分宛てのタスク一覧を表示する
SELECT * FROM representatives JOIN reminds ON representatives.id = reminds.representative_id
WHERE slack_id = 'U1234567890' AND done = FALSE;
