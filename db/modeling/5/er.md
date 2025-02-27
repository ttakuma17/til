# 5-1

### 設計意図
- ユーザーとブログの状態遷移を明示したうえで、仕様を満たすようにテーブル設計しました。
- 論理設計時点では、各イベントをテーブルにしましたが、物理設計ではそれらをまとめる判断をしました。
  - 理由
    - テーブルの数が多くなってしまい、毎度JOINしないと必要な情報を取得できない
    - 状態遷移図がそのままテーブルに反映された形になっていまい、同列にならぶと違和感のあるものがあったため
      - ドラフト記事を公開開始/終了というイベントとドラフト/公開済みの記事を更新開始/更新終了するというイベントがあった

### ユーザーの状態遷移

```mermaid
stateDiagram-v2
  active_users: アクティブユーザー
  inactive_users: 非アクティブユーザー
  
  [*] --> active_users: ユーザー登録
  active_users --> inactive_users: ユーザー除外
  active_users --> inactive_users: ユーザー削除
  inactive_users --> active_users: ユーザー復帰
  inactive_users --> [*]
```

### 記事の状態遷移

```mermaid
stateDiagram-v2
  Draft: ドラフト記事
  Published: 公開記事
  Private: 非公開記事
  Latest: 最新記事

  [*] --> Draft: 記事作成
  Draft --> Published: 公開開始 (新規記事)
  Published --> Private: 公開終了
    
  Published --> Draft: 更新作業開始
  Draft --> Published: 更新完了 (再公開)
  Published --> Latest: 最新記事として同期
  Private --> [*]
```

```mermaid
---
title: ブログサービス - 論理設計細かめ
---
erDiagram
  %% ユーザー(R)
  users {}
  %% 退会済みユーザー(R)
  inactive_users {}
  %% ユーザー登録 (E)
  user_registration {}
  %% ユーザー除外 (E)
  user_exclusion {}
  %% ユーザー削除 (E)
  user_deletion {}
  %% ユーザー復帰 (E)
  user_recovery {}
  %% 記事作成(E)
  create_draft {}
  %% ドラフト記事(R)
  draft_articles {}
  %% 公開開始(E)
  publish_start {}
  %% 記事更新(E)
  update_start {}
  %% 記事更新完了(E)
  update_end {}
  %% 公開終了(E)
  publish_end {}
  %% 公開記事(R)
  published_articles {}
  %% 非公開記事(R)
  unpublished_articles {}
  %% 最新記事(R)
  latest_articles {}

  users ||--o{ create_draft: "creates"
  user_registration }|--|| users: "creates"
  users ||--o{ user_exclusion: "has"
  users ||--o{ user_deletion: "has"
  users ||--o{ user_recovery: "has"
  user_exclusion }|--|| inactive_users: "creates"
  user_deletion }|--|| inactive_users: "creates"
  user_recovery }|--|| inactive_users: "creates"
  create_draft }|--|| draft_articles: "has"
  draft_articles ||--o{ update_start: "creates"
  draft_articles ||--o{ publish_start: "creates"
  draft_articles ||--o{ update_end: "creates"
  published_articles ||--o{ publish_end: "c"
  update_start }o--|| published_articles: "has"
  update_end }o--|| published_articles: "has"
  publish_start }|--|| published_articles: "has"
  publish_end }|--|| unpublished_articles: "has"  
  published_articles ||--|| latest_articles: "creates"
```

```mermaid
---
title: ブログサービス - ERD
---
erDiagram
  %% ユーザーイベント(E)
  %% event_type: "registered/updated/deactivated/reactivated"
  user_events {
    varchar id PK
    varchar user_uuid
    varchar event_type
    datetime created_at
    integer version
  }

  %% ユーザー(R)
  %% status: "active/inactive"
  users {
      varchar id PK 
      varchar user_uuid
      varchar name
      varchar email
      varchar status
      integer version
  }

  %% 記事イベント(E)
  %% event_type: "draft_created/draft_deleted/published/unpublished/republished"
  %% user_uuid: "イベントを発生させたユーザー"
  article_events {
      varchar id PK
      varchar article_uuid
      varchar event_type
      varchar user_uuid
      integer version
      datetime created_at
  }

  %% ドラフト記事(R)
  %% status: "created/deleted"
  draft_articles {
      varchar id PK
      varchar article_uuid
      integer version
      varchar title
      varchar content
      varchar status 
  }

  %% 公開記事(R)
  %% status: "created/deleted"
  published_articles {
      varchar id PK
      varchar article_uuid 
      integer version
      varchar title
      text content
      varchar status
  }

  %% 非公開記事(R)
  %% status: "created/deleted"
  unpublished_articles {
      varchar id PK
      varchar published_article_uuid
      varchar status
  }

  users ||--o{ user_events: "creates"
  user_events ||--o{ users: "affects"
  users ||--o{ article_events: "creates"
  article_events ||--o{ draft_articles: "affects"
  article_events ||--o{ published_articles: "affects"
  article_events ||--o{ unpublished_articles: "creates" 
```

### 微妙と思ってること

#### 参考
