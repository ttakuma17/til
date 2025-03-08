# 5-1

## 設計意図
- テーブルの増加を重く捉えずに、責務ごとにテーブルを分ける方針
- ResourceとEventに分けて設計する
- 完全にUPDATEのSQLが発生しないテーブル設計にする
- テーブル数は増えており、単純にJOINSしてSELECT系を実行することで取得はできるが、性能問題があると仮定して、できるだけSQLで性能問題を回避できるようにusecaseのSQLを工夫する方針

## 仕様
### ユーザー
- ユーザーはユーザー情報を自由に変更できる
- ユーザーにはロールがあり、一般ユーザーと管理者ユーザーを持つ。
- 一般ユーザーは、「入会」「退会」イベント、管理者ユーザーも「入会」「退会」イベントと一般ユーザーに対する「強制退会」イベントを実行できる 
- ユーザーは複数のロールを割り当てることができる。

### 記事
- 記事の種別として、ドラフト記事と公開記事を持つ
- ドラフト記事に対するイベントとしては「ドラフト作成」「ドラフト削除」
- 公開記事に対するイベントとしては「記事公開」「記事非公開」「記事削除」がある
- 公開記事を公開後に編集する場合は、ドラフト記事を作成し、新たなバージョンの記事は記事公開イベントを通して、公開される


### ER図
```mermaid
---
title: ブログサービス
---
erDiagram
  %% ユーザー(R)
  users {
    varchar id PK
  }

  %% ユーザー情報(R)
  user_profiles {
    varchar id PK
    varchar user_id FK
    varchar name
    varchar email
  }

  %% ユーザー情報変更イベント(E)
  user_profile_change_events {
    varchar id PK
    varchar user_id FK
    varchar user_profile_id FK
    timestamp changed_date
  }

  %% ユーザーロール(R)
  user_roles {
    varchar id PK
    varchar name
  }

  %% セルフサインアップイベント(E)
  user_self_registration_events {
    varchar id PK
    varchar user_id FK
    varchar role_id FK
    varchar user_profile_id FK
    timestamp registered_date
  }

  %% ユーザーロール割り当てイベント(E)
  user_role_assignment_events {
    varchar id PK
    varchar user_id FK
    varchar role_id FK
    varchar assigned_by_user_id FK
    timestamp assigned_date
  }
  
  %% 強制退会イベント(E)
  user_forced_withdrawal_events {
    varchar id PK
    varchar user_id FK
    varchar admin_user_id FK
    varchar reason
    timestamp forced_withdrawn_date
  }


  %% ユーザー退会イベント(E)
  user_withdrawal_events {
    varchar id PK
    varchar user_id FK
    timestamp withdrawn_date
  }

  
  %% 記事(R)
  articles {
    varchar id PK
  }

  %% ドラフト作成(E)
  draft_creation_events {
    varchar id PK
    varchar article_id FK
    varchar user_id FK
    timestamp draft_created_date
  }

  %% ドラフト削除(E)
  draft_deletion_events {
    varchar id PK
    varchar article_id FK
    varchar user_id FK
    timestamp draft_deleted_date
  }

  %% ドラフト記事(R)
  draft_articles {
    varchar id PK
    varchar title
    varchar text
    varchar article_id FK
  }

  %% 記事公開(E)
  article_publication_events {
    varchar id PK
    varchar article_id FK
    varchar user_id FK
    timestamp published_date
  }

  %% 記事非公開(E)
  article_unpublication_events {
    varchar id PK
    varchar article_id FK
    varchar user_id FK
    timestamp unpublished_date
  }
  
  %% 公開記事(R)
  published_articles {
    varchar id PK
    varchar title
    varchar text
    varchar article_id FK
  }

  %% 記事削除(E)
  article_deletion_events {
    varchar id PK
    varchar article_id FK
    varchar user_id FK
    timestamp deleted_date
  }

  user_profiles }o--|| users: "belongs to"
  user_profile_change_events }o--|| users: "changes"
  user_profile_change_events }o--|| user_profiles: "creates"
  user_self_registration_events }o--|| users: "has"
  user_self_registration_events }o--|| user_profiles: "creates"
  user_self_registration_events}o--||user_roles: "has"
  user_role_assignment_events }o--||user_roles: "has"
  user_withdrawal_events }o--|| users: "has"
  user_role_assignment_events }o--|| users: "has"
  user_forced_withdrawal_events }o--|| users: "has"
  users ||--o{ draft_creation_events: "creates"
  users ||--o{ draft_deletion_events: "deletes"
  users ||--o{ article_publication_events: "publishes"
  users ||--o{ article_unpublication_events: "unpublishes"
  users ||--o{ article_deletion_events: "deletes"
  articles ||--o{ draft_articles: "has"
  articles ||--o{ published_articles: "has"
  draft_creation_events }o--|| articles: "creates"
  draft_deletion_events }o--|| articles: "deletes"
  article_publication_events }o--|| articles: "publishes"
  article_unpublication_events }o--|| articles: "unpublishes"
  article_deletion_events }o--|| articles: "deletes"
```



