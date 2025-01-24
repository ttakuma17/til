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

OpenAPIドキュメント確認時
```
open http://localhost:3000/doc
```

## ルーティングの設定

- 以下のようにディレクトリを作成し、ファイルを配置
    - api/{path}
        - {path}Api.ts
        - {path}Schema.ts
- index.tsへ `.route('/{path}', {path}Api)` を追加

## DBスキーマ反映手順

1. db/schema/ 配下にスキーマファイルを作成する
2. `npm run drizzle:generate` を実行
3. `npm run drizzle:migrate`  を実行

### テスト実行手順
1. ***.test.tsという名前でファイルを作成
2. `npx test` を実行

設定ファイル: `jest.config.ts`


## OpenAPIドキュメントの生成

現状はindex.tsへ定義しているので、API追加時にスキーマを書いてあれば反映される

1. HonoOpenAPIインスタンスを生成する
    `const app = new OpenAPIHono();`
2. app.openapi(...) でAPIを定義
3. app.openapi(...).doc(...)で仕様書を定義
4. app.openapi(...).doc(...).get('/doc', swaggerUI({url: '/specification'})) で `/doc`にアクセスでドキュメントの確認が可能になる

参考
- https://tech.fusic.co.jp/posts/hono-zod-openapi/
- https://zenn.dev/praha/articles/d1d6462a27e37e
- https://zenn.dev/slowhand/articles/b7872e09b84e15

## あとでやること 
- Sushi Order用のAPI作成
- Zodの使い方確認
    - drizzle zodも調べる
- SeedDataをDrizzle経由で作成する
    - https://orm.drizzle.team/docs/seed-overview
- RPC使えるようにしたい。client側が必要になったときで良い
    - https://zenn.dev/yusukebe/articles/a00721f8b3b92e
    - https://zenn.dev/chot/articles/e109287414eb8c
- testcontainersでpostgresコンテナ上げるようにする
- Drizzle のmigration downってまだないらしい。どう対応するのがベストか調べる。GitHubにIssueにはなってた
    - https://zenn.dev/toridori/articles/7ea35472f8a30c

## Hono Zod Drizzle OpenAPI 

middleware > ここにはHonoのmiddlewareをカスタマイズしたファイルをいれる

- Hono
- RPC
- Zod
- pino
- Drizzle
- OpenAPI
