# 2-1

### 設計意図
- トランザクションや履歴管理を別テーブル用意したくないので今回は、イミュータブルデータモデリングで設計しました
- 事実を記録する
- UPDATE が発生しないことによるデータ量の増加は許容する方針

### Event と Resource の整理

- Event は動詞で表現できるもの。〜する、〜日で表現して違和感のないものがEvent系と判断
- Resource は名詞で表現できるもの。Event系のように〜日で表現できないものをResource系と判断

#### Event 
- 参加,脱退
  - ユーザーがワークスペースに参加する, 脱退する
  - ユーザーがチャンネルに参加する, 脱退する
- 投稿
  - ユーザーがチャンネルにメッセージを投稿する, 編集する, 削除する
  - ユーザーがチャンネルのメッセージにスレッドメッセージを投稿する, 編集する, 削除する
- 検索

#### Resource
- ユーザー
- ワークスペース
- チャンネル
- メッセージ
- スレッドメッセージ

### ERD

```mermaid
---
title: チャットサービス
---
erDiagram
  users {
    int id PK
    varchar user_uuid
    varchar name
    varchar email
    varchar password
    varchar salt
    timestamp created_at
  }
  workspaces {
    int id PK
    varchar workspace_uuid
    varchar name
    timestamp created_at
  }
  channels {
    int id PK
    varchar channel_uuid
    varchar name
    varchar workspace_uuid FK
    timestamp created_at
  }
  join_workspaces {
    int id PK
    varchar user_uuid FK
    int workspace_id FK
    timestamp joined_at
  }
  join_channels {
    int id PK
    varchar user_uuid FK
    int channel_id FK
    timestamp joined_at
  }
  leave_workspaces{
    int id PK
    varchar user_uuid FK
    varchar workspace_uuid FK
    timestamp left_at
  }
  leave_channels{
    int id PK
    varchar user_uuid FK
    varchar channel_uuid FK
    timestamp left_at
  }
  posts{
    int id PK
    varchar post_uuid
    varchar status
    varchar user_uuid FK
    varchar message_uuid FK
    varchar channel_uuid FK
    timestamp posted_at
  }
  messages {
    int id PK
    varchar message_uuid
    varchar content
    varchar type
    timestamp created_at
  }
  messages ||--o{ thread_messages: "has"
  thread_messages {
    int id PK
    varchar thread_message_uuid
    varchar status
    varchar parent_message_uuid FK
    timestamp created_at
  }
  
  users }|--o{ join_workspaces: "creates"
  users }|--o{ join_channels: "creates"
  users }|--o{ leave_workspaces: "creates"
  users }|--o{ leave_channels: "creates"
  users }|--o{ posts: "creates"
  channels }| -- || workspaces: "belongs to"
  posts ||--|{ channels: "has"
  posts ||--|{ messages: "has"
  join_workspaces }|--|| workspaces: "has"
  join_channels }|--|| channels: "has"
  leave_workspaces }|--|| workspaces: "has"
  leave_channels }|--|| channels: "has"
```

### メモ

- あるメッセージが更新されたら、それに紐づくスレッドメッセージもつけかえが必要になる
- つまりPKだけで管理するとややこしいなになりそう
- メッセージとスレッドメッセージの話は以前あったセットメニューの扱いとか、注文に対する明細の扱いが近い
- 参考
  - https://scrapbox.io/kawasima/%E3%82%A4%E3%83%9F%E3%83%A5%E3%83%BC%E3%82%BF%E3%83%96%E3%83%AB%E3%83%87%E3%83%BC%E3%82%BF%E3%83%A2%E3%83%87%E3%83%AB
  - https://qiita.com/tonbi_attack/items/59439398a4899506de0e
