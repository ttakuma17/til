### アンチパターンと初回のDB設計で微妙だったところを見直し

- doneフラグ
- idの採番を見直す。clientsとrecepintsいる？とか
- interval types はEAV

変更点
- clientとrepresentativeテーブルは不要なので削除しました


```mermaid
---
title: penpen
---
erDiagram
  %% リマインド (E)
  reminds {
    int id PK
    int slack_client_id
    int slack_representative_id
    int task_id FK
    int interval_setting_id FK
    timestamp created_at
    timestamp updated_at
  }
  %% タスク完了(E)
  task_completed {
    int reminds_id FK
    int task_id FK
    timestamp created_at
  }
  %% タスク(R)
  tasks {
    int id PK
    varchar content
    timestamp created_at
    timestamp updated_at
  }
  
  %% リマインド間隔設定(R)
  interval_types {
    int id PK
    varchar name 
    timestamp created_at
  }
  %% リマインド間隔タイプ(R)
  interval_settings { 
    int id PK
    int interval_type_id FK
    int value 
    timestamp created_at 
  }
  
  reminds }|--|| tasks: ""
  reminds }|--|| interval_settings: ""
  task_completed }|--|| tasks: ""
  task_completed }|--|| reminds: ""
  interval_settings }|--|| interval_types: ""
```