# 寿司のお持ち帰り注文用のAPI

個人的に設計だけやってても気づかんことがあるので、実際にどう使われるかを確認するようにプロジェクト作った

## 使用技術

- [Hono](https://hono.dev/docs/getting-started/basic)
- [Drizzle](https://orm.drizzle.team/docs/get-started/postgresql-new)
    - [PostgreSQL column types](https://orm.drizzle.team/docs/column-types/pg)
- [Zod](https://zod.dev/)
- [PostgreSQL](https://www.postgresql.jp/document/14/html/index.html)
- [Jest](https://jestjs.io/docs/getting-started)
- [Open API](https://swagger.io/specification/)

## 起動手順

```
npm run dev
```

```
open http://localhost:3000
```

## DBスキーマ反映手順

1. db/schema/ 配下にスキーマファイルを作成する
2. `npm run drizzle:push` を実行する

Drizzle でmigrationのdownが実装されていないので、一旦すべての変更をpushする形で反映させている。  
本番とかだとやらないだろうけど、推奨の手順とかはまた調べる

### テスト実行手順

```
npx test
```

## あとでやること 
- Hono OpenAPI でドキュメント化できるようにする
    - https://tech.fusic.co.jp/posts/hono-zod-openapi/
    - https://zenn.dev/praha/articles/d1d6462a27e37e
    - https://zenn.dev/slowhand/articles/b7872e09b84e15
- testcontainersでpostgresコンテナ上げるようにする
- SeedDataをDrizzle経由で作成する
    - https://orm.drizzle.team/docs/seed-overview
- Zodの使い方確認   
    - drizzle zodも調べる
- Sushi Order用のAPI作成
- Drizzle のmigration downってまだないらしい。GitHubにIssueにはなってた
    - https://zenn.dev/toridori/articles/7ea35472f8a30c
