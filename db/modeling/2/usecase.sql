-- あるチャンネルを参加済みのユーザーの一覧を取得
select users.user_uuid, name, status
from users
join channel_events on users.user_uuid = channel_events.user_uuid
where channel_uuid = 'channel-uuid-4' and status = '参加';

-- 特定のメッセージとそれにひもづくスレッドメッセージをすべて取得
explain select *
from messages
left join thread_messages on messages.message_uuid = thread_messages.message_uuid
where 'message-uuid-4' in (messages.message_uuid, parent_message_uuid)
order by messages.message_uuid;

-- 火曜日を含む文字列を検索する
select messages.message_uuid, messages.content, messages.type, posts.channel_uuid
from messages
    join posts
        on posts.message_uuid = messages.message_uuid
    join channel_events
        on channel_events.channel_uuid = posts.channel_uuid and channel_events.user_uuid = posts.user_uuid
where channel_events.user_uuid = 'user-uuid-1' and channel_events.status = '参加'
  and messages.content like '%火曜日%';


