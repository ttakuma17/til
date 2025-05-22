## 課題1-1

SOLID原則の各要素を、業務経験1年目のITエンジニアに伝わるように説明してください。これらを守ることで、どのようなメリットがあるのでしょうか？

**SOLIDの原則**
- https://ja.wikipedia.org/wiki/SOLID

概要
- ソフトウェアの拡張性や保守性を高めるための守るべきガイドライン
- 各原則ごとに目的が異なる
- 対象はクラス、メソッド、モジュール、関数にも当てはまる

5つの原則
- 単一責任の原則(single-responsibility principle)
  - 目的
      - 変更の結果としてバグが発生しても、他の無関係な動作に影響を与えないように動作を分離すること
  - メリット
    - 変更の理由を1つだけにできることで、どこを変更すればやりたいことを実現できるかもすぐに分かる。バグが発生してもその範囲に限定することができる
  - 説明
    - xxは、単一の責任を持つべきだ
    - これを守れていれば「変更の理由」が1つになる

- 開放閉鎖の原則（open/closed principle）
  - 目的
    - 既存の動作を変更することなく、動作の拡張すること -> 使用されている箇所のバグが発生するのを避けるため
  - メリット
    - 変更によってバグが生まれる可能性を下げることができ、他の機能に対して影響を与えることなく新しい変更を反映できる
  - 説明
    - 拡張にはオープンで、変更にはクローズドであるべき=モジュールは、既存のコードを変更せず新しい機能を追加できるようにすべきである
      - 用語の補足
        - 拡張: 機能追加 - 拡張にはオープン = 新しいコードを追加すれば機能を追加できる
        - 変更: 既存コードの修正 - 変更にはクローズド = 既存のコードを変更せず、新しい機能を追加できる

- リスコフの置換原則（Liskov substitution principle）
  - 目的
    - 親(P)クラスやその子(C)クラスがエラーなしで同じ方法で使用できるように、一貫性を保つこと
  - メリット
    - 継承関係にあるクラスで振る舞いがかわらない一貫性によって、変更を早くできる
  - 説明
    - CがPのサブタイプである場合、プログラムないのC型のオブジェクトをP型のオブジェクトに置き換えても、そのプログラムの特性は何も変わらない
    - Childクラスは、Parentクラスと同じリクエストを処理し、同じ結果か、同様の結果を提供できなければならない。

- インターフェース分離の原則 (Interface segregation principle)
  - 目的
    - 動作のセットをより小さく分割して、クラスが必要なもののみ実行すること
  - メリット
    - インターフェースごとに使用する目的がわかれることで、変更を加えるときの影響範囲を絞れる
  - 説明
    - クライアントが使用しないメソッドへの依存を強制すべきではない
    - Interfaceにメソッドを定義しすぎて、その実装クラスでいらないものが含まれないようにする

- 依存性逆転の原則（dependency inversion principle）
  - 目的
    - インターフェースを導入することで、上位のレベルのクラスが下位のレベルのクラスに依存するのを減らすこと
  - メリット
    - クラス間が疎結合になるので、変更が容易でテストしやすい状態を担保できる
  - 説明
    - 上位のモジュールは、下位のモジュールに依存してはならない。どちらも抽象化に依存すべきだ。
    - 抽象化は詳細に依存してはならない。詳細が抽象に依存すべきだ
      - 用語の補足
        - 上位モジュール（またはクラス）: ツールを使って動作を実行するクラス
        - 下位モジュール（またはクラス）: 動作を実行するために必要なツール
        - 抽象化: 2つのクラスをつなぐインターフェイス
        - 詳細: ツールの動作方法

## 課題1-2

単一責任の原則と、単純にファイルを細かなファイルに分解することには、どのような違いがあるでしょうか？

- 違い
  - 分割を考える順番が違う
    - 単一責任の原則はあくまでも、変更の理由が1つになるように責任単位で分割することを指す
      - 責任範囲を考える→分割するという順番
    - 細かなファイルにわけることは、プロパティなど人間がわかりやすい単位で分割することになる
      - 分割すること自体が目的なので、分割→責任範囲を考えることになる
      - 細かなファイルにわけたとしても、1つの変更理由で複数ファイルを編集しないといけないようになるなら、責任が複数ファイルに分かれていることになってしまう

## 課題1-3

Open-Closed-Principleの実例を一つ考えて、作成してみてください。[TS Playground](https://www.typescriptlang.org/play)で書けるような簡単なサンプルで構いません！


```typescriptlang
class Order {
    private _productId: string;

    constructor(productId: string, cartId: string) {
        this._productId = productId;
    }

    // 支払い方法を変更するたびに、Orderクラスを変更する必要がでてくる
    public processPayment(paymentType: string): void {
        if (paymentType === "CreditCard") {
            console.log("Processing credit card payment", this._productId);
        } else if (paymentType === "PayPay") {
            console.log("Processing PayPay payment", this._productId);
        } else {
            console.error("Unsupported payment type");
        }
    }
}
```

## 課題1-4

リスコフの置換原則に違反した場合、どのような不都合が生じるでしょうか？

- 予想していないことが、発生しうるので、バグの原因になる
- 振る舞いが違うことを前提に、変更を加える必要が出てくる
  - 継承関係にあるすべての関連クラスの動作を確認しないといけなくなり、コードリーディングにも時間がかかり変更速度が遅れる

## 課題1-5

インターフェースを用いる事で、設計上どのようなメリットがあるでしょうか？

- クラス間の関係を疎結合にできる
  - 切り替えが容易になるので、機能追加や修正が早く行える
- テストもしやすいコードにできる
  - DBなどの外部リソースに依存して環境によって変わるものの動作をテストをしたい場合にも簡単にテストすることができる

## 課題1-6

どんな時に依存性の逆転を用いる必要が生じるのでしょうか？
- 外部リソース(DB、キャッシュストレージ、外部API)などを扱う処理を作る時
  - 使わない場合は、コード上で切り替えをするなど、外部リソースに分岐が増えてしまう
  - 分岐が増えることで、それに対するテストを行う必要が出てきてしまう
- 構造的に上記のようなことを行わなくてもいいように依存性の逆転を用いる

## 課題1-7

デメテルの法則について

### 課題1-7-1

デメテルの法則とは何でしょうか？業務経験1年目のITエンジニアに伝わるように説明してください。この法則を守ることで、どのようなメリットがあるのでしょうか？

**デメテルの法則**
- https://ja.wikipedia.org/wiki/%E3%83%87%E3%83%A1%E3%83%86%E3%83%AB%E3%81%AE%E6%B3%95%E5%89%87
- 別名: 最小知識の原則 (Principle of Least Knowledge)
- 基本的な考え方は、任意のオブジェクトが自分以外（サブコンポーネント含む）の構造やプロパティに対して持っている仮定を最小限にすべきであるという原則
  - user.name.first_name みたいに直接依存しているクラスのプロパティやメソッドを参照したりするのはやめようっていうもの
    - a.method はOKで、a.b.otherMethod() これはやめようっていうもの
- 簡単にいうと、不要な内部情報を外部に見せないようにしようという法則

### 課題1-7-2

デメテルの法則を新人エンジニアに伝えたところ「わかりました！こうすれば良いのですね！」と、[このようなコードを提出されました](https://www.typescriptlang.org/play?#code/MYGwhgzhAEAKCuAnYALSBTaBvAsAKGmgAdEBLANzABdMB9eCdRASQBMAuaCKsgOwHN8hEhWp0SAe1bxgVNp259BBaMAm9FMqhMQAKBk3lcepAQBpiiKVqOLT-AJTYhhV1RSkIAOnqMWraABeaAN-F1dod08fSWlZNiDLa3jWFwBffBcAeizoQAbTQC65QBgGQGUGQDEGQBCGQGMGQDMGfnQqGkQsxkamQCSGQCztQEr-QHUGGsAhBkAlBkAYhkAHBkBxhkBDhkAJhkBrhkA7BkBVm0BxJUBrBkB7BkBVBMBZ5V7APwZAbQZAZIZACIZAWwZAQH-AWAYXIngAIxBSYGh6qhC-Nl0nXBUIxANJC8SIeby+QypFQZFT3J4vLgNT6Q3SkVi-cJuME+UIJYJo9J3R7PV7vJJxOSsH7Of6uQFUYGg6K0WI2KGEGHCYkI1rktmo9E0iKEKLg1kpRIE6H4NJAA)。これだけでは特にコードの保守性に対して効果が無いことを説明してあげてください

効果がない理由
- 見かけ上はデメテルの法則を満たしているように見えるが、、、、
- プロパティ経由でのアクセスがgetter経由になっただけで、Purchaseの変更が難しくなってしまうということは変わっていない
- Purchaseクラスのうち、例えばproductIdを複数にしたいとなった場合に影響範囲が増えてしまう
- Purchaseクラスの責務が曖昧になっている
  - PurchaseというクラスがuserIdという詳細を知ってないといけないのか？というと知らなくてもいいはず
  - getter経由でPurchaseクラスの知識が外部にでてしまっている
解消方法
- tell, don't ask (尋ねるな。命じろ)
- 情報を取り出して処理するではなく、命令して処理させる

```typescriptlang
// Ask
// getterをつかって、見かけ上はデメテルの法則を満たしているように見えるけど意味ない
if (purchase.getUserId() === user.id) {
  // ロジック
}

// クラスの構造を変えたバージョン
class Purchase {
  private _userId: string;
  private _productId: string;

  constructor(userId: string, productId: string) {
    this._userId = userId;
    this._productId = productId;
  }

  public isPurchasedBy(user: User): boolean {
    return user.id === this._userId;
  }
}

// tell
if (purchase.isPurchasedBy(user)) {
  // ロジック
}
```

## まとめメモ

**Defensive Programming(防御的プログラミング)**
- 目的: 何が起こるかわからない という前提でコードを書く。外部からの誤用、攻撃、バグからアプリケーションを守る
- あらゆる入力や実行環境が想定外の動作をする可能性を考慮して、プログラムがクラッシュしたりバグを起こさないようにコードを書く手法
- 信頼できない相手に対するため、外部との接点に必須
- 例
  - 入力検証（Input Validation）
  - nullチェック | undefinedチェック
  - ガード節
  - 例外処理
  - フェールセーフ
  - ロギング
  - セキュリティ対策

**Design by Contract(契約プログラミング)**
- 目的: ソフトウェアコンポーネント間の「契約」を明示し、それに従って動作することを保証する手法
- 双方の責任を明確にし、仕様に基づいた正当な使用を前提に設計する
- 信頼できるコード間での仕様を明示するため、内部設計やテストに有効
- 用語の説明
  - 事前条件
    - 目的: 処理の前提を明示し、無効な入力や誤用を防ぐため、呼び出し元と呼び出される側の責任を明確化。
    - 関数やメソッドを呼び出す前に、呼び出し元が満たしておかなければならない条件。
  - 事後条件
    - 目的: 正しい出力と状態遷移を保証する。コードの正当性とテストしやすさを向上
    - 関数やメソッドの実行後に、呼び出された側が必ず保証すべき結果や状態。
  - 不変条件
    - 目的: モデルの一貫性を維持。実装ミスの検出と複雑な状態管理の整理。
    - オブジェクトやシステムのあらゆる操作・状態変化の中で常に保たれるべき条件。


Webアプリ開発における使い分け、外部境界(ユーザー入力、APIリクエスト、DBアクセス、外部API呼び出し)に防御的手法、内部構造(サービス/ドメインなどのビジネスロジック)に契約的手法を適用するということをベースに考える

## 参考
- [イラストで理解するSOLID原則](https://qiita.com/baby-degu/items/d058a62f145235a0f007)
- [SOLID原則完全に理解した！になるための本](https://zenn.dev/nakurei/books/solid-principle-kanzen-rikai)
- [契約プログラミング](https://ja.wikipedia.org/wiki/%E5%A5%91%E7%B4%84%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0)
- [防御的プログラミングと契約プログラミング](https://qiita.com/yoshitaro-yoyo/items/bb8cc631276380b68c13)
- [予防に勝る防御なし - 堅牢なコードを導く様々な設計のヒント](https://speakerdeck.com/twada/growing-reliable-code-phperkaigi-2022)
- [デメテルの法則を厳密に守るにはどうすればいいの？](https://qiita.com/br_branch/items/37cf71dd5865cae21401)
- [デメテルの法則とは？深堀してみた](https://zenn.dev/miya_tech/articles/b59916140347e2)
- [コード品質向上のテクニック：第55回 デメテルを知っているか](https://techblog.lycorp.co.jp/ja/20250123icq)
- [コードを複雑化させないために意識したいパターン集](https://qiita.com/TakeshiFukushima/items/0b16aef3d320a2ccb7c3)