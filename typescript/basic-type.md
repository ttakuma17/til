### 型定義ええ感じにできるようにするためにまとめる

Conditional Types: 型を条件分岐して決めたいときに使う

```typescript
type MessageOf<T extends { message: unknown }> = T["message"];

interface Email {
    message: string;
}

type EmailMessageContents = MessageOf<Email>;
```

参考
- https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#conditional-type-constraints
- https://typescriptbook.jp/reference/statements/unknown

Distributive Conditional Types: Union型に対する条件はそれぞれに対して適用されて、結果もそれぞれに対して出される

```typescript
type ToArray<T> = T extends string ? T[] : never;
type StrArrOrNumArr = ToArray<string | number>; // string | never 
```

参考
- https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types
- https://typescriptbook.jp/reference/statements/never

Inferring Within Conditional Types: 型の条件分岐内部で型推論してほしいときに使う  
inferはextends と組み合わせてつかうもの

```typescript
type GetReturnType<T> = T extends (...args: never[]) => infer R ? R : never;

type Num = GetReturnType<() => number>;
type Str = GetReturnType<() => string>;
type Bools = GetReturnType<(a: boolean, b: boolean) => boolean[]>;
type Never = GetReturnType<() => "never">;
```

参考
- https://typescriptbook.jp/reference/type-reuse/infer
- https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types

KeyOf Type Operator:オブジェクトの型を受け取って、そのキーの文字列か数値のUNION型を作る

```typescript
type Point = { x: number; y: number };
type P = keyof Point; // "x" | "y"

type Arrayish = { [n: number]: unknown }
type A = keyof Arrayish; // number
```

keyofはオブジェクトの型からプロパティ名として返す型演算子

参考
- https://www.typescriptlang.org/docs/handbook/2/keyof-types.html
- https://typescriptbook.jp/reference/type-reuse/keyof-type-operator

Mapped Types: オブジェクトの型を受け取って、新しいオブジェクトの型を作る

```typescript
type OprionsFlags<T> = {
    [P in keyof T]: boolean;
}

type Features = {
    darkMode: () => void;
    newUserProfile: () => void;
}

type FetureOptions = OptionsFlags<Features>; // { darkMode: boolean; newUserProfile: boolean; }
```

基本的にUnion型と組み合わせて使うもの。Featuresのキーである darkMode と newUserProfileが keyofで取得されて、
P に取り出した値を型として定義する。

参考
- https://www.typescriptlang.org/docs/handbook/2/mapped-types.html
- https://typescriptbook.jp/reference/type-reuse/mapped-types

Indexed Access Types:  オブジェクトのプロパティの型を取得する

```typescript
type Person = {
    age: number;
    name: string;
}

// typeof オブジェクト[キー名]とすると値の型を取得できる
type Age = Person["age"]; // number

// typeof 配列[index]とすると配列の要素の型を取得できる
const arr = ["a", "b", "c"]
type A = typeof arr[0]; // string
```

参考
- https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html

Types Challenge
- https://github.com/type-challenges/type-challenges/blob/main/README.ja.md
