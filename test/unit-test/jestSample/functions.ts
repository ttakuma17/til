import {INameApiService, NameApiService} from "./nameApiService";
import { DatabaseMock } from "./util";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";

export const sumOfArray = (numbers: number[]): number => {
  return numbers.reduce((a: number, b: number): number => a + b);
};

export const asyncSumOfArray = (numbers: number[]): Promise<number> => {
  return new Promise((resolve): void => {
    resolve(sumOfArray(numbers));
  });
};

export const asyncSumOfArraySometimesZero = (
  numbers: number[],
  database: DatabaseMock
): Promise<number> => {
  return new Promise((resolve): void => {
    try {
      database.save(numbers);
      resolve(sumOfArray(numbers));
    } catch (error) {
      resolve(0);
    }
  });
};

export const getFirstNameThrowIfLong = async (
  maxNameLength: number,
  nameApiService: INameApiService
): Promise<string> => {
  const firstName = await nameApiService.getFirstName();

  if (firstName.length > maxNameLength) {
    throw new Error("first_name too long");
  }
  return firstName;
};

// 課題2-3
describe("NameApiService", () => {
  let nameApiService: NameApiService;
  let mock: MockAdapter

  beforeAll(() => {
    mock = new MockAdapter(axios);
    nameApiService = new NameApiService(axios, "https://example.com");
  });

  afterEach(() => {
    mock.reset();
  });

  test("getFirstNameで200レスポンスを返す", () => {
    mock.onGet("https://example.com").reply(200, {
      first_name: "John"
    });

    return nameApiService.getFirstName().then((data) => {
      expect(data).toBe("John");
    })
  })


  test("firstNameがMax Length以上の場合は例外を返す", () => {
    mock.onGet("https://example.com").reply(200, {
      first_name: "Johnnnnnnnnnnn"
    });

    return nameApiService.getFirstName().catch((err) => {
      expect(err.message).toBe("firstName is too long!");
    })
  })

});