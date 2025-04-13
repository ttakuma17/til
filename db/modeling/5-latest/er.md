### アンチパターンと初回のDB設計で微妙だったところを見直し

変更点
- event_typeテーブルの削除
- 世代バージョンタグ付けパターンでどのバージョンに戻したかをおえるようにする

```mermaid
---
title: ブログサービス (5-1)
---
erDiagram
    users {
        varchar(36) id PK
    }

    user_profile_versions {
        varchar(36) id PK
        varchar(36) user_id FK
        int version
        varchar(255) name
        varchar(255) email
        timestamp created_at
    }

    user_roles {
        varchar(36) id PK
        varchar(50) name
    }

    user_events {
        varchar(36) id PK
        varchar(10) event_type
        varchar(36) user_id FK
        varchar(36) actor_user_id FK
        varchar(36) role_id FK
        varchar(1000) reason
        timestamp occurred_at
    }

    articles {
        varchar(36) id PK
    }
    
    active_articles {
        varchar(36) article_id FK
        varchar(36) article_version_id FK
    }

    article_versions {
        varchar(36) id PK
        varchar(36) article_id FK
        int version
        varchar(255) title
        text text
        timestamp created_at
    }

    article_events {
        varchar(36) id PK
        varchar(10) event_type
        varchar(36) article_id FK
        varchar(36) user_id FK
        varchar(50) status
        varchar(50) status
        timestamp occurred_at
    }

    %% リレーションシップ
    users ||--o{ user_profile_versions : ""
    users ||--o{ user_events : ""
    
    user_roles ||--o{ user_events : ""

    users ||--o{ article_events : ""
    articles ||--o{ article_versions : ""
    articles ||--o{ article_events : ""
```

変更点
- resultテーブル不要なので削除した。
　- resultテーブルは外部にAPI叩いた結果をもとに判定するなどであれば必要だが、今回は自身のアプリケーションに閉じるため不要
- トランザクション管理しない理由
  - どちらも登録できてたら問題なし。article_register_startで失敗したら、最初からやり直し。
article_transactionに失敗したら、article_startの登録だけなので記事の内容自体がないので使えない。

```mermaid
---
title: ブログサービス (5-2)
---
erDiagram
  %% 記事登録開始(E)
  article_register_start {
    varchar article_event_start_id PK
    varchar article_id
    datetime created_at
  }

  %% 記事トランザクション(E)
  article_transaction {
    varchar article_transaction_id PK
    varchar article_id FK
    varchar title
    varchar content
    varchar status
    integer version
    datetime created_at
  }

  article_register_start o|--|{ article_transaction: "has"
```
