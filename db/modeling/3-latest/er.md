### アンチパターンと初回のDB設計で微妙だったところを見直し

- usersテーブルは課題の主となるテーブルではないので最低限のものとする
- writesが依存するのはusersとdocumentsだけにさせた。当初はdirectoriesも入れてたが、documentsテーブルでdirectoryの情報をもつようにした
- ドキュメントの履歴管理には世代バージョンタグ付けパターンで表現し直す
  - すべてのバージョンをデータとして持っておいて、ポインタ/タグでどれをアクティブなものとするかをきめるパターン
- ディレクトリの構造管理は閉包テーブルで表現する
  - ancestor_idとdescendant_idには自身を含んですべての親子関係を保持させる
- ディレクトリ内の順番管理にはFractional Indexingをつかって管理する
  - document_positionsテーブルのpositionを文字列として扱い順番を入れ替えたいところだけを触れば成立させる

```mermaid
---
title: ドキュメント管理システム
---
erDiagram
    users {
        serial id PK
        varchar name
        timestamp created_at
        timestamp updated_at
    }
    writes {
        serial id PK
        int user_id FK
        int document_id FK
        timestamp created_at
    }
    
    documents {
        serial document_id PK
        int directory_id FK
        timestamp created_at
        timestamp updated_at
    }
    document_versions {
        serial id PK
        int document_id FK
        varchar title
        text content
        timestamp created_at
    }
    active_documents {
        int document_id FK
        int document_version_id FK
    }
    document_positions {
        int directory_id FK
        int document_id FK
        varchar position
    }
    directories {
        serial id PK
        varchar name
        timestamp created_at
    }
    directory_paths {
        int ancestor_id
        int descendant_id
    }
    
    users ||--o{ writes: ""
    writes }o--|| documents: ""
    documents ||--|{ document_versions: ""
    active_documents }|--|| document_versions: ""
    documents }|--|| directories: ""
    directories ||--|{ directory_paths: ""
    directory_paths }|--|| directories: ""
    documents ||--|{ document_positions: ""
    directories ||--|{ document_positions: ""

```
