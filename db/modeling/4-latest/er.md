### アンチパターンと初回のDB設計で微妙だったところを見直し

- doneフラグ
- idの採番を見直す。clientsとrecepintsいる？とか
- interval types はEAV

変更点
- clientとrepresentativeテーブルは不要なので削除

```mermaid
---
title: penpen
---
erDiagram
  %% リマインド (E)
  reminds {
    int id PK
    boolean done
    int slack_client_id FK
    int slack_representative_id FK
    int task_id FK
    int interval_setting_id FK
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
  
  reminds }|--|| tasks: "has"
  reminds ||--|| interval_settings: "has"
  interval_settings }|--|| interval_types: "has"
```