## 過去のコード

- 特定のドメインクラスの中にPrivateメソッドがいくつもいくつも生えており、Couponクラスの責務がわかりにくい状態だった

```java

class Coupon {
    // フィールドやコンストラクタは省略
    public int calculateDiscount(List<CartItem> items){
        int discount;
        int limit;

        if(discountIfAmount()){
            discount = calculateDiscountByAmountitems); 
            limit = calculateLimit(items);
        } else if(discountIfRate) {
            discount = calcDiscountByRate(items)
            limit = calculateLimit(items);
        } else {
            return 0;
        }

        return Math.min(discount, limit);
    }


    private int calculateLimit(List<CartItem> items){
        // 実装省略
    }


    private int calcDiscountByAmount(List<CartItem> items){
        // 実装省略
    }

    private int calcDiscountByRate(List<CartItem> items){
        // 実装省略
    }
}


```


## リファクタリング後

- ファーストクラスコレクションをつかって、privateメソッドを使わずに責務を分割できるようになった

```

class Coupon {
    // フィールドやコンストラクタは省略
    
    public int calculateDiscount(CartItems items){
        int discount;
        int limit;

        if(info.discountIfAmount()){ // infoはCouponのフィールドのクラス
            discount = items.calculateDiscountByAmountitems(); 
            limit = items.calculateLimit(items);
        } else if(info.discountIfRate) {
            discount = items.calcDiscountByRate(items)
            limit = items.calculateLimit(items);
        } else {
            return 0;
        }

        return Math.min(discount, limit);
    }
}


class CartItems {
    List<CartItem> list;

    public CartItems(List<CartItem> list) {
        this.list = list;
    }

    public int calculateLimit(List<CartItem> items){
        // 実装省略
    }


    public int calcDiscountByAmount(List<CartItem> items){
        // 実装省略
    }

    public int calcDiscountByRate(List<CartItem> items){
        // 実装省略
    }
}
```


### 参考
-  https://www.amazon.co.jp/%E7%8F%BE%E5%A0%B4%E3%81%A7%E5%BD%B9%E7%AB%8B%E3%81%A4%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E8%A8%AD%E8%A8%88%E3%81%AE%E5%8E%9F%E5%89%87-%E5%A4%89%E6%9B%B4%E3%82%92%E6%A5%BD%E3%81%A7%E5%AE%89%E5%85%A8%E3%81%AB%E3%81%99%E3%82%8B%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E6%8C%87%E5%90%91%E3%81%AE%E5%AE%9F%E8%B7%B5%E6%8A%80%E6%B3%95-%E5%A2%97%E7%94%B0-%E4%BA%A8/dp/477419087X
