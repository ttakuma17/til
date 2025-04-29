import {sumOfArray, asyncSumOfArray, asyncSumOfArraySometimesZero, getFirstNameThrowIfLong} from "../functions";
import {INameApiService} from "../nameApiService";

// 課題2-1
describe("sumOfArray", () => {
  test("配列の中身を加算した結果を返せること", () => {
    expect(sumOfArray([1, 1])).toBe(2);
  });

  test("空配列の場合は例外を投げる", () => {
    expect(() => sumOfArray([])).toThrow(TypeError);
  });

  // 実装側で担保すべきなので、ここのテストは不要になるはず
  // test("配列の中身がStringの場合はビルド時の例外でテストが実行できない", () => {
  //     expect(sumOfArray(["1", "1"])).toBe(2);
  //   });
});

describe("asyncSumOfArray", () => {
    test("配列の中身を加算した結果を返せること", async () => {
        return asyncSumOfArray([1,2]).then((data) => {
            expect(data).toBe(3);
        });
    });

    test("空配列の場合は例外を投げる", async () => {
        return asyncSumOfArray([]).catch((err) => {
            expect(err).toBeInstanceOf(TypeError);
        });
    });
});

// 課題2-2
describe("asyncSumOfArraySometimesZero", () => {
  const databaseMock = {
    save: jest.fn()
  }

  test("配列の中身を加算した結果を返せること",() => {
    return asyncSumOfArraySometimesZero([1,1], databaseMock).then((data) => {
      expect(data).toBe(2);
    })
  })

  test("配列の中身を加算した結果を返せること",() => {
    return asyncSumOfArraySometimesZero([], databaseMock).catch((err) => {
      expect(err).toBeInstanceOf(TypeError);
    })
  })
});

describe("getFirstNameThrowIfLong", () => {
  const nameApiServiceMock: INameApiService= {
    getFirstName: jest.fn().mockResolvedValue("John")
  }

  test("FirstNameを返すことができる",() => {
    return getFirstNameThrowIfLong(4, nameApiServiceMock).then((data) => {
      expect(data).toBe("John");
    })
  })

  test("lengthがReturnより小さい場合にエラーを返す",() => {
    return getFirstNameThrowIfLong(1, nameApiServiceMock).catch((err) => {
      expect(err).toBeInstanceOf(Error);
      expect(err.message).toBe("first_name too long");
    })
  })
});
