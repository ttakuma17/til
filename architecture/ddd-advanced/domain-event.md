今回の課題では「ドメインイベント」については触れませんでした。

近年こうしたイベント駆動のリアクティブシステムが注目を集めています。

代表的なフレームワークは[Akka](https://akka.io/)（Scala）や[Elixir](https://elixir-lang.org/)（Erlang）です。

もし興味があればリアクティブ宣言に目を通してみたり、これらのフレームワークについて調べてみてください。

ドメインイベント
- 一連の業務活動の中で発生した出来事を特定し、表現する設計手法
- 出来事の発生は偶然ではなく、何らかの業務ルールによって制御された行動の結果

イベントの判断基準
- 過去形、タイムスタンプがつけられるか
- 確認したなどのクエリに相当する動作は基本的にはイベントではない

フレームワーク
- [Axon](https://www.axoniq.io/products/axon-framework)
    - https://docs.axoniq.io/axon-framework-reference/4.11/
    - イベント駆動で開発するときの主要なパターンがフレームワーク側でサポートされている
    - ただでさえ複雑だから、イベント駆動アーキテクチャ前提の開発やるならこういうのにのっかりたい

### 参考
- https://zenn.dev/kohii/articles/4a68e768c93573
- https://www.reactivemanifesto.org/
- https://speakerdeck.com/nrslib/guide-to-implementing-event-driven-architecture-and-common-pitfalls
- https://buildersbox.corp-sansan.com/entry/2024/02/22/180000
