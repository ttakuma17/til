# 5-1

### 仕様整理

### ユーザーの状態遷移

```mermaid
stateDiagram-v2
  active_users: ユーザー
  inactive_users: 退会済みユーザー
  
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
title: ブログサービス - 論理設計
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
title: ブログサービス - 物理設計
---
erDiagram
  %% ユーザー登録開始
  user_registration_start {
    varchar id PK
    varchar user_uuid FK
    datetime created_at
  }
  %% ユーザー登録終了
  user_registration_end {
    varchar id PK
    varchar user_uuid FK
    datetime created_at
  }
  %% ユーザー(R)
  users {
    varchar id PK
    varchar user_uuid
    varchar name
    varchar email
    varchar status
    datetime created_at
  }
  %% 記事作成(E)
  create_draft {
    varchar id PK
    varchar user_uuid FK
    varchar draft_article_uuid FK
    datetime created_at
  }
  %% ドラフト記事(R)
  draft_articles {
    varchar id PK
    varchar title
    varchar content
  }
  %% 公開開始(E)
  publish_start {
    varchar id PK
    varchar draft_article_uuid FK
    varchar published_article_uuid FK
    datetime created_at
  }
  %% 記事更新(E)
  update_start {
    varchar id PK
    varchar draft_article_uuid FK
    varchar published_article_uuid FK
    datetime created_at
  }
  %% 記事更新完了(E)
  update_end {
    varchar id PK
    varchar draft_article_uuid FK
    varchar published_article_uuid FK
    datetime created_at
  }
  %% 公開終了(E)
  publish_end {
    varchar id PK
    varchar published_article_uuid FK
    varchar unpublished_article_uuid FK
    datetime created_at
  }
  %% 公開記事(R)
  published_articles {
    varchar id PK
    varchar title
    text content
  }
  %% 非公開記事(R)
  unpublished_articles {
    varchar id PK
    varchar published_article_uuid FK
    datetime created_at
  }
  %% 最新記事(R)
  latest_articles {
    varchar id PK
    varchar title
    text content
  }

  user_registration_start ||--|{ users: "creates"
  user_registration_end ||--|{ users: "creates"
  users ||--o{ create_draft: "creates"
  create_draft }|--|| draft_articles: "has"
  draft_articles ||--o{ update_start: "creates"
  draft_articles ||--o{ publish_start: "creates"
  draft_articles ||--o{ update_end: "creates"
  published_articles ||--o{ publish_end: "creates"
  update_start }o--|| published_articles: "has"
  update_end }o--|| published_articles: "has"
  publish_start }|--|| published_articles: "has"
  publish_end }|--|| unpublished_articles: "has"  
  published_articles ||--|| latest_articles: "creates"
```


### 微妙と思ってること

TODO 
- イベントをまとめるとcreated_atがresourceテーブルにほしくなってしまうの整理
- 記事のバージョン履歴一覧の対応方法を考える
- 公開記事のテーブルやっぱりidもう一個いるかも？トランザクション用のidと記事自体のidがないと、記事の更新反映がきつい
- publish_startとupdate_start, update_endが並列になっているのがなんか違和感
  - 状態遷移としては正しいけど、テーブルにしたときにどうするかを検討したい
- これらがおわったら、物理設計なので、どこにインデックスはるかとかまでを決めてからDoneにする

#### 参考


