### アンチパターンと初回のDB設計で微妙だったところを見直し

変更点
- customersに関しては会員管理する必要がないので
- orders から paidを除去して別で状態を管理する
- orders計算によって導出できる totalとtax_amountとsubtotalはカラムから除外、updated_atも発生しないので除外
- order_details の tax_rateは整数値で管理する。アプリケーション側での浮動小数点の扱いでバグる要因を減らすため。updated_atは削除。打ち消しのInsertをすればいいだけにする

```mermaid
---
title: お持ち帰りメニュー ご注文表
---
erDiagram
    customers {
        int id PK
        varchar name
        varchar tel
        timestamp created_at
        timestamp updated_at
    }
    orders {
        int id PK
        int customer_id FK
        timestamp created_at
    }
    order_totals {
        int id PK
        int order_id FK
        int subtotal
        int discount
        int tax_amount
        int total
        timestamp created_at
    }
    order_details {
        int id PK
        int unit_price
        int quantity
        int tax_rate
        int order_id FK
        int menu_id FK
        timestamp created_at
    }
    order_payment_status {
        int id PK
        int order_id FK
        timestamp created_at
    }
    menus {
        int id PK
        varchar name
        int category_id FK
        timestamp created_at
        timestamp updated_at
    }
    menu_prices {
        int id PK
        int menu_id FK
        int unit_price
        timestamp created_at
    }
    set_menus_detail {
        int id PK
        int set_menu_id FK
        int menu_id FK
        timestamp created_at
        timestamp updated_at
    }
    menu_categories {
        int id PK
        varchar name
        timestamp created_at
        timestamp updated_at
    }
    menu_available_options {
        int menu_id
        int option_type_id
    }
    option_types {
        int id PK
        varchar option_type_name
        timestamp created_at
        timestamp updated_at
    }
    option_values {
        int id PK
        int option_type_id FK
        varchar option_value
        timestamp created_at
        timestamp updated_at
    }
    order_detail_options {
        int id PK
        int order_detail_id FK
        int option_type_id FK
        int option_value_id FK
        timestamp created_at
        timestamp updated_at
    }
    campaigns {
        int id PK
        varchar name
        timestamp created_at
    }
    campaign_application {
        int id PK
        int order_id FK
        int campaign_id FK
        int applied_at
    }
    campaign_status {
        int id PK
        int campaign_id FK
        varchar status
        timestamp created_at
    }
    campaign_schedule {
        int id PK
        int campaign_id FK
        timestamp start_at
        timestamp end_at
        timestamp created_at
    }
    campaign_discounts {
        int id PK
        int campaign_id FK
        int discount_type
        int discount_amount
        timestamp created_at
    }
    
    customers ||--o{ orders: ""
    orders ||--|{ order_details: ""
    orders ||--|{ order_totals: ""
    orders ||--|{ order_payment_status: ""
    order_details ||--|| menus: ""
    order_details ||--o{ order_detail_options: ""
    menus }|--|| menu_categories: ""
    menus ||--|{ menu_prices: ""
    menus ||--|{ set_menus_detail: ""
    menus ||--o{ menu_available_options: ""
    menu_available_options }o--|| option_types: ""
    order_detail_options }o--|| option_types: ""
    order_detail_options }o--|| option_values: ""
    campaign_application }|--|| campaigns: ""
    campaigns ||--|{ campaign_status: ""
    campaigns ||--|{ campaign_schedule: ""
    campaigns ||--|{ campaign_discounts: ""
    orders ||--o{ campaign_application: ""
```