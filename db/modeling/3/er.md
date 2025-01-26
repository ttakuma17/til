# 3-1

### 設計意図
- マスタ・トランザクション で設計
- 履歴管理はRDBの責務として、RDBで対応する
    - ユーザーおよび執筆の履歴管理に関しては、それぞれのテーブルの statusテーブルを別途作成し、その最新のレコードで状態を判定させる
    - ドキュメント自体の履歴管理はstatusではなく、document_historiesテーブルの作成日時に基づいて管理
- 課題に明記されていない想定仕様
    - ユーザーが削除されても、ドキュメントは削除はされない
    - ディレクトリを削除した場合、その中にあるドキュメントも削除する

### Event と Resource の整理

- Event
    - 執筆

- Resource
    - ユーザー
    - ドキュメント
    - ドキュメント履歴
    - ディレクトリ
    - ディレクトリパス
    - ユーザー状態
    - 執筆状態

### ERD

```mermaid
---
title: ドキュメント管理システム
---
erDiagram
    user_statuses {
        serial user_id FK
        varchar status
        timestamp created_at
    }
    users {
        serial id PK
        varchar name
        timestamp created_at
        timestamp updated_at
    }
    writes {
        serial id PK
        serial user_id FK
        serial directory_id FK 
        serial document_id FK
        timestamp created_at
        timestamp updated_at
    }
    write_statuses {
        serial write_id FK
        varchar status
        timestamp created_at
    }
    documents {
        serial id PK
        varchar title
        text content
        timestamp created_at
        timestamp updated_at
    }
    document_histories {
        serial document_id FK
        varchar title
        text content
        timestamp created_at
    }
    directories {
        serial id PK
        varchar name
        timestamp created_at
        timestamp updated_at
    }
    directory_paths {
        serial parent_id
        serial child_id
    }
    users ||--o{ writes: "creates"
    users ||--|{ user_statuses: "creates"
    writes }o--|| documents: "has"
    writes }o--|| directories: "has"
    writes ||--|{ write_statuses: "creates"
    directories ||--|{ directory_paths: "has"
    documents ||--|{ document_histories: "creates"
```

### 微妙と思ってること

- 

### 参考
- [階層構造(a.k.a ツリー構造・ディレクトリ構造・フォルダ)をDBでどう設計すべきか](https://teitei-tk.hatenablog.com/entry/2020/11/30/130000)
- [階層構造データへの挑戦](https://qiita.com/uchinami_shoichi/items/5fa52f340003107d46c1)
