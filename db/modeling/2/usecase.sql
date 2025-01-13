-- あるチャンネルを参加済みのユーザーの一覧を出す
select users.name, join_channels.user_uuid, leave_channels.user_uuid
from channels
join join_channels on channels.channel_uuid = join_channels.channel_uuid
left join leave_channels on leave_channels.channel_uuid = channels.channel_uuid
join users on join_channels.user_uuid = users.user_uuid
where channels.channel_uuid = 'channel-uuid-1'
  AND leave_channels.user_uuid IS NULL;

-- 特定のメッセージ(message-uuid-4)にひもづくスレッドメッセージをすべて表示する
select * from messages
    left join thread_messages on messages.message_uuid = thread_messages.message_uuid
where parent_message_uuid = 'message-uuid-4'

-- メッセージ検索する

