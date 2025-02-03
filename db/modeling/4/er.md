### 仕様整理
- https://qiita.com/dowanna6/items/b5d1d0245985a26abf8e
- https://penpen.netlify.app/

penpenするユーザーはタスクをどんな間隔でリマインドするかを決める
penpenされるユーザーは誰からなんのタスク依頼がきたのかが通知される
penpenされるユーザーはタスクの完了をマークできる
penpenするユーザーは自分に対しても、penpenすることができる

/penpen 自分がだれかにタスクを依頼する
/penpen-outgoing 自分が設定したタスク一覧を表示
/penpen-list 自分宛てのタスク一覧を表示する


### 設計意図
- 履歴を取りたいようなデータもないと判断し、ミュータブルな形でデータモデリングする
- ユーザーの管理はSlack側が担うので、データベースとしてユーザーを管理することはないものとする
  - https://api.slack.com/methods/users.info
- タスクの通知間隔は hours / days で最小間隔で1hour最大間隔で7daysの仕様とする
- 設定の間違いの担保はデータベース側で行うために、interval_typesとinterval_settingsのテーブルを定義
  - もともとはremindsテーブルに interval_typeとintervalをカラムで持たせていました。以下の考慮がアプリケーション側によってしまうので、DB側で対応できるようにするならという意味でテーブル追加しました。
    - interval_type には day / hour が入りうるが、どのようにして入れ間違いを防ぐのか
    - 25hoursにしたりするのをどう防ぐか?
    - 8daysにしたのをどう防ぐか?
    - 0を入れないという対応の担保

### ERD

```mermaid
---
title: penpen
---
erDiagram
  %% 依頼者(R)
  clients {
    int id PK
    varchar slackId
    timestamp created_at
    timestamp updated_at
  }
  %% リマインド (E)
  reminds {
    int id PK
    varchar content
    boolean done
    int client_id FK
    int representative_id FK
    int task_id FK
    int interval_setting_id FK
    timestamp created_at
    timestamp updated_at
  }
  %% 担当者(R)
  representatives {
    int id PK
    varchar slackId
    timestamp created_at
    timestamp updated_at
  }
  %% タスク(R)
  tasks {
    int id PK
    varchar content
    timestamp created_at
    timestamp updated_at
  }
  %% リマインド間隔タイプ(R)
  interval_types {
    int id PK
    varchar name "hour または day"
    int max_value "hour:24, day:7"
    timestamp created_at
    timestamp updated_at
  }
  %% リマインド間隔設定(R)
  interval_settings {
    int id PK
    int interval_type_id FK
    int interval "CHECK (interval >= 1)"
    timestamp created_at
    timestamp updated_at
  }
  
  clients ||--o{ reminds: "creates"
  reminds }|--|| representatives: "has"
  reminds }|--|| tasks: "has"
  reminds ||--|| interval_settings: "has"
  interval_settings }|--|| interval_types: "has"
```
 