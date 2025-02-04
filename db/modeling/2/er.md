# 2-1

### 設計意図
- トランザクションや履歴管理を別テーブル用意したくないので今回は、イミュータブルデータモデリングで設計しました。
- UPDATE が発生させないことによるデータ量の増加は許容する方針です。
- messageとthread_messageについて
  - messagesテーブルのtypeカラムで「message」か「thread_message」という値で投稿したメッセージの種別を管理します。
  - thread_messagesテーブルのparent_message_idでどのメッセージに紐づくスレッドメッセージかを判断して、statusによって表示する方針です。スレッドメッセージがあとから編集されたときに順序を保つために、post_orderのカラムを使います。
- uuidを使用する予定の箇所のデータ型はvarcharにしています。業務で使用しているライブラリがuuid対応していないため。 
- usersテーブルには本来パスワードなどのカラムが必要ですが、今回のテーブル設計では認証周りの要件は外しました。

### Event と Resource の整理について
- Event は動詞で表現できるもの。〜する、〜日で表現して違和感のないものがEvent系と判断
- Resource は名詞で表現できるもの。Event系のように〜日で表現できないものをResource系と判断
- mermaidで表現したERDのコメントとしてテーブル名(E/R)を追加
  - E: Entity
  - R: Resource
- 「事実を記録」するという方針でEventを分けています。チャンネルの参加とワークスペースの参加は異なるEventのため別々に記録。退出を参加と同じテーブルで管理しようとしたが、参加日と退出日というカラムが必要になるため、別々のテーブルで管理する方針にした。
  - ただし、チャンネルの参加と退出などの管理をするテーブルとして、参加/退出をstatusとして管理すれば、１テーブルで良いはずとも考えました。なので、今よりよい設計がありそうかなとは思ってます。
  - この案を採用しなかったのは、「チャンネル所属管理」みたいな目的が人によって変わる名前しか思いつかなかったため。

### ERD

```mermaid
---
title: チャットサービス
---
erDiagram
  %% ユーザー(R)
  users {
    int id PK
    varchar user_uuid
    varchar name
    varchar email
    timestamp created_at
  }
  %% ワークスペース(R) 
  workspaces {
    int id PK
    varchar workspace_uuid
    varchar name
    timestamp created_at
  }
  %% チャンネル(R)
  channels {
    int id PK
    varchar channel_uuid
    varchar name
    varchar workspace_uuid FK
    timestamp created_at
  }
  %% ワークスペースイベント(E)
  workspace_events {
    int id PK
    varchar status
    varchar user_uuid FK
    int workspace_id FK
    timestamp created_at
  }
  %% チャンネルイベント(E)
  channel_events {
    int id PK
    varchar status
    varchar user_uuid FK
    int channel_id FK
    timestamp created_at
  }
  %% 投稿(E)
  posts {
    int id PK
    varchar post_uuid
    varchar status
    varchar user_uuid FK
    varchar message_uuid FK
    varchar channel_uuid FK
    timestamp posted_at
  }
  %% メッセージ(R)
  messages {
    int id PK
    varchar message_uuid
    varchar content
    varchar type
    timestamp created_at
  }
  %% スレッドメッセージ(R)
  thread_messages {
    int id PK
    varchar thread_message_uuid
    int post_order
    varchar parent_message_uuid FK
    varchar message_uuid FK
    timestamp created_at
  }
        
  users ||--o{ workspace_events: "creates"
  users ||--o{ channel_events: "creates"
  users ||--o{ posts: "creates"
  channels }| -- || workspaces: "belongs to"
  posts ||--|{ channels: "has"
  posts ||--|{ messages: "has"
  messages ||--o{ thread_messages: "has"
  workspace_events }|--|| workspaces: "has"
  channel_events }|--|| channels: "has"
```

### 微妙と思ってること
- スレッドメッセージの順序をどう管理するのがベストか？
  - 今の設計だと、投稿時にparent_message_idに紐づくスレッドメッセージの件数をカウントしてから、Insertしないと順序が保てないのが気になる
- チャンネルイベントとワークスペースイベントと言う名前
  - 役割わかりにくいからこの命名はいやだが、いいの思いつかなかった
  - ステータスごとにテーブルを分ければ、テーブル名としてはわかりやすいがJOINが多数必要になる。
  - 今回はそこまでjoinさせたくないというのを優先してテーブルへまとめた
- 各テーブルのIDが Auto increment と uuidで2つ存在していること
  - updateしない設計なので、messageがあとから編集されたときにも過去の履歴はテーブルに残る
  - ただし、他のテーブルから参照されているものを編集すると都合が悪いので、uuidは変えずに新しいレコードを作成するという方針にしている
  - もうちょいうまいやり方がありそう

#### 参考
- [イミュータブルデータモデル](https://scrapbox.io/kawasima/%E3%82%A4%E3%83%9F%E3%83%A5%E3%83%BC%E3%82%BF%E3%83%96%E3%83%AB%E3%83%87%E3%83%BC%E3%82%BF%E3%83%A2%E3%83%87%E3%83%AB)
- [DB設計のアプローチ：マスタ・トランザクション vs イミュータブルデータモデル](https://qiita.com/tonbi_attack/items/59439398a4899506de0e)