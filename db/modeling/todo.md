## 追々対応すること

### DBモデリング課題1
- 商品とセット商品の扱い
  - 現状はセット商品を別商品として管理しているが、セット商品の中身がわからないテーブル設計になってしまっている
- 全品に対する割引であれば orders / 個別の明細に対する割引であれば order_details に紐づけると考えていた
- キャンペーンとクーポンの扱い
  - ERDからいらないと判断したテーブルを消して、DDL、DMLが乖離したので合わせる
  - キャンペーンとクーポンを以下のように定義して、それを満たすテーブルに設計し直す
    - キャンペーンは店側が設定すれば、お客さんが言わなくても勝手に適用されるというものにする
    - クーポンはお客さんがクーポンを出したときにだけ適用されるというものにする
    - キャンペーン / クーポン はそれぞれ個別商品に対して適用できるし、会計全体に対して適用できるものとする
- 考えられる仕様を明確に定義したうえで、そのすべてをデータ層だけで対応できるテーブル設計を考える

### DBモデリング課題2
- idの扱いイケてないので、開始イベント、終了イベントをはさんでステータスを記録するとかにして、不要なIDになってしまっているのを修正
- xxxx_eventみたいなテーブルをどうにかしてわかりやすくする
- 考えられる仕様を明確に定義したうえで、そのすべてをデータ層だけで対応できるテーブル設計を考える 

### DBモデリング課題3
- Fractional Indexでやり直してみる
- DMLが閉包テーブルに見えない問題がある。意図が伝わるデータにする
- ディレクトリの削除のところで、矛盾している
- writesテーブルがほかと密結合になっているのにリソース間の関連が適切に表現されていない
