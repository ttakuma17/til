### 任意課題

- 凝集度(cohesion)に関して
    - 凝集度は高いほど望ましく、モジュールの明確さ、再利用性、保守性が向上します。
    - 用語の意味
        - モジュール内部の要素(関数、手続き、データなど)がどれだけ密接に関連しているかを示す指標
    - 偶発的凝集
      - モジュール内の処理が偶然まとめられているだけで、機能的な関連性がほとんどない。
      - e.g ログ出力処理、データ初期化処理、エラー処理などが1つの関数に混在しているケース
    - 論理的凝集
      - 論理的には関連するが、制御の仕方によって処理内容が変わるモジュール。フラグや条件分岐で処理が変わる
      - e.g 引数に応じて「印刷」「保存」「送信」など異なる操作を行う。
    - 時間的凝集
      - 同じタイミングで実行される処理が集められているモジュール。時間的な共通点はあるが、機能的な関連は薄い。
      - e.g プログラム起動時に行う「ログ初期化」「設定読み込み」「UI初期化」など
    - 手続き的凝集（手順的凝集）
      - 順番に実行される必要がある処理を集めたモジュール。処理の流れには関連があるが、データや目的に強い結びつきがない。
      - e.g 「入力 → 検証 → 格納」の一連の手順。
    - 通信的凝集
      - 同じデータを操作する処理を集めたモジュール。処理間でデータの共有が明確。
      - e.g 同じ構造体やデータベース行に対する複数の操作（読み出し、検証、加工）。
    - 逐次的凝集
      - ある処理の出力が次の処理の入力になるような一連の手続き。データの流れに基づく自然な処理構造。
      - e.g 「データ読込 → データ整形 → 出力」など。
    - 機能的凝集
      - モジュール内の処理が1つの明確な目的・機能を達成するために構成されている。
      - e.g 「計算結果を求める関数」「ファイルを保存する関数」など。
```typescript
// 1. 偶発的凝集の例（良くない例）
class OrderProcessor {
    processOrder(order: Order): void {
        // ログ出力
        console.log(`Processing order: ${order.id}`);
        
        // データ初期化
        const orderData = this.initializeOrderData(order);
        
        // エラー処理
        try {
            this.validateOrder(order);
        } catch (error) {
            console.error('Order validation failed:', error);
        }
        
        // 注文処理
        this.saveOrder(orderData);
    }
}

// 2. 論理的凝集の例（良くない例）
class DocumentHandler {
    handleDocument(document: Document, action: 'print' | 'save' | 'send'): void {
        switch (action) {
            case 'print':
                this.printDocument(document);
                break;
            case 'save':
                this.saveDocument(document);
                break;
            case 'send':
                this.sendDocument(document);
                break;
        }
    }
}

// 3. 時間的凝集の例（良くない例）
class ApplicationInitializer {
    initialize(): void {
        this.initializeLogger();
        this.loadConfiguration();
        this.initializeUI();
        this.setupDatabase();
    }
}

// 4. 手続き的凝集の例（やや良くない例）
class OrderValidationFlow {
    validateOrder(order: Order): void {
        this.validateInput(order);
        this.checkInventory(order);
        this.verifyPayment(order);
        this.updateStock(order);
    }
}

// 5. 通信的凝集の例（良い例）
class ProductManager {
    private product: Product;

    constructor(product: Product) {
        this.product = product;
    }

    updateStock(quantity: number): void {
        this.product.stock = quantity;
    }

    updatePrice(price: number): void {
        this.product.price = price;
    }

    updateDescription(description: string): void {
        this.product.description = description;
    }
}

// 6. 逐次的凝集の例（良い例）
class OrderProcessor {
    processOrder(order: Order): OrderResult {
        const validatedOrder = this.validateOrder(order);
        const processedOrder = this.processPayment(validatedOrder);
        return this.generateInvoice(processedOrder);
    }
}

// 7. 機能的凝集の例（最良の例）
class PriceCalculator {
    calculateTotalPrice(items: CartItem[]): number {
        return items.reduce((total, item) => {
            return total + (item.price * item.quantity);
        }, 0);
    }
} 
```

結合度(coupling)に関して
    - 結合度は低いほど望ましく、変更の影響範囲が狭まり、柔軟性や再利用性が高くなる。
    - 用語の意味
        - モジュール間の依存関係の強さを示す指標。
    - 内部結合
      - あるモジュールが他モジュールの内部に直接アクセス（例：変数や関数）する。
      - e.g 他モジュールのローカル変数や関数を直接呼び出す。
    - 共通結合
      - グローバル変数を複数モジュールで共有している状態。変更の影響が広範囲に及び、トラブルの原因になりやすい。
      - e.g 複数のモジュールが同じ設定変数やステータス変数を変更・参照。
    - 外部結合
      - モジュールが外部データ形式や外部インターフェースに依存。外部要因に変更されるとモジュールが壊れるリスク。
      - e.g 外部ファイル形式、ハードウェアI/O仕様に依存。
    - 制御結合
      - モジュールが他モジュールの処理内容を制御するフラグや引数を渡す。モジュール間の責任分担が不明瞭になる
      - e.g 引数で「mode=1なら印刷、2なら保存」といった制御を他に任せる。
    - スタンプ結合
      - モジュールが**必要な情報以上に複雑なデータ構造（レコード・構造体）**を受け渡す。インターフェースが不明瞭になり、依存性が増す。
      - e.g 巨大な構造体を引数に渡すが、実際に使うのはその一部だけ。
    - データ結合
      - モジュール間で必要なデータのみを引数で受け渡す。望ましい結合形態。インターフェースが明確。
      - e.g 関数に数値や文字列などの単純なデータを渡す。
    - メッセージ結合
      - モジュール間がメッセージ（イベントやコマンド）で疎結合に通信する。最も低い結合。モジュール独立性が高く、テストやスケーラビリティに優れる。
      - e.g オブジェクト指向やマイクロサービスでの非同期メッセージ送信。

```typescript
// 1. 内部結合の例（良くない例）
class OrderProcessor {
    private order: Order;
    
    processOrder(): void {
        // 他クラスの内部実装に直接依存
        const paymentProcessor = new PaymentProcessor();
        paymentProcessor._processPayment(this.order); // プライベートメソッドに直接アクセス
    }
}

// 2. 共通結合の例（良くない例）
// グローバルな状態管理
let globalOrderStatus: OrderStatus = 'pending';
let globalInventory: Map<string, number> = new Map();

class OrderManager {
    updateOrderStatus(): void {
        globalOrderStatus = 'processing';
    }
}

class InventoryManager {
    updateStock(): void {
        globalInventory.set('product1', 100);
    }
}

// 3. 外部結合の例（良くない例）
class FileExporter {
    exportToCSV(data: Order[]): void {
        // 外部ファイル形式に強く依存
        const csvContent = this.convertToCSVFormat(data);
        fs.writeFileSync('orders.csv', csvContent, 'utf-8');
    }
}

// 4. 制御結合の例（良くない例）
class OrderHandler {
    processOrder(order: Order, mode: 'normal' | 'express' | 'bulk'): void {
        switch (mode) {
            case 'normal':
                this.processNormalOrder(order);
                break;
            case 'express':
                this.processExpressOrder(order);
                break;
            case 'bulk':
                this.processBulkOrder(order);
                break;
        }
    }
}

// 5. スタンプ結合の例（良くない例）
class OrderProcessor {
    processOrder(order: Order): void {
        // 巨大なOrderオブジェクト全体を受け取るが、実際に使うのは一部だけ
        const orderId = order.id;
        const totalAmount = order.calculateTotal();
        // 他の多くのプロパティは使用しない
    }
}

// 6. データ結合の例（良い例）
class PriceCalculator {
    calculateTotal(price: number, quantity: number): number {
        return price * quantity;
    }
}

// 7. メッセージ結合の例（最良の例）
interface OrderEvent {
    type: 'ORDER_CREATED' | 'ORDER_PAID' | 'ORDER_SHIPPED';
    payload: any;
}

class OrderEventPublisher {
    publish(event: OrderEvent): void {
        // イベントを発行
        eventBus.publish(event);
    }
}

class OrderEventListener {
    onOrderCreated(event: OrderEvent): void {
        // イベントを処理
        if (event.type === 'ORDER_CREATED') {
            this.handleNewOrder(event.payload);
        }
    }
}
```